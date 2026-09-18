TOOL.Category		=	"uv.unitvehicles"
TOOL.Name			=	"#tool.uvracermanager.name"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

TOOL.ClientConVar["vehiclebase"] = 1
TOOL.ClientConVar["assignracers"] = 0
TOOL.ClientConVar["racers"] = ""
TOOL.ClientConVar["spawncondition"] = 1
TOOL.ClientConVar["maxracer"] = 3

local conVarsDefault = TOOL:BuildConVarList()

UVRacerManagerTool = UVRacerManagerTool or {}

local vehicleBases = {
	{ id = 1, name = "HL2",      path = "prop_vehicle_jeep>>racers", type = "txt"  },
	{ id = 2, name = "Simfphys", path = "simfphys>>racers",           type = "txt"  },
	{ id = 3, name = "Glide",    path = "glide>>racers",               type = "json" },
	{ id = 4, name = "LVS",      path = "lvs>>racers",               type = "json" },
}

if SERVER then
	
	net.Receive("UVRacerManagerGetRacerInfo", function( length, ply )
		local filename = net.ReadString()
		local vehicleBase = net.ReadUInt(3)

		local vehicleBaseData = vehicleBases[vehicleBase]
		if not vehicleBaseData then return end

		local data = UV_LoadFile(vehicleBaseData.path, filename)
		if not data then return end

		ply.UVRacerTOOLMemory = {}

		if vehicleBaseData.type == "json" then
			ply.UVRacerTOOLMemory = util.JSONToTable(
				data, true
			)
		else
			local DataString = data
			local words, decoded = string.Explode("", DataString), {}

			for k, v in pairs(words) do
				decoded[k] = string.char(string.byte(v) - 20)
			end

			local Data = string.Explode("#", string.Implode("", decoded))
			table.Empty(ply.UVRacerTOOLMemory)

			for _, v in pairs(Data) do
				local Var = string.Explode("=", v)
				local name, variable = Var[1], Var[2]

				if name and variable then
					if name == "SubMaterials" then
						ply.UVRacerTOOLMemory[name] = {}
						local submats = string.Explode(",", variable)
						for i = 0, table.Count(submats) - 1 do
							ply.UVRacerTOOLMemory[name][i] = submats[i + 1]
						end
					else
						ply.UVRacerTOOLMemory[name] = variable
					end
				end
			end
		end

		ply:SelectWeapon( "gmod_tool" )
	end)

	local function SaveVehicle(ply, filename, canSaveColor)
		if next(ply.UVRacerTOOLMemory) == nil then return end
		
		local Name = filename
		local Color = canSaveColor

		if Name == "" then return end
		
		if Color then
			ply.UVRacerTOOLMemory.SaveColor = true
		end
		
		local vehicleBase = ply.UVRacerTOOLMemory.VehicleBase
		if vehicleBase == "gmod_sent_vehicle_fphysics_base" then
			local DataString = ""
			
			for k,v in pairs(ply.UVRacerTOOLMemory) do
				if k == "SubMaterials" then
					local mats = ""
					local first = true
					for k, v in pairs( v ) do
						if first then
							first = false
							mats = mats..v
						else
							mats = mats..","..v
						end
					end
					DataString = DataString..k.."="..mats.."#"
				else
					DataString = DataString..k.."="..tostring( v ).."#"
				end
			end
			
			local words = string.Explode( "", DataString )
			local shit = {}
			
			for k, v in pairs( words ) do
				shit[k] =  string.char( string.byte( v ) + 20 )
			end
			
			file.Write("unitvehicles/simfphys/racers/"..Name..".txt", string.Implode("",shit) )
			UV_AddFile( "simfphys>>racers", Name .. ".txt", "unitvehicles/simfphys/racers/", "DATA" )
		elseif vehicleBase == "base_glide_car" or vehicleBase == "base_glide_motorcycle" then
			local jsondata = util.TableToJSON(ply.UVRacerTOOLMemory)
			file.Write("unitvehicles/glide/racers/"..Name..".json", jsondata )
			UV_AddFile( "glide>>racers", Name .. ".json", "unitvehicles/glide/racers/", "DATA" )
		elseif vehicleBase == "prop_vehicle_jeep" then
			local DataString = ""
			
			for k,v in pairs(ply.UVRacerTOOLMemory) do
				if k == "SubMaterials" then
					local mats = ""
					local first = true
					for k, v in pairs( v ) do
						if first then
							first = false
							mats = mats..v
						else
							mats = mats..","..v
						end
					end
					DataString = DataString..k.."="..mats.."#"
				else
					DataString = DataString..k.."="..tostring( v ).."#"
				end
			end
			
			local words = string.Explode( "", DataString )
			local shit = {}
			
			for k, v in pairs( words ) do
				shit[k] =  string.char( string.byte( v ) + 20 )
			end
			
			file.Write("unitvehicles/prop_vehicle_jeep/racers/"..Name..".txt", string.Implode("",shit) )
			UV_AddFile( "prop_vehicle_jeep>>racers", Name .. ".txt", "unitvehicles/prop_vehicle_jeep/racers/", "DATA" )
		elseif vehicleBase == "LVS" then
			local jsondata = util.TableToJSON(ply.UVRacerTOOLMemory)
			file.Write("unitvehicles/lvs/racers/"..Name..".json", jsondata )
			UV_AddFile( "lvs>>racers", Name .. ".json", "unitvehicles/lvs/racers/", "DATA" )
		end
	end

	net.Receive("UVRacerManagerSaveRacer", function( length, ply )
		if ply and not ply:IsSuperAdmin() then return end
		if next(ply.UVRacerTOOLMemory) == nil then return end

		local filename = net.ReadString()
		local canSaveColor = net.ReadBool()

		SaveVehicle(ply, filename, canSaveColor)
	end)


	net.Receive("UVRacerManagerDeleteFile", function( length, ply )
		if ply and not ply:IsSuperAdmin() then return end

		local path = net.ReadString()
		local fileName = net.ReadString()

		local file = UV_GetFile(path, fileName)
		if not file then return end

		if not UV_IsWorkshop( path, fileName ) then
			UV_RemoveFile( path, fileName )
		end
	end)
			
	if not file.Exists( "unitvehicles/glide/racers", "DATA" ) then
		file.CreateDir( "unitvehicles/glide/racers" )
		print("Created a Glide data file for the Racer Vehicles!")
	end
	
	if not file.Exists( "unitvehicles/simfphys/racers", "DATA" ) then
		file.CreateDir( "unitvehicles/simfphys/racers" )
		print("Created a simfphys data file for the Racer Vehicles!")
	end
	
	if not file.Exists( "unitvehicles/prop_vehicle_jeep/racers", "DATA" ) then
		file.CreateDir( "unitvehicles/prop_vehicle_jeep/racers" )
		print("Created a Default Vehicle Base data file for the Racer Vehicles!")
	end

	if not file.Exists( "unitvehicles/lvs/racers", "DATA" ) then
		file.CreateDir( "unitvehicles/lvs/racers" )
		print("Created a LVS data file for the Racer Vehicles!")
	end

end

