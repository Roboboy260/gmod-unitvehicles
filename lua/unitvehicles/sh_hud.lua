UV = UV or {}

UV.Tips = UV.Tips or {}

UV.Tips.Racer = {
	-- General
	"uv.tip.repairshop",
	
	-- General Pursuit Tech
	"uv.tip.pt.emp1",
	"uv.tip.pt.emp2",
	"uv.tip.pt.esf1",
	"uv.tip.pt.esf2",
	"uv.tip.pt.repairkit1",
	"uv.tip.pt.spikes1",
	"uv.tip.pt.spikes2",
	"uv.tip.pt.jammer",
	"uv.tip.drafting",
	
	-- Racer-specific Pursuit Tech
	"uv.tip.racer.pt.jammer1",
	"uv.tip.racer.pt.jammer2",
	"uv.tip.racer.pt.shockwave1",
	"uv.tip.racer.pt.stunmine1",
	"uv.tip.racer.pt.powerplay1",
	"uv.tip.racer.pt.juggernaut1",
	"uv.tip.racer.pt.ghost1",

	"uv.tip.racer.pt.killswitch1",
	"uv.tip.racer.pt.shockram1",
	"uv.tip.racer.pt.gpsdart1",
	"uv.tip.racer.pt.grappler1",

	-- General Racer-specific
	"uv.tip.racer.cooldown",
	"uv.tip.racer.aitactics1",
	"uv.tip.racer.aitactics2",
	"uv.tip.racer.pb",
	"uv.tip.racer.comunits1",
	"uv.tip.racer.comunits2",
	"uv.tip.racer.comunits3",
	"uv.tip.racer.airunits1",
	"uv.tip.racer.leastagro",
	"uv.tip.racer.roadblocks1",
	"uv.tip.racer.roadblocks2",
	"uv.tip.racer.boxedin",
	"uv.tip.racer.upgradedunits",
	"uv.tip.racer.stuck",
	"uv.tip.racer.disorient",
	"uv.tip.racer.rhinounits",
}

UV.Tips.Units = {
	-- General
	"uv.tip.repairshop",
	
	-- General Pursuit Tech
	"uv.tip.pt.emp1",
	"uv.tip.pt.emp2",
	"uv.tip.pt.esf1",
	"uv.tip.pt.esf2",
	"uv.tip.pt.repairkit1",
	"uv.tip.pt.spikes1",
	"uv.tip.pt.spikes2",
	"uv.tip.pt.jammer",
	"uv.tip.drafting",
	
	-- Unit-specific Pursuit Tech
	"uv.tip.unit.pt.killswitch1",
	"uv.tip.unit.pt.killswitch2",
	"uv.tip.unit.pt.shockram1",
	"uv.tip.unit.pt.gpsdart1",
	"uv.tip.unit.pt.grappler1",

	"uv.tip.unit.pt.shockwave1",
	"uv.tip.unit.pt.juggernaut1",
	"uv.tip.unit.pt.ghost1",

	-- General Unit-specific
	"uv.tip.unit.pit",
	"uv.tip.unit.teamwork",
	"uv.tip.unit.roadblocks",
	"uv.tip.unit.loneunit",
	"uv.tip.unit.comunit",
	"uv.tip.unit.nocooldown",
	"uv.tip.unit.respawn",
	"uv.tip.unit.pbnote",
}

UVColors = {
    -- Original HUD
    ["Original_LocalPlayer"] = Color(255, 217, 0),
    ["Original_Others"] = Color(255, 255, 255),
    ["Original_Disqualified"] = Color(255, 50, 50, 133),
	
	-- Most Wanted HUD
    ["MW_LocalPlayer"] = Color(223, 184, 127), --Color(255, 187, 0),
    ["MW_Accent"] = Color(223, 184, 127),
    ["MW_Others"] = Color(255, 255, 255),
    ["MW_Disqualified"] = Color(255, 50, 50, 133),
    ["MW_Cop"] = Color(61, 184, 255, 107),
    ["MW_CopShade"] = Color(41, 149, 212, 107),
    ["MW_Racer"] = Color(255, 221, 142, 107),
    ["MW_RacerShade"] = Color(166, 142, 85, 107),
	
    -- Carbon HUD
    ["Carbon_Accent"] = Color(86, 214, 205),
    ["Carbon_AccentTransparent"] = Color(86, 214, 205, 50),
    ["Carbon_AccentDarker"] = Color(62, 153, 145),
    ["Carbon_Accent2"] = Color(168, 168, 168),
    ["Carbon_Accent2Bright"] = Color(189, 189, 189),
    ["Carbon_Accent2Transparent"] = Color(168, 168, 168, 100),
    ["Carbon_LocalPlayer"] = Color(86, 214, 205),
    ["Carbon_Others"] = Color(255, 255, 255),
    ["Carbon_OthersDark"] = Color(255, 255, 255, 121),
    ["Carbon_Disqualified"] = Color(255, 50, 50, 133),
	
    -- Undercover HUD
    ["Undercover_Accent1"] = Color(255, 255, 255),
    ["Undercover_Accent2"] = Color(187, 226, 220),
    ["Undercover_Accent2Transparent"] = Color(187, 226, 220, 150)
}

