TOOL.Category		=	"uv.unitvehicles"
TOOL.Name			=	"#tool.uvrepairshop.name"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

TOOL.ClientConVar["maxrs"] = 1
TOOL.ClientConVar["spawncondition"] = 2

local conVarsDefault = TOOL:BuildConVarList()

if SERVER then

	net.Receive("UVRepairShopRetrieve", function( length, ply )
		ply.UVRSTOOLMemory = net.ReadTable()
		ply:SelectWeapon( "gmod_tool" )
	end)

	net.Receive("UVRepairShopMarkAll", function( length, ply )
		if ply and not ply:IsSuperAdmin() then return end

		local savedRepairShops = UV_GetFiles( "repairshops>>"..game.GetMap() )
		local rss = {}

		for k,v in pairs(savedRepairShops) do
			local json = UV_LoadFile( "repairshops>>"..game.GetMap(), v )
			local rsdata = util.JSONToTable(json, true)

			if rsdata then
				table.insert( rss, {
					name = v,
					location = rsdata.Location or rsdata.Maxs,
				} )
			end
		end

		local compressedRss = util.Compress( util.TableToJSON(rss) )

		net.Start("UVRepairShopMarkAllResponse")
		net.WriteUInt( #compressedRss, 16 )
		net.WriteData( compressedRss, #compressedRss )
		net.Send(ply)
	end)

	net.Receive("UVRepairShopDeleteFile", function( length, ply )
		if ply and not ply:IsSuperAdmin() then return end

		local path = net.ReadString()
		local fileName = net.ReadString()

		local file = UV_GetFile(path, fileName)
		if not file then return end

		if not UV_IsWorkshop( path, fileName ) then
			UV_RemoveFile( path, fileName )
		end
	end)

	net.Receive("UVRepairShopCreate", function( length, ply )
		if next(ply.UVRSTOOLMemory) == nil then return end

		local name = net.ReadString()

		local jsondata = util.TableToJSON(ply.UVRSTOOLMemory)
		file.Write("unitvehicles/repairshops/"..game.GetMap().."/"..name..".json", jsondata)
		UV_AddFile( "repairshops>>"..game.GetMap(), name .. ".json", "unitvehicles/repairshops/"..game.GetMap().."/", "DATA" )

		PrintMessage( HUD_PRINTTALK, "Repair Shop "..name.." has been created for "..game.GetMap().."!" )
		net.Start("UVRepairShopRefresh")
		net.Send(ply)

	end)

	net.Receive("UVRepairShopLoad", function( length, ply )
		local jsonfile = net.ReadString()
		UVLoadRepairShop(jsonfile)
	end)
	
	net.Receive("UVRepairShopLoadAll", function( length, ply )
		--Load ALL Repair Shops
		local repairshops = UV_GetFiles( "repairshops>>"..game.GetMap() )
		for k,v in pairs(repairshops) do
			UVLoadRepairShop(v)
		end
	end)

end

if CLIENT then

	TOOL.Information = {
		{ name = "info"},
		{ name = "left" },
		{ name = "right" },
	}

	local selecteditem	= nil
	local UVRSTOOLMemory = {}
	
	net.Receive("UVRepairShopRetrieve", function( length )
		UVRSTOOLMemory = net.ReadTable()
	end)

	net.Receive("UVRepairShopMarkAllResponse", function( length )
		local bytes = net.ReadUInt( 16 )
		local data = net.ReadData( bytes )
		local rss = util.JSONToTable( util.Decompress( data ) )
		UVMarkAllLocationsRS(rss)
	end)

	net.Receive("UVRepairShopAdjust", function()
		local RepairShopAdjust = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")

		RepairShopAdjust:Add(OK)
		RepairShopAdjust:SetSize(400, 220)
		RepairShopAdjust:SetBackgroundBlur(true)
		RepairShopAdjust:Center()
		RepairShopAdjust:SetTitle("#tool.uvrepairshop.name")
		RepairShopAdjust:SetDraggable(false)
		RepairShopAdjust:MakePopup()

		local Intro = vgui.Create( "DLabel", RepairShopAdjust )
		Intro:SetPos( 20, 25 )
		Intro:SetText( string.format( language.GetPhrase("tool.uvrepairshop.create.desc"), UVRSTOOLMemory.PropCount, UVRSTOOLMemory.ConstraintCount ) )
		Intro:SizeToContents()

		local RepairShopNameEntry = vgui.Create( "DTextEntry", RepairShopAdjust )
		RepairShopNameEntry:SetPos( 20, 80 )
		RepairShopNameEntry:SetPlaceholderText( "#tool.uvrepairshop.create.name" )
		RepairShopNameEntry:SetSize(RepairShopAdjust:GetWide() / 2, 22)

		OK:SetText("#uv.tool.create")
		OK:SetSize(RepairShopAdjust:GetWide() * 5 / 16, 22)
		OK:Dock(BOTTOM)

		function OK:DoClick()

			local Name = RepairShopNameEntry:GetValue()
					
			if Name ~= "" then

				net.Start("UVRepairShopCreate")
				net.WriteString(Name)
				net.SendToServer() --Create Repair Shop
				
				RepairShopAdjust:Close()
				surface.PlaySound( "buttons/button15.wav" )

			else
				RepairShopNameEntry:SetPlaceholderText( "#uv.tool.fillme" )
				surface.PlaySound( "buttons/button10.wav" )
			end
			
		end
	end)

	net.Receive("UVRepairShopRefresh", function( length )
		UVRepairShopScrollPanel:Clear()
		if RefreshRepairShopList then RefreshRepairShopList() end
	end)

	function TOOL.BuildCPanel(CPanel)
		local lang = language.GetPhrase
		
		if not file.Exists( "unitvehicles/repairshops/"..game.GetMap(), "DATA" ) then
			file.CreateDir( "unitvehicles/repairshops/"..game.GetMap() )
			print("Created a Repair Shop data file for "..game.GetMap().."!")
		end

		CPanel:AddControl("Label", {
			Text = "#tool.uvrepairshop.settings.desc",
		})

		local selecteditem = nil

		local Frame = vgui.Create("DPanel")
		Frame:SetTall(320)
		Frame.Paint = function(self, w, h)
			draw.RoundedBox(5, 0, 0, w, h, Color(115,115,115,200))
			draw.RoundedBox(5, 1, 1, w-2, h-2, Color(0,0,0,200))
		end
		CPanel:AddItem(Frame)

		UVRepairShopScrollPanel = vgui.Create("DScrollPanel", Frame)
		UVRepairShopScrollPanel:Dock(FILL)
		UVRepairShopScrollPanel:DockMargin(4, 4, 4, 4)

		local function RefreshRepairShopList()
			UVRepairShopScrollPanel:Clear()
			selecteditem = nil

			local files = UV_GetFiles( "repairshops>>"..game.GetMap() )

			if #files == 0 then
				local empty = vgui.Create("DLabel", UVRepairShopScrollPanel)
				empty:SetText("#uv.tool.nors")
				empty:SetTextColor(Color(200,200,200))
				empty:SetContentAlignment(5)
				empty:Dock(TOP)
				empty:SetTall(24)
				return
			end

			for _, filename in ipairs(files) do
				local btn = UVRepairShopScrollPanel:Add("DButton")
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

					UVDrawCursorText(self, filename, "UVSettingsFontSmall", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.25, color_black, w * 0.05, w * 0.95)
				end

				btn.DoClick = function()
					selecteditem = filename
					SetClipboardText(filename)

					net.Start("UVRepairShopLoad")
					net.WriteString(filename)
					net.SendToServer()
				end
			end
		end

		timer.Simple(0, RefreshRepairShopList)

		hook.Add( "UVContentEvent", "UVRepairShopTool_OnContentUpdate", function( operation, path, fileName )
			if path == "repairshops>>"..game.GetMap() then
				RefreshRepairShopList()
			end
		end )
		
		local MarkAll = vgui.Create( "DButton", CPanel )
		MarkAll:SetText( "#tool.uvrepairshop.markall" )
		MarkAll:SetSize( 280, 20 )
		MarkAll.DoClick = function( self )
			net.Start("UVRepairShopMarkAll")
			net.SendToServer()
			notification.AddLegacy( "#tool.uvrepairshop.markedall", NOTIFY_UNDO, 10 )
			surface.PlaySound( "buttons/button15.wav" )
		end
		CPanel:AddItem(MarkAll)

		local Refresh = vgui.Create( "DButton", CPanel )
		Refresh:SetText( "#refresh" )
		Refresh:SetSize( 280, 20 )
		Refresh.DoClick = function( self )
			RefreshRepairShopList()
			notification.AddLegacy( "#uv.tool.loaded.all", NOTIFY_UNDO, 5 )
			surface.PlaySound( "buttons/button15.wav" )
		end
		CPanel:AddItem(Refresh)
		
		local Delete = vgui.Create( "DButton", CPanel )
		Delete:SetText( "#spawnmenu.menu.delete" )
		Delete:SetSize( 280, 20 )
		Delete.DoClick = function( self )
			
			if isstring(selecteditem) then
				net.Start("UVRepairShopDeleteFile")
				net.WriteString("repairshops>>"..game.GetMap())
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
		
	if not istable(ply.UVRSTOOLMemory) then 
		ply.UVRSTOOLMemory = {}
	end
	
	if ent:GetClass() ~= "entity_uvrepairshop" then return false end
	
	self:GetRepairShopData( ent, ply, trace.HitPos )

	net.Start("UVRepairShopAdjust")
	net.Send(ply)
	
	return true
end

function TOOL:LeftClick( trace )
	if CLIENT then return true end

	local ply = self:GetOwner()
	local tr = ply:GetEyeTrace()
	local ANGZ = ply:EyeAngles()

    local prop = ents.Create("entity_uvrepairshop")
    prop:SetPos(tr.HitPos+Vector(0,0,1))
	prop:SetAngles(Angle(0,ANGZ.y+180,0))
	prop:Spawn()
	prop.PhysgunDisabled = false
	prop:GetPhysicsObject():EnableMotion(false)

	undo.Create("#uv.repairshop")
	 	undo.AddEntity(prop)
	 	undo.SetPlayer(ply)
	undo.Finish()
		
	return true
end

function TOOL:GetRepairShopData( ent, ply, location )
	if not IsValid(ent) then return end
	if not istable(ply.UVRSTOOLMemory) then ply.UVRSTOOLMemory = {} end

	ply.UVRSTOOLMemory = duplicator.Copy( ent )

	local Key = "Location"
	ply.UVRSTOOLMemory[Key] = location

	if not IsValid( ply ) then return end

	local clientrstoolmemory = {
		PropCount = table.Count(ply.UVRSTOOLMemory.Entities),
		ConstraintCount = table.Count(ply.UVRSTOOLMemory.Constraints),
		VectorsMins = Vector(ply.UVRSTOOLMemory.Mins),
		VectorsMaxs = Vector(ply.UVRSTOOLMemory.Maxs),
	}
	
	net.Start("UVRepairShopRetrieve")
	net.WriteTable( clientrstoolmemory )
	net.Send( ply )

end
