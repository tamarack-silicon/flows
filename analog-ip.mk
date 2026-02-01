# PDK Paths
PDK_XSCHEM_RC_FILE := $(PDK_ROOT)/$(ASIC_TECH)/libs.tech/xschem/xschemrc
PDK_MAGIC_RC_FILE := $(PDK_ROOT)/$(ASIC_TECH)/libs.tech/magic/$(ASIC_TECH).magicrc
PDK_NGSPICE_PATH := $(PDK_ROOT)/$(ASIC_TECH)/libs.tech/ngspice/
PDK_NETGEN_SETUP_FILE := $(PDK_ROOT)/$(ASIC_TECH)/libs.tech/netgen/setup.tcl

# Project File Path
SCHEM_FILE := schem/$(DESIGN).sch
SYMBOL_FILE := schem/$(DESIGN).sym
NETLIST_FILE := netlist/$(DESIGN).spice
LVS_NETLIST_FILE := netlist/$(DESIGN).lvs.spice
TB_FILE := tb/$(DESIGN)_tb.spice

export PDK_NGSPICE_PATH

# Open xschem schematic file and symbol file
.PHONY: schem
schem:
	xschem --rcfile $(PDK_XSCHEM_RC_FILE) $(SCHEM_FILE)

.PHONY: symbol
symbol:
	xschem --rcfile $(PDK_XSCHEM_RC_FILE) $(SYMBOL_FILE)

# export SPICE netlist from xschem schematic file
$(NETLIST_FILE): schem/*
	mkdir -p netlist
	xschem --rcfile $(PDK_XSCHEM_RC_FILE) --netlist --spice --no_x --quit $(SCHEM_FILE) -o netlist

$(LVS_NETLIST_FILE): schem/*
	mkdir -p netlist
	xschem --rcfile $(PDK_XSCHEM_RC_FILE) --netlist --spice --tcl "set lvs_netlist 1;" --no_x --quit $(SCHEM_FILE) -o netlist --netlist_filename "$(DESIGN).lvs.spice"

.PHONY: netlist
netlist: $(NETLIST_FILE) $(LVS_NETLIST_FILE)

# Simulation
.PHONY: sim
sim: $(NETLIST_FILE)
	ngspice $(TB_FILE)

# Open magic layout design file
.PHONY: layout
layout:
	mkdir -p layout
	cd layout; magic -rcfile $(PDK_MAGIC_RC_FILE) -d XR $(DESIGN).mag

# GDS file export
output/$(DESIGN).gds: layout/*
	mkdir -p output
	echo "gds write output/$(DESIGN).gds" | magic -rcfile $(PDK_MAGIC_RC_FILE) -dnull -noconsole layout/$(DESIGN).mag

# LEF abstract export
output/$(DESIGN).lef: layout/*
	mkdir -p output
	echo "lef write output/$(DESIGN).lef" | magic -rcfile $(PDK_MAGIC_RC_FILE) -dnull -noconsole layout/$(DESIGN).mag

# Extract netlist from layout for LVS
extracted/$(DESIGN).lvs.spice: layout/*
	mkdir -p extracted
	echo "select top cell; extract all; ext2spice lvs; ext2spice -o extracted/$(DESIGN).lvs.spice" | magic -rcfile $(PDK_MAGIC_RC_FILE) -dnull -noconsole layout/$(DESIGN).mag

# Extract netlist with parastics from layout for simulation
extracted/$(DESIGN).postlayout.spice: layout/*
	mkdir -p extracted
	echo "select top cell; extract all; ext2spice cthresh 0; ext2spice extresist on; ext2spice subcircuit off; ext2spice -o extracted/$(DESIGN).postlayout.spice" | magic -rcfile $(PDK_MAGIC_RC_FILE) -dnull -noconsole layout/$(DESIGN).mag

# Layout vs Schematic
.PHONY: lvs
lvs: $(LVS_NETLIST_FILE) extracted/$(DESIGN).lvs.spice
	netgen -batch lvs "$(LVS_NETLIST_FILE) $(DESIGN)" "extracted/$(DESIGN).lvs.spice $(DESIGN)" $(PDK_NETGEN_SETUP_FILE)

# Design Rule Check
.PHONY: drc
drc:
	echo "drc count total" | magic -rcfile $(PDK_MAGIC_RC_FILE) -dnull -noconsole layout/$(DESIGN).mag

# Generate all IP deliverables
.PHONY: deliverable
deliverable: output/$(DESIGN).gds output/$(DESIGN).lef

# Clean temporary files
.PHONY: clean
clean:
	rm -rf netlist/* output/* extracted/* layout/*.ext

# Delete all layout files
.PHONY: clean-layout
clean-layout: clean
	rm -rf layout/*
