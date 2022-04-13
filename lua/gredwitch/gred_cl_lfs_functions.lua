


local function DrawCircle( X, Y, radius ) -- copyright LunasFlightSchool™
	local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
	
	for a = 0, 360 - segmentdist, segmentdist do
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
	end
end



gred.UpdateBoneTable = function(self)
	if self.CreatingBones then return end
	self.Bones = nil
	timer.Simple(0,function()
		if !self or (self and !IsValid(self)) then return end
		if self.CreatingBones then return end
		self.CreatingBones = true
		self:SetLOD(0)
		self.Bones = {}
		local name
		for i=0, self:GetBoneCount()-1 do
			name = self:GetBoneName(i)
			if name == "__INVALIDBONE__" and ((self.BoneBlackList and !self.BoneBlackList[i]) or !self.BoneBlackList) and i != 0 then
				-- print("["..self.ClassName.."] INVALID BONE : "..i)
				self.Bones = nil
				break
			end
			self.Bones[name] = i
		end
		self:SetLOD(-1)
		self.CreatingBones = false
	end)
end

gred.ManipulateBoneAngles = function(self,bone,angle)
	if !self.Bones or (self.Bones and !self.Bones[bone]) then
		gred.UpdateBoneTable(self)
		return
	end
	
	self:ManipulateBoneAngles(self.Bones[bone],angle)
end

gred.ManipulateBonePosition = function(self,bone,pos)
	if !self.Bones or (self.Bones and !self.Bones[bone]) then
		gred.UpdateBoneTable(self)
		return
	end
	
	self:ManipulateBonePosition(self.Bones[bone],pos)
end

gred.ManipulateBoneScale = function(self,bone,scale)
	if !self.Bones or (self.Bones and !self.Bones[bone]) then
		gred.UpdateBoneTable(self)
		return
	end
	
	self:ManipulateBoneScale(self.Bones[bone],scale)
end

gred.HandleFlyBySound = function(self,ply,ct,minvel,maxdist,delay,snd)
	ply.NGPLAY = ply.NGPLAY or 0
	ply.lfsGetPlane = ply.lfsGetPlane or function() return nil end
	if ply:lfsGetPlane() != self and (ply.NGPLAY < ct) and self:GetEngineActive() then
		local vel = self:GetVelocity():Length()
		if vel >= minvel then
			local plypos = ply:GetPos()
			local pos = self:GetPos()
			local dist = pos:Distance(plypos)
			if dist < maxdist then
				ply.NGPLAY = ct + delay
				ply:EmitSound(snd)
			end
		end
	end
end

gred.HandleVoiceLines = function(self,ply,ct,hp)
	ply.lfsGetPlane = ply.lfsGetPlane or function() return nil end
	self.BumpSound = self.BumpSound or ct
	if self.BumpSound < ct then
		for k,v in pairs(self.SoundQueue) do
			ply:EmitSound(v)
			
			table.RemoveByValue(self.SoundQueue,v)
			self.BumpSound = ct + 4
			break
		end
	end
	
	if self.IsDead then
		local Driver = self:GetDriver()
		if self.CheckDriver and Driver != self.OldDriver and !IsValid(Driver) then
			for k,v in pairs(player.GetAll()) do
				if v:lfsGetAITeam() == self.OldDriver:lfsGetAITeam() and (IsValid(v:lfsGetPlane()) or v == self.OldDriver) then
					v:EmitSound("GRED_VO_BAILOUT_0"..math.random(1,3))
				end
			end
		end
		self.CheckDriver = true
		self.OldDriver = Driver
	end
	if ply:lfsGetPlane() == self then
		if self.EmitNow.wing_r and self.EmitNow.wing_r != "CEASE" then
			self.EmitNow.wing_r = "CEASE"
			table.insert(self.SoundQueue,"GRED_VO_HOLE_RIGHT_WING_0"..math.random(1,3))
		end
		if self.EmitNow.wing_l and self.EmitNow.wing_l != "CEASE" then
			self.EmitNow.wing_l = "CEASE"
			table.insert(self.SoundQueue,"GRED_VO_HOLE_LEFT_WING_0"..math.random(1,3))
		end
		if hp == 0 then
			self.IsDead = true
		end
	end
end

gred.LFSHUDPaintFilterParts = function(self)
	local partnum = {}
	local a = 1
	if self.Parts then
		for k,v in pairs(self.Parts) do
			partnum[a] = v
			a = a + 1
		end
	end
	partnum[a] = self
	
	return partnum
end

