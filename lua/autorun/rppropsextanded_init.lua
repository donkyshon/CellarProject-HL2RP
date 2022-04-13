local cvar = CreateConVar("rppropsex_hide", -1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Show Roleplay Props Extended in the spawnmenu")

if SERVER then

	if (cvar:GetInt() == -1) then -- Default convars don't seem to be sent to clients
		cvar:SetInt(0)
	end

else

	local models = {
		["Living Room"] = {
			"models/U4Lab/tv_monitor_plasma.mdl",
			"models/gmod_tower/suitetv.mdl",
			"models/scenery/furniture/coffeetable1/vestbl.mdl",
			"models/props_interiors/chairlobby01.mdl",
			"models/props_warehouse/office_furniture_couch.mdl",
			"models/props_vtmb/armchair.mdl",
			"models/props_vtmb/sofa.mdl",
			"models/props_interiors/sofa01.mdl",
			"models/props_interiors/sofa02.mdl",
			"models/props_interiors/sofa_chair02.mdl",
			"models/props_interiors/ottoman01.mdl",
			"models/env/furniture/decosofa_wood/decosofa_wood_dou.mdl",
			"models/Highrise/lobby_chair_01.mdl",
			"models/Highrise/lobby_chair_02.mdl",
			"models/props_interiors/desk_motel.mdl",
			"models/props_furniture/piano.mdl",
			"models/props_furniture/piano_bench.mdl",
			"models/props_interiors/painting_landscape01.mdl",
			"models/props_interiors/painting_portrait01.mdl",
			"models/props_furniture/picture_frame8.mdl",
			"models/props_urban/hotel_curtain001.mdl",
			"models/props_plants/plantairport01.mdl",
			"models/Highrise/potted_plant_05.mdl",
			"models/env/decor/tall_plant_b/tall_plant_b.mdl",
			"models/env/decor/plant_decofern/plant_decofern.mdl",
			"models/sunabouzu/theater_table.mdl",
			"models/testmodels/apple_display.mdl",
			"models/testmodels/coffee_table_long.mdl",
			"models/testmodels/macbook_pro.mdl",
			"models/testmodels/sofa_double.mdl",
			"models/testmodels/sofa_single.mdl",
			"models/splayn/rp/lr/chair.mdl",
			"models/splayn/rp/lr/couch.mdl",
			"models/props/slow/glass_table_low/slow_glass_table_low.mdl",
			"models/sunabouzu/lobby_chair.mdl",
			"models/sunabouzu/lobby_poster.mdl",
			"models/sunabouzu/lobby_poster_small.mdl",
			"models/props/cs_office/table_coffee.mdl",
			"models/props/cs_office/sofa.mdl",
			"models/props/cs_office/sofa_chair.mdl",
			"models/props/de_tides/patio_chair.mdl",
			"models/chairs/armchair.mdl",
			"models/props/cs_militia/couch.mdl",
			"models/props/de_inferno/tableantique.mdl",
			
			},
		["Kitchen"] = {
			"models/props_interiors/refrigerator03.mdl",
			"models/sickness/fridge_01.mdl",
			"models/sickness/stove_01.mdl",
			"models/props_interiors/sink_kitchen.mdl",
			"models/props_interiors/coffee_maker.mdl",
			"models/props_interiors/chair01.mdl",
			"models/props_interiors/chair_cafeteria.mdl",
			"models/props_interiors/dining_table_round.mdl",
			"models/props_interiors/dinning_table_oval.mdl",
			"models/props_interiors/trashcankitchen01.mdl",
			"models/props_unique/showercurtain01.mdl",
			"models/props/cs_office/microwave.mdl",
			},
		["Bathroom"] = {
			"models/env/furniture/wc_double_cupboard/wc_double_cupboard.mdl",
			"models/env/furniture/square_sink/sink_double.mdl",
			"models/env/furniture/square_sink/sink_merged_b.mdl",
			"models/env/furniture/showerbase/showerbase.mdl",
			"models/env/furniture/shower/shower.mdl",
			"models/props_interiors/bathtub01.mdl",
			"models/env/furniture/ensuite1_toilet/ensuite1_toilet.mdl",
			"models/env/furniture/ensuite1_toilet/ensuite1_toilet_b.mdl",
			"models/env/furniture/ensuite1_sink/ensuite1_sink.mdl",
			"models/props_interiors/soap_dispenser.mdl",
			"models/props_interiors/toiletpaperdispenser_residential.mdl",
			"models/props_interiors/toiletpaperroll.mdl",
			"models/env/furniture/ensuite1_bath/ensuite1_bath.mdl",
			"models/props_interiors/urinal01.mdl",
			},
		["Bedroom"] = {
			"models/props_interiors/bed_motel.mdl",
			"models/props_downtown/bed_motel01.mdl",
			"models/env/furniture/bed_secondclass/beddouble_group.mdl",
			"models/env/furniture/bed_andrea/bed_andrea_1st.mdl",
			"models/props_interiors/side_table_square.mdl",
			"models/env/furniture/bed_naronic/bed_naronic_1st.mdl",
		},
		["Office"] = {
			"models/U4Lab/chair_office_a.mdl",
			"models/U4Lab/desk_office_a.mdl",
			"models/props_warehouse/office_furniture_coffee_table.mdl",
			"models/props_warehouse/office_furniture_desk.mdl",
			"models/props_warehouse/office_furniture_desk_corner.mdl",
			"models/props_office/desk_01.mdl",
			"models/props_interiors/desk_executive.mdl",
			"models/env/furniture/largedesk/largedesk.mdl",
			"models/props_office/file_cabinet_03.mdl",
			"models/Highrise/cubicle_monitor_01.mdl",
			"models/props_interiors/copymachine01.mdl",
			"models/props_interiors/printer.mdl",
			"models/props_interiors/paper_tray.mdl",
			"models/props_interiors/water_cooler.mdl",
			"models/props_interiors/corkboardverticle01.mdl",
			"models/props_interiors/magazine_rack.mdl",	
			"models/props/cs_office/chair_office.mdl",
			"models/props/cs_office/computer.mdl",
			"models/props_interiors/chair_office2.mdl",
			"models/props_interiors/chair_thonet.mdl",
			"models/props_interiors/closet_clothes.mdl",
			"models/props/cs_office/trash_can_p.mdl",
			"models/props/cs_office/table_meeting.mdl",
			"models/props/cs_office/file_box.mdl",
			"models/props/cs_office/offcorkboarda.mdl",
			},
		["Outdoors"] = {
			"models/props_unique/spawn_apartment/coffeeammo.mdl",
			"models/props_downtown/sign_donotenter.mdl",
			"models/props_waterfront/awning01.mdl",
			"models/props_c17/awning001a.mdl",
			"models/props_c17/awning002a.mdl",
			"models/props_street/awning_department_store.mdl",
			"models/props/de_tides/planter.mdl",
			"models/props_urban/bench001.mdl",
			"models/props_interiors/table_picnic.mdl",
			"models/props_urban/plastic_chair001.mdl",
			"models/props_interiors/patio_chair2_white.mdl",
			"models/props/de_tides/patio_chair2.mdl",
			"models/props/de_tides/patio_table2.mdl",
			"models/env/furniture/pool_recliner/pool_recliner.mdl",
			"models/props/de_piranesi/pi_bench.mdl",
			"models/props/de_piranesi/pi_sundial.mdl",
			"models/props/de_inferno/bench_concrete.mdl",
			"models/props/de_inferno/fountain.mdl",
			"models/props/de_inferno/lattice.mdl",
			"models/props_unique/firepit_campground.mdl",
			"models/props_equipment/sleeping_bag1.mdl",
			"models/props_equipment/sleeping_bag2.mdl",
			"models/props_urban/outhouse001.mdl",
			"models/props_junk/trashcluster01a_corner.mdl",
			"models/trees/pi_tree1.mdl",
			"models/trees/pi_tree3.mdl",
			"models/trees/pi_tree4.mdl",
			"models/trees/pi_tree5.mdl",
			"models/gm_forest/tree_alder.mdl",
			"models/props_foliage/r_maple1.mdl",
			"models/props_foliage/maple_001_l.mdl",
			"models/props_foliage/tree_springers_01a.mdl",
			"models/props/cs_militia/tree_large_militia.mdl",
			"models/sickness/parkinglotlight.mdl",
			"models/props_junk/dumpster.mdl",
			"models/props/de_inferno/bench_wood.mdl",
			"models/props_silo/camera.mdl",
			"models/props/cs_italy/it_mkt_table3.mdl",
			"models/props/cs_militia/table_shed.mdl",
			"models/props/cs_militia/table_kitchen.mdl",
			"models/props/cs_militia/logpile2.mdl",
			"models/props/cs_militia/bar01.mdl",
			"models/props/cs_militia/barstool01.mdl",
			"models/props/de_piranesi/pi_orrery.mdl",
			"models/props/de_tides/tides_streetlight.mdl",
			"models/natalya/furniture/patio_table.mdl",
			"models/props/de_tides/vending_cart.mdl",
			},
		["Commercial"] = {
			"models/props_equipment/phone_booth.mdl",
			"models/Highrise/trashcanashtray_01.mdl",
			"models/Highrise/trash_can_03.mdl",
			"models/props_interiors/trashcan01.mdl",
			"models/props_interiors/cashregister01.mdl",
			"models/props_interiors/magazine_rack.mdl",
			"models/props_interiors/shelvinggrocery01.mdl",
			"models/props_interiors/shelvingstore01.mdl",
			"models/props_equipment/fountain_drinks.mdl",
			"models/props_downtown/bar_long.mdl",
			"models/props_downtown/bar_long_endcorner.mdl",
			"models/scenery/structural/vesuvius/bartap.mdl",
			"models/env/furniture/bstoolred/bstoolred.mdl",
			"models/props_furniture/cafe_barstool1.mdl",
			"models/props_downtown/pooltable.mdl",
			"models/de_vegas/card_table.mdl",
			"models/props_equipment/security_desk1.mdl",
			"models/sickness/bk_booth2.mdl",
			"models/props_downtown/booth01.mdl",
			"models/props_downtown/booth02.mdl",
			"models/props_downtown/booth_table.mdl",
			"models/props_interiors/table_cafeteria.mdl",
			"models/props_warehouse/table_01.mdl",
			"models/props_interiors/chairs_airport.mdl",
			"models/props_warehouse/toolbox.mdl",
			"models/props_vtmb/turntable.mdl",
			"models/props_unique/wheelchair01.mdl",
			"models/props_unique/hospital/exam_table.mdl",
			"models/props_unique/hospital/gurney.mdl",
			"models/props_equipment/surgicaltray_01.mdl",
			"models/props_unique/hospital/hospital_bed.mdl",
			"models/props_unique/hospital/iv_pole.mdl",
			"models/props_unique/hospital/surgery_lamp.mdl",
			"models/props_interiors/medicalcabinet02.mdl",
			"models/props/slow/glass_table_high/slow_glass_table_high.mdl",
			"models/props/slow/hocker/slow_hocker.mdl",
			"models/pg_props/pg_hospital/pg_optable.mdl",
			"models/props_equipment/snack_machine.mdl",
			"models/env/decor/gents_display/gents_display.mdl",
			"models/env/decor/vous_display/vous_display.mdl",
			"models/maxib123/pooltable.mdl",
			"models/props_interiors/phone.mdl",
			"models/props_unique/coffeemachine01.mdl",
			"models/props/cs_office/tv_plasma.mdl",
			"models/props/cs_office/bookshelf1.mdl",
			"models/props/de_tides/menu_stand.mdl",
		},
		["Industrial"] = {
			"models/props_industrial/warehouse_shelf001.mdl",
			"models/props_industrial/warehouse_shelf002.mdl",
			"models/props_industrial/warehouse_shelf003.mdl",
			"models/props_industrial/warehouse_shelf004.mdl",
			"models/props/cs_assault/moneypallete.mdl",
			"models/props/cs_assault/moneypallet03.mdl",
			"models/props/cs_assault/handtruck.mdl",
			"models/props/cs_assault/forklift.mdl",
			"models/props/cs_office/paperbox_pile_01.mdl",
			"models/props/cs_office/cardboard_box03.mdl",
			"models/props/de_dust/stoneblock01a.mdl",
		},
		["Lighting"] = {
			"models/props_unique/spawn_apartment/lantern.mdl",	
			"models/env/lighting/lamp_trumpet/lamp_trumpet_tall.mdl",
			"models/env/lighting/jelly_lamp/jellylamp.mdl",
			"models/env/lighting/corridor_ceil_lamp/corridor_ceil_lamp.mdl",
			"models/env/lighting/corridorlamp/corridorlamp.mdl",
			"models/props_urban/light_fixture01.mdl",
			"models/Highrise/tall_lamp_01.mdl",
			"models/U4Lab/track_lighting_a.mdl",
			"models/Highrise/sconce_01.mdl",
			"models/wilderness/lamp6.mdl",
			"models/props_interiors/lamp_table02.mdl",	
			"models/env/lighting/dance_spots/dance_spots.mdl",
			"models/props/cs_assault/light_shop2.mdl",
		},
		["Paintings"] = {
			"models/props/cs_office/offinspa.mdl",
			"models/props/cs_office/offinspb.mdl",
			"models/props/cs_office/offinspc.mdl",
			"models/props/cs_office/offinspd.mdl",
			"models/props/cs_office/offinspf.mdl",
			"models/props/cs_office/offinspg.mdl",
			"models/props/cs_office/offpaintinga.mdl",
			"models/props/cs_office/offpaintingb.mdl",
			"models/props/cs_office/offpaintingd.mdl",
			"models/props/cs_office/offpaintinge.mdl",
			"models/props/cs_office/offpaintingf.mdl",
			"models/props/cs_office/offpaintingg.mdl",
			"models/props/cs_office/offpaintingh.mdl",
			"models/props/cs_office/offpaintingi.mdl",
			"models/props/cs_office/offpaintingj.mdl",
			"models/props/cs_office/offpaintingk.mdl",
			"models/props/cs_office/offpaintingl.mdl",
			"models/props/cs_office/offpaintingm.mdl",
			"models/props/cs_office/offpaintingo.mdl",
		},
	}


	hook.Add("PopulateContent", "RoleplayPropsExtended", function(pnlContent, tree)
	
		local cvar = GetConVar("rppropsex_hide")
		if cvar and (cvar:GetInt() == 1) then return end -- The server doesn't want it in the client spawn menu

		local RootNode = tree:AddNode("Roleplay Props Extended", "icon16/rpprops.png")

		local ViewPanel = vgui.Create("ContentContainer", pnlContent)
		ViewPanel:SetVisible(false)
		
		RootNode.DoClick = function()
		
			ViewPanel:Clear(true)
			
			for name, tbl in SortedPairs(models) do
			
				local label = vgui.Create("ContentHeader", container)
				label:SetText(name)

				ViewPanel:Add(label)
			
				for _, v in ipairs(tbl) do
				
					local mdlicon = spawnmenu.GetContentType("model")
					if mdlicon then
						mdlicon(ViewPanel, {model = v})
					end

				end
				
			end
			
			pnlContent:SwitchPanel(ViewPanel)
			
		end

	end)
	
end

local cvar = CreateConVar("rppropsex_hide", -1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Show Roleplay Props Extended in the spawnmenu")

if SERVER then

	if (cvar:GetInt() == -1) then -- Default convars don't seem to be sent to clients
		cvar:SetInt(0)
	end

else

	local models = {
		["Living Room"] = {
			"models/U4Lab/tv_monitor_plasma.mdl",
			"models/gmod_tower/suitetv.mdl",
			"models/scenery/furniture/coffeetable1/vestbl.mdl",
			"models/props_interiors/chairlobby01.mdl",
			"models/props_warehouse/office_furniture_couch.mdl",
			"models/props_vtmb/armchair.mdl",
			"models/props_vtmb/sofa.mdl",
			"models/props_interiors/sofa01.mdl",
			"models/props_interiors/sofa02.mdl",
			"models/props_interiors/sofa_chair02.mdl",
			"models/props_interiors/ottoman01.mdl",
			"models/env/furniture/decosofa_wood/decosofa_wood_dou.mdl",
			"models/Highrise/lobby_chair_01.mdl",
			"models/Highrise/lobby_chair_02.mdl",
			"models/props_interiors/desk_motel.mdl",
			"models/props_furniture/piano.mdl",
			"models/props_furniture/piano_bench.mdl",
			"models/props_interiors/painting_landscape01.mdl",
			"models/props_interiors/painting_portrait01.mdl",
			"models/props_furniture/picture_frame8.mdl",
			"models/props_urban/hotel_curtain001.mdl",
			"models/props_plants/plantairport01.mdl",
			"models/Highrise/potted_plant_05.mdl",
			"models/env/decor/tall_plant_b/tall_plant_b.mdl",
			"models/env/decor/plant_decofern/plant_decofern.mdl",
			"models/sunabouzu/theater_table.mdl",
			"models/testmodels/apple_display.mdl",
			"models/testmodels/coffee_table_long.mdl",
			"models/testmodels/macbook_pro.mdl",
			"models/testmodels/sofa_double.mdl",
			"models/testmodels/sofa_single.mdl",
			"models/splayn/rp/lr/chair.mdl",
			"models/splayn/rp/lr/couch.mdl",
			"models/props/slow/glass_table_low/slow_glass_table_low.mdl",
			"models/sunabouzu/lobby_chair.mdl",
			"models/sunabouzu/lobby_poster.mdl",
			"models/sunabouzu/lobby_poster_small.mdl",
			"models/props/cs_office/table_coffee.mdl",
			"models/props/cs_office/sofa.mdl",
			"models/props/cs_office/sofa_chair.mdl",
			"models/props/de_tides/patio_chair.mdl",
			"models/chairs/armchair.mdl",
			"models/props/cs_militia/couch.mdl",
			"models/props/de_inferno/tableantique.mdl",
			
			},
		["Kitchen"] = {
			"models/props_interiors/refrigerator03.mdl",
			"models/sickness/fridge_01.mdl",
			"models/sickness/stove_01.mdl",
			"models/props_interiors/sink_kitchen.mdl",
			"models/props_interiors/coffee_maker.mdl",
			"models/props_interiors/chair01.mdl",
			"models/props_interiors/chair_cafeteria.mdl",
			"models/props_interiors/dining_table_round.mdl",
			"models/props_interiors/dinning_table_oval.mdl",
			"models/props_interiors/trashcankitchen01.mdl",
			"models/props_unique/showercurtain01.mdl",
			"models/props/cs_office/microwave.mdl",
			},
		["Bathroom"] = {
			"models/env/furniture/wc_double_cupboard/wc_double_cupboard.mdl",
			"models/env/furniture/square_sink/sink_double.mdl",
			"models/env/furniture/square_sink/sink_merged_b.mdl",
			"models/env/furniture/showerbase/showerbase.mdl",
			"models/env/furniture/shower/shower.mdl",
			"models/props_interiors/bathtub01.mdl",
			"models/env/furniture/ensuite1_toilet/ensuite1_toilet.mdl",
			"models/env/furniture/ensuite1_toilet/ensuite1_toilet_b.mdl",
			"models/env/furniture/ensuite1_sink/ensuite1_sink.mdl",
			"models/props_interiors/soap_dispenser.mdl",
			"models/props_interiors/toiletpaperdispenser_residential.mdl",
			"models/props_interiors/toiletpaperroll.mdl",
			"models/env/furniture/ensuite1_bath/ensuite1_bath.mdl",
			"models/props_interiors/urinal01.mdl",
			},
		["Bedroom"] = {
			"models/props_interiors/bed_motel.mdl",
			"models/props_downtown/bed_motel01.mdl",
			"models/env/furniture/bed_secondclass/beddouble_group.mdl",
			"models/env/furniture/bed_andrea/bed_andrea_1st.mdl",
			"models/props_interiors/side_table_square.mdl",
			"models/env/furniture/bed_naronic/bed_naronic_1st.mdl",
		},
		["Office"] = {
			"models/U4Lab/chair_office_a.mdl",
			"models/U4Lab/desk_office_a.mdl",
			"models/props_warehouse/office_furniture_coffee_table.mdl",
			"models/props_warehouse/office_furniture_desk.mdl",
			"models/props_warehouse/office_furniture_desk_corner.mdl",
			"models/props_office/desk_01.mdl",
			"models/props_interiors/desk_executive.mdl",
			"models/env/furniture/largedesk/largedesk.mdl",
			"models/props_office/file_cabinet_03.mdl",
			"models/Highrise/cubicle_monitor_01.mdl",
			"models/props_interiors/copymachine01.mdl",
			"models/props_interiors/printer.mdl",
			"models/props_interiors/paper_tray.mdl",
			"models/props_interiors/water_cooler.mdl",
			"models/props_interiors/corkboardverticle01.mdl",
			"models/props_interiors/magazine_rack.mdl",	
			"models/props/cs_office/chair_office.mdl",
			"models/props/cs_office/computer.mdl",
			"models/props_interiors/chair_office2.mdl",
			"models/props_interiors/chair_thonet.mdl",
			"models/props_interiors/closet_clothes.mdl",
			"models/props/cs_office/trash_can_p.mdl",
			"models/props/cs_office/table_meeting.mdl",
			"models/props/cs_office/file_box.mdl",
			"models/props/cs_office/offcorkboarda.mdl",
			},
		["Outdoors"] = {
			"models/props_unique/spawn_apartment/coffeeammo.mdl",
			"models/props_downtown/sign_donotenter.mdl",
			"models/props_waterfront/awning01.mdl",
			"models/props_c17/awning001a.mdl",
			"models/props_c17/awning002a.mdl",
			"models/props_street/awning_department_store.mdl",
			"models/props/de_tides/planter.mdl",
			"models/props_urban/bench001.mdl",
			"models/props_interiors/table_picnic.mdl",
			"models/props_urban/plastic_chair001.mdl",
			"models/props_interiors/patio_chair2_white.mdl",
			"models/props/de_tides/patio_chair2.mdl",
			"models/props/de_tides/patio_table2.mdl",
			"models/env/furniture/pool_recliner/pool_recliner.mdl",
			"models/props/de_piranesi/pi_bench.mdl",
			"models/props/de_piranesi/pi_sundial.mdl",
			"models/props/de_inferno/bench_concrete.mdl",
			"models/props/de_inferno/fountain.mdl",
			"models/props/de_inferno/lattice.mdl",
			"models/props_unique/firepit_campground.mdl",
			"models/props_equipment/sleeping_bag1.mdl",
			"models/props_equipment/sleeping_bag2.mdl",
			"models/props_urban/outhouse001.mdl",
			"models/props_junk/trashcluster01a_corner.mdl",
			"models/trees/pi_tree1.mdl",
			"models/trees/pi_tree3.mdl",
			"models/trees/pi_tree4.mdl",
			"models/trees/pi_tree5.mdl",
			"models/gm_forest/tree_alder.mdl",
			"models/props_foliage/r_maple1.mdl",
			"models/props_foliage/maple_001_l.mdl",
			"models/props_foliage/tree_springers_01a.mdl",
			"models/props/cs_militia/tree_large_militia.mdl",
			"models/sickness/parkinglotlight.mdl",
			"models/props_junk/dumpster.mdl",
			"models/props/de_inferno/bench_wood.mdl",
			"models/props_silo/camera.mdl",
			"models/props/cs_italy/it_mkt_table3.mdl",
			"models/props/cs_militia/table_shed.mdl",
			"models/props/cs_militia/table_kitchen.mdl",
			"models/props/cs_militia/logpile2.mdl",
			"models/props/cs_militia/bar01.mdl",
			"models/props/cs_militia/barstool01.mdl",
			"models/props/de_piranesi/pi_orrery.mdl",
			"models/props/de_tides/tides_streetlight.mdl",
			"models/natalya/furniture/patio_table.mdl",
			"models/props/de_tides/vending_cart.mdl",
			},
		["Commercial"] = {
			"models/props_equipment/phone_booth.mdl",
			"models/Highrise/trashcanashtray_01.mdl",
			"models/Highrise/trash_can_03.mdl",
			"models/props_interiors/trashcan01.mdl",
			"models/props_interiors/cashregister01.mdl",
			"models/props_interiors/magazine_rack.mdl",
			"models/props_interiors/shelvinggrocery01.mdl",
			"models/props_interiors/shelvingstore01.mdl",
			"models/props_equipment/fountain_drinks.mdl",
			"models/props_downtown/bar_long.mdl",
			"models/props_downtown/bar_long_endcorner.mdl",
			"models/scenery/structural/vesuvius/bartap.mdl",
			"models/env/furniture/bstoolred/bstoolred.mdl",
			"models/props_furniture/cafe_barstool1.mdl",
			"models/props_downtown/pooltable.mdl",
			"models/de_vegas/card_table.mdl",
			"models/props_equipment/security_desk1.mdl",
			"models/sickness/bk_booth2.mdl",
			"models/props_downtown/booth01.mdl",
			"models/props_downtown/booth02.mdl",
			"models/props_downtown/booth_table.mdl",
			"models/props_interiors/table_cafeteria.mdl",
			"models/props_warehouse/table_01.mdl",
			"models/props_interiors/chairs_airport.mdl",
			"models/props_warehouse/toolbox.mdl",
			"models/props_vtmb/turntable.mdl",
			"models/props_unique/wheelchair01.mdl",
			"models/props_unique/hospital/exam_table.mdl",
			"models/props_unique/hospital/gurney.mdl",
			"models/props_equipment/surgicaltray_01.mdl",
			"models/props_unique/hospital/hospital_bed.mdl",
			"models/props_unique/hospital/iv_pole.mdl",
			"models/props_unique/hospital/surgery_lamp.mdl",
			"models/props_interiors/medicalcabinet02.mdl",
			"models/props/slow/glass_table_high/slow_glass_table_high.mdl",
			"models/props/slow/hocker/slow_hocker.mdl",
			"models/pg_props/pg_hospital/pg_optable.mdl",
			"models/props_equipment/snack_machine.mdl",
			"models/env/decor/gents_display/gents_display.mdl",
			"models/env/decor/vous_display/vous_display.mdl",
			"models/maxib123/pooltable.mdl",
			"models/props_interiors/phone.mdl",
			"models/props_unique/coffeemachine01.mdl",
			"models/props/cs_office/tv_plasma.mdl",
			"models/props/cs_office/bookshelf1.mdl",
			"models/props/de_tides/menu_stand.mdl",
		},
		["Industrial"] = {
			"models/props_industrial/warehouse_shelf001.mdl",
			"models/props_industrial/warehouse_shelf002.mdl",
			"models/props_industrial/warehouse_shelf003.mdl",
			"models/props_industrial/warehouse_shelf004.mdl",
			"models/props/cs_assault/moneypallete.mdl",
			"models/props/cs_assault/moneypallet03.mdl",
			"models/props/cs_assault/handtruck.mdl",
			"models/props/cs_assault/forklift.mdl",
			"models/props/cs_office/paperbox_pile_01.mdl",
			"models/props/cs_office/cardboard_box03.mdl",
			"models/props/de_dust/stoneblock01a.mdl",
		},
		["Lighting"] = {
			"models/props_unique/spawn_apartment/lantern.mdl",	
			"models/env/lighting/lamp_trumpet/lamp_trumpet_tall.mdl",
			"models/env/lighting/jelly_lamp/jellylamp.mdl",
			"models/env/lighting/corridor_ceil_lamp/corridor_ceil_lamp.mdl",
			"models/env/lighting/corridorlamp/corridorlamp.mdl",
			"models/props_urban/light_fixture01.mdl",
			"models/Highrise/tall_lamp_01.mdl",
			"models/U4Lab/track_lighting_a.mdl",
			"models/Highrise/sconce_01.mdl",
			"models/wilderness/lamp6.mdl",
			"models/props_interiors/lamp_table02.mdl",	
			"models/env/lighting/dance_spots/dance_spots.mdl",
			"models/props/cs_assault/light_shop2.mdl",
		},
		["Paintings"] = {
			"models/props/cs_office/offinspa.mdl",
			"models/props/cs_office/offinspb.mdl",
			"models/props/cs_office/offinspc.mdl",
			"models/props/cs_office/offinspd.mdl",
			"models/props/cs_office/offinspf.mdl",
			"models/props/cs_office/offinspg.mdl",
			"models/props/cs_office/offpaintinga.mdl",
			"models/props/cs_office/offpaintingb.mdl",
			"models/props/cs_office/offpaintingd.mdl",
			"models/props/cs_office/offpaintinge.mdl",
			"models/props/cs_office/offpaintingf.mdl",
			"models/props/cs_office/offpaintingg.mdl",
			"models/props/cs_office/offpaintingh.mdl",
			"models/props/cs_office/offpaintingi.mdl",
			"models/props/cs_office/offpaintingj.mdl",
			"models/props/cs_office/offpaintingk.mdl",
			"models/props/cs_office/offpaintingl.mdl",
			"models/props/cs_office/offpaintingm.mdl",
			"models/props/cs_office/offpaintingo.mdl",
		},
	}


	hook.Add("PopulateContent", "RoleplayPropsExtended", function(pnlContent, tree)
	
		local cvar = GetConVar("rppropsex_hide")
		if cvar and (cvar:GetInt() == 1) then return end -- The server doesn't want it in the client spawn menu

		local RootNode = tree:AddNode("Roleplay Props Extended", "icon16/rpprops.png")

		local ViewPanel = vgui.Create("ContentContainer", pnlContent)
		ViewPanel:SetVisible(false)
		
		RootNode.DoClick = function()
		
			ViewPanel:Clear(true)
			
			for name, tbl in SortedPairs(models) do
			
				local label = vgui.Create("ContentHeader", container)
				label:SetText(name)

				ViewPanel:Add(label)
			
				for _, v in ipairs(tbl) do
				
					local mdlicon = spawnmenu.GetContentType("model")
					if mdlicon then
						mdlicon(ViewPanel, {model = v})
					end

				end
				
			end
			
			pnlContent:SwitchPanel(ViewPanel)
			
		end

	end)
	
end