if CLIENT then
	
	TOOL.Information = {
		{ name = "info"},
		{ name = "left" },
		{ name = "right" },
	}
	
	local selecteditem = nil
	local UVRacerTOOLMemory = {}
	
	net.Receive("UVRacerManagerGetRacerInfo", function( length )
		UVRacerTOOLMemory = net.ReadTable()
		--PrintTable(UVRacerTOOLMemory)
	end)
	
	net.Receive("UVRacerManagerAdjustRacer", function()
		local RacerAdjust = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		local lang = language.GetPhrase
		
		RacerAdjust:Add(OK)
		RacerAdjust:SetSize(600, 300)
		RacerAdjust:SetBackgroundBlur(true)
		RacerAdjust:Center()
		RacerAdjust:SetTitle("#tool.uvracermanager.create")
		RacerAdjust:SetDraggable(false)
		RacerAdjust:MakePopup()
		
		local Intro = vgui.Create( "DLabel", RacerAdjust )
		Intro:SetPos( 20, 40 )
		Intro:SetText( string.format( lang("uv.tool.create.base"), UVRacerTOOLMemory.VehicleBase ) )
		Intro:SizeToContents()
		
		local Intro2 = vgui.Create( "DLabel", RacerAdjust )
		Intro2:SetPos( 20, 60 )
		Intro2:SetText( string.format( lang("uv.tool.create.rawname"), UVRacerTOOLMemory.SpawnName ) )
		Intro2:SizeToContents()
		
		local Intro3 = vgui.Create( "DLabel", RacerAdjust )
		Intro3:SetPos( 20, 100 )
		Intro3:SetText( "#uv.tool.create.uniquename" )
		Intro3:SizeToContents()
		
		local RacerNameEntry = vgui.Create( "DTextEntry", RacerAdjust )
		RacerNameEntry:SetPos( 20, 120 )
		RacerNameEntry:SetPlaceholderText( "#tool.uvracermanager.create.name" )
		RacerNameEntry:SetSize(RacerAdjust:GetWide() / 2, 22)
		
		local SaveColour = vgui.Create("DCheckBoxLabel", RacerAdjust )
		SaveColour:SetPos( 20, 160 )
		SaveColour:SetText("#uv.tool.savecol")
		SaveColour:SetSize(RacerAdjust:GetWide(), 22)
		
		OK:SetText("#uv.tool.create")
		OK:SetSize(RacerAdjust:GetWide() * 5 / 16, 22)
		OK:Dock(BOTTOM)
		
		function OK:DoClick()
			net.Start("UVRacerManagerSaveRacer")
			net.WriteString(RacerNameEntry:GetValue())
			net.WriteBool(SaveColour:GetChecked())
			net.SendToServer()

			RacerAdjust:Close()
			surface.PlaySound("buttons/button15.wav")
		end
	end)

	function TOOL.BuildCPanel(CPanel)
		local lang = language.GetPhrase

		local activeFilterBaseId = 0
		local selecteditem = nil

		CPanel:AddControl("Label", { Text = "#tool.uvracermanager.settings.desc" })

		local FilterBar = vgui.Create("DIconLayout")
		FilterBar:Dock(TOP)
		FilterBar:SetTall(60)
		FilterBar:SetSpaceX(4)
		FilterBar:SetSpaceY(4)
		CPanel:AddItem(FilterBar)
		FilterBar.Paint = function(self, w, h)
			draw.RoundedBox(5, 0, 0, w, h, Color(115,115,115,200))
			draw.RoundedBox(5, 1, 1, w-2, h-2, Color(0,0,0,200))
		end
		
		FilterBar.OnSizeChanged = function(self, w)
			local spacing = self:GetSpaceX()
			local children = self:GetChildren()

			for i, child in ipairs(children) do
				if not IsValid(child) then continue end

				if i == 1 then
					child:SetWide(w)
				else
					child:SetWide((w - spacing) / 2)
				end
			end
		end

		CPanel:AddItem(FilterBar)

		local function AddFilterButton(text, baseId)
			local btn = FilterBar:Add("DButton")
			btn:SetTall(24)
			btn:SetText(" ")

			btn.Paint = function(self, w, h)
				local selected = (activeFilterBaseId == baseId)
				local hovered  = self:IsHovered()

				local default = Color(
					GetConVar("uvmenu_col_button_r"):GetInt(),
					GetConVar("uvmenu_col_button_g"):GetInt(),
					GetConVar("uvmenu_col_button_b"):GetInt(),
					GetConVar("uvmenu_col_button_a"):GetInt()
				)

				local active = Color(
					GetConVar("uvmenu_col_bool_active_r"):GetInt(),
					GetConVar("uvmenu_col_bool_active_g"):GetInt(),
					GetConVar("uvmenu_col_bool_active_b"):GetInt(),
					GetConVar("uvmenu_col_button_a"):GetInt()
				)

				local hover = Color(
					GetConVar("uvmenu_col_button_hover_r"):GetInt(),
					GetConVar("uvmenu_col_button_hover_g"):GetInt(),
					GetConVar("uvmenu_col_button_hover_b"):GetInt(),
					GetConVar("uvmenu_col_button_hover_a"):GetInt()
						* math.abs(math.sin(RealTime() * 4))
				)

				draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, selected and active or default)
				if hovered then
					draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, hover)
				end

				draw.SimpleTextOutlined(text, "UVSettingsFontSmall", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.25, color_black)
			end

			btn.DoClick = function()
				activeFilterBaseId = baseId
				UVRacerManagerTool.RefreshList()
			end
		end

		AddFilterButton(UVString("all"), 0)
		AddFilterButton(UVString("uv.base.hl2"), 1)
		AddFilterButton(UVString("uv.base.simfphys"), 2)
		AddFilterButton(UVString("uv.base.glide"), 3)
		AddFilterButton(UVString("uv.base.lvs"), 4)

		local FrameListPanel = vgui.Create("DPanel")
		FrameListPanel:SetTall(220)
		FrameListPanel.Paint = function(self, w, h)
			draw.RoundedBox(5, 0, 0, w, h, Color(115,115,115,200))
			draw.RoundedBox(5, 1, 1, w-2, h-2, Color(0,0,0,200))
		end
		CPanel:AddItem(FrameListPanel)

		local ScrollPanel = vgui.Create("DScrollPanel", FrameListPanel)
		ScrollPanel:Dock(FILL)
		ScrollPanel:DockMargin(4, 4, 4, 4)

		UVRacerManagerTool.ScrollPanel = ScrollPanel

		local function getAvailableRacers()
			local entries = {}

			for _, base in ipairs(vehicleBases) do
				local files = UV_GetFiles(base.path) or {}
				for _, filename in ipairs(files) do
					entries[#entries + 1] = {
						filename = filename,
						base     = base,
						baseId   = base.id,
						display  = "[ " .. base.name .. " ] " .. filename
					}
				end
			end

			return entries
		end

		function UVRacerManagerTool.RefreshList()
			ScrollPanel:Clear()

			local entries = getAvailableRacers()
			if #entries == 0 then
				local empty = vgui.Create("DLabel", ScrollPanel)
				empty:SetText("#uv.tool.novehicle")
				empty:SetTextColor(Color(200,200,200))
				empty:SetContentAlignment(5)
				empty:Dock(TOP)
				empty:SetTall(24)
				return
			end

			for _, entry in ipairs(entries) do
				if activeFilterBaseId ~= 0 and entry.baseId ~= activeFilterBaseId then
					continue
				end

				if not selecteditem then
					selecteditem = entry.filename
				end

				local btn = ScrollPanel:Add("DButton")
				btn:Dock(TOP)
				btn:DockMargin(0, 0, 0, 4)
				btn:SetTall(24)
				btn:SetText("")
				btn.printname = entry.filename

				btn.Paint = function(self, w, h)
					local hovered = self:IsHovered()

					local default = Color(
						GetConVar("uvmenu_col_button_r"):GetInt(),
						GetConVar("uvmenu_col_button_g"):GetInt(),
						GetConVar("uvmenu_col_button_b"):GetInt(),
						GetConVar("uvmenu_col_button_a"):GetInt()
					)

					local active = Color(
						GetConVar("uvmenu_col_bool_active_r"):GetInt(),
						GetConVar("uvmenu_col_bool_active_g"):GetInt(),
						GetConVar("uvmenu_col_bool_active_b"):GetInt(),
						GetConVar("uvmenu_col_button_a"):GetInt()
					)

					local hover = Color(
						GetConVar("uvmenu_col_button_hover_r"):GetInt(),
						GetConVar("uvmenu_col_button_hover_g"):GetInt(),
						GetConVar("uvmenu_col_button_hover_b"):GetInt(),
						GetConVar("uvmenu_col_button_hover_a"):GetInt()
							* math.abs(math.sin(RealTime() * 4))
					)

					draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h,
						(selecteditem == self.printname) and active or default)

					if hovered then
						draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, hover)
					end

					UVDrawCursorText(self, entry.display, "UVSettingsFontSmall", w * 0.05, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1.25, color_black, w * 0.05, w * 0.95)
				end

				btn.DoClick = function()
					selecteditem = entry.filename
					SetClipboardText(selecteditem)
					net.Start("UVRacerManagerGetRacerInfo")
					net.WriteString(selecteditem)
					net.WriteUInt(entry.baseId, 3)
					net.SendToServer()
				end
			end
		end

		timer.Simple(0, function()
			if IsValid(ScrollPanel) then
				UVRacerManagerTool.RefreshList()
			end
		end)

		hook.Add( "UVContentEvent", "UVRacerManagerTool_OnContentUpdate", function( operation, path, fileName )
			for _, base in ipairs(vehicleBases) do
				if base.path == path then
					UVRacerManagerTool.RefreshList()
					break
				end
			end
		end )

		local RefreshBtn = vgui.Create("DButton")
		RefreshBtn:SetText("#refresh")
		RefreshBtn:SetSize(280, 20)
		RefreshBtn.DoClick = function()
			UVRacerManagerTool.RefreshList()
			surface.PlaySound("buttons/button15.wav")
		end
		CPanel:AddItem(RefreshBtn)

		local DeleteBtn = vgui.Create("DButton")
		DeleteBtn:SetText("#spawnmenu.menu.delete")
		DeleteBtn:SetSize(280, 20)
		DeleteBtn.DoClick = function()
			if not isstring(selecteditem) then return end

			for _, base in ipairs(vehicleBases) do
				if activeFilterBaseId == 0 or base.id == activeFilterBaseId then
					if UV_GetFile(base.path, selecteditem) then
						net.Start("UVRacerManagerDeleteFile")
						net.WriteString(base.path)
						net.WriteString(selecteditem)
						net.SendToServer()
					end
					-- if UV_GetFile(base.path, selecteditem) then
					-- 	UV_RemoveFile(base.path, selecteditem)
					--	notification.AddLegacy(
					-- 		string.format(language.GetPhrase("uv.tool.deleted"), selecteditem),
					-- 		NOTIFY_UNDO, 5
					-- 	)
					-- 	surface.PlaySound("buttons/button15.wav")
					-- 	break
					-- end
				end
			end

			selecteditem = nil
		end
		CPanel:AddItem(DeleteBtn)


		CPanel:AddControl("Label", { Text = "" }) -- General Settings
		CPanel:AddControl("Label", { Text = "#uv.tweakinmenu" })
		local OpenMenu = vgui.Create("DButton")
		OpenMenu:SetText("#uv.tweakinmenu.open")
		OpenMenu:SetSize(280, 20)
		OpenMenu.DoClick = function()
			UVMenu.OpenMenu(UVMenu.Main)
			UVMenu.PlaySFX("menuopen")
		end
		CPanel:AddItem(OpenMenu)
	end

