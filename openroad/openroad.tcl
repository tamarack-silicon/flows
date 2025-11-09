set tech_lef [split $::env(TECH_LEF)]
foreach lef $tech_lef {
	puts ">> read_lef $lef"
	read_lef $lef
}

set stdcell_lef [split $::env(STDCELL_LEF)]
foreach lef $stdcell_lef {
	puts ">> read_lef $lef"
	read_lef $lef
}

set sram_lef [split $::env(SRAM_LEF)]
foreach lef $sram_lef {
	puts ">> read_lef $lef"
	read_lef $lef
}

set stdcell_liberty [split $::env(STDCELL_LIBERTY)]
foreach lib $stdcell_liberty {
	puts ">> read_liberty $lib"
	read_liberty $lib
}

set sram_liberty [split $::env(SRAM_LIBERTY)]
foreach lib $sram_liberty {
	puts ">> read_liberty $lib"
	read_liberty $lib
}

puts ">> read_verilog $::env(NETLIST_FILE)"
read_verilog $::env(NETLIST_FILE)

puts ">> link_design $::env(RTL_TOP_NAME)"
link_design $::env(RTL_TOP_NAME)

puts ">> read_sdc synth/$::env(RTL_TOP_NAME).sdc"
read_sdc synth/$::env(RTL_TOP_NAME).sdc
