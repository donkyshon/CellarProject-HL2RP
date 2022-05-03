local light_table = {
	L_HeadLampPos = Vector(126,45,55),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector(126,-45,55),
	R_HeadLampAng = Angle(0,0,0),
	
	Headlight_sprites = { 
		Vector(126,45,55),
		Vector(126,-47,55)
	},
	Rearlight_sprites = {
		Vector(-128,45,73),
		Vector(-128,-47,73)
	},
	Brakelight_sprites = {
		Vector(-128,45,73),
		Vector(-128,-47,73)
	},
	
}
list.Set( "simfphys_lights", "m2", light_table)

local V = {
	Name = "M2 BREDLEY",
	Model = "models/cod4/M2_Bradley.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "US ARMY",
	SpawnOffset = Vector(0,0,60),
	SpawnAngleOffset = 180,

	Members = {
		Mass = 12000,
		AirFriction = 0,
		--Inertia = Vector(14017.5,46543,47984.5),
		Inertia = Vector(20000,80000,100000),

		OnSpawn = function(ent) 
		ent.OnTakeDamage = DSKst.TankTakeDamage
		ent:SetNWBool( "simfphys_NoRacingHud", true ) end,
		
		OnDestroyed = 
			function(ent)
				if IsValid( ent.Gib ) then 
					local yaw = ent.sm_pp_yaw or 0
					local pitch = ent.sm_pp_pitch or 0
					ent.Gib:SetPoseParameter("cannon_aim_yaw", yaw - 0 )
					ent.Gib:SetPoseParameter("cannon_aim_pitch", -pitch )
				end
			end,

		LightsTable = "m2",

		MaxHealth = 9000,

		IsArmored = true,

		NoWheelGibs = true,

		FirstPersonViewPos = Vector(100,100,100),

		FrontWheelRadius = 40,
		RearWheelRadius = 40,

		EnginePos = Vector(90,0,60),

		CustomWheels = true,
		CustomSuspensionTravel = 10,

		CustomWheelModel = "models/props_c17/canisterchunk01g.mdl",
		--CustomWheelModel = "models/props_vehicles/apc_tire001.mdl",

		CustomWheelPosRL = Vector(-122,-50,30),
		CustomWheelPosRR = Vector(-122,50,30),
		CustomWheelPosML = Vector(0,-50,30),
		CustomWheelPosMR = Vector(0,50,30),
		CustomWheelPosFL = Vector(110,-50,30),
		CustomWheelPosFR = Vector(110,50,30),
		CustomWheelAngleOffset = Angle(0,0,90),

		CustomMassCenter = Vector(0,0,0),

		CustomSteerAngle = 60,

		SeatOffset = Vector(0,0,48),
		SeatPitch = -15,
		SeatYaw = 90,

		ModelInfo = {
			WheelColor = Color(0,0,0,0),
		},

		PassengerSeats = {
			{
				pos = Vector(0,0,32),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(0,0,32),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(0,0,32),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(0,0,32),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(0,0,32),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(0,0,32),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(0,0,32),
				ang = Angle(0,-90,0)
			},
		},

		FrontHeight = 1,
		FrontConstant = 50000,
		FrontDamping = 30000,
		FrontRelativeDamping = 300000,

		RearHeight = 1,
		RearConstant = 50000,
		RearDamping = 20000,
		RearRelativeDamping = 20000,

		FastSteeringAngle = 20,
		SteeringFadeFastSpeed = 300,

		TurnSpeed = 4,

		MaxGrip = 1500,
		Efficiency = 1,
		GripOffset = -500,
		BrakePower = 400,
		BulletProofTires = true,

		IdleRPM = 500,
		LimitRPM = 4500,
		PeakTorque = 610,
		PowerbandStart = 600,
		PowerbandEnd = 2600,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = true,

		FuelFillPos = Vector(139.42,-3.68,38.38),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 220,
		
		PowerBias = -0.3,
		
		EngineSoundPreset = 0,
		
		Sound_Idle = "simulated_vehicles/t90ms/idle.wav",
		Sound_IdlePitch = 1,
		
		Sound_Mid = "simulated_vehicles/sherman/low.wav",
		Sound_MidPitch = 1.5,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 100,
		Sound_MidFadeOutRate = 1,
		
		Sound_High = "simulated_vehicles/t90ms/high.wav",
		Sound_HighPitch = 1.5,
		Sound_HighVolume = 0.7,
		Sound_HighFadeInRPMpercent = 50,
		Sound_HighFadeInRate = 0.2,
		
		Sound_Throttle = "",
		Sound_ThrottlePitch = 0,
		Sound_ThrottleVolume = 0,
		
		snd_horn = "common/null.wav",
		ForceTransmission = 1,
		
		DifferentialGear = 0.4,
		Gears = {-0.06,0,0.06,0.08,0.1,0.12,0.13}
	}
}
list.Set( "simfphys_vehicles", "m2_bredley", V )