STDCELL_CORNER := tt_025C_1v80
SRAM_CORNER := tt_025C_1v80

STDCELL_BEHAV_VERILOG := \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_sc_mcu9t5v0/verilog/primitives.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_sc_mcu9t5v0/verilog/gf180mcu_fd_sc_mcu9t5v0.v

SRAM_BEHAV_VERILOG := \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_ip_sram/verilog/gf180mcu_fd_ip_sram__sram64x8m8wm1.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_ip_sram/verilog/gf180mcu_fd_ip_sram__sram128x8m8wm1.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_ip_sram/verilog/gf180mcu_fd_ip_sram__sram256x8m8wm1.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_ip_sram/verilog/gf180mcu_fd_ip_sram__sram512x8m8wm1.v

STDCELL_LIBERTY := $(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_sc_mcu9t5v0/lib/gf180mcu_fd_sc_mcu9t5v0__$(STDCELL_CORNER).lib

SRAM_LIBERTY := \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_ip_sram/lib/gf180mcu_fd_ip_sram__sram64x8m8wm1__$(SRAM_CORNER).lib \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_ip_sram/lib/gf180mcu_fd_ip_sram__sram128x8m8wm1__$(SRAM_CORNER).lib \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_ip_sram/lib/gf180mcu_fd_ip_sram__sram256x8m8wm1__$(SRAM_CORNER).lib \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_ip_sram/lib/gf180mcu_fd_ip_sram__sram512x8m8wm1__$(SRAM_CORNER).lib

TECH_LEF := $(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_sc_mcu9t5v0/techlef/gf180mcu_fd_sc_mcu9t5v0__nom.tlef

STDCELL_LEF := $(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_sc_mcu9t5v0/lef/gf180mcu_fd_sc_mcu9t5v0.lef

SRAM_LEF := \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_ip_sram/lef/gf180mcu_fd_ip_sram__sram64x8m8wm1.lef \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_ip_sram/lef/gf180mcu_fd_ip_sram__sram128x8m8wm1.lef \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_ip_sram/lef/gf180mcu_fd_ip_sram__sram256x8m8wm1.lef \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/gf180mcu_fd_ip_sram/lef/gf180mcu_fd_ip_sram__sram512x8m8wm1.lef

HI_CELL_NAME := gf180mcu_fd_sc_mcu9t5v0__tieh
HI_CELL_PORT := Z
LO_CELL_NAME := gf180mcu_fd_sc_mcu9t5v0__tiel
LO_CELL_PORT := ZN
SITE_NAME := GF018hv5v_green_sc9
PDN_GRID_PIN_LAYERS := Metal5
PDN_LOCAL_STRIPE_LAYER := Metal1
PDN_LOCAL_STRIPE_WIDTH := 0.900
PDN_LOCAL_STRIPE_PITCH := 5.040
PDN_LOCAL_STRIPE_OFFSET := 0.0
PDN_GLOBAL_VER_STRIPE_LAYER := Metal4
PDN_GLOBAL_HOR_STRIPE_LAYER := Metal5
PDN_GLOBAL_STRIPE_WIDTH := 4.480
PDN_GLOBAL_STRIPE_PITCH := 89.6
PDN_GLOBAL_STRIPE_OFFSET := 22.4
PDN_CONNECT1 := Metal1 Metal4
PDN_CONNECT2 := Metal4 Metal5
SIGNAL_ROUTING_LAYERS := Metal2-Metal5
CLOCK_ROUTING_LAYERS := Metal2-Metal5
PINS_HOR_LAYERS := Metal3
PINS_VER_LAYERS := Metal4
