set stdcell_liberty [split $::env(STDCELL_LIBERTY)]
set sram_liberty [split $::env(SRAM_LIBERTY)]

foreach lib $stdcell_liberty {
	puts ">> read_liberty $lib"
	read_liberty $lib
}

foreach lib $sram_liberty {
	puts ">> read_liberty $lib"
	read_liberty $lib
}

puts ">> read_verilog dataout/synth/$::env(RTL_TOP_NAME).v"
read_verilog dataout/synth/$::env(RTL_TOP_NAME).v

puts ">> link_design $::env(RTL_TOP_NAME)"
link_design $::env(RTL_TOP_NAME)

puts ">> read_sdc synth/$::env(RTL_TOP_NAME).sdc"
read_sdc synth/$::env(RTL_TOP_NAME).sdc

puts ">> report_checks"
report_checks
