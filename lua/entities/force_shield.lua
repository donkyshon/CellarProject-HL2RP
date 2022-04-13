AddCSLuaFile()

util.PrecacheModel( "models/ovr_load/force_shield.mdl" )

if CLIENT then
surface.CreateFont("OvR_Load_HUD_Holo_1" , {
    font = "Kenney Future Square", --name of font
    size = 60,
    weight = 500,
    blursize = 2;
    scanlines = 2,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = true,
    outline = false
})
end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Author = "Trench"
ENT.Purpose = "deployable force shield for blocking income small arms fire- has hp and then is destroyed"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.spawnTime = 0
ENT.totalLifeTime = 30
ENT.hp = 800
ENT.mmRHAe = 10000 --Controls penetration resistance for ArcCW weapons, high number means no bullets from this pack will penetrate

local forceShieldImpactSounds = {
    [1] = "weapons/physcannon/superphys_small_zap1.wav",
    [2] = "weapons/physcannon/superphys_small_zap2.wav",
    [3] = "weapons/physcannon/superphys_small_zap3.wav",
    [4] = "weapons/physcannon/superphys_small_zap4.wav"
}

local HPColorValues = {
    [40] = Color(0, 80, 255),
    [39] = Color(0, 65, 255),
    [38] = Color(0, 50, 255),
    [37] = Color(0, 35, 255),
    [36] = Color(0, 20, 255),
    [35] = Color(0, 5, 255),
    [34] = Color(10, 0, 255),
    [33] = Color(25, 3, 255),
    [32] = Color(40, 0, 255),
    [31] = Color(55, 0, 255),
    [30] = Color(70, 0, 255),
    [29] = Color(85, 0, 255),
    [28] = Color(100, 0, 255),
    [27] = Color(115, 0, 255),
    [26] = Color(130, 0, 255),
    [25] = Color(145, 0, 255),
    [24] = Color(160, 0, 255),
    [23] = Color(175, 0, 255),
    [22] = Color(190, 0, 255),
    [21] = Color(205, 0, 255),
    [20] = Color(220, 0, 255),
    [19] = Color(235, 0, 255),
    [18] = Color(250, 0, 255),
    [17] = Color(255, 0, 245),
    [16] = Color(255, 0, 230),
    [15] = Color(255, 0, 215),
    [14] = Color(255, 0, 200),
    [13] = Color(255, 0, 185),
    [12] = Color(255, 0, 170),
    [11] = Color(255, 0, 155),
    [10] = Color(255, 0, 140),
    [9]  = Color(255, 0, 125),
    [8]  = Color(255, 0, 110),
    [7]  = Color(255, 0, 95),
    [6]  = Color(255, 0, 80),
    [5]  = Color(255, 0, 65),
    [4]  = Color(255, 0, 50),
    [3]  = Color(255, 0, 35),
    [2]  = Color(255, 0, 20),
    [1]  = Color(255, 0, 5),
    [0]  = Color(255, 0, 0),
}

PrecacheParticleSystem( "vortigaunt_hand_glow" )
util.PrecacheSound("ambient/machines/combine_shield_touch_loop1.wav")
util.PrecacheSound("ambient/levels/labs/electric_explosion5.wav")
util.PrecacheSound("weapons/stunstick/alyx_stunner1.wav")

for impactSound in ipairs(forceShieldImpactSounds) do
    util.PrecacheSound(forceShieldImpactSounds[impactSound])
