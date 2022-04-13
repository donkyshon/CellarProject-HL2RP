
color_white 					= Color(255,255,255,255)
local COL_WHITE					= color_white
local COL_GREY					= Color(45,45,45,255)
local COL_LIGHT_GREY			= Color(60,60,60,255)
local COL_LIGHT_GREY1			= Color(50,50,50,255)
local COL_RED					= Color(255,0,0,255)
local COL_GREEN					= Color(0,255,0,255)
local COL_DARK_GREY 			= Color(30,30,30,255)
local COL_DARK_GREY1 			= Color(35,35,35,255)
local COL_BLUE_HIGHLIGHT		= Color(20,200,250,255)
local COL_DARK_BLUE_HIGHLIGHT	= Color(10,100,150,255)
local COL_TRANSPARENT_GREY 		= Color(100,100,100,100)



local ExplosivesMaterial		= Material("gredwitch/bombicon.png")
local BulletMaterial			= Material("gredwitch/bulleticon.png")
local HomeMaterial				= Material("gredwitch/homeicon.png")
local LFSMaterial				= Material("gredwitch/lfsicon.png")
local PlusMaterial				= Material("gredwitch/plusicon.png")
local SimfphysMaterial			= Material("gredwitch/simfphysicon.png")
local WACMaterial				= Material("gredwitch/wacicon.png")

local xml2lua 					= include("xml2lua/xml2lua.lua")

local PreMadePictures = {
	["gredwitch's base update released"] = "https://steamuserimages-a.akamaihd.net/ugc/795362966701394778/3CC2AED5CC8CD8E90F805708EF2B723B00C14749/",
	["simfphys vehicles updates released"] = "https://steamuserimages-a.akamaihd.net/ugc/785247758985481775/5FEB9B086475B567223B73ADE2E23078B2745629/",
	["simfphys vehicle updates released"] = "https://steamuserimages-a.akamaihd.net/ugc/785247758985481775/5FEB9B086475B567223B73ADE2E23078B2745629/",
	["simfphys vehicle update released"] = "https://steamuserimages-a.akamaihd.net/ugc/785247758985481775/5FEB9B086475B567223B73ADE2E23078B2745629/",
	["emplacement pack update released"] = "https://steamuserimages-a.akamaihd.net/ugc/927058346493048477/2DC6F3942A2D9FAB1F35BC96CFD1A254AC0CD71F/",
	["lfs aircrafts released"] = "https://i.imgur.com/2vmoYzj.jpg",
	["lfs aircraft released"] = "https://i.imgur.com/2vmoYzj.jpg",
}



local function GetServerBanner(IP,OnFetched,Force)
	local NiceIP = string.Replace(IP,":","_PORT_")
	if !file.Exists("gredwitch_base_cache/"..NiceIP..".png","DATA") or !gred.ServerBanners[IP] or Force then
		http.Fetch("https://cache.gametracker.com/server_info/"..IP.."/b_560_95_1.png",function(body)
			file.Delete("gredwitch_base_cache/"..NiceIP..".png")
			file.Write("gredwitch_base_cache/"..NiceIP..".png",body)
			-- timer.Simple(2,function()
				gred.ServerBanners[IP] = Material("data/gredwitch_base_cache/"..NiceIP..".png")
				if OnFetched then
					OnFetched()
				end
			-- end)
		end)
	else
		gred.ServerBanners[IP] = gred.ServerBanners[IP] or Material("data/gredwitch_base_cache/"..NiceIP..".png")
		if OnFetched then
			OnFetched()
		end
	end
end



local function GetNewsMaterial(Tab,OnFetched,Force)
	local ImageURL
	
	local _,LinkStart = string.find(Tab.description or "",'<span class="bb_spoiler"><span><a class="bb_link" href="https://steamcommunity.com/linkfilter/?url=',1,true)
	
	if LinkStart then
		local LinkEnd = string.find(Tab.description,'" target="_blank" rel="noreferrer" >',1,true)
		
		if LinkEnd then
			ImageURL = string.sub(Tab.description,LinkStart + 1,LinkEnd - 1)
		end
	end
	
	local pic = ImageURL or PreMadePictures[Tab.title:lower()]
	
	if pic then
		local name = string.Replace(string.Replace(Tab.title,"'","")," ","_")
		if !file.Exists("gredwitch_base_cache/"..name..".png","DATA") or !gred.NewsMaterials[pic] or Force then
			http.Fetch(pic,function(body)
				file.Delete("gredwitch_base_cache/"..name..".png")
				file.Write("gredwitch_base_cache/"..name..".png",body)
				gred.NewsMaterials[pic] = Material("data/gredwitch_base_cache/"..name..".png")
				if OnFetched then
					OnFetched(gred.NewsMaterials[pic])
				end
			end)
		else
			gred.NewsMaterials[pic] = gred.NewsMaterials[pic] or Material("data/gredwitch_base_cache/"..name..".png")
			if OnFetched then
				OnFetched(gred.NewsMaterials[pic])
			end
		end
	end
end

local function GetSteamGroupImage(OnFetched,Force)
	local pic = "https://i.imgur.com/Lh5G1ru.png"
	if !file.Exists("gredwitch_base_cache/SteamGroup.png","DATA") or !gred.NewsMaterials[pic] or Force then
		http.Fetch(pic,function(body)
			file.Delete("gredwitch_base_cache/SteamGroup.png")
			file.Write("gredwitch_base_cache/SteamGroup.png",body)
			gred.ServerBanners[pic] = Material("data/gredwitch_base_cache/SteamGroup.png")
			if OnFetched then
				OnFetched(gred.ServerBanners[pic])
			end
		end)
	else
		gred.ServerBanners[pic] = gred.ServerBanners[pic] or Material("data/gredwitch_base_cache/SteamGroup.png")
		if OnFetched then
			OnFetched(gred.ServerBanners[pic])
		end
	end
end

local function DrawEmptyRect(x,y,w,h,thick_w,thick_h,fixoffset)
	fixoffset = fixoffset or 0
	surface.DrawRect(x,y,w,thick_h)
	surface.DrawRect(x,y+h-thick_h,w,thick_h)
	
	surface.DrawRect(x,y,thick_w,h)
	surface.DrawRect(x+w-thick_w + fixoffset,y-fixoffset,thick_w,h)
end


local Months = {
	["Jan"] = 1,
	["Feb"] = 2,
	["Mar"] = 3,
	["Apr"] = 4,
	["May"] = 5,
	["Jun"] = 6,
	["Jul"] = 7,
	["Aug"] = 8,
	["Sep"] = 9,
	["Oct"] = 10,
	["Nov"] = 11,
	["Dec"] = 12,
}