end

function TOOL:RightClick(trace)
	if CLIENT then return true end
	
	local ent = trace.Entity
	local ply = self:GetOwner()
	
	ply.UVRacerTOOLMemory = {}
	
	if ent.IsSimfphyscar or ent.IsGlideVehicle or ent:GetClass() == "prop_vehicle_jeep" or ent.LVS then
		if not IsValid(ent) then 
			net.Start("UVRacerManagerGetRacerInfo")
			net.WriteTable( ply.UVRacerTOOLMemory )
			net.Send( ply )
			
			return false
		end
		
		self:GetVehicleData( ent, ply )
	end

	if table.IsEmpty(ply.UVRacerTOOLMemory) then return false end
	
	net.Start("UVRacerManagerAdjustRacer")
	net.Send(ply)
	
	return true
end

local function ValidateModel( model )
	local v_list = list.Get( "simfphys_vehicles" )
	for listname, _ in pairs( v_list ) do
		if v_list[listname].Members.CustomWheels then
			local FrontWheel = v_list[listname].Members.CustomWheelModel
			local RearWheel = v_list[listname].Members.CustomWheelModel_R
			
			if FrontWheel then 
				FrontWheel = string.lower( FrontWheel )
			end
			
			if RearWheel then 
				RearWheel = string.lower( RearWheel )
			end
			
			if model == FrontWheel or model == RearWheel then
				return true
			end
		end
	end
	
	local list = list.Get( "simfphys_Wheels" )[model]
	
	if list then 
		return true
	end
	
	return false
end

local function GetRight( ent, index, WheelPos )
	local Steer = ent:GetTransformedDirection()
	
	local Right = ent.Right
	
	if WheelPos.IsFrontWheel then
		Right = (IsValid( ent.SteerMaster ) and Steer.Right or ent.Right) * (WheelPos.IsRightWheel and 1 or -1)
	else
		Right = (IsValid( ent.SteerMaster ) and Steer.Right2 or ent.Right) * (WheelPos.IsRightWheel and 1 or -1)
	end
	
	return Right
end

local function SetWheelOffset( ent, offset_front, offset_rear )
	if not IsValid( ent ) then return end
	
	ent.WheelTool_Foffset = offset_front
	ent.WheelTool_Roffset = offset_rear
	
	if not istable( ent.Wheels ) or not istable( ent.GhostWheels ) then return end
	
	for i = 1, table.Count( ent.GhostWheels ) do
		local Wheel = ent.Wheels[ i ]
		local WheelModel = ent.GhostWheels[i]
		local WheelPos = ent:LogicWheelPos( i )
		
		if IsValid( Wheel ) and IsValid( WheelModel ) then
			local Pos = Wheel:GetPos()
			local Right = GetRight( ent, i, WheelPos )
			local offset = WheelPos.IsFrontWheel and offset_front or offset_rear
			
			WheelModel:SetParent( nil )
			
			local physObj = WheelModel:GetPhysicsObject()
			if IsValid( physObj ) then
				physObj:EnableMotion( false )
			end
			
			WheelModel:SetPos( Pos + Right * offset )
			WheelModel:SetParent( Wheel )
		end
	end
end

