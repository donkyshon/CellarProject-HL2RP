
AddCSLuaFile()

gred = gred or {}
gred.CVars = gred.CVars or {}

hook.Add("PlayerHurt","gred_getlastdmg",function(ply)
	ply.LastHit = CurTime()
end)

-- hook.Add("PlayerDeath","gred_death_nonsilent",function(ply,inflictor,attacker)
-- end)
-- hook.Add("PlayerDeath","gred_death_nonsilent",function(ply)
-- end)

local CreateConVar = CreateConVar
local GRED_SVAR = { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }
gred.CVars["gred_sv_artisweps_aircrafts"] 					= CreateConVar("gred_sv_artisweps_aircrafts"					,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_artisweps_skybox_mdls"] 				= CreateConVar("gred_sv_artisweps_skybox_mdls"					,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_artisweps_spam"] 						= CreateConVar("gred_sv_artisweps_spam"							,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_artisweps_helisupport_shootateveryone"] = CreateConVar("gred_sv_artisweps_helisupport_shootateveryone"	,  "1"  , GRED_SVAR)

local COL_INVISIBLE  = Color(255,255,255,0)

gred.AddonList = gred.AddonList or {}
table.insert(gred.AddonList,1131455085) -- Base
	
if CLIENT then
	gred.CVars["gred_cl_artisweps_enable_subtitles"] = CreateConVar("gred_cl_artisweps_enable_subtitles"	,  "1"  , { FCVAR_USERINFO, FCVAR_ARCHIVE })
	
	language.Add("allied_radiobattery", "Allied radio battery")
	language.Add("axis_radiobattery", "Axis radio battery")
	
	local ArtilleryMaterial = Material("gredwitch/artilleryicon.png")
	
	hook.Add("GredOptionsAddLateralMenuOption","AddArtillery",function(DFrame,DPanel,DScrollPanel,X,Y,X_DPanel,y_DPanel)
		local CreateOptions				= gred.Menu.CreateOptions
		local CreateCheckBoxPanel   	= gred.Menu.CreateCheckBoxPanel
		local CreateSliderPanel     	= gred.Menu.CreateSliderPanel
		local DrawEmptyRect         	= gred.Menu.DrawEmptyRect
		local CreateBindPanel       	= gred.Menu.CreateBindPanel
		local COL_WHITE					= gred.Menu.COL_WHITE					
		local COL_GREY					= gred.Menu.COL_GREY					
		local COL_LIGHT_GREY			= gred.Menu.COL_LIGHT_GREY			
		local COL_LIGHT_GREY1			= gred.Menu.COL_LIGHT_GREY1			
		local COL_RED					= gred.Menu.COL_RED					
		local COL_GREEN					= gred.Menu.COL_GREEN					
		local COL_DARK_GREY 			= gred.Menu.COL_DARK_GREY 			
		local COL_DARK_GREY1 			= gred.Menu.COL_DARK_GREY1 			
		local COL_BLUE_HIGHLIGHT		= gred.Menu.COL_BLUE_HIGHLIGHT		
		local COL_DARK_BLUE_HIGHLIGHT	= gred.Menu.COL_DARK_BLUE_HIGHLIGHT
		local COL_TRANSPARENT_GREY 		= gred.Menu.COL_TRANSPARENT_GREY
		
		local DButton = DScrollPanel:Add("DButton")
		DButton:SetText("")
		DButton:Dock(TOP)
		DButton:DockMargin(0,0,0,10)
		DButton:SetSize(X_DPanel,y_DPanel*0.15)
		DButton.Paint = function(DButton,w,h)
			local col = DButton:IsHovered() and COL_BLUE_HIGHLIGHT or COL_WHITE
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			DrawEmptyRect(0,0,w,h,2,2,0)
			surface.SetMaterial(ArtilleryMaterial)
			local H = h - 24
			surface.DrawTexturedRect((w - H)*0.5,0,H,H)
			
			draw.DrawText("ARTILLERY SWEPS OPTIONS","Trebuchet24",w*0.5,h-24,col,TEXT_ALIGN_CENTER)
		end
		DButton.DoClick = function()
			DFrame:SelectLateralMenuOption("ARTILLERY SWEPS OPTIONS")
			DPanel.ToggleButton:DoClick(true)
		end
		
		DFrame.LateralOptionList["ARTILLERY SWEPS OPTIONS"] = function(DFrame,DPanel,X,Y)
			CreateOptions(DFrame,DPanel,X,Y,{
				["CLIENT"] = {
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_artisweps_enable_subtitles","Subtitles","",false)
					end,
				},
				["SERVER"] = {
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_artisweps_aircrafts","Aircraft flyovers","",true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_artisweps_skybox_mdls","Skybox sized aircraft models","Scales the aircraft models to 1/16",true)
					end,
					function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_artisweps_spam","Spam mode","Allows player to call in artillery even if the voice lines aren't finished",true)
					end,
					-- function(DFrame,DPanel,DScrollPanel,Panel,x,y)
						-- CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_artisweps_helisupport_shootateveryone","Support aircraft shoots everyone","Makes support aircrafts shoot everyone, even the caller",true)
					-- end,
				}
			})
		end
	end)

	
	net.Receive("gred_net_artiplaysound",function()
		surface.PlaySound(net.ReadString())
	end)
	net.Receive("gred_net_artisweps_singleplayer",function()
		local self = net.ReadEntity()
		if !IsValid(self) then return end
		self:CreateMenu()
	end)
