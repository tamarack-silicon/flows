set stdcell_liberty [split $::env(STDCELL_LIBERTY)]
set sram_liberty [split $::env(SRAM_LIBERTY)]

yosys -import

foreach lib $stdcell_liberty {
	puts ">> read_liberty -ignore_miss_func -lib $lib"
	read_liberty -ignore_miss_func -lib $lib
}

foreach lib $sram_liberty {
	puts ">> read_liberty -ignore_miss_func -lib $lib"
	read_liberty -ignore_miss_func -lib $lib
}

puts ">> read_slang -Weverything --top $::env(RTL_TOP_NAME) +define+SYNTHESIS $::env(RTL_FLIST_ARG)"
read_slang -Weverything --top $::env(RTL_TOP_NAME) +define+SYNTHESIS {*}$::env(RTL_FLIST_ARG)

puts ">> synth -top $::env(RTL_TOP_NAME) -flatten"
synth -top $::env(RTL_TOP_NAME) -flatten

foreach lib $stdcell_liberty {
	puts ">> dfflibmap -liberty $lib"
	dfflibmap -liberty $lib
}

foreach lib $stdcell_liberty {
	puts ">> abc -liberty $lib"
	abc -liberty $lib
}

puts ">> hilomap -singleton -hicell $::env(HI_CELL_NAME) $::env(HI_CELL_PORT) -locell $::env(LO_CELL_NAME) $::env(LO_CELL_PORT)"
hilomap -singleton -hicell $::env(HI_CELL_NAME) $::env(HI_CELL_PORT) -locell $::env(LO_CELL_NAME) $::env(LO_CELL_PORT)

puts ">> clean"
clean

puts ">> autorename"
autoname

puts ">> stat"
stat

puts ">> write_verilog -nohex -nodec dataout/synth/$::env(RTL_TOP_NAME).v"
write_verilog -nohex -nodec dataout/synth/$::env(RTL_TOP_NAME).v