local function ApplyWheel(ent, data)
	ent.CustomWheelAngleOffset = data[2]
	ent.CustomWheelAngleOffset_R = data[4]
	
	timer.Simple( 0.05, function()
		if not IsValid( ent ) then return end
		for i = 1, table.Count( ent.GhostWheels ) do
			local Wheel = ent.GhostWheels[i]
			
			if IsValid( Wheel ) then
				local isfrontwheel = (i == 1 or i == 2)
				local swap_y = (i == 2 or i == 4 or i == 6)
				
				local angleoffset = isfrontwheel and ent.CustomWheelAngleOffset or ent.CustomWheelAngleOffset_R
				
				local model = isfrontwheel and data[1] or data[3]
				
				local fAng = ent:LocalToWorldAngles( ent.VehicleData.LocalAngForward )
				local rAng = ent:LocalToWorldAngles( ent.VehicleData.LocalAngRight )
				
				local Forward = fAng:Forward() 
				local Right = swap_y and -rAng:Forward() or rAng:Forward()
				local Up = ent:GetUp()
				
				local Camber = data[5] or 0
				
				local ghostAng = Right:Angle()
				local mirAng = swap_y and 1 or -1
				ghostAng:RotateAroundAxis(Forward,angleoffset.p * mirAng)
				ghostAng:RotateAroundAxis(Right,angleoffset.r * mirAng)
				ghostAng:RotateAroundAxis(Up,-angleoffset.y)
				
				ghostAng:RotateAroundAxis(Forward, Camber * mirAng)
				
				Wheel:SetModelScale( 1 )
				Wheel:SetModel( model )
				Wheel:SetAngles( ghostAng )
				
				timer.Simple( 0.05, function()
					if not IsValid(Wheel) or not IsValid( ent ) then return end
					local wheelsize = Wheel:OBBMaxs() - Wheel:OBBMins()
					local radius = isfrontwheel and ent.FrontWheelRadius or ent.RearWheelRadius
					local size = (radius * 2) / math.max(wheelsize.x,wheelsize.y,wheelsize.z)
					
					Wheel:SetModelScale( size )
				end)
			end
		end
	end)
end

local function GetAngleFromSpawnlist( model )
	if not model then print("invalid model") return Angle(0,0,0) end
	
	model = string.lower( model )
	
	local v_list = list.Get( "simfphys_vehicles" )
	for listname, _ in pairs( v_list ) do
		if v_list[listname].Members.CustomWheels then
			local FrontWheel = v_list[listname].Members.CustomWheelModel
			local RearWheel = v_list[listname].Members.CustomWheelModel_R
			
			if FrontWheel then 
				FrontWheel = string.lower( FrontWheel )
			end
			
			if RearWheel then 
				RearWheel = string.lower( RearWheel )
			end
			
			if model == FrontWheel or model == RearWheel then
				local Angleoffset = v_list[listname].Members.CustomWheelAngleOffset
				if (Angleoffset) then
					return Angleoffset
				end
			end
		end
	end
	
	local list = list.Get( "simfphys_Wheels" )[model]
	local output = list and list.Angle or Angle(0,0,0)
	
	return output
end

