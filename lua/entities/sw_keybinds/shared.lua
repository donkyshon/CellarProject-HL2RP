ENT.Base 				= "wac_pl_base"
ENT.Type 				= "anim"
ENT.Category			= "SW Aircraft Plant"
ENT.PrintName			= "SW Keybinds"
ENT.Author				= "Shermann Wolf"
ENT.Engines = 1
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.Model            = nil
ENT.RotorPhModel        = nil
ENT.RotorModel        = nil
ENT.rotorPos        = Vector(0,0,0)
ENT.TopRotorDir        = 1.0
ENT.AutomaticFrameAdvance = true
ENT.EngineForce        = 0
ENT.Weight            = 0
ENT.SeatSwitcherPos	= Vector(0,0,0)
ENT.AngBrakeMul	= 0
ENT.SmokePos       = ENT.rotorPos
ENT.FirePos        = ENT.SmokePos
ENT.thirdPerson = {
	distance = 500
}

ENT.Agility = {
}

ENT.Wheels={
}

ENT.Seats = {
}

ENT.Weapons = {
}
ENT.WeaponAttachments={
}
ENT.Camera = {
}

ENT.Sounds={
}
wac.hook("wacAirAddInputs", "wac_aircraft_sw", function()
	wac.aircraft.addControls("Flight Controls", {
        Cockpit = {true, KEY_},
		Cargo_ramp = {true, KEY_},
		Door1 = {true, KEY_},
		Door2 = {true, KEY_},
		Door3 = {true, KEY_},
		Door4 = {true, KEY_},
		Landing_Gear = {true, KEY_},
        Wings = {true, KEY_},
		Catapult = {true, KEY_},
		Flare = {true, KEY_},
    })
end)
ENT.Base 				= "wac_pl_base"
ENT.Type 				= "anim"
ENT.Category			= "SW Aircraft Plant"
ENT.PrintName			= "SW Keybinds"
ENT.Author				= "Shermann Wolf"
ENT.Engines = 1
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.Model            = nil
ENT.RotorPhModel        = nil
ENT.RotorModel        = nil
ENT.rotorPos        = Vector(0,0,0)
ENT.TopRotorDir        = 1.0
ENT.AutomaticFrameAdvance = true
ENT.EngineForce        = 0
ENT.Weight            = 0
ENT.SeatSwitcherPos	= Vector(0,0,0)
ENT.AngBrakeMul	= 0
ENT.SmokePos       = ENT.rotorPos
ENT.FirePos        = ENT.SmokePos
ENT.thirdPerson = {
	distance = 500
}

ENT.Agility = {
}

ENT.Wheels={
}

ENT.Seats = {
}

ENT.Weapons = {
}
ENT.WeaponAttachments={
}
ENT.Camera = {
}

ENT.Sounds={
}
wac.hook("wacAirAddInputs", "wac_aircraft_sw", function()
	wac.aircraft.addControls("Flight Controls", {
        Cockpit = {true, KEY_},
		Cargo_ramp = {true, KEY_},
		Door1 = {true, KEY_},
		Door2 = {true, KEY_},
		Door3 = {true, KEY_},
		Door4 = {true, KEY_},
		Landing_Gear = {true, KEY_},
        Wings = {true, KEY_},
		Catapult = {true, KEY_},
		Flare = {true, KEY_},
    })
end)