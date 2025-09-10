# Toolchains
VERILATOR := verilator
SLANG := slang
YOSYS := yosys

# Linter: verilator
LINTER := verilator

# Simulator: verilator, iverilog
SIMULATOR := verilator

# Synthesis Tool: yosys, yosys-surelog, yosys-slang
SYNTH_TOOL := yosys

VL_COMMON_ARGS :=
SLANG_COMMON_ARGS :=

# UVM Specific Option
UVM_PKG_ARGS := +incdir+ip/uvm/src ip/uvm/src/uvm_pkg.sv
VL_UVM_ARGS := -DUVM_NO_DPI ip/flows/lint-waivers/uvm.vlt

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
VL_SIM_COMMON_ARGS += --trace --trace-structs
else ifeq ($(WAVE), fst)
VL_SIM_COMMON_ARGS += --trace-fst --trace-structs
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
	$(VERILATOR) --lint-only $(VL_RTL_LINT_ARGS) $(RTL_FLIST_ARG) --top $(RTL_TOP_NAME)

.PHONY: lint-tb
lint-tb:
	$(VERILATOR) --lint-only $(VL_TB_LINT_ARGS) $(RTL_FLIST_ARG) $(TB_FILE) --top $(TB_NAME)

.PHONY: lint-verif
lint-verif:
	$(VERILATOR) --lint-only $(VL_VERIF_LINT_ARGS) $(RTL_FLIST_ARG) $(VERIF_FLIST_ARG) --top $(VERIF_TOP_NAME)

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
	$(SLANG) $(SLANG_VERIF_LINT_ARGS) $(RTL_FLIST_ARG) $(VERIF_FLIST_ARG) --top $(VERIF_TOP_NAME)

endif

# Clock domain crossing check
.PHONY: cdc
cdc:
	echo "Clock domain crossing checking not available"

# Reset domain crossing check
.PHONY: rdc
rdc:
	echo "Reset domain crossing checking not available"

# Simple SystemVerilog Testbench Simulation
# Build simulation executable
ifeq ($(SIMULATOR), verilator)
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
	cd sim/$(TEST) ; ../verif_obj_dir/V$(VERIF_TOP_NAME) +UVM_TESTNAME=$(TEST) $(SIM_ARGS)

else ifeq ($(SIMULATOR), iverilog)
sim/icarus_$(TB_NAME): rtl_filelist.f
	iverilog -g2012 -Y.sv -f rtl_filelist.f $(TB_FILE) -s $(TB_NAME) -o sim/icarus_$(TB_NAME)

.PHONY: build-tb-sim
build-tb-sim: sim/icarus_$(TB_NAME)

.PHONY: run-tb-sim
run-tb-sim: sim/icarus_$(TB_NAME)
	cd sim ; ./icarus_$(TB_NAME) $(SIM_ARGS)

endif

# Formal property verification
.PHONY: formal
formal:
	echo "SVA Formal Verification not available"

# CSR
.PHONY: csr
csr: csr-rtl csr-ral csr-doc

# Generate CSR block RTL
.PHONY: csr-rtl
csr-rtl:
	peakrdl regblock csr/$(CSR_BLOCK_NAME).rdl -o rtl/ --cpuif apb4-flat

# Generate CSR UVM RAL model
.PHONY: csr-ral
csr-ral:
	peakrdl uvm csr/$(CSR_BLOCK_NAME).rdl -o verif/$(CSR_BLOCK_NAME)_ral_pkg.sv

# Generate CSR reStructuredText Documentation
.PHONY: csr-doc
csr-doc:
	mkdir -p sim
	peakrdl html csr/$(CSR_BLOCK_NAME).rdl -o doc/

# Synthesis
ifeq ($(SYNTH_TOOL), yosys)

.PHONY: synth
synth:
	mkdir -p netlist
	yosys -p "read_verilog_file_list $(RTL_FLIST_ARG); synth -top $(RTL_TOP_NAME) -flatten; write_verilog netlist/$(RTL_TOP_NAME)_generic.netlist.v"

