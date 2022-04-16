local PLUGIN = PLUGIN

PLUGIN.name = "Advanced Cellar HUD"
PLUGIN.author = "Sectorial.Commander"
PLUGIN.description = "Advanced Smart Heads-Up Display & Animations specially for Cellar Project."
PLUGIN.version = 1.2


PLUGIN.hasWeapon = nil
PLUGIN.bbarshide = nil
PLUGIN.lerphealth = 1
PLUGIN.lerpstamina = 1
PLUGIN.lerphunger = 1
PLUGIN.lerpthirst = 1
PLUGIN.lerpgeiger = 1
PLUGIN.lerpfilter = 1
PLUGIN.tickbrake = true
PLUGIN.tickbrake1 = true
PLUGIN.tickbrake2 = true
PLUGIN.tickbrake3 = true
PLUGIN.tickbrake4 = true
PLUGIN.tickbrake5 = true
PLUGIN.ammoShow = false

PLUGIN.tempBrake = true


ix.util.Include('derma/cl_cellarbar.lua')
ix.util.Include('derma/cl_cellarneeds.lua')

function PLUGIN:ShouldHideBars() -- hiding original Helix HUD bars
	return true
end

function PLUGIN:HUDPaint() -- using HUDPaint instead of think to call the function only on client-side
	local client = LocalPlayer()
	local character = client:GetCharacter()

	if not client:GetCharacter() then return end

	if !character:HasVisor() and !character:IsOTA() then
		if IsValid(cellar_hud_ammo) then
			cellar_hud_ammo:SetVisible(false)
			cellar_hud_ammo:Remove()
		end
		if IsValid(cellar_hud_main) then
			cellar_hud_main:SetVisible(false)
			cellar_hud_main:Remove()
		end
		if IsValid(cellar_needs_geiger) then
			cellar_needs_geiger:SetVisible(false)
			cellar_needs_geiger:Remove()
		end
		if IsValid(cellar_needs_filter) then
			cellar_needs_filter:SetVisible(false)
			cellar_needs_filter:Remove()
		end
		if IsValid(cellar_needs_hunger) then
			cellar_needs_hunger:SetVisible(false)
			cellar_needs_hunger:Remove()
		end
		if IsValid(cellar_needs_thirst) then
			cellar_needs_thirst:SetVisible(false)
			cellar_needs_thirst:Remove()
		end
		return
	end

	--  AMMO BAR    --

	if client:Health() <= 1 or !client:Alive() then
		if IsValid(cellar_hud_ammo) then
			cellar_hud_ammo:Remove()
		end

		if IsValid(cellar_hud_main) then
			cellar_hud_main:Remove()
		end
	end

	local weapon = client:GetActiveWeapon()

	-- Be sure that the original Helix ammo hooks are removed from helix/core/hooks/cl_hooks.lua
	if (IsValid(weapon) and hook.Run("CanDrawAmmoHUD", weapon) != false and weapon.DrawAmmo != false) then 
		local clip = weapon:Clip1()
		local clipMax = weapon:GetMaxClip1()
		local count = client:GetAmmoCount(weapon:GetPrimaryAmmoType())
		local secondary = client:GetAmmoCount(weapon:GetSecondaryAmmoType())
		if (weapon:GetClass() != "weapon_slam" and clip > 0 or count > 0) then
			if !cellar_hud_ammo or cellar_hud_ammo.removed then
				vgui.Create('cellar.ammo')
			end
			if !client:Alive() then
				cellar_hud_ammo:Remove()
			end
		end
	end

	--  FIRST NEED BARS --

	PLUGIN.lerphealth = Lerp(0.35 * FrameTime(), PLUGIN.lerphealth, math.max(character:GetBlood() / 5000, 0))
	oldhealth = math.Round(PLUGIN.lerphealth, 2)
	newhealth = math.Round(math.max(character:GetBlood() / 5000, 0), 2)
	/*PLUGIN.lerpstamina = Lerp(0.5 * FrameTime(), PLUGIN.lerpstamina, math.Clamp((ix.plugin.list["stamina"].predictedStamina or 100) / LocalPlayer():GetCharacter():GetMaxStamina(), 0, 1))
	oldstamina = math.Round(PLUGIN.lerpstamina, 2)*/
	newstamina = math.Round(math.Clamp((ix.plugin.list["stamina"].predictedStamina or 100) / LocalPlayer():GetCharacter():GetMaxStamina(), 0, 1), 2)
	-- Стамина догоняет сама себя и заставляет линию закрываться и открываться, так что ей мы линейную интерполяцию не прописываем..

	if !LocalPlayer():Alive() then
		if IsValid(cellar_hud_main) then
			cellar_hud_main:Remove()
		end
	end

	if cellar_hud_ammo and !cellar_hud_ammo.removed then
		PLUGIN.ammoShow = true
		if !cellar_hud_main or cellar_hud_main.removed then
			vgui.Create('cellar.hud')
		end
	else
		PLUGIN.ammoShow = false
	end

	if newstamina != 1 then
		PLUGIN.tickbrake1 = false

		if !cellar_hud_main or cellar_hud_main.removed then
			vgui.Create('cellar.hud')
		end
	end

	if newstamina == 1 and PLUGIN.tickbrake1 == false then
		if cellar_hud_main then
			if cellar_hud_ammo then
				if cellar_hud_ammo.removed then
					PLUGIN.tickbrake1 = true
					cellar_hud_main:Remove()
				end
			else
				PLUGIN.tickbrake1 = true
				cellar_hud_main:Remove()
			end
		end
	end


	if newhealth != oldhealth then
		PLUGIN.tickbrake = false

		if !cellar_hud_main or cellar_hud_main.removed then
			vgui.Create('cellar.hud')
		end
	end

	if newhealth == oldhealth and PLUGIN.tickbrake == false then
		if cellar_hud_main then
			if cellar_hud_ammo then
				if cellar_hud_ammo.removed then
					PLUGIN.tickbrake1 = true
					cellar_hud_main:Remove()
				end
			else
				PLUGIN.tickbrake = true
				cellar_hud_main:Remove()
			end
		end
	end

	--  OTHER BARS  --

	PLUGIN.lerphunger = Lerp(0.1 * FrameTime(), PLUGIN.lerphunger, LocalPlayer():GetCharacter():GetHunger()/100)
	oldhunger = math.Round(PLUGIN.lerphunger, 2)
	newhunger = math.Round(LocalPlayer():GetCharacter():GetHunger()/100, 2)
	PLUGIN.lerpthirst = Lerp(0.1 * FrameTime(), PLUGIN.lerpthirst, LocalPlayer():GetCharacter():GetThirst()/100)
	oldthirst = math.Round(PLUGIN.lerpthirst, 2)
	newthirst = math.Round(LocalPlayer():GetCharacter():GetThirst()/100, 2)


	-- geiger
	local radLevel = LocalPlayer():GetNetVar("radDmg") or 0
	local geiger = character:HasGeigerCounter()
	if geiger == true then
		PLUGIN.lerpgeiger = Lerp(0.35 * FrameTime(), PLUGIN.lerpgeiger, radLevel/100)
		oldgeiger = math.Round(PLUGIN.lerpgeiger, 2)
		newgeiger = math.Round(radLevel/100, 2)

		
		if oldgeiger != newgeiger then
			PLUGIN.tickbrake4 = false
			if !cellar_needs_geiger or cellar_needs_geiger.removed then
				vgui.Create('cellar.needs.geiger')
			end
		end

		if oldgeiger == newgeiger and PLUGIN.tickbrake4 == false then
			if cellar_needs_geiger then
				PLUGIN.tickbrake4 = true
				cellar_needs_geiger:Remove()
			end
		end
	end
	

	-- filter
	local filter = character:HasWearedFilter()
	if filter == true then
		PLUGIN.lerpfilter = Lerp(0.35 * FrameTime(), PLUGIN.lerpfilter, filter and filter:GetFilterQuality()/filter.filterQuality)
		oldfilter = math.Round(PLUGIN.lerpfilter, 2)
		newfilter = math.Round(filter:GetFilterQuality()/filter.filterQuality, 2)

		
		if oldfilter != newfilter then
			PLUGIN.tickbrake5 = false
			if !cellar_needs_filter or cellar_needs_filter.removed then
				vgui.Create('cellar.needs.filter')
			end
		end

		if oldfilter == newfilter and PLUGIN.tickbrake5 == false then
			if cellar_needs_filter then
				PLUGIN.tickbrake5 = true
				cellar_needs_filter:Remove()
			end
		end
	end

	-- hunger
	if oldhunger != newhunger then
		PLUGIN.tickbrake2 = false
		if !cellar_needs_hunger or cellar_needs_hunger.removed then
			vgui.Create('cellar.needs.hunger')
		end
	end

	if oldhunger == newhunger and PLUGIN.tickbrake2 == false then
		if cellar_needs_hunger then
			PLUGIN.tickbrake2 = true
			cellar_needs_hunger:Remove()
		end
	end

	-- thirst
	if oldthirst != newthirst then
		PLUGIN.tickbrake3 = false
		if !cellar_needs_thirst or cellar_needs_thirst.removed then
			vgui.Create('cellar.needs.thirst')
		end
	end

	if oldthirst == newthirst and PLUGIN.tickbrake3 == false then
		if cellar_needs_thirst then
			PLUGIN.tickbrake3 = true
			cellar_needs_thirst:Remove()
		end
	end

	-- temperature

	local temperature = LocalPlayer():GetLocalVar("coldCounter", 0) / 100

	if temperature < 1 then
		PLUGIN.tempBrake = false
		if !cellar_citizenhud_temperature or cellar_citizenhud_temperature.removed then
			vgui.Create('cellar.citizenhud.temperature')
		end
	end

	if temperature > 0.99 then
		if IsValid(cellar_citizenhud_temperature) then
			PLUGIN.tempBrake = true
			cellar_citizenhud_temperature:Remove()
		end
	end

	
	
end