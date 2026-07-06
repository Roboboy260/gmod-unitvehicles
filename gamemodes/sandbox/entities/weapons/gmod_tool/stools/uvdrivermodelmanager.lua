TOOL.Category		=	"uv.unitvehicles"
TOOL.Name			=	"#tool.uvdrivermodelmanager.name"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

local conVarsDefault = TOOL:BuildConVarList()

if SERVER then

	net.Receive("UVDriverModelManagerRetrieve", function( length, ply )
		local filename = net.ReadString()

		local data = UV_LoadFile("drivermodels", filename)
		if not data then return end

		ply.UVDMTOOLMemory = {}

		ply.UVDMTOOLMemory = util.JSONToTable(
			data, true
		)
	end)

	net.Receive("UVDriverModelManagerRetrieveColor", function( length, ply )
		local color = net.ReadColor(false)

		if color.r == 0 and color.g == 0 and color.b == 0 and color.a == 0 then
		    color = color_white
			ply:PrintMessage(HUD_PRINTTALK, "Driver Model Manager: Unable to retrieve color, defaulting to white.")
		end

		ply.UVDMTOOLMemory["Color"] = color

		ply:SelectWeapon( "gmod_tool" )
	end)

	net.Receive("UVDriverModelManagerDeleteFile", function( length, ply )
		if ply and not ply:IsSuperAdmin() then return end

		local path = net.ReadString()
		local fileName = net.ReadString()

		local file = UV_GetFile(path, fileName)
		if not file then return end

		if not UV_IsWorkshop( path, fileName ) then
			UV_RemoveFile( path, fileName )
		end
	end)

	net.Receive("UVDriverModelManagerCreate", function( length, ply )
		if next(ply.UVDMTOOLMemory) == nil then return end

		local name = net.ReadString()
		local randomizebodygroups = net.ReadBool()
		local randomizeskin = net.ReadBool()
		local randomizecolor = net.ReadBool()

		ply.UVDMTOOLMemory["RandomizeBodygroups"] = randomizebodygroups
		ply.UVDMTOOLMemory["RandomizeSkin"] = randomizeskin
		ply.UVDMTOOLMemory["RandomizeColor"] = randomizecolor

		local jsondata = util.TableToJSON(ply.UVDMTOOLMemory)
		file.Write("unitvehicles/drivermodels/"..name..".json", jsondata)
		UV_AddFile( "drivermodels", name .. ".json", "unitvehicles/drivermodels/", "DATA" )

		PrintMessage( HUD_PRINTTALK, "Driver Model "..name.." has been created!" )
		net.Start("UVDriverModelManagerRefresh")
		net.Send(ply)

	end)

end

