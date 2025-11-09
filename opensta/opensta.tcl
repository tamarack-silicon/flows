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

puts ">> report_checks"
report_checks
