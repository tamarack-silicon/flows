# Toolchains
VERILATOR := verilator
SLANG := slang
YOSYS := yosys
PEAKRDL := peakrdl

# Linter options: verilator, slang
LINTER := verilator

# Simulator options: verilator
SIMULATOR := verilator

# Synthesis Tool options: yosys, yosys-surelog, yosys-slang
SYNTH_TOOL := yosys

VL_COMMON_ARGS :=
SLANG_COMMON_ARGS :=

# UVM Specific Option
UVM_PKG_ARGS := +incdir+ip/uvm/src ip/uvm/src/uvm_pkg.sv
VL_UVM_ARGS := +define+UVM_NO_DPI

# Verilator lint arguments
VL_LINT_COMMON_ARGS := $(VL_COMMON_ARGS) -Wall
VL_RTL_LINT_ARGS := $(VL_LINT_COMMON_ARGS) --no-timing
VL_TB_LINT_ARGS := $(VL_LINT_COMMON_ARGS) --timing
VL_VERIF_LINT_ARGS := $(VL_LINT_COMMON_ARGS) --timing $(VL_UVM_ARGS)

SLANG_LINT_COMMON_ARGS := $(SLANG_COMMON_ARGS) -Weverything
SLANG_RTL_LINT_ARGS := $(SLANG_LINT_COMMON_ARGS)
SLANG_TB_LINT_ARGS := $(SLANG_LINT_COMMON_ARGS)
SLANG_VERIF_LINT_ARGS := $(SLANG_LINT_COMMON_ARGS)

# Verilator simulation arguments
VL_SIM_COMMON_ARGS := $(VL_COMMON_ARGS) -Wno-fatal
ifeq ($(WAVE), vcd)
VL_SIM_COMMON_ARGS += --trace-vcd --trace-structs
else ifeq ($(WAVE), fst)
VL_SIM_COMMON_ARGS += --trace-fst --trace-structs
else ifeq ($(WAVE), saif)
VL_SIM_COMMON_ARGS += --trace-saif --trace-structs
endif
ifeq ($(ASSERT), 0)
VL_SIM_COMMON_ARGS += --no-assert
endif
ifeq ($(COVERAGE), 1)
VL_SIM_COMMON_ARGS += --coverage
endif

VL_TB_SIM_ARGS := $(VL_SIM_COMMON_ARGS) --timing --stats
VL_VERIF_SIM_ARGS := $(VL_SIM_COMMON_ARGS) --timing $(VL_UVM_ARGS) --stats

# RTL file list
RTL_FLIST_IP_ARG := $(foreach ip, $(RTL_IP_DEP), $(addprefix -F ip/, $(addsuffix /rtl/source.f, $(ip))))
RTL_FLIST_REPO_ARG := $(foreach ip, $(RTL_REPO_DEP), $(addprefix -F ../, $(addsuffix /rtl/source.f, $(ip))))

RTL_FLIST_ARG := $(RTL_FLIST_IP_ARG) $(RTL_FLIST_REPO_ARG) -F rtl/source.f

# Verification file list
VERIF_FLIST_IP_ARG := $(foreach ip, $(VERIF_IP_DEP), $(addprefix -F ip/, $(addsuffix /verif/source.f, $(ip))))
VERIF_FLIST_REPO_ARG := $(foreach ip, $(VERIF_REPO_DEP), $(addprefix -F ../, $(addsuffix /verif/source.f, $(ip))))

VERIF_FLIST_ARG := $(VERIF_FLIST_IP_ARG) $(VERIF_FLIST_REPO_ARG) -F verif/source.f

# Testbench file
TB_FILE := tb/$(TB_NAME).sv

rtl_filelist.f:
	$(dir $(lastword $(MAKEFILE_LIST)))/scripts/filelist.py $(RTL_FLIST_ARG) > rtl_filelist.f