end

    -- To get a read off the table above we only look at first two numbers of HP, since we never go over 999
    -- we can do this by dividing by 10 and flooring the result with math.floor  
    function ENT:Flicker()
        timer.Create( "shield_flicker_timer" .. tostring(self), .02, 24, function() 
            if !IsValid(self) then return end
            local color = self:GetColor()
            
            if(self.colorModulate == false)then
                color.a = math.abs(math.sin(CurTime()) * 100)
                self:SetColor(color)
            else 
                color.a = 255
                self:SetColor(color)
            end
            self.colorModulate = !self.colorModulate
        end)
    end

    function ENT:bulletImpactEffect(impactPoint, impactNormal)
        local effectdata = EffectData()
        effectdata:SetNormal(impactNormal)
        effectdata:SetOrigin(impactPoint)
        util.Effect( "AR2Impact", effectdata) 
        util.Effect( "selection_ring", effectdata)
    end
    
    function ENT:OnTakeDamage( dmginfo )
        local damage = dmginfo:GetDamage() 
        local HPColorValueIndex = math.floor((self.hp/2)/10)
        
        self:EmitSound(forceShieldImpactSounds[math.random(1,4)], 85)
        self:bulletImpactEffect(dmginfo:GetDamagePosition(), self:GetRight())
        self.hp = self.hp - damage 
        
        self:SetModelScale(.995, .05)
        timer.Simple(.05, function() 
            if (IsValid(self)) then 
                self:SetModelScale(1,.05) 
            end 
        end)

        if(self.hp <= 0) then
            self:Flicker()
            self:EmitSound("ambient/levels/labs/electric_explosion5.wav", 100)
            self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
            timer.Simple(.48,function()
                if(IsValid(self)) then self:Remove() end
            end)
        end
        -- At the point the ENT:Flicker function is called, the shield's HP will be 0. 
        -- So if we don't cancel the coloring code if shield HP is below 0 the shield will be white since 
        -- the shield's color lookup table doesn't index below 0, which is where we retrieve color values 
        -- indexed for HP values(Less memory efficient, more performance efficient)
        if(HPColorValueIndex <= 0) then return end -- This line blocks the call to set color if shield HP is below 0
        self:SetColor(HPColorValues[HPColorValueIndex])
    end

    function ENT:SetupDataTables()
        self:NetworkVar( "Float", 0, "spawnTime" )

        if SERVER then
            self:SetspawnTime( CurTime() )
        end
    end

    function ENT:Draw()
        self:DrawModel()

        local shieldPos = self:GetPos()
        shieldPos.z = shieldPos.z + 96
        local shieldAngle = self:GetAngles()
        shieldAngle = Angle(0, shieldAngle.y, 90)
        
        local timeRemaining = math.Round(self.totalLifeTime - (CurTime() - self:GetCreationTime()))

        cam.Start3D2D( shieldPos, shieldAngle, .225 )
            draw.SimpleText( timeRemaining, "OvR_Load_HUD_Holo_1", 0, 0, Color(130,248,181, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end

if SERVER then
    function ENT:Initialize()
        self:SetModel( "models/ovr_load/force_shield.mdl" )
        self:SetRenderMode(RENDERMODE_TRANSCOLOR)
        self:SetMoveType( MOVETYPE_NOCLIP )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetCollisionGroup( COLLISION_GROUP_WORLD ) 
        self.spawnTime = CurTime()
        --Effects 
        self:SetColor(Color(0, 80, 255))
        self:EmitSound("ambient/machines/combine_shield_touch_loop1.wav", 55)
        self:EmitSound("weapons/stunstick/alyx_stunner1.wav",100)
        ParticleEffectAttach( "vortigaunt_hand_glow", PATTACH_ABSORIGIN_FOLLOW, self, 1)
        self.colorModulate = false
        self:Flicker()
        -- Put default setModelScale in timer too because even though physics are initialized before SetModelScale is called,
        -- SetModelScale finishes its job first, so this will result in it spawning a tiny model collision. 
        timer.Simple( 0, function() self:SetModelScale( 0, 0 ) end) --default of size 0
        timer.Simple( 0, function() self:SetModelScale( 1, .1 ) end ) --grows to size 1
        --Code that defines behavior when entity's lifetime runs out
        timer.Simple(self.totalLifeTime,function()
            if(!IsValid(self)) then return end
            self:EmitSound("ambient/levels/labs/electric_explosion5.wav", 100)
            self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
            self:Flicker()
            timer.Simple(.48,function()
                if(IsValid(self)) then self:Remove() end
            end)
        end)
    end
end    


AddCSLuaFile()

util.PrecacheModel( "models/ovr_load/force_shield.mdl" )

if CLIENT then
surface.CreateFont("OvR_Load_HUD_Holo_1" , {
    font = "Kenney Future Square", --name of font
    size = 60,
    weight = 500,
    blursize = 2;
    scanlines = 2,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = true,
    outline = false
})
end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Author = "Trench"
ENT.Purpose = "deployable force shield for blocking income small arms fire- has hp and then is destroyed"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.spawnTime = 0
ENT.totalLifeTime = 30
ENT.hp = 800
ENT.mmRHAe = 10000 --Controls penetration resistance for ArcCW weapons, high number means no bullets from this pack will penetrate

local forceShieldImpactSounds = {
    [1] = "weapons/physcannon/superphys_small_zap1.wav",
    [2] = "weapons/physcannon/superphys_small_zap2.wav",
    [3] = "weapons/physcannon/superphys_small_zap3.wav",
    [4] = "weapons/physcannon/superphys_small_zap4.wav"
}

local HPColorValues = {
    [40] = Color(0, 80, 255),
    [39] = Color(0, 65, 255),
    [38] = Color(0, 50, 255),
    [37] = Color(0, 35, 255),
    [36] = Color(0, 20, 255),
    [35] = Color(0, 5, 255),
    [34] = Color(10, 0, 255),
    [33] = Color(25, 3, 255),
    [32] = Color(40, 0, 255),
    [31] = Color(55, 0, 255),
    [30] = Color(70, 0, 255),
    [29] = Color(85, 0, 255),
    [28] = Color(100, 0, 255),
    [27] = Color(115, 0, 255),
    [26] = Color(130, 0, 255),
    [25] = Color(145, 0, 255),
    [24] = Color(160, 0, 255),
    [23] = Color(175, 0, 255),
    [22] = Color(190, 0, 255),
    [21] = Color(205, 0, 255),
    [20] = Color(220, 0, 255),
    [19] = Color(235, 0, 255),
    [18] = Color(250, 0, 255),
    [17] = Color(255, 0, 245),
    [16] = Color(255, 0, 230),
    [15] = Color(255, 0, 215),
    [14] = Color(255, 0, 200),
    [13] = Color(255, 0, 185),
    [12] = Color(255, 0, 170),
    [11] = Color(255, 0, 155),
    [10] = Color(255, 0, 140),
    [9]  = Color(255, 0, 125),
    [8]  = Color(255, 0, 110),
    [7]  = Color(255, 0, 95),
    [6]  = Color(255, 0, 80),
    [5]  = Color(255, 0, 65),
    [4]  = Color(255, 0, 50),
    [3]  = Color(255, 0, 35),
    [2]  = Color(255, 0, 20),
    [1]  = Color(255, 0, 5),
    [0]  = Color(255, 0, 0),
}

PrecacheParticleSystem( "vortigaunt_hand_glow" )
util.PrecacheSound("ambient/machines/combine_shield_touch_loop1.wav")
util.PrecacheSound("ambient/levels/labs/electric_explosion5.wav")
util.PrecacheSound("weapons/stunstick/alyx_stunner1.wav")

for impactSound in ipairs(forceShieldImpactSounds) do
    util.PrecacheSound(forceShieldImpactSounds[impactSound])
end

    -- To get a read off the table above we only look at first two numbers of HP, since we never go over 999
    -- we can do this by dividing by 10 and flooring the result with math.floor  
    function ENT:Flicker()
        timer.Create( "shield_flicker_timer" .. tostring(self), .02, 24, function() 
            if !IsValid(self) then return end
            local color = self:GetColor()
            
            if(self.colorModulate == false)then
                color.a = math.abs(math.sin(CurTime()) * 100)
                self:SetColor(color)
            else 
                color.a = 255
                self:SetColor(color)
            end
            self.colorModulate = !self.colorModulate
        end)
    end

    function ENT:bulletImpactEffect(impactPoint, impactNormal)
        local effectdata = EffectData()
        effectdata:SetNormal(impactNormal)
        effectdata:SetOrigin(impactPoint)
        util.Effect( "AR2Impact", effectdata) 
        util.Effect( "selection_ring", effectdata)
    end
    
    function ENT:OnTakeDamage( dmginfo )
        local damage = dmginfo:GetDamage() 
        local HPColorValueIndex = math.floor((self.hp/2)/10)
        
        self:EmitSound(forceShieldImpactSounds[math.random(1,4)], 85)
        self:bulletImpactEffect(dmginfo:GetDamagePosition(), self:GetRight())
        self.hp = self.hp - damage 
        
        self:SetModelScale(.995, .05)
        timer.Simple(.05, function() 
            if (IsValid(self)) then 
                self:SetModelScale(1,.05) 
            end 
        end)

        if(self.hp <= 0) then
            self:Flicker()
            self:EmitSound("ambient/levels/labs/electric_explosion5.wav", 100)
            self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
            timer.Simple(.48,function()
                if(IsValid(self)) then self:Remove() end
            end)
        end
        -- At the point the ENT:Flicker function is called, the shield's HP will be 0. 
        -- So if we don't cancel the coloring code if shield HP is below 0 the shield will be white since 
        -- the shield's color lookup table doesn't index below 0, which is where we retrieve color values 
        -- indexed for HP values(Less memory efficient, more performance efficient)
        if(HPColorValueIndex <= 0) then return end -- This line blocks the call to set color if shield HP is below 0
        self:SetColor(HPColorValues[HPColorValueIndex])
    end

    function ENT:SetupDataTables()
        self:NetworkVar( "Float", 0, "spawnTime" )

        if SERVER then
            self:SetspawnTime( CurTime() )
        end
    end

    function ENT:Draw()
        self:DrawModel()

        local shieldPos = self:GetPos()
        shieldPos.z = shieldPos.z + 96
        local shieldAngle = self:GetAngles()
        shieldAngle = Angle(0, shieldAngle.y, 90)
        
        local timeRemaining = math.Round(self.totalLifeTime - (CurTime() - self:GetCreationTime()))

        cam.Start3D2D( shieldPos, shieldAngle, .225 )
            draw.SimpleText( timeRemaining, "OvR_Load_HUD_Holo_1", 0, 0, Color(130,248,181, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end

if SERVER then
    function ENT:Initialize()
        self:SetModel( "models/ovr_load/force_shield.mdl" )
        self:SetRenderMode(RENDERMODE_TRANSCOLOR)
        self:SetMoveType( MOVETYPE_NOCLIP )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetCollisionGroup( COLLISION_GROUP_WORLD ) 
        self.spawnTime = CurTime()
        --Effects 
        self:SetColor(Color(0, 80, 255))
        self:EmitSound("ambient/machines/combine_shield_touch_loop1.wav", 55)
        self:EmitSound("weapons/stunstick/alyx_stunner1.wav",100)
        ParticleEffectAttach( "vortigaunt_hand_glow", PATTACH_ABSORIGIN_FOLLOW, self, 1)
        self.colorModulate = false
        self:Flicker()
        -- Put default setModelScale in timer too because even though physics are initialized before SetModelScale is called,
        -- SetModelScale finishes its job first, so this will result in it spawning a tiny model collision. 
        timer.Simple( 0, function() self:SetModelScale( 0, 0 ) end) --default of size 0
        timer.Simple( 0, function() self:SetModelScale( 1, .1 ) end ) --grows to size 1
        --Code that defines behavior when entity's lifetime runs out
        timer.Simple(self.totalLifeTime,function()
            if(!IsValid(self)) then return end
            self:EmitSound("ambient/levels/labs/electric_explosion5.wav", 100)
            self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
            self:Flicker()
            timer.Simple(.48,function()
                if(IsValid(self)) then self:Remove() end
            end)
        end)
    end
end    

