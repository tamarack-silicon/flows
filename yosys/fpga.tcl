yosys -import

puts ">> read_slang -Weverything --top $::env(RTL_TOP_NAME) +define+SYNTHESIS $::env(RTL_FLIST_ARG)"
read_slang -Weverything --top $::env(RTL_TOP_NAME) +define+SYNTHESIS {*}$::env(RTL_FLIST_ARG)

if {$::env(FPGA_VENDOR) eq "xilinx"} {
	if {$::env(FPGA_TOP_LEVEL) eq "1"} {
		puts ">> synth_xilinx -family $::env(FPGA_FAMILY) -top $::env(RTL_TOP_NAME) -flatten"
		synth_xilinx -family $::env(FPGA_FAMILY) -top $::env(RTL_TOP_NAME) -flatten
	} else {
		puts ">> synth_xilinx -family $::env(FPGA_FAMILY) -top $::env(RTL_TOP_NAME) -flatten -noiopad"
		synth_xilinx -family $::env(FPGA_FAMILY) -top $::env(RTL_TOP_NAME) -flatten -noiopad
	}
}

puts ">> clean"
clean

puts ">> autorename"
autoname

puts ">> stat"
stat

puts ">> write_verilog -nohex -nodec dataout/synth/$::env(RTL_TOP_NAME).v"
write_verilog -nohex -nodec dataout/synth/$::env(RTL_TOP_NAME).v