if CLIENT then

	TOOL.Information = {
		{ name = "info"},
		{ name = "left" },
		{ name = "right" },
	}

	local selecteditem	= nil
	local UVDMTOOLMemory = {}
	
	net.Receive("UVDriverModelManagerRetrieve", function( length )
		UVDMTOOLMemory = net.ReadTable()
		
		--PlayerColor
		local entIndex = net.ReadInt( 32 )
		local creationId = net.ReadInt( 32 )
		
		local entity = Entity( entIndex )
		if not IsValid( entity ) then return end

		local localCreationId = entity:GetCreationID()

		if localCreationId ~= creationId then 
			return 
		end

		local vectorColor = isfunction(entity.GetPlayerColor) and entity:GetPlayerColor() or Vector(1, 1, 1)
		local rgbColor = vectorColor:ToColor()
		
		UVDMTOOLMemory["Color"] = rgbColor

		net.Start("UVDriverModelManagerRetrieveColor")
			net.WriteColor( rgbColor, false )
		net.SendToServer()
	end)

	net.Receive("UVDriverModelManagerAdjust", function()
		local DriverModelAdjust = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")

		DriverModelAdjust:Add(OK)
		DriverModelAdjust:SetSize(1000, 500)
		DriverModelAdjust:SetBackgroundBlur(true)
		DriverModelAdjust:Center()
		DriverModelAdjust:SetTitle("#tool.uvdrivermodelmanager.create")
		DriverModelAdjust:SetDraggable(false)
		DriverModelAdjust:MakePopup()

		local Intro = vgui.Create( "DLabel", DriverModelAdjust )
		Intro:SetPos( 20, 40 )
		Intro:SetText( string.format( language.GetPhrase("tool.uvdrivermodelmanager.create.desc"), UVDMTOOLMemory.ModelName ) )
		Intro:SizeToContents()

		local DriverModelNameEntry = vgui.Create( "DTextEntry", DriverModelAdjust )
		DriverModelNameEntry:SetPos( 20, 70 )
		DriverModelNameEntry:SetPlaceholderText( "#tool.uvdrivermodelmanager.create.name" )
		DriverModelNameEntry:SetSize(DriverModelAdjust:GetWide() / 2, 22)

		local RandomizeBodygroups = vgui.Create( "DCheckBoxLabel", DriverModelAdjust )
		RandomizeBodygroups:SetPos( 20, 100 )
		RandomizeBodygroups:SetText( "#tool.uvdrivermodelmanager.create.optional.randomizebodygroups" )
		RandomizeBodygroups:SetValue( 0 )

		local RandomizeSkin = vgui.Create( "DCheckBoxLabel", DriverModelAdjust )
		RandomizeSkin:SetPos( 20, 120 )
		RandomizeSkin:SetText( "#tool.uvdrivermodelmanager.create.optional.randomizeskin" )
		RandomizeSkin:SetValue( 0 )

		local RandomizeColor = vgui.Create( "DCheckBoxLabel", DriverModelAdjust )
		RandomizeColor:SetPos( 20, 140 )
		RandomizeColor:SetText( "#tool.uvdrivermodelmanager.create.optional.randomizecolor" )
		RandomizeColor:SetValue( 0 )

		local Warning = vgui.Create( "DLabel", DriverModelAdjust )
		Warning:SetPos( 20, 160 )
		Warning:SetText( UVDMTOOLMemory.NoDriveSequence and "#tool.uvdrivermodelmanager.sequence.warning" or "" )
		Warning:SizeToContents()

		OK:SetText("#uv.tool.create")
		OK:SetSize(DriverModelAdjust:GetWide() * 5 / 16, 22)
		OK:Dock(BOTTOM)

		function OK:DoClick()

			local Name = DriverModelNameEntry:GetValue()
					
			if Name ~= "" then

				net.Start("UVDriverModelManagerCreate")
				net.WriteString(Name)
				net.WriteBool(RandomizeBodygroups:GetChecked())
				net.WriteBool(RandomizeSkin:GetChecked())
				net.WriteBool(RandomizeColor:GetChecked())
				net.SendToServer()
				
				DriverModelAdjust:Close()
				surface.PlaySound( "buttons/button15.wav" )

			else
				DriverModelNameEntry:SetPlaceholderText( "#uv.tool.fillme" )
				surface.PlaySound( "buttons/button10.wav" )
			end
			
		end
	end)

	net.Receive("UVDriverModelManagerRefresh", function( length )
		UVDriverModelManagerScrollPanel:Clear()
		if RefreshDriverModelList then RefreshDriverModelList() end
	end)

	function TOOL.BuildCPanel(CPanel)
		local lang = language.GetPhrase
		
		if not file.Exists( "unitvehicles/drivermodels", "DATA" ) then
			file.CreateDir( "unitvehicles/drivermodels" )
			print("Created a Driver Model data file!")
		end

		CPanel:AddControl("Label", {
			Text = "#tool.uvdrivermodelmanager.desc",
		})

		local selecteditem = nil

		local Frame = vgui.Create("DPanel")
		Frame:SetTall(320)
		Frame.Paint = function(self, w, h)
			draw.RoundedBox(5, 0, 0, w, h, Color(115,115,115,200))
			draw.RoundedBox(5, 1, 1, w-2, h-2, Color(0,0,0,200))
		end
		CPanel:AddItem(Frame)

		UVDriverModelManagerScrollPanel = vgui.Create("DScrollPanel", Frame)
		UVDriverModelManagerScrollPanel:Dock(FILL)
		UVDriverModelManagerScrollPanel:DockMargin(4, 4, 4, 4)

		local function RefreshDriverModelList()
			UVDriverModelManagerScrollPanel:Clear()
			selecteditem = nil

			local files = UV_GetFiles( "drivermodels" )

			if #files == 0 then
				local empty = vgui.Create("DLabel", UVDriverModelManagerScrollPanel)
				empty:SetText("#uv.tool.nodm")
				empty:SetTextColor(Color(200,200,200))
				empty:SetContentAlignment(5)
				empty:Dock(TOP)
				empty:SetTall(24)
				return
			end

			for _, filename in ipairs(files) do
				local btn = UVDriverModelManagerScrollPanel:Add("DButton")
				btn:Dock(TOP)
				btn:DockMargin(0, 0, 0, 4)
				btn:SetTall(24)
				btn:SetText("")
				btn.printname = filename

				btn.Paint = function(self, w, h)
					local hovered = self:IsHovered()

					local default = Color(
						GetConVar("uvmenu_col_button_r"):GetInt(),
						GetConVar("uvmenu_col_button_g"):GetInt(),
						GetConVar("uvmenu_col_button_b"):GetInt(),
						GetConVar("uvmenu_col_button_a"):GetInt()
					)

					local hover = Color(
						GetConVar("uvmenu_col_button_hover_r"):GetInt(),
						GetConVar("uvmenu_col_button_hover_g"):GetInt(),
						GetConVar("uvmenu_col_button_hover_b"):GetInt(),
						GetConVar("uvmenu_col_button_hover_a"):GetInt()
							* math.abs(math.sin(RealTime() * 4))
					)

					draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, default)
					if hovered then
						draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, hover)
					end

					if selecteditem == filename then
						draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, Color(0, 138, 28))
					end

					draw.SimpleTextOutlined(filename, "UVSettingsFontSmall", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.25, color_black)
				end

				btn.DoClick = function()
					selecteditem = filename
					SetClipboardText(filename)

					net.Start("UVDriverModelManagerRetrieve")
					net.WriteString(filename)
					net.SendToServer()
				end
			end
		end

		timer.Simple(0, RefreshDriverModelList)

		hook.Add( "UVContentEvent", "UVDriverModelManagerTool_OnContentUpdate", function( operation, path, fileName )
			if path == "drivermodels" then
				RefreshDriverModelList()
			end
		end )

		local Refresh = vgui.Create( "DButton", CPanel )
		Refresh:SetText( "#refresh" )
		Refresh:SetSize( 280, 20 )
		Refresh.DoClick = function( self )
			RefreshDriverModelList()
			notification.AddLegacy( "#uv.tool.loaded.all", NOTIFY_UNDO, 5 )
			surface.PlaySound( "buttons/button15.wav" )
		end
		CPanel:AddItem(Refresh)
		
		local Delete = vgui.Create( "DButton", CPanel )
		Delete:SetText( "#spawnmenu.menu.delete" )
		Delete:SetSize( 280, 20 )
		Delete.DoClick = function( self )
			
			if isstring(selecteditem) then
				net.Start("UVDriverModelManagerDeleteFile")
				net.WriteString("drivermodels")
				net.WriteString(selecteditem)
				net.SendToServer()
				notification.AddLegacy( string.format( language.GetPhrase("uv.tool.deleted"), selecteditem ), NOTIFY_UNDO, 5 )
				surface.PlaySound( "buttons/button15.wav" )

				selecteditem = nil
			end
		end
		CPanel:AddItem(Delete)
		
		CPanel:AddControl("Label", { Text = "" }) -- General Settings
		CPanel:AddControl("Label", { Text = "#uv.tweakinmenu" })
		local OpenMenu = vgui.Create("DButton")
		OpenMenu:SetText("#uv.tweakinmenu.open")
		OpenMenu:SetSize(280, 20)
		OpenMenu.DoClick = function()
			UVMenu.OpenMenu(UVMenu.Settings)
			UVMenu.PlaySFX("menuopen")
		end
		CPanel:AddItem(OpenMenu)

	end

