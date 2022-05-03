DSKst = DSKst or {}

local function bcDamage( vehicle , position , cdamage )
	if not simfphys.DamageEnabled then return end
	
	cdamage = cdamage or false
	net.Start( "simfphys_spritedamage" )
		net.WriteEntity( vehicle )
		net.WriteVector( position ) 
		net.WriteBool( cdamage ) 
	net.Broadcast()
end

local function DestroyVehicle( ent )
	if not IsValid( ent ) then return end
	if ent.destroyed then return end
	
	ent.destroyed = true
	
	local ply = ent.EntityOwner
	local skin = ent:GetSkin()
	local Col = ent:GetColor()
	Col.r = Col.r * 0.8
	Col.g = Col.g * 0.8
	Col.b = Col.b * 0.8
	
	local bprop = ents.Create( "gmod_sent_vehicle_fphysics_gib" )
	bprop:SetModel( ent:GetModel() )			
	bprop:SetPos( ent:GetPos() )
	bprop:SetAngles( ent:GetAngles() )
	bprop:Spawn()
	bprop:Activate()
	bprop:GetPhysicsObject():SetVelocity( ent:GetVelocity() + Vector(math.random(-5,5),math.random(-5,5),math.random(150,250)) ) 
	bprop:GetPhysicsObject():SetMass( ent.Mass * 0.75 )
	bprop.DoNotDuplicate = true
	bprop.MakeSound = true
	bprop:SetColor( Col )
	bprop:SetSkin( skin )
	
	ent.Gib = bprop
	
	simfphys.SetOwner( ply , bprop )
	
	if IsValid( ply ) then
		undo.Create( "Gib" )
		undo.SetPlayer( ply )
		undo.AddEntity( bprop )
		undo.SetCustomUndoText( "Undone Gib" )
		undo.Finish( "Gib" )
		ply:AddCleanup( "Gibs", bprop )
	end
	
	if ent.CustomWheels == true and not ent.NoWheelGibs then
		for i = 1, table.Count( ent.GhostWheels ) do
			local Wheel = ent.GhostWheels[i]
			if IsValid(Wheel) then
				local prop = ents.Create( "gmod_sent_vehicle_fphysics_gib" )
				prop:SetModel( Wheel:GetModel() )			
				prop:SetPos( Wheel:LocalToWorld( Vector(0,0,0) ) )
				prop:SetAngles( Wheel:LocalToWorldAngles( Angle(0,0,0) ) )
				prop:SetOwner( bprop )
				prop:Spawn()
				prop:Activate()
				prop:GetPhysicsObject():SetVelocity( ent:GetVelocity() + Vector(math.random(-5,5),math.random(-5,5),math.random(0,25)) )
				prop:GetPhysicsObject():SetMass( 20 )
				prop.DoNotDuplicate = true
				bprop:DeleteOnRemove( prop )
				
				simfphys.SetOwner( ply , prop )
			end
		end
	end
	
	local Driver = ent:GetDriver()
	if IsValid( Driver ) then
		if ent.RemoteDriver ~= Driver then
			Driver:TakeDamage( Driver:Health() + Driver:Armor(), ent.LastAttacker or Entity(0), ent.LastInflictor or Entity(0) )
		end
	end
	
	if ent.PassengerSeats then
		for i = 1, table.Count( ent.PassengerSeats ) do
			local Passenger = ent.pSeat[i]:GetDriver()
			if IsValid( Passenger ) then
				Passenger:TakeDamage( Passenger:Health() + Passenger:Armor(), ent.LastAttacker or Entity(0), ent.LastInflictor or Entity(0) )
			end
		end
	end
	
	ent:Extinguish() 
	
	ent:OnDestroyed()
	
	ent:Remove()
end

local function DamageVehicle( ent , damage, type )
	if not simfphys.DamageEnabled then return end
	
	local MaxHealth = ent:GetMaxHealth()
	local CurHealth = ent:GetCurHealth()
	
	local NewHealth = math.max( math.Round(CurHealth - damage,0) , 0 )
	
	if NewHealth <= (MaxHealth * 0.6) then
		if NewHealth <= (MaxHealth * 0.3) then
			ent:SetOnFire( true )
			ent:SetOnSmoke( false )
		else
			ent:SetOnSmoke( true )
		end
	end
	
	if MaxHealth > 30 and NewHealth <= 31 then
		if ent:EngineActive() then
			ent:DamagedStall()
		end
	end
	
	if NewHealth <= 0 then
		if type ~= DMG_GENERIC and type ~= DMG_CRUSH or damage > 400 then
			
			DestroyVehicle( ent )
			
			return
		end
		
		if ent:EngineActive() then
			ent:DamagedStall()
		end
		
		return
	end
	
	ent:SetCurHealth( NewHealth )
end
--система  повреждения 
function DSKst.TankTakeDamage( ent, dmginfo )
	ent:TakePhysicsDamage( dmginfo )

	if not ent:IsInitialized() then return end

	local Damage = dmginfo:GetDamage()
	local DamagePos = dmginfo:GetDamagePosition()
	local Type = dmginfo:GetDamageType()

	ent.LastAttacker = dmginfo:GetAttacker() 
	ent.LastInflictor = dmginfo:GetInflictor()

	bcDamage( ent , ent:WorldToLocal( DamagePos ) )
	local Mul = 0
	--дамаг от рпг
	if Damage >=100 and Type==64 then
		Mul = Damage*10
	end
	--дамаг от противотанковых орудий и ББ
	if Damage >=160 and Type~=64 then
			Mul = Damage
	end
	DamageVehicle( ent , Mul, Type )
end