UVMaterials = {
    ["RACE_COUNTDOWN_BG"] = Material("unitvehicles/hud/COUNTDOWN_BG.png"),
    ["RESPAWN_BG"] = Material("unitvehicles/hud/RESPAWN_BG.png"),
    ["PT_BG"] = Material("unitvehicles/hud/PT_BG.png"),
    ["SCREENFLASH"] = Material("unitvehicles/hud/SCREENFLASH.png"),
    ["SCREENFLASH_SMALL"] = Material("unitvehicles/hud/SCREENFLASH_SMALL.png"),
	
    ["PT_LEFT"] = Material("unitvehicles/hud/PTLeft.png"),
    ["PT_RIGHT"] = Material("unitvehicles/hud/PTRight.png"),
    ["PT_LEFT_BG"] = Material("unitvehicles/hud/PTLeftBG.png"),
    ["PT_RIGHT_BG"] = Material("unitvehicles/hud/PTRightBG.png"),
    
    ["GLOW_ICON"] = Material("unitvehicles/icons/CIRCLE_GLOW_LIGHT.png"),
    ["UNITS_DAMAGED"] = Material("unitvehicles/icons/COPS_DAMAGED_ICON.png"),
    ["UNITS_DISABLED"] = Material("unitvehicles/icons/COPS_TAKENOUT_ICON.png"),
    ["UNITS"] = Material("unitvehicles/icons/COPS_ICON.png"),
    ["HEAT"] = Material("unitvehicles/icons/HEAT_ICON.png"),
    ["CLOCK"] = Material("unitvehicles/icons/TIMER_ICON.png"),
    ["CLOCK_BG"] = Material("unitvehicles/icons/TIMER_ICON_BG.png", "smooth mips"),
    ["CHECK"] = Material("unitvehicles/icons/MINIMAP_ICON_CIRCUIT.png"),
    ["RESULTCOP"] = Material("unitvehicles/icons/(9)T_UI_PlayerCop_Large_Icon.png"),
    ["RESULTRACE"] = Material("unitvehicles/icons/INGAME_ICON_LEADERBOARD.png"),
    ["HIDECAR"] = Material("unitvehicles/icons/HIDE_CAR_ICON.png"),
    ["PBREAKER"] = Material("unitvehicles/icons/MINIMAP_ICON_PURSUIT_BREAKER.png"),
    ["PBREAKER3D"] = Material("unitvehicles/icons/WORLD_PURSUITBREAKER.png"),
    
    ["RACE_BG_POS"] = Material("unitvehicles/hud/POSITION_BACKING.png"),
    ["RACE_BG_TIME"] = Material("unitvehicles/hud/TIME_BACKING.png"),
    
    ["PURSUIT_BG_TOP"] = Material("unitvehicles/hud/PURSUIT_BACKING_TOP.png"),
    ["PURSUIT_BG_BOTTOM"] = Material("unitvehicles/hud/PURSUIT_BACKING_BOTTOM.png"),
    ["PURSUIT_BG_PULSE"] = Material("unitvehicles/hud/PURSUIT_LEADERLIST_PULSE.png"),
    
    ["PURSUIT_BG_BOTBAR"] = Material("unitvehicles/hud/OUTRUN_BACKING.png"),
    ["PURSUIT_BG_BOTBAR_ALT"] = Material("unitvehicles/hud/OUTRUN_BACKING_ALT.png"),
    
    ["BACKGROUND"] = Material("unitvehicles/hud/NFSMW_BACKGROUND.png"),
    ["BACKGROUND_BIG"] = Material("unitvehicles/hud/NFSMW_BACKGROUND_BIG.png"),
    ["BACKGROUND_BIGGER"] = Material("unitvehicles/hud/NFSMW_BACKGROUND_BIGGER.png"),
	
    ["SCANNER_BG"] = Material("unitvehicles/hud/RADAR_BACKING.png"),
    ["SCANNER_MIDDLE"] = Material("unitvehicles/hud/RADAR_ICON.png"),
    ["SCANNER_ARROW"] = Material("unitvehicles/hud/RADAR_DIRECTIONARROW.png"),
	
    ["SCANNER_LEDS_BG"] = Material("unitvehicles/hud/RADAR_LEDS.png"),
    ["SCANNER_LEDS_BG_INV"] = Material("unitvehicles/hud/RADAR_LEDS_INV.png"),
    
    ["SCANNER_LEDS"] = Material("unitvehicles/hud/RADAR_LEDS_COLOR.png"),
    ["SCANNER_LEDS_INV"] = Material("unitvehicles/hud/RADAR_LEDS_COLOR_INV.png"),
    
    ["INFRACTIONS_BG"] = Material("unitvehicles/hud/outter_ring_infractions.png"),
    ["INFRACTIONS_BG_RING"] = Material("unitvehicles/hud/outter_ring.png"),
    ["INFRACTIONS_ICON"] = Material("unitvehicles/hud/generic_infraction.png"),
	
    -- Carbon
    ["TAKEDOWN_CIRCLE_CARBON"] = Material("unitvehicles/icons_carbon/FULL_CIRCLE.png"),
    ["TAKEDOWN_RING_CARBON"] = Material("unitvehicles/icons_carbon/FULL_CIRCLE_RING.png"),
    
    ["UNITS_DISABLED_CARBON"] = Material("unitvehicles/icons_carbon/COPS_DESTROYED.png"),
    ["UNITS_CARBON"] = Material("unitvehicles/icons_carbon/COPS_INVOLVED.png"),
    ["HEAT_CARBON"] = Material("unitvehicles/icons_carbon/FLASHER_ICON_HEAT.png"),
	
    ["SPLITTIME_CARBON"] = Material("unitvehicles/icons_carbon/FLASHER_ICON_SPLITTIME.png"),
    
    ["ARROW_CARBON"] = Material("unitvehicles/hud_carbon/NFSC_ARROWRIGHT.png"),
    ["BACKGROUND_CARBON"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT.png"),
    ["BACKGROUND_CARBON_INVERTED"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT_INV.png"),
    ["BACKGROUND_CARBON_SMALL"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT_SMALL.png"),
    ["BACKGROUND_CARBON_SMALL_INVERTED"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT_SMALL_INV.png"),
    ["BACKGROUND_CARBON_SOLID"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT_SOLID.png"),
    ["BACKGROUND_CARBON_SOLID_INVERTED"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT_SOLID_INV.png"),
    
    ["BACKGROUND_CARBON_FILLED"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT_FILLED.png"),
    ["BACKGROUND_CARBON_FILLED_INVERTED"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT_FILLED_INV.png"),
    
    ["BAR_CARBON_FILLED"] = Material("unitvehicles/hud_carbon/HUD_GENERIC_METER_COLOR.png"),
    ["BAR_CARBON_FILLED_INVERTED"] = Material("unitvehicles/hud_carbon/HUD_GENERIC_METER_COLOR_INV.png"),
	
    ["BAR_CARBON_FILLED_MIDDLE"] = Material("unitvehicles/hud_carbon/HUD_GENERIC_METER_COLOR_CENTER.png"),
    ["BAR_CARBON_FILLED_COOLDOWN"] = Material("unitvehicles/hud_carbon/HUD_COOLDOWN_METER_COLOR.png"),
    
    ["X_OUTER_CARBON"] = Material("unitvehicles/hud_carbon/SHAPE_INGAME_OUTLINE.png"),
    ["EOC_FRAME_CARBON"] = Material("unitvehicles/hud_carbon/PC_HELP_FRAME_LONG.png"),
    
    ["BG_BIG_CARBON"] = Material("unitvehicles/hud_carbon/NFSC_BG_BIG.png"),

	-- [Carbon] UI

	["RPM_8000"] = Material("unitvehicles/speedometers/carbon00/HUD_RPM_8000.png", "mips smooth"),
	["RPM_10000"] = Material("unitvehicles/speedometers/carbon00/HUD_RPM_10000.png", "mips smooth"),
	["HUD_BACKGROUND_BACKING"] = Material("unitvehicles/speedometers/carbon00/HUD_MAIN_SPEED_BACKING.png", "mips smooth"),
	["HUD_GEAR"] = Material("unitvehicles/speedometers/carbon/HUD_GEAR.png", "mips smooth"),
	["NOS_ICON"] = Material("unitvehicles/speedometers/carbon/NOS_ICON.png", "mips smooth"),
	["SPEEDBREAKER_ICON"] = Material("unitvehicles/speedometers/carbon/SPEEDBREAKER_ICON.png", "mips smooth"),
	["RPM_BACKING"] = Material("unitvehicles/speedometers/carbon00/HUD_RPM_METER_BACKING.png", "mips smooth"),
	["RPM_COLOR"] = Material("unitvehicles/speedometers/carbon00/HUD_RPM_METER_COLOR.png", "mips smooth"),
	["SHIFT_ICON_NORMAL"] = Material("unitvehicles/speedometers/carbon00/HUD_SHIFT_ICON_NORMAL.png", "mips smooth"),
    
    -- Undercover
    ["ARREST_BG_UC"] = Material("unitvehicles/hud_undercover/BUSTED_HEADER.png"),
    ["ARREST_LIGHT_UC"] = Material("unitvehicles/hud_undercover/BUSTED_COPLIGHT_BG.png"),
    
    ["UNITS_DISABLED_UC"] = Material("unitvehicles/icons_undercover/HUD_COP_TAKEDOWN_ICON.png"),
    ["CTS_UC"] = Material("unitvehicles/icons_undercover/HUD_CTS_ICON.png"),
    
    ["BUSTED_ICON_UC"] = Material("unitvehicles/icons_undercover/BUST_COP_ICON.png", "smooth mips"),
    ["BUSTED_ICON_UC_GLOW"] = Material("unitvehicles/icons_undercover/BUSTED_ICON_GLOW.png", "smooth mips"),
    ["EVADE_ICON_UC"] = Material("unitvehicles/icons_undercover/EVADE_CAR_ICON.png", "smooth mips"),
    ["EVADE_ICON_UC_GLOW"] = Material("unitvehicles/icons_undercover/EVADE_ICON_GLOW.png", "smooth mips"),
    
    -- Underground 2
    ["RACE_BG_UPPER_UG2"] = Material("unitvehicles/hud_underground2/3RDPERSON_BOXCORNER.png"),
    ["RACE_BG_LAP_UG2"] = Material("unitvehicles/hud_underground2/3RDPERSON_BOXLAPS.png"),
    ["RACE_BG_TIME_UG2"] = Material("unitvehicles/hud_underground2/3RDPERSON_BOXTIME.png"),
    ["RACE_BG_TIME_UG2_ALT"] = Material("unitvehicles/hud_underground2/3RDPERSON_BOXTIME2.png"),
    
    ["RESULTS_UG2_BG"] = Material("unitvehicles/hud_underground2/results_bg_bg.png"),
    ["RESULTS_UG2_SHINE"] = Material("unitvehicles/hud_underground2/results_bg_shine.png"),
    ["RESULTS_UG2_LP"] = Material("unitvehicles/hud_underground2/results_bg_lp.png"),
    ["RESULTS_UG2_BUTTON"] = Material("unitvehicles/hud_underground2/UI_PC_GENERIC_BUTTON.png"),
    
    -- ProStreet
    ["RESULTS_PS_CURVES"] = Material("unitvehicles/icons_prostreet/curves.png"),
    ["RESULTS_PS_HUB"] = Material("unitvehicles/icons_prostreet/hub_44.png"),
    ["RESULTS_PS_WING"] = Material("unitvehicles/icons_prostreet/flixfx_wing.png"),
    ["RESULTS_PS_WING_INV"] = Material("unitvehicles/icons_prostreet/flixfx_wing_inv.png"),
    ["RESULTS_PS_SP8"] = Material("unitvehicles/icons_prostreet/flixfx_sp8.png"),
    ["RACE_FLAG_PS"] = Material("unitvehicles/icons_prostreet/flag.png"),
    
	-- World
	["RACE_CDBG_LEFT_WORLD"] = Material("unitvehicles/hud_world/race_starter_bg_left.png"),
	["RACE_CDBG_RIGHT_WORLD"] = Material("unitvehicles/hud_world/race_starter_bg_right.png"),
	
	["RACE_PLAYERMARKER_WORLD"] = Material("unitvehicles/hud_world/race_playerarrow.png"),
	["RACE_DNFMARKER_WORLD"] = Material("unitvehicles/hud_world/race_playerdnf.png"),
	["RACE_BUSTEDMARKER_WORLD"] = Material("unitvehicles/hud_world/race_playerbusted.png"),
	["CTS_WORLD"] = Material("unitvehicles/hud_world/pursuit_cts.png"),
	
	["WARNING_WORLD"] = Material("unitvehicles/hud_world/pursuitbar_warning.png"),
	["WARNINGBG_WORLD"] = Material("unitvehicles/hud_world/pursuitbar_centernoti_bg.png"),
	["COOLDOWNBG_WORLD"] = Material("unitvehicles/hud_world/pursuitbar_centernoti_bg_blue.png"),
	["UNIT_WORLD"] = Material("unitvehicles/hud_world/pursuit_policecar.png"),
	["UNIT_DMG_WORLD"] = Material("unitvehicles/hud_world/pursuit_policecar_dmg.png"),
	["UNIT_DMG_WORLD_LIT"] = Material("unitvehicles/hud_world/pursuit_policecar_dmg_red.png"),
	["UNIT_CROSS_WORLD"] = Material("unitvehicles/hud_world/pursuit_policecarcross.png"),
	["UNIT_CROSS_WORLD_LIT"] = Material("unitvehicles/hud_world/pursuit_policecarcross_lit.png"),
	
	["CHASEBAR_LEFT_WORLD"] = Material("unitvehicles/hud_world/pursuitbar_left.png"),
	["CHASEBAR_RIGHT_WORLD"] = Material("unitvehicles/hud_world/pursuitbar_right.png"),
	
	["CHASEBAR_ARROW_LEFT_WORLD"] = Material("unitvehicles/hud_world/pursuitbar_arrow_left.png"),
	["CHASEBAR_ARROW_RIGHT_WORLD"] = Material("unitvehicles/hud_world/pursuitbar_arrow_right.png"),
	
	["CHASEBAR_CAR_WORLD"] = Material("unitvehicles/hud_world/pursuitbar_escapecar.png"),
	["CHASEBAR_COP_WORLD"] = Material("unitvehicles/hud_world/pursuitbar_copcar.png"),
	["CHASEBAR_COOLDOWN_WORLD"] = Material("unitvehicles/hud_world/pursuitbar_cooldown.png"),
	
	["RESULTSBG_WORLD"] = Material("unitvehicles/hud_world/result/result_bg.png"),
	
	["LOADING_WORLD_L"] = Material("unitvehicles/hud_world/result/loading_left.png"),
	["LOADING_WORLD_R"] = Material("unitvehicles/hud_world/result/loading_right.png"),
	["LOADING_WORLD_SHINE1"] = Material("unitvehicles/hud_world/result/loading_shine1.png"),
	["LOADING_WORLD_SHINE2"] = Material("unitvehicles/hud_world/result/loading_shine2.png"),
	["LOADING_WORLD_SHINE3"] = Material("unitvehicles/hud_world/result/loading_shine3.png"),
	
	["RESULTS_1ST_WORLD"] = Material("unitvehicles/hud_world/result/result_1st.png"),
	["RESULTS_2ND_WORLD"] = Material("unitvehicles/hud_world/result/result_2nd.png"),
	["RESULTS_3RD_WORLD"] = Material("unitvehicles/hud_world/result/result_3rd.png"),
	["RESULTS_4TH_WORLD"] = Material("unitvehicles/hud_world/result/result_4th.png"),
	
	["RESULTS_1ST_BANNER_WORLD"] = Material("unitvehicles/hud_world/result/result_banner_1st.png"),
	["RESULTS_2ND_BANNER_WORLD"] = Material("unitvehicles/hud_world/result/result_banner_2nd.png"),
	["RESULTS_3RD_BANNER_WORLD"] = Material("unitvehicles/hud_world/result/result_banner_3rd.png"),
	["RESULTS_4TH_BANNER_WORLD"] = Material("unitvehicles/hud_world/result/result_banner_4th.png"),
	
	["RESULTS_NEXTBTN_WORLD"] = Material("unitvehicles/hud_world/result/nextbutton.png"),
	["RESULTS_NEXTBTN_GLOW_WORLD"] = Material("unitvehicles/hud_world/result/nextbutton_glowing.png"),
	["RESULTS_NEXTBTN_INACTIVE_WORLD"] = Material("unitvehicles/hud_world/result/nextbutton_inactive.png"),
	
	["RESULTS_BANNER_ESCAPED"] = Material("unitvehicles/hud_world/result/result_banner_escaped.png"),
	["RESULTS_BANNER_BUSTED"] = Material("unitvehicles/hud_world/result/result_banner_busted.png"),
	
	["RESULTS_SHEEN_ESCAPED"] = Material("unitvehicles/hud_world/result/result_sheen_blue.png"),
	["RESULTS_SHEEN_BUSTED"] = Material("unitvehicles/hud_world/result/result_sheen_red.png"),
	    
    -- Crash Time - Undercover
    ["HUD_CTU_LEFT"] = Material("unitvehicles/hud_ctu/hud_left.png"),
    ["HUD_CTU_LEFT_BG"] = Material("unitvehicles/hud_ctu/hud_left_bg.png"),
    ["HUD_CTU_RIGHT"] = Material("unitvehicles/hud_ctu/hud_right.png"),
    ["HUD_CTU_RIGHT_BG"] = Material("unitvehicles/hud_ctu/hud_right_bg.png"),
	
    ["HUD_CTU_GRADIENT_UP"] = Material("unitvehicles/hud_ctu/PauseGradient.png"),
    ["HUD_CTU_GRADIENT_DOWN"] = Material("unitvehicles/hud_ctu/PauseGradientBottom.png"),
    ["HUD_CTU_BAR"] = Material("unitvehicles/hud_ctu/OrangeTickerBar.png"),
    ["HUD_CTU_ENDBOX"] = Material("unitvehicles/hud_ctu/Endbox.png"),
    ["HUD_CTU_FOCUSBAR"] = Material("unitvehicles/hud_ctu/FocusBar.png"),
    ["HUD_CTU_FOCUSBARBLACK"] = Material("unitvehicles/hud_ctu/FocusBarBlack.png"),

	-- NIGHTRUNNERS
	["OPP_NR_SIGNAL_0"] = Material("unitvehicles/icons_nightrunners/race_ui_signal_0.png", "smooth mips"),
	["OPP_NR_SIGNAL_1"] = Material("unitvehicles/icons_nightrunners/race_ui_signal_1.png", "smooth mips"),
	["OPP_NR_SIGNAL_2"] = Material("unitvehicles/icons_nightrunners/race_ui_signal_2.png", "smooth mips"),
	["OPP_NR_SIGNAL_3"] = Material("unitvehicles/icons_nightrunners/race_ui_signal_3.png", "smooth mips"),
	["OPP_NR_SIGNAL_4"] = Material("unitvehicles/icons_nightrunners/race_ui_signal_4.png", "smooth mips"),

	-- shared
	['SHARED_DASH_NR_NEEDLE_GLASS'] = Material("unitvehicles/speedometers/nightrunners/needle_glass.png", "smooth mips"),
	['SHARED_DASH_NR_NEEDLE_GLOW'] = Material("unitvehicles/speedometers/nightrunners/big_needle_center_glow_2.png", "smooth mips"),
	['SHARED_DASH_NR_ENGINE_OVERHEAT'] = Material("unitvehicles/speedometers/nightrunners/dash_engine_overheat.png", "smooth mips"),
	['SHARED_DASH_NR_LIGHT'] = Material("unitvehicles/speedometers/nightrunners/dash_light.png", "smooth mips"),
	['SHARED_DASH_NR_ODOMETER'] = Material("unitvehicles/speedometers/nightrunners/odometer.png", "smooth mips"),
	['SHARED_DASH_NR_SHIFT_DOWN_ICON'] = Material("unitvehicles/speedometers/nightrunners/shift_down_icon.png", "smooth mips"),
	['SHARED_DASH_NR_SHIFT_UP_ICON'] = Material("unitvehicles/speedometers/nightrunners/shift_up_icon.png", "smooth mips"),
	['SHARED_DASH_NR_SHIFT_BG'] = Material("unitvehicles/speedometers/nightrunners/shift_bg.png", "smooth mips"),

	-- tacho1
	['TACHO1_NR_BIG_BACKING'] = Material("unitvehicles/speedometers/nightrunners/TACHO1_BIG_BACKING.png", "smooth mips"),
	['TACHO1_NR_BIG_BACKING_GLASS'] = Material("unitvehicles/speedometers/nightrunners/tacho1_big_backing_glass.png", "smooth mips"),
	['TACHO1_NR_RPM_GAUGE'] = Material("unitvehicles/speedometers/nightrunners/TACHO1_RPM_GAUGE.png", "smooth mips"),
	['TACHO1_NR_REDLINE'] = Material("unitvehicles/speedometers/nightrunners/TACHO1_REDLINE.png", "smooth mips"),
	['TACHO1_NR_SPEEDO_GAUGE'] = Material("unitvehicles/speedometers/nightrunners/TACHO1_SPEEDO_GAUGE.png", "smooth mips"),
	['TACHO1_NR_TEMP_GAUGE_BACKING'] = Material("unitvehicles/speedometers/nightrunners/TACHO1_TEMP_GAUGE_BACKING.png", "smooth mips"),
	['TACHO1_NR_TEMP_GAUGE_GLASS'] = Material("unitvehicles/speedometers/nightrunners/TACHO1_TEMP_GAUGE_GLASS.png", "smooth mips"),
	['TACHO1_NR_TEMP_GAUGE'] = Material("unitvehicles/speedometers/nightrunners/TACHO1_TEMP_GAUGE.png", "smooth mips"),
	['TACHO1_NR_FUEL_GAUGE_BACKING'] = Material("unitvehicles/speedometers/nightrunners/TACHO1_FUEL_GAUGE_BACKING.png", "smooth mips"),
	['TACHO1_NR_FUEL_GAUGE_GLASS'] = Material("unitvehicles/speedometers/nightrunners/TACHO1_FUEL_GAUGE_GLASS.png", "smooth mips"),
	['TACHO1_NR_FUEL_GAUGE'] = Material("unitvehicles/speedometers/nightrunners/TACHO1_FUEL_GAUGE.png", "smooth mips"),
	['TACHO1_NR_NEEDLE'] = Material("unitvehicles/speedometers/nightrunners/tacho1_big_needle.png", "smooth mips"),
	['TACHO1_NR_SMALL_NEEDLE'] = Material("unitvehicles/speedometers/nightrunners/TACHO1_SMALL_NEEDLE_3.png", "smooth mips"),
	['TACHO1_NR_SMALL_NEEDLE_GLASS'] = Material("unitvehicles/speedometers/nightrunners/small_glass_2.png", "smooth mips"),
	
	-- tacho2
	['TACHO2_NR_BIG_BACKING'] = Material("unitvehicles/speedometers/nightrunners/TACHO2_BIG_BACKING.png", "smooth mips"),
	['TACHO2_NR_BIG_BACKING_GLASS'] = Material("unitvehicles/speedometers/nightrunners/tacho2_big_backing_glass.png", "smooth mips"),
	['TACHO2_NR_RPM_GAUGE'] = Material("unitvehicles/speedometers/nightrunners/TACHO2_RPM_GAUGE.png", "smooth mips"),
	['TACHO2_NR_REDLINE'] = Material("unitvehicles/speedometers/nightrunners/TACHO2_REDLINE.png", "smooth mips"),
	['TACHO2_NR_SPEEDO_GAUGE'] = Material("unitvehicles/speedometers/nightrunners/TACHO2_SPEEDO_GAUGE.png", "smooth mips"),
	['TACHO2_NR_BIG_NEEDLE'] = Material("unitvehicles/speedometers/nightrunners/TACHO2_BIG_NEEDLE.png", "smooth mips"),
	['TACHO2_NR_SMALL_NEEDLE'] = Material("unitvehicles/speedometers/nightrunners/TACHO2_SMALL_NEEDLE.png", "smooth mips"),
	['TACHO2_NR_SMALL_BACKING'] = Material("unitvehicles/speedometers/nightrunners/TACHO2_SMALL_BACKING.png", "smooth mips"),
	['TACHO2_NR_SMALL_BACKING_GLASS'] = Material("unitvehicles/speedometers/nightrunners/TACHO2_SMALL_BACKING_GLASS.png", "smooth mips"),
	['TACHO2_NR_FUEL_GAUGE'] = Material("unitvehicles/speedometers/nightrunners/TACHO2_FUEL_GAUGE.png", "smooth mips"),
	['TACHO2_NR_TEMP_GAUGE'] = Material("unitvehicles/speedometers/nightrunners/TACHO2_TEMP_GAUGE.png", "smooth mips"),

	-- tacho3
	['TACHO3_NR_SPEEDO_GAUGE'] = Material("unitvehicles/speedometers/nightrunners/TACHO3_SPEEDO_GAUGE.png", "smooth mips"),
	['TACHO3_NR_RPM_GAUGE'] = Material("unitvehicles/speedometers/nightrunners/TACHO3_RPM_GAUGE.png", "smooth mips"),
	['TACHO3_NR_BIG_NEEDLE'] = Material("unitvehicles/speedometers/nightrunners/TACHO3_BIG_NEEDLE.png", "smooth mips"),
	-- ['TACHO2_NR_TEMP_GAUGE_BACKING'] = Material("unitvehicles/speedometers/nightrunners/TACHO2_TEMP_GAUGE_BACKING.png", "smooth mips"),
	-- ['TACHO2_NR_TEMP_GAUGE_GLASS'] = Material("unitvehicles/speedometers/nightrunners/TACHO2_TEMP_GAUGE_GLASS.png", "smooth mips"),
	-- ['TACHO2_NR_TEMP_GAUGE'] = Material("unitvehicles/speedometers/nightrunners/TACHO2_TEMP_GAUGE.png", "smooth mips"),
}

UV_UI_Events = {
    ['Wrecks'] = 'onUnitWreck',
    ['Deploys'] = 'onUnitDeploy',
    ['Tags'] = 'onUnitTag',
    ['ResourcePoints'] = 'onResourceChange',
    ['UnitsChasing'] = 'onChasingUnitsChange',
    ['Heat'] = 'onHeatLevelUpdate',
}

function UVBindButtonName(var)
	local keyName = input.GetKeyName(var)
	if not keyName then return "UNKNOWN" end
	local upperKeyName = string.upper(keyName)
	return upperKeyName
end

if CLIENT then
	-- Size-related stuff
	UV.BaseW = 1920
	UV.BaseH = 1080
	
	local uiscale = 1
	UV.DebugRes = nil
	
	-- UV.DebugRes = { w = ScrW(), h = ScrH() }
	
	-- Uncomment if you want to debug certain screen resolutions. Below are the resolutions for 16:9:
	-- UV.DebugRes = { w = 1280, h = 720 } -- 16:9 720p (!! Bare Minimum !!)
	-- UV.DebugRes = { w = 640, h = 480 } -- 16:9 480p (For testing - never work with this as a baseline)
	
	-- UV.DebugRes = { w = 1280, h = 1024 } -- 4:3 (For testing - never work with this as a baseline)
	
	-- UV.DebugRes = { w = 3440, h = 1440 } -- Ultrawide fuckery
	-- uiscale = 0.5
	
	UV.UIScale = math.Clamp(uiscale, 0.25, 1)

	function UV_GetW()
		local w = UV.DebugRes and UV.DebugRes.w or ScrW()
		return w * (UV.UIScale or 1)
	end

	function UV_GetH()
		local h = UV.DebugRes and UV.DebugRes.h or ScrH()
		return h * (UV.UIScale or 1)
	end

	function UV.ScaleW(px)
		return math.Round(px * (UV_GetW() / UV.BaseW))
	end

	function UV.ScaleH(px)
		return math.Round(px * (UV_GetH() / UV.BaseH))
	end

	function UV.Scale(px)
		return math.Round(px * (math.min(UV_GetH(), UV.BaseH) / UV.BaseH))
	end

	-- Fonts
	function UV.CreateFonts()
		local scale = UV.ScaleH
	
		surface.CreateFont("UVFont", { font = "Arial", size = scale(50), weight = 500, italic = true, extended = true })
		surface.CreateFont("UVFont-Shadow", { font = "Arial", size = scale(50), weight = 500, italic = true, shadow = true, extended = true })
		surface.CreateFont("UVFont-Smaller", { font = "Arial", size = scale(46), weight = 500, italic = true, extended = true })
		surface.CreateFont("UVFont-Bolder", { font = "Arial", size = scale(46), weight = 1000, italic = false, shadow = true, extended = true })
		surface.CreateFont("UVFont2", { font = "Arial", size = scale(50), weight = 500, extended = true })
		surface.CreateFont("UVFont2-Smaller", { font = "Arial", size = scale(40), weight = 500, extended = true })
		surface.CreateFont("UVFont3", { font = "Arial", size = scale(50), weight = 500, shadow = true, extended = true })
		surface.CreateFont("UVFont3Big", { font = "Arial", size = scale(92), weight = 500, extended = true })
		surface.CreateFont("UVFont3Bigger", { font = "Arial", size = scale(130), weight = 500, extended = true })
		surface.CreateFont("UVFont4", { font = "Arial", size = scale(25), weight = 1100, shadow = true, extended = true })
		surface.CreateFont("UVFont7", { font = "VCR OSD Mono", size = scale(110), weight = 500, shadow = true, })
		surface.CreateFont("UVFont7Smaller", { font = "VCR OSD Mono", size = scale(64), weight = 500, shadow = true, })
		surface.CreateFont("UVFont7Tiny", { font = "VCR OSD Mono", size = scale(48), weight = 500, shadow = true, })
	
		-- CTU
		surface.CreateFont("UVFont4BiggerItalic", { font = "Arial", size = scale(27), weight = 1100, shadow = true, extended = true, italic = true })
		surface.CreateFont("UVFont4BiggerItalic2", { font = "Arial", size = scale(32), weight = 1100, shadow = true, extended = true, italic = true })
		surface.CreateFont("UVFont4BiggerItalic3", { font = "Arial", size = scale(70), weight = 1100, shadow = true, extended = true, italic = true })
	
		-- Carbon Fonts
		surface.CreateFont("UVCarbonFont", { font = "HelveticaNeue LT 57 Cn", size = scale(46), shadow = true, weight = 1000, extended = true })
		surface.CreateFont("UVCarbonFont-Larger", { font = "HelveticaNeue LT 57 Cn", size = scale(64), shadow = true, weight = 1000, extended = true, bold = true })
		surface.CreateFont("UVCarbonFont-Smaller", { font = "HelveticaNeue LT 57 Cn", size = scale(38), shadow = true, weight = 1000, extended = true })
		surface.CreateFont("UVCarbonMonoFont", { font = "Carbon Mono", size = scale(46), shadow = true, weight = 1000, extended = true })
		surface.CreateFont("UVCarbonMonoFont-Smaller", { font = "Carbon Mono", size = scale(38), shadow = true, weight = 1000, extended = true })
		surface.CreateFont("UVCarbonMonoFont7", { font = "Carbon Mono ", size = scale(100), shadow = true, weight = 0, extended = true })
		surface.CreateFont("UVCarbonMonoFont7Smaller", { font = "Carbon Mono ", size = scale(64), shadow = true, weight = 0, extended = true })
	
		-- Undercover Fonts
		surface.CreateFont("UVUndercoverAccentFont", { font = "HelveticaNeue LT 57 Cn", size = scale(36), shadow = true, weight = 1000, extended = true })
		surface.CreateFont("UVUndercoverLeaderboardFont", { font = "HelveticaNeue LT 57 Cn", size = scale(32), shadow = true, weight = 1000, extended = true })
		surface.CreateFont("UVUndercoverWhiteFont", { font = "Aquarius Six", size = scale(51), shadow = true, weight = 1, extended = true })
		surface.CreateFont("UVCarbonLeaderboardFont", { font = "HelveticaNeue LT 57 Cn", size = scale(25), shadow = true, weight = 1000, extended = true })
	
		-- Most Wanted Fonts
		surface.CreateFont("UVFont5", { font = "EurostileBold", size = scale(46), weight = 500, extended = true })
		surface.CreateFont("UVFont5UI", { font = "EurostileBold", size = scale(38), weight = 500, extended = true })
		surface.CreateFont("UVFont5UI-BottomBar", { font = "EurostileBold", size = scale(44), weight = 500, extended = true })
		surface.CreateFont("UVFont5WeightShadow", { font = "EurostileBold", size = scale(46), weight = 500, shadow = true, extended = true })
		surface.CreateFont("UVFont5Shadow", { font = "EurostileBold", size = scale(32), weight = 350, shadow = true, extended = true })
		surface.CreateFont("UVFont5ShadowLarge", { font = "EurostileBold", size = scale(64), weight = 500, shadow = true, extended = true })
		surface.CreateFont("UVFont5ShadowBig", { font = "EurostileBold", size = scale(108), weight = 500, shadow = true, extended = true })
		surface.CreateFont("UVMostWantedLeaderboardFont", { font = "EurostileBold", size = scale(25), weight = 1000, shadow = true, extended = true })
		surface.CreateFont("UVMostWantedLeaderboardFont2", { font = "EurostileBold", size = scale(18), weight = 1000, shadow = true, extended = true })
		surface.CreateFont("UVMWFont7", { font = "DS-Digital", size = scale(110), weight = 500, shadow = false, extended = false })
		surface.CreateFont("UVMWFont7Smaller", { font = "DS-Digital", size = scale(64), weight = 500, shadow = false, extended = false })
		surface.CreateFont("UVMWFont7Tiny", { font = "DS-Digital", size = scale(48), weight = 500, shadow = false, extended = false })
	
		-- World Fonts
		surface.CreateFont("UVWorldFont1", { font = "HelveticaNeue LT 57 Cn", size = scale(16), shadow = false, weight = 1000, extended = true })
		surface.CreateFont("UVWorldFont2", { font = "Reg-B-I", size = scale(43), shadow = false, weight = 1000, extended = true })
		surface.CreateFont("UVWorldFont3", { font = "Reg-B-I", size = scale(27), shadow = false, weight = 1000, extended = true })
		surface.CreateFont("UVWorldFont4", { font = "Reg-B-I", size = scale(38), shadow = false, weight = 1000, extended = true })
		surface.CreateFont("UVWorldFont5", { font = "Reg-B-I", size = scale(162), shadow = false, weight = 1000, extended = true })
		surface.CreateFont("UVWorldFont6", { font = "Reg-B-I", size = scale(24), shadow = false, weight = 1000, extended = true })
		surface.CreateFont("UVWorldFont7", { font = "Reg-B-I", size = scale(19), shadow = false, weight = 1000, extended = true })
	
		-- World Fonts Backup (for specific languages)
		surface.CreateFont("UVWorldFont1-Alt", { font = "Arial", size = scale(16), shadow = false, weight = 1000, italic = true, extended = true })
		surface.CreateFont("UVWorldFont2-Alt", { font = "Arial", size = scale(40), shadow = false, weight = 1000, italic = true, extended = true })
		surface.CreateFont("UVWorldFont3-Alt", { font = "Arial", size = scale(26), shadow = false, weight = 1000, italic = true, extended = true })
		surface.CreateFont("UVWorldFont4-Alt", { font = "Arial", size = scale(38), shadow = false, weight = 1000, italic = true, extended = true })
		surface.CreateFont("UVWorldFont5-Alt", { font = "Arial", size = scale(151), shadow = false, weight = 1000, italic = true, extended = true })
		surface.CreateFont("UVWorldFont6-Alt", { font = "Arial", size = scale(24), shadow = false, weight = 1000, italic = true, extended = true })
		surface.CreateFont("UVWorldFont7-Alt", { font = "Arial", size = scale(19), shadow = false, weight = 1000, italic = true, extended = true })

		-- NIGHTRUNNERS Fonts
		surface.CreateFont("UVNightRunnersFont-Small", { font = "Karma Suture", size = scale(40), shadow = true, weight = 500, extended = true, italic = true })
		surface.CreateFont("UVNightRunnersFont-Smaller", { font = "Karma Suture", size = scale(56), shadow = true, weight = 500, extended = true, italic = true })
		surface.CreateFont("UVNightRunnersFont", { font = "Karma Suture", size = scale(64), shadow = true, weight = 500, extended = true, italic = true })
		surface.CreateFont("UVNightRunnersFont-Bigger", { font = "Karma Suture", size = scale(72), shadow = true, weight = 500, extended = true, italic = true })
		surface.CreateFont("UVNightRunnersFont-Big", { font = "Karma Suture", size = scale(108), shadow = true, weight = 500, extended = true, italic = true })
		surface.CreateFont("UVNightRunnersLCDFont-Tiny1", { font = "LCDMono", size = scale(32), shadow = true, weight = 500, extended = true })
    	surface.CreateFont("UVNightRunnersLCDFont-Tiny2NoShadow", { font = "LCDBold", size = scale(20), shadow = false, weight = 500, extended = true })
    	surface.CreateFont("UVNightRunnersLCDFont-ThinTiny2", { font = "LCDBold", size = scale(11), shadow = false, weight = 500, extended = true })
		surface.CreateFont("UVNightRunnersLCDFont-Tiny1", { font = "LCDMono", size = scale(32), shadow = true, weight = 500, extended = true })
    	surface.CreateFont("UVNightRunnersLCDFont-Tiny2NoShadow", { font = "LCDBold", size = scale(20), shadow = false, weight = 500, extended = true })
    	surface.CreateFont("UVNightRunnersLCDFont-ThinTiny2", { font = "LCDBold", size = scale(11), shadow = false, weight = 500, extended = true })
		surface.CreateFont("UVNightRunnersLCDFont-Small", { font = "LCDMono", size = scale(40), shadow = true, weight = 500, extended = true })
		surface.CreateFont("UVNightRunnersLCDFont-Smaller", { font = "LCDMono", size = scale(56), shadow = true, weight = 500, extended = true })
		surface.CreateFont("UVNightRunnersLCDFont", { font = "LCDMono", size = scale(64), shadow = true, weight = 500, extended = true })
		surface.CreateFont("UVNightRunnersLCDFont-Bigger", { font = "LCDMono", size = scale(72), shadow = true, weight = 500, extended = true })
		surface.CreateFont("UVNightRunnersLCDFont-Big", { font = "LCDMono", size = scale(108), shadow = true, weight = 500, extended = true })
		
		surface.CreateFont("UVNightRunnersLCDFont-ODOMETERUNIT2", { font = "LCDBold", size = scale(9), shadow = false, weight = 500, extended = true })
		surface.CreateFont("UVNightRunnersLCDFont-ODOMETERVALUE2", { font = "LCDBold", size = scale(18), shadow = false, weight = 500, extended = true })

    	surface.CreateFont("UVNightRunnersFont-SmallNonItalic", { font = "Karma Suture", size = scale(40), shadow = true, weight = 500, extended = true, italic = false  })
    	surface.CreateFont("UVNightRunnersFont-SmallerNonItalic", { font = "Karma Suture", size = scale(56), shadow = true, weight = 500, extended = true, italic = false })
    	surface.CreateFont("UVNightRunnersFontNonItalic", { font = "Karma Suture", size = scale(64), shadow = true, weight = 500, extended = true, italic = false })
    	surface.CreateFont("UVNightRunnersFont-BiggerNonItalic", { font = "Karma Suture", size = scale(72), shadow = true, weight = 500, extended = true, italic = false })
    	surface.CreateFont("UVNightRunnersFont-BigNonItalic", { font = "Karma Suture", size = scale(108), shadow = true, weight = 500, extended = true, italic = false })
			
		-- Settings Fonts
		surface.CreateFont("UVSettingsFont", { font = "EurostileBold", size = scale(25), weight = 1000, shadow = true, extended = true })
		surface.CreateFont("UVSettingsFont-Italic", { font = "EurostileBold", size = scale(25), weight = 1000, shadow = true, extended = true, italic = true })
		surface.CreateFont("UVSettingsFontBig", { font = "EurostileBold", size = scale(35), weight = 1000, shadow = true, extended = true })
		surface.CreateFont("UVSettingsFontBig-Italic", { font = "EurostileBold", size = scale(35), weight = 1000, shadow = true, extended = true, italic = true })
		surface.CreateFont("UVSettingsFontSmall", { font = "EurostileBold", size = scale(18), weight = 1000, shadow = true, extended = true })
		surface.CreateFont("UVSettingsFontSmall-Italic", { font = "EurostileBold", size = scale(18), weight = 1000, shadow = true, extended = true, italic = true })
		surface.CreateFont("UVSettingsFontSmall-Bold", { font = "EurostileBold", size = scale(22), weight = 1000, shadow = true, extended = true })
	
		-- Keybind Fonts
		surface.CreateFont("UVKeybindFont", { font = "Destiny Keys", size = scale(25), weight = 500, extended = true })
		surface.CreateFont("UVKeybindFontBig", { font = "Destiny Keys", size = scale(35), weight = 500, extended = true })
		surface.CreateFont("UVKeybindFontSmall", { font = "Destiny Keys", size = scale(17.5), weight = 500, extended = true })	
	end
	
	hook.Add("UV-OnResolutionChange", "UV.UpdateFonts", function()
		UV.CreateFonts()
	end)
	
	-- hook.Add("Initialize", "UV.InitFonts", function()
		UV.CreateFonts()
	-- end)
	
	local screenW = ScrW()
	local screenH = ScrH()

    hook.Add( "Initialize", "UV.UpdateResolution", function()
		hook.Run( "UV-OnResolutionChange", ScrW(), ScrH() )
	end ) timer.Create( "UV.CheckResolutionTimer", 2, 0, function()
		if ScrW() ~= screenW or ScrH() ~= screenH then
			screenW = ScrW()
			screenH = ScrH()
			hook.Run( "UV-OnResolutionChange", screenW, screenH )
		end
	end )

    IsUVFrozen = false
    local effectDuration = 0
    local UVFreezeTime = 0

    local spottedCameraView = {}
    local cameraTransitionTime = 2
    local transitionStart = 0

    local copEnt = nil

    net.Receive("UVSpottedFreeze", function()
        effectDuration = net.ReadFloat()
        copEnt = net.ReadEntity()

        IsUVFrozen = true
        UVFreezeTime = RealTime() + effectDuration
        transitionStart = RealTime()

        if Glide then
            if Glide.Camera.isActive and IsValid(Glide.Camera.vehicle) then
                _OldGlideCameraFunction = Glide.Camera.ShouldBeActive
                Glide.Camera.ShouldBeActive = function()
                    return false
                end
            end
        end

        RunConsoleCommand("cl_drawhud", 0)
    end)

    net.Receive("UVSpottedUnfreeze", function()
        IsUVFrozen = false

        if Glide then
            if not Glide.Camera.isActive and IsValid(Glide.Camera.vehicle) and _OldGlideCameraFunction then
                Glide.Camera.ShouldBeActive = _OldGlideCameraFunction
            end
        end

        RunConsoleCommand("cl_drawhud", 1)
    end)

    local orbitYaw = 0

    gameevent.Listen( "player_spawn" ); hook.Add( "player_spawn", "UVOnLocalPlayerSpawn", function( data ) 
	    local id = data.userid

        if LocalPlayer():UserID() == id then
            UVLastVehicleDriven = nil
        end
    end )

    hook.Add("CalcView", "UVCalcView", function(ply, origin, angles, fov, znear, zfar)
        
        UVLastVehicleDriven = IsValid(UVGetVehicle(ply)) and UVGetVehicle(ply) or UVLastVehicleDriven
        local isVehicleValid = IsValid(UVLastVehicleDriven)

        --Spotted (SINGLEPLAYER)
        if IsUVFrozen and IsValid(copEnt) then

            local t = math.Clamp((RealTime() - transitionStart) / cameraTransitionTime, 0, 1)

            local copPos = copEnt:WorldSpaceCenter() or copEnt:GetPos()
            local plyPos = ply:GetPos()
            local dist = plyPos:Distance(copPos)
            
            local camPos = plyPos + ply:GetForward() * -300 + Vector(0, 0, 100)
            local camAng = (copPos - camPos):Angle()
            local camFov
            
            local normalized_dist = math.Clamp(dist / 5000, 0, 1)

            camFov = Lerp(normalized_dist, 30, 5)

            local currentView = {
                origin = ply:EyePos() + ply:GetForward() * -300 + Vector(0, 0, 100),
                angles = ply:EyeAngles(),
                fov = fov,
            }

            local spottedCameraView = {}

            spottedCameraView.origin = LerpVector(t, currentView.origin, camPos)
            spottedCameraView.angles = LerpAngle(t, currentView.angles, camAng)
            spottedCameraView.fov = Lerp(t, currentView.fov, camFov)

            return spottedCameraView
        end

        -- Dead
        if not ply:Alive() and isVehicleValid then
            local orbitDistance = 200

            local orbitSpeed = 45 

            orbitYaw = orbitYaw + (FrameTime() * orbitSpeed)
            
            local targetPos = UVLastVehicleDriven:GetPos()

            local camAngles = Angle(0, orbitYaw, 0)
            
            local camPos = targetPos + camAngles:Forward() * - orbitDistance

            camPos = camPos + (vector_up * 100)
            
            local view = {}
            view.origin = camPos
            view.angles = (targetPos - camPos):Angle()
            view.fov = 90
            view.drawviewer = false
            
            return view
        end

    end)

    if not isVehicleValid then
        UVLastVehicleDriven = nil
    end
	
	local HUDCountdownTick = nil

	-- Glyph tables
	UVKeyGlyphs = {}

	-- Keyboard & Mouse
	UVKeyGlyphs.kb = {
		["MOUSE1"] = "<color=51,150,218></color>" .. "", 
		["MOUSE2"] = "<color=51,150,218></color>" .. "", 
		["MOUSE3"] = "<color=51,150,218></color>" .. "", 
		["MOUSE4"] = "<color=51,150,218></color>" .. "", 
		["MOUSE5"] = "<color=51,150,218></color>" .. "", 
		["MWHEELDOWN"] = "<color=51,150,218></color>" .. "",
		["MWHEELUP"] = "<color=51,150,218></color>" .. "",
		
		["ö"] = "<color=51,51,51><color=255,255,255></color></color>",
		["ä"] = "<color=51,51,51><color=255,255,255></color></color>",
		["ì"] = "<color=51,51,51><color=255,255,255></color></color>",
		["è"] = "<color=51,51,51><color=255,255,255></color></color>",
		["é"] = "<color=51,51,51><color=255,255,255></color></color>",
		["ß"] = "<color=51,51,51><color=255,255,255></color></color>",
		["c"] = "<color=51,51,51><color=255,255,255></color></color>",
		["ò"] = "<color=51,51,51><color=255,255,255></color></color>",
		["à"] = "<color=51,51,51><color=255,255,255></color></color>",
		["ù"] = "<color=51,51,51><color=255,255,255></color></color>",
		["a"] = "<color=51,51,51><color=255,255,255></color></color>",
		["b"] = "<color=51,51,51><color=255,255,255></color></color>",
		["c"] = "<color=51,51,51><color=255,255,255></color></color>",
		["d"] = "<color=51,51,51><color=255,255,255></color></color>",
		["e"] = "<color=51,51,51><color=255,255,255></color></color>",
		["f"] = "<color=51,51,51><color=255,255,255></color></color>",
		["g"] = "<color=51,51,51><color=255,255,255></color></color>",
		["h"] = "<color=51,51,51><color=255,255,255></color></color>",
		["i"] = "<color=51,51,51><color=255,255,255></color></color>",
		["j"] = "<color=51,51,51><color=255,255,255></color></color>",
		["k"] = "<color=51,51,51><color=255,255,255></color></color>",
		["l"] = "<color=51,51,51><color=255,255,255></color></color>",
		["m"] = "<color=51,51,51><color=255,255,255></color></color>",
		["n"] = "<color=51,51,51><color=255,255,255></color></color>",
		["o"] = "<color=51,51,51><color=255,255,255></color></color>",
		["p"] = "<color=51,51,51><color=255,255,255></color></color>",
		["q"] = "<color=51,51,51><color=255,255,255></color></color>",
		["r"] = "<color=51,51,51><color=255,255,255></color></color>",
		["s"] = "<color=51,51,51><color=255,255,255></color></color>",
		["t"] = "<color=51,51,51><color=255,255,255></color></color>",
		["u"] = "<color=51,51,51><color=255,255,255></color></color>",
		["v"] = "<color=51,51,51><color=255,255,255></color></color>",
		["w"] = "<color=51,51,51><color=255,255,255></color></color>",
		["x"] = "<color=51,51,51><color=255,255,255></color></color>",
		["y"] = "<color=51,51,51><color=255,255,255></color></color>",
		["z"] = "<color=51,51,51><color=255,255,255></color></color>",
		["ü"] = "<color=51,51,51><color=255,255,255></color></color>",
		
		["0"] = "<color=51,51,51><color=255,255,255></color></color>",
		["1"] = "<color=51,51,51><color=255,255,255></color></color>",
		["2"] = "<color=51,51,51><color=255,255,255></color></color>",
		["3"] = "<color=51,51,51><color=255,255,255></color></color>",
		["4"] = "<color=51,51,51><color=255,255,255></color></color>",
		["5"] = "<color=51,51,51><color=255,255,255></color></color>",
		["6"] = "<color=51,51,51><color=255,255,255></color></color>",
		["7"] = "<color=51,51,51><color=255,255,255></color></color>",
		["8"] = "<color=51,51,51><color=255,255,255></color></color>",
		["9"] = "<color=51,51,51><color=255,255,255></color></color>",
		["'"] = "<color=51,51,51><color=255,255,255></color></color>",
		["*"] = "<color=51,51,51><color=255,255,255></color></color>",
		["+"] = "<color=51,51,51><color=255,255,255></color></color>",
		[","] = "<color=51,51,51><color=255,255,255></color></color>",
		["-"] = "<color=51,51,51><color=255,255,255></color></color>",
		
		["KP_SLASH"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_MULTIPLY"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_INS"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_END"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_DOWNARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_PGDN"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_LEFTARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_5"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_RIGHTARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_HOME"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_UPARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_PGUP"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_MINUS"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_PLUS"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_ENTER"] = "<color=51,51,51><color=255,255,255></color></color>",
		["KP_DEL"] = "<color=51,51,51><color=255,255,255></color></color>",
		
		["SPACE"] = "<color=51,51,51><color=255,255,255></color></color>",
		["DEL"] = "<color=51,51,51><color=255,255,255></color></color>",
		["BACKSPACE"] = "<color=51,51,51><color=255,255,255></color></color>",
		["TAB"] = "<color=51,51,51><color=255,255,255></color></color>",
		["ENTER"] = "<color=51,51,51><color=255,255,255></color></color>",
		["SHIFT"] = "<color=51,51,51><color=255,255,255></color></color>",
		["RSHIFT"] = "<color=51,51,51><color=255,255,255></color></color>",
		["CTRL"] = "<color=51,51,51><color=255,255,255></color></color>",
		["RCTRL"] = "<color=51,51,51><color=255,255,255></color></color>",
		["ALT"] = "<color=51,51,51><color=255,255,255></color></color>",
		["RALT"] = "<color=51,51,51><color=255,255,255></color></color>",
		["UPARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
		["DOWNARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
		["LEFTARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
		["RIGHTARROW"] = "<color=51,51,51><color=255,255,255></color></color>",
		["INS"] = "<color=51,51,51><color=255,255,255></color></color>",
		["END"] = "<color=51,51,51><color=255,255,255></color></color>",
		["F1"] = "<color=51,51,51><color=255,255,255></color></color>",
		["F2"] = "<color=51,51,51><color=255,255,255></color></color>",
		["F3"] = "<color=51,51,51><color=255,255,255></color></color>",
		["F4"] = "<color=51,51,51><color=255,255,255></color></color>",
		["F5"] = "<color=51,51,51><color=255,255,255></color></color>",
		["F6"] = "<color=51,51,51><color=255,255,255></color></color>",
		["F7"] = "<color=51,51,51><color=255,255,255></color></color>",
		["F8"] = "<color=51,51,51><color=255,255,255></color></color>",
		["F9"] = "<color=51,51,51><color=255,255,255></color></color>",
		["F10"] = "<color=51,51,51><color=255,255,255></color></color>",
		["F11"] = "<color=51,51,51><color=255,255,255></color></color>",
		["F12"] = "<color=51,51,51><color=255,255,255></color></color>",
		
		["["] = "<color=51,51,51><color=255,255,255></color></color>",
		["]"] = "<color=51,51,51><color=255,255,255></color></color>",
		["/"] = "<color=51,51,51><color=255,255,255></color></color>",
		["SEMICOLON"] = "<color=51,51,51><color=255,255,255></color></color>",
		["="] = "<color=51,51,51><color=255,255,255></color></color>",
		["\\"] = "<color=51,51,51><color=255,255,255></color></color>",
		["."] = "<color=51,51,51><color=255,255,255></color></color>",
		-- ["."] = "<color=51,51,51><color=255,255,255></color></color>",
		["CAPSLOCK"] = "<color=51,51,51><color=255,255,255></color></color>",
	}

	-- Unified Xbox controller glyphs
	UVKeyGlyphs.xbox = {
		-- Face buttons
		a = "<color=115,164,108><color=51,51,51></color></color>",
		b = "<color=206,89,89><color=51,51,51></color></color>",
		x = "<color=93,123,210><color=51,51,51></color></color>",
		y = "<color=227,194,45><color=51,51,51></color></color>",

		-- Face buttons (360)
		a360 = "<color=255,255,255><color=0,200,0></color></color>",
		b360 = "<color=255,255,255><color=200,0,0></color></color>",
		x360 = "<color=255,255,255><color=0,200,200></color></color>",
		y360 = "<color=255,255,255><color=225,225,0></color></color>",

		-- Face buttons (New)
		anew = "<color=51,51,51><color=255,255,255></color></color>",
		bnew = "<color=51,51,51><color=255,255,255></color></color>",
		xnew = "<color=51,51,51><color=255,255,255></color></color>",
		ynew = "<color=51,51,51><color=255,255,255></color></color>",

		-- Start / Back
		start  = "<color=255,255,255><color=51,51,51></color></color>",
		back   = "<color=255,255,255><color=51,51,51></color></color>",
		start360 = "<color=50,50,50></color>",
		back360  = "<color=50,50,50></color>",

		-- Triggers & Bumpers
		r2 = "<color=255,255,255></color>",
		r1 = "<color=255,255,255></color>",
		l2 = "<color=255,255,255></color>",
		l1 = "<color=255,255,255></color>",

		-- Sticks
		rs  = "<color=255,255,255></color>",
		rsc = "<color=255,255,255></color>",
		ls  = "<color=255,255,255></color>",
		lsc = "<color=255,255,255></color>",

		-- D-Pad
		du  = "<color=255,255,255></color>",
		dr  = "<color=255,255,255></color>",
		dd  = "<color=255,255,255></color>",
		dl  = "<color=255,255,255></color>",
		da  = "<color=255,255,255></color>",
		dlr = "<color=255,255,255></color>",
		dud = "<color=255,255,255></color>",
	}

	-- Unified PlayStation controller glyphs
	UVKeyGlyphs.ps = {
		-- Face buttons
		a = "<color=116,154,244><color=51,51,51></color></color>",
		b = "<color=255,100,96><color=51,51,51></color></color>",
		x = "<color=216,132,184><color=51,51,51></color></color>",
		y = "<color=128,176,128><color=51,51,51></color></color>",

		-- Face buttons
		anew = "<color=51,51,51><color=255,255,255></color></color>",
		bnew = "<color=51,51,51><color=255,255,255></color></color>",
		xnew = "<color=51,51,51><color=255,255,255></color></color>",
		ynew = "<color=51,51,51><color=255,255,255></color></color>",

		-- Special buttons
		share = "<color=255,255,255></color>",
		start = "<color=255,255,255></color>",
		pad   = "<color=96,96,96><color=34,34,34></color></color>",

		-- Triggers & Bumpers
		r1 = "<color=255,255,255></color>",
		r2 = "<color=255,255,255></color>",
		l1 = "<color=255,255,255></color>",
		l2 = "<color=255,255,255></color>",

		-- Sticks
		rs  = "<color=255,255,255></color>",
		rsc = "<color=255,255,255></color>",
		ls  = "<color=255,255,255></color>",
		lsc = "<color=255,255,255></color>",

		-- D-Pad
		du  = "<color=255,255,255></color>",
		dr  = "<color=255,255,255></color>",
		dd  = "<color=255,255,255></color>",
		dl  = "<color=255,255,255></color>",
		da  = "<color=255,255,255></color>",
		dlr = "<color=255,255,255></color>",
		dud = "<color=255,255,255></color>",
	}

	-- Unified Switch controller glyphs
	UVKeyGlyphs.switch = {
		-- Face buttons
		a = "<color=255,255,255><color=51,51,51></color></color>",
		b = "<color=255,255,255><color=51,51,51></color></color>",
		x = "<color=255,255,255><color=51,51,51></color></color>",
		y = "<color=255,255,255><color=51,51,51></color></color>",

		-- Start / Back
		start  = "<color=255,255,255><color=51,51,51></color></color>",
		back   = "<color=255,255,255><color=51,51,51></color></color>",

		-- Triggers & Bumpers
		r2 = "<color=255,255,255></color>",
		r1 = "<color=255,255,255></color>",
		l2 = "<color=255,255,255></color>",
		l1 = "<color=255,255,255></color>",

		-- Sticks
		rs  = "<color=255,255,255></color>",
		rsc = "<color=255,255,255></color>",
		ls  = "<color=255,255,255></color>",
		lsc = "<color=255,255,255></color>",

		-- D-Pad
		du  = "<color=255,255,255></color>",
		dr  = "<color=255,255,255></color>",
		dd  = "<color=255,255,255></color>",
		dl  = "<color=255,255,255></color>",
		da  = "<color=255,255,255></color>",
		dlr = "<color=255,255,255></color>",
		dud = "<color=255,255,255></color>",
	}

	local UVGlyphOverrideTable = {}
	local lastGlyphUpdate = -1
	local UVCommandFallbacks = {
		invnext = "MWHEELDOWN",  -- default glyph key
		invprev = "MWHEELUP",
		slot1   = "1",
		slot2   = "2",
		lastinv = "q",
	}

	local function UpdateGlyphOverrides()
		if lastGlyphUpdate == FrameNumber() then return end
		lastGlyphUpdate = FrameNumber()

		table.Empty(UVGlyphOverrideTable)

		if UVGlyphOverride:GetBool() ~= true then return end

		local raw = UVGlyphSet:GetString()
		if raw == "" then return end

		local lines = string.Split(raw, ", ")
		for _, line in ipairs(lines) do
			line = string.Trim(line)
			if line == "" then continue end

			local parts = string.Split(line, " ")
			if #parts >= 2 then
				local token = parts[1]
				local glyph = parts[2]
				UVGlyphOverrideTable[token] = glyph
			end
		end
	end

	local function ResolveGlyphOverride(token)
		UpdateGlyphOverrides()
		return UVGlyphOverrideTable[token]
	end

	-- The main functions
	function UVKeybindIcon(key, size)
		local font = "UVKeybindFont"  -- default
		if size == "Big" then
			font = "UVKeybindFontBig"
		elseif size == "Small" then
			font = "UVKeybindFontSmall"
		end
		
		local alpha = alpha or 255

		local wrap = function(str)
			return "<font=" .. font .. ">" .. str .. "</font>"
		end

		local parts = string.Split(key, ".")
		local glyph = "[" .. key .. "]"

		if #parts == 1 then
			if UVKeyGlyphs.kb[parts[1]] then
				glyph = UVKeyGlyphs.kb[parts[1]]
			end
		elseif #parts == 2 then
			local family, subkey = parts[1], parts[2]
			if family == "kb" and UVKeyGlyphs.kb[subkey] then
				glyph = UVKeyGlyphs.kb[subkey]
			elseif family == "mouse" and UVKeyGlyphs.mouse[subkey] then
				glyph = UVKeyGlyphs.mouse[subkey]
			elseif family == "xbox" and UVKeyGlyphs.xbox[subkey] then
				glyph = UVKeyGlyphs.xbox[subkey]
			elseif family == "ps" and UVKeyGlyphs.ps[subkey] then
				glyph = UVKeyGlyphs.ps[subkey]
			elseif family == "switch" and UVKeyGlyphs.switch[subkey] then
				glyph = UVKeyGlyphs.switch[subkey]
			elseif subkey == "all" then
				local tbl = UVKeyGlyphs[family]
				if tbl then
					local out = {}
					for _, glyph in pairs(tbl) do
						out[#out + 1] = glyph
					end
					glyph = table.concat(out, "")
				end
			end
		end

		return wrap(glyph)
	end

	local function ResolveKeybind(token)
		if token:sub(1, 1) == "+" then -- console command (+use, +jump, etc.)
			return input.LookupBinding(token, true)
		end

		local cv = GetConVar(token)
		if cv then
			return input.GetKeyName(cv:GetInt())
		end

		return nil
	end

	local function ResolveCommandGlyph(cmd)
		-- Check for user override first
		local override = ResolveGlyphOverride(cmd)
		if override then return override end

		local clean = cmd:gsub("^%+", "")
		-- Check fallback table
		if UVCommandFallbacks[clean] then return UVCommandFallbacks[clean] end

		-- Fallback to normal keybind
		return ResolveKeybind(cmd) or "???"
	end

	function UVReplaceKeybinds(str, glyphsize)
		local glyphsize = glyphsize or nil

		-- [+use] or [command]
		str = str:gsub("%[([%+]?[%w_]+)%]", function(cmd)
			return UVKeybindIcon(ResolveCommandGlyph(cmd), glyphsize)
		end)

		-- [key:convar_name]
		str = str:gsub("%[key:([%w_]+)%]", function(cvar)
			local override = ResolveGlyphOverride("key:" .. cvar)
			if override then
				return UVKeybindIcon(override, glyphsize)
			end

			local key = ResolveKeybind(cvar)
			if not key then return "???" end
			return UVKeybindIcon(key, glyphsize)
		end)

		-- [string:phrase]
		str = str:gsub("%[string:([^%]]+)%]", function(locstring)
			return "<color=255,255,0>" .. UVString(locstring) .. "</color>"
		end)

		-- [ncstring:phrase] -- Without colour
		str = str:gsub("%[ncstring:([^%]]+)%]", function(locstring)
			return UVString(locstring)
		end)

		-- [glyph:phrase]
		str = str:gsub("%[glyph:([^%]]+)%]", function(glyph)
			return UVKeybindIcon(glyph, glyphsize)
		end)

		return str
	end

	function UVDiscordTextFormat(str)
	str = str:gsub("%*%*(.-)%*%*", "<font=UVSettingsFontSmall-Bold>%1</font>")
	str = str:gsub("(%s)%*(.-)%*", "<font=UVSettingsFontSmall-Italic> %2 </font>")
	str = str:gsub("^%*(.-)%*", "[i]%1[/i]")
	str = str:gsub("__(.-)__", "[u]%1[/u]")
	str = str:gsub("^#%s*(.-)\n", "<font=UVSettingsFontBig>%1</font>\n")
	str = str:gsub("\n#%s*(.-)\n", "\n<font=UVSettingsFontBig>%1</font>\n")
	return str
end

	UVHUDTimedBars = UVHUDTimedBars or {}
	UVHUDActiveBar = UVHUDActiveBar or nil
	
	function UVHUD_AddTimedBar(id, duration, labelToken, priority, label2, args, reversedTexts)
		local now = CurTime()

		UVHUDTimedBars[id] = {
			id = id,
			label = labelToken,
			label2 = label2,
			priority = priority or 0,

			startTime = now,
			endTime = now + duration,

			closeTime = nil,
			hidden = false,
			args = args,
			reversedTexts = reversedTexts or false
		}
	end
	
	function UVHUD_CloseTimedBar(id)
		local bar = UVHUDTimedBars[id]
		if not bar then return end

		if not bar.closeTime then
			bar.closeTime = CurTime()
		end
	end
	
	function UVHUD_GetTopBar()
		local best = nil

		for _, bar in pairs(UVHUDTimedBars) do

			if not bar.closeTime then
				if not best or bar.priority > best.priority then
					best = bar
				end
			end
		end

		return best
	end

	function UVHUD_TimedBar(bar)
		local w, h = ScrW(), ScrH()
		
		local now = CurTime()
		local realTime = RealTime()
		
		local startTime = bar.startTime
		local endTime = bar.endTime
		local labelToken = bar.label
		local label2Token = bar.label2
		local closingTime = bar.closeTime
		local reverseTexts = bar.reversedTexts
		
		local animTime = now - startTime

		-- Phase durations
		local delay = 0.1
		local expandDuration = 0.25
		local whiteFadeInDuration = 0.025
		local blackFadeOutDuration = 1

		local expandStart = delay
		local whiteStart = expandStart + expandDuration
		local blackStart = whiteStart + whiteFadeInDuration
		local endAnim = blackStart + blackFadeOutDuration

		-- Compute bar width
		local currentWidth

		if closingTime then
			local retractDuration = 0.25
			local p = math.Clamp((now - closingTime) / retractDuration, 0, 1)

			currentWidth = Lerp(p, w, 0)
		else
			local barProgress = 0
			if animTime >= expandStart then
				barProgress = math.Clamp((animTime - expandStart) / expandDuration, 0, 1)
			end

			currentWidth = Lerp(barProgress, 0, w)
		end

		local barHeight = h * (label2Token == "" and 0.05 or 0.075)
		local barX = (w - currentWidth) / 2
		local barY = h - barHeight

		-- Compute bar color
		local colorVal = 0
		if animTime >= whiteStart and animTime < blackStart then
			-- black → white
			local p = (animTime - whiteStart) / whiteFadeInDuration
			colorVal = Lerp(math.Clamp(p, 0, 1), 0, 255)
		elseif animTime >= blackStart then
			-- white → black
			local p = (animTime - blackStart) / blackFadeOutDuration
			colorVal = Lerp(math.Clamp(p, 0, 1), 255, 0)
		end
		
		if not closingTime and now >= endTime then
			UVHUD_CloseTimedBar(bar.id)
		end

		-- Only draw when HUD is enabled
		if GetConVar("cl_drawhud"):GetBool() then
			-- Draw bar
			surface.SetMaterial(UVMaterials["RESPAWN_BG"])
			surface.SetDrawColor(Color(colorVal, colorVal, colorVal, 255))
			surface.DrawTexturedRect(barX, barY, currentWidth, barHeight)

			-- Display text only after bar is white or fading
			if animTime >= whiteStart then
				-- local timeLeft = math.max(0, math.floor(endTime - now + 0.999))
				
				local timeLeft = math.max(0, endTime - now)  -- numeric
				local timeLeftStr

				-- Choose decimal precision
				if timeLeft > 10 then
					timeLeftStr = string.format("%.0f", timeLeft)  -- 0 decimals
				else
					timeLeftStr = string.format("%.1f", timeLeft)  -- 1 decimal
				end

				-- Blink red depending on time left
				local blink = 255 * math.abs(math.sin(realTime * 4))
				local blink2 = 255 * math.abs(math.sin(realTime * 6))
				local blink3 = 255 * math.abs(math.sin(realTime * 8))
				local redblink = 255

				if not noblink then
					if timeLeft >= 10 then
						redblink = redblink
					elseif timeLeft >= 5 then
						redblink = blink
					elseif timeLeft >= 3 then
						redblink = blink2
					else
						redblink = blink3
					end
				end

				-- Draw Text
				local text1, text2 = UVString(labelToken), timeLeftStr
				local textAlpha = 255
		
				local formatStr = UVString(labelToken)

				if bar.args then
					text1 = string.format(formatStr, unpack(bar.args), timeLeftStr)
				else
					text1 = string.format(formatStr, timeLeftStr)
				end

				if closingTime then
					local fadeDur = 0.1
					local t = math.Clamp((now - closingTime) / fadeDur, 0, 1)
					textAlpha = 1 - t
				end

				if label2Token then
					local ytextpos = h * 0.925

					if label2Token == "" then
						ytextpos = h * 0.955
					end

					text2 = UVString(label2Token)
				end

				surface.SetAlphaMultiplier(textAlpha)
				if reverseTexts then
					markup.Parse( "<font=UVSettingsFontBig>" .. text2 .. "</font>", w ):Draw(w * 0.5, h * 0.925, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					markup.Parse( "<font=UVSettingsFontBig>" .. text1 .. "</font>", w ):Draw(w * 0.5, h * 0.96, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				else
					markup.Parse( "<font=UVSettingsFontBig>" .. text1 .. "</font>", w ):Draw(w * 0.5, h * 0.925, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					markup.Parse( "<font=UVSettingsFontBig>" .. text2 .. "</font>", w ):Draw(w * 0.5, h * 0.96, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
				surface.SetAlphaMultiplier(1)
			end
		end
	end

end

function Carbon_FormatRaceTime(curTime)
    local minutes = math.floor(curTime / 60)
    local seconds = math.floor(curTime % 60)
    local milliseconds = math.floor((curTime % 1) * 100)
    
    if minutes > 0 then
        return string.format("%d:%02d.%02d", minutes, seconds, milliseconds)
    else
        return string.format("%01d.%02d", seconds, milliseconds)
    end
end

function UV_FormatRaceEndTime(seconds)
    if not seconds then return nil end
    if type(seconds) == "string" then
        return seconds
    elseif type(seconds) == "number" then
        local minutes = math.floor(seconds / 60)
        local secs = seconds % 60
        return string.format("%d:%05.2f", minutes, secs)
    else
        return "NIL"
    end
end

function NightRunners_FormatRaceTime(seconds)
    if not seconds then return nil end
    if type(seconds) == "string" then
        return seconds
    elseif type(seconds) == "number" then
        local minutes = math.floor(seconds / 60)
        local secs = seconds % 60
		minutes = (minutes < 10 and "0" .. minutes) or minutes
        return string.format("%s:%05.2f", minutes, secs)
    else
        return "NIL"
    end
end

UV_UI = UV_UI or {}

function UV_GetOffsetX()
    if not UV.DebugRes then return 0 end

    local realW = ScrW()
    local debugW = UV_GetW()

    return (realW - debugW) * 0.5
end

function UV_GetOffsetY()
    if not UV.DebugRes then return 0 end

    local realH = ScrH()
    local debugH = UV_GetH()

    return (realH - debugH) * 0.5
end

function UV_UI.GetSide(x, screenW)
    if x > screenW * 0.55 then return 1 end
    if x < screenW * 0.45 then return -1 end
    return 0
end

function UV_UI.ScaleX(x, scale, screenW)
    local centerX = screenW * 0.5
    return centerX + (x - centerX) * scale
end

function UV_UI.ResolveX(x, scale, deadzone, screenW)
    local side = UV_UI.GetSide(x, screenW)
    local scaledX = UV_UI.ScaleX(x, scale, screenW)

    if side == 1 then
        return scaledX - deadzone
    elseif side == -1 then
        return scaledX + deadzone
    end

    return scaledX
end

function UV_UI.ScaleW(width, scale)
    return width * scale
end

function UV_UI.X(x)
    local w = UV_GetW()
    local scale = math.Clamp(UVHUDXScale:GetFloat(), 0.1, 1)
    local deadzone = math.Clamp(UVHUDXDeadzone:GetFloat(), 0, 500)

    local resolved = UV_UI.ResolveX(x, scale, deadzone, w)

    return UV_GetOffsetX() + resolved
end

function UV_UI.XScaled(x)
    local w = UV_GetW()
    local scale = math.Clamp(UVHUDXScale:GetFloat(), 0.1, 1)

    local centerX = w * 0.5
    local result = centerX + (x - centerX) * scale

    return UV_GetOffsetX() + result
end

function UV_UI.Y(y)
    return UV_GetOffsetY() + y
end

function UV_UI.YScaled(y)
    local h = UV_GetH()
    local centerY = h * 0.5

    return UV_GetOffsetY() + (centerY + (y - centerY))
end

function UV_UI.W(width)
    local scale = math.Clamp(UVHUDXScale:GetFloat(), 0.1, 1)
    return width * scale
end


for _, v in pairs( {'racing', 'pursuit'} ) do
    UV_UI[v] = UV_UI[v] or {}
end

-- Universal
function DrawIcon(material, x, y, height_ratio, color, args)
    local tex = material:GetTexture("$basetexture")
    
    if tex then
        local texW, texH = tex:Width(), tex:Height()
        local aspect = texW / texH
        
        local desiredHeight = UV_GetH() * height_ratio
        local desiredWidth = desiredHeight * aspect

        if args and args.sizeOffsets then
            desiredHeight = desiredHeight + ( UV_GetH() * (args.sizeOffsets.y or 0) )
            desiredWidth = desiredWidth + ( UV_GetW() * (args.sizeOffsets.x or 0) )
        end
   
        -- Center coords for DrawTexturedRectRotated
        local centerX = x
        local centerY = y
        
        if color then
            surface.SetDrawColor(color:Unpack())
        else
            surface.SetDrawColor(255, 255, 255)
        end
        
        surface.SetMaterial(material, args)
        
        -- Check if 'args' table contains 'rotation' key
        if args and args.rotation then
            surface.DrawTexturedRectRotated(centerX, centerY, desiredWidth, desiredHeight, args.rotation)
        else
            local offsetX = args and args.sizeOffsets and args.sizeOffsets.x or 0
            local offsetY = args and args.sizeOffsets and args.sizeOffsets.y or 0
            local drawX = x - desiredWidth  / 2 + offsetX
            local drawY = y - desiredHeight / 2 + offsetY
            surface.DrawTexturedRect(drawX, drawY, desiredWidth, desiredHeight)
        end
    end
end

function UVRenderCommander(ent)
    local localPlayer = LocalPlayer()
    local box_color = Color(0, 161, 255)
    local lang = UVString
    
    if IsValid(ent) then
        if not UVHUDDisplayPursuit then return end
        
        local callsign = lang("uv.unit.commander")
        local driver = UVGetDriver(ent)
        local notitext = "uv.unit.commander.noti"
        
        -- if driver and driver:IsPlayer() then
        if driver then
            callsign = driver:IsPlayer() and driver:GetName() or lang("uv.unit.commander")
            if not ent.lplayernotified then
                ent.lplayernotified = true
                if localPlayer == driver then
                    notitext = "uv.unit.commander.noti.you"
                end
                if Glide then
                    Glide.Notify( {
                        text = "<color=61,183,255>" .. UVString(notitext),
                        icon = "unitvehicles/icons/MINIMAP_ICON_EVENT_RIVAL.png",
                        lifetime = 5,
                        immediate = true
                    } )
                else
                    chat.AddText(
                    Color(0, 81, 161), "[Unit Vehicles] ",
                    Color(61, 183, 255), UVString(notitext) )
                end
                return
            end
        end
		
		if localPlayer == driver then return end
		
		-- Anchor point at vehicle origin (or lightly above)
		local anchorPos = ent:GetPos() + Vector(0, 0, 70) -- Light lift to target roof

		-- Convert to 2D screen space
		local screenPos = anchorPos:ToScreen()
		if not screenPos.visible then return end

		-- Fixed screen offset (so it doesn’t drift with distance)
		local textX = screenPos.x
		local textY = screenPos.y - 120 -- This is in pixels and stays consistent
		
        local w = UV_GetW()
        local h = UV_GetH()
        
        local dist = localPlayer:GetPos():Distance(ent:GetPos())
        local distInMeters = dist * 0.01905

        -- Distance in meters
        local fadeAlpha = 255
        local fadeDist = RacerTagsDistance:GetInt() or 100
        
        if distInMeters <= fadeDist then
            fadeAlpha = 255 * ((fadeDist - distInMeters) / 25)
        elseif distInMeters > fadeDist then
            fadeAlpha = 0
        end

		-- Edge fade (screen position based)
		local edgeFadeAlpha = 255

		local edgeStartX = w * 0.2
		local edgeEndX = w * 0.8
		local edgeStartY = h * 0.2
		local edgeEndY = h * 0.8

		-- Horizontal fade
		if textX < w * 0.05 or textX > w * 0.95 then
			edgeFadeAlpha = 0
		elseif textX < edgeStartX then
			edgeFadeAlpha = 255 * ((textX - w * 0.05) / (edgeStartX - w * 0.05))
		elseif textX > edgeEndX then
			edgeFadeAlpha = 255 * ((w * 0.95 - textX) / (w * 0.95 - edgeEndX))
		end

		-- Vertical fade
		if textY < h * 0.05 or textY > h * 0.95 then
			edgeFadeAlpha = math.min(edgeFadeAlpha, 0)
		elseif textY < edgeStartY then
			edgeFadeAlpha = math.min(edgeFadeAlpha, 255 * ((textY - h * 0.05) / (edgeStartY - h * 0.05)))
		elseif textY > edgeEndY then
			edgeFadeAlpha = math.min(edgeFadeAlpha, 255 * ((h * 0.95 - textY) / (h * 0.95 - edgeEndY)))
		end

		-- Combine with distance fade
		fadeAlpha = math.min(fadeAlpha, edgeFadeAlpha)
	
		local feet  = distInMeters * 3.28084
		local yards = distInMeters * 1.09361

		local unitType = GetConVar("unitvehicle_unitstype"):GetInt() -- 0=M,1=FT,2=YD

		local displayDist, displayString
		if unitType == 1 then
			displayDist = feet
			displayString = UVString("uv.dist.feet")
		elseif unitType == 2 then
			displayDist = yards
			displayString = UVString("uv.dist.yards")
		else
			displayDist = distInMeters
			displayString = UVString("uv.dist.meter")
		end
		
        cam.Start2D()
			if not GetConVar("cl_drawhud"):GetBool() then return end
			
			-- local bustdist = math.Round(displayDist) .. " m"
			
			local bustdist = string.format( displayString, math.Round(displayDist) )
			
			local cname = lang("uv.unit.commander")
			if IsValid(UVHUDCommander) then
				local driver = UVHUDCommander:GetDriver()
				if IsValid(driver) and driver:IsPlayer() then
					cname = driver:Nick()
				end
			end

			surface.SetFont("UVFont4")
			local textWidth, textHeight = surface.GetTextSize(cname)
			local textWidthDist, textHeightDist = surface.GetTextSize(bustdist)
			local padding = 10
			local distpadding = 5

			local rectywidth = math.max(textWidthDist + textWidth + padding, 0)
			local rectxpos = textX - (rectywidth / 2)
			local rectypos = textY + 22.5

			local thickness = RacerTagsThickness:GetInt() or 2

			surface.SetDrawColor( box_color.r, box_color.g, box_color.b, fadeAlpha )
			surface.DrawOutlinedRect( rectxpos - thickness, rectypos - thickness, rectywidth + (thickness * 2), textHeight + thickness, thickness )

			surface.SetMaterial(UVMaterials["ARROW_CARBON"])
			surface.DrawTexturedRectRotated( textX, textY + 57.5, 15, 15, -90)

			surface.SetDrawColor( 0, 0, 0, math.min(200, fadeAlpha) )
			surface.DrawRect( rectxpos, rectypos, rectywidth, textHeight - thickness)

			draw.RoundedBox( 0, rectxpos - thickness, rectypos - thickness, textWidthDist + distpadding, textHeight + thickness, Color( box_color.r, box_color.g, box_color.b, math.Clamp(fadeAlpha, 0, 100) ) )

			draw.SimpleTextOutlined(cname, "UVFont4", rectxpos + textWidthDist + distpadding, rectypos - thickness, Color(255, 255, 255, fadeAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.25, Color(0, 0, 0, fadeAlpha) )
			draw.SimpleTextOutlined(bustdist, "UVFont4", rectxpos, rectypos - thickness, Color(255, 255, 255, fadeAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.25, Color(0, 0, 0, fadeAlpha) )

        cam.End2D()
    end
end

local function FormatBountyShort(n)
    if n >= 1000000 then
        local m = n / 1000000
        return (m % 1 == 0) and (math.floor(m) .. "m") or (string.format("%.1fm", m))
    elseif n >= 1000 then
        local k = n / 1000
        return (k % 1 == 0) and (math.floor(k) .. "k") or (string.format("%.1fk", k))
    else
        return tostring(n)
    end
end

local function UVDrawBustAndDistance(ent, textX, textY, fadeAlpha, box_color, h)
    if not GetConVar("cl_drawhud"):GetBool() then return end
	if BustedTimer:GetInt() == 0 then return end
	
    local scope = UVGetScope(ent)
	
	if not scope then return end

    local bustpro = math.Clamp(math.floor((((ent.UVBustingProgress or 0) / BustedTimer:GetInt()) * 100) + .5), 0, 100)

    local targetAlpha = bustpro >= 4 and 1 or 0
    local targetOffset = bustpro >= 2 and -20 or -40

    ent._bustAlpha = math.Approach(ent._bustAlpha or 0, fadeAlpha * targetAlpha, FrameTime() * 600)
    ent._bustOffset = Lerp(FrameTime() * 10, ent._bustOffset or 0, targetOffset)
	
	local baseY = textY + ent._bustOffset

	-- spacing control (tweak these freely)
	local textOffset = -h * 0.02     -- text sits above
	local barOffset  =  h * 0.005    -- bar sits below
	
    local y = baseY + barOffset

    if ent._bustAlpha > 0 and ent.beingbusted then
        local barW = 120
        local barH = h * 0.0125
        local x = textX - (barW / 2)

        local T = math.Clamp(((ent.UVBustingProgress or 0) / BustedTimer:GetInt()) * barW, 0, barW)

        surface.SetDrawColor(100, 100, 100, ent._bustAlpha)
        surface.DrawRect(x, y, barW, barH)

        surface.SetDrawColor(255, 0, 0, ent._bustAlpha)
        surface.DrawRect(x, y, T, barH)
    end

    if ent._bustAlpha > 0 then
        local text = scope.InPursuit and "uv.chase.busting.other" or "uv.chase.fining"

        draw.SimpleTextOutlined( UVString(text), "UVFont4", textX, baseY + textOffset, Color(box_color.r, box_color.g, box_color.b, ent._bustAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 2, Color(0,0,0,ent._bustAlpha) )
    end
end

function UVRenderEnemySquare(ent)
    if not IsValid(ent) then return end
    if not RacerTags:GetBool() then return end
    
    local localPlayer = LocalPlayer()
    local box_color = (not UVHUDCopMode and Color(255, 255, 255)) or Color( 255, 132, 0 )
    local blink = 255 * math.abs(math.sin(RealTime() * 4))
    local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
    local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
    
    local lang = UVString
    
    local entbustedtimeleft = math.Round((BustedTimer:GetFloat()-(ent.UVBustingProgress or 0)),3)
    
    if ent.beingbusted then
        if (entbustedtimeleft > 2 and entbustedtimeleft < 3) then
            box_color = Color( 255, blink, blink)
        elseif entbustedtimeleft < 2 then
            box_color = Color( 255, blink2, blink2)
        elseif entbustedtimeleft < 1 then
            box_color = Color( 255, blink3, blink3)
        end
    end
	
    ent._bustAlpha = ent._bustAlpha or 0
	ent._bustOffset = ent._bustOffset or 0

	if IsValid(ent) then
		local scope = UVGetScope(ent)
		
		if not scope then return end
		
		if not UVHUDCopMode and not (UVHUDDisplayPursuit or UVHUDDisplayRacing) then return end

		-- Unfucked, clarified logic: hide enemy square as cop during cooldown, or if there are no units chasing or out of unit view,
		-- except when one-commander-evading is actually active (and one commander is active)
		if UVHUDCopMode then
			if not ent.inunitview then return end
		end

		if UVHUDRaceInfo and UVHUDRaceInfo.Participants and UVHUDRaceInfo.Participants[ent] then
			local pdata = UVHUDRaceInfo.Participants[ent]
			if (not UVHUDCopMode) and pdata.Finished or pdata.Disqualified or pdata.Busted then
				return
			end
		end

		if UVHUDCopMode then
			if not scope.InPursuit then
				box_color = Color( 255, 207, 63)
			end
			if scope.IsBeingPulledOver then
				local red = math.Remap( math.sin(SysTime() * 8), -1, 1, 0, 255 )
				local blue = math.Remap( math.sin(SysTime() * 8), -1, 1, 255, 0 )

				box_color = Color( red, 0, blue )
			end
		end
		
		local enemycallsign = UVGetDriverName(ent)
		local enemypos = false
		
		if UVHUDRaceInfo then
			local function GetRacerPositionForEntity(ent)
				if UVHUDCopMode then return end
				if not UVHUDRaceInfo.Participants then return nil end

				local sorted_table, string_array = UVFormLeaderboard(UVHUDRaceInfo.Participants)
				if not istable(sorted_table) or not istable(string_array) then return nil end

				for i, entry in ipairs(string_array) do
					local participant_ent = nil
					if sorted_table[i] then
						participant_ent = sorted_table[i].vehicle
					end

					if participant_ent == ent then
						return i
					end
				end

				return nil
			end

			-- Fallback: use name from leaderboard data
			if not UVHUDCopMode then
				if UVHUDRaceInfo and UVHUDRaceInfo.Participants then
					local racerInfo = UVHUDRaceInfo.Participants[ent]
					if racerInfo then
						local pos = GetRacerPositionForEntity(ent)
						if pos then
							-- enemypos = UVString("uv.race.pos.num." .. pos)
							enemypos = pos
						end
						if racerInfo.Name then
							enemycallsign = racerInfo.Name
						end
					end
				end
			end
		end

		-- Anchor point at vehicle origin (or lightly above)
		local anchorPos = ent:GetPos() + Vector(0, 0, 70) -- Light lift to target roof

		-- Convert to 2D screen space
		local screenPos = anchorPos:ToScreen()
		if not screenPos.visible then return end

		-- Fixed screen offset (so it doesn’t drift with distance)
		local textX = screenPos.x
		local textY = screenPos.y - 90 -- This is in pixels and stays consistent

        local w = UV_GetW()
        local h = UV_GetH()
        
        -- Distance in meters
        local fadeAlpha = 255
        local fadeDist = RacerTagsDistance:GetInt() or 100

        local dist = localPlayer:GetPos():Distance(ent:GetPos())
        local distInMeters = dist * 0.01905
        
        if not UVHUDCopMode then
            if distInMeters <= fadeDist then
                fadeAlpha = 255 * ((fadeDist - distInMeters) / 25)
            elseif distInMeters > fadeDist then
                fadeAlpha = 0
            end
        end
		
		-- Edge fade (screen position based)
		local edgeFadeAlpha = 255

		local edgeStartX = w * 0.2
		local edgeEndX = w * 0.8
		local edgeStartY = h * 0.2
		local edgeEndY = h * 0.8

		-- Horizontal fade
		if textX < w * 0.05 or textX > w * 0.95 then
			edgeFadeAlpha = 0
		elseif textX < edgeStartX then
			edgeFadeAlpha = 255 * ((textX - w * 0.05) / (edgeStartX - w * 0.05))
		elseif textX > edgeEndX then
			edgeFadeAlpha = 255 * ((w * 0.95 - textX) / (w * 0.95 - edgeEndX))
		end

		-- Vertical fade
		if textY < h * 0.05 or textY > h * 0.95 then
			edgeFadeAlpha = math.min(edgeFadeAlpha, 0)
		elseif textY < edgeStartY then
			edgeFadeAlpha = math.min(edgeFadeAlpha, 255 * ((textY - h * 0.05) / (edgeStartY - h * 0.05)))
		elseif textY > edgeEndY then
			edgeFadeAlpha = math.min(edgeFadeAlpha, 255 * ((h * 0.95 - textY) / (h * 0.95 - edgeEndY)))
		end

		-- Combine with distance fade
		fadeAlpha = math.min(fadeAlpha, edgeFadeAlpha)

		if #enemycallsign > 20 then -- If too long
			enemycallsign = string.sub(enemycallsign, 1, 20 - 3) .. "..."
		end

		ent._bustAlpha = ent._bustAlpha or 0
		ent._bustOffset = ent._bustOffset or 0
	
		local feet  = distInMeters * 3.28084
		local yards = distInMeters * 1.09361

		local unitType = GetConVar("unitvehicle_unitstype"):GetInt() -- 0=M,1=FT,2=YD

		local displayDist, displayString
		if unitType == 1 then
			displayDist = feet
			displayString = UVString("uv.dist.feet")
		elseif unitType == 2 then
			displayDist = yards
			displayString = UVString("uv.dist.yards")
		else
			displayDist = distInMeters
			displayString = UVString("uv.dist.meter")
		end

        cam.Start2D()
			if not GetConVar("cl_drawhud"):GetBool() then return end
			local pos = ent:GetPos() + Vector(0, 0, 80)
			local bustpro = math.Clamp(math.floor((((ent.UVBustingProgress or 0) / BustedTimer:GetInt()) * 100) + .5), 0, 100)
			local bustdist = math.Round(distInMeters) .. " m"

			bustdist = string.format( displayString, math.Round(displayDist) )

			enemypos = enemypos or bustdist

			surface.SetFont("UVFont4")
			local textWidth, textHeight = surface.GetTextSize(enemycallsign)
			local textWidthDist, textHeightDist = surface.GetTextSize(enemypos)
			local padding = 10
			local distpadding = 5

			local rectywidth = math.max(textWidth + textWidthDist + padding, 0)
			local rectxpos = textX - (rectywidth / 2)
			local rectypos = textY + 17.5

			local targetAlpha = bustpro >= 4 and 1 or 0
			local targetOffset = bustpro >= 2 and -20 or -40

			local thickness = RacerTagsThickness:GetInt() or 2

			-- Smoothly approach the target alpha and offset
			ent._bustAlpha = math.Approach(ent._bustAlpha, fadeAlpha * targetAlpha, FrameTime() * 600)
			ent._bustOffset = Lerp(FrameTime() * 10, ent._bustOffset, targetOffset)

			if UVHUDRaceInfo and UVHUDRaceInfo.Participants then -- Race

				surface.SetDrawColor( box_color.r, box_color.g, box_color.b, fadeAlpha )
				surface.DrawOutlinedRect( rectxpos - thickness, rectypos - thickness, rectywidth + (thickness * 2), textHeight + thickness, thickness )
				
				surface.SetMaterial(UVMaterials["ARROW_CARBON"])
				surface.DrawTexturedRectRotated( textX, textY + 57.5, 15, 15, -90)

				surface.SetDrawColor( 0, 0, 0, math.min(200, fadeAlpha) )
				surface.DrawRect( rectxpos, rectypos, rectywidth, textHeight - thickness)
				draw.RoundedBox( 0, rectxpos - thickness, rectypos - thickness, textWidthDist + distpadding, textHeight + thickness, Color( 255, 255, 255, fadeAlpha ) )

				draw.SimpleTextOutlined(enemycallsign, "UVFont4", rectxpos + textWidthDist + distpadding, rectypos - thickness, Color(255, 255, 255, fadeAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, Color(0, 0, 0, fadeAlpha) )
				draw.SimpleTextOutlined(enemypos or busdist, "UVFont4", rectxpos - (thickness * 0.5), rectypos - thickness, Color(255, 255, 255, fadeAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, Color(0, 0, 0, fadeAlpha) )
				
				UVDrawBustAndDistance( ent, rectxpos + (rectywidth / 2), rectypos - textHeight - thickness - ent._bustOffset, fadeAlpha, box_color, h * 1 )
				
			else -- Pursuit

				-- Distance thresholds
				local HEAT_EXPAND_DIST   = 60
				local HEAT_FADE_DIST     = 50

				local BOUNTY_EXPAND_DIST = 80
				local BOUNTY_FADE_DIST   = 70

				-- Expand / fade values
				local function CalcExpandFade(dist, expandDist, fadeDist, fadeRange)
					local expand = 0
					local fade = 0

					if dist < expandDist then
						expand = math.Clamp((expandDist - dist) / (expandDist - fadeDist), 0, 1)
					end

					if dist < fadeDist then
						fade = math.Clamp((fadeDist - dist) / fadeRange, 0, 1)
					end

					return expand, fade
				end

				local heatExpand, heatFade     = CalcExpandFade(distInMeters, HEAT_EXPAND_DIST, HEAT_FADE_DIST, 20)
				local bountyExpand, bountyFade = CalcExpandFade(distInMeters, BOUNTY_EXPAND_DIST, BOUNTY_FADE_DIST, 15)

				-- Text content
				local bountyText
				if scope.InPursuit then
					bountyText = "$" .. FormatBountyShort(scope.Bounty)
				else
					bountyText = "$" .. FormatBountyShort(scope.FinesDue)
				end

				surface.SetFont("UVFont4")

				local nameW   = textWidth
				local bountyW = surface.GetTextSize(bountyText)
				local heatW   = surface.GetTextSize(tostring(scope.Heat))

				local maxTextWidth = math.max(nameW, bountyW, heatW)
				local padding = 20

				local rectywidth = math.max(maxTextWidth + padding, 0)
				local rectxpos = textX - (rectywidth / 2)

				-- Height (bottom anchored)
				local baseHeight = textHeight * 2 -- name + bounty baseline

				local totalHeight =
					textHeight +                                -- name
					(textHeight * bountyExpand) +               -- bounty space
					(textHeight * heatExpand)                   -- heat space

				local dynamicOffset = totalHeight - baseHeight
				local boxY = rectypos - dynamicOffset

				-- Box
				surface.SetDrawColor(box_color.r, box_color.g, box_color.b, fadeAlpha)
				surface.DrawOutlinedRect( rectxpos - thickness, boxY - thickness, rectywidth + (thickness * 2), totalHeight + (thickness * 2), thickness )

				surface.SetDrawColor(0, 0, 0, math.min(200, fadeAlpha))
				surface.DrawRect(rectxpos, boxY, rectywidth, totalHeight)

				-- Content stacking
				local currentY = boxY

				-- NAME (always)
				draw.SimpleTextOutlined( enemycallsign, "UVFont4", rectxpos + (rectywidth / 2), currentY - thickness, Color(255,255,255,fadeAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1.25, Color(0,0,0,fadeAlpha) )

				currentY = currentY + textHeight

				-- BOUNTY (baseline)
				do
					local alpha = fadeAlpha * math.max(bountyFade) -- slight presence even before fade
					draw.SimpleTextOutlined( bountyText, "UVFont4", rectxpos + (rectywidth / 2), currentY, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1.25, Color(0,0,0,alpha) )
				end

				currentY = currentY + (textHeight * bountyExpand)

				-- HEAT (top layer)
				if heatFade > 0 then
					local alpha = fadeAlpha * heatFade

					surface.SetDrawColor(255,255,255,alpha)
					surface.SetMaterial(UVMaterials["HEAT"])
					surface.DrawTexturedRect( rectxpos + (rectywidth / 2) - (textHeight * 0.75), currentY, textHeight, textHeight )

					draw.SimpleTextOutlined( scope.Heat, "UVFont4", rectxpos + (rectywidth / 2 + (textHeight * 0.25)), currentY, Color(255,255,255,alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.25, Color(0,0,0,alpha) )
				end

				-- Distance text
				draw.SimpleTextOutlined( bustdist, "UVFont4BiggerItalic2", rectxpos + (rectywidth / 2), rectypos - textHeight - totalHeight - thickness - ent._bustOffset, Color(255,255,255,fadeAlpha - ent._bustAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1.25, Color(0,0,0,fadeAlpha - ent._bustAlpha) )
				
				UVDrawBustAndDistance( ent, rectxpos + (rectywidth / 2), rectypos + textHeight - totalHeight - thickness - ent._bustOffset, fadeAlpha, box_color, h * 1 )

				-- Arrow
				surface.SetDrawColor(255,255,255,fadeAlpha)
				surface.SetMaterial(UVMaterials["ARROW_CARBON"])
				surface.DrawTexturedRectRotated( rectxpos + (rectywidth / 2), boxY + totalHeight + padding - 7.5, 15, 15, -90 )
			end
        cam.End2D()
    end
end

function mw_noti_draw(text, font, x, y, color, colorbg)
    surface.SetFont(font)
    local lines = string.Explode("\n", text)
    
    local lH = {}
    local mW = 0
    local tH = 0
    
    for _, line in ipairs(lines) do
        local w, h = surface.GetTextSize(line)
        table.insert( lH, h )
        mW = math.max( mW, w )
        tH = tH + h
    end
    
    local currentY = y - tH/2
    
	if not colorbg then colorbg = Color(0, 0, 0) end
	
    for i, line in ipairs(lines) do
        local w,h = surface.GetTextSize(line)
		draw.SimpleTextOutlined(line, font, x - w/2, currentY, Color(color.r, color.g, color.b, color.a), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.25, Color( colorbg.r, colorbg.g, colorbg.b, colorbg.a or color.a ) )
        currentY = currentY + h
    end
end

function carbon_noti_draw(text, font, font2, x, y, color, color2, colorbg )
    surface.SetFont(font)
    local lines = string.Explode("\n", text)
    
    local lH = {}
    local mW = 0
    local tH = 0
    
    for _, line in ipairs(lines) do
        local w, h = surface.GetTextSize(line)
        table.insert( lH, h )
        mW = math.max( mW, w )
        tH = tH + h
    end
    
    local currentY = y - tH/2
    
    for i, line in ipairs(lines) do
        local drawFont = font
        local drawColor = color
        
        -- Customize second line
        if i == 2 then
            drawFont = font2
            drawColor = color2
        end
    
		if not colorbg then colorbg = Color(0, 0, 0, color.a) end
	
        local w,h = surface.GetTextSize(line)
		draw.SimpleTextOutlined(line, font, x, currentY, drawColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.25, Color( colorbg.r, colorbg.g, colorbg.b, colorbg.a or color.a ))
        currentY = currentY + h
    end
end

-- Automatically add all files to client and server
local path = "unitvehicles/uvhud/"
local files = file.Find(path .. "*.lua", "LUA")

table.sort(files)

for _, f in ipairs(files) do
    AddCSLuaFile(path .. f)
    if CLIENT then
        include(path .. f)
    end
end

local path2 = "unitvehicles/uvspeedometers/"
local files2 = file.Find(path2 .. "*.lua", "LUA")

table.sort(files2)

for _, f in ipairs(files2) do
    AddCSLuaFile(path2 .. f)
    if CLIENT then
        include(path2 .. f)
    end
end

-- timer.Simple(1, function()
    -- for k,v in pairs(UV_UI) do
        -- if type(v) == "table" then
            -- print("[UV_UI] found HUD:", k)
        -- end
    -- end
	
    -- for k,v in pairs(UV_UI.racing) do
        -- if type(v) == "table" then
            -- print("[UV_UI] found racing HUD:", k)
        -- end
    -- end
	
    -- for k,v in pairs(UV_UI.pursuit) do
        -- if type(v) == "table" then
            -- print("[UV_UI] found pursuit HUD:", k)
        -- end
    -- end
-- end)

-- Hooks
local function onEvent(type, eventName, ...)
    local main = UVHUDTypeMain:GetString()
    local backup = UVHUDTypeBackup:GetString()

    -- Try to resolve the event function from main UI first
    local handler = UV_UI[type] and UV_UI[type][main] and UV_UI[type][main].events and UV_UI[type][main].events[eventName]

    -- If not found, and type is pursuit, fall back to backup UI
    if not handler and type == "pursuit" then
        handler = UV_UI.pursuit[backup] and UV_UI.pursuit[backup].events and UV_UI.pursuit[backup].events[eventName]
    end

    if handler then
        handler(...)
    end
end

hook.Add( "UIEventHook", "UI_Event", onEvent )

hook.Add("HUDPaint", "UV.DebugResolutionBox", function()
	if not UV.DebugRes then return end

	local realW, realH = ScrW(), ScrH()

	-- Apply UIScale to debug resolution
	local scaleMul = UV.UIScale or 1
	local debugW = UV.DebugRes.w * scaleMul
	local debugH = UV.DebugRes.h * scaleMul

	-- Center the box WITHOUT auto-fitting to screen
	local x = (realW - debugW) * 0.5
	local y = (realH - debugH) * 0.5

	-- Border
	surface.SetDrawColor(255, 0, 0, 200)
	surface.DrawOutlinedRect(x, y, debugW, debugH)

	-- Darken outside area
	surface.SetDrawColor(0, 0, 0, 150)

	-- Top
	surface.DrawRect(0, 0, realW, y)
	-- Bottom
	surface.DrawRect(0, y + debugH, realW, realH - (y + debugH))
	-- Left
	surface.DrawRect(0, y, x, debugH)
	-- Right
	surface.DrawRect(x + debugW, y, realW - (x + debugW), debugH)
end)