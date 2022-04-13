if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

ENT.Base             = "nz_risen"
ENT.Spawnable        = false
ENT.AdminSpawnable   = false

--SpawnMenu--
list.Set( "NPC", "nz_slow_risen", {
	Name = "Slow Risen",
	Class = "nz_slow_risen",
	Category = "NextBot Zombies 2.0"
} )

--Stats--
ENT.MoveType = 2

ENT.FootAngles = 5

ENT.CollisionHeight = 66
ENT.CollisionSide = 11

ENT.Speed = 30
ENT.WalkSpeedAnimation = 1

ENT.health = 100
ENT.Damage = 25

ENT.PhysForce = 30000
ENT.AttackRange = 40
ENT.DoorAttackRange = 25

ENT.NextAttack = 0.5

--Model Settings--
ENT.Model = "models/freshdead/freshdead_01.mdl"
ENT.Model2 = "models/freshdead/freshdead_02.mdl"
ENT.Model3 = "models/freshdead/freshdead_03.mdl"
ENT.Model4 = "models/freshdead/freshdead_04.mdl"
ENT.Model5 = "models/freshdead/freshdead_05.mdl"
ENT.Model6 = "models/freshdead/freshdead_06.mdl"
ENT.Model7 = "models/freshdead/freshdead_07.mdl"

ENT.AttackAnim1 = "attacka"
ENT.AttackAnim2 = "attackb"
ENT.AttackAnim3 = "attackc"

ENT.IdleAnim = "idle01"
ENT.IdleAnim2 = "idle02"
ENT.IdleAnim3 = "idle03"
ENT.IdleAnim4 = "idle04"

ENT.ChestFlinch1 = "physflinch1"
ENT.ChestFlinch2 = "physflinch2"
ENT.ChestFlinch3 = "physflinch3"

ENT.HeadFlinch = "flinch_head"

ENT.RLegFlinch = "flinch_rightleg"
ENT.RArmFlinch = "flinch_rightarm"

ENT.LLegFlinch = "flinch_leftleg"
ENT.LArmFlinch = "flinch_leftarm"

--Sounds--
ENT.Attack1 = Sound("npc/freshdead/male/attack1.wav")
ENT.Attack2 = Sound("npc/freshdead/male/attack2.wav")
ENT.Attack3 = Sound("npc/freshdead/male/attack3.wav")
ENT.Attack4 = Sound("npc/freshdead/male/attack4.wav")

ENT.FemaleAttack1 = Sound("npc/freshdead/Female/attack1.wav")
ENT.FemaleAttack2 = Sound("npc/freshdead/Female/attack2.wav")
ENT.FemaleAttack3 = Sound("npc/freshdead/Female/attack3.wav")
ENT.FemaleAttack4 = Sound("npc/freshdead/Female/attack4.wav")

ENT.DoorBreak = Sound("npc/zombie/zombie_pound_door.wav")

ENT.Death1 = Sound("npc/freshdead/male/death1.wav")
ENT.Death2 = Sound("npc/freshdead/male/death2.wav")
ENT.Death3 = Sound("npc/freshdead/male/death3.wav")
ENT.Death4 = Sound("npc/freshdead/male/death4.wav")

ENT.FemaleDeath1 = Sound("npc/freshdead/Female/death1.wav")
ENT.FemaleDeath2 = Sound("npc/freshdead/Female/death2.wav")
ENT.FemaleDeath3 = Sound("npc/freshdead/Female/death3.wav")
ENT.FemaleDeath4 = Sound("npc/freshdead/Female/death4.wav")

ENT.Alert1 = Sound("npc/freshdead/male/alert1.wav")
ENT.Alert2 = Sound("npc/freshdead/male/alert2.wav")
ENT.Alert3 = Sound("npc/freshdead/male/alert3.wav")
ENT.Alert4 = Sound("npc/freshdead/male/alert4.wav")

ENT.FemaleAlert1 = Sound("npc/freshdead/Female/alert1.wav")
ENT.FemaleAlert2 = Sound("npc/freshdead/Female/alert2.wav")
ENT.FemaleAlert3 = Sound("npc/freshdead/Female/alert3.wav")
ENT.FemaleAlert4 = Sound("npc/freshdead/Female/alert4.wav")

ENT.Flinch1 = Sound("npc/freshdead/male/flinch1.wav")
ENT.Flinch2 = Sound("npc/freshdead/male/flinch2.wav")
ENT.Flinch3 = Sound("npc/freshdead/male/flinch3.wav")

ENT.FemaleFlinch1 = Sound("npc/freshdead/Female/flinch1.wav")
ENT.FemaleFlinch2 = Sound("npc/freshdead/Female/flinch2.wav")
ENT.FemaleFlinch3 = Sound("npc/freshdead/Female/flinch3.wav")

