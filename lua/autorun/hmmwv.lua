local light_table = {
	L_HeadLampPos = Vector(109,-32,50),
	L_HeadLampAng = Angle(0,0,0),
	R_HeadLampPos = Vector(109,32,50),
	R_HeadLampAng = Angle(0,0,0),
	
	Headlight_sprites = {   -- lowbeam
		{
			pos = Vector(98,22,38),
			material = "sprites/light_ignorez",
			size = 55,
			color = Color(255,238,200,255),
		},
		{
			pos = Vector(98,-22,38),
			material = "sprites/light_ignorez",
			size = 55,
			color = Color(255,238,200,255),
		},
	},
	Rearlight_sprites = {
		Vector(-103,-34.5,40),
		Vector(-103,34.5,40)
	},
	Brakelight_sprites = {
		Vector(-103,-34.5,40),
		Vector(-103,34.5,40)
	},
	Turnsignal_sprites = {
		Left = {
		Vector(-103,-43,37),
		Vector(93,-39,42),
		},
		Right = {
		Vector(-103,43,37),
		Vector(93,39,42),
		},
	},
	
}
list.Set( "simfphys_lights", "hmmwv", light_table)

local V = {
	Name = "HMMWV (1 variant)",
	Model = "models/hmmwv.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Simfphys USA",
	SpawnOffset = Vector(0,0,0),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2500,
		EnginePos = Vector(90,0,48),
		BulletProofTires = true,
		
		LightsTable = "hmmwv",
		
		MaxHealth = 2450,
		
		IsArmored = true,
				
		CustomWheels = true,       	 -- You have to set this to "true" in order to define custom wheels
		CustomSuspensionTravel = 10,	--suspension travel limiter length
		
		FrontWheelRadius = 20,		-- if you set CustomWheels to true then the script will figure the radius out by itself using the CustomWheelModel
		RearWheelRadius = 20,
		
		CustomWheelModel = "models/wheels.mdl",	-- since we create our own wheels we have to define a model. It has to have a collission model
		--CustomWheelModel_R = "",			-- different model for rear wheels?
		CustomWheelPosFL = Vector(71,41,15),		-- set the position of the front left wheel. 
		CustomWheelPosFR = Vector(71,-41,15),	-- position front right wheel
		CustomWheelPosRL = Vector(-73,41,15),	-- rear left
		CustomWheelPosRR = Vector(-73,-41,15),	-- rear right		NOTE: make sure the position actually matches the name. So FL is actually at the Front Left ,  FR Front Right, ...   if you do this wrong the wheels will spin in the wrong direction or the car will drive sideways/reverse
		CustomWheelAngleOffset = Angle(0,180,0),
		
		CustomMassCenter = Vector(0,0,10),		-- custom masscenter offset. The script creates a counter weight to make the masscenter exactly in the center of the wheels. However you can add an offset to this to create more body roll if you really have to...
		
		CustomSteerAngle = 30,				-- max clamped steering angle,

		SeatOffset = Vector(0,-30,60),
		SeatPitch = 0,
		SeatYaw = 90,

		ExhaustPositions = {
			{
				pos = Vector(-40,-38,20),
				ang = Angle(90,-90,0)
			},
			{
				pos = Vector(-40,-38,20),
				ang = Angle(90,-90,0)
			},
			{
				pos = Vector(-40,-38,20),
				ang = Angle(90,-90,0)
			},
			{
				pos = Vector(-40,38,20),
				ang = Angle(90,90,0)
			},
			{
				pos = Vector(-40,38,20),
				ang = Angle(90,90,0)
			},
			{
				pos = Vector(-40,38,20),
				ang = Angle(90,90,0)
			},
		},
		
		PassengerSeats = {
			{
				pos = Vector(-20,0,60),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(3,-30,28),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-35,-30,28),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-35,30,28),
				ang = Angle(0,-90,0)
			},

		},

		FrontHeight = 2,
		FrontConstant = 100000,
		FrontDamping = 7000,
		FrontRelativeDamping = 4000,
		
		RearHeight = 2,
		RearConstant = 100000,
		RearDamping = 7000,
		RearRelativeDamping = 4000,
		
		FastSteeringAngle = 20,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 4,
		
		MaxGrip = 120,
		Efficiency = 1,
		GripOffset = -1,
		BrakePower = 80,
		
		IdleRPM = 3000,
		LimitRPM = 8000,
		PeakTorque = 200,
		PowerbandStart = 650,
		PowerbandEnd = 7800,
		Turbocharged = false,
		Supercharged = false,
		
		FuelFillPos = Vector(-40,48,48),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,
		
		PowerBias = 2,
		
		EngineSoundPreset = -1,
		
		snd_pitch = 1,
		snd_idle = "simulated_vehicles/4banger/4banger_idle.wav",
		
		snd_low = "simulated_vehicles/4banger/4banger_low.wav",
		snd_low_pitch = 0.6,
		
		snd_mid = "simulated_vehicles/4banger/4banger_mid.wav",
		snd_mid_gearup = "simulated_vehicles/4banger/4banger_second.wav",
		snd_mid_pitch = 0.5,
		
		snd_horn = "simulated_vehicles/horn_2.wav",
		
		DifferentialGear = 0.2,
		Gears = {-0.4,0,0.4,0.8,0.12,0.14,0.17}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_hmmwv", V )