local function CreateNewsPanels(DPanelNewsMain,Tab)
	for i = 1,3 do
		local DPanelNews = vgui.Create("DButton",DPanelNewsMain)
		local pubdata = Tab[i].pubDate
		
		local ExplodedPubData = string.Explode(" ",string.Replace(pubdata,",",""),false)
		
		pubdata = ExplodedPubData[2].."/"..ExplodedPubData[3].."/"..ExplodedPubData[4]
		local title = Tab[i].title:upper()
		
		DPanelNews:Dock(FILL)
		DPanelNews:SetText("")
		DPanelNews.Paint = function(DPanelNews,w,h)
			surface.SetDrawColor(255,255,255,255)
			if DPanelNews.Material then
				surface.SetMaterial(DPanelNews.Material)
				surface.DrawTexturedRect(0,0,w,h)
			end
			DrawEmptyRect(0,0,w,h,2,2,0)
			surface.DrawRect(0,h-52,w,2)
			draw.DrawText(pubdata,"Trebuchet24",6,h-48,COL_BLUE_HIGHLIGHT,TEXT_ALIGN_LEFT)
			draw.DrawText(title,"Trebuchet24",6,h-24,COL_BLUE_HIGHLIGHT,TEXT_ALIGN_LEFT)
		end 
		GetNewsMaterial(Tab[i],function(mat)
			if IsValid(DPanelNews) then
				DPanelNews.Material = mat
			end
		end)
		DPanelNews:SetAlpha(0)
		DPanelNews.DoClick = function(DPanelNews)
			surface.PlaySound("garrysmod/ui_click.wav")
			gui.OpenURL(Tab[i].link)
		end
		
		table.insert(DPanelNewsMain.SubPanels,DPanelNews)
		-- for k,v in pairs(Tab[i]) do
			-- print(k)
		-- end
	end 
	DPanelNewsMain:AnimatePanels()
end

local function CreateOptions(DFrame,DPanel,X,Y,Tab)
	DPanel.Paint = function(DPanel,w,h)
		-- surface.SetDrawColor(40,40,40,255)
		-- surface.DrawRect(60,0,w - 60,h*0.1)
	end
	
	local DScrollPanel = vgui.Create("DScrollPanel",DPanel)
	local x,y = X,Y*0.08
	DScrollPanel:Dock(FILL)
	DScrollPanel:DockMargin(0,Y*0.15,0,0)
	DScrollPanel.Buttons = {}
	DScrollPanel.PurgeButtons = function(DScrollPanel)
		for k,v in pairs(DScrollPanel.Buttons) do
			v:Remove()
		end
		DScrollPanel.Buttons = {}
	end
	DScrollPanel.ReNewButtons = function(DScrollPanel,Tab)
		DScrollPanel:PurgeButtons()
		for k,v in pairs(Tab) do
			local Panel = DScrollPanel:Add("DPanel")
			Panel:Dock(TOP)
			Panel:SetHeight(y)
			Panel.Paint = function(Panel,w,h)
				surface.SetDrawColor(35,35,35,255)
				surface.DrawRect(0,h-2,w,2)
			end
			table.insert(DScrollPanel.Buttons,Panel)
			v(DFrame,DPanel,DScrollPanel,Panel,x,y)
		end
	end
	
	local DHorizontalScroller = vgui.Create("DHorizontalScroller",DPanel)
	DHorizontalScroller:Dock(FILL)
	DHorizontalScroller:DockMargin(70,0,0,Y*0.89)
	DHorizontalScroller.ToggleSelect = function(DHorizontalScroller,DButton,tab)
		if IsValid(DHorizontalScroller.SelectedButton) then
			DHorizontalScroller.SelectedButton.Selected = nil
		end
		DHorizontalScroller.SelectedButton = DButton
		DButton.Selected = true
		DScrollPanel:ReNewButtons(tab)
	end
	
	local clicked
	for k,v in SortedPairs(Tab) do
		local DButton = vgui.Create("DButton",DHorizontalScroller)
		local col
		DHorizontalScroller:AddPanel(DButton)
		DButton:Dock(LEFT)
		DButton:SetWidth(X*0.275)
		DButton:SetText("")
		DButton.Paint = function(DButton,w,h)
			surface.SetDrawColor(COL_DARK_GREY1.r,COL_DARK_GREY1.g,COL_DARK_GREY1.b,255)
			
			local s = 6
			-- surface.DrawRect(0,0,s,h)
			surface.DrawRect(w-s,0,s,h)
			surface.DrawRect(0,0,w,s)
			-- surface.DrawRect(0,h-s,w,s)
			
			col = DButton.Selected and COL_BLUE_HIGHLIGHT or (DButton:IsHovered() and COL_DARK_BLUE_HIGHLIGHT or nil)
			
			if col then
				if DButton.Selected then surface.DrawRect(w*0.1-s*0.5,h*0.775-s*0.5,w*0.8+s,h*0.075+s) end
				surface.SetDrawColor(col.r,col.g,col.b,255)
				
				-- surface.DrawRect(0,0,5,h)
				surface.DrawRect(w-5,0,5,h)
				surface.DrawRect(0,0,w,5)
				-- surface.DrawRect(0,h-5,w,5)
				
				if DButton.Selected then surface.DrawRect(w*0.1,h*0.775,w*0.8,h*0.075) end
			else
				col = COL_DARK_GREY1
			end
			draw.DrawText(k.." SIDE SETTINGS","Trebuchet24",w*0.5,h*0.25,col,TEXT_ALIGN_CENTER)
		end
		DButton.DoClick = function(DButton,NoSound)
			if !NoSound then
				surface.PlaySound("garrysmod/ui_click.wav")
			end
			if DHorizontalScroller.SelectedButton != DButton then
				DHorizontalScroller:ToggleSelect(DButton,v)
			end
		end
		if !clicked then
			DButton:DoClick(true)
			clicked = true
		end
	end
	
end

local function CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,ConVarName,ConVarText,ToolTip,ServerCVar)
	ToolTip = ToolTip and "\n"..ToolTip or ""
	local DCheckBoxLabel = vgui.Create("DCheckBoxLabel",Panel)
	DCheckBoxLabel:SetPos(25,y*0.5 - 12)
	DCheckBoxLabel:SetText(ConVarText..ToolTip)
	DCheckBoxLabel:SetConVar(ConVarName)
	DCheckBoxLabel.OnChange = function(self,val)
		val = val and 1 or 0
		gred.CheckConCommand(ConVarName,val)
		-- cvars.AddChangeCallback(ConVarName,function(cvar,OldVal,NewVal)
			
		-- end)
	end
	return DCheckBoxLabel
end

local function CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,ConVarName,ConVarText,ToolTip,HasApplyButton,ServerCVar)
	CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,ConVarName,ConVarText,ToolTip,ServerCVar)
	if HasApplyButton then
		local DButton = vgui.Create("DButton",Panel)
		DButton:SetSize(x*0.15,y*0.5)
		DButton:SetPos(x*0.75,y*0.25)
		DButton:SetText("Apply on all active simfphys vehicles")
		DButton.DoClick = function()
			if ServerCVar then
				net.Start("gred_net_applyboolonsimfphys")
					net.WriteString(ConVarName)
				net.SendToServer()
			else
				for k,v in pairs(gred.ActiveSimfphysVehicles) do
					v[ConVarName] = gred.CVars[ConVarName]:GetBool()
				end
			end
		end
	end
end

