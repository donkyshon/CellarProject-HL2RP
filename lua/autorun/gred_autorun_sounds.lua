for i = 1,3 do
	sound.Add({
		name = "GRED_VO_HOLE_LEFT_WING_0"..i,
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 125,
		sound = "gredwitch/voice/eng_left_wing_v1_r"..i.."_t1_mood_high.wav"
	})
	sound.Add({
		name = "GRED_VO_HOLE_RIGHT_WING_0"..i,
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 125,
		sound = "gredwitch/voice/eng_right_wing_v1_r"..i.."_t1_mood_high.wav"
	})
	sound.Add({
		name = "GRED_VO_BAILOUT_0"..i,
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 90,
		sound = "gredwitch/voice/eng_bailout_v1_r"..i.."_t1_mood_high.wav"
	})
    sound.Add({
        name = "SMOKE_LAUNCHER_"..i,
        channel = CHAN_AUTO,
        volume = 1.0,
        level = 90,
        sound = "grenadelauncher/grenade_launcher_0"..i..".wav"
    })
    sound.Add({
        name = "SMOKE_LAUNCHER_INSIDE_"..i,
        channel = CHAN_AUTO,
        volume = 1.0,
        level = 90,
        sound = "grenadelauncher/grenade_launcher_0"..i..".wav"
    })
end


sound.Add({
	name = "GRED_MAC31_RELOAD",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	sound = "mg/reload_dt.ogg"
})

----------------------------- M693 -----------------------------

sound.Add({
	name = "GRED_M693_LOOP",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "^mg/15mm_mg151_loop.wav"
})
sound.Add({
	name = "GRED_M693_LOOP_INSIDE",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 0,
	sound = "mg/15mm_mg151_loop_interior.wav"
})
sound.Add({
	name = "GRED_M693_RELOAD",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	sound = "mg/reload_20mm.ogg"
})

----------------------------- BESA -----------------------------

sound.Add({
	name = "GRED_BESA_LOOP",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "^mg/loop_besa.wav"
})
sound.Add({
	name = "GRED_BESA_LOOP_INSIDE",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 0,
	sound = "mg/loop_rps10_besa_origin-001_interior.wav"
})
sound.Add({
	name = "GRED_BESA_RELOAD",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	sound = "mg/reload_m1919.ogg"
})

----------------------------- M1919A4 -----------------------------

sound.Add({
	name = "GRED_M1919A4_LOOP",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "^mg/loop_m1919.wav"
})
sound.Add({
	name = "GRED_M1919A4_LOOP_INSIDE",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 0,
	sound = "mg/loop_rps8_33_m1919_origin-001_interior.wav"
})
sound.Add({
	name = "GRED_M1919A4_RELOAD",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	sound = "mg/reload_m1919.ogg"
})

----------------------------- SGMT -----------------------------

sound.Add({
	name = "GRED_SGMT_LOOP",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "^mg/loop_sgmt.wav"
})
sound.Add({
	name = "GRED_SGMT_LOOP_INSIDE",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 0,
	sound = "mg/loop_rps11_66_sgmt_origin-001_interior.wav"
})
sound.Add({
	name = "GRED_SGMT_RELOAD",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	sound = "mg/reload_m1919.ogg"
})

------------------------------ VZ 37 ------------------------------

sound.Add({
	name = "GRED_VZ37_LOOP",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "^mg/loop_vz37.wav"
})
sound.Add({
	name = "GRED_VZ37_LOOP_INSIDE",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 0,
	sound = "mg/loop_rps12_8_vz37_origin-001_interior.wav"
})
sound.Add({
	name = "GRED_VZ37_RELOAD",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	sound = "mg/reload_m1919.ogg"
})

------------------------------ MAC 31 ------------------------------

sound.Add({
	name = "GRED_MAC31_LOOP",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "^mg/loop_vz37.wav"
})
sound.Add({
	name = "GRED_MAC31_LOOP_INSIDE",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 0,
	sound = "mg/loop_rps12_8_vz37_origin-001_interior.wav"
})
sound.Add({
	name = "GRED_MAC31_RELOAD",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	sound = "mg/reload_m1919.ogg"
})

------------------------------ M2 HB ------------------------------

sound.Add({
	name = "GRED_M2HB_LOOP",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "^mg/loop_m2.wav"
})
sound.Add({
	name = "GRED_M2HB_LOOP_INSIDE",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 0,
	sound = "mg/loop_m2-001_interior.wav"
})
sound.Add({
	name = "GRED_M2HB_RELOAD",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	sound = "mg/reload_m2hb.ogg"
})

------------------------------ MG 42 ------------------------------

sound.Add({
	name = "GRED_MG42_LOOP",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "^mg/loop_mg42.wav"
})
sound.Add({
	name = "GRED_MG42_LOOP_INSIDE",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 0,
	sound = "mg/loop_rps20_mg42_origin-001_interior.wav"
})
sound.Add({
	name = "GRED_MG42_RELOAD",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	sound = "mg/reload_mg34.ogg"
})

------------------------------ DT ------------------------------

sound.Add({
	name = "GRED_DT_SHOOT",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "mg/shoot_dt.wav"
} )
sound.Add({
	name = "GRED_DT_LOOP_INSIDE",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "mg/loop_rps10_dt_origin-001_interior.wav"
} )
sound.Add({
	name = "GRED_DT_RELOAD",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	sound = "mg/reload_dt.ogg"
})


