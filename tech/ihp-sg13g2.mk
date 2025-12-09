STDCELL_CORNER := typ_1p20V_25C
SRAM_CORNER := typ_1p20V_25C

STDCELL_BEHAV_VERILOG := $(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_stdcell/verilog/sg13g2_stdcell.v

SRAM_BEHAV_VERILOG := \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_1024x16_c2_bm_bist.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_1024x64_c2_bm_bist.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_1024x8_c2_bm_bist.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_2048x64_c2_bm_bist.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_256x48_c2_bm_bist.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_256x64_c2_bm_bist.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_4096x16_c3_bm_bist.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_4096x8_c3_bm_bist.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_512x32_c2_bm_bist.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_512x64_c2_bm_bist.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_64x64_c2_bm_bist.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_core_behavioral_bm_bist.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_2P_64x32_c2.v \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_2P_core_behavioral_ideal.v

STDCELL_LIBERTY := $(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_$(STDCELL_CORNER).lib

SRAM_LIBERTY := \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_1024x16_c2_bm_bist_$(SRAM_CORNER).lib \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_1024x64_c2_bm_bist_$(SRAM_CORNER).lib \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_1024x8_c2_bm_bist_$(SRAM_CORNER).lib \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_2048x64_c2_bm_bist_$(SRAM_CORNER).lib \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_256x48_c2_bm_bist_$(SRAM_CORNER).lib \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_256x64_c2_bm_bist_$(SRAM_CORNER).lib \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_4096x16_c3_bm_bist_$(SRAM_CORNER).lib \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_4096x8_c3_bm_bist_$(SRAM_CORNER).lib \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_512x32_c2_bm_bist_$(SRAM_CORNER).lib \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_512x64_c2_bm_bist_$(SRAM_CORNER).lib \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_64x64_c2_bm_bist_$(SRAM_CORNER).lib \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lib/RM_IHPSG13_2P_64x32_c2_$(SRAM_CORNER).lib

TECH_LEF := $(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef

STDCELL_LEF := $(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_stdcell/lef/sg13g2_stdcell.lef

SRAM_LEF := \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_1024x16_c2_bm_bist.lef \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_1024x64_c2_bm_bist.lef \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_1024x8_c2_bm_bist.lef \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_2048x64_c2_bm_bist.lef \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_256x48_c2_bm_bist.lef \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_256x64_c2_bm_bist.lef \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_4096x16_c3_bm_bist.lef \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_4096x8_c3_bm_bist.lef \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_512x32_c2_bm_bist.lef \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_512x64_c2_bm_bist.lef \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lef/RM_IHPSG13_1P_64x64_c2_bm_bist.lef \
	$(PDK_ROOT)/$(ASIC_TECH)/libs.ref/sg13g2_sram/lef/RM_IHPSG13_2P_64x32_c2.lef

HI_CELL_NAME_AND_PORT := sg13g2_tiehi L_HI

LO_CELL_NAME_AND_PORT := sg13g2_tielo L_LO