function TOOL:LeftClick( trace )
	if CLIENT then return true end
	
	local Ent = trace.Entity
	
	local ply = self:GetOwner()
	
	if not istable(ply.UVRacerTOOLMemory) then
		ply:PrintMessage( HUD_PRINTTALK, "Select a Racer" )
		return 
	end
	
	if ply.UVRacerTOOLMemory.VehicleBase == "base_glide_car" or ply.UVRacerTOOLMemory.VehicleBase == "base_glide_motorcycle" or ply.UVRacerTOOLMemory.VehicleBase == "LVS" then
		local SpawnCenter = trace.HitPos
		SpawnCenter.z = SpawnCenter.z - ply.UVRacerTOOLMemory.Mins.z
		
		duplicator.SetLocalPos( SpawnCenter+Vector( 0, 0, 50 ) )
		duplicator.SetLocalAng( Angle( 0, ply:EyeAngles().yaw, 0 ) )
		
		local Ents = duplicator.Paste( self:GetOwner(), ply.UVRacerTOOLMemory.Entities, ply.UVRacerTOOLMemory.Constraints )
		
		local Ent = nil
		if next(Ents) ~= nil then
			for _, v in pairs(Ents) do
				if (v.IsGlideVehicle and v.GetIsHonking) or v.LVS then
					Ent = v
					break
				end
			end
		end
		
		if not IsValid( Ent ) then 
			PrintMessage( HUD_PRINTTALK, "The vehicle ".. ply.UVRacerTOOLMemory.SpawnName .." dosen't seem to be installed!" )
			return 
		end

		if ply.UVRacerTOOLMemory.SubMaterials then
			if istable( ply.UVRacerTOOLMemory.SubMaterials ) then
				for i = 0, table.Count( ply.UVRacerTOOLMemory.SubMaterials ) do
					Ent:SetSubMaterial( i, ply.UVRacerTOOLMemory.SubMaterials[i] )
				end
			end

			local groups = string.Explode( ",", ply.UVRacerTOOLMemory.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end

			Ent:SetSkin( ply.UVRacerTOOLMemory.Skin )

			local c = string.Explode( ",", ply.UVRacerTOOLMemory.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )

			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot

			if ply.UVRacerTOOLMemory.SaveColor then
				Ent:SetColor( Color )
			else
				if isfunction(Ent.GetSpawnColor) then
					Color = Ent:GetSpawnColor()
					Ent:SetColor( Color )
				else
					Color.r = math.random(0, 255)
					Color.g = math.random(0, 255)
					Color.b = math.random(0, 255)
					Ent:SetColor( Color )
				end
			end

			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
		end
		
		duplicator.SetLocalPos( vector_origin )
		duplicator.SetLocalAng( angle_zero )
		
		undo.Create( "Duplicator" )
		
		for k, ent in pairs( Ents ) do
			undo.AddEntity( ent )
		end
		
		for k, ent in pairs( Ents )	do
			self:GetOwner():AddCleanup( "duplicates", ent )
		end
		
		undo.SetPlayer( self:GetOwner() )
		undo.SetCustomUndoText( "Undone LVS Racer" )
		
		undo.Finish( "Undo (" .. tostring( table.Count( Ents ) ) ..  ")" )

		if cffunctions and not ply.UVRacerTOOLMemory.VehicleBase == "LVS" then
			Ent.NitrousPower = ply.UVRacerTOOLMemory.NitrousPower
			Ent.NitrousDepletionRate = ply.UVRacerTOOLMemory.NitrousDepletionRate
			Ent.NitrousRegenRate = ply.UVRacerTOOLMemory.NitrousRegenRate
			Ent.NitrousRegenDelay = ply.UVRacerTOOLMemory.NitrousRegenDelay
			Ent.NitrousPitchChangeFrequency = ply.UVRacerTOOLMemory.NitrousPitchChangeFrequency
			Ent.NitrousPitchMultiplier = ply.UVRacerTOOLMemory.NitrousPitchMultiplier
			Ent.NitrousBurst = ply.UVRacerTOOLMemory.NitrousBurst
			Ent.NitrousColor = ply.UVRacerTOOLMemory.NitrousColor
			Ent.NitrousStartSound = ply.UVRacerTOOLMemory.NitrousStartSound
			Ent.NitrousLoopingSound = ply.UVRacerTOOLMemory.NitrousLoopingSound
			Ent.NitrousEndSound = ply.UVRacerTOOLMemory.NitrousEndSound
			Ent.NitrousEmptySound = ply.UVRacerTOOLMemory.NitrousEmptySound
			Ent.NitrousReadyBurstSound = ply.UVRacerTOOLMemory.NitrousReadyBurstSound
			Ent.NitrousStartBurstSound = ply.UVRacerTOOLMemory.NitrousStartBurstSound
			Ent.NitrousStartBurstAnnotationSound = ply.UVRacerTOOLMemory.NitrousStartBurstAnnotationSound
			Ent.CriticalDamageSound = ply.UVRacerTOOLMemory.CriticalDamageSound
			Ent:SetNWBool( 'NitrousEnabled', ply.UVRacerTOOLMemory.NitrousEnabled == nil and true or ply.UVRacerTOOLMemory.NitrousEnabled )
			
			if Ent.NitrousColor then
				local r = Ent.NitrousColor.r
    			local g = Ent.NitrousColor.g
    			local b = Ent.NitrousColor.b
			
    			net.Start( "cfnitrouscolor" )
    			    net.WriteEntity(Ent)
    			    net.WriteInt(r, 9)
    			    net.WriteInt(g, 9)
    			    net.WriteInt(b, 9)
					net.WriteBool(Ent.NitrousBurst)
					net.WriteBool(Ent.NitrousEnabled)
    			net.Broadcast()
			end
		end
		
		Ent.RacerVehicle = ply
		
		return true
		
	elseif ply.UVRacerTOOLMemory.VehicleBase == "prop_vehicle_jeep" then
		local class = ply.UVRacerTOOLMemory.SpawnName
		local vehicles = list.Get("Vehicles")
		local lst = vehicles[class]
		if not lst then
			PrintMessage( HUD_PRINTTALK, "The vehicle '"..class.."' is missing!")
			return
		end
		
		local Ent = ents.Create("prop_vehicle_jeep")
		Ent.VehicleTable = lst
		Ent.VehicleName = ply.UVRacerTOOLMemory.VehicleName
		Ent:SetModel(lst.Model) 
		Ent:SetPos(trace.HitPos)
		
		local SpawnAng = self:GetOwner():EyeAngles()
		SpawnAng.pitch = 0
		SpawnAng.yaw = SpawnAng.yaw + 90
		SpawnAng.roll = 0
		Ent:SetAngles(SpawnAng)
		
		Ent:SetKeyValue("vehiclescript", lst.KeyValues.vehiclescript)
		Ent:SetVehicleClass( class )
		Ent:Spawn()
		Ent:Activate()
		
		local vehicle = Ent
		gamemode.Call( "PlayerSpawnedVehicle", ply, vehicle ) --Some vehicles has different models implanted together, so do that.
		
		if istable( ply.UVRacerTOOLMemory.SubMaterials ) then
			for i = 0, table.Count( ply.UVRacerTOOLMemory.SubMaterials ) do
				Ent:SetSubMaterial( i, ply.UVRacerTOOLMemory.SubMaterials[i] )
			end
		end
		
		timer.Simple(0.5, function()
			if not IsValid(Ent) then return end
			local groups = string.Explode( ",", ply.UVRacerTOOLMemory.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( ply.UVRacerTOOLMemory.Skin )
			
			local c = string.Explode( ",", ply.UVRacerTOOLMemory.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			
			if ply.UVRacerTOOLMemory.SaveColor then
				Ent:SetColor( Color )
			else
				Color.r = math.random(0, 255)
				Color.g = math.random(0, 255)
				Color.b = math.random(0, 255)
				Ent:SetColor( Color )
			end
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
		end)
		
		undo.Create( "Vehicle" )
		undo.SetPlayer( ply )
		undo.AddEntity( Ent )
		undo.SetCustomUndoText( "Undone " .. class )
		undo.Finish( "Vehicle (" .. tostring( class ) .. ")" )
		
		Ent.RacerVehicle = ply
		
		return true
		
	end
	
	local vname = ply.UVRacerTOOLMemory.SpawnName
	local Update = false
	local VehicleList = list.Get( "simfphys_vehicles" )
	local vehicle = VehicleList[ vname ]
	
	if not vehicle then return false end
	
	ply.LockRightClick = true
	timer.Simple( 0.6, function() if IsValid( ply ) then ply.LockRightClick = false end end )
	
	local SpawnPos = trace.HitPos + Vector(0,0,25) + (vehicle.SpawnOffset or Vector(0,0,0))
	
	local SpawnAng = self:GetOwner():EyeAngles()
	SpawnAng.pitch = 0
	SpawnAng.yaw = SpawnAng.yaw + 180 + (vehicle.SpawnAngleOffset and vehicle.SpawnAngleOffset or 0)
	SpawnAng.roll = 0
	
	if Ent.IsSimfphyscar then
		if vname ~= Ent:GetSpawn_List() then 
			ply:PrintMessage( HUD_PRINTTALK, vname.." is not compatible with "..Ent:GetSpawn_List() )
			return
		end
		Update = true
	else
		Ent = simfphys.SpawnVehicle( ply, SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, vname, vehicle )
	end
	
	if not IsValid( Ent ) then return end
	
	undo.Create( "Vehicle" )
	undo.SetPlayer( ply )
	undo.AddEntity( Ent )
	undo.SetCustomUndoText( "Undone " .. vehicle.Name )
	undo.Finish( "Vehicle (" .. tostring( vehicle.Name ) .. ")" )
	
	ply:AddCleanup( "vehicles", Ent )
	
	timer.Simple( 0.5, function()
		if not IsValid(Ent) then return end
		
		local tsc = string.Explode( ",", ply.UVRacerTOOLMemory.TireSmokeColor )
		Ent:SetTireSmokeColor( Vector( tonumber(tsc[1]), tonumber(tsc[2]), tonumber(tsc[3]) ) )
		
		Ent.Turbocharged = tobool( ply.UVRacerTOOLMemory.HasTurbo )
		Ent.Supercharged = tobool( ply.UVRacerTOOLMemory.HasBlower )
		
		Ent:SetEngineSoundPreset( math.Clamp( tonumber( ply.UVRacerTOOLMemory.SoundPreset ), -1, 23) )
		Ent:SetMaxTorque( math.Clamp( tonumber( ply.UVRacerTOOLMemory.PeakTorque ), 20, 1000) )
		Ent:SetDifferentialGear( math.Clamp( tonumber( ply.UVRacerTOOLMemory.FinalGear ),0.2, 6 ) )
		
		Ent:SetSteerSpeed( math.Clamp( tonumber( ply.UVRacerTOOLMemory.SteerSpeed ), 1, 16 ) )
		Ent:SetFastSteerAngle( math.Clamp( tonumber( ply.UVRacerTOOLMemory.SteerAngFast ), 0, 1) )
		Ent:SetFastSteerConeFadeSpeed( math.Clamp( tonumber( ply.UVRacerTOOLMemory.SteerFadeSpeed ), 1, 5000 ) )
		
		Ent:SetEfficiency( math.Clamp( tonumber( ply.UVRacerTOOLMemory.Efficiency ) ,0.2,4) )
		Ent:SetMaxTraction( math.Clamp( tonumber( ply.UVRacerTOOLMemory.MaxTraction ) , 5,1000) )
		Ent:SetTractionBias( math.Clamp( tonumber( ply.UVRacerTOOLMemory.GripOffset ),-0.99,0.99) )
		Ent:SetPowerDistribution( math.Clamp( tonumber( ply.UVRacerTOOLMemory.PowerDistribution ) ,-1,1) )
		
		Ent:SetBackFire( tobool( ply.UVRacerTOOLMemory.HasBackfire ) )
		Ent:SetDoNotStall( tobool( ply.UVRacerTOOLMemory.DoesntStall ) )
		
		Ent:SetIdleRPM( math.Clamp( tonumber( ply.UVRacerTOOLMemory.IdleRPM ),1,25000) )
		Ent:SetLimitRPM( math.Clamp( tonumber( ply.UVRacerTOOLMemory.MaxRPM ),4,25000) )
		Ent:SetRevlimiter( tobool( ply.UVRacerTOOLMemory.HasRevLimiter ) )
		Ent:SetPowerBandEnd( math.Clamp( tonumber( ply.UVRacerTOOLMemory.PowerEnd ), 3, 25000) )
		Ent:SetPowerBandStart( math.Clamp( tonumber( ply.UVRacerTOOLMemory.PowerStart ) ,2 ,25000) )
		
		Ent:SetTurboCharged( Ent.Turbocharged )
		Ent:SetSuperCharged( Ent.Supercharged )
		Ent:SetBrakePower( math.Clamp( tonumber( ply.UVRacerTOOLMemory.BrakePower ), 0.1, 500) )
		
		Ent:SetSoundoverride( ply.UVRacerTOOLMemory.SoundOverride or "" )
		
		Ent:SetLights_List( Ent.LightsTable or "no_lights" )
				
		Ent.snd_horn = ply.UVRacerTOOLMemory.HornSound
		
		Ent.snd_blowoff = ply.UVRacerTOOLMemory.snd_blowoff
		Ent.snd_spool = ply.UVRacerTOOLMemory.snd_spool
		Ent.snd_bloweron = ply.UVRacerTOOLMemory.snd_bloweron
		Ent.snd_bloweroff = ply.UVRacerTOOLMemory.snd_bloweroff
		
		Ent:SetBackfireSound( ply.UVRacerTOOLMemory.backfiresound or "" )
		
		local Gears = {}
		local Data = string.Explode( ",", ply.UVRacerTOOLMemory.Gears  )
		for i = 1, table.Count( Data ) do 
			local gRatio = tonumber( Data[i] )
			
			if isnumber( gRatio ) then
				if i == 1 then
					Gears[i] = math.Clamp( gRatio, -5, -0.001)
					
				elseif i == 2 then
					Gears[i] = 0
					
				else
					Gears[i] = math.Clamp( gRatio, 0.001, 5)
				end
			end
		end
		Ent.Gears = Gears
		
		if istable( ply.UVRacerTOOLMemory.SubMaterials ) then
			for i = 0, table.Count( ply.UVRacerTOOLMemory.SubMaterials ) do
				Ent:SetSubMaterial( i, ply.UVRacerTOOLMemory.SubMaterials[i] )
			end
		end
		
		if ply.UVRacerTOOLMemory.FrontDampingOverride and ply.UVRacerTOOLMemory.FrontConstantOverride and ply.UVRacerTOOLMemory.RearDampingOverride and ply.UVRacerTOOLMemory.RearConstantOverride then
			Ent.FrontDampingOverride = tonumber( ply.UVRacerTOOLMemory.FrontDampingOverride )
			Ent.FrontConstantOverride = tonumber( ply.UVRacerTOOLMemory.FrontConstantOverride )
			Ent.RearDampingOverride = tonumber( ply.UVRacerTOOLMemory.RearDampingOverride )
			Ent.RearConstantOverride = tonumber( ply.UVRacerTOOLMemory.RearConstantOverride )
			
			local data = {
				[1] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
				[2] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
				[3] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
				[4] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
				[5] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
				[6] = {Ent.RearConstantOverride,Ent.RearDampingOverride}
			}
			
			local elastics = Ent.Elastics
			if elastics then
				for i = 1, table.Count( elastics ) do
					local elastic = elastics[i]
					if Ent.StrengthenSuspension == true then
						if IsValid( elastic ) then
							elastic:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
							elastic:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
						end
						local elastic2 = elastics[i * 10]
						if IsValid( elastic2 ) then
							elastic2:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
							elastic2:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
						end
					else
						if IsValid( elastic ) then
							elastic:Fire( "SetSpringConstant", data[i][1], 0 )
							elastic:Fire( "SetSpringDamping", data[i][2], 0 )
						end
					end
				end
			end
		end
		
		Ent:SetFrontSuspensionHeight( tonumber( ply.UVRacerTOOLMemory.FrontHeight ) )
		Ent:SetRearSuspensionHeight( tonumber( ply.UVRacerTOOLMemory.RearHeight ) )
		
		local groups = string.Explode( ",", ply.UVRacerTOOLMemory.BodyGroups)
		for i = 1, table.Count( groups ) do
			Ent:SetBodygroup(i, tonumber(groups[i]) )
		end
		
		Ent:SetSkin( ply.UVRacerTOOLMemory.Skin )
		
		local c = string.Explode( ",", ply.UVRacerTOOLMemory.Color )
		local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
		
		local dot = Color.r * Color.g * Color.b * Color.a
		Ent.OldColor = dot
		
		if ply.UVRacerTOOLMemory.SaveColor then
			Ent:SetColor( Color )
		else
			Color.r = math.random(0, 255)
			Color.g = math.random(0, 255)
			Color.b = math.random(0, 255)
			Ent:SetColor( Color )
		end
		
		local data = {
			Color = Color,
			RenderMode = 0,
			RenderFX = 0
		}
		duplicator.StoreEntityModifier( Ent, "colour", data )
		
		if Update then
			local PhysObj = Ent:GetPhysicsObject()
			if not IsValid( PhysObj ) then return end
			
			local freezeWhenDone = PhysObj:IsMotionEnabled()
			local freezeWheels = {}
			PhysObj:EnableMotion( false )
			Ent:SetNotSolid( true )
			
			local ResetPos = Ent:GetPos()
			local ResetAng = Ent:GetAngles()
			
			Ent:SetPos( ResetPos + Vector(0,0,30) )
			Ent:SetAngles( Angle(0,ResetAng.y,0) )
			
			for i = 1, table.Count( Ent.Wheels ) do
				local Wheel = Ent.Wheels[ i ]
				if IsValid( Wheel ) then
					local wPObj = Wheel:GetPhysicsObject()
					
					if IsValid( wPObj ) then
						freezeWheels[ i ] = {}
						freezeWheels[ i ].dofreeze = wPObj:IsMotionEnabled()
						freezeWheels[ i ].pos = Wheel:GetPos()
						freezeWheels[ i ].ang = Wheel:GetAngles()
						Wheel:SetNotSolid( true )
						wPObj:EnableMotion( true ) 
						wPObj:Wake() 
					end
				end
			end
			
			timer.Simple( 0.5, function()
				if not IsValid( Ent ) then return end
				if not IsValid( PhysObj ) then return end
				
				PhysObj:EnableMotion( freezeWhenDone )
				Ent:SetNotSolid( false )
				Ent:SetPos( ResetPos )
				Ent:SetAngles( ResetAng )
				
				for i = 1, table.Count( freezeWheels ) do
					local Wheel = Ent.Wheels[ i ]
					if IsValid( Wheel ) then
						local wPObj = Wheel:GetPhysicsObject()
						
						Wheel:SetNotSolid( false )
						
						if IsValid( wPObj ) then
							wPObj:EnableMotion( freezeWheels[i].dofreeze ) 
						end
						
						Wheel:SetPos( freezeWheels[ i ].pos )
						Wheel:SetAngles( freezeWheels[ i ].ang )
					end
				end
			end)
		end
		
		if Ent.CustomWheels then
			if Ent.GhostWheels then
				timer.Simple( Update and 0.25 or 0, function()
					if not IsValid( Ent ) then return end
					if ply.UVRacerTOOLMemory.WheelTool_Foffset and ply.UVRacerTOOLMemory.WheelTool_Roffset then
						SetWheelOffset( Ent, ply.UVRacerTOOLMemory.WheelTool_Foffset, ply.UVRacerTOOLMemory.WheelTool_Roffset )
					end
					
					if not ply.UVRacerTOOLMemory.FrontWheelOverride and not ply.UVRacerTOOLMemory.RearWheelOverride then return end
					
					local front_model = ply.UVRacerTOOLMemory.FrontWheelOverride or vehicle.Members.CustomWheelModel
					local front_angle = GetAngleFromSpawnlist(front_model)
					
					local camber = ply.UVRacerTOOLMemory.Camber or 0
					local rear_model = ply.UVRacerTOOLMemory.RearWheelOverride or (vehicle.Members.CustomWheelModel_R and vehicle.Members.CustomWheelModel_R or front_model)
					local rear_angle = GetAngleFromSpawnlist(rear_model)
					
					if not front_model or not rear_model or not front_angle or not rear_angle then return end
					
					if ValidateModel( front_model ) and ValidateModel( rear_model ) then 
						Ent.Camber = camber
						ApplyWheel(Ent, {front_model,front_angle,rear_model,rear_angle,camber})
					else
						ply:PrintMessage( HUD_PRINTTALK, "selected wheel does not exist on the server")
					end
				end)
			end
		end
		
		Ent.RacerVehicle = ply
		
	end)
	
	return true
end

function TOOL:GetVehicleData( ent, ply )
	if not IsValid(ent) then return end
	ply.UVRacerTOOLMemory = {}
	
	if ent.IsSimfphyscar then
		ply.UVRacerTOOLMemory.VehicleBase = ent:GetClass()
		ply.UVRacerTOOLMemory.SpawnName = ent:GetSpawn_List()
		ply.UVRacerTOOLMemory.SteerSpeed = ent:GetSteerSpeed()
		ply.UVRacerTOOLMemory.SteerFadeSpeed = ent:GetFastSteerConeFadeSpeed()
		ply.UVRacerTOOLMemory.SteerAngFast = ent:GetFastSteerAngle()
		ply.UVRacerTOOLMemory.SoundPreset = ent:GetEngineSoundPreset()
		ply.UVRacerTOOLMemory.IdleRPM = ent:GetIdleRPM()
		ply.UVRacerTOOLMemory.MaxRPM = ent:GetLimitRPM()
		ply.UVRacerTOOLMemory.PowerStart = ent:GetPowerBandStart()
		ply.UVRacerTOOLMemory.PowerEnd = ent:GetPowerBandEnd()
		ply.UVRacerTOOLMemory.PeakTorque = ent:GetMaxTorque()
		ply.UVRacerTOOLMemory.HasTurbo = ent:GetTurboCharged()
		ply.UVRacerTOOLMemory.HasBlower = ent:GetSuperCharged()
		ply.UVRacerTOOLMemory.HasRevLimiter = ent:GetRevlimiter()
		ply.UVRacerTOOLMemory.HasBulletProofTires = ent:GetBulletProofTires()
		ply.UVRacerTOOLMemory.MaxTraction = ent:GetMaxTraction()
		ply.UVRacerTOOLMemory.GripOffset = ent:GetTractionBias()
		ply.UVRacerTOOLMemory.BrakePower = ent:GetBrakePower()
		ply.UVRacerTOOLMemory.PowerDistribution = ent:GetPowerDistribution()
		ply.UVRacerTOOLMemory.Efficiency = ent:GetEfficiency()
		ply.UVRacerTOOLMemory.HornSound = ent.snd_horn
		ply.UVRacerTOOLMemory.HasBackfire = ent:GetBackFire()
		ply.UVRacerTOOLMemory.DoesntStall = ent:GetDoNotStall()
		ply.UVRacerTOOLMemory.SoundOverride = ent:GetSoundoverride()
		
		ply.UVRacerTOOLMemory.FrontHeight = ent:GetFrontSuspensionHeight()
		ply.UVRacerTOOLMemory.RearHeight = ent:GetRearSuspensionHeight()
		
		ply.UVRacerTOOLMemory.Camber = ent.Camber or 0
		
		if ent.FrontDampingOverride and ent.FrontConstantOverride and ent.RearDampingOverride and ent.RearConstantOverride then
			ply.UVRacerTOOLMemory.FrontDampingOverride = ent.FrontDampingOverride
			ply.UVRacerTOOLMemory.FrontConstantOverride = ent.FrontConstantOverride
			ply.UVRacerTOOLMemory.RearDampingOverride = ent.RearDampingOverride
			ply.UVRacerTOOLMemory.RearConstantOverride = ent.RearConstantOverride
		end
		
		if ent.CustomWheels then
			if ent.GhostWheels then
				if IsValid(ent.GhostWheels[1]) then
					ply.UVRacerTOOLMemory.FrontWheelOverride = ent.GhostWheels[1]:GetModel()
				elseif IsValid(ent.GhostWheels[2]) then
					ply.UVRacerTOOLMemory.FrontWheelOverride = ent.GhostWheels[2]:GetModel()
				end
				
				if IsValid(ent.GhostWheels[3]) then
					ply.UVRacerTOOLMemory.RearWheelOverride = ent.GhostWheels[3]:GetModel()
				elseif IsValid(ent.GhostWheels[4]) then
					ply.UVRacerTOOLMemory.RearWheelOverride = ent.GhostWheels[4]:GetModel()
				end
			end
		end
		
		local tsc = ent:GetTireSmokeColor()
		ply.UVRacerTOOLMemory.TireSmokeColor = tsc.r..","..tsc.g..","..tsc.b
		
		local Gears = ""
		for _,v in pairs(ent.Gears) do
			Gears = Gears..v..","
		end
		
		local c = ent:GetColor()
		ply.UVRacerTOOLMemory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		local bodygroups = {}
		for k,v in pairs(ent:GetBodyGroups()) do
			bodygroups[k] = ent:GetBodygroup( k ) 
		end
		
		ply.UVRacerTOOLMemory.BodyGroups = string.Implode( ",", bodygroups)
		
		ply.UVRacerTOOLMemory.Skin = ent:GetSkin()
		
		ply.UVRacerTOOLMemory.Gears = Gears
		ply.UVRacerTOOLMemory.FinalGear = ent:GetDifferentialGear()
		
		if ent.WheelTool_Foffset then
			ply.UVRacerTOOLMemory.WheelTool_Foffset = ent.WheelTool_Foffset
		end
		
		if ent.WheelTool_Roffset then
			ply.UVRacerTOOLMemory.WheelTool_Roffset = ent.WheelTool_Roffset
		end
		
		if ent.snd_blowoff then
			ply.UVRacerTOOLMemory.snd_blowoff = ent.snd_blowoff
		end
		
		if ent.snd_spool then
			ply.UVRacerTOOLMemory.snd_spool = ent.snd_spool
		end
		
		if ent.snd_bloweron then
			ply.UVRacerTOOLMemory.snd_bloweron = ent.snd_bloweron
		end
		
		if ent.snd_bloweroff then
			ply.UVRacerTOOLMemory.snd_bloweroff = ent.snd_bloweroff
		end
		
		ply.UVRacerTOOLMemory.backfiresound = ent:GetBackfireSound()
		
		ply.UVRacerTOOLMemory.SubMaterials = {}
		for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
			ply.UVRacerTOOLMemory.SubMaterials[i] = ent:GetSubMaterial( i )
		end
	elseif ent.IsGlideVehicle then
		local pos = ent:GetPos()
		duplicator.SetLocalPos( pos )
		
		ply.UVRacerTOOLMemory = duplicator.Copy( ent )
		
		duplicator.SetLocalPos( vector_origin )
		duplicator.SetLocalAng( angle_zero )
		
		if ( not ply.UVRacerTOOLMemory ) then return false end
		
		local baseon = scripted_ents.IsBasedOn(ent.Base, "base_glide_car") and "base_glide_car" or scripted_ents.IsBasedOn(ent.Base, "base_glide_motorcycle") and "base_glide_motorcycle"
		
		local Key = "VehicleBase"
		ply.UVRacerTOOLMemory[Key] = baseon or ent.Base
		local Key2 = "SpawnName"
		ply.UVRacerTOOLMemory[Key2] = ent:GetClass()
		ply.UVRacerTOOLMemory.Mins = Vector(ply.UVRacerTOOLMemory.Mins.x,ply.UVRacerTOOLMemory.Mins.y,0)
		
		ply.UVRacerTOOLMemory.Entities[next(ply.UVRacerTOOLMemory.Entities)].Angle = Angle(0,180,0)

		local c = ent:GetColor()
		ply.UVRacerTOOLMemory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		local bodygroups = {}
		for k,v in pairs(ent:GetBodyGroups()) do
			bodygroups[k] = ent:GetBodygroup( k ) 
		end
		
		ply.UVRacerTOOLMemory.BodyGroups = string.Implode( ",", bodygroups)
		
		ply.UVRacerTOOLMemory.Skin = ent:GetSkin()
		
		ply.UVRacerTOOLMemory.SubMaterials = {}
		for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
			ply.UVRacerTOOLMemory.SubMaterials[i] = ent:GetSubMaterial( i )
		end

		for _, v in pairs(ply.UVRacerTOOLMemory.Entities) do
			if cffunctions then
				v.NitrousPower = ent.NitrousPower or 2
				v.NitrousDepletionRate = ent.NitrousDepletionRate or 0.5
				v.NitrousRegenRate = ent.NitrousRegenRate or 0.1
				v.NitrousRegenDelay = ent.NitrousRegenDelay or 2
				v.NitrousPitchChangeFrequency = ent.NitrousPitchChangeFrequency or 1 
				v.NitrousPitchMultiplier = ent.NitrousPitchMultiplier or 0.2
				v.NitrousBurst = ent.NitrousBurst or false
				v.NitrousColor = ent.NitrousColor or Color(35, 204, 255)
				v.NitrousStartSound = ent.NitrousStartSound or "glide_nitrous/nitrous_burst.wav"
				v.NitrousLoopingSound = ent.NitrousLoopingSound or "glide_nitrous/nitrous_burst.wav"
				v.NitrousEndSound = ent.NitrousEndSound or "glide_nitrous/nitrous_activation_whine.wav"
				v.NitrousEmptySound = ent.NitrousEmptySound or "glide_nitrous/nitrous_empty.wav"
				v.NitrousReadyBurstSound = ent.NitrousReadyBurstSound or "glide_nitrous/nitrous_burst/ready/ready.wav"
				v.NitrousStartBurstSound = ent.NitrousStartBurstSound or file.Find("sound/glide_nitrous/nitrous_burst/*", "GAME")
				v.NitrousStartBurstAnnotationSound = ent.NitrousStartBurstAnnotationSound or file.Find("sound/glide_nitrous/nitrous_burst/annotation/*", "GAME")
				v.CriticalDamageSound = ent.CriticalDamageSound or "glide_healthbar/criticaldamage.wav"
				v.NitrousEnabled = ent:GetNWBool( 'NitrousEnabled' )
			end
		end
		
	elseif ent:GetClass() == "prop_vehicle_jeep" then
		ply.UVRacerTOOLMemory.VehicleBase = ent:GetClass()
		ply.UVRacerTOOLMemory.SpawnName = ent:GetVehicleClass()
		ply.UVRacerTOOLMemory.VehicleName = ent.VehicleName
		
		if not ply.UVRacerTOOLMemory.SpawnName then 
			print("This vehicle dosen't have a vehicle class set" )
			return 
		end
		
		local c = ent:GetColor()
		ply.UVRacerTOOLMemory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		local bodygroups = {}
		for k,v in pairs(ent:GetBodyGroups()) do
			bodygroups[k] = ent:GetBodygroup( k ) 
		end
		
		ply.UVRacerTOOLMemory.BodyGroups = string.Implode( ",", bodygroups)
		
		ply.UVRacerTOOLMemory.Skin = ent:GetSkin()
		
		ply.UVRacerTOOLMemory.SubMaterials = {}
		for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
			ply.UVRacerTOOLMemory.SubMaterials[i] = ent:GetSubMaterial( i )
		end
	elseif ent.LVS then
		local pos = ent:GetPos()
		duplicator.SetLocalPos( pos )

		ply.UVRacerTOOLMemory = duplicator.Copy( ent )

		duplicator.SetLocalPos( vector_origin )
		duplicator.SetLocalAng( angle_zero )

		ply.UVRacerTOOLMemory.MainEnt = ent:EntIndex()
		ply.UVRacerTOOLMemory.Mins = Vector(ply.UVRacerTOOLMemory.Mins.x,ply.UVRacerTOOLMemory.Mins.y,0)

		local needle = ply.UVRacerTOOLMemory.Entities[ply.UVRacerTOOLMemory.MainEnt]
		needle.PhysicsObjects[0].Angle = Angle(0,180,0)
		needle.Lights = nil

		needle.MaxHealth = ent:GetMaxHP()
		needle.CurHealth = needle.MaxHealth

		needle.DT = nil

		local c = ent:GetColor()
		ply.UVRacerTOOLMemory.Color = c.r..","..c.g..","..c.b..","..c.a

		if ( not ply.UVRacerTOOLMemory ) then return false end

		ply.UVRacerTOOLMemory.VehicleBase = "LVS"
		ply.UVRacerTOOLMemory.SpawnName = ent.PrintName
	end
	
	if not IsValid( ply ) then return end

	if ply.UVRacerTOOLMemory.Entities then
		for _, v in pairs(ply.UVRacerTOOLMemory.Entities) do
			v.OnDieFunctions = nil
			v.AutomaticFrameAdvance = nil
			v.BaseClass = nil
		end
	end

	if ply.UVRacerTOOLMemory.Constraints then
		for _, v in pairs(ply.UVRacerTOOLMemory.Constraints) do
			v.OnDieFunctions = nil
		end
	end
	
	net.Start("UVRacerManagerGetRacerInfo")
	net.WriteTable( ply.UVRacerTOOLMemory )
	net.Send( ply )
	
end