local function CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,ConVarName,ConVarText,ToolTip,Min,Max,Decimals,ServerCVar)
	ToolTip = ToolTip and "\n"..ToolTip or ""
	
	local DNumSlider = vgui.Create("DNumSlider",Panel)
	DNumSlider:SetPos(25,0)
	DNumSlider:SetText("")
	DNumSlider:SetMin(Min)
	DNumSlider:SetMax(Max)
	DNumSlider:SetDecimals(Decimals)
	DNumSlider:SetValue(gred.CVars[ConVarName]:GetFloat())
	DNumSlider:SetSize(x*0.7,y)
	DNumSlider.Scratch:SetSize(1,1)
	DNumSlider.TextArea:SetTextColor(color_white)
	
	DNumSlider.OnValueChanged = function(DNumSlider,val)
		if ServerCVar then
			gred.CheckConCommand(ConVarName,math.Round(val,Decimals)) 
		else
			gred.CVars[ConVarName]:SetFloat(val)
		end
	end
	
	local DLabel = vgui.Create("DLabel",Panel)
	DLabel:Dock(LEFT)
	DLabel:SetMouseInputEnabled(true)
	DLabel:SetText(ConVarText..ToolTip)
	DLabel:SetSize(x*0.7,y)
	DLabel:DockMargin(45,0,0,0)
	DNumSlider:MoveToFront()
end

local function CreateSimfphysSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,ConVarName,ConVarText,ToolTip,Min,Max,Decimals,HasApplyButton,ServerCVar)
	CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,ConVarName,ConVarText,ToolTip,Min,Max,Decimals,ServerCVar)
	if HasApplyButton then
		local DButton = vgui.Create("DButton",Panel)
		DButton:SetSize(x*0.15,y*0.5)
		DButton:SetPos(x*0.75,y*0.25)
		DButton:SetText("Apply on all active simfphys vehicles")
		DButton.DoClick = function()
			if ServerCVar then
				net.Start("gred_net_applyfloatonsimfphys")
					net.WriteString(ConVarName)
				net.SendToServer()
			else
				for k,v in pairs(gred.ActiveSimfphysVehicles) do
					v[ConVarName] = gred.CVars[ConVarName]:GetFloat()
				end
			end
		end
	end
end

local function CreateBindPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,ConVarName,ConVarText,ToolTip)
	ToolTip = ToolTip and "\n"..ToolTip or ""
	local DBinder = vgui.Create("DBinder",Panel)
	DBinder:SetValue(gred.CVars[ConVarName]:GetInt())
	DBinder.OnChange = function(DBinder,key)
		gred.CVars[ConVarName]:SetInt(key)
	end
	DBinder:SetSize(x*0.15,y*0.5)
	DBinder:SetPos(x*0.75,y*0.25)
	
	local DLabel = vgui.Create("DLabel",Panel)
	DLabel:Dock(LEFT)
	DLabel:SetMouseInputEnabled(true)
	DLabel:SetText(ConVarText..ToolTip) 
	DLabel:SetSize(x*0.7,y)
	DLabel:DockMargin(45,0,0,0)
end

local function CreateResetButton(DFrame,DPanel,DScrollPanel,Panel,x,y,Server)
	local DButton = vgui.Create("DButton",Panel)
	DButton:SetText("Reset every "..(Server and "server" or "client").." side convars to their default values")
	DButton:SetSize(x*0.2,y*0.5)
	DButton:SetPos(x*0.5 - x*0.2*0.5,y*0.25)
	
	DButton.DoClick = function(DButton)
		local ConfirmFrame = vgui.Create("DFrame")
		local OldPaint = ConfirmFrame.Paint
		local BlurTime = SysTime()
		local Index = table.insert(DFrame.RemoveOnRemove,ConfirmFrame)
		ConfirmFrame:SetSize(450,128)
		ConfirmFrame:SetTitle("Reset the "..(Server and "server" or "client").." side convars to their default values? This can't be undone!")
		ConfirmFrame:Center()
		ConfirmFrame:MakePopup()
		
		ConfirmFrame.OnRemove = function(ConfirmFrame)
			if IsValid(DFrame) then
				table.remove(DFrame.RemoveOnRemove,Index)
			end
		end
		
		ConfirmFrame.Paint = function(ConfirmFrame,w,h)
			Derma_DrawBackgroundBlur(ConfirmFrame,BlurTime)
			OldPaint(ConfirmFrame,w,h)
		end
		
		local DButton = vgui.Create("DButton",ConfirmFrame)
		DButton:SetPos(20,40)
		DButton:SetSize(128,64)
		DButton:SetText("Yes")
		DButton.DoClick = function(DButton)
			if not IsValid(DPanel) then return end
			
			DFrame:Remove()
			
			if Server then
				for k,v in pairs(gred.CVars) do
					if string.StartWith(k,"gred_sv") then
						gred.CheckConCommand(k,v:GetDefault())
					end
				end
			else
				for k,v in pairs(gred.CVars) do
					if string.StartWith(k,"gred_cl") then
						local default = v:GetDefault()
						
						if isstring(default) then
							v:SetString(default)
						else
							v:SetFloat(default)
						end
					end
				end
			end
		end
		
		local DButton = vgui.Create("DButton",ConfirmFrame)
		DButton:SetPos(302,40)
		DButton:SetSize(128,64)
		DButton:SetText("No")
		DButton.DoClick = function(DButton)
			if not IsValid(DPanel) then return end
			
			ConfirmFrame:Remove()
		end
		
	end
end

if IsValid(gred.OptionsMenuFrame) then
	gred.OptionsMenuFrame:Remove()
end

gred.Menu = {}
gred.Menu.CreateOptions = CreateOptions
gred.Menu.CreateCheckBoxPanel = CreateCheckBoxPanel
gred.Menu.CreateSliderPanel = CreateSliderPanel
gred.Menu.DrawEmptyRect = DrawEmptyRect
gred.Menu.CreateBindPanel = CreateBindPanel
gred.Menu.COL_WHITE					= COL_WHITE					
gred.Menu.COL_GREY					= COL_GREY					
gred.Menu.COL_LIGHT_GREY			= COL_LIGHT_GREY			
gred.Menu.COL_LIGHT_GREY1			= COL_LIGHT_GREY1			
gred.Menu.COL_RED					= COL_RED					
gred.Menu.COL_GREEN					= COL_GREEN					
gred.Menu.COL_DARK_GREY 			= COL_DARK_GREY 			
gred.Menu.COL_DARK_GREY1 			= COL_DARK_GREY1 			
gred.Menu.COL_BLUE_HIGHLIGHT		= COL_BLUE_HIGHLIGHT		
gred.Menu.COL_DARK_BLUE_HIGHLIGHT	= COL_DARK_BLUE_HIGHLIGHT	
gred.Menu.COL_TRANSPARENT_GREY 		= COL_TRANSPARENT_GREY

gred.ServerBanners = gred.ServerBanners or {}
gred.NewsMaterials = gred.NewsMaterials or {}



