STDCELL_SRAM_BEHAV_VERILOG := \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_stdcell/verilog/sg13g2_stdcell.v \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_1024x16_c2_bm_bist.v \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_1024x64_c2_bm_bist.v \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_1024x8_c2_bm_bist.v \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_2048x64_c2_bm_bist.v \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_256x48_c2_bm_bist.v \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_256x64_c2_bm_bist.v \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_4096x16_c3_bm_bist.v \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_4096x8_c3_bm_bist.v \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_512x32_c2_bm_bist.v \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_512x64_c2_bm_bist.v \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_64x64_c2_bm_bist.v \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_1P_core_behavioral_bm_bist.v \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_2P_64x32_c2.v \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/verilog/RM_IHPSG13_2P_core_behavioral_ideal.v

STDCELL_LIBERTY := $(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib

SRAM_LIBERTY := \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_1024x16_c2_bm_bist_typ_1p20V_25C.lib \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_1024x64_c2_bm_bist_typ_1p20V_25C.lib \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_1024x8_c2_bm_bist_typ_1p20V_25C.lib \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_2048x64_c2_bm_bist_typ_1p20V_25C.lib \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_256x48_c2_bm_bist_typ_1p20V_25C.lib \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_256x64_c2_bm_bist_typ_1p20V_25C.lib \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_4096x16_c3_bm_bist_typ_1p20V_25C.lib \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_4096x8_c3_bm_bist_typ_1p20V_25C.lib \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_512x32_c2_bm_bist_typ_1p20V_25C.lib \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_512x64_c2_bm_bist_typ_1p20V_25C.lib \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/lib/RM_IHPSG13_1P_64x64_c2_bm_bist_typ_1p20V_25C.lib \
	$(PDK_PATH)/ihp-sg13g2/libs.ref/sg13g2_sram/lib/RM_IHPSG13_2P_64x32_c2_typ_1p20V_25C.lib

HI_CELL_NAME_AND_PORT := sg13g2_tiehi L_HI

LO_CELL_NAME_AND_PORT := sg13g2_tielo L_LO