end

function TOOL:RightClick(trace)
    if CLIENT then return true end
	
	local ent = trace.Entity
	local ply = self:GetOwner()
		
	if not istable(ply.UVDMTOOLMemory) then 
		ply.UVDMTOOLMemory = {}
	end
	
	if ent:GetClass() ~= "prop_ragdoll" and not ent:IsNPC() and not ent:IsPlayer() then return false end
	
	self:GetDriverModelData( ent, ply, trace.HitPos )

	net.Start("UVDriverModelManagerAdjust")
	net.Send(ply)
	
	return true
end

function TOOL:LeftClick( trace )
	if CLIENT then return true end

	local ply = self:GetOwner()
	local tr = ply:GetEyeTrace()
	local ANGZ = ply:EyeAngles()

	if not istable(ply.UVDMTOOLMemory) then
		ply:PrintMessage( HUD_PRINTTALK, "Select a model or make one" )
		return 
	end

    local prop = ents.Create("prop_ragdoll")
	prop:SetModel(ply.UVDMTOOLMemory.ModelName or "models/player/kleiner.mdl")
    prop:SetPos(tr.HitPos + vector_up * 10)
	prop:SetAngles(Angle(-90, ANGZ.y, 180))
	prop:Spawn()
	prop:Activate()

	if ply.UVDMTOOLMemory.Bodygroups and not ply.UVDMTOOLMemory.RandomizeBodygroups then
		for index, value in pairs(ply.UVDMTOOLMemory.Bodygroups) do
		    prop:SetBodygroup(index, value)
		end
	else
		for k = 0, prop:GetNumBodyGroups() do
			prop:SetBodygroup( k, math.random( 0, prop:GetBodygroupCount( k ) - 1 ) )
		end
	end

	if ply.UVDMTOOLMemory.Skin and not ply.UVDMTOOLMemory.RandomizeSkin then
		prop:SetSkin(ply.UVDMTOOLMemory.Skin)
	else
		local totalSkins = prop:SkinCount()
    	if totalSkins > 0 then
    	    prop:SetSkin(math.random(0, totalSkins - 1))
    	end
	end

	local color = (ply.UVDMTOOLMemory.RandomizeColor and Color(math.random(0, 255), math.random(0, 255), math.random(0, 255))) 
	or (ply.UVDMTOOLMemory.Color and Color(ply.UVDMTOOLMemory.Color.r, ply.UVDMTOOLMemory.Color.g, ply.UVDMTOOLMemory.Color.b))
	or color_white

	net.Start("UVHUDAddUV")
		net.WriteInt(prop:EntIndex(), 32)
		net.WriteInt(prop:GetCreationID(), 32)
		net.WriteString("drivermodel")
		net.WriteColor(color)
	net.Broadcast()

	undo.Create("#uv.drivermodel")
	 	undo.AddEntity(prop)
	 	undo.SetPlayer(ply)
	undo.Finish()
		
	return true