gred.AddHome = function(DFrame,DPanel,DScrollPanel,X,Y,X_DPanel,y_DPanel)
	local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("")
	DButton:Dock(TOP)
	DButton:DockMargin(0,0,0,10)
	DButton:SetSize(X_DPanel,y_DPanel*0.15)
	DButton.Paint = function(DButton,w,h)
		local col = DButton:IsHovered() and COL_BLUE_HIGHLIGHT or COL_WHITE
		surface.SetDrawColor(col.r,col.g,col.b,col.a)
		DrawEmptyRect(0,0,w,h,2,2,0)
		surface.SetMaterial(HomeMaterial)
		local H = h - 24
		surface.DrawTexturedRect((w - H)*0.5,0,H,H)
		
		draw.DrawText("HOME","Trebuchet24",w*0.5,h-24,col,TEXT_ALIGN_CENTER)
	end
	DButton.DoClick = function()
		DFrame:SelectLateralMenuOption("HOME")
		DPanel.ToggleButton:DoClick(true)
	end
	
	DFrame.LateralOptionList["HOME"] = function(DFrame,DPanel,X,Y)
		local DPanelNews_X,DPanelNews_Y = X*0.35,Y*0.32
		
		local CURRENT_VERSION = ""
		local changelogs = file.Exists("changelog.lua","LUA") and file.Read("changelog.lua","LUA") or (file.Exists("changelog.lua","lsv") and file.Read("changelog.lua","lsv") or "")
		 
		for i = 1,14 do if !changelogs[i] then break end CURRENT_VERSION = CURRENT_VERSION..changelogs[i] end
		CURRENT_VERSION = string.sub(CURRENT_VERSION,5)
		
		DPanel.Paint = function(DPanel,w,h)
			draw.DrawText("LATEST NEWS","Trebuchet24",w - DPanelNews_X*0.5,0,col,TEXT_ALIGN_CENTER)
			draw.DrawText("Gredwitch's Base version : "..CURRENT_VERSION,"Trebuchet24",0,h-24,col,TEXT_ALIGN_LEFT)
			draw.DrawText("FEATURED SERVERS","Trebuchet24",w*0.16,0,col,TEXT_ALIGN_LEFT)
			draw.DrawText("Steam Group","Trebuchet24",X - DPanelNews_X + 228,h*0.47,col,TEXT_ALIGN_CENTER)
			surface.SetDrawColor(40,40,40,255)
			surface.DrawRect(55,45,584,h-70)
		end
		
		local DScrollPanelServers = vgui.Create("DScrollPanel",DPanel)
		DScrollPanelServers:Dock(LEFT)
		DScrollPanelServers:DockMargin(60,50,0,70)
		DScrollPanelServers:SetWidth(560)
		DScrollPanelServers.ActiveButtons = {}
		
		DScrollPanelServers.PurgeButtons = function(DScrollPanelServers)
			for k,v in pairs(DScrollPanelServers.ActiveButtons) do
				v:Remove()
			end
			DScrollPanelServers.ActiveButtons = {}
		end
		
		DScrollPanelServers.CreateButton = function(DScrollPanelServers,IP,Data,ForceReload)
			local DImageButton = vgui.Create("DImageButton",DScrollPanelServers)
			DImageButton:Dock(TOP)
			DImageButton:SetHeight(95)
			DImageButton:DockMargin(0,0,0,10)
			DImageButton:SetText("")
			DImageButton:SetToolTip(Data.ToolTip or false)
			DImageButton.DoClick = function()
				surface.PlaySound("garrysmod/ui_click.wav")
				local DFrame1 = vgui.Create("DFrame")
				DImageButton.OnRemove = function()
					if IsValid(DFrame1) then DFrame1:Remove() end 
				end
				DFrame1.OnClose = function()
					surface.PlaySound("garrysmod/ui_click.wav")
				end
				local X,Y = ScrW()*0.2,ScrH()*0.2
				DFrame1:SetSize(X,Y)
				DFrame1:SetTitle("Connect to "..IP)
				DFrame1:Center()
				DFrame1:MakePopup()
				DFrame1.Think = function(DFrame1)
					DFrame1:MoveToFront()
				end
				DFrame1.Paint = function(DFrame1,w,h)
					draw.RoundedBox(1,0,0,w,24,COL_LIGHT_GREY)
					draw.RoundedBox(1,0,24,w,h-24,COL_GREY)
					-- draw.DrawText(text,"SmallRockwell",w*0.5,h*0.3,COL_WHITE,TEXT_ALIGN_CENTER)
				end
				
				local DScrollPanelServerInfo = vgui.Create("DScrollPanel",DFrame1)
				DScrollPanelServerInfo:Dock(FILL)
				
				if Data.Collection then
					local DButton = vgui.Create("DButton",DScrollPanelServerInfo)
					DButton:Dock(TOP)
					DButton:SetHeight(50)
					DButton:SetText("Collection")
					DButton.DoClick = function(DButton)
						surface.PlaySound("garrysmod/ui_click.wav")
						gui.OpenURL(Data.Collection)
					end
				end
				local DButton = vgui.Create("DButton",DScrollPanelServerInfo)
				DButton:Dock(TOP)
				DButton:SetHeight(50)
				DButton:SetText("Copy IP to clipboard")
				DButton.DoClick = function(DButton)
					surface.PlaySound("garrysmod/ui_click.wav")
					SetClipboardText(IP)
				end 
				if Data.Discord then
					local DButton = vgui.Create("DButton",DScrollPanelServerInfo)
					DButton:Dock(TOP)
					DButton:SetHeight(50)
					DButton:SetText("Discord Server")
					DButton.DoClick = function(DButton)
						surface.PlaySound("garrysmod/ui_click.wav")
						gui.OpenURL(Data.Discord)
					end
				end
				if Data.SteamGroup then
					local DButton = vgui.Create("DButton",DScrollPanelServerInfo)
					DButton:Dock(TOP)
					DButton:SetHeight(50)
					DButton:SetText("Steam group")
					DButton.DoClick = function(DButton)
						surface.PlaySound("garrysmod/ui_click.wav")
						gui.OpenURL(Data.SteamGroup)
					end
				end
			end
			GetServerBanner(IP,function()
				if IsValid(DImageButton) then
					DImageButton:SetMaterial(gred.ServerBanners[IP])
				end
			end,ForceReload) 
			table.insert(DScrollPanelServers.ActiveButtons,DImageButton)
		end
		
		DScrollPanelServers.CreateButtons = function(DScrollPanelServers,ForceReload)
			DScrollPanelServers:PurgeButtons()
			if gred.CVars.gred_sv_isdedicated:GetBool() then
				local DButton = vgui.Create("DButton",DScrollPanelServers)
				DButton:Dock(TOP)
				DButton:SetHeight(95)
				DButton:DockMargin(0,0,0,10)
				DButton:SetText("Featured servers are disabled on Dedicated Servers for obvious ethical reasons.")
				DButton.Paint = function(DButton,w,h)
				
				end
				table.insert(DScrollPanelServers.ActiveButtons,DButton)
			else
				http.Fetch("https://raw.githubusercontent.com/Gredwitch/gredwitch-base/master/servers.json",function(body)
					if !IsValid(DScrollPanelServers) then return end
					
					local tab = util.JSONToTable(body)
					
					if !istable(tab) then return end
					
					for k,v in SortedPairs(tab) do
						DScrollPanelServers:CreateButton(k,v,ForceReload)
					end
				end)
			end
		end
		
		DScrollPanelServers:CreateButtons() 
		
		
		local DImageButton = vgui.Create("DImageButton",DPanel)
		DImageButton:SetImage("icon16/arrow_rotate_clockwise.png")
		DImageButton:SetSize(18,18)
		DImageButton:SetPos(X*0.215,25)
		DImageButton:SetToolTip("Refresh...")
		DImageButton.DoClick = function()
			surface.PlaySound("garrysmod/ui_click.wav")
			DScrollPanelServers:CreateButtons(true)
		end
		
		local DPanelNewsMain = vgui.Create("DPanel",DPanel)
		DPanelNewsMain:SetSize(X*0.32,Y*0.32)
		DPanelNewsMain:SetPos(X - X*0.32 - 10,24)
		DPanelNewsMain.Paint = function() end
		DPanelNewsMain.SubPanels = {}
		
		
		DPanelNewsMain.NEWS_1 = 1
		DPanelNewsMain.NEWS_2 = 2
		DPanelNewsMain.FADE = 0
		DPanelNewsMain.ToggleImage = function(DPanelNewsMain,NewNews)
			DPanelNewsMain.NEWS_2 = DPanelNewsMain.NEWS_1
			DPanelNewsMain.NEWS_1 = NewNews
		end
		DPanelNewsMain.Paint = function(DPanelNewsMain,w,h)
		end
		
		DPanelNewsMain.SwitchPannels = function(DPanelNewsMain)
			DPanelNewsMain.SubPanels[DPanelNewsMain.NEWS_2]:AlphaTo(0,2)
			DPanelNewsMain.SubPanels[DPanelNewsMain.NEWS_1]:AlphaTo(255,2)
			DPanelNewsMain.SubPanels[DPanelNewsMain.NEWS_1]:MoveToFront()
		end
		
		DPanelNewsMain.AnimatePanels = function(DPanelNewsMain)
			local New
			DPanelNewsMain:SwitchPannels()
			timer.Create("ANIMATEPANELS",7,0,function()
				if !IsValid(DPanelNewsMain) then timer.Remove("ANIMATEPANELS") return end
				if !istable(DPanelNewsMain.SubPanels) then timer.Remove("ANIMATEPANELS") return end
				
				New = DPanelNewsMain.NEWS_2 + 1
				New = New > #DPanelNewsMain.SubPanels and 1 or New
				DPanelNewsMain.NEWS_2 = DPanelNewsMain.NEWS_1
				DPanelNewsMain.NEWS_1 = New
				DPanelNewsMain:SwitchPannels()
			end)
		end
		
		DPanelNewsMain.OnRemove = function()
			timer.Remove("ANIMATEPANELS")
		end
		
		if gred.CachedNewsTable then
			CreateNewsPanels(DPanelNewsMain,gred.CachedNewsTable)
		else
			http.Fetch("https://steamcommunity.com/groups/GredCancer/rss/",function(body)
				local tab = include("xml2lua/xmlhandler/tree.lua")
				xml2lua.parser(tab):parse(body)
				
				if !istable(tab) then return end
				
				gred.CachedNewsTable = tab.root.rss.channel.item
				CreateNewsPanels(DPanelNewsMain,gred.CachedNewsTable)
			end)
		end
	
		local DButtonSteamGroup = vgui.Create("DImageButton",DPanel)
		DButtonSteamGroup:SetSize(436,87)
		DButtonSteamGroup:SetPos(X - DPanelNews_X + 109,Y*0.35)
		DButtonSteamGroup.DoClick = function()
			surface.PlaySound("garrysmod/ui_click.wav")
			gui.OpenURL("https://steamcommunity.com/groups/GredCancer")
		end
		GetSteamGroupImage(function(mat)
			if !IsValid(DButtonSteamGroup) then return end
			DButtonSteamGroup:SetMaterial(mat)
		end)
	end
