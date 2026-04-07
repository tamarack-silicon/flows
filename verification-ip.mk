# Toolchains
VERILATOR := verilator
SLANG := slang

# Linter options: verilator, slang
LINTER := verilator

VL_COMMON_ARGS :=
SLANG_COMMON_ARGS :=

# UVM Specific Option
UVM_PKG_ARGS := +incdir+ip/uvm/src ip/uvm/src/uvm_pkg.sv
VL_UVM_ARGS := +define+UVM_NO_DPI

# Verilator lint arguments
VL_LINT_COMMON_ARGS := $(VL_COMMON_ARGS) -Wall --timing $(VL_UVM_ARGS)
VL_VIP_LINT_ARGS := $(VL_LINT_COMMON_ARGS)

SLANG_LINT_COMMON_ARGS := $(SLANG_COMMON_ARGS) -Weverything
SLANG_VIP_LINT_ARGS := $(SLANG_LINT_COMMON_ARGS)

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

VL_TESTS_SIM_ARGS := $(VL_SIM_COMMON_ARGS) --timing $(VL_UVM_ARGS) --stats

# RTL file list
VIP_FLIST_IP_ARG := $(foreach ip, $(IP_DEP), $(addprefix -F ip/, $(addsuffix /src/source.f, $(ip))))
VIP_FLIST_REPO_ARG := $(foreach ip, $(REPO_DEP), $(addprefix -F ../, $(addsuffix /src/source.f, $(ip))))

VIP_FLIST_ARG := $(VIP_FLIST_IP_ARG) $(VIP_FLIST_REPO_ARG) -F src/source.f

vip_filelist.f:
	$(dir $(lastword $(MAKEFILE_LIST)))/scripts/filelist.py $(VIP_FLIST_ARG) > vip_filelist.f

ifeq ($(LINTER), verilator)

# Lint with Verilator
.PHONY: lint-vip
lint-vip:
	$(VERILATOR) --lint-only $(VL_VIP_LINT_ARGS) lint/waiver.vlt $(UVM_PKG_ARGS) $(VIP_FLIST_ARG)

.PHONY: lint-tests
lint-tests:
	$(VERILATOR) --lint-only $(VL_VIP_LINT_ARGS) lint/waiver.vlt $(UVM_PKG_ARGS) $(VIP_FLIST_ARG) -F tests/source.f --top $(TESTS_TOP_NAME)

else ifeq ($(LINTER), slang)

# Lint with Slang
.PHONY: lint-vip
lint-vip:
	$(SLANG) $(SLANG_VIP_LINT_ARGS) $(UVM_PKG_ARGS) $(VIP_FLIST_ARG)

.PHONY: lint-tests
lint-tests:
	$(SLANG) $(SLANG_VIP_LINT_ARGS) $(UVM_PKG_ARGS) $(VIP_FLIST_ARG) -F tests/source.f --top $(TESTS_TOP_NAME)

endif

# Verification IP Unit Test
# Build simulation executable
sim/obj_dir/V$(TESTS_TOP_NAME):
	mkdir -p sim
	$(VERILATOR) --cc --exe --main $(VL_TESTS_SIM_ARGS) $(UVM_PKG_ARGS) $(VIP_FLIST_ARG) -F tests/source.f --top $(TESTS_TOP_NAME) -Mdir sim/obj_dir
	$(MAKE) -C sim/obj_dir -f V$(TESTS_TOP_NAME).mk

.PHONY: build-tests-sim
build-tests-sim: sim/obj_dir/V$(TESTS_TOP_NAME)

# Run UVM test
.PHONY: run-test
run-test: sim/obj_dir/V$(TESTS_TOP_NAME)
	mkdir -p sim/$(TEST)
	cd sim/$(TEST) ; ../obj_dir/V$(TESTS_TOP_NAME) +UVM_TESTNAME=$(TEST) $(SIM_ARGS)

# Clean
.PHONY: clean
clean:
	rm -rf sim/* *.f
