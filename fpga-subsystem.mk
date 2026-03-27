# Technology-specific behavioural verilog
TECH_BEHAV_VERILOG := +incdir+$(shell yosys-config --datdir)/$(FPGA_VENDOR) $(shell yosys-config --datdir)/$(FPGA_VENDOR)/cells_sim.v

include ip/flows/digital-ip.mk

export RTL_TOP_NAME
export RTL_FLIST_ARG
export FPGA_VENDOR
export FPGA_FAMILY
export FPGA_PART
export FPGA_TOP_LEVEL

# Synthesis
dataout/synth/$(RTL_TOP_NAME).v:
	mkdir -p dataout/synth
	$(YOSYS) -m slang -c ip/flows/yosys/fpga.tcl

.PHONY: synth
synth: dataout/synth/$(RTL_TOP_NAME).v
