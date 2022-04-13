
TOOL.Category		= "Construction"
TOOL.Name		= "#MM"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar["mmmodel"] = ""

if ( CLIENT ) then
	language.Add( "MM", "Model Manipulator" )
	
	language.Add( "tool.modelmanipulator.name", "Model Manipulator" )
	language.Add( "tool.modelmanipulator.desc", "Swap models around." )
	language.Add( "tool.modelmanipulator.0", "Left-Click to Set a model. Right-Click to Get a model. Reload to Set your own player model." )
end

function TOOL:LeftClick( trace, attach )
	if trace.Entity && trace.Entity:IsPlayer() then return true end
	if (CLIENT) then return true end
	
	local model = self:GetClientInfo("mmmodel")
	
	if trace.Entity:IsValid() then
		if model == "" then
			self:Message("No model selected!")
			return
		end
		trace.Entity:SetModel(model)
		self:Message("Model set to: "..model..".")
	end
	return true

end

function TOOL:RightClick( trace )
	if trace.Entity && trace.Entity:IsPlayer() then return true end
	if (CLIENT) then return true end
	
	if trace.Entity:IsValid() then
		local model = trace.Entity:GetModel()
		local owner = self:GetOwner()
		owner:ConCommand("modelmanipulator_mmmodel "..model.."\n")
		self:Message("Model retrived: "..model..".")
	end
end

function TOOL:Reload(trace)
	local model = self:GetClientInfo("mmmodel")
	
	if trace.Entity:IsValid() then
		if model == "" then
			self:Message("No model selected!")
			return
		end
		self:GetOwner():SetModel(model)
		self:Message("Player Model set to: "..model..".")
	end
end

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Text = "#MM", Description = "Swap models around." }  )
end

function TOOL:Message(Text)
	if SERVER then
		self:GetOwner():SendLua("GAMEMODE:AddNotify('"..Text.."', NOTIFY_GENERIC, 10)")
		self:GetOwner():SendLua("surface.PlaySound('ambient/water/drip"..math.random(1, 4)..".wav')")
	end
end

TOOL.Category		= "Construction"
TOOL.Name		= "#MM"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar["mmmodel"] = ""

if ( CLIENT ) then
	language.Add( "MM", "Model Manipulator" )
	
	language.Add( "tool.modelmanipulator.name", "Model Manipulator" )
	language.Add( "tool.modelmanipulator.desc", "Swap models around." )
	language.Add( "tool.modelmanipulator.0", "Left-Click to Set a model. Right-Click to Get a model. Reload to Set your own player model." )
end

function TOOL:LeftClick( trace, attach )
	if trace.Entity && trace.Entity:IsPlayer() then return true end
	if (CLIENT) then return true end
	
	local model = self:GetClientInfo("mmmodel")
	
	if trace.Entity:IsValid() then
		if model == "" then
			self:Message("No model selected!")
			return
		end
		trace.Entity:SetModel(model)
		self:Message("Model set to: "..model..".")
	end
	return true

end

function TOOL:RightClick( trace )
	if trace.Entity && trace.Entity:IsPlayer() then return true end
	if (CLIENT) then return true end
	
	if trace.Entity:IsValid() then
		local model = trace.Entity:GetModel()
		local owner = self:GetOwner()
		owner:ConCommand("modelmanipulator_mmmodel "..model.."\n")
		self:Message("Model retrived: "..model..".")
	end
end

function TOOL:Reload(trace)
	local model = self:GetClientInfo("mmmodel")
	
	if trace.Entity:IsValid() then
		if model == "" then
			self:Message("No model selected!")
			return
		end
		self:GetOwner():SetModel(model)
		self:Message("Player Model set to: "..model..".")
	end
end

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Text = "#MM", Description = "Swap models around." }  )
end

function TOOL:Message(Text)
	if SERVER then
		self:GetOwner():SendLua("GAMEMODE:AddNotify('"..Text.."', NOTIFY_GENERIC, 10)")
		self:GetOwner():SendLua("surface.PlaySound('ambient/water/drip"..math.random(1, 4)..".wav')")
	end
end