verif_filelist.f:
	$(dir $(lastword $(MAKEFILE_LIST)))/scripts/filelist.py $(VERIF_FLIST_ARG) > verif_filelist.f

ifeq ($(LINTER), verilator)

# Lint with Verilator
.PHONY: lint-rtl
lint-rtl:
	$(VERILATOR) --lint-only $(VL_RTL_LINT_ARGS) lint/waiver.vlt $(RTL_FLIST_ARG) --top $(RTL_TOP_NAME)

.PHONY: lint-tb
lint-tb:
	$(VERILATOR) --lint-only $(VL_TB_LINT_ARGS) lint/waiver.vlt $(RTL_FLIST_ARG) $(TB_FILE) --top $(TB_NAME)

.PHONY: lint-verif
lint-verif:
	$(VERILATOR) --lint-only $(VL_VERIF_LINT_ARGS) lint/waiver.vlt $(UVM_PKG_ARGS) $(RTL_FLIST_ARG) $(VERIF_FLIST_ARG) --top $(VERIF_TOP_NAME)

else ifeq ($(LINTER), slang)

# Lint with Slang
.PHONY: lint-rtl
lint-rtl:
	$(SLANG) $(SLANG_RTL_LINT_ARGS) $(RTL_FLIST_ARG) --top $(RTL_TOP_NAME)

.PHONY: lint-tb
lint-tb:
	$(SLANG) $(SLANG_TB_LINT_ARGS) $(RTL_FLIST_ARG) $(TB_FILE) --top $(TB_NAME)

.PHONY: lint-verif
lint-verif:
	$(SLANG) $(SLANG_VERIF_LINT_ARGS) $(UVM_PKG_ARGS) $(RTL_FLIST_ARG) $(VERIF_FLIST_ARG) --top $(VERIF_TOP_NAME)

endif

# Clock domain crossing check
.PHONY: cdc
cdc:
	echo "Clock domain crossing checking not available"

# Reset domain crossing check
.PHONY: rdc
rdc:
	echo "Reset domain crossing checking not available"

ifeq ($(SIMULATOR), verilator)

# Simple SystemVerilog Testbench Simulation
# Build simulation executable
sim/$(TB_NAME)_obj_dir/V$(TB_NAME):
	mkdir -p sim
	$(VERILATOR) --cc --exe --main $(VL_TB_SIM_ARGS) --top $(TB_NAME) $(RTL_FLIST_ARG) $(TB_FILE) -Mdir sim/$(TB_NAME)_obj_dir
	$(MAKE) -C sim/$(TB_NAME)_obj_dir -f V$(TB_NAME).mk

.PHONY: build-tb-sim
build-tb-sim: sim/$(TB_NAME)_obj_dir/V$(TB_NAME)

.PHONY: run-tb-sim
run-tb-sim: sim/$(TB_NAME)_obj_dir/V$(TB_NAME)
	cd sim ; ./$(TB_NAME)_obj_dir/V$(TB_NAME) $(SIM_ARGS)

# UVM Verification Testbench Simulation
# Build simulation executable
sim/verif_obj_dir/V$(VERIF_TOP_NAME):
	mkdir -p sim
	$(VERILATOR) --cc --exe --main $(VL_VERIF_SIM_ARGS) --top $(VERIF_TOP_NAME) $(UVM_PKG_ARGS) $(RTL_FLIST_ARG) $(VERIF_FLIST_ARG) -Mdir sim/verif_obj_dir
	$(MAKE) -C sim/verif_obj_dir -f V$(VERIF_TOP_NAME).mk

.PHONY: build-verif-sim
build-verif-sim: sim/verif_obj_dir/V$(VERIF_TOP_NAME)

# Run simulation
.PHONY: run-verif-sim
run-verif-sim: sim/verif_obj_dir/V$(VERIF_TOP_NAME)
	cd sim ; ./verif_obj_dir/V$(VERIF_TOP_NAME) $(SIM_ARGS)

