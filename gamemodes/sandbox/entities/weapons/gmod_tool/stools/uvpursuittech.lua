-- UNLOCALIZED NOTE: some notification strings below are unlocalized placeholders for easy localization later.
TOOL.Category      = "uv.unitvehicles"
TOOL.Name          = "#tool.uvpursuittech.name"
TOOL.Command       = nil
TOOL.ConfigName    = ""

-- ===================== Pursuit Tech Definitions ===============================
-- Display key should be used (may contain spaces). shortname used for convar keys.
local PursuitTechDefs = {
    ["EMP"] = {
        name = "#uv.ptech.emp",
        sname = "#uv.ptech.emp.short",
        shortname = "emp",
        description = "#uv.ptech.emp.desc",
        racer = true, unit = true,
        convars = {
            damage   = { default = 0.1, min = 0, max = 1, decimals = 1 },
            damagecommander = { default = 0.1, min = 0, max = 1, decimals = 1, nounit = true },
            force    = { default = 100, min = 0, max = 1000, decimals = 0 },
            cooldown = { default = 30, min = 0, max = 120, decimals = 0 },
            maxammo     = { default = 5, min = 0, max = 120, decimals = 0 },
            maxdistance = { default = 1000, min = 0, max = 5000, decimals = 0 }
        }
    },

    ["ESF"] = {
        name = "#uv.ptech.esf",
        sname = "#uv.ptech.esf.short",
        description = "#uv.ptech.esf.desc",
        shortname = "esf",
        racer = true, unit = true,
        convars = {
            duration = { default = 10, min = 1, max = 30, decimals = 0 },
            power    = { default = 1000000, min = 100000, max = 10000000, decimals = 0 },
            damage   = { default = 0.1, min = 0, max = 1, decimals = 1 },
            damagecommander = { default = 0.1, min = 0, max = 1, decimals = 1, nounit = true },
            cooldown = { default = 30, min = 0, max = 120, decimals = 0 },
            maxammo     = { default = 5, min = 0, max = 120, decimals = 0 }
        }
    },

    ["Power Play"] = {
        name = "#uv.ptech.powerplay",
        sname = "#uv.ptech.powerplay.short",
        description = "#uv.ptech.powerplay.desc",
        shortname = "powerplay",
        racer = true, unit = false,
        convars = {
            cooldown = { default = 30, min = 0, max = 120, decimals = 0 },
            maxammo     = { default = 5,  min = 0, max = 120, decimals = 0 }
        }
    },

    ["Killswitch"] = {
        name = "#uv.ptech.killswitch",
        sname = "#uv.ptech.killswitch.short",
        description = "#uv.ptech.killswitch.desc",
        shortname = "killswitch",
        racer = false, unit = true,
        convars = {
            lockontime      = { default = 3, min = 1, max = 10, decimals = 1 },
            disableduration = { default = 2.5, min = 1, max = 10, decimals = 1 },
            cooldown        = { default = 30, min = 0, max = 120, decimals = 0 },
            maxammo            = { default = 5, min = 0, max = 120, decimals = 0 }
        }
    },

    ["Repair Kit"] = {
        name = "#uv.ptech.repairkit",
        sname = "#uv.ptech.repairkit.short",
        description = "#uv.ptech.repairkit.desc",
        shortname = "repairkit",
        racer = true, unit = true,
        convars = {
            cooldown = { default = 30, min = 0, max = 120, decimals = 0 },
            maxammo     = { default = 5,  min = 0, max = 120, decimals = 0 }
        }
    },

    ["Shock Ram"] = {
        name = "#uv.ptech.shockram",
        sname = "#uv.ptech.shockram.short",
        description = "#uv.ptech.shockram.desc",
        shortname = "shockram",
        racer = false, unit = true,
        convars = {
            power    = { default = 1000000, min = 100000, max = 10000000, decimals = 0 },
            damage   = { default = 0.1, min = 0, max = 1, decimals = 1 },
            cooldown = { default = 30, min = 0, max = 120, decimals = 0 },
            maxammo     = { default = 5, min = 0, max = 120, decimals = 0 }
        }
    },

    ["Spikestrip"] = {
        name = "#uv.ptech.spikes",
        sname = "#uv.ptech.spikes.short",
        description = "#uv.ptech.spikes.desc",
        shortname = "spikestrip",
        racer = true, unit = true,
        convars = {
            damage   = { default = 0.1, min = 0, max = 1, decimals = 1 },
            damagecommander = { default = 0.1, min = 0, max = 1, decimals = 1, nounit = true },
            duration = { default = 60, min = 5, max = 120, decimals = 0 },
            cooldown = { default = 30, min = 0, max = 120, decimals = 0 },
            maxammo     = { default = 5,  min = 0, max = 120, decimals = 0 }
        }
    },

    ["GPS Dart"] = {
        name = "#uv.ptech.gpsdart",
        sname = "#uv.ptech.gpsdart.short",
        description = "#uv.ptech.gpsdart.desc",
        shortname = "gpsdart",
        racer = false, unit = true,
        convars = {
            duration = { default = 300, min = 1, max = 600, decimals = 0 },
            cooldown = { default = 30, min = 0, max = 120, decimals = 0 },
            maxammo     = { default = 5,  min = 0, max = 120, decimals = 0 }
        }
    },

    ["Juggernaut"] = {
        name = "#uv.ptech.juggernaut",
        sname = "#uv.ptech.juggernaut.short",
        description = "#uv.ptech.juggernaut.desc",
        shortname = "juggernaut",
        racer = true, unit = false,
        convars = {
            duration = { default = 10, min = 1, max = 30, decimals = 0 },
            cooldown = { default = 30, min = 0, max = 120, decimals = 0 },
            maxammo     = { default = 5,  min = 0, max = 120, decimals = 0 }
        }
    },

	["Ghost"] = {
        name = "#uv.ptech.ghost",
        sname = "#uv.ptech.ghost.short",
        description = "#uv.ptech.ghost.desc",
        shortname = "ghost",
        racer = true, unit = false,
        convars = {
            duration = { default = 5, min = 1, max = 30, decimals = 0 },
            cooldown = { default = 30, min = 0, max = 120, decimals = 0 },
            maxammo     = { default = 5,  min = 0, max = 120, decimals = 0 }
        }
    },

	["Grappler"] = {
        name = "#uv.ptech.grappler",
        sname = "#uv.ptech.grappler.short",
        description = "#uv.ptech.grappler.desc",
        shortname = "grappler",
        racer = false, unit = true,
        convars = {
            duration = { default = 10, min = 1, max = 30, decimals = 0 },
			disableduration = { default = 10, min = 1, max = 30, decimals = 0 },
			length = { default = 1000, min = 1, max = 5000, decimals = 0 },
			strength = { default = 10000, min = 1, max = 100000, decimals = 0 },
            cooldown = { default = 30, min = 0, max = 120, decimals = 0 },
            maxammo     = { default = 5,  min = 0, max = 120, decimals = 0 }
        }
    },
	
    ["Jammer"] = {
        name = "#uv.ptech.jammer",
        sname = "#uv.ptech.jammer.short",
        description = "#uv.ptech.jammer.desc",
        shortname = "jammer",
        racer = true, unit = false,
        convars = {
            duration = { default = 10, min = 1, max = 30, decimals = 0 },
            cooldown = { default = 30, min = 0, max = 120, decimals = 0 },
            maxammo     = { default = 5,  min = 0, max = 120, decimals = 0 }
        }
    },

    ["Shockwave"] = {
        name = "#uv.ptech.shockwave",
        sname = "#uv.ptech.shockwave.short",
        description = "#uv.ptech.shockwave.desc",
        shortname = "shockwave",
        racer = true, unit = false,
        convars = {
            power    = { default = 1000000, min = 100000, max = 10000000, decimals = 0 },
            damage   = { default = 0.1, min = 0, max = 1, decimals = 1 },
            damagecommander = { default = 0.1, min = 0, max = 1, decimals = 1, nounit = true },
            cooldown = { default = 30, min = 0, max = 120, decimals = 0 },
            maxammo     = { default = 5, min = 0, max = 120, decimals = 0 }
        }
    },

    ["Stunmine"] = {
        name = "#uv.ptech.stunmine",
        sname = "#uv.ptech.stunmine.short",
        description = "#uv.ptech.stunmine.desc",
        shortname = "stunmine",
        racer = true, unit = false,
        convars = {
            power    = { default = 1000000, min = 100000, max = 10000000, decimals = 0 },
            damage   = { default = 0.1, min = 0, max = 1, decimals = 1 },
            damagecommander = { default = 0.1, min = 0, max = 1, decimals = 1, nounit = true },
            cooldown = { default = 30, min = 0, max = 120, decimals = 0 },
            maxammo     = { default = 5, min = 0, max = 120, decimals = 0 }
        }
    },

}