------------------------------ MG 34 ------------------------------

sound.Add({
	name = "GRED_MG34_LOOP",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "^mg/loop_mg34.wav"
})
sound.Add({
	name = "GRED_MG34_LOOP_INSIDE",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 0,
	sound = "mg/loop_rps15_mg34_origin-001_interior.wav"
})
sound.Add({
	name = "GRED_MG34_RELOAD",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	sound = "mg/reload_mg34.ogg"
})


------------------------------ DShK ------------------------------

sound.Add({
	name = "GRED_DSHK_LOOP",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 130,
	sound = "^mg/loop_dshk.wav"
})
sound.Add({
	name = "GRED_DSHK_LOOP_INSIDE",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 0,
	sound = "mg/loop_dshk-001_interior.wav"
})
sound.Add({
	name = "GRED_DSHK_RELOAD",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	sound = "mg/reload_m2hb.ogg"
})

for i = 1,3 do
	sound.Add({
		name = "GRED_MG_8MM_LASTSHOT_0"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 75,
		sound = "mg/8mm_last_shot-00"..i..".wav"
	})
	sound.Add({
		name = "GRED_MG_12MM_LASTSHOT_0"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 75,
		sound = "mg/12mm_last_shot-00"..i..".wav"
	})
	sound.Add({
		name = "GRED_MG_8MM_LASTSHOT_INSIDE_0"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = "mg/8mm_last_shot-00"..i..".wav"
	})
	sound.Add({
		name = "GRED_MG_12MM_LASTSHOT_INSIDE_0"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = "mg/12mm_last_shot-00"..i..".wav"
	})
	
	sound.Add({
		name = "GRED_CANNON_MECH_INSIDE_0"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = "cannon/cannon_shot_mech_int-00"..i..".wav"
	})
	
	sound.Add({
		name = "GRED_SMALL_CANNON_0"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = "cannon/cannon_shot_SMALL_inside-00"..i..".wav"
	})
	sound.Add({
		name = "GRED_MED_CANNON_0"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = "cannon/cannon_shot_med_inside-00"..i..".wav"
	})
	sound.Add({
		name = "GRED_BIG_CANNON_0"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = "cannon/cannon_shot_BIG_inside-00"..i..".wav"
	})
	
	sound.Add({
		name = "37MM_KWK36_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_37mm_kwk36_shot_0"..i..".ogg"
	})
	sound.Add({
		name = "50MM_KWK39_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_50mm_kwk_shot_0"..i..".ogg"
	})
	sound.Add({
		name = "75MM_KWK40_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_75mm_kwk42_0"..i..".ogg"
	})
	sound.Add({
		name = "75MM_KWK42_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_75mm_kwk42_0"..i..".ogg"
	})
	sound.Add({
		name = "88MM_KWK36_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_88mm_kwk36_0"..i..".ogg"
	})
	
	sound.Add({
		name = "40MM_QF2_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_40mm_qf2_shot_0"..i..".ogg"
	})
	sound.Add({
		name = "57MM_QF6_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_57mm_qf6_shot_0"..i..".ogg"
	})
	
	sound.Add({
		name = "37MM_M5_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_37mm_m5_0"..i..".ogg"
	})
	sound.Add({
		name = "75MM_M3_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_75mm_m3_shot_0"..i..".ogg"
	})
	sound.Add({
		name = "76MM_M1_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_76mm_m1_shot_0"..i..".ogg"
	})
	sound.Add({
		name = "90MM_M3_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_90mm_m3_shot_0"..i..".ogg"
	})
	
	
	sound.Add({
		name = "85MM_D5T_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_85mm_zis_c53_shot_0"..i..".ogg"
	})
	sound.Add({
		name = "152MM_M10T_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_150mm_type38_shot_0"..i..".ogg"
	})
	sound.Add({
		name = "122MM_D25T_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_122mm_d25t_shot_0"..i..".ogg"
	})
	sound.Add({
		name = "76MM_F34_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_76mm_zis5_shot_0"..i..".ogg"
	})
	sound.Add({
		name = "85MM_ZIS53_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_85mm_zis_c53_shot_0"..i..".ogg"
	})
	sound.Add({
		name = "76MM_L11_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_76mm_zis5_shot_0"..i..".ogg"
	})
	sound.Add({
		name = "76MM_KT28_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_76mm_zis5_shot_0"..i..".ogg"
	})
	sound.Add({
		name = "45MM_20K_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_45mm_20k_shot_0"..i..".ogg"
	})
	sound.Add({
		name = "57MM_ZIS4_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_57mm_zis4_shot_0"..i..".ogg"
	})
	
	sound.Add({
		name = "100MM_D10T_"..i,
		channel = CHAN_WEAPON,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_100mm_d10t_shot_0"..i..".ogg"
	})


	sound.Add( 	{
		name = "120MM_GIAT_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_120mm_qqf_shot_0"..i..".ogg"
	} )
	sound.Add( 	{
		name = "105MM_EFAB_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_105mm_m4_shot_0"..i..".ogg"
	} )
	sound.Add( 	{
		name = "75MM_SA50_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_75mm_m3_shot_0"..i..".ogg"
	} )
	sound.Add( 	{
		name = "75MM_SA49_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_75mm_m3_shot_0"..i..".ogg"
	} )
	sound.Add( 	{
		name = "90MM_CN90_"..i,
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 140,
		sound = "^cannon/cannon_90mm_m3_shot_0"..i..".ogg"
	} )
end