end

gred.AddOthers = function(DFrame,DPanel,DScrollPanel,X,Y,X_DPanel,y_DPanel)
	local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("")
	DButton:Dock(TOP)
	DButton:DockMargin(0,0,0,10) 
	DButton:SetSize(X_DPanel,y_DPanel*0.15)
	
	DButton.Paint = function(DButton,w,h)
		local col = DButton:IsHovered() and COL_BLUE_HIGHLIGHT or COL_WHITE
		surface.SetDrawColor(col.r,col.g,col.b,col.a)
		DrawEmptyRect(0,0,w,h,2,2,0)
		surface.SetMaterial(PlusMaterial)
		local H = h - 24
		surface.DrawTexturedRect((w - H)*0.5,0,H,H)
		
		draw.DrawText("OTHER OPTIONS","Trebuchet24",w*0.5,h-24,col,TEXT_ALIGN_CENTER)
	end
	
	DButton.DoClick = function()
		DFrame:SelectLateralMenuOption("OTHER OPTIONS")
		DPanel.ToggleButton:DoClick(true)
	end
	
	DFrame.LateralOptionList["OTHER OPTIONS"] = function(DFrame,DPanel,X,Y)
			CreateOptions(DFrame,DPanel,X,Y,{
			["CLIENT"] = {
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateResetButton(DFrame,DPanel,DScrollPanel,Panel,x,y,false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_altmuzzleeffect","Use a high quality muzzle flash effect","Toggle this if you have performance issues",false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_enable_popups","Pop ups about missing content","",false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_resourceprecache","Resources precaching","[NOTE : Increases loading times]",false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					-- CreateComboBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_favouritetab","Default options tab","",false)
					-- ToolTip = ToolTip and "\n"..ToolTip or ""
					-- local DCheckBoxLabel = vgui.Create("DCheckBoxLabel",Panel)
					-- DCheckBoxLabel:SetPos(25,y*0.5 - 12)
					-- DCheckBoxLabel:SetText(ConVarText..ToolTip)
					-- DCheckBoxLabel:SetConVar(ConVarName)
					-- DCheckBoxLabel.OnChange = function(self,val)
						-- val = val and 1 or 0
						-- gred.CheckConCommand(ConVarName,val)
					-- end
					-- return DCheckBoxLabel
	
					local DLabel = vgui.Create("DLabel",Panel)
					DLabel:Dock(LEFT)
					DLabel:SetMouseInputEnabled(true)
					DLabel:SetText("Default options tab")
					DLabel:SetSize(x*0.7,y)
					DLabel:DockMargin(45,0,0,0)
					
					local DComboBox = vgui.Create("DComboBox",Panel)
					DComboBox:SetSize(x*0.15,y*0.5)
					DComboBox:SetPos(x*0.75,y*0.25)
					for k,v in pairs(DFrame.LateralOptionList) do
						DComboBox:AddChoice(k)
					end
					DComboBox:SetValue(gred.CVars.gred_cl_favouritetab:GetString())
					DComboBox.OnSelect = function(DComboBox,index,value)
						gred.CVars.gred_cl_favouritetab:SetString(value)
					end
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					local DLabel = vgui.Create("DLabel",Panel)
					DLabel:Dock(LEFT)
					DLabel:SetMouseInputEnabled(true)
					DLabel:SetText("Clear the menu image cache\n[NOTE : This will close your menu]")
					DLabel:SetSize(x*0.7,y)
					DLabel:DockMargin(45,0,0,0)
					
					local DButton = vgui.Create("DButton",Panel)
					DButton:SetSize(x*0.15,y*0.5)
					DButton:SetPos(x*0.75,y*0.25)
					DButton:SetText("Clear")
					DButton.DoClick = function()
						surface.PlaySound("garrysmod/ui_click.wav")
						DFrame:Remove()
						gred.ServerBanners = {}
						gred.NewsMaterials = {}
						local files,folders = file.Find("gredwitch_base_cache/*","DATA")
						if files then
							local v
							for k = 1,#files do
								v = files[k]
								if v then
									file.Delete("gredwitch_base_cache/"..v)
								end
							end
						end
					end
				end,
			},
			["SERVER"] = {
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateResetButton(DFrame,DPanel,DScrollPanel,Panel,x,y,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_resourceprecache","Resources precaching","[NOTE : Increases loading times]",true)
				end,
			},
		})
	end
end

gred.CreateLateralMenu = function(DFrame,X,Y)
	local DPanel = vgui.Create("DPanel",DFrame)
	local X_DPanel,y_DPanel = X*0.18,Y-24
	DPanel.IsShown = false
	DPanel:SetPos(-X_DPanel,24)
	DPanel:SetSize(X_DPanel,y_DPanel)
	DPanel.Paint = function(DPanel,w,h)
		draw.RoundedBox(0,0,0,w,h,COL_DARK_GREY)
	end
	DFrame.LateralOptionList = {}
	
	local DScrollPanel = vgui.Create("DScrollPanel",DPanel)
	DScrollPanel:Dock(FILL)
	DScrollPanel:DockMargin(0,45,0,0)
	gred.AddHome(DFrame,DPanel,DScrollPanel,X,Y,X_DPanel,y_DPanel)
	hook.Run("GredOptionsAddLateralMenuOption",DFrame,DPanel,DScrollPanel,X,Y,X_DPanel,y_DPanel)
	gred.AddOthers(DFrame,DPanel,DScrollPanel,X,Y,X_DPanel,y_DPanel)
	
	local DButton = vgui.Create("DButton",DFrame)
	DPanel.ToggleButton = DButton
	DButton:SetPos(18,30)
	DButton:SetSize(45,64)
	DButton:SetText("")
	DButton:SetTextColor(COL_WHITE)
	DButton.DoClick = function(DButton,NotToggle)
		surface.PlaySound("garrysmod/ui_click.wav")
		DPanel.IsShown = !DPanel.IsShown
		if DPanel.IsShown or NotToggle then
			DPanel:MoveToFront()
		end
		DPanel:MoveTo(DPanel.IsShown and 0 or -X_DPanel,24,1,0,-1)
	end
	-- DButton:DoClick()
	DButton.Paint = function(DButton,w,h)
		local col = DButton:IsHovered() and COL_BLUE_HIGHLIGHT or COL_WHITE
		surface.SetDrawColor(col.r,col.g,col.b,col.a)
		DrawEmptyRect(0,0,w,7,2,2,0)
		DrawEmptyRect(0,10,w,7,2,2,0)
		DrawEmptyRect(0,0,w,7,2,2,0)
		DrawEmptyRect(0,20,w,7,2,2,0)
		DButton:MoveToFront()
	end
end

gred.OpenOptions = function()
	local X,Y = ScrW()*0.8,ScrH()*0.8
	
	local DFrame = vgui.Create("DFrame")
	gred.OptionsMenuFrame = DFrame
	DFrame:SetSize(X,Y)
	-- DFrame:SetTitle("Gredwitch's Base : Options")
	DFrame:SetTitle("")
	DFrame:ShowCloseButton(false)
	DFrame:SetDraggable(false)
	DFrame:Center()
	DFrame:MakePopup()
	
	DFrame.RemoveOnRemove = {}
	
	DFrame.OnRemove = function(DFrame)
		for k,v in pairs(DFrame.RemoveOnRemove) do
			v:Remove()
		end
	end
	
	DFrame.SelectLateralMenuOption = function(DFrame,OptionID)
		if !OptionID then return end
		if !DFrame.LateralOptionList[OptionID] then return end
		if IsValid(DFrame.CurrentDPanel) then
			DFrame.CurrentDPanel:Remove()
		end
		local DPanel = vgui.Create("DPanel",DFrame)
		DPanel:Dock(FILL)
		DFrame.CurrentDPanel = DPanel
		DFrame.LateralOptionList[OptionID](DFrame,DPanel,X,Y-24)
	end
	
	DFrame.Paint = function(DFrame,w,h)
		draw.RoundedBox(1,0,0,w,24,COL_GREY)
		draw.RoundedBox(1,0,24,w,h-24,COL_DARK_GREY)
		
		draw.DrawText("Gredwitch's Base Options","Trebuchet24",w*0.5,0,COL_WHITE,TEXT_ALIGN_CENTER)
	end
	
	local DButton = vgui.Create("DButton",DFrame)
	DButton:SetPos(X - 18,3)
	DButton:SetSize(18,18)
	DButton:SetText("X")
	DButton:SetTextColor(COL_WHITE)
	DButton.DoClick = function(DButton)
		surface.PlaySound("garrysmod/ui_click.wav")
		DFrame:Remove()
	end
	DButton.Paint = function(DButton,w,h)
		DButton:SetTextColor(DButton:IsHovered() and COL_BLUE_HIGHLIGHT or COL_WHITE)
	end
	
	gred.CreateLateralMenu(DFrame,X,Y)
	
	local str = gred.CVars.gred_cl_favouritetab:GetString()
	DFrame:SelectLateralMenuOption(DFrame.LateralOptionList[str] and str or "HOME")
end



hook.Add("GredOptionsAddLateralMenuOption","AddLFS",function(DFrame,DPanel,DScrollPanel,X,Y,X_DPanel,y_DPanel)
	local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("")
	DButton:Dock(TOP)
	DButton:DockMargin(0,0,0,10)
	DButton:SetSize(X_DPanel,y_DPanel*0.15)
	DButton.Paint = function(DButton,w,h)
		local col = DButton:IsHovered() and COL_BLUE_HIGHLIGHT or COL_WHITE
		surface.SetDrawColor(col.r,col.g,col.b,col.a)
		DrawEmptyRect(0,0,w,h,2,2,0)
		surface.SetMaterial(LFSMaterial)
		local H = h - 24
		surface.DrawTexturedRect((w - H)*0.5,0,H,H)
		draw.DrawText("LFS OPTIONS","Trebuchet24",w*0.5,h-24,col,TEXT_ALIGN_CENTER)
	end
	DButton.DoClick = function()
		DFrame:SelectLateralMenuOption("LFS OPTIONS")
		DPanel.ToggleButton:DoClick(true)
	end
	
	DFrame.LateralOptionList["LFS OPTIONS"] = function(DFrame,DPanel,X,Y)
			CreateOptions(DFrame,DPanel,X,Y,{
			["SERVER"] = {
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_lfs_infinite_ammo","Infinite ammo","[NOTE : Makes bombs undroppable!]",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_lfs_godmode","Aircraft God mode","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_lfs_healthmultiplier_all","Health multiplier mode","Check this if you want the health multiplier to change all the LFS aircrafts' health, turn off if you want it to only change Gredwitch's LFS aircrafts health.",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_lfs_healthmultiplier","Aircraft health multiplier","",0.1,10,1,true)
				end,
			},
		})
	end
end)

hook.Add("GredOptionsAddLateralMenuOption","AddSimfphys",function(DFrame,DPanel,DScrollPanel,X,Y,X_DPanel,y_DPanel)
	local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("")
	DButton:Dock(TOP)
	DButton:DockMargin(0,0,0,10)
	DButton:SetSize(X_DPanel,y_DPanel*0.15)
	DButton.Paint = function(DButton,w,h)
		local col = DButton:IsHovered() and COL_BLUE_HIGHLIGHT or COL_WHITE
		surface.SetDrawColor(col.r,col.g,col.b,col.a)
		DrawEmptyRect(0,0,w,h,2,2,0)
		surface.SetMaterial(SimfphysMaterial)
		local H = h - 24
		surface.DrawTexturedRect((w - H)*0.5,0,H,H)
		
		draw.DrawText("SIMFPHYS OPTIONS","Trebuchet24",w*0.5,h-24,col,TEXT_ALIGN_CENTER)
	end
	DButton.DoClick = function()
		DFrame:SelectLateralMenuOption("SIMFPHYS OPTIONS")
		DPanel.ToggleButton:DoClick(true)
	end
	
	DFrame.LateralOptionList["SIMFPHYS OPTIONS"] = function(DFrame,DPanel,X,Y)
		CreateOptions(DFrame,DPanel,X,Y,{
			["CLIENT"] = {
				-- function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					-- CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_testviewports","WIP Viewport System","Enables the WIP viewport system - may cause heavy lags",true,false)
				-- end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_suspensions","Enable suspensions","Uncheck this if you have extreme lags.",true,false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_camera_tankgunnersight","Camera from tank gunner sight","Moves the camera to the muzzle of your main gun when possible in sight mode",false,false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_enablecrosshair","Enable crosshair","Toggles the crosshair [NOTE : This is ignored if the crosshairs are disabled server side]",false,false)
				end,
				-- function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					-- CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_viewport_hq","High quality viewports","Do not tick this if you have performance issues",true,false)
				-- end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_viewport_fovnodraw","Viewport FOV draw offset","Decrease this if you don't like viewports dissapearing when you look too much away, Increase this if viewports make you lag",-90,90,0,true,false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_viewport_fovnodraw_vertical","Viewport FOV vertical offset multiplier","Increase this if you don't like viewports dissapearing when you look too much away, decrease this if viewports make you lag",0,1,2,true,false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_maxsuspensioncalcdistance","Max suspension calculation distance","The suspensions of the tanks won't be calculated past this distnace, decrease this if you have performance issues\n[NOTE : This is ignored if you have completely disabled the suspensions]",0,3000000,0,true,false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_sightsensitivity","Mouse sensitivity in sight mode","",0,1,2,true,false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateBindPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_key_togglesight","Toggle tank sight")
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateBindPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_key_changeshell","Toggle shell types") 
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateBindPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_key_togglegun","Toggle tank gun")
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateBindPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_key_togglehatch","Toggle hatch")
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateBindPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_key_throwsmoke","Launch smoke grenade")
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateBindPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_simfphys_key_togglezoom","Toggle Zoom")
				end,
			},
			["SERVER"] = {
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_arcade","Turret driver control","Gives the ability to the drive to operate the main gun by himself.",false,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_camera_tankgunnersight","Allow camera from tank gunner sight","Allows player to have their camera to the muzzle of their main gun in sight mode",false,true)
				end,
				vFireIsVFireEnt and function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_vfire_thrower","vFire flame tanks","Gives the ability to tanks to throw vFire if vFire is installed and enabled.",false,true)
				end or nil,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_infinite_ammo","Infinite ammo","Toggles infinite ammo for anything that isn't a machinegun",true,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_infinite_mg_ammo","Infinite machinegun ammo","Toggles infinite ammo for anything that is a machinegun / autocannon",true,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_disable_viewmodels","Disable 1st person viewport models","Toggles the view goggles / viewports in 1st person for tanks that have them",false,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_spawnwithoutammo","Spawn without ammo","Spawns vehicles with 0 munitions",false,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_enablecrosshair","Enable crosshair","If unchecked, will force disable the crosshair on every clients",false,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_lesswheels","Force 4 wheels instead of 6","For super slow servers - check this if you want to trade behavior for performance",false,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_forcefirstperson","Force 1st person mode","",true,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_manualreloadsystem","Loader system","Gives the ability to the loader to reload the gun and change the shell types instead of having an automatic reload",false,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_forcesynchronouselevation","Force synchronous elevation","Makes the gun able to move vertically while moving horizontally",true,true)
				end,
				-- function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					-- CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_moduledamagesystem","Module damage system","Toggles the realistic module damage system - uncheck this if you want an health-based damage system",false,true)
				-- end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_realisticarmour","Armour simulation system","If disabled, the armour thickness of a tank will be calculated based on its maximum health",false,true)
				end,
				-- function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					-- CreateSimfphysCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_testsuspensions","Test suspensions","trololo",false,true)
				-- end,
				
				-- function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					-- CreateSimfphysSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_turnrate_multplier","Turn rate multiplier","trololo",false,true)
				-- end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_smokereloadtime","Smoke launchers reload time","",0,3600,0,false,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_traverse_speed_multiplier","Turret traverse speed multiplier","",0.1,10,1,false,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_reload_speed_multiplier","Cannon reload speed multiplier","",0.1,10,1,false,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_elevation_speed_multiplier","Turret elevation speed multiplier","",0.1,10,1,false,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_health_multplier","Health multiplier","",0.1,3,1,false,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSimfphysSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_simfphys_suspension_rate","Suspension calculation rate","Increase this this if your server lags when tanks are on",0,1,1,true,true)
				end,
			},
		})
	end
