TOOL.Category       =   "uv.unitvehicles"
TOOL.Name           =   "#tool.uvroadblock.name"
TOOL.Command        =   nil
TOOL.ConfigName     =   ""

local rbtable = {
    "Vehicle",
    "Concrete Barrier",
    "Barricade",
    "Sawhorse Barricade",
    "Barrel",
    "Cone",
    "Spikestrip",
    "Explosive Barrel",
}

local proptable = {
    ["Vehicle"] = "entity_uvroadblockcar",
    ["Concrete Barrier"] = "prop_physics",
    ["Barricade"] = "prop_physics",
    ["Sawhorse Barricade"] = "prop_physics",
    ["Barrel"] = "prop_physics",
    ["Cone"] = "prop_physics",
    ["Spikestrip"] = "entity_uvspikestrip",
    ["Explosive Barrel"] = "entity_uvbombstrip"
}

local modeltable = {
    ["Vehicle"] = "models/unitvehiclesprops/uvarrow/uvarrow.mdl",
    ["Concrete Barrier"] = "models/props_phx/construct/concrete_barrier01.mdl",
    ["Barricade"] = "models/unitvehiclesprops/roadblock_gate/roadblock_gate.mdl",
    ["Sawhorse Barricade"] = "models/unitvehiclesprops/woodenbarriers/prop_brk_sawhorse_01_cops_mesh.mdl",
    ["Barrel"] = "models/unitvehiclesprops/policebigcone/prop_brk_cones_big_cops_mesh.mdl",
    ["Cone"] = "models/unitvehiclesprops/policesmallcone/policesmallcone.mdl",
    ["Spikestrip"] = "models/unitvehiclesprops/prop_metalspikes_01/metalspikes.mdl",
    ["Explosive Barrel"] = "models/props_phx/oildrum001_explosive.mdl",
}

local function GetModelAngle(rbtype, eyeAngles)
    local angles = {
        ["Vehicle"] = Angle(0, eyeAngles.y, 0),
        ["Concrete Barrier"] = Angle(180, eyeAngles.y + 90, 180),
        ["Barricade"] = Angle(180, eyeAngles.y, 180),
        ["Sawhorse Barricade"] = Angle(180, eyeAngles.y - 90, 180),
        ["Barrel"] = Angle(180, eyeAngles.y, 180),
        ["Cone"] = Angle(180, eyeAngles.y + 90, 180),
        ["Spikestrip"] = Angle(180, eyeAngles.y + 90, 180),
        ["Explosive Barrel"] = Angle(0, eyeAngles.y, 0),
    }
    return angles[rbtype] or Angle(0, eyeAngles.y, 0)
end

TOOL.ClientConVar["maxrb"] = 1
TOOL.ClientConVar["type"] = rbtable[1]
TOOL.ClientConVar["override"] = 0

local conVarsDefault = TOOL:BuildConVarList()

