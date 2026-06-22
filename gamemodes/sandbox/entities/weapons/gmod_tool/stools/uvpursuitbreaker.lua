TOOL.Category		=	"uv.unitvehicles"
TOOL.Name			=	"#tool.uvpursuitbreaker.name"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

TOOL.ClientConVar["maxpb"] = 2
TOOL.ClientConVar["spawncondition"] = 2
TOOL.ClientConVar["pbcooldown"] = 60

local conVarsDefault = TOOL:BuildConVarList()

if SERVER then

	net.Receive("UVPursuitBreakerRetrieve", function( length, ply )
		ply.UVPBTOOLMemory = net.ReadTable()
		ply:SelectWeapon( "gmod_tool" )
	end)

	net.Receive("UVPursuitBreakerDeleteFile", function( length, ply )
		if ply and not ply:IsSuperAdmin() then return end

		local path = net.ReadString()
		local fileName = net.ReadString()

		local file = UV_GetFile(path, fileName)
		if not file then return end

		if not UV_IsWorkshop( path, fileName ) then
			UV_RemoveFile( path, fileName )
		end
	end)

	net.Receive("UVPursuitBreakerMarkAll", function( length, ply )
		if ply and not ply:IsSuperAdmin() then return end

		local savedPursuitBreakers = UV_GetFiles( "pursuitbreakers>>"..game.GetMap() )
		local pbs = {}

		for k,v in pairs(savedPursuitBreakers) do
			local json = UV_LoadFile( "pursuitbreakers>>"..game.GetMap(), v )
			local pbdata = util.JSONToTable(json, true)
	
			if pbdata then
				table.insert( pbs, {
					name = v,
					location = pbdata.Location or pbdata.Maxs,
				} )
			end
		end

		local compressedPbs = util.Compress( util.TableToJSON(pbs) )

		net.Start("UVPursuitBreakerMarkAllResponse")
		net.WriteUInt( #compressedPbs, 16 )
		net.WriteData( compressedPbs, #compressedPbs )
		net.Send(ply)
	end)

	net.Receive("UVPursuitBreakerCreate", function( length, ply )
		if next(ply.UVPBTOOLMemory) == nil then return end

		local name = net.ReadString()
		local duration = net.ReadInt(32)
		local dontunweld = net.ReadBool()
		local disableactioncam = net.ReadBool()

		local keyduration = "ActiveDuration"
		local keydontunweld = "DontUnweldProps"
		local keydisableactioncam = "DisableActionCam"

		ply.UVPBTOOLMemory[keyduration] = duration
		ply.UVPBTOOLMemory[keydontunweld] = dontunweld
		ply.UVPBTOOLMemory[keydisableactioncam] = disableactioncam

		local jsondata = util.TableToJSON(ply.UVPBTOOLMemory)
		file.Write("unitvehicles/pursuitbreakers/"..game.GetMap().."/"..name..".json", jsondata)
		UV_AddFile( "pursuitbreakers>>"..game.GetMap(), name .. ".json", "unitvehicles/pursuitbreakers/"..game.GetMap().."/", "DATA" )
		PrintMessage( HUD_PRINTTALK, "Pursuit Breaker "..name.." has been created for "..game.GetMap().."!" )
		net.Start("UVPursuitBreakerRefresh")
		net.Send(ply)

		UVPreloadPursuitBreakers()

	end)

	net.Receive("UVPursuitBreakerLoad", function( length, ply )
		local id = net.ReadInt(32)
		UVSpawnPursuitBreaker(id)
	end)
	
	net.Receive("UVPursuitBreakerLoadAll", function( length, ply )
		--Load ALL Pursuit Breakers
		local pursuitbreakers = UV_GetFiles( "pursuitbreakers>>"..game.GetMap() )
		for k,v in pairs(pursuitbreakers) do
			UVSpawnPursuitBreaker(v)
		end
	end)

end

if CLIENT then

	TOOL.Information = {
		{ name = "info"},
		{ name = "right" },
	}

	-- language.Add("tool.uvpursuitbreaker.name", "Pursuit Breakers")
	-- language.Add("tool.uvpursuitbreaker.desc", "Create and manage your Pursuit Breakers for this map! Crash into them to take out Unit Vehicles!")
	-- language.Add("tool.uvpursuitbreaker.0", "Build a structure anywhere on this map (or use a dupe if you are lazy, make sure the props are welded together)! When done, right-click it!" )
	-- language.Add("tool.uvpursuitbreaker.left", "Spawns ALL saved pursuit breakers for this map (mind the lag if you have many!)" )
	-- language.Add("tool.uvpursuitbreaker.right", "Saves the structure as a pursuit breaker for this map. The Pursuit Breaker icon created is where you right-click it" )

	local selecteditem	= nil
	local UVPBTOOLMemory = {}
	
	net.Receive("UVPursuitBreakerRetrieve", function( length )
		UVPBTOOLMemory = net.ReadTable()
	end)

	net.Receive("UVPursuitBreakerMarkAllResponse", function( length )
		local bytes = net.ReadUInt( 16 )
		local data = net.ReadData( bytes )
		local pbs = util.JSONToTable( util.Decompress( data ) )
		UVMarkAllLocationsPB(pbs)
	end)

	net.Receive("UVPursuitBreakerAdjust", function()
		local PursuitBreakerAdjust = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")

		PursuitBreakerAdjust:Add(OK)
		PursuitBreakerAdjust:SetSize(400, 240)
		PursuitBreakerAdjust:SetBackgroundBlur(true)
		PursuitBreakerAdjust:Center()
		PursuitBreakerAdjust:SetTitle("#tool.uvpursuitbreaker.name")
		PursuitBreakerAdjust:SetDraggable(false)
		PursuitBreakerAdjust:MakePopup()

		local Intro = vgui.Create( "DLabel", PursuitBreakerAdjust )
		Intro:SetPos( 20, 25 )
		Intro:SetText( string.format( language.GetPhrase("tool.uvpursuitbreaker.create.desc"), UVPBTOOLMemory.PropCount, UVPBTOOLMemory.ConstraintCount ) )
		Intro:SizeToContents()

		local PursuitBreakerNameEntry = vgui.Create( "DTextEntry", PursuitBreakerAdjust )
		PursuitBreakerNameEntry:SetPos( 20, 80 )
		PursuitBreakerNameEntry:SetPlaceholderText( "#tool.uvpursuitbreaker.create.name" )
		PursuitBreakerNameEntry:SetSize(PursuitBreakerAdjust:GetWide() / 2, 22)

		local ActiveDuration = vgui.Create( "DNumSlider", PursuitBreakerAdjust )
		ActiveDuration:SetPos( 20, 120 )
		ActiveDuration:SetSize( PursuitBreakerAdjust:GetWide(), 22 )
		ActiveDuration:SetText( "#tool.uvpursuitbreaker.create.duration" )
		ActiveDuration:SetMin( 1 )
		ActiveDuration:SetMax( 60 )
		ActiveDuration:SetDecimals( 0 )
		ActiveDuration:SetValue( 10 )
		ActiveDuration:SetTooltip( "#tool.uvpursuitbreaker.create.duration.desc" )

		local DontUnweldProps = vgui.Create( "DCheckBoxLabel", PursuitBreakerAdjust )
		DontUnweldProps:SetPos( 20, 160 )
		DontUnweldProps:SetText( "#tool.uvpursuitbreaker.create.keepweld" )
		DontUnweldProps:SetValue( 0 )
		DontUnweldProps:SetTooltip( "#tool.uvpursuitbreaker.create.keepweld.desc" )

		local DisableActionCam = vgui.Create( "DCheckBoxLabel", PursuitBreakerAdjust )
		DisableActionCam:SetPos( 20, 180 )
		DisableActionCam:SetText( "#tool.uvpursuitbreaker.create.disableactioncam" )
		DisableActionCam:SetValue( 0 )
		DisableActionCam:SetTooltip( "#tool.uvpursuitbreaker.create.disableactioncam.desc" )

		OK:SetText("#uv.tool.create")
		OK:SetSize(PursuitBreakerAdjust:GetWide() * 5 / 16, 22)
		OK:Dock(BOTTOM)

		function OK:DoClick()

			local Name = PursuitBreakerNameEntry:GetValue()
					
			if Name ~= "" then

				net.Start("UVPursuitBreakerCreate")
				net.WriteString(Name)
				net.WriteInt(ActiveDuration:GetValue(), 32)
				net.WriteBool(DontUnweldProps:GetChecked())
				net.WriteBool(DisableActionCam:GetChecked())
				net.SendToServer() --Create Pursuit Breaker
				
				UVPursuitBreakerScrollPanel:Clear() 
				if RefreshPursuitBreakerList then RefreshPursuitBreakerList() end
				PursuitBreakerAdjust:Close()
				surface.PlaySound( "buttons/button15.wav" )

			else
				PursuitBreakerNameEntry:SetPlaceholderText( "#uv.tool.fillme" )
				surface.PlaySound( "buttons/button10.wav" )
			end
			
		end
	end)

	net.Receive("UVPursuitBreakerRefresh", function( length )
		UVPursuitBreakerScrollPanel:Clear()
		if RefreshPursuitBreakerList then RefreshPursuitBreakerList() end
	end)

	function TOOL.BuildCPanel(CPanel)
		local lang = language.GetPhrase
		
		if not file.Exists( "unitvehicles/pursuitbreakers/"..game.GetMap(), "DATA" ) then
			file.CreateDir( "unitvehicles/pursuitbreakers/"..game.GetMap() )
			print("Created a Pursuit Breaker data file for "..game.GetMap().."!")
		end

		CPanel:AddControl("Label", {
			Text = "#tool.uvpursuitbreaker.settings.desc",
		})

		local selecteditem = nil

		local Frame = vgui.Create("DPanel")
		Frame:SetTall(320)
		Frame.Paint = function(self, w, h)
			draw.RoundedBox(5, 0, 0, w, h, Color(115,115,115,200))
			draw.RoundedBox(5, 1, 1, w-2, h-2, Color(0,0,0,200))
		end
		CPanel:AddItem(Frame)

		UVPursuitBreakerScrollPanel = vgui.Create("DScrollPanel", Frame)
		UVPursuitBreakerScrollPanel:Dock(FILL)
		UVPursuitBreakerScrollPanel:DockMargin(4, 4, 4, 4)

		local function RefreshPursuitBreakerList()
			UVPursuitBreakerScrollPanel:Clear()
			selecteditem = nil

			local files = UV_GetFiles( "pursuitbreakers>>"..game.GetMap() )

			if #files == 0 then
				local empty = vgui.Create("DLabel", UVPursuitBreakerScrollPanel)
				empty:SetText("#uv.tool.nopb")
				empty:SetTextColor(Color(200,200,200))
				empty:SetContentAlignment(5)
				empty:Dock(TOP)
				empty:SetTall(24)
				return
			end

			for id, filename in ipairs(files) do
				local btn = UVPursuitBreakerScrollPanel:Add("DButton")
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

					net.Start("UVPursuitBreakerLoad")
					net.WriteInt(id, 32)
					net.SendToServer()
				end
			end
		end

		timer.Simple(0, RefreshPursuitBreakerList)

		hook.Add( "UVContentEvent", "UVPursuitBreakerTool_OnContentUpdate", function( operation, path, fileName )
			if path == "pursuitbreakers>>"..game.GetMap() then
				RefreshPursuitBreakerList()
			end
		end )
		
		local MarkAll = vgui.Create( "DButton", CPanel )
		MarkAll:SetText( "#tool.uvpursuitbreaker.markall" )
		MarkAll:SetSize( 280, 20 )
		MarkAll.DoClick = function( self )
			net.Start("UVPursuitBreakerMarkAll")
			net.SendToServer()
			notification.AddLegacy( "#tool.uvpursuitbreaker.markedall", NOTIFY_UNDO, 10 )
			surface.PlaySound( "buttons/button15.wav" )
		end
		CPanel:AddItem(MarkAll)

		-- local LoadAll = vgui.Create( "DButton", CPanel )
		-- LoadAll:SetText( "#tool.uvpursuitbreaker.load.all" )
		-- LoadAll:SetSize( 280, 20 )
		-- LoadAll.DoClick = function( self )
			-- if not LocalPlayer():IsSuperAdmin() then
				-- notification.AddLegacy( "#uv.superadmin", NOTIFY_ERROR, 5 )
				-- surface.PlaySound( "buttons/button10.wav" )
					
				-- net.Start("UVPursuitBreakerLoadAll")
				-- net.SendToServer()
				-- notification.AddLegacy( "#tool.uvpursuitbreaker.loaded.all", NOTIFY_UNDO, 5 )
				-- surface.PlaySound( "buttons/button15.wav" )
			-- end
		-- end
		-- CPanel:AddItem(LoadAll)

		local Refresh = vgui.Create( "DButton", CPanel )
		Refresh:SetText( "#refresh" )
		Refresh:SetSize( 280, 20 )
		Refresh.DoClick = function( self )
			RefreshPursuitBreakerList()
			notification.AddLegacy( "#uv.tool.loaded.all", NOTIFY_UNDO, 5 )
			surface.PlaySound( "buttons/button15.wav" )
		end
		CPanel:AddItem(Refresh)
		
		local Delete = vgui.Create( "DButton", CPanel )
		Delete:SetText( "#spawnmenu.menu.delete" )
		Delete:SetSize( 280, 20 )
		Delete.DoClick = function( self )
			
			if isstring(selecteditem) then
				net.Start("UVPursuitBreakerDeleteFile")
				net.WriteString("pursuitbreakers>>"..game.GetMap())
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
		
	if not istable(ply.UVPBTOOLMemory) then 
		ply.UVPBTOOLMemory = {}
	end
	
	if ent:GetClass() ~= "prop_physics" then return false end
	
	self:GetPursuitBreakerData( ent, ply, trace.HitPos )

	net.Start("UVPursuitBreakerAdjust")
	net.Send(ply)
	
	return true
end

function TOOL:LeftClick( trace )
	if CLIENT then return true end
		--:thinking:
	return true
end

function TOOL:GetPursuitBreakerData( ent, ply, location )
	if not IsValid(ent) then return end
	if not istable(ply.UVPBTOOLMemory) then ply.UVPBTOOLMemory = {} end

	ply.UVPBTOOLMemory = duplicator.Copy( ent )

	local Key = "Location"
	ply.UVPBTOOLMemory[Key] = location

	if not IsValid( ply ) then return end

	local clientpbtoolmemory = {
		PropCount = table.Count(ply.UVPBTOOLMemory.Entities),
		ConstraintCount = table.Count(ply.UVPBTOOLMemory.Constraints),
		VectorsMins = Vector(ply.UVPBTOOLMemory.Mins),
		VectorsMaxs = Vector(ply.UVPBTOOLMemory.Maxs),
	}
	
	net.Start("UVPursuitBreakerRetrieve")
	net.WriteTable( clientpbtoolmemory )
	net.Send( ply )

end