else
	gred.ActiveArtilleryStrikes = {}
	util.AddNetworkString("gred_net_artisweps_singleplayer")
	util.AddNetworkString("gred_net_artisweps_callin")
	util.AddNetworkString("gred_net_artiplaysound")
	
	net.Receive("gred_net_artisweps_callin",function(len,ply)
		local self = net.ReadEntity()
		local index = net.ReadTable()
		local tab = table.Copy(self.Choices)
		for k,v in pairs(index) do
			tab = tab[v]
		end
		self:HandleStrike(tab)
	end)
	
	hook.Add("PostCleanupMap","gred_artisweps_removetimers",function()
		if !gred.ActiveArtilleryStrikes then return end
		for k,v in pairs(gred.ActiveArtilleryStrikes) do
			timer.Remove(v)
		end
		gred.ActiveArtilleryStrikes = {}
	end)
	
	local WHISTLE_SOUNDS = {
		["ARTILLERY"] = {
			"artillery/flyby/artillery_strike_incoming_01.wav",
			"artillery/flyby/artillery_strike_incoming_02.wav",
			"artillery/flyby/artillery_strike_incoming_03.wav",
			"artillery/flyby/artillery_strike_incoming_04.wav",
		},
		["BIGARTILLERY"] = {
			"artillery/far/siegehowitzer_incoming_01.wav",
		},
		["MORTAR"] = {
			"artillery/flyby/mortar_strike_incoming_01.wav",
			"artillery/flyby/mortar_strike_incoming_02.wav",
			"artillery/flyby/mortar_strike_incoming_03.wav",
			"artillery/flyby/mortar_strike_incoming_04.wav",
		},
		["BOMBER"] = {
			"bomb/bomb_whistle_01.wav",
			"bomb/bomb_whistle_02.wav",
			"bomb/bomb_whistle_03.wav",
			"bomb/bomb_whistle_04.wav",
		},
		["NEBELWERFER"] = {
			"artillery/flyby/rocket_artillery_strike_incoming_01.wav",
			"artillery/flyby/rocket_artillery_strike_incoming_02.wav",
			"artillery/flyby/rocket_artillery_strike_incoming_03.wav",
			"artillery/flyby/rocket_artillery_strike_incoming_04.wav",
		},
	}
	
	local FIRE_SOUNDS = {
		["ARTILLERY"] = {
			"artillery/far/distant_artillery_fire_01.wav",
			"artillery/far/distant_artillery_fire_02.wav",
			"artillery/far/distant_artillery_fire_03.wav",
			"artillery/far/distant_artillery_fire_04.wav",
		},
		["NEBELWERFER"] = {
			"artillery/far/distant_rocket_artillery_fire_01.wav",
			"artillery/far/distant_rocket_artillery_fire_02.wav",
			"artillery/far/distant_rocket_artillery_fire_03.wav",
			"artillery/far/distant_rocket_artillery_fire_04.wav",
		},
		["MORTAR"] = {
			"artillery/far/mortar_fire1.wav",
			"artillery/far/mortar_fire2.wav",
			"artillery/far/mortar_fire3.wav",
			"artillery/far/mortar_fire4.wav",
			"artillery/far/mortar_fire5.wav",
			"artillery/far/mortar_fire6.wav",
			"artillery/far/mortar_fire7.wav",
			"artillery/far/mortar_fire8.wav",
			"artillery/far/mortar_fire9.wav",
			"artillery/far/mortar_fire10.wav",
			"artillery/far/mortar_fire11.wav",
		}
		
	}
	
	local reachSky = Vector(0,0,9999999999)
	
	local function CreateArti(ply,tr,FIRE_TABLE,WHISTLE_TABLE,caliber,shelltype,Spread,STR)
		net.Start("gred_net_artiplaysound")
			net.WriteString(table.Random(FIRE_TABLE))
		net.Broadcast()
		
		if not table.HasValue(gred.ActiveArtilleryStrikes,STR) then return end
		
		timer.Simple(math.random(2,3),function()
			if not table.HasValue(gred.ActiveArtilleryStrikes,STR) then return end
			
			local BPos = tr.HitPos + Vector(math.random(-Spread,Spread),math.random(-Spread,Spread),-1)
			if !util.IsInWorld(BPos) then
				BPos = tr.HitPos
			end
			-- if !util.IsInWorld(BPos) then return end
			
			local dist = math.abs(util.QuickTrace(BPos,BPos - reachSky).HitPos.z - BPos.z)
			
			----------------------
			
			local snd = table.Random(WHISTLE_TABLE)
			local sndDuration = SoundDuration(snd)
			
			timer.Simple(4,function()
				if not table.HasValue(gred.ActiveArtilleryStrikes,STR) then return end
				
				local time = (dist / -1000) + (sndDuration - 0.2) -- Calculates when to play the whistle sound
				
				if time < 0 then
					local b = gred.CreateShell(BPos,Angle(90),ply,{},caliber,shelltype,100,7,"white",dmg)
					local phys = b:GetPhysicsObject()
					
					if IsValid(phys) then
						phys:EnableDrag(false)
					end
					
					b:Arm()
					b:SetBodygroup(0,1)
					
					b.PhysicsUpdate = function(data,phys)
						phys:SetVelocityInstantaneous(Vector(0,0,-1000))
					end
					
					timer.Simple(-time,function()
						if !IsValid(b) then return end
						b:EmitSound(snd, 140, 100, 1)
					end)
				else
					local p = ents.Create("prop_dynamic")
					p:SetModel("models/hunter/blocks/cube025x025x025.mdl")
					p:SetPos(BPos)
					p:Spawn()
					p:SetRenderMode(RENDERMODE_TRANSALPHA)
					p:SetColor(COL_INVISIBLE)
					p:EmitSound(snd,140,100,1)
					p:Remove()
					
					timer.Simple(time,function()
						local b = gred.CreateShell(BPos,Angle(90),ply,{},caliber,shelltype,100,7,"white",dmg)
						b:Arm()
						b:SetBodygroup(0,1)
						
						local phys = b:GetPhysicsObject()
						
						if IsValid(phys) then
							phys:EnableDrag(false)
						end
						
						b.PhysicsUpdate = function(data,phys)
							phys:SetVelocityInstantaneous(Vector(0,0,-1000))
						end
					end)
				end
			end)
		end)
	end
	
	local function CreatePlane(MODEL,MODEL_SPAWN_AT_HITPOS,tr,ang,MODEL_ANIMRATE)
		if !MODEL then return end
		local bomber = ents.Create("prop_dynamic")
		bomber:SetModel(MODEL)
		if !MODEL_SPAWN_AT_HITPOS then
			bomber:SetPos(util.QuickTrace(tr.HitPos,tr.HitPos + Vector(0,0,20000)).HitPos)
		else
			bomber:SetPos(tr.HitPos)
		end
		bomber.AutomaticFrameAdvance = true
		bomber:SetAngles(Angle(0,ang.y,0))
		bomber:SetMoveType(MOVETYPE_NOCLIP)
		bomber:Spawn()
		bomber:Activate()
		bomber:SetSkin(math.random(0,bomber:SkinCount()))
		if gred.CVars.gred_sv_artisweps_skybox_mdls:GetInt() == 1 then
			bomber:SetModelScale(0.16)
		end
		local ph = bomber:GetPhysicsObject()
		if IsValid(ph) then
			ph:EnableCollisions(false)
		end
		bomber:ResetSequence("action")
		MODEL_ANIMRATE = MODEL_ANIMRATE or 0.8
		bomber:SetPlaybackRate(MODEL_ANIMRATE)
		
		local time = bomber:SequenceDuration() / MODEL_ANIMRATE
		timer.Simple(time,function()
			if IsValid(bomber) then 
				bomber:Remove() 
			end
		end)
	end
	
	gred.STRIKE = {
		ARTILLERY = function(ply,tr,FIRE_TABLE,WHISTLE_TABLE,count,caliber,shelltype,Spread,dmg)
			local STR = "GRED_ARTILLERY_"..#gred.ActiveArtilleryStrikes+1
			table.insert(gred.ActiveArtilleryStrikes,STR)
			
			timer.Create(STR,1,count,function()
				timer.Simple(math.Rand(0.2,0.5),function()
					CreateArti(ply,tr,FIRE_SOUNDS[FIRE_TABLE],WHISTLE_SOUNDS[WHISTLE_TABLE],caliber,shelltype,Spread,STR)
				end)
			end)
		end,
		
		BOMBER = function(ply,tr,EyeTrace,FLYBY_SOUND,MODEL,BOMB_CLASSNAME,BOMB_COUNT,DROPDELAY,MODEL_SPAWNDELAY,MODEL_ANIMRATE,MODEL_SPAWN_AT_HITPOS)
			if FLYBY_SOUND then
				net.Start("gred_net_artiplaysound")
					net.WriteString(FLYBY_SOUND)
				net.Broadcast()
			end
			local ang = (EyeTrace.StartPos - EyeTrace.HitPos):Angle()
			ang.y = ang.y + 90
			local STR = "GRED_ARTILLERY_"..#gred.ActiveArtilleryStrikes+1
			table.insert(gred.ActiveArtilleryStrikes,STR)
			
			timer.Simple(MODEL_SPAWNDELAY,function()
				if not table.HasValue(gred.ActiveArtilleryStrikes,STR) then return end
				CreatePlane(MODEL,MODEL_SPAWN_AT_HITPOS,tr,ang,MODEL_ANIMRATE)
				
			end)
			
			timer.Simple(DROPDELAY,function()
				if not table.HasValue(gred.ActiveArtilleryStrikes,STR) then return end
				local MUL = 450
				local HALF_COUNT_1 = math.ceil(BOMB_COUNT*0.5)
				local dir = ang:Forward()*-MUL
				
				local BPos = tr.HitPos + dir*HALF_COUNT_1
				
				timer.Create(STR,0.2,BOMB_COUNT,function()
					if not table.HasValue(gred.ActiveArtilleryStrikes,STR) then return end
					if !util.IsInWorld(BPos) then return end
					
					local HitBPos = Vector(0,0,util.QuickTrace(BPos,BPos - reachSky).HitPos.z) -- Defines the ground's pos
					local zpos = Vector(0,0,BPos.z) -- The exact spawn altitude
					local dist = HitBPos:Distance(zpos) -- Calculates the distance between our spawn altitude and the ground
					
					----------------------
					
					local snd = table.Random(WHISTLE_SOUNDS.BOMBER)
					local sndDuration = SoundDuration(snd)
					local oldpos = BPos
					
					local time = (dist*-0.001)+(sndDuration-0.2) -- Calculates when to play the whistle sound
					if time < 0 then
						local b = ents.Create(BOMB_CLASSNAME)
						b:SetPos(oldpos)
						b:SetAngles(ang)
						b:Spawn()
						b:Activate()
						b:Arm()
						timer.Simple(-time,function()
							if !IsValid(b) then return end
							b:EmitSound(snd, 140, 100, 1)
						end)
					else
						local p = ents.Create("prop_dynamic")
						p:SetModel("models/hunter/blocks/cube025x025x025.mdl")
						p:SetPos(oldpos)
						p:Spawn()
						p:SetRenderMode(RENDERMODE_TRANSALPHA)
						p:SetColor(COL_INVISIBLE)
						p:EmitSound(snd,140,100,1)
						p:Remove()
						timer.Simple(time,function()
							local b = ents.Create(BOMB_CLASSNAME)
							b:SetPos(oldpos)
							b:SetAngles(ang)
							b:Spawn()
							b:Activate()
							b:Arm()
							b.PhysicsUpdate = function(data,phys)
								phys:SetVelocityInstantaneous(Vector(0,0,-1000))
							end
						end)
					end
					
					BPos = BPos - dir
				end)
			end)
		end,
		
		GUNRUN = function(ply,tr,EyeTrace,caliber,firerate,firetime,tracercolor,guncount,Spread,ENDPITCH,dmg,FLYBY_SOUND,MODEL,MODEL_SPAWNDELAY,DELAY,MODEL_SPAWN_AT_HITPOS,GUN_SOUND)
			if FLYBY_SOUND then
				net.Start("gred_net_artiplaysound")
					net.WriteString(FLYBY_SOUND)
				net.Broadcast()
			end
			
			local ang = (EyeTrace.StartPos - EyeTrace.HitPos):Angle()
			
			ang.y = ang.y - 180
			
			local GUN_POS = {}
			local Tab = {}
			local MUL = 50
			local dir = ang:Right()*MUL
			
			for i = 1,guncount do
				GUN_POS[i] = GUN_POS[i-1] and GUN_POS[i-1] + dir or tr.HitPos - dir*guncount*0.5
			end
			
			local STR = "GRED_ARTILLERY_"..#gred.ActiveArtilleryStrikes + 1
			table.insert(gred.ActiveArtilleryStrikes,STR)
			
			timer.Simple(MODEL_SPAWNDELAY,function()
				if not table.HasValue(gred.ActiveArtilleryStrikes,STR) then return end
				
				CreatePlane(MODEL,MODEL_SPAWN_AT_HITPOS,tr,ang,MODEL_ANIMRATE)
			end)
			
			local CUR_POS = 1
			ang:Normalize()
			ang.p = 110
			
			local approach = ((ang.p-ENDPITCH)*firerate)/firetime
			
			timer.Simple(DELAY,function()
				if not table.HasValue(gred.ActiveArtilleryStrikes,STR) then return end
				
				if GUN_SOUND then
					net.Start("gred_net_artiplaysound")
						net.WriteString(GUN_SOUND)
					net.Broadcast()
				end
				
				timer.Create(STR,firerate,firetime/firerate,function()
					PrintTable(GUN_POS)
					CUR_POS = CUR_POS > #GUN_POS and 1 or CUR_POS
					
					ang.p = math.ApproachAngle(ang.p,ENDPITCH,approach)
					
					gred.CreateBullet(ply,GUN_POS[CUR_POS] + Vector(),ang + Angle(math.Rand(Spread,-Spread),math.Rand(Spread,-Spread),math.Rand(Spread,-Spread)),caliber,Tab,nil,false,"red",dmg)
					
					CUR_POS = CUR_POS + 1
				end)
			end)
		end,
		
		TYPHOON = function(ply,tr,EyeTrace,ROCKET_CLASSNAME,FIRERATE,ROCKETCOUNT,ENDPITCH,FLYBY_SOUND,MODEL,MODEL_SPAWNDELAY,DELAY,MODEL_SPAWN_AT_HITPOS)
			if FLYBY_SOUND then
				net.Start("gred_net_artiplaysound")
					net.WriteString(FLYBY_SOUND)
				net.Broadcast()
			end
			local ang = (EyeTrace.StartPos - EyeTrace.HitPos):Angle()
			ang.y = ang.y - 180
			local GUN_POS = {}
			
			local MUL = 300
			local dir = ang:Right()*MUL
			for i = 1,2 do
				GUN_POS[i] = GUN_POS[i-1] and GUN_POS[i-1] + dir or tr.HitPos - dir*2*0.5
			end
			
			local STR = "GRED_ARTILLERY_"..#gred.ActiveArtilleryStrikes+1
			table.insert(gred.ActiveArtilleryStrikes,STR)
			
			timer.Simple(MODEL_SPAWNDELAY,function()
				if not table.HasValue(gred.ActiveArtilleryStrikes,STR) then return end
				
				CreatePlane(MODEL,MODEL_SPAWN_AT_HITPOS,tr,ang,MODEL_ANIMRATE)
			end)
			
			local CUR_POS = 1
			ang:Normalize()
			ang.p = 110
			local firetime = ROCKETCOUNT*FIRERATE*0.5
			local approach = ((ang.p-ENDPITCH)*FIRERATE)/firetime
			timer.Simple(DELAY,function()
				if not table.HasValue(gred.ActiveArtilleryStrikes,STR) then return end
				timer.Create(STR,FIRERATE,ROCKETCOUNT*0.5,function()
					ang.p = math.ApproachAngle(ang.p,ENDPITCH,approach)
					for i = 1,2 do
						CUR_POS = CUR_POS > #GUN_POS and 1 or CUR_POS
						local b = ents.Create(ROCKET_CLASSNAME)
						b:SetPos(GUN_POS[CUR_POS])
						b:SetAngles(ang)
						b:Spawn()
						b:Activate()
						b:Launch()
						CUR_POS = CUR_POS + 1
					end
				end)
			end)
		end,
	}
end

-- Precache sounds

local utilPrecacheSound = util.PrecacheSound
local totalsounds = 0

for k,v in pairs(file.Find('sound/american_01/suppressed/*.wav', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/american_01/unsuppressed/*.wav', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end

for k,v in pairs(file.Find('sound/british/suppressed/*.wav', "GAME")) do
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/british/unsuppressed/*.wav', "GAME")) do
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end

for k,v in pairs(file.Find('sound/german_01/suppressed/*.wav', "GAME")) do 
	utilPrecacheSound(v)
	totalsounds = totalsounds + 1
end
for k,v in pairs(file.Find('sound/german_01/unsuppressed/*.wav', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1
end

for k,v in pairs(file.Find('sound/radio/axis/*.ogg', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/radio/allied/british/*.ogg', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/radio/allied/american/*.ogg', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end

for k,v in pairs(file.Find('sound/artillery/far/*.wav', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/artillery/flyby/*.wav', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end
for k,v in pairs(file.Find('sound/artillery/flyby/*.ogg', "GAME")) do 
	utilPrecacheSound(v) 
	totalsounds = totalsounds + 1 
end

print("[GREDWITCH'S ARTILLERY SWEPs] Precached "..totalsounds.." sounds.")