end

function TOOL:GetDriverModelData( ent, ply, location )
	if not IsValid(ent) then return end
	if not istable(ply.UVDMTOOLMemory) then ply.UVDMTOOLMemory = {} end

	local modelname = ent:GetModel()
	ply.UVDMTOOLMemory["ModelName"] = modelname

    local bodygroupTable = {}
	local bgCount = ent:GetNumBodyGroups()
	
	for i = 0, bgCount - 1 do
	    bodygroupTable[i] = ent:GetBodygroup(i)
	end
    ply.UVDMTOOLMemory["Bodygroups"] = bodygroupTable

	local skin = ent:GetSkin()
	ply.UVDMTOOLMemory["Skin"] = skin

	--PlayerColor is retreived from the client side

	if not IsValid( ply ) then return end

	local clientdmtoolmemory = {}

	clientdmtoolmemory["ModelName"] = modelname

	local sequenceName = "drive_jeep"
	local sequenceID = ent:LookupSequence(sequenceName)

	if sequenceID == -1 then
	    clientdmtoolmemory["NoDriveSequence"] = true
	end
	
	net.Start("UVDriverModelManagerRetrieve")
		net.WriteTable( clientdmtoolmemory )
		net.WriteInt( ent:EntIndex(), 32 )
		net.WriteInt( ent:GetCreationID(), 32 )
	net.Send( ply )

end
