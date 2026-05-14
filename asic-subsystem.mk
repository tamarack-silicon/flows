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
export HI_CELL_NAME
export HI_CELL_PORT
export LO_CELL_NAME
export LO_CELL_PORT
export SITE_NAME
export PDN_GRID_PIN_LAYERS
export PDN_LOCAL_STRIPE_LAYER
export PDN_LOCAL_STRIPE_WIDTH
export PDN_LOCAL_STRIPE_PITCH
export PDN_LOCAL_STRIPE_OFFSET
export PDN_GLOBAL_VER_STRIPE_LAYER
export PDN_GLOBAL_HOR_STRIPE_LAYER
export PDN_GLOBAL_STRIPE_WIDTH
export PDN_GLOBAL_STRIPE_PITCH
export PDN_GLOBAL_STRIPE_OFFSET
export PDN_CONNECT1
export PDN_CONNECT2
export SIGNAL_ROUTING_LAYERS
export CLOCK_ROUTING_LAYERS
export PINS_HOR_LAYERS
export PINS_VER_LAYERS

dataout/synth/$(RTL_TOP_NAME).v:
	mkdir -p dataout/synth
	$(YOSYS) -m slang -c ip/flows/yosys/asic.tcl -t -l dataout/synth/synth.log

.PHONY: synth
synth: dataout/synth/$(RTL_TOP_NAME).v

# Zero-wire-load model static timing analysis
.PHONY: sta-zwl
sta-zwl: dataout/synth/$(RTL_TOP_NAME).v
	sta -no_init -exit ip/flows/opensta/opensta.tcl

# ASIC implementation (Netlist-to-GDS)
dataout/postroute/$(RTL_TOP_NAME).def: dataout/synth/$(RTL_TOP_NAME).v
	mkdir -p dataout/postroute
	openroad -no_init -exit ip/flows/openroad/openroad.tcl -log dataout/postroute/placeroute.log