ENT.Idle1 = Sound("npc/freshdead/male/alert_no_enemy1.wav")
ENT.Idle2 = Sound("npc/freshdead/male/alert_no_enemy2.wav")
ENT.Idle3 = Sound("npc/freshdead/male/pain2.wav")
ENT.Idle4 = Sound("npc/freshdead/male/pain4.wav")

ENT.FemaleIdle1 = Sound("npc/freshdead/Female/alert_no_enemy1.wav")
ENT.FemaleIdle2 = Sound("npc/freshdead/Female/alert_no_enemy2.wav")
ENT.FemaleIdle3 = Sound("npc/freshdead/Female/pain2.wav")
ENT.FemaleIdle4 = Sound("npc/freshdead/Female/pain4.wav")

ENT.Pain1 = Sound("npc/freshdead/male/pain1.wav")
ENT.Pain2 = Sound("npc/freshdead/male/pain2.wav")
ENT.Pain3 = Sound("npc/freshdead/male/pain3.wav")
ENT.Pain4 = Sound("npc/freshdead/male/pain4.wav")

ENT.FemalePain1 = Sound("npc/freshdead/Female/pain1.wav")
ENT.FemalePain2 = Sound("npc/freshdead/Female/pain2.wav")
ENT.FemalePain3 = Sound("npc/freshdead/Female/pain3.wav")
ENT.FemalePain4 = Sound("npc/freshdead/Female/pain4.wav")

ENT.Hit1 = Sound("npc/infected_zombies/hit_punch_01.wav")
ENT.Hit2 = Sound("npc/infected_zombies/hit_punch_02.wav")
ENT.Hit3 = Sound("npc/infected_zombies/hit_punch_03.wav")
ENT.Hit4 = Sound("npc/infected_zombies/hit_punch_04.wav")
ENT.Hit5 = Sound("npc/infected_zombies/hit_punch_05.wav")
ENT.Hit6 = Sound("npc/infected_zombies/hit_punch_06.wav")
ENT.Hit7 = Sound("npc/infected_zombies/hit_punch_07.wav")
ENT.Hit8 = Sound("npc/infected_zombies/hit_punch_08.wav")

ENT.Miss1 = Sound("npc/infected_zombies/claw_miss_1.wav")
ENT.Miss2 = Sound("npc/infected_zombies/claw_miss_2.wav")

function ENT:SwitchToFemale( model )
	self.WalkAnim = ( table.Random(self.Anims) )
	self.Model = model
	
	if self.WalkAnim == "walk8" then
		self.Speed = self.Speed - 10
	end
	
	self.Death1 = self.FemaleDeath1
	self.Death2 = self.FemaleDeath2
	self.Death3 = self.FemaleDeath3
	self.Death4 = self.FemaleDeath4
	
	self.Alert1 = self.FemaleAlert1
	self.Alert2 = self.FemaleAlert2
	self.Alert3 = self.FemaleAlert3
	self.Alert4 = self.FemaleAlert4
	
	self.Idle1 = self.FemaleIdle1
	self.Idle2 = self.FemaleIdle2
	self.Idle3 = self.FemaleIdle3
	self.Idle4 = self.FemaleIdle4
	
	self.Attack1 = self.FemaleAttack1
	self.Attack2 = self.FemaleAttack2
	self.Attack3 = self.FemaleAttack3
	self.Attack4 = self.FemaleAttack4
	
	self.Flinch1 = self.FemaleFlinch1
	self.Flinch2 = self.FemaleFlinch2
	self.Flinch3 = self.FemaleFlinch3
	
	self.Pain1 = self.FemalePain1
	self.Pain2 = self.FemalePain2
	self.Pain3 = self.FemalePain3
	self.Pain4 = self.FemalePain4
	
end

function ENT:SwitchToMale( model )
	self.WalkAnim = ( table.Random(self.Anims) )
	self.Model = model
	
	if self.WalkAnim == "walk8" then
		self.Speed = self.Speed - 10
	end
	
end

function ENT:Switch()
	self.Anims = { "walk1", "walk2", "walk3", "walk4", "walk5", "walk6", "walk7", "walk8", "walk9", "walk10" }

	local model = math.random(1,7)
	if model == 1 then
		self:SwitchToMale( self.Model )
	elseif model == 2 then
		self:SwitchToMale( self.Model2 )
	elseif model == 3 then
		self:SwitchToMale( self.Model3 )
	elseif model == 4 then
		self:SwitchToMale( self.Model4 )
	elseif model == 5 then
		self:SwitchToFemale( self.Model5 )
	elseif model == 6 then
		self:SwitchToFemale( self.Model6 )
	elseif model == 7 then
		self:SwitchToFemale( self.Model7 )
	end
	
end