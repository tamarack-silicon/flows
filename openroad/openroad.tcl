set stdcell_liberty [split $::env(STDCELL_LIBERTY)]
set sram_liberty [split $::env(SRAM_LIBERTY)]
set tech_lef [split $::env(TECH_LEF)]
set stdcell_lef [split $::env(STDCELL_LEF)]
set sram_lef [split $::env(SRAM_LEF)]

foreach lef $tech_lef {
	puts ">> read_lef $lef"
	read_lef $lef
}

foreach lef $stdcell_lef {
	puts ">> read_lef $lef"
	read_lef $lef
}

foreach lef $sram_lef {
	puts ">> read_lef $lef"
	read_lef $lef
}

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