local V = {
	Name = "HMMWV (2 variant)",
	Model = "models/hmmwv1.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Simfphys USA",
	SpawnOffset = Vector(0,0,0),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2500,
		EnginePos = Vector(90,0,48),
		BulletProofTires = true,
		
		LightsTable = "hmmwv",
		
		MaxHealth = 2450,
		
		IsArmored = true,
				
		CustomWheels = true,       	 -- You have to set this to "true" in order to define custom wheels
		CustomSuspensionTravel = 10,	--suspension travel limiter length
		
		FrontWheelRadius = 20,		-- if you set CustomWheels to true then the script will figure the radius out by itself using the CustomWheelModel
		RearWheelRadius = 20,
		
		CustomWheelModel = "models/wheels.mdl",	-- since we create our own wheels we have to define a model. It has to have a collission model
		--CustomWheelModel_R = "",			-- different model for rear wheels?
		CustomWheelPosFL = Vector(71,41,15),		-- set the position of the front left wheel. 
		CustomWheelPosFR = Vector(71,-41,15),	-- position front right wheel
		CustomWheelPosRL = Vector(-73,41,15),	-- rear left
		CustomWheelPosRR = Vector(-73,-41,15),	-- rear right		NOTE: make sure the position actually matches the name. So FL is actually at the Front Left ,  FR Front Right, ...   if you do this wrong the wheels will spin in the wrong direction or the car will drive sideways/reverse
		CustomWheelAngleOffset = Angle(0,180,0),
		
		CustomMassCenter = Vector(0,0,10),		-- custom masscenter offset. The script creates a counter weight to make the masscenter exactly in the center of the wheels. However you can add an offset to this to create more body roll if you really have to...
		
		CustomSteerAngle = 30,				-- max clamped steering angle,

		SeatOffset = Vector(0,-30,60),
		SeatPitch = 0,
		SeatYaw = 90,

		ExhaustPositions = {
			{
				pos = Vector(-40,-38,20),
				ang = Angle(90,-90,0)
			},
			{
				pos = Vector(-40,-38,20),
				ang = Angle(90,-90,0)
			},
			{
				pos = Vector(-40,-38,20),
				ang = Angle(90,-90,0)
			},
			{
				pos = Vector(-40,38,20),
				ang = Angle(90,90,0)
			},
			{
				pos = Vector(-40,38,20),
				ang = Angle(90,90,0)
			},
			{
				pos = Vector(-40,38,20),
				ang = Angle(90,90,0)
			},
		},
		
		PassengerSeats = {
			{
				pos = Vector(-20,0,60),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(3,-30,28),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-35,-30,28),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-35,30,28),
				ang = Angle(0,-90,0)
			},
			{
				pos = Vector(-65,-34,46),
				ang = Angle(0,0,0)
			},
			{
				pos = Vector(-88,-34,46),
				ang = Angle(0,0,0)
			},
			{
				pos = Vector(-65,34,46),
				ang = Angle(0,180,0)
			},
			{
				pos = Vector(-88,34,46),
				ang = Angle(0,180,0)
			},

		},

		FrontHeight = 2,
		FrontConstant = 100000,
		FrontDamping = 7000,
		FrontRelativeDamping = 4000,
		
		RearHeight = 2,
		RearConstant = 100000,
		RearDamping = 7000,
		RearRelativeDamping = 4000,
		
		FastSteeringAngle = 20,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 4,
		
		MaxGrip = 120,
		Efficiency = 1,
		GripOffset = -1,
		BrakePower = 80,
		
		IdleRPM = 3000,
		LimitRPM = 8000,
		PeakTorque = 200,
		PowerbandStart = 650,
		PowerbandEnd = 7800,
		Turbocharged = false,
		Supercharged = false,
		
		FuelFillPos = Vector(-40,48,48),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,
		
		PowerBias = 2,
		
		EngineSoundPreset = -1,
		
		snd_pitch = 1,
		snd_idle = "simulated_vehicles/4banger/4banger_idle.wav",
		
		snd_low = "simulated_vehicles/4banger/4banger_low.wav",
		snd_low_pitch = 0.6,
		
		snd_mid = "simulated_vehicles/4banger/4banger_mid.wav",
		snd_mid_gearup = "simulated_vehicles/4banger/4banger_second.wav",
		snd_mid_pitch = 0.5,
		
		snd_horn = "simulated_vehicles/horn_2.wav",
		
		DifferentialGear = 0.2,
		Gears = {-0.4,0,0.4,0.8,0.12,0.14,0.17}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_hmmwv2", V )