-- ===================== Build lookup lists ===============================
local pttable_racer, pttable_unit, all_pt_displaylist = {}, {}, {}
for displayName, info in pairs(PursuitTechDefs) do
    if info.racer then table.insert(pttable_racer, displayName) end
    if info.unit then table.insert(pttable_unit, displayName) end
    table.insert(all_pt_displaylist, displayName)
end
table.sort(pttable_racer)
table.sort(pttable_unit)
table.sort(all_pt_displaylist)

-- ===================== Client ConVars ===============================
TOOL.ClientConVar = TOOL.ClientConVar or {}
-- slot defaults
TOOL.ClientConVar["racer_slot1"] = ""
TOOL.ClientConVar["racer_slot2"] = ""
TOOL.ClientConVar["unit_slot1"]  = ""
TOOL.ClientConVar["unit_slot2"]  = ""
TOOL.ClientConVar["racer_slot1_upgraded"] = 0
TOOL.ClientConVar["racer_slot2_upgraded"] = 0
TOOL.ClientConVar["unit_slot1_upgraded"] = 0
TOOL.ClientConVar["unit_slot2_upgraded"] = 0

-- generate per-PT convars
for displayName, info in pairs(PursuitTechDefs) do
    local short = info.shortname
    for param, dat in pairs(info.convars) do
        if info.racer then
            local key = short.."_"..param
            TOOL.ClientConVar[key] = TOOL.ClientConVar[key] or dat.default
        end
        if info.unit and not dat.nounit then
            local key = short.."_"..param.."_unit"
            TOOL.ClientConVar[key] = TOOL.ClientConVar[key] or dat.default
        end
    end
