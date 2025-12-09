# Include ASIC technology-specific makefile
include ip/flows/tech/$(ASIC_TECH).mk

# Technology-specific behavioural verilog
TECH_BEHAV_VERILOG := $(STDCELL_BEHAV_VERILOG) $(SRAM_BEHAV_VERILOG)

export STDCELL_LIBERTY
export SRAM_LIBERTY
export TECH_LEF
export STDCELL_LEF
export SRAM_LEF
export RTL_TOP_NAME
export NETLIST_FILE

include ip/flows/digital-ip.mk

# Synthesis
YOSYS_READ_SRAM_LIBERTY_CMD := $(foreach lib, $(SRAM_LIBERTY), $(addprefix read_liberty -ignore_miss_func -lib , $(addsuffix ; , $(lib))))

$(NETLIST_FILE):
	mkdir -p netlist
	$(YOSYS) -m slang -p "read_liberty -ignore_miss_func -lib $(STDCELL_LIBERTY); $(YOSYS_READ_SRAM_LIBERTY_CMD) read_slang -Weverything --top $(RTL_TOP_NAME) +define+SYNTHESIS $(RTL_FLIST_ARG); synth -top $(RTL_TOP_NAME) -flatten; dfflibmap -liberty $(STDCELL_LIBERTY); abc -liberty $(STDCELL_LIBERTY); hilomap -singleton -hicell $(HI_CELL_NAME_AND_PORT) -locell $(LO_CELL_NAME_AND_PORT); clean; autoname; stat; write_verilog -nohex -nodec $(NETLIST_FILE)"

.PHONY: synth
synth: $(NETLIST_FILE)

# Zero-wire-load model static timing analysis
.PHONY: sta-zwl
sta-zwl: $(NETLIST_FILE)
	sta -no_init -exit ip/flows/opensta/opensta.tcl

# ASIC implementation (Netlist-to-GDS)
ifeq ($(GUI), 1)

.PHONY: impl
impl: $(NETLIST_FILE)
	openroad -no_init -gui ip/flows/openroad/openroad.tcl

else

.PHONY: impl
impl: $(NETLIST_FILE)
	openroad -no_init -exit ip/flows/openroad/openroad.tcl

endif


