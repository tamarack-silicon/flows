include ip/flows/digital-ip.mk

# Synthesis
$(NETLIST_FILE):
	mkdir -p netlist
	$(YOSYS) -m slang -p "read_slang -Weverything --top $(RTL_TOP_NAME) +define+SYNTHESIS $(RTL_FLIST_ARG); synth_$(FPGA_VENDOR) -family $(FPGA_FAMILY) -top $(RTL_TOP_NAME) -flatten -noiopad; write_verilog netlist/$(RTL_TOP_NAME).netlist.v"

.PHONY: synth
synth: $(NETLIST_FILE)