end

local conVarsDefault = TOOL:BuildConVarList()
local conVarList = table.GetKeys(conVarsDefault)

local RESTRICTED_CONVARS = {
    'uvpursuittech_racer_slot1',
    'uvpursuittech_racer_slot2',
    'uvpursuittech_unit_slot1',
    'uvpursuittech_unit_slot2'
}

local presetMap = {}

for _, convar in pairs( conVarList ) do
    local cv = GetConVar(convar)
    if cv then
        presetMap[convar] = cv:GetDefault()
    end
end

if SERVER then
    UV_DefinePresetTemplate('uvpursuittech', presetMap)
    local data = UV_SavePreset('uvpursuittech', 'Default', presetMap)
    UV_AddPreset('uvpursuittech', 'default.json', data)
end

-- ===================== Helpers ===============================
local function SanitizeForConvar(s)
    if not s then return "" end
    return string.lower(string.gsub(s, " ", ""))
end

local function IsSupportedVehicle(ent)
    if not IsValid(ent) then return false end
    return (ent.IsGlideVehicle or ent.IsSimfphyscar or ent:GetClass() == "prop_vehicle_jeep" or ent.LVS)
end

local function VehicleIsOccupied(ent)
    if not IsValid(ent) then return false end
    if ent:IsVehicle() then
        return ent:GetDriver() ~= nil and IsValid(ent:GetDriver())
    end
    return false
end

local function PlayerCanModifyPT(ply, ent)
    if not IsValid(ent) then return false end

    -- If vehicle is unoccupied, allow anyone to modify
    if not VehicleIsOccupied(ent) then
        return true
    end

    -- Optional: still allow superadmins to override
    if ply:IsSuperAdmin() then
        return true
    end

    return false
end

local PROTECTED_CONVARS = {
    'uvpursuittech_racer_slot1',
    'uvpursuittech_racer_slot2',
    'uvpursuittech_unit_slot1',
    'uvpursuittech_unit_slot2'
}