.PHONY: synth-asic
synth-asic:
	mkdir -p netlist
	yosys -p "read_verilog_file_list $(RTL_FLIST_ARG); read_liberty -ignore_miss_func $(LIBERTY_FILE); synth -top $(RTL_TOP_NAME) -flatten; dfflibmap -liberty $(LIBERTY_FILE); abc -liberty $(LIBERTY_FILE); clean; stat; write_verilog netlist/$(RTL_TOP_NAME)_asic.netlist.v"

.PHONY: synth-fpga
synth-fpga:
	mkdir -p netlist
	yosys -p "read_verilog_file_list $(RTL_FLIST_ARG); synth_$(FPGA_VENDOR) -top $(RTL_TOP_NAME) -flatten; write_verilog netlist/$(RTL_TOP_NAME)_fpga.netlist.v"

else ifeq ($(SYNTH_TOOL), yosys-surelog)

.PHONY: synth
synth: rtl_filelist.f
	mkdir -p netlist
	yosys -m systemverilog -p "read_systemverilog -f rtl_filelist.f; synth -top $(RTL_TOP_NAME) -flatten; write_verilog netlist/$(RTL_TOP_NAME)_generic.netlist.v"

.PHONY: synth-asic
synth-asic: rtl_filelist.f
	mkdir -p netlist
	yosys -m systemverilog -p "read_systemverilog -f rtl_filelist.f; read_liberty -ignore_miss_func $(LIBERTY_FILE); synth -top $(RTL_TOP_NAME) -flatten; dfflibmap -liberty $(LIBERTY_FILE); abc -liberty $(LIBERTY_FILE); clean; stat; write_verilog netlist/$(RTL_TOP_NAME)_asic.netlist.v"

.PHONY: synth-fpga
synth-fpga: rtl_filelist.f
	mkdir -p netlist
	yosys -m systemverilog -p "read_systemverilog -f rtl_filelist.f; synth_$(FPGA_VENDOR) -top $(RTL_TOP_NAME) -flatten; write_verilog netlist/$(RTL_TOP_NAME)_fpga.netlist.v"

else ifeq ($(SYNTH_TOOL), yosys-slang)

.PHONY: synth
synth:
	mkdir -p netlist
	yosys -m slang -p "read_slang -Weverything --top $(RTL_TOP_NAME) +define+SYNTHESIS $(RTL_FLIST_ARG); synth -top $(RTL_TOP_NAME) -flatten; write_verilog netlist/$(RTL_TOP_NAME)_generic.netlist.v"

.PHONY: synth-asic
synth-asic:
	mkdir -p netlist
	yosys -m slang -p "read_slang -Weverything --top $(RTL_TOP_NAME) +define+SYNTHESIS $(RTL_FLIST_ARG); read_liberty -ignore_miss_func $(LIBERTY_FILE); synth -top $(RTL_TOP_NAME) -flatten; dfflibmap -liberty $(LIBERTY_FILE); abc -liberty $(LIBERTY_FILE); clean; stat; write_verilog netlist/$(RTL_TOP_NAME)_asic.netlist.v"

.PHONY: synth-fpga
synth-fpga:
	mkdir -p netlist
	yosys -m slang -p "read_slang -Weverything --top $(RTL_TOP_NAME) +define+SYNTHESIS $(RTL_FLIST_ARG); synth_$(FPGA_VENDOR) -top $(RTL_TOP_NAME) -flatten; write_verilog netlist/$(RTL_TOP_NAME)_fpga.netlist.v"

endif

# Static Timing Analysis
.PHONY: sta
sta:
	echo "STA not available"

# Logic Equivalant Check
.PHONY: lec
lec:
	echo "LEC not available"

# Clean
.PHONY: clean
clean:
	rm -rf sim/* netlist/* *.f
