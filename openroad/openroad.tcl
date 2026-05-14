set stdcell_liberty [split $::env(STDCELL_LIBERTY)]
set sram_liberty [split $::env(SRAM_LIBERTY)]
set tech_lef [split $::env(TECH_LEF)]
set stdcell_lef [split $::env(STDCELL_LEF)]
set sram_lef [split $::env(SRAM_LEF)]

###
# Flow Initialization
###

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

puts ">> read_upf -file synth/$::env(RTL_TOP_NAME).upf"
read_upf -file synth/$::env(RTL_TOP_NAME).upf

###
# Floorplan
###

puts ">> initialize_floorplan -utilization 70 -aspect_ratio 1.0 -core_space 0.0 -site $::env(SITE_NAME)"
initialize_floorplan -utilization 70 -aspect_ratio 1.0 -core_space 0.0 -site $::env(SITE_NAME)

puts ">> insert_tiecells $::env(HI_CELL_NAME)/$::env(HI_CELL_PORT) -prefix \"TIE_ONE_\""
insert_tiecells $::env(HI_CELL_NAME)/$::env(HI_CELL_PORT) -prefix "TIE_ONE_"

puts ">> insert_tiecells $::env(LO_CELL_NAME)/$::env(LO_CELL_PORT) -prefix \"TIE_ZERO_\""
insert_tiecells $::env(LO_CELL_NAME)/$::env(LO_CELL_PORT) -prefix "TIE_ZERO_"

puts ">> make_tracks"
make_tracks

###
# Macro Placement
###

###
# Power distribution network
###

puts ">> add_global_connection -net VDD -pin_pattern {^VDD$} -power"
add_global_connection -net VDD -pin_pattern {^VDD$} -power

puts ">> add_global_connection -net VSS -pin_pattern {^VSS$} -ground"
add_global_connection -net VSS -pin_pattern {^VSS$} -ground

puts ">> global_connect"
global_connect

puts ">> set_voltage_domain -name Core -power VDD -ground VSS"
set_voltage_domain -name Core -power VDD -ground VSS

puts ">> define_pdn_grid -name core_grid -voltage_domains Core -pins {$::env(PDN_GRID_PIN_LAYERS)}"
define_pdn_grid -name core_grid -voltage_domains Core -pins $::env(PDN_GRID_PIN_LAYERS)

puts ">> add_pdn_stripe -grid core_grid -layer $::env(PDN_LOCAL_STRIPE_LAYER) -width $::env(PDN_LOCAL_STRIPE_WIDTH) -pitch $::env(PDN_LOCAL_STRIPE_PITCH) -offset $::env(PDN_LOCAL_STRIPE_OFFSET) -followpins"
add_pdn_stripe -grid core_grid -layer $::env(PDN_LOCAL_STRIPE_LAYER) -width $::env(PDN_LOCAL_STRIPE_WIDTH) -pitch $::env(PDN_LOCAL_STRIPE_PITCH) -offset $::env(PDN_LOCAL_STRIPE_OFFSET) -followpins

puts ">> add_pdn_stripe -grid core_grid -layer $::env(PDN_GLOBAL_VER_STRIPE_LAYER) -width $::env(PDN_GLOBAL_STRIPE_WIDTH) -pitch $::env(PDN_GLOBAL_STRIPE_PITCH) -offset $::env(PDN_GLOBAL_STRIPE_OFFSET)"
add_pdn_stripe -grid core_grid -layer $::env(PDN_GLOBAL_VER_STRIPE_LAYER) -width $::env(PDN_GLOBAL_STRIPE_WIDTH) -pitch $::env(PDN_GLOBAL_STRIPE_PITCH) -offset $::env(PDN_GLOBAL_STRIPE_OFFSET)

puts ">> add_pdn_stripe -grid core_grid -layer $::env(PDN_GLOBAL_HOR_STRIPE_LAYER) -width $::env(PDN_GLOBAL_STRIPE_WIDTH) -pitch $::env(PDN_GLOBAL_STRIPE_PITCH) -offset $::env(PDN_GLOBAL_STRIPE_OFFSET)"
add_pdn_stripe -grid core_grid -layer $::env(PDN_GLOBAL_HOR_STRIPE_LAYER) -width $::env(PDN_GLOBAL_STRIPE_WIDTH) -pitch $::env(PDN_GLOBAL_STRIPE_PITCH) -offset $::env(PDN_GLOBAL_STRIPE_OFFSET)

puts ">> add_pdn_connect -grid core_grid -layers {$::env(PDN_CONNECT1)}"
add_pdn_connect -grid core_grid -layers $::env(PDN_CONNECT1)

puts ">> add_pdn_connect -grid core_grid -layers {$::env(PDN_CONNECT2)}"
add_pdn_connect -grid core_grid -layers $::env(PDN_CONNECT2)

puts ">> pdngen"
pdngen

###
# Placement
###

puts ">> set_routing_layers -signal $::env(SIGNAL_ROUTING_LAYERS) -clock $::env(CLOCK_ROUTING_LAYERS)"
set_routing_layers -signal $::env(SIGNAL_ROUTING_LAYERS) -clock $::env(CLOCK_ROUTING_LAYERS)

puts ">> place_pins -hor_layers $::env(PINS_HOR_LAYERS) -ver_layers $::env(PINS_VER_LAYERS)"
place_pins -hor_layers $::env(PINS_HOR_LAYERS) -ver_layers $::env(PINS_VER_LAYERS)

puts ">> global_placement -density 0.7"
global_placement -density 0.7

###
# Clock tree synthesis
###

puts ">> clock_tree_synthesis"
clock_tree_synthesis

puts ">> repair_clock_nets"
repair_clock_nets

puts ">> detailed_placement"
detailed_placement

###
# Routing
###

puts ">> global_route"
global_route

puts ">> detailed_route"
detailed_route

###
# Chip finish
###

puts ">> check_antennas -report_file dataout/postroute/antennas.rpt"
check_antennas -report_file dataout/postroute/antennas.rpt

puts ">> report_checks -format full_clock_expanded -endpoint_count 100 > dataout/postroute/timing.rpt"
report_checks -format full_clock_expanded -endpoint_count 100 > dataout/postroute/timing.rpt

puts ">> report_power > dataout/postroute/power.rpt"
report_power > dataout/postroute/power.rpt

puts ">> report_floating_nets > dataout/postroute/floating_nets.rpt"
report_floating_nets > dataout/postroute/floating_nets.rpt

puts ">> report_design_area"
report_design_area

puts ">> write_db dataout/postroute/$::env(RTL_TOP_NAME).odb"
write_db dataout/postroute/$::env(RTL_TOP_NAME).odb

puts ">> write_abstract_lef dataout/postroute/$::env(RTL_TOP_NAME).lef"
write_abstract_lef dataout/postroute/$::env(RTL_TOP_NAME).lef

puts ">> write_def dataout/postroute/$::env(RTL_TOP_NAME).def"
write_def dataout/postroute/$::env(RTL_TOP_NAME).def

puts ">> write_verilog dataout/postroute/$::env(RTL_TOP_NAME).v"
write_verilog dataout/postroute/$::env(RTL_TOP_NAME).v