-- ===================== Client: Visuals & CPanel ===============================
if CLIENT then
    local function Export( name )
		local jsonArray = {
			['Name'] = name,
			['Data'] = {}
		}

		for _, cVarKey in pairs( conVarList ) do
			if table.HasValue( PROTECTED_CONVARS, cVarKey ) then continue end

			local cVar = GetConVar( cVarKey )
			if cVar then
				jsonArray.Data[cVarKey] = cVar:GetString()
			end
		end

		if not file.IsDir( 'unitvehicles/preset_import', 'DATA' ) then
			file.CreateDir( 'unitvehicles/preset_import' )
		end

		if not file.IsDir( 'unitvehicles/preset_import/uvpursuittech', 'DATA' ) then
			file.CreateDir( 'unitvehicles/preset_import/uvpursuittech' )
		end

		file.Write( 'unitvehicles/preset_import/uvpursuittech/' .. name .. '.json', util.TableToJSON( jsonArray ) )
		chat.AddText( Color( 0, 150, 0 ), "Your preset has been exported!\nDestination: data/unitvehicles/preset_import/uvpursuittech/" .. name .. ".json" )
	end

	-- if not file.IsDir( 'data/unitvehicles/preset_import', 'GAME' ) then
	-- 	file.CreateDir( 'unitvehicles/preset_import' )
	-- end

	-- if not file.IsDir( 'data/unitvehicles/preset_import/uvpursuittech', 'GAME' ) then
	-- 	file.CreateDir( 'unitvehicles/preset_import/uvpursuittech' )
	-- end

	-- timer.Simple(0, function()
	-- 	local importFiles, _ = file.Find( 'data/unitvehicles/preset_import/uvpursuittech/*', 'GAME' )
		
	-- 	for _, impFile in pairs( importFiles ) do
	-- 		local success = ProtectedCall(function()
	-- 			local data = util.JSONToTable( file.Read( 'data/unitvehicles/preset_import/uvpursuittech/' .. impFile, 'GAME' ) )
				
	-- 			if type(data) == 'table' and (data.Name and data.Data) then
	-- 				presets.Add( 
	-- 					'pursuittech', 
	-- 					data.Name, 
	-- 					data.Data 
	-- 				)
	-- 			else
	-- 				error('Malformed JSON data!')
	-- 			end

	-- 			file.Delete( 'unitvehicles/preset_import/uvpursuittech/' .. impFile, 'DATA' )
	-- 		end)

	-- 		if success then
	-- 			MsgC( Color(0, 255, 0), "[Unit Vehicles (uvpursuittech)]: Added \"" .. string.Split( impFile, '.json' )[1] .. "\" to the presets!\n" )
	-- 		else
	-- 			MsgC( Color(255, 0, 0), "[Unit Vehicles (uvpursuittech)]: Failed to add \"" .. string.Split( impFile, '.json' )[1] .. "\" to the presets!\n" )
	-- 		end
	-- 	end
	-- end)

	TOOL.Information = {
		{ name = "info" },
		{ name = "left" },
		{ name = "right" },
	}
	
    -- 3D2D draw above vehicle
    hook.Add("PostDrawTranslucentRenderables", "UVPursuitTech_DrawVehicleText", function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return end
        local wep = ply:GetActiveWeapon()
        local tool = ply:GetTool()
        local tr = ply:GetEyeTrace()
        local ent = tr.Entity

        if not IsValid(wep) or wep:GetClass() ~= "gmod_tool" then return end
        if not tool or tool.Mode ~= "uvpursuittech" then return end

        local PT_Replacement_Strings = {}
        for displayName, info in pairs(PursuitTechDefs) do
            PT_Replacement_Strings[displayName] = info.name or displayName
        end

        if IsValid(ent) and (ent:IsVehicle() or ent.LVS) and tr.HitPos:DistToSqr(ply:GetPos()) < 50000 then
            local pos = ent:GetPos() + Vector(0,0,80)
            local ang = Angle(0, EyeAngles().y - 90, 90)
            local tech1, tech2 = " ", " "
            if ent.PursuitTech then
                if ent.PursuitTech[1] and ent.PursuitTech[1].Tech then tech1 = PT_Replacement_Strings[ent.PursuitTech[1].Tech] or ent.PursuitTech[1].Tech end
                if ent.PursuitTech[2] and ent.PursuitTech[2].Tech then tech2 = PT_Replacement_Strings[ent.PursuitTech[2].Tech] or ent.PursuitTech[2].Tech end
            end
            cam.Start3D2D(pos, ang, 0.2)
                draw.SimpleTextOutlined("#uv.ptech", "DermaLarge", 0, 20, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
                draw.SimpleTextOutlined(tech1, "DermaLarge", -27.5, 50, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
                draw.SimpleTextOutlined("< | >", "DermaLarge", 0, 50, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
                draw.SimpleTextOutlined(tech2, "DermaLarge", 30, 50, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
            cam.End3D2D()
        end
    end)

    local toolicon_racer = Material("unitvehicles/icons/(9)T_UI_PlayerRacer_Large_Icon.png", "ignorez")
    local toolicon_unit  = Material("unitvehicles/icons/(9)T_UI_PlayerCop_Large_Icon.png", "ignorez")

    function TOOL:DrawToolScreen(width, height)
        local racer_s1 = self:GetClientInfo("racer_slot1")
        local racer_s2 = self:GetClientInfo("racer_slot2")
        local unit_s1  = self:GetClientInfo("unit_slot1")
        local unit_s2  = self:GetClientInfo("unit_slot2")

        surface.SetDrawColor(Color(0,0,0))
        surface.DrawRect(0,0,width,height)

        -- Racer top
        surface.SetDrawColor(255,132,0,25)
        surface.SetMaterial(toolicon_racer)
        surface.DrawTexturedRect(width*0.3,height*0.1,width*0.4,height*0.4)
        draw.SimpleText("#tool.uvpursuittech.tg.racer", "UVFont4BiggerItalic2", width*0.5, height*0.175, Color(255,132,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("|", "UVFont4", width*0.5, height*0.3, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText((PursuitTechDefs[racer_s1] and PursuitTechDefs[racer_s1].sname or racer_s1), "UVFont4", width*0.475, height*0.3, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText((PursuitTechDefs[racer_s2] and PursuitTechDefs[racer_s2].sname or racer_s2), "UVFont4", width*0.525, height*0.3, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        -- Unit bottom
        surface.SetDrawColor(125,125,255,50)
        surface.SetMaterial(toolicon_unit)
        surface.DrawTexturedRect(width*0.3,height*0.6,width*0.4,height*0.4)
        draw.SimpleText("#tool.uvpursuittech.tg.unit", "UVFont4BiggerItalic2", width*0.5, height*0.675, Color(125,125,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("|", "UVFont4", width*0.5, height*0.8, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText((PursuitTechDefs[unit_s1] and PursuitTechDefs[unit_s1].sname or unit_s1), "UVFont4", width*0.475, height*0.8, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText((PursuitTechDefs[unit_s2] and PursuitTechDefs[unit_s2].sname or unit_s2), "UVFont4", width*0.525, height*0.8, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    -- BuildCPanel
	function TOOL.BuildCPanel(CPanel)
		CPanel:ClearControls()
		-- CPanel:AddControl("Label", {Text=" "})
		CPanel:AddControl("Label", {Text="#tool.uvpursuittech.menu.desc"})

		-- ===== Racer slots =====
		CPanel:AddControl("Label",{Text="#tool.uvpursuittech.slot.racer"})

		local slotCombos = {}

		local function CreateSlotCombo(varname, list)
			local combo = vgui.Create("DComboBox")
			combo:SetTextColor(Color(0,0,0))

			local convarName = "uvpursuittech_" .. varname
			local currentValue = ConVarExists(convarName) and GetConVar(convarName):GetString() or ""

			-- Visible "None" option, true blank data, no tooltip
			local noneLabel = "#uv.none"
			combo:AddChoice(noneLabel, "")

			-- Add all Pursuit Tech options
			for _, v in ipairs(list) do
				local info = PursuitTechDefs[v]
				if info then
					combo:AddChoice(info.name, v)
				else
					combo:AddChoice(v, v)
				end
			end

			-- Map current convar to display value
			local displayValue = noneLabel
			if currentValue ~= "" and PursuitTechDefs[currentValue] then
				displayValue = PursuitTechDefs[currentValue].name
			end
			combo:SetValue(displayValue)

			-- Tooltip for current value (skip for None)
			if currentValue ~= "" and PursuitTechDefs[currentValue] then
				combo:SetToolTip(PursuitTechDefs[currentValue].description or "")
			else
				combo:SetToolTip("")
			end

			-- Handle selection
			combo.OnSelect = function(pnl, idx, val, data)
				if data and data ~= "" then
					RunConsoleCommand(convarName, data)
					if PursuitTechDefs[data] then
						combo:SetToolTip(PursuitTechDefs[data].description or "")
					else
						combo:SetToolTip("")
					end
				else
					-- None selected
					RunConsoleCommand(convarName, "")
					combo:SetToolTip("")       -- no tooltip
					combo:SetValue(noneLabel)  -- display label
				end
			end

			CPanel:AddItem(combo)
			slotCombos[varname] = combo
			return combo
		end

		local racerSlot1Combo = CreateSlotCombo("racer_slot1", pttable_racer)
		CPanel:AddControl("CheckBox", {
			Label = "#tool.uvpursuittech.upgraded",
			Command = "uvpursuittech_racer_slot1_upgraded"
		})
		local racerSlot2Combo = CreateSlotCombo("racer_slot2", pttable_racer)
		CPanel:AddControl("CheckBox", {
			Label = "#tool.uvpursuittech.upgraded",
			Command = "uvpursuittech_racer_slot2_upgraded"
		})

		-- ===== Unit slots =====
		CPanel:AddControl("Label", {Text=" "})
		CPanel:AddControl("Label",{Text="#tool.uvpursuittech.slot.unit"})
		local unitSlot1Combo = CreateSlotCombo("unit_slot1", pttable_unit)
		CPanel:AddControl("CheckBox", {
			Label = "#tool.uvpursuittech.upgraded",
			Command = "uvpursuittech_unit_slot1_upgraded"
		})
		local unitSlot2Combo = CreateSlotCombo("unit_slot2", pttable_unit)
		CPanel:AddControl("CheckBox", {
			Label = "#tool.uvpursuittech.upgraded",
			Command = "uvpursuittech_unit_slot2_upgraded"
		})

		-- ===== Settings PT picker =====
		CPanel:AddControl("Label",{Text=" "})
		CPanel:AddControl("Label",{Text="#tool.uvpursuittech.settings"})
		CPanel:AddControl("Label",{Text="#tool.uvpursuittech.settings.desc"})

		-- ===== Preset =====
		-- CPanel:AddControl("ComboBox", {
		-- 	MenuButton = 1,
		-- 	Folder = "pursuittech",
		-- 	Options = { ["#preset.default"] = conVarsDefault },
		-- 	CVars = table.GetKeys(conVarsDefault)
		-- })

        local presetPicker = vgui.Create("DComboBox")
        presetPicker:SetText("Select a preset to load")
        presetPicker:SetTextColor(Color(0,0,0))
        --presetPicker:AddChoice("default", "default")

        local function fetchPresets()
            presetPicker:Clear()

            local presets = UVPresets["uvpursuittech"]

            for file, name in pairs( presets ) do
                presetPicker:AddChoice(name, file)
            end
        end

        function presetPicker:OnSelect( index, value, data )
            net.Start("UVPresets_Load")
            net.WriteString("uvpursuittech")
            net.WriteString(data)
            net.SendToServer()
        end

        fetchPresets()
        hook.Add("UVPresetsEvent", "UVPursuitTech_FetchPresets", function(event, type, data)
            if type ~= "uvpursuittech" then return end
            if event == "Add" or event == "Remove" or event == "Set" then
                fetchPresets()
            end
        end)

        CPanel:AddItem(presetPicker)

		CPanel:AddControl("Label",{Text=" "})

        local exportsettings = vgui.Create("DButton")
		exportsettings:SetText("Save Settings as Preset")
		exportsettings.DoClick = function()
            if not LocalPlayer():IsSuperAdmin() then
                notification.AddLegacy("#tool.uvpursuitbreaker.needsuperadmin", NOTIFY_ERROR, 5)
                surface.PlaySound("buttons/button10.wav")
                return
            end

			Derma_StringRequest("#tool.uvracemanager.export", "What should the preset be named?", cpID, function(txt)
				chat.AddText("Exporting preset...")
				net.Start("UVPresets_Save")
				net.WriteString("uvpursuittech")
				net.WriteString(txt)
				net.SendToServer()
			end, nil, "#addons.confirm", "#addons.cancel")
		end
		CPanel:AddItem(exportsettings)
		
		local ptPicker = vgui.Create("DComboBox")
		ptPicker:SetText("#tool.uvpursuittech.select")
		ptPicker:SetTextColor(Color(0,0,0))

		local selectedPT = nil
		for _, displayName in ipairs(all_pt_displaylist) do
			local info = PursuitTechDefs[displayName]
			local displayText = (info and info.name) or displayName
			ptPicker:AddChoice(displayText, displayName) -- localized display
		end
		CPanel:AddItem(ptPicker)

		-- ===== Parameter sliders panel =====
		local paramsPanel = vgui.Create("DPanel")
		paramsPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,255))
		end
		CPanel:AddItem(paramsPanel)

		local sliders = {}
		local function ClearSliders()
			for _,s in ipairs(sliders) do if IsValid(s) then s:Remove() end end
			sliders = {}
		end

		local function BuildSlidersForPT(displayName)
			ClearSliders()
			paramsPanel:Clear()
			local info = PursuitTechDefs[displayName]
			if not info then return end
			selectedPT = displayName

			local y = 0
			local function AddSlider(param, dat, isUnit)
				local cvKey = "uvpursuittech_" .. info.shortname.."_"..param .. (isUnit and "_unit" or "")
				-- if not ConVarExists(cvKey) then
				-- 	CreateClientConVar(cvKey, tostring(dat.default), true, false)
				-- end
				local slider = vgui.Create("DNumSlider", paramsPanel)
				slider:SetPos(4, y)
				slider:SetSize(paramsPanel:GetWide() - 8, 30)
				slider:SetMin(dat.min)
				slider:SetMax(dat.max)
				slider:SetDecimals(dat.decimals)
				--slider:SetConVar(cvKey)
				local cv = GetConVar(cvKey)
				slider:SetValue(cv and cv:GetFloat() or dat.default)
				slider:SetText("#uv.ptech." .. param)
				slider:SetToolTip("#uv.ptech." .. param .. ".desc")
				slider:SetFGColor(Color(0,0,0))
				y = y + 34

                local lastValue = slider:GetValue()

                function slider:Think()
                    if not self:IsEditing() and lastValue ~= self:GetValue() then
                        lastValue = self:GetValue()
                        net.Start("UVUpdateSettings")
                        net.WriteTable({ [cvKey] = lastValue })
                        net.SendToServer()
                    end
                end

                function slider:OnValueChanged( val )
                    print(self:IsEditing(), val)
                end

				table.insert(sliders, slider)
			end

			-- Racer sliders
			if info.racer then
				local lab = vgui.Create("DLabel", paramsPanel)
				lab:SetText("#tool.uvpursuittech.slot.racer")
				lab:SetPos(4,y); lab:SizeToContents(); y=y+20
				lab:SetTextColor(Color(255,132,0))
				table.insert(sliders, lab)
				for param, dat in pairs(info.convars) do
					AddSlider(param, dat, false)
				end
			end

			-- Unit sliders
			if info.unit then
				if info.racer then
					local sep = vgui.Create("DLabel", paramsPanel)
					sep:SetText(" "); sep:SetPos(4,y); sep:SizeToContents(); y=y+18
					sep:SetTextColor(Color(0,0,0))
					table.insert(sliders, sep)
				end
				local lab2 = vgui.Create("DLabel", paramsPanel)
				lab2:SetText("#tool.uvpursuittech.slot.unit"); lab2:SetPos(4,y); lab2:SizeToContents(); y=y+20
				lab2:SetTextColor(Color(125,125,255))
				table.insert(sliders, lab2)
				for param, dat in pairs(info.convars) do
                    if not dat.nounit then
					    AddSlider(param, dat, true)
                    end
				end
			end

			paramsPanel:SetTall(y + 4)
		end

		ptPicker.OnSelect = function(pnl,index,value,data)
			BuildSlidersForPT(data)
		end

		-- ===== Refresh slot combos =====
		local function RefreshSlots()
			for varname, combo in pairs(slotCombos) do
				local convar = "uvpursuittech_"..varname
				if ConVarExists(convar) then
					combo:SetValue(GetConVar(convar):GetString())
				else
					combo:SetValue("")
				end
			end
		end

		-- ===== Apply Settings button =====
		-- local applysettings = vgui.Create("DButton")
		-- applysettings:SetText("#spawnmenu.savechanges")
		-- applysettings.DoClick = function()
		-- 	if not LocalPlayer():IsSuperAdmin() then
		-- 		notification.AddLegacy("#tool.uvpursuitbreaker.needsuperadmin", NOTIFY_ERROR, 5)
		-- 		surface.PlaySound("buttons/button10.wav")
		-- 		return
		-- 	end

		-- 	local convar_table = {}
		-- 	for displayName, info in pairs(PursuitTechDefs) do
		-- 		for param, dat in pairs(info.convars) do
		-- 			local racerKey = "uvpursuittech_" .. info.shortname .. "_" .. param
		-- 			if not ConVarExists(racerKey) then
		-- 				CreateClientConVar(racerKey, tostring(dat.default), true, false)
		-- 			end
		-- 			if info.racer then
		-- 				convar_table[racerKey] = GetConVar(racerKey):GetFloat()
		-- 			end

		-- 			if info.unit and not dat.nounit then
		-- 				local unitKey = racerKey .. "_unit"
		-- 				if not ConVarExists(unitKey) then
		-- 					CreateClientConVar(unitKey, tostring(dat.default), true, false)
		-- 				end
		-- 				convar_table[unitKey] = GetConVar(unitKey):GetFloat()
		-- 			end
		-- 		end
		-- 	end

		-- 	RefreshSlots()

		-- 	net.Start("UVUpdateSettings")
		-- 	net.WriteTable(convar_table)
		-- 	net.SendToServer()
		-- 	notification.AddLegacy("#uv.tool.applied", NOTIFY_UNDO,5)
		-- 	surface.PlaySound("buttons/button15.wav")
		-- 	-- Msg("#uv.tool.applied")
		-- end
		-- CPanel:AddItem(applysettings)
	end
end -- CLIENT

-- ===================== Shared: LeftClick / RightClick ===============================
function TOOL:LeftClick(trace)
    local car = trace.Entity
    if not IsValid(car) then return false end
    if not IsSupportedVehicle(car) then return false end
	if not PlayerCanModifyPT(self:GetOwner(), car) then
		-- print("[UVPursuitTech] Vehicle is occupied, cannot apply PT for", self:GetOwner())
		return false
	end

    if CLIENT then return false end

    -- Choose correct slot convar based on vehicle type
    local ptSlot1, ptSlot2, upgradedSlot1, upgradedSlot2
    if car.UnitVehicle then
        ptSlot1 = self:GetClientInfo("unit_slot1") or ""
        ptSlot2 = self:GetClientInfo("unit_slot2") or ""
		upgradedSlot1 = self:GetClientNumber("unit_slot1_upgraded") == 1
		upgradedSlot2 = self:GetClientNumber("unit_slot2_upgraded") == 1
    else
        ptSlot1 = self:GetClientInfo("racer_slot1") or ""
        ptSlot2 = self:GetClientInfo("racer_slot2") or ""
		upgradedSlot1 = self:GetClientNumber("racer_slot1_upgraded") == 1
		upgradedSlot2 = self:GetClientNumber("racer_slot2_upgraded") == 1
    end

    if not car.PursuitTech then car.PursuitTech = {} end

	for slot = 1, 2 do
		local ptselected = slot == 1 and ptSlot1 or ptSlot2

		-- Skip if blank or invalid
		if ptselected == "" or not PursuitTechDefs[ptselected] then
			UVRemovePursuitTech( car, slot )
		else
			-- Skip second slot if same as first
			if slot == 2 and ptselected == ptSlot1 then
				UVRemovePursuitTech( car, slot )
				continue  -- skip the rest of the loop for slot 2
			end

			-- Apply PT normally
			-- local info = PursuitTechDefs[ptselected]
			-- local short = (info and info.shortname) or string.lower(ptselected:gsub(" ", ""))

			-- local ammo_cv = (car.UnitVehicle and "uvpursuittech_"..short.."_maxammo_unit" or "uvpursuittech_"..short.."_maxammo")
			-- local cooldown_cv = (car.UnitVehicle and "uvpursuittech_"..short.."_cooldown_unit" or "uvpursuittech_"..short.."_cooldown")

			-- local ammo_val, cd_val = math.huge, 30
			-- if ConVarExists(ammo_cv) then
			-- 	local cv = GetConVar(ammo_cv)
			-- 	if cv then ammo_val = cv:GetInt() end
			-- end
			-- if ConVarExists(cooldown_cv) then
			-- 	local cv2 = GetConVar(cooldown_cv)
			-- 	if cv2 then cd_val = cv2:GetInt() end
			-- end

			-- car.PursuitTech[slot] = {
			-- 	Tech     = ptselected,
			-- 	Ammo     = ammo_val,
			-- 	Cooldown = cd_val,
			-- 	LastUsed = -math.huge,
			-- }

			-- UVReplicatePT(car, slot)

			local upgraded = upgradedSlot2
			if slot == 1 then
				upgraded = upgradedSlot1
			end
            UVAddPursuitTech(car, ptselected, slot, nil, nil, upgraded)
		end
	end

    -- freeze effect
    local eff = EffectData()
    eff:SetEntity(car)
    util.Effect("phys_freeze", eff)

    if not table.HasValue(UVRVWithPursuitTech, car) then
        table.insert(UVRVWithPursuitTech, car)
        car:CallOnRemove("UVRVWithPursuitTechRemoved", function(ent)
            if table.HasValue(UVRVWithPursuitTech, ent) then table.RemoveByValue(UVRVWithPursuitTech, ent) end
        end)
    end

    -- -- replicate both slots
    -- UVReplicatePT(car, 1)
    -- UVReplicatePT(car, 2)

    return true
end

-- RightClick removal
function TOOL:RightClick(trace)
    local car = trace.Entity
    if not IsValid(car) then return false end
    if not IsSupportedVehicle(car) then return false end
    if CLIENT then return false end
	if not PlayerCanModifyPT(self:GetOwner(), car) then return false end

    -- Completely remove Pursuit Tech from this vehicle
    -- if car.PursuitTech then
    --     car.PursuitTech = nil
    -- end
    UVRemovePursuitTech( car, 1 )
    UVRemovePursuitTech( car, 2 )

    -- Remove from active PursuitTech tracking list
    if table.HasValue(UVRVWithPursuitTech, car) then
        table.RemoveByValue(UVRVWithPursuitTech, car)
    end

    -- Replicate cleared state to all clients
    -- UVReplicatePT(car, 1)
    -- UVReplicatePT(car, 2)

    -- Optional: visual feedback
    local eff = EffectData()
    eff:SetEntity(car)
    util.Effect("phys_unfreeze", eff)

    -- Optional: notification or sound for admins
    sound.Play("buttons/button10.wav", car:GetPos())

    return true
end

function TOOL:Reload(trace)
    return false
end