gred.CalcViewThirdPersonLFSParts = function(self,view,ply)
	view.origin = ply:EyePos()
	local Parent = ply:lfsGetPlane()
	local Pod = ply:GetVehicle()
	local radius = 550
	radius = radius + radius * Pod:GetCameraDistance()
	local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
	local WallOffset = 4
	local tr = util.TraceHull( {
		start = view.origin,
		endpos = TargetOrigin,
		filter = function( e )
			local c = e:GetClass()
			local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS and Parent:GetCalcViewFilter(e)
			
			return collide
		end,
		mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
		maxs = Vector( WallOffset, WallOffset, WallOffset ),
	} )
	view.origin = tr.HitPos
	
	if tr.Hit and not tr.StartSolid then
		view.origin = view.origin + tr.HitNormal * WallOffset
	end
	
	return view
end

gred.GunnersInit = function(self)
	local ATT
	local seat
	for k,v in pairs(self.Gunners) do
		for a,b in pairs(v.att) do
			v.att[a] = self:LookupAttachment(b)
		end
	end
end

gred.GunnersDriverHUDPaint = function(self,ply)
	if !self.Initialized then
		gred.GunnersInit(self)
		self.Initialized = true
	end
	
	local att
	local tr
	local filter = self:GetCrosshairFilterEnts()
	local ScrW,ScrH = ScrW(),ScrH()
	local pparam1
	local pparam2
	local alpha
	
	for k,v in pairs(self.Gunners) do
		att = self:GetAttachment(v.att[1])
		tr = TraceLine({
			start = att.Pos,
			endpos = (att.Pos + att.Ang:Forward() * 50000),
			filter = filter
		})
		
		alpha = !IsValid(self["GetGunner"..k](self)) and 255 or 0
		
		pparam1,pparam2 = self:GetPoseParameter(v.poseparams[1]),self:GetPoseParameter(v.poseparams[2])
		
		if pparam1 == 1 or pparam2 == 1 or pparam1 == 0 or pparam2 == 0 then -- yea but shut up ok
			surface.SetDrawColor(255,0,0,alpha)
		else
			surface.SetDrawColor(0,255,0,alpha)
		end
		
		tr.ScreenPos = tr.HitPos:ToScreen()
		tr.ScreenPos.x = tr.ScreenPos.x > ScrW and tr.ScreenPosW or (tr.ScreenPos.x < 0 and 0 or tr.ScreenPos.x)
		tr.ScreenPos.y = tr.ScreenPos.y > ScrH and tr.ScreenPosH or (tr.ScreenPos.y < 0 and 0 or tr.ScreenPos.y)
		DrawCircle(tr.ScreenPos.x,tr.ScreenPos.y,5)
	end
end

gred.GunnersHUDPaint = function(self,ply)
	if !self.Initialized then
		gred.GunnersInit(self)
		self.Initialized = true
	end
	
	local att
	local tr
	local filter = self:GetCrosshairFilterEnts()
	local ScrW,ScrH = ScrW(),ScrH()
	local pparam1
	local pparam2
	local veh = ply:GetVehicle()
	for k,v in pairs(self.Gunners) do
		if veh == self["GetGunnerSeat"..k](self) then
			att = self:GetAttachment(v.att[1])
			tr = TraceLine({
				start = att.Pos,
				endpos = (att.Pos + att.Ang:Forward() * 50000),
				filter = filter
			})
			
			pparam1,pparam2 = self:GetPoseParameter(v.poseparams[1]),self:GetPoseParameter(v.poseparams[2])
			
			if pparam1 == 1 or pparam2 == 1 or pparam1 == 0 or pparam2 == 0 then -- yea but shut up ok
				surface.SetDrawColor(255,0,0,255)
			else
				surface.SetDrawColor(0,255,0,255)
			end
			
			tr.ScreenPos = tr.HitPos:ToScreen()
			tr.ScreenPos.x = tr.ScreenPos.x > ScrW and tr.ScreenPosW or (tr.ScreenPos.x < 0 and 0 or tr.ScreenPos.x)
			tr.ScreenPos.y = tr.ScreenPos.y > ScrH and tr.ScreenPosH or (tr.ScreenPos.y < 0 and 0 or tr.ScreenPos.y)
			DrawCircle(tr.ScreenPos.x,tr.ScreenPos.y,5)
			break
		end
	end
end



net.Receive("gred_lfs_setparts",function()
	local self = net.ReadEntity()
	if not self then print("[LFS] ERROR! ENTITY NOT INITALIZED CLIENT SIDE! PLEASE, RE-SPAWN!") return end
	self.Parts = {}
	for k,v in pairs(net.ReadTable()) do
		self.Parts[k] = v
	end
end)

net.Receive("gred_lfs_remparts",function()
	local self = net.ReadEntity()
	local k = net.ReadString()
	
	self.EmitNow = istable(self.EmitNow) and self.EmitNow or {}
	if self.EmitNow and (k == "wing_l" or k == "wing_r") and self.EmitNow[k] != "CEASE" then
		self.EmitNow[k] = true
	end
	if self.Parts then
		self.Parts[k] = nil
	end
end)