# Run UVM test
.PHONY: run-test
run-test: sim/verif_obj_dir/V$(VERIF_TOP_NAME)
	mkdir -p sim/$(TEST)
	cd sim ; ./verif_obj_dir/V$(VERIF_TOP_NAME) +UVM_TESTNAME=$(TEST) $(SIM_ARGS)

endif

# Formal property verification
.PHONY: formal
formal:
	echo "SVA Formal Verification not available"

# CSR
.PHONY: csr
csr: csr-rtl csr-ral csr-ipxact csr-c-header

# Generate CSR block RTL
.PHONY: csr-rtl
csr-rtl:
	$(PEAKRDL) regblock csr/$(CSR_BLOCK_NAME).rdl -o rtl/ --cpuif apb4-flat --peakrdl-cfg ip/flows/peakrdl/peakrdl.toml

# Generate CSR UVM RAL model
.PHONY: csr-ral
csr-ral:
	$(PEAKRDL) uvm csr/$(CSR_BLOCK_NAME).rdl -o verif/$(CSR_BLOCK_NAME)_ral_pkg.sv --peakrdl-cfg ip/flows/peakrdl/peakrdl.toml

# Generate CSR IP-XACT file
.PHONY: csr-ipxact
csr-ipxact:
	mkdir -p deliverable
	$(PEAKRDL) ip-xact csr/$(CSR_BLOCK_NAME).rdl -o deliverable/$(CSR_BLOCK_NAME).xml --peakrdl-cfg ip/flows/peakrdl/peakrdl.toml

# Generate CSR C header file
.PHONY: csr-c-header
csr-c-header:
	mkdir -p deliverable
	$(PEAKRDL) c-header csr/$(CSR_BLOCK_NAME).rdl -o deliverable/$(CSR_BLOCK_NAME).h --peakrdl-cfg ip/flows/peakrdl/peakrdl.toml

# Synthesis
ifeq ($(SYNTH_TOOL), yosys)

.PHONY: synth
synth:
	mkdir -p netlist
	$(YOSYS) -p "read_verilog_file_list $(RTL_FLIST_ARG); synth_$(FPGA_VENDOR) -family $(FPGA_FAMILY) -top $(RTL_TOP_NAME) -flatten -noiopad; write_verilog netlist/$(RTL_TOP_NAME).netlist.v"

else ifeq ($(SYNTH_TOOL), yosys-surelog)

.PHONY: synth
synth: rtl_filelist.f
	mkdir -p netlist
	$(YOSYS) -m systemverilog -p "read_systemverilog -f rtl_filelist.f; synth_$(FPGA_VENDOR) -family $(FPGA_FAMILY) -top $(RTL_TOP_NAME) -flatten -noiopad; write_verilog netlist/$(RTL_TOP_NAME).netlist.v"

else ifeq ($(SYNTH_TOOL), yosys-slang)

.PHONY: synth
synth:
	mkdir -p netlist
	$(YOSYS) -m slang -p "read_slang -Weverything --top $(RTL_TOP_NAME) +define+SYNTHESIS $(RTL_FLIST_ARG); synth_$(FPGA_VENDOR) -family $(FPGA_FAMILY) -top $(RTL_TOP_NAME) -flatten -noiopad; write_verilog netlist/$(RTL_TOP_NAME).netlist.v"

endif

# Micro-Architecture Specification documentation
deliverable/micro-architecture-specification.pdf:
	$(MAKE) -C doc/micro_architecture_specification latexpdf
	cp doc/micro_architecture_specification/_build/latex/*.pdf deliverable/micro-architecture-specification.pdf

# Generate IP deliverables
.PHONY: deliverable
deliverable: csr-ipxact csr-c-header deliverable/micro-architecture-specification.pdf

# Clean
.PHONY: clean
clean:
	$(MAKE) -C doc/micro_architecture_specification clean
	rm -rf sim/* netlist/* deliverable/* *.f abc.history
