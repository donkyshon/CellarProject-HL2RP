TOOL.Category        = "Construction"
TOOL.Name            = "#No Collide World"
TOOL.Command        = nil
TOOL.ConfigName		= ""

if CLIENT then
	language.Add("Tool.nocollideworld.name", "No Collide World")
	language.Add("Tool.nocollideworld.desc", "Make a prop not collide with anything, including the world")
	language.Add("Tool.nocollideworld.0", "Left click on an object to make it not collide with anything. Right click to return an object to normal.")
end

function TOOL:LeftClick( trace )

    if (!trace.Entity ) then return end
    if (!trace.Entity:IsValid()) then return end
	if (trace.Entity:IsPlayer()) then return end
	
	local PhysObj = trace.Entity:GetPhysicsObject()
    
    if ( CLIENT ) then return true end
    
    if ( trace.Entity.CollisionGroup != COLLISION_GROUP_WORLD && PhysObj:IsCollisionEnabled() ) then
    
        trace.Entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
        trace.Entity.CollisionGroup = COLLISION_GROUP_WORLD
		PhysObj:EnableCollisions(false)
        
    end
    
    return true
    
end

function TOOL:RightClick( trace )

    if (!trace.Entity ) then return end
    if (!trace.Entity:IsValid()) then return end
	if (trace.Entity:IsPlayer()) then return end
	
	local PhysObj = trace.Entity:GetPhysicsObject()
    
    if ( CLIENT ) then return true end
    
    if ( trace.Entity.CollisionGroup == COLLISION_GROUP_WORLD && !PhysObj:IsCollisionEnabled() ) then
    
        trace.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
        trace.Entity.CollisionGroup = COLLISION_GROUP_NONE
		PhysObj:EnableCollisions(true)
        
    end
    
    return true
    
end
TOOL.Category        = "Construction"
TOOL.Name            = "#No Collide World"
TOOL.Command        = nil
TOOL.ConfigName		= ""

if CLIENT then
	language.Add("Tool.nocollideworld.name", "No Collide World")
	language.Add("Tool.nocollideworld.desc", "Make a prop not collide with anything, including the world")
	language.Add("Tool.nocollideworld.0", "Left click on an object to make it not collide with anything. Right click to return an object to normal.")
end

function TOOL:LeftClick( trace )

    if (!trace.Entity ) then return end
    if (!trace.Entity:IsValid()) then return end
	if (trace.Entity:IsPlayer()) then return end
	
	local PhysObj = trace.Entity:GetPhysicsObject()
    
    if ( CLIENT ) then return true end
    
    if ( trace.Entity.CollisionGroup != COLLISION_GROUP_WORLD && PhysObj:IsCollisionEnabled() ) then
    
        trace.Entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
        trace.Entity.CollisionGroup = COLLISION_GROUP_WORLD
		PhysObj:EnableCollisions(false)
        
    end
    
    return true
    
end

function TOOL:RightClick( trace )

    if (!trace.Entity ) then return end
    if (!trace.Entity:IsValid()) then return end
	if (trace.Entity:IsPlayer()) then return end
	
	local PhysObj = trace.Entity:GetPhysicsObject()
    
    if ( CLIENT ) then return true end
    
    if ( trace.Entity.CollisionGroup == COLLISION_GROUP_WORLD && !PhysObj:IsCollisionEnabled() ) then
    
        trace.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
        trace.Entity.CollisionGroup = COLLISION_GROUP_NONE
		PhysObj:EnableCollisions(true)
        
    end
    
    return true
    
end