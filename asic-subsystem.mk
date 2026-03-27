# Include ASIC technology-specific makefile
include ip/flows/tech/$(ASIC_TECH).mk

# Technology-specific behavioural verilog
TECH_BEHAV_VERILOG := $(STDCELL_BEHAV_VERILOG) $(SRAM_BEHAV_VERILOG)

include ip/flows/digital-ip.mk

export RTL_TOP_NAME
export RTL_FLIST_ARG
export STDCELL_LIBERTY
export SRAM_LIBERTY
export TECH_LEF
export STDCELL_LEF
export SRAM_LEF
export HI_CELL_NAME_AND_PORT
export LO_CELL_NAME_AND_PORT

dataout/synth/$(RTL_TOP_NAME).v:
	mkdir -p dataout/synth
	$(YOSYS) -m slang -c ip/flows/yosys/asic.tcl

.PHONY: synth
synth: dataout/synth/$(RTL_TOP_NAME).v

# Zero-wire-load model static timing analysis
.PHONY: sta-zwl
sta-zwl: dataout/synth/$(RTL_TOP_NAME).v
	sta -no_init -exit ip/flows/opensta/opensta.tcl

# ASIC implementation (Netlist-to-GDS)
ifeq ($(GUI), 1)

.PHONY: impl
impl: dataout/synth/$(RTL_TOP_NAME).v
	openroad -no_init -gui ip/flows/openroad/openroad.tcl

else

.PHONY: impl
impl: dataout/synth/$(RTL_TOP_NAME).v
	openroad -no_init -exit ip/flows/openroad/openroad.tcl

endif
