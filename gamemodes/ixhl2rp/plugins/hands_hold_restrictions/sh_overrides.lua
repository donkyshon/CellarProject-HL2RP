
if (SERVER) then
	util.AddNetworkString("ixPickedUpPlayer")
else
	net.Receive("ixPickedUpPlayer", function()
		local client = LocalPlayer()
		local heldPlayer = net.ReadEntity()

		if (IsValid(heldPlayer) and heldPlayer != game.GetWorld()) then
			client.ixHeldPlayer = heldPlayer
		else
			client.ixHeldPlayer = nil
		end
	end)
end

local ix_hands = weapons.Get("ix_hands")

function ix_hands:PickupObject(entity)
	if (self:IsHoldingObject() or
		!IsValid(entity) or
		!IsValid(entity:GetPhysicsObject())) then
		return
	end

	local physics = entity:GetPhysicsObject()
	physics:EnableGravity(false)
	physics:AddGameFlag(FVPHYSICS_PLAYER_HELD)

	entity.ixHeldOwner = self:GetOwner()
	entity.ixCollisionGroup = entity:GetCollisionGroup()
	entity:StartMotionController()
	entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	self.heldObjectAngle = entity:GetAngles()
	self.heldEntity = entity

	self.holdEntity = ents.Create("prop_physics")
	self.holdEntity:SetPos(self.heldEntity:LocalToWorld(self.heldEntity:OBBCenter()))
	self.holdEntity:SetAngles(self.heldEntity:GetAngles())
	self.holdEntity:SetModel("models/weapons/w_bugbait.mdl")
	self.holdEntity:SetOwner(self:GetOwner())

	self.holdEntity:SetNoDraw(true)
	self.holdEntity:SetNotSolid(true)
	self.holdEntity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.holdEntity:DrawShadow(false)

	self.holdEntity:Spawn()

	local trace = self:GetOwner():GetEyeTrace()
	local physicsObject = self.holdEntity:GetPhysicsObject()

	if (IsValid(physicsObject)) then
		physicsObject:SetMass(2048)
		physicsObject:SetDamping(0, 1000)
		physicsObject:EnableGravity(false)
		physicsObject:EnableCollisions(false)
		physicsObject:EnableMotion(false)
	end

	if (trace.Entity:IsRagdoll()) then
		local tracedEnt = trace.Entity
		self.holdEntity:SetPos(tracedEnt:GetBonePosition(tracedEnt:TranslatePhysBoneToBone(trace.PhysicsBone)))
	end

	self.constraint = constraint.Weld(self.holdEntity, self.heldEntity, 0,
		trace.Entity:IsRagdoll() and trace.PhysicsBone or 0, 0, true, true)

	-- PickupObject func is being executed only on server
	if (self.heldEntity.ixPlayer) then
		self:GetOwner().ixHeldPlayer = self.heldEntity.ixPlayer

		net.Start("ixPickedUpPlayer")
			net.WriteEntity(self.heldEntity.ixPlayer)
		net.Send(self:GetOwner())

		self.bHeldPlayerSent = true
	end
end

function ix_hands:DropObject(bThrow)
	-- DropObject func is being executed only on server
	if (self.bHeldPlayerSent) then
		self:GetOwner().ixHeldPlayer = nil

		net.Start("ixPickedUpPlayer")
		net.Send(self:GetOwner())

		self.bHeldPlayerSent = nil
	end

	if (!IsValid(self.heldEntity) or self.heldEntity.ixHeldOwner != self:GetOwner()) then
		return
	end

	self.lastPlayerAngles = nil
	self:GetOwner():SetLocalVar("bIsHoldingObject", false)

	self.constraint:Remove()
	self.holdEntity:Remove()

	self.heldEntity:StopMotionController()
	self.heldEntity:SetCollisionGroup(self.heldEntity.ixCollisionGroup or COLLISION_GROUP_NONE)

	local physics = self:GetHeldPhysicsObject()
	physics:EnableGravity(true)
	physics:Wake()
	physics:ClearGameFlag(FVPHYSICS_PLAYER_HELD)

	if (bThrow) then
		timer.Simple(0, function()
			if (IsValid(physics) and IsValid(self:GetOwner())) then
				physics:AddGameFlag(FVPHYSICS_WAS_THROWN)
				physics:ApplyForceCenter(self:GetOwner():GetAimVector() * ix.config.Get("throwForce", 732))
			end
		end)
	end

	self.heldEntity.ixHeldOwner = nil
	self.heldEntity.ixCollisionGroup = nil
	self.heldEntity = nil
end

-- we will re-register SWEP to prevent auto refresh issues
weapons.Register(ix_hands, "ix_hands")