end)

hook.Add("GredOptionsAddLateralMenuOption","AddWAC",function(DFrame,DPanel,DScrollPanel,X,Y,X_DPanel,y_DPanel)
	local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("")
	DButton:Dock(TOP)
	DButton:DockMargin(0,0,0,10)
	DButton:SetSize(X_DPanel,y_DPanel*0.15)
	DButton.Paint = function(DButton,w,h)
		local col = DButton:IsHovered() and COL_BLUE_HIGHLIGHT or COL_WHITE
		surface.SetDrawColor(col.r,col.g,col.b,col.a)
		DrawEmptyRect(0,0,w,h,2,2,0)
		surface.SetMaterial(WACMaterial)
		local H = h - 24
		surface.DrawTexturedRect((w - H)*0.5,0,H,H)
		
		draw.DrawText("WAC OPTIONS","Trebuchet24",w*0.5,h-24,col,TEXT_ALIGN_CENTER)
	end
	DButton.DoClick = function()
		DFrame:SelectLateralMenuOption("WAC OPTIONS")
		DPanel.ToggleButton:DoClick(true)
	end
	
	DFrame.LateralOptionList["WAC OPTIONS"] = function(DFrame,DPanel,X,Y)
			CreateOptions(DFrame,DPanel,X,Y,{
			["CLIENT"] = {
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_wac_explosions","Enable crash effects","",false)
				end,
			},
			["SERVER"] = {
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_wac_override","Override default WAC functions","[NOTE : if you uncheck this, most of the settings down there will be ignored]",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_oldrockets","Use legacy rockets","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_wac_bombs","Enable bombs in aircrafts","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_wac_radio","Enable radio sounds","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_jets_speed","Fast jets","[NOTE : Might require a map restart to work]",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_fire_effect","Alternative fire particles","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_multiple_fire_effects","1 fire particle per engine system","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_wac_explosion_water","Water crashes aircrafts","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_wac_explosion","Custom aircraft explosions","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_default_wac_munitions","Use default WAC weapons","[NOTE : Only works on aircrafts that use Gredwitch's weapons]",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_wac_heli_spin","Helicopter spin on low health","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_enablehealth","Custom health system","[NOTE : The health settings down there will be ignored if you turn this off]",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_enableenginehealth","Custom health per engine system","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_healthslider","Health per engine","",1,1000,0,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_wac_heli_spin_chance","Helicopter spin chance","[NOTE : Set to 0 if you want the helicopters to always spin]",0,10,0,true)
				end,
			},
		})
	end
end)

hook.Add("GredOptionsAddLateralMenuOption","AddBullet",function(DFrame,DPanel,DScrollPanel,X,Y,X_DPanel,y_DPanel)
	local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("")
	DButton:Dock(TOP)
	DButton:DockMargin(0,0,0,10)
	DButton:SetSize(X_DPanel,y_DPanel*0.15)
	DButton.Paint = function(DButton,w,h)
		local col = DButton:IsHovered() and COL_BLUE_HIGHLIGHT or COL_WHITE
		surface.SetDrawColor(col.r,col.g,col.b,col.a)
		DrawEmptyRect(0,0,w,h,2,2,0)
		surface.SetMaterial(BulletMaterial)
		local H = h - 24
		surface.DrawTexturedRect((w - H)*0.5,0,H,H)
		
		draw.DrawText("BULLET OPTIONS","Trebuchet24",w*0.5,h-24,col,TEXT_ALIGN_CENTER)
	end
	DButton.DoClick = function()
		DFrame:SelectLateralMenuOption("BULLET OPTIONS")
		DPanel.ToggleButton:DoClick(true)
	end
	
	DFrame.LateralOptionList["BULLET OPTIONS"] = function(DFrame,DPanel,X,Y)
			CreateOptions(DFrame,DPanel,X,Y,{
			["CLIENT"] = {
				-- function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					-- CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_insparticles","Use Insurgency particles for 7mm bullets","",false)
				-- end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_noparticles_7mm","Disable particles for 7mm bullets","",false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_noparticles_12mm","Disable particles for 12mm bullets","",false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_noparticles_20mm","Disable particles for 20mm shells","",false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_noparticles_30mm","Disable particles for 30mm shells","",false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_noparticles_40mm","Disable particles for 40mm shells","",false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_nowaterimpacts","Disable water impact particles","",false)
				end,
			},
			["SERVER"] = {
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_12mm_he_impact","Blast radius for 12mm bullets","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_7mm_he_impact","Blast radius for 7mm bullets","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_override_hab","Override HAVOK's physical bullet module","[NOTE : Only works if HAVOK's physical bullet module is installed]",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_bullet_dmg","Bullet damage multiplier","",0,10,2,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_bullet_radius","Bullet radius multiplier","",0,10,2,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_tracers","Tracer ammo rate","A tracer will appear after X bullet shot",0,20,0,true)
				end,
			},
		})
	end