if SERVER then

    net.Receive("UVRoadblocksRetrieve", function( length, ply )
        ply.UVRBTOOLMemory = net.ReadTable()
        ply:SelectWeapon( "gmod_tool" )
    end)

    net.Receive("UVRoadblocksDeleteFile", function( length, ply )
        if ply and not ply:IsSuperAdmin() then return end

        local path = net.ReadString()
        local fileName = net.ReadString()

        local file = UV_GetFile(path, fileName)
        if not file then return end

        if not UV_IsWorkshop( path, fileName ) then
            UV_RemoveFile( path, fileName )
        end
    end)

    net.Receive("UVRoadblocksMarkAll", function( length, ply )
        if ply and not ply:IsSuperAdmin() then return end

        local savedRoadblocks = UV_GetFiles( "roadblocks>>"..game.GetMap() )
        local rbs = {}

        for k,v in pairs(savedRoadblocks) do
            local json = UV_LoadFile( "roadblocks>>"..game.GetMap(), v )
            local rbdata = util.JSONToTable(json, true)

            if rbdata then
                table.insert( rbs, {
                    name = v,
                    location = rbdata.Location or rbdata.Maxs,
                } )
            end
        end

        local compressedRbs = util.Compress( util.TableToJSON(rbs) )

        net.Start("UVRoadblocksMarkAllResponse")
        net.WriteUInt( #compressedRbs, 16 )
        net.WriteData( compressedRbs, #compressedRbs )
        net.Send(ply)
    end)

    net.Receive("UVRoadblocksCreate", function( length, ply )
        if next(ply.UVRBTOOLMemory) == nil then return end

        local name = net.ReadString()
        local angle = net.ReadAngle()
        local heatlevel = net.ReadInt(8)
        local disperse = net.ReadBool()

        local keyangle = "Angle"
        local keyheat = "HeatLevel"
        local keydisperse = "DisperseAfterPassing"

        ply.UVRBTOOLMemory[keyangle] = angle
        ply.UVRBTOOLMemory[keyheat] = heatlevel
        ply.UVRBTOOLMemory[keydisperse] = disperse

        local jsondata = util.TableToJSON(ply.UVRBTOOLMemory)
        file.Write("unitvehicles/roadblocks/"..game.GetMap().."/"..name..".json", jsondata)
        UV_AddFile( "roadblocks>>"..game.GetMap(), name .. ".json", "unitvehicles/roadblocks/"..game.GetMap().."/", "DATA" )

        PrintMessage( HUD_PRINTTALK, "Roadblock "..name.." has been created for "..game.GetMap().."!" )
        net.Start("UVRoadblocksRefresh")
        net.Send(ply)

        UVPreloadRoadblocks()

    end)

    net.Receive("UVRoadblocksLoad", function( length, ply )
        local id = net.ReadInt(32)
        UVSpawnRoadblock(id, true)
    end)

    net.Receive("UVRoadblocksLoadAll", function( length, ply )
        local saved_roadblocks = UV_GetFiles( "roadblocks>>"..game.GetMap() )
        for k,v in pairs(saved_roadblocks) do
            UVSpawnRoadblock(v, true)
        end
    end)
    
end

if CLIENT then

    TOOL.Information = {
        { name = "info"},
        { name = "left" },
        { name = "right" },
        { name = "reload" },
    }

    local selecteditem  = nil
    local UVRBTOOLMemory = {}
    
    net.Receive("UVRoadblocksRetrieve", function( length )
        UVRBTOOLMemory = net.ReadTable()
    end)

    net.Receive("UVRoadblocksMarkAllResponse", function( length )
        local bytes = net.ReadUInt( 16 )
        local data = net.ReadData( bytes )
        local rbs = util.JSONToTable( util.Decompress( data ) )
        UVMarkAllLocations(rbs)
    end)

    net.Receive("UVRoadblocksAdjust", function()
        local RoadblocksAdjust = vgui.Create("DFrame")
        local OK = vgui.Create("DButton")
        local lang = language.GetPhrase

        RoadblocksAdjust:Add(OK)
        RoadblocksAdjust:SetSize(500, 220)
        RoadblocksAdjust:SetBackgroundBlur(true)
        RoadblocksAdjust:Center()
        RoadblocksAdjust:SetTitle("#tool.uvroadblock.name")
        RoadblocksAdjust:SetDraggable(false)
        RoadblocksAdjust:MakePopup()

        local Intro = vgui.Create( "DLabel", RoadblocksAdjust )
        Intro:SetPos( 20, 40 )
        Intro:SetText( string.format( lang("tool.uvroadblock.create.desc"), UVRBTOOLMemory.PropCount ) )
        Intro:SizeToContents()

        local RoadblocksNameEntry = vgui.Create( "DTextEntry", RoadblocksAdjust )
        RoadblocksNameEntry:SetPos( 20, 80 )
        RoadblocksNameEntry:SetPlaceholderText( "#tool.uvroadblock.create.name" )
        RoadblocksNameEntry:SetSize(RoadblocksAdjust:GetWide() / 2, 22)

        local RoadblockHeatLevel = vgui.Create( "DNumSlider", RoadblocksAdjust )
        RoadblockHeatLevel:SetPos( 20, 120 )
        RoadblockHeatLevel:SetText( "#tool.uvroadblock.minheat" )
        RoadblockHeatLevel:SetTooltip( "#tool.uvroadblock.minheat.desc" )
        RoadblockHeatLevel:SetMin( 1 )
        RoadblockHeatLevel:SetMax( MAX_HEAT_LEVEL )
        RoadblockHeatLevel:SetDecimals( 0 )
        RoadblockHeatLevel:SetValue( 1 )
        RoadblockHeatLevel:SetSize(RoadblocksAdjust:GetWide(), 22)

        local DisperseAfterPassing = vgui.Create( "DCheckBoxLabel", RoadblocksAdjust )
        DisperseAfterPassing:SetPos( 20, 160 )
        DisperseAfterPassing:SetText( "#tool.uvroadblock.joinpursuit" )
        DisperseAfterPassing:SetTooltip( "#tool.uvroadblock.joinpursuit.desc" )
        DisperseAfterPassing:SetValue( false )

        local RoadblockAngle = LocalPlayer():EyeAngles()

        OK:SetText("Create Roadblock")
        OK:SetSize(RoadblocksAdjust:GetWide() * 5 / 16, 22)
        OK:Dock(BOTTOM)

        function OK:DoClick()

            local Name = RoadblocksNameEntry:GetValue()
                    
            if Name ~= "" then

                net.Start("UVRoadblocksCreate")
                net.WriteString(Name)
                net.WriteAngle(RoadblockAngle)
                net.WriteInt(RoadblockHeatLevel:GetValue(), 8)
                net.WriteBool(DisperseAfterPassing:GetChecked())
                net.SendToServer()
                
                UVRoadblocksScrollPanel:Clear() 
                if RefreshRoadblockList then RefreshRoadblockList() end
                RoadblocksAdjust:Close()
                surface.PlaySound( "buttons/button15.wav" )

            else
                RoadblocksNameEntry:SetPlaceholderText( "#uv.tool.fillme" )
                surface.PlaySound( "buttons/button10.wav" )
            end
            
        end
    end)

    net.Receive("UVRoadblocksRefresh", function( length )
        UVRoadblocksScrollPanel:Clear()
        if RefreshRoadblockList then RefreshRoadblockList() end
    end)

    function UVRoadblocksGetSaves( panel )
        local saved_roadblocks = file.Find("unitvehicles/roadblocks/"..game.GetMap().."/*.json", "DATA")
        local index = 0
        local highlight = false
        local offset = 22
        
        for k,v in pairs(saved_roadblocks) do
            local printname = v

            if not selecteditem then
                selecteditem = printname
            end
            
            local Button = vgui.Create( "DButton", panel )
            Button:SetText( printname )
            Button:SetTextColor( Color( 255, 255, 255 ) )
            Button:SetPos( 0,index * offset)
            Button:SetSize( 280, offset )
            Button.highlight = highlight
            Button.printname = printname
            Button.Paint = function( self, w, h )
                
                local c_selected = Color( 128, 185, 128, 255 )
                local c_normal = self.highlight and Color( 108, 111, 114, 200 ) or Color( 77, 80, 82, 200 )
                local c_hovered = Color( 41, 128, 185, 255 )
                local c_ = (selecteditem == self.printname) and c_selected or (self:IsHovered() and c_hovered or c_normal)
                
                draw.RoundedBox( 5, 1, 1, w - 2, h - 1, c_ )
            end
            Button.DoClick = function( self )
                selecteditem = self.printname
                if isstring(selecteditem) then

                    if not LocalPlayer():IsSuperAdmin() then
                        notification.AddLegacy( "#uv.superadmin.settings", NOTIFY_ERROR, 5 )
                        surface.PlaySound( "buttons/button10.wav" )
                        return
                    end

                    SetClipboardText(selecteditem)

                    net.Start("UVRoadblocksLoad")
                    net.WriteInt(k, 32)
                    net.SendToServer()
                    notification.AddLegacy( string.format( language.GetPhrase("uv.tool.loaded"), selecteditem ), NOTIFY_UNDO, 5 )
                    surface.PlaySound( "buttons/button15.wav" )
                    
                end
            end
            
            index = index + 1
            highlight = not highlight
        end
    end

    function TOOL.BuildCPanel(CPanel)
        local lang = language.GetPhrase
        
        if not file.Exists( "unitvehicles/roadblocks/"..game.GetMap(), "DATA" ) then
            file.CreateDir( "unitvehicles/roadblocks/"..game.GetMap() )
        end

        CPanel:AddControl("Label", {
            Text = "#tool.uvroadblock.settings.roadblocks",
        })

        local selecteditem = nil

        local Frame = vgui.Create("DPanel")
        Frame:SetTall(320)
        Frame.Paint = function(self, w, h)
            draw.RoundedBox(5, 0, 0, w, h, Color(115,115,115,200))
            draw.RoundedBox(5, 1, 1, w-2, h-2, Color(0,0,0,200))
        end
        CPanel:AddItem(Frame)

        UVRoadblocksScrollPanel = vgui.Create("DScrollPanel", Frame)
        UVRoadblocksScrollPanel:Dock(FILL)
        UVRoadblocksScrollPanel:DockMargin(4, 4, 4, 4)
        
        local function RefreshRoadblockList()
            UVRoadblocksScrollPanel:Clear()
            selecteditem = nil

            local files = UV_GetFiles( "roadblocks>>"..game.GetMap() )

            if #files == 0 then
                local empty = vgui.Create("DLabel", UVRoadblocksScrollPanel)
                empty:SetText("#uv.tool.novehicle")
                empty:SetTextColor(Color(200,200,200))
                empty:SetContentAlignment(5)
                empty:Dock(TOP)
                empty:SetTall(24)
                return
            end

            for id, filename in ipairs(files) do
                local btn = UVRoadblocksScrollPanel:Add("DButton")
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

                    if not LocalPlayer():IsSuperAdmin() then
                        notification.AddLegacy( "#uv.superadmin.settings", NOTIFY_ERROR, 5 )
                        surface.PlaySound( "buttons/button10.wav" )
                        return
                    end

                    SetClipboardText(selecteditem)

                    net.Start("UVRoadblocksLoad")
                    net.WriteInt(id, 32)
                    net.SendToServer()
                    notification.AddLegacy( string.format( language.GetPhrase("uv.tool.loaded"), selecteditem ), NOTIFY_UNDO, 5 )
                    surface.PlaySound( "buttons/button15.wav" )
                end
            end
        end

        timer.Simple(0, RefreshRoadblockList)

        hook.Add( "UVContentEvent", "UVRoadblocksTool_OnContentUpdate", function( operation, path, fileName )
            if path == "roadblocks>>"..game.GetMap() then
                RefreshRoadblockList()
            end
        end )
        
        local MarkAll = vgui.Create( "DButton", CPanel )
        MarkAll:SetText( "#tool.uvroadblock.markall" )
        MarkAll:SetSize( 280, 20 )
        MarkAll.DoClick = function( self )
            net.Start("UVRoadblocksMarkAll")
            net.SendToServer()
            notification.AddLegacy( "#tool.uvroadblock.markedall", NOTIFY_UNDO, 10 )
            surface.PlaySound( "buttons/button15.wav" )
        end
        CPanel:AddItem(MarkAll)

        local Refresh = vgui.Create( "DButton", CPanel )
        Refresh:SetText( "#refresh" )
        Refresh:SetSize( 280, 20 )
        Refresh.DoClick = function( self )
            UVRoadblocksScrollPanel:Clear()
            selecteditem = nil
            RefreshRoadblockList()
            surface.PlaySound( "buttons/button15.wav" )
        end
        CPanel:AddItem(Refresh)

        local Delete = vgui.Create( "DButton", CPanel )
        Delete:SetText( "#spawnmenu.menu.delete" )
        Delete:SetSize( 280, 20 )
        Delete.DoClick = function( self )
            
            if isstring(selecteditem) then
                net.Start("UVRoadblocksDeleteFile")
                net.WriteString("roadblocks>>"..game.GetMap())
                net.WriteString(selecteditem)
                net.SendToServer()
                notification.AddLegacy( string.format( language.GetPhrase("uv.tool.deleted"), selecteditem ), NOTIFY_UNDO, 5 )
                surface.PlaySound( "buttons/button15.wav" )
            end
            
            selecteditem = nil
        end
        CPanel:AddItem(Delete)

        CPanel:AddControl("Label", { Text = "" })
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

    local toolicon = Material( "hud/(8)roadblock.png", "ignorez" )

    function TOOL:DrawToolScreen(width, height)

        local ptselected = self:GetClientInfo("type")
        local RB_Strings = {
            ['Vehicle'] = '#tool.uvroadblock.type.vehicle',
            ['Concrete Barrier'] = '#tool.uvroadblock.type.concrete',
            ['Barricade'] = '#tool.uvroadblock.type.barricade',
            ['Sawhorse Barricade'] = '#tool.uvroadblock.type.sawhorse',
            ['Barrel'] = '#tool.uvroadblock.type.barrel',
            ['Cone'] = '#tool.uvroadblock.type.cone',
            ['Spikestrip'] = '#tool.uvroadblock.type.spikes',
            ['Explosive Barrel'] = '#tool.uvroadblock.type.explosivebarrel',
        }

        surface.SetDrawColor( Color( 0, 0, 0) )
        surface.DrawRect( 0, 0, width, height )
    
        surface.SetDrawColor( 0, 0, 255, 25)
        surface.SetMaterial( toolicon )
        surface.DrawTexturedRect( 0, 0, width, height )
        
        draw.SimpleText( (RB_Strings[ptselected] or ptselected), "DermaLarge", width / 2, height / 2, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    
    end

end

function TOOL:Think()
    if SERVER then return end

    local rbselected = self:GetClientInfo("type")
    local model = modeltable[rbselected]

    if not model or model == "" then
        if IsValid(self.GhostEntity) then
            self.GhostEntity:Remove()
            self.GhostEntity = nil
        end
        return
    end

    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    local tr = ply:GetEyeTrace()
    if not tr.Hit or ( IsValid( tr.Entity ) and tr.Entity:IsPlayer() ) then
        if IsValid(self.GhostEntity) then
            self.GhostEntity:SetNoDraw(true)
        end
        return
    end

    local ang = GetModelAngle(rbselected, ply:EyeAngles())
    local pos = tr.HitPos + Vector(0, 0, 1)

    if not IsValid(self.GhostEntity) or self.GhostEntity:GetModel() ~= model then
        if IsValid(self.GhostEntity) then
            self.GhostEntity:Remove()
        end

        self.GhostEntity = ClientsideModel(model, RENDERGROUP_TRANSLUCENT)
        if IsValid(self.GhostEntity) then
            self.GhostEntity:SetRenderMode(RENDERMODE_TRANSALPHA)
            self.GhostEntity:SetColor(Color(255, 255, 255, 150))
        end
    end

    if IsValid(self.GhostEntity) then
        self.GhostEntity:SetPos(pos)
        self.GhostEntity:SetAngles(ang)
        self.GhostEntity:SetNoDraw(false)
    end
end

function TOOL:Holster()
    if CLIENT and IsValid(self.GhostEntity) then
        self.GhostEntity:Remove()
        self.GhostEntity = nil
    end
end

function TOOL:RightClick(trace)
    if CLIENT then return true end
    
    local ent = trace.Entity
    local ply = self:GetOwner()
        
    if not istable(ply.UVRBTOOLMemory) then 
        ply.UVRBTOOLMemory = {}
    end
    
    if (ent:GetClass() ~= "prop_physics" and ent:GetClass() ~= "entity_uvspikestrip" and ent:GetClass() ~= "entity_uvroadblockcar" and ent:GetClass() ~= "entity_uvbombstrip") then return false end
    
    self:GetRoadblocksData( ent, ply, trace.HitPos )

    net.Start("UVRoadblocksAdjust")
    net.Send(ply)
    
    return true
end

function TOOL:LeftClick( trace )
    if CLIENT then return true end

    local rbselected = self:GetClientInfo("type")
    local ply = self:GetOwner()
    local tr = ply:GetEyeTrace()
    local ANGZ = ply:EyeAngles()

    local classname = proptable[rbselected] or "prop_physics"
    local prop = ents.Create(classname)

    if prop:GetClass() ~= "entity_uvspikestrip" and prop:GetClass() ~= "entity_uvroadblockcar" and prop:GetClass() ~= "entity_uvbombstrip" then
        if modeltable[rbselected] then
            prop:SetModel(modeltable[rbselected])
        end
    end

    prop:SetPos(tr.HitPos + Vector(0, 0, 1))
    prop:SetAngles(GetModelAngle(rbselected, ANGZ))
    prop:Spawn()
    prop.PhysgunDisabled = false

    if IsValid(prop:GetPhysicsObject()) then
        prop:GetPhysicsObject():EnableMotion(true)
        prop:GetPhysicsObject():Wake()
    end

    undo.Create(rbselected)
        undo.AddEntity(prop)
        undo.SetPlayer(ply)
    undo.Finish()
        
    return true
end

function TOOL:Reload( trace )
    if CLIENT then return false end

    local rbselected = self:GetClientInfo("type")
    
    if rbselected == rbtable[#rbtable] then
        self:GetOwner():ConCommand("uvroadblock_type "..rbtable[1])
    else
        for k,v in pairs(rbtable) do
            if v == rbselected then
                self:GetOwner():ConCommand("uvroadblock_type "..rbtable[k+1])
            end
        end
    end

    return false
end

function TOOL:GetRoadblocksData( ent, ply, location )
    if not IsValid(ent) then return end
    if not istable(ply.UVRBTOOLMemory) then ply.UVRBTOOLMemory = {} end

    ply.UVRBTOOLMemory = duplicator.Copy( ent )

    local Key = "Location"
    ply.UVRBTOOLMemory[Key] = location

    if not IsValid( ply ) then return end

    local clientrbtoolmemory = {
        PropCount = table.Count(ply.UVRBTOOLMemory.Entities),
        ConstraintCount = table.Count(ply.UVRBTOOLMemory.Constraints),
        VectorsMins = Vector(ply.UVRBTOOLMemory.Mins),
        VectorsMaxs = Vector(ply.UVRBTOOLMemory.Maxs),
    }
    
    net.Start("UVRoadblocksRetrieve")
    net.WriteTable( clientrbtoolmemory )
    net.Send( ply )

end