end)

hook.Add("GredOptionsAddLateralMenuOption","AddExplosives",function(DFrame,DPanel,DScrollPanel,X,Y,X_DPanel,y_DPanel)
	local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("")
	DButton:Dock(TOP)
	DButton:DockMargin(0,0,0,10)
	DButton:SetSize(X_DPanel,y_DPanel*0.15)
	DButton.Paint = function(DButton,w,h)
		local col = DButton:IsHovered() and COL_BLUE_HIGHLIGHT or COL_WHITE
		surface.SetDrawColor(col.r,col.g,col.b,col.a)
		DrawEmptyRect(0,0,w,h,2,2,0)
		surface.SetMaterial(ExplosivesMaterial)
		local H = h - 24
		surface.DrawTexturedRect((w - H)*0.5,0,H,H)
		
		draw.DrawText("EXPLOSIVES OPTIONS","Trebuchet24",w*0.5,h-24,col,TEXT_ALIGN_CENTER)
	end
	DButton.DoClick = function()
		DFrame:SelectLateralMenuOption("EXPLOSIVES OPTIONS")
		DPanel.ToggleButton:DoClick(true)
	end
	
	DFrame.LateralOptionList["EXPLOSIVES OPTIONS"] = function(DFrame,DPanel,X,Y)
		CreateOptions(DFrame,DPanel,X,Y,{
			["CLIENT"] = {
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_sound_shake","Explosions shake your screen","",false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_decals","Explosions decals","",false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_shell_enable_killcam","War Thunder killcam","Toggles the killcam that appears on the top left corner of your screen when you hit a vehicle [NOTE : Only works if this is enabled server side]",false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_shell_blur","Shell suppresion effects","Blurs your screen when a shell near misses you",false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_shell_blur_invehicles","Shell suppresion effects in vehicles","[NOTE : Only works when Shell suppresion effects is enabled]",false)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_cl_explosionvolume","Explosion sounds volume","",0,1,2,false)
				end,
			},
			["SERVER"] = {
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_easyuse","Explosives easy-use mode","Allows you to arm explosives by pressing the USE key on them",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_shockwave_unfreeze","Explosives unweld and unfreeze","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_fragility","Explosives arm when hit or dropped","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_spawnable_bombs","Spawnable explosives","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_shell_enable_killcam","War Thunder killcam","Allows / Disallows players to see the War Thunder style killcam that appears on their screen when they hit a vehicle",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_shell_he_damage","HE shells all deal the same ammount of damage","",true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateCheckBoxPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_shell_ap_lowpen_system","Arcade non-penetration system","Deals a very low ammouny of damage on a non penetration instead of dealing no damage at all",true) -- [NOTE : Only works when the custom module system is disabled]
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_shell_ap_damagemultiplier","AP shells damage multiplier","",0,10,2,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_shell_apcr_damagemultiplier","APCR shells damage multiplier","",0,10,2,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_shell_he_damagemultiplier","HE shells damage multiplier","",0,10,2,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_shell_heat_damagemultiplier","HEAT shells damage multiplier","",0,10,2,true)
				end,
				function(DFrame,DPanel,DScrollPanel,Panel,x,y)
					CreateSliderPanel(DFrame,DPanel,DScrollPanel,Panel,x,y,"gred_sv_soundspeed_divider","Explosion sound distance preset","The higher this value is, the lower the explosion sounds will be from far away",1,3,0,true)
				end,
			},
		})
	end
end)


list.Set("DesktopWindows","GredwitchOptionsMenu",{
	title = "GB Options",
	icon = "icon64/bombicon_widget_64.png",
	init = gred.OpenOptions,
})

concommand.Add("gred_openoptions",gred.OpenOptions)

file.CreateDir("gredwitch_base_cache")
