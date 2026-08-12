UV = UV or {}
UVMenu = UVMenu or {}
UV.SettingsTable = UV.SettingsTable or {}

-- Global API for third-party sounds and addons
UVMenu.Sounds = UVMenu.Sounds or {}
UVMenu.SoundProfiles = UVMenu.SoundProfiles or {}
UVMenu.AddonEntries = UVMenu.AddonEntries or {}

function UVMenuSound(data)
    if not istable(data) then return end
    if not isstring(data.name) then return end
    if not istable(data.sounds) then return end

    local id = data.name

    -- Prevent accidental overwrite (optional)
    if UVMenu.Sounds[id] then
        return
    end

    -- Store sounds
    UVMenu.Sounds[id] = data.sounds

    -- Store display info
    UVMenu.SoundProfiles[id] = {
        displayname = data.displayname or id
    }
end

function UVAddon(rows)
	if not istable(rows) then return end

	local block = {}

	for _, row in ipairs(rows) do
		if istable(row) then
			table.insert(block, row)
		end
	end

	if #block > 0 then
		table.insert(UVMenu.AddonEntries, block)
	end
end

--[[ Examples:
UVAddon({
	{ 
	type = "label", <-- Type
	text = "NAME", <-- Menu String
	desc = "DESC", <-- Description String
	convar = "CV", <-- Console Variable
	sv = true, <-- Server variable (hidden to Clients)
	},
})

Types: 
"info" - Simple information panel.

"infosimple" - Less advanced information panel with centered text.

"info_flags" - Information panel with flags! Uses "entries".
	∟ "entries" - Set up like this:

entries = {
	{ flag = "flagcode", desc = "DESC", name = "NAME" }
}

"image" - Displays an image.
	∟ "image" - Path to image.

"label" - Inserts a label header with a solid background.

"bool" - Inserts an on/off toggle button.

"slider" - Inserts a numerical slider with a confirmation box.
	∟ "min" / "max" / "decimals" are required. Full numbers only.
	∟ "func = function() <Code> end" - Runs the code inside whenever the confirm button is pressed.

"combo" - Inserts a dropdown box with options.
	∟ "content" - A table of contents, done like this:
	
	content = {
		{ "Option 1", "Variable" },
		{ "Option 2", "Variable" },
		{ "Option 3", "Variable" },
	}

"button" - Inserts a clickable button.
	∟ "func = function() <Code> end" - Runs the code inside whenever the button is pressed.
	
"buttonsw" - Inserts a clickable button which you can manipulate using your Scrollwheel.
	∟ "min" / "max" / "start" are required. Full numbers only.
	∟ "func = function() <Code> end" - Runs the code inside whenever the button is pressed.
	∟ "text" needs to have a "%s" in it to display properly. If a string, use "UVString(<string>)". Still works without it, however.
	
"color" / "coloralpha" - Inserts a color selector. Supports RGB and alpha.
	∟ Requires "convar" to have "_r", "_g" and "_b" versions. "_a" is optional for alpha.
	
"timer" - Inserts a timer that sends its function when it reaches 0.
	∟ "duration" - Controls the duration of the timer.
	∟ "text" needs a "%s" in it to display the timer proprely. Still works without it, however.
]]--

if vcmod_main then -- VCMod ELS
	UVAddon({
		{ type = "label", text = "VCMod ELS", sv = true },
		{ type = "bool", text = "uv.vcmod.els", desc = "uv.vcmod.els.desc", convar = "unitvehicle_vcmodelspriority", sv = true },
	})
end

if cffunctions then -- Glide // Circular Functions
	UVAddon({
		{ type = "label", text = "Glide // Circular Functions", sv = true },
		{ type = "bool", text = "uv.ailogic.usenitrousracer", desc = "uv.ailogic.usenitrousracer.desc", convar = "unitvehicle_usenitrousracer", sv = true },
		{ type = "bool", text = "uv.ailogic.usenitrousunit", desc = "uv.ailogic.usenitrousunit.desc", convar = "unitvehicle_usenitrousunit", sv = true },
	})
end

if LVS then -- LVS
	UVAddon({
		{ type = "label", text = "LVS", sv = true },
		{ type = "bool", text = "uv.lvs.alwaysfullthrottle", desc = "uv.lvs.alwaysfullthrottle.desc", convar = "unitvehicle_lvsalwaysfullthrottle" },
	})
end

UVMenuSound({
    name = "MW",
    displayname = "NFS Most Wanted",
    sounds = {
        menuopen  = "uvui/mw/fe_common_mb [8].wav",
        menuclose = "uvui/mw/fe_common_mb [9].wav",
        hover     = "uvui/mw/fe_common_mb [1].wav",
        hovertab  = "uvui/mw/fe_common_mb [2].wav",
        click     = "uvui/mw/fe_common_mb [8].wav",
        clickopen = "uvui/mw/fe_common_mb [3].wav",
        clickback = "uvui/mw/fe_common_mb [4].wav",
        confirm   = "uvui/mw/fe_common_mb [5].wav"
    }
})

UVMenuSound({
    name = "Carbon",
    displayname = "NFS Carbon",
    sounds = {
        menuopen  = "uvui/carbon/fe_mb [1].wav",
        menuclose = "uvui/carbon/fe_common_mb [10].wav",
        hover     = "uvui/carbon/fe_common_mb [1].wav",
        hovertab  = "uvui/carbon/fe_common_mb [2].wav",
        click     = "uvui/carbon/fe_common_mb [8].wav",
        clickopen = "uvui/carbon/fe_common_mb [5].wav",
        clickback = "uvui/carbon/fe_common_mb [6].wav",
        confirm   = "uvui/carbon/fe_common_mb [5].wav"
    }
})

UVMenuSound({
    name = "MC2",
    displayname = "Midnight Club 2",
    sounds = {
        menuopen  = "uvui/MC2/ui_flyin.wav",
        menuclose = "uvui/MC2/off_screen.wav",
        hover     = "uvui/MC2/leftright_alt.wav",
        hovertab  = "uvui/MC2/updown_alt.wav",
        click     = "uvui/MC2/save_game_select_22k.wav",
        clickopen = "uvui/MC2/save_game_select_22k.wav",
        clickback = "uvui/MC2/point_dropped_16k.wav",
        confirm   = "uvui/MC2/time_added_appear_18k.wav"
    }
})

UVMenuSound({
    name = "MC3",
    displayname = "Midnight Club 3",
    sounds = {
        menuopen  = "uvui/MC3/Hud_MC31.wav",
        menuclose = "uvui/MC3/Hud_MC3Close.wav",
        hover     = "uvui/MC3/Hud_MC32.wav",
        hovertab  = "uvui/MC3/Hud_MC32.wav",
        click     = "uvui/MC3/Hud_MC32.wav",
        clickopen = "uvui/MC3/Hud_MC33.wav",
        clickback = "uvui/MC3/Hud_MC3open.wav",
        confirm   = "uvui/MC3/Hud_MC32.wav"
    }
})

UVMenuSound({
    name = "HP2",
    displayname = "Hot Pursuit 2",
    sounds = {
       menuopen  = "uvui/HP2/fesfx#1.wav",
        menuclose = "uvui/HP2/fesfx#14.wav",
        hover     = "uvui/HP2/fesfx#11.wav",
        hovertab  = "uvui/HP2/fesfx#11.wav",
        click     = "uvui/HP2/fesfx#11.wav",
        clickopen = "uvui/HP2/fesfx#8.wav",
        clickback = "uvui/HP2/fesfx#15.wav",
        confirm   = "uvui/HP2/fesfx#1.wav"
    }
})

UVMenuSound({
    name = "HS",
    displayname = "High Stakes",
    sounds = {
       menuopen  = "uvui/HS/ZFESFX8.wav",
        menuclose = "uvui/HS/ZFESFX9.wav",
        hover     = "uvui/HS/ZFESFX5.wav",
        hovertab  = "uvui/HS/ZFESFX5.wav",
        click     = "uvui/HS/ZFESFX1.wav",
        clickopen = "uvui/HS/ZFESFX9.wav",
        clickback = "uvui/HS/ZFESFX9.wav",
        confirm   = "uvui/HS/ZFESFX1.wav"
    }
})


-- if cffunctions then -- Hero's Glide Extras
	-- UVAddon({
		-- { type = "label", text = "Hero's Glide Extras", sv = true },
		-- { type = "bool", 
		-- text = "Allow Vehicle Exit in Pursuits", 
		-- desc = "If enabled, allow the user to exit their vehicle while in the middle of Pursuits, even while being busted, fined or in cooldown.\n\nNote: Does not disable Pursuits or Units - only restores the ability to exit vehicles.",
		-- convar = "unitvehicle_usenitrousracer", sv = true },
	-- })
-- end

-- Sounds Table
UVMenu.Sounds = {
    ["MW"] = {
        menuopen = "uvui/mw/fe_common_mb [8].wav",
        menuclose = "uvui/mw/fe_common_mb [9].wav",
        hover = "uvui/mw/fe_common_mb [1].wav",
        hovertab = "uvui/mw/fe_common_mb [2].wav",
        click = "uvui/mw/fe_common_mb [8].wav",
        clickopen = "uvui/mw/fe_common_mb [3].wav",
        clickback = "uvui/mw/fe_common_mb [4].wav",
        confirm = "uvui/mw/fe_common_mb [5].wav"
    },
    ["Carbon"] = {
        menuopen = "uvui/carbon/fe_mb [1].wav",
        menuclose = "uvui/carbon/fe_common_mb [10].wav",
        hover = "uvui/carbon/fe_common_mb [1].wav",
        hovertab = "uvui/carbon/fe_common_mb [2].wav",
        click = "uvui/carbon/fe_common_mb [8].wav",
        clickopen = "uvui/carbon/fe_common_mb [5].wav",
        clickback = "uvui/carbon/fe_common_mb [6].wav",
        confirm = "uvui/carbon/fe_common_mb [5].wav"
    },
	["MC2"] = {
        menuopen  = "uvui/MC2/ui_flyin.wav",
        menuclose = "uvui/MC2/off_screen.wav",
        hover     = "uvui/MC2/leftright_alt.wav",
        hovertab  = "uvui/MC2/updown_alt.wav",
        click     = "uvui/MC2/save_game_select_22k.wav",
        clickopen = "uvui/MC2/save_game_select_22k.wav",
        clickback = "uvui/MC2/point_dropped_16k.wav",
        confirm   = "uvui/MC2/time_added_appear_18k.wav"
    },
	["MC3"] = {
        menuopen  = "uvui/MC3/Hud_MC31.wav",
        menuclose = "uvui/MC3/Hud_MC3Close.wav",
        hover     = "uvui/MC3/Hud_MC32.wav",
        hovertab  = "uvui/MC3/Hud_MC32.wav",
        click     = "uvui/MC3/Hud_MC32.wav",
        clickopen = "uvui/MC3/Hud_MC33.wav",
        clickback = "uvui/MC3/Hud_MC3open.wav",
        confirm   = "uvui/MC3/Hud_MC32.wav"
    },
	["HP2"] = {
        menuopen  = "uvui/HP2/fesfx#1.wav",
        menuclose = "uvui/HP2/fesfx#14.wav",
        hover     = "uvui/HP2/fesfx#11.wav",
        hovertab  = "uvui/HP2/fesfx#11.wav",
        click     = "uvui/HP2/fesfx#11.wav",
        clickopen = "uvui/HP2/fesfx#8.wav",
        clickback = "uvui/HP2/fesfx#15.wav",
        confirm   = "uvui/HP2/fesfx#1.wav"
    },
	["HS"] = {
       menuopen  = "uvui/HS/ZFESFX8.wav",
        menuclose = "uvui/HS/ZFESFX9.wav",
        hover     = "uvui/HS/ZFESFX5.wav",
        hovertab  = "uvui/HS/ZFESFX5.wav",
        click     = "uvui/HS/ZFESFX1.wav",
        clickopen = "uvui/HS/ZFESFX9.wav",
        clickback = "uvui/HS/ZFESFX9.wav",
        confirm   = "uvui/HS/ZFESFX1.wav"
	}
}

--[[ 
UVMenu Framework
Single-file menu system for Garry's Mod
Author: Adapted from UnitVehicles Settings menu
]]

--[[ UVMenu:Open
    config = {
        Title = "Menu title",
        Width = 800,
        Height = 600,
        MainColor = Color(...),
        PanelColor = Color(...),
        AccentColor = Color(...),
        TitleFont = "fontname",
        ItemFont = "fontname",
        Description = true/false,
        Tabs = { {name="tab1", items={...}}, ... }
    }
--]]

-- Store all menus globally
UVMenu.Menus = UVMenu.Menus or {}

-- [[ Start of Menu ConVars ]] --
-- Sounds
CreateClientConVar("uvmenu_sound_enabled", 1, true, false)
CreateClientConVar("uvmenu_sound_set", "MW", true, false)

-- Background
CreateClientConVar("uvmenu_hide_description", 0, true, false)
CreateClientConVar("uvmenu_hide_prompts", 0, true, false)

CreateClientConVar("uvmenu_open_speed", 0.25, true, false)
CreateClientConVar("uvmenu_close_speed", 0.25, true, false)

-- Background colour
CreateClientConVar("uvmenu_col_bg_r", 25, true, false)
CreateClientConVar("uvmenu_col_bg_g", 25, true, false)
CreateClientConVar("uvmenu_col_bg_b", 25, true, false)
CreateClientConVar("uvmenu_col_bg_a", 245, true, false)

-- Description panel colour
CreateClientConVar("uvmenu_col_desc_r", 28, true, false)
CreateClientConVar("uvmenu_col_desc_g", 28, true, false)
CreateClientConVar("uvmenu_col_desc_b", 28, true, false)
CreateClientConVar("uvmenu_col_desc_a", 150, true, false)

-- Tabs sidebar colour
CreateClientConVar("uvmenu_col_tabs_r", 0, true, false)
CreateClientConVar("uvmenu_col_tabs_g", 0, true, false)
CreateClientConVar("uvmenu_col_tabs_b", 0, true, false)
CreateClientConVar("uvmenu_col_tabs_a", 0,  true, false)

-- Tab button (active/hover/default)
CreateClientConVar("uvmenu_col_tab_default_r", 125, true, false)
CreateClientConVar("uvmenu_col_tab_default_g", 125, true, false)
CreateClientConVar("uvmenu_col_tab_default_b", 125, true, false)

CreateClientConVar("uvmenu_col_tab_active_r", 255, true, false)
CreateClientConVar("uvmenu_col_tab_active_g", 255, true, false)
CreateClientConVar("uvmenu_col_tab_active_b", 255, true, false)

CreateClientConVar("uvmenu_col_tab_hover_r", 255, true, false)
CreateClientConVar("uvmenu_col_tab_hover_g", 255, true, false)
CreateClientConVar("uvmenu_col_tab_hover_b", 255, true, false)

-- Label colour
CreateClientConVar("uvmenu_col_label_r", 100, true, false)
CreateClientConVar("uvmenu_col_label_g", 100, true, false)
CreateClientConVar("uvmenu_col_label_b", 100, true, false)
CreateClientConVar("uvmenu_col_label_a", 75,  true, false)

-- Bool colour
CreateClientConVar("uvmenu_col_bool_r", 125, true, false)
CreateClientConVar("uvmenu_col_bool_g", 125, true, false)
CreateClientConVar("uvmenu_col_bool_b", 125, true, false)
CreateClientConVar("uvmenu_col_bool_a", 200, true, false)

CreateClientConVar("uvmenu_col_bool_active_r", 58, true, false)
CreateClientConVar("uvmenu_col_bool_active_g", 193, true, false)
CreateClientConVar("uvmenu_col_bool_active_b", 0, true, false)

-- Bool colour
CreateClientConVar("uvmenu_col_button_r", 125, true, false)
CreateClientConVar("uvmenu_col_button_g", 125, true, false)
CreateClientConVar("uvmenu_col_button_b", 125, true, false)
CreateClientConVar("uvmenu_col_button_a", 125, true, false)

CreateClientConVar("uvmenu_col_button_hover_r", 125, true, false)
CreateClientConVar("uvmenu_col_button_hover_g", 125, true, false)
CreateClientConVar("uvmenu_col_button_hover_b", 125, true, false)
CreateClientConVar("uvmenu_col_button_hover_a", 200, true, false)
-- [[ End of Color ConVars ]] --

function UV.PlayerCanSeeSetting(st)
	if st.sp and not game.SinglePlayer() then
		return false
	end
	
	if st.developer then
		local ply = LocalPlayer()
		if not IsValid(ply) then return false end
		if GetConVar("developer"):GetInt() < 1 then return false end
	end
	
	if st.sv or st.admin then
		local ply = LocalPlayer()
		if not IsValid(ply) then return false end
		if not ply:IsAdmin() and not ply:IsSuperAdmin() then
		-- if ply:IsAdmin() and ply:IsSuperAdmin() then -- Reverse for debugging
			return false
		end
	end
	return true
end

-- Filtering logic similar to ARC9
function UV.ShouldDrawSetting(st)
	if not UV.PlayerCanSeeSetting(st) then
		return false
	end

	if st.showfunc and st.showfunc() == false then return false end
	if st.cond and st.cond() == false then return false end

	if st.requireparentconvarvariable then
		local c = GetConVar(st.requireparentconvarvariable)
		if c then
			local value = c:GetString()
			local allowed = st.requireparentconvarvalue or st.requireparentconvarvariable -- fallback

			local active
			if istable(allowed) then
				active = table.HasValue(allowed, value)
			else
				active = (value == allowed)
			end

			if st.parentinvert then active = not active end
			if not active then return false end
		end

	elseif st.requireparentconvar then
		local c = GetConVar(st.requireparentconvar)
		if c then
			local v = c:GetBool()
			if st.parentinvert then v = not v end
			if not v then return false end
		end

	elseif st.parentconvar then
		local c = GetConVar(st.parentconvar)
		if c then
			local v = c:GetBool()
			if st.parentinvert then v = not v end
			if not v then return false end
		end
	end

	if st.requireconvar then
		local c = GetConVar(st.requireconvar)
		if c and not c:GetBool() then return false end
	end

	if st.requireconvaroff then
		local c = GetConVar(st.requireconvaroff)
		if c and c:GetBool() then return false end
	end

	return true
end

-- small materials for on/off indicators
local matTick = Material("unitvehicles/icons/generic_check.png", "mips")
local matCross = Material("unitvehicles/icons/generic_uncheck.png", "mips")

-- Returns a table of lines and the font used based on the text and max width
function UVTextSplit(text, maxWidth, baseFont, altFont)
    baseFont = baseFont or "UVMostWantedLeaderboardFont"
    altFont = altFont or "UVMostWantedLeaderboardFont2"
    
    local paragraphs = string.Split(text, "\n")
    local wrappedLines = {}

    for _, paragraph in ipairs(paragraphs) do
        if paragraph == "" then
            table.insert(wrappedLines, "")
        else
            for _, line in ipairs(UV_WrapText(paragraph, baseFont, maxWidth)) do
                table.insert(wrappedLines, line)
            end
        end
    end

    local chosenFont = #wrappedLines >= 3 and altFont or baseFont
    return wrappedLines, chosenFont
end

-- Helper to draw wrapped text inside a panel
local function DrawWrappedText(panel, text, maxWidth, x, y, center, altfont, altsmallfont, textcol)
    local wrappedLines, font = UVTextSplit(text, maxWidth, altfont or nil, altsmallfont or nil)
    surface.SetFont(font)
    local _, lineHeight = surface.GetTextSize("A")
    local totalHeight = lineHeight * #wrappedLines
    local startY = y or (panel:GetTall() - totalHeight) / 2
    local color = textcol or Color(255, 255, 255, panel:GetAlpha() or 255)
	local center = center and TEXT_ALIGN_CENTER or TEXT_ALIGN_LEFT

    for i, line in ipairs(wrappedLines) do
        -- draw.DrawText(line, font, x or 10, startY + (i-1)*lineHeight, color, center)
		draw.SimpleTextOutlined(line, font, x or 10, startY + (i-1)*lineHeight, color, center, TEXT_ALIGN_LEFT, 1.5, color_black)
    end
end

-- Returns required height for given text and max width
local function GetDynamicTall(text, maxWidth, baseFont, altFont)
    local lines, font = UVTextSplit(text, maxWidth, baseFont, altFont)
    surface.SetFont(font)
    local _, lineHeight = surface.GetTextSize("A")
    local padding = 0 -- optional padding
    return (#lines * lineHeight) + padding
end

-- Custom Dropdown panel
local UVDropdown = {}

function UVDropdown:Init()
	self:SetTall(UV.ScaleH(26))
	self:SetCursor("hand")

	self.Open = false
	self.Value = nil
	self.Choices = {}

	self.Button = vgui.Create("DButton", self)
	self.Button:Dock(FILL)
	self.Button:SetText("")
	self.Button.DoClick = function()
		self:Toggle()
	end

	self.Button.Paint = function(btn, w, h)
		DrawWrappedText(self, self.Value or "???", self:GetWide(), w * 0.5, nil, true, "UVMostWantedLeaderboardFont2", "UVMostWantedLeaderboardFont2")
		draw.SimpleTextOutlined( self.Open and "▲" or "▼", "UVMostWantedLeaderboardFont2", w - 14, h*0.45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, color_black )
		
		-- draw.SimpleText( self.Value or "???", "UVMostWantedLeaderboardFont2", 12, h * 0.45, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		-- draw.SimpleText( self.Open and "▲" or "▼", "UVMostWantedLeaderboardFont2", w - 14, h * 0.45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end

function UVDropdown:AddChoice(text, data)
	table.insert(self.Choices, {text = UVString(text), data = data})
end

function UVDropdown:SetValue(text, data)
	self.Value = UVString(text)
	self.Data = data
end

function UVDropdown:Toggle()
	if self.Open then
		self:CloseList()
	else
		self:OpenList()
	end
end

function UVDropdown:OpenList()
	if IsValid(self.List) then return end
	self.Open = true

	-- Create dropdown panel
	self.List = vgui.Create("DPanel", self:GetParent())
	self.List:SetWide(self:GetWide())
	self.List:MakePopup()
	self.List:SetKeyboardInputEnabled(false)

	-- Track globally
	UVMenu.OpenDropdowns = UVMenu.OpenDropdowns or {}
	table.insert(UVMenu.OpenDropdowns, self.List)

	self.List.OnRemove = function(pnl)
		for i, v in ipairs(UVMenu.OpenDropdowns) do
			if v == pnl then
				table.remove(UVMenu.OpenDropdowns, i)
				break
			end
		end
	end

	local x, y = self:LocalToScreen(0, self:GetTall() + 2)

	-- Determine menu boundaries
	local menu = self:GetParent()
	while IsValid(menu:GetParent()) do
		menu = menu:GetParent()
	end
	local mx, my = menu:LocalToScreen(0, 0)
	local mw, mh = menu:GetSize()

	local maxHeight = #self.Choices * 26 + 6
	local spaceBelow = (my + mh) - y
	local spaceAbove = y - my
	local listHeight = math.min(maxHeight, 260)

	-- Flip dropdown if not enough space below
	if listHeight > spaceBelow and spaceAbove > spaceBelow then
		listHeight = math.min(listHeight, spaceAbove - 4)
		y = y - listHeight - 2
	else
		listHeight = math.min(listHeight, spaceBelow - 4)
	end

	self.List:SetSize(self:GetWide(), listHeight)
	self.List:SetPos(x, y)

	-- Close on click outside dropdown
	self.List._wasMouseDown = false
	self.List.Think = function(pnl)
		if not IsValid(self) then pnl:Remove() return end

		local mouseDown = input.IsMouseDown(MOUSE_LEFT)
		if pnl._wasMouseDown and not mouseDown then
			local mx, my = gui.MousePos()
			local bx, by = self:LocalToScreen(0, 0)
			local bw, bh = self:GetSize()

			-- Check if inside dropdown
			local inList = false
			for _, pnl2 in ipairs(UVMenu.OpenDropdowns or {}) do
				if IsValid(pnl2) then
					local px, py = pnl2:LocalToScreen(0, 0)
					local pw, ph = pnl2:GetSize()
					if mx >= px and mx <= px + pw and my >= py and my <= py + ph then
						inList = true
						break
					end
				end
			end

			local inButton = mx >= bx and mx <= bx + bw and my >= by and my <= by + bh

			if not inList and not inButton then
				self:CloseList()
			end
		end

		pnl._wasMouseDown = mouseDown
	end

	-- Background
	self.List.Paint = function(p, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 30, 240))
	end

	-- Scroll panel
	local scroll = vgui.Create("DScrollPanel", self.List)
	scroll:Dock(FILL)
	scroll:DockMargin(4, 4, 4, 4)
	scroll.OnMouseWheeled = function(pnl, delta)
		pnl:GetVBar():AddScroll(-delta * 1)
		return true
	end

	-- Options
	for _, v in ipairs(self.Choices) do
		local opt = scroll:Add("DButton")
		opt:SetTall(UV.ScaleH(24))
		opt:Dock(TOP)
		opt:DockMargin(0, 0, 0, 2)
		opt:SetText("")

		function opt:PerformLayout()
			local text = v.text
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(24), GetDynamicTall(text, w, "UVMostWantedLeaderboardFont2", "UVMostWantedLeaderboardFont2"))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		
		opt.Paint = function(btn, w, h)
			local hovered = btn:IsHovered()
			draw.RoundedBox(6, 0, 0, w, h, hovered and Color(80, 80, 80, 220) or Color(60, 60, 60, 200))
			DrawWrappedText(self, v.text, self:GetWide(), w * 0.5, h * 0.05, true, "UVMostWantedLeaderboardFont2", "UVMostWantedLeaderboardFont2")
		end

		opt.DoClick = function()
			self:SetValue(v.text, v.data)
			if self.OnSelect then
				self:OnSelect(v.text, v.data)
			end
			self:CloseList()
		end
	end

	-- Fix default display text if not set
	if not self.Value and #self.Choices > 0 then
		self:SetValue(self.Choices[1].text, self.Choices[1].data)
	end
end

function UVDropdown:CloseList()
	self.Open = false
	if IsValid(self.List) then
		self.List:Remove()
	end
end

vgui.Register("UVCombo", UVDropdown, "DPanel")

-- Build one setting (label / bool / slider / combo / button)
function UV.BuildSetting(parent, st, descPanel, promptBar)
	local function GetDisplayText()
		local prefix = ""

		local parentName
		local checkType

		if st.requireparentconvarvariable then
			parentName = st.requireparentconvarvariable
			checkType = "string"
		elseif st.requireparentconvarfloat then
			parentName = st.requireparentconvarfloat
			checkType = "float"
		else
			parentName = st.parentconvar or st.requireparentconvar
			checkType = "bool"
		end
		
		if st.showprefix then prefix = "	|-- " end
		
		if parentName then
			local cv = GetConVar(parentName)
			if cv then
				local active

				if checkType == "float" then
					active = cv:GetFloat() > 0
				elseif checkType == "string" then
					local value = cv:GetString()
					local allowed = st.requireparentconvarvalue or st.requireparentconvarvariable

					if istable(allowed) then
						active = table.HasValue(allowed, value)
					else
						active = (value == allowed)
					end
				else
					active = cv:GetBool()
				end

				if st.parentinvert then active = not active end
				if st.showprefix then active = true end

				if active then
					prefix = "	|-- "
				end
			end
		end
		
		if st.noprefix then prefix = "" end

		return prefix .. UVString(st.text)
	end
	
	-- if st is an information panel
	if st.type == "info" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(6, 6, 6, 2)
		p:SetPaintBackground(false)

		local rawText = UVString(st.text or "") or ""
		rawText = UVReplaceKeybinds(rawText, "Small")
		rawText = UVDiscordTextFormat(rawText)

		local mk
		local lastWidth = 0
		local padding = 10

		function p:Rebuild()
			local w = self:GetWide()
			if w <= 0 then return end

			local text = rawText

			mk = markup.Parse(
				"<font=" .. (st.font or "UVSettingsFontSmall") .. ">" .. text .. "</font>",
				w - 20
			)

			self:SetTall(mk:GetHeight() + 20)
		end

		function p:PerformLayout()
			local w = self:GetWide()
			if w ~= lastWidth then
				lastWidth = w
				self:Rebuild()
			end
		end

		function p:Paint(w, h)
			surface.SetDrawColor(28, 28, 28, 150)
			surface.DrawRect(0, 0, w, h)

			if mk then
				mk:Draw(10, 10)
			end
		end

		return p
	end

	-- if st is a header label
	if st.type == "infosimple" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		function p:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(32), GetDynamicTall(text, w, "UVMostWantedLeaderboardFont", "UVMostWantedLeaderboardFont"))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		p:DockMargin(6, 6, 6, 2)
		p.Paint = function(self, w, h)
			local text = GetDisplayText() or "???"
			DrawWrappedText(self, text, self:GetWide(), w * 0.5, nil, true, "UVMostWantedLeaderboardFont", "UVMostWantedLeaderboardFont")
		end

		if st.desc then
			p.OnCursorEntered = function()
				if descPanel then
					descPanel.Desc = st.desc or ""
				end
			end

			p.OnCursorExited = function()
				if descPanel then
					descPanel.Desc = ""
				end
			end
		end
		
		return p
	end

	-- if st is an information panel, but now with flags
	if st.type == "info_flags" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(6, 6, 6, 2)
		p:SetPaintBackground(false)

		local padding = UV.ScaleH(10)
		local y = padding

		for _, entry in ipairs(st.entries or {}) do
			local row = vgui.Create("DPanel", p)
			row:SetTall(22.5)
			row:Dock(TOP)
			row:DockMargin(padding, 0, padding, 4)
			row:SetPaintBackground(false)

			local img = vgui.Create("DImage", row)
			img:SetImage("flags16/" .. entry.flag .. ".png")
			img:SetSize(16, 8)
			img:SetPos(0, UV.ScaleW(8))
			img:SetMouseInputEnabled(true)
			img:SetTooltip(entry.desc or "Tooltip")

			local lbl = vgui.Create("DLabel", row)
			lbl:SetFont("UVSettingsFontSmall")
			lbl:SetText(entry.name)
			lbl:SetTextColor(color_white)
			lbl:SizeToContents()
			lbl:SetPos(UV.ScaleW(20), UV.ScaleH(2.5))
		end

		function p:PerformLayout()
			p:SizeToChildren(false, true)
		end

		function p:Paint(w, h)
			surface.SetDrawColor(28, 28, 28, 150)
			surface.DrawRect(0, 0, w, h)
		end

		return p
	end

	-- if st is a singular image
	if st.type == "image" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(60, 6, 60, 2)

		local mat = Material(st.image or "", "smooth")

		if not mat or mat:IsError() then
			-- p.Paint = function(self, w, h)
				-- draw.SimpleText(
					-- "/// Missing image ///",
					-- "UVSettingsFontSmall",
					-- w / 2,
					-- h / 2,
					-- color_white,
					-- TEXT_ALIGN_CENTER,
					-- TEXT_ALIGN_CENTER
				-- )
			-- end
			-- return p
			
			mat = Material("unitvehicles/icons_settings/pnotes/pnotesplaceholder.png", "smooth")
		end

		-- Cache image size
		local iw, ih = mat:Width(), mat:Height()
		local aspect = (iw > 0 and ih > 0) and (ih / iw) or (9 / 16)

		-- Optional text config
		local font  = st.font or "UVFont5"
		local xPos  = st.XPos or 0.5
		local yPos  = st.YPos or 0.01

		-- Layout based on image aspect
		p.PerformLayout = function(self, w, h)
			self:SetTall(math.floor(w * aspect))
		end

		p.Paint = function(self, w, h)
			-- Background
			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(0, 0, w, h)

			if iw == 0 or ih == 0 then return end

			-- Letterboxed image
			local ratio = math.min(w / iw, h / ih)
			local fw, fh = iw * ratio, ih * ratio
			local x = (w - fw) * 0.5
			local y = (h - fh) * 0.5

			surface.SetMaterial(mat)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(x, y, fw, fh)

			-- Optional overlay text (infosimple-style)
			if st.text then
				if st.text and st.text ~= "" then
					DrawWrappedText( self, UVString(st.text), w - UV.ScaleW(20), w * xPos, h * yPos, true, font, font )
				end
			end
		end

		-- Optional desc hover behavior (same as infosimple)
		if st.desc then
			p.OnCursorEntered = function()
				if descPanel then
					descPanel.Desc = st.desc or ""
				end
			end

			p.OnCursorExited = function()
				if descPanel then
					descPanel.Desc = ""
				end
			end
		end

		return p
	end

	-- if st is a header label
	if st.type == "label" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		function p:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(36), GetDynamicTall(text, w*0.8))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		p:DockMargin(6, 6, 6, 2)
		p.Paint = function(self, w, h)
			local bg = Color( GetConVar("uvmenu_col_label_r"):GetInt(), GetConVar("uvmenu_col_label_g"):GetInt(), GetConVar("uvmenu_col_label_b"):GetInt(), GetConVar("uvmenu_col_label_a"):GetInt() )
			
			draw.RoundedBox(4, 0, 0, w, h, bg)
			draw.SimpleTextOutlined(UVString(st.text), "UVFont5UI", w*0.5, h*0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, color_black)
		end
		
		if st.desc then
			p.OnCursorEntered = function()
				if descPanel then
					descPanel.Desc = st.desc or ""
				end
			end

			p.OnCursorExited = function()
				if descPanel then
					descPanel.Desc = ""
				end
			end
		end
		
		return p
	end

	---- boolean custom button ----
	if st.type == "bool" then
		local wrap = vgui.Create("DButton", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		function wrap:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(30), GetDynamicTall(text, w - 44))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		wrap:SetText("")
		wrap:SetCursor("hand")

		local localvar = false
		local cv = GetConVar(st.convar or "")
		local function getBool()
			if cv then return cv:GetBool() end
			return localvar
		end

		wrap.DoClick = function()
			if not cv then  
				localvar = not localvar
				UVMenu.PlaySFX("confirm")
				if descPanel and st.convar then
					descPanel.SelectedCurrent = localvar and "1" or "0"
				end
				if st.func then pcall(st.func, localvar) end
				return
			end
			local new = getBool() and "0" or "1"
			if st.sv and string.match(st.convar, 'unitvehicle_') then
				net.Start("UVUpdateSettings")
				net.WriteTable({ [st.convar] = new })
				net.SendToServer()
			else
				cv:SetString( new )
			end
			UVMenu.PlaySFX("confirm")
			if descPanel and st.convar then
				descPanel.SelectedCurrent = new
			end
			if st.func then pcall(st.func, new) end
		end

		wrap.OnCursorEntered = function()
			-- UVMenu.PlaySFX("hover")
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.convar):GetBool() and "1" or "0"
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
			if promptBar then promptBar.Prompts = { "uv.prompt.toggle", "uv.prompt.reset" } end
		end

		wrap.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				end
				if promptBar then promptBar.Prompts = nil end
			end
		end

		wrap.Paint = function(self, w, h)
			local enabled = getBool()
			local hovered = self:IsHovered()

			local bga = hovered and 
			GetConVar("uvmenu_col_bool_a"):GetInt() * math.abs(math.sin(RealTime()*4)) 
			or GetConVar("uvmenu_col_bool_a"):GetInt() * 0.75
			local bg

			local default = Color( 
				GetConVar("uvmenu_col_bool_r"):GetInt(),
				GetConVar("uvmenu_col_bool_g"):GetInt(),
				GetConVar("uvmenu_col_bool_b"):GetInt(),
				bga
			)
			local active = Color(
				GetConVar("uvmenu_col_bool_active_r"):GetInt(),
				GetConVar("uvmenu_col_bool_active_g"):GetInt(),
				GetConVar("uvmenu_col_bool_active_b"):GetInt(),
				bga
			)

			bg = enabled and active or default

			-- background & text
			draw.RoundedBox(6, w - 34, 0, 30, h, bg)
			DrawWrappedText(self, GetDisplayText(), w - 44, 10, nil)
		end

		-- dynamic update when convar changes - simple timer check
		wrap.Think = function(self)
			-- nothing heavy; updates on click via convar toggle
		end
		
		wrap.OnMousePressed = function(self, mc)
			if mc == MOUSE_RIGHT and st.convar then
				local cv = GetConVar(st.convar)
				if cv then
					if st.sv and string.match(st.convar, 'unitvehicle_') then
						net.Start("UVUpdateSettings")
						net.WriteTable({ [st.convar] = cv:GetDefault() })
						net.SendToServer()
					else
						cv:SetString( cv:GetDefault() )
					end
					UVMenu.PlaySFX("confirm")
				end
				return
			end
			-- existing left-click handling:
			if mc == MOUSE_LEFT then
				self:DoClick()
			end
		end

		return wrap
	end

	---- slider: label left, slider right ----
	if st.type == "slider" then
		local wrap = vgui.Create("DPanel", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		function wrap:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(30), GetDynamicTall(text, w * 0.4))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		wrap.Paint = function(self, w, h)
			local text = UVString(GetDisplayText()) or "???"
			DrawWrappedText(self, text, w * 0.425, 10)
			
			-- draw.RoundedBox(4, 0, 0, w * 0.425, h, Color(255, 255, 255))
		end

		local function PushDesc()
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.convar):GetString() or "?"
					descPanel.SelectedConVar = st.convar or st.command or "?"
				elseif st.command then
					descPanel.SelectedConVar = st.command or "?"
				end
			end
			if promptBar then promptBar.Prompts = { "uv.prompt.reset" } end
		end
		local function PopDesc()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				elseif st.command then
					descPanel.SelectedConVar = ""
				end
			end
			if promptBar then promptBar.Prompts = nil end
		end
		wrap.OnCursorEntered = PushDesc
		wrap.OnCursorExited  = PopDesc

		local slider = vgui.Create("DNumSlider", wrap)
		slider:Dock(RIGHT)
		slider:SetWide(UV.ScaleW(250))
		slider:DockMargin(26, 0, 6, 0)
		slider:SetContentAlignment(5)
		slider:SetMin(st.min or 0)
		slider:SetMax(st.max or 100)
		slider:SetDecimals(st.decimals or 0)
		slider:SetValue(st.min or 0)
		slider.Label:SetVisible(false)
		slider.TextArea:SetVisible(false)
		slider.OnCursorEntered = PushDesc
		slider.OnCursorExited  = PopDesc

		local valPanel = vgui.Create("DPanel", wrap)
		valPanel:SetWide(UV.ScaleW(84))
		valPanel:Dock(RIGHT)
		valPanel.Paint = function() end

		local valBox = vgui.Create("DTextEntry", valPanel)
		valBox:SetWide(UV.ScaleW(80))
		valBox:SetFont("UVSettingsFontSmall")
		valBox:SetTextColor(color_white)
		valBox:SetHighlightColor(Color(58,193,0))
		valBox:SetCursorColor(Color(58,193,0))
		valBox.Paint = function(self2, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(30,30,30,200))
			self2:DrawTextEntryText(color_white, Color(58,193,0), color_white)
		end
		valBox.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.convar):GetString() or "?"
					descPanel.SelectedConVar = st.convar or st.command or "?"
				elseif st.command then
					descPanel.SelectedConVar = st.command or "?"
				end
			end
			-- if promptBar then promptBar.Prompts = { "uv.prompt.confirm" } end
		end
		valBox.OnCursorExited  = PopDesc

		-- Only validate on enter/apply, allow free typing
		valBox.OnTextChanged = function(self2)
			local v = tonumber(self2:GetValue())
			if v then
				-- store as pending value but don't overwrite with applied yet
				pendingValue = v
				applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
			end
		end

		local applyBtn = vgui.Create("DButton", wrap)
		applyBtn:SetSize(UV.ScaleW(25), UV.ScaleH(25))
		applyBtn:Dock(RIGHT)
		applyBtn:SetText(" ")
		applyBtn:SetVisible(false)
		applyBtn.Paint = function(self2, w, h)
			draw.RoundedBox(4,0,0,w,h,self2:IsHovered() and Color(60,180,60) or Color(45,140,45))
			draw.SimpleText("✔", "UVMostWantedLeaderboardFont2", w/2,h/2,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		applyBtn.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.convar):GetString() or "?"
					descPanel.SelectedConVar = st.convar or st.command or "?"
				elseif st.command then
					descPanel.SelectedConVar = st.command or "?"
				end
			end
			if promptBar then promptBar.Prompts = { "uv.prompt.confirm" } end
		end
		applyBtn.OnCursorExited  = PopDesc

		-- Vertically center value box and button
		local function LayoutValPanel()
			if not (IsValid(valBox) and IsValid(applyBtn)) then return end

			local offsetY = (wrap:GetTall() - valBox:GetTall()) / 2
			valBox:SetPos(0, offsetY)

			local btnX = valBox:GetWide() + 4
			-- applyBtn:SetPos(valPanel:GetX() + btnX, offsetY)
		end

		wrap.OnSizeChanged = LayoutValPanel

		local appliedValue = st.min or 0
		local pendingValue = appliedValue

		local function RoundValue(val)
			if st.decimals then
				local factor = 10 ^ st.decimals
				return math.floor(val * factor + 0.5) / factor
			end
			return val
		end

		local function ApplyPendingValue()
			local val = RoundValue(pendingValue)
			appliedValue = val
			if st.convar and GetConVar(st.convar) then
				if st.sv and string.match(st.convar, 'unitvehicle_') then
					net.Start("UVUpdateSettings")
					net.WriteTable({ [st.convar] = val })
					net.SendToServer()
				else
					GetConVar(st.convar):SetString( tostring(val) )
				end
			elseif st.command then
				RunConsoleCommand(st.command, tostring(val))
			end
			if st.func then pcall(st.func, val) end
			valBox:SetText(string.format("%."..(st.decimals or 2).."f", val))
			applyBtn:SetVisible(false)
			UVMenu.PlaySFX("confirm")
		end

		valBox:SetText(string.format("%."..slider:GetDecimals().."f", appliedValue))
		slider:SetValue(appliedValue)

		local typing = false

		valBox.OnGetFocus = function()
			typing = true
			if IsValid(UV.SettingsFrame) then
				UV.SettingsFrame:SetKeyboardInputEnabled(true)
			end
		end

		valBox.OnLoseFocus = function()
			typing = false
			if IsValid(UV.SettingsFrame) then
				UV.SettingsFrame:SetKeyboardInputEnabled(false)
			end
		end

		slider.OnValueChanged = function(_, val)
			pendingValue = val
			applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)

			if not typing and IsValid(valBox) then
				valBox:SetText(string.format("%."..slider:GetDecimals().."f", val))
			end
		end

		valBox.OnEnter = function(self2)
			local v = tonumber(self2:GetValue()) or st.max
			if st.min then v = math.max(st.min, v) end
			if st.max then v = math.min(st.max, v) end

			pendingValue = v
			slider:SetValue(v)
			ApplyPendingValue()
		end

		valBox.OnTextChanged = function(self2)
			local v = tonumber(self2:GetValue())
			if not v then return end
			pendingValue = v
			slider:SetValue(v)
			applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
		end

		applyBtn.DoClick = function()
			local v = tonumber(valBox:GetValue()) or st.max
			if st.min then v = math.max(st.min, v) end
			if st.max then v = math.min(st.max, v) end

			pendingValue = v
			slider:SetValue(v)
			ApplyPendingValue()
		end

		if st.convar then
			local cv = GetConVar(st.convar)
			if cv then
				appliedValue = cv:GetFloat()
				pendingValue = appliedValue
				slider:SetValue(appliedValue)
				valBox:SetText(string.format("%."..slider:GetDecimals().."f", appliedValue))
			end
		end

		wrap.OnMousePressed = function(self, mc)
			if mc == MOUSE_RIGHT and st.convar then
				local cv = GetConVar(st.convar)
				if cv then
					local def = tonumber(cv:GetDefault()) or st.min or 0
					slider:SetValue(def)
					valBox:SetText(tostring(def))
					pendingValue = def
					applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
				end
			end
		end

		return wrap
	end

	---- combo: label left, dropdown right ----
	if st.type == "combo" then
		local wrap = vgui.Create("DPanel", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		wrap.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.convar):GetString() or "?"
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
			if promptBar then promptBar.Prompts = { "uv.prompt.reset" } end
		end

		wrap.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				end
			end
			if promptBar then promptBar.Prompts = nil end
		end

		if st.convar == "unitvehicle_racetheme" then
			st.content = {}
			local keys = {}
			for k in pairs(UVPlaylists) do
				table.insert(keys, k)
			end
			table.sort(keys)
			for _, k in ipairs(keys) do
				table.insert(st.content, { k, k })
			end
		end

		local combo = vgui.Create("UVCombo", wrap)
		combo:Dock(RIGHT)
		combo:SetWide(UV.ScaleW(330))
		combo:DockMargin(6, 3, 6, 3)
		combo.Paint = function(self, w, h)
			local hovered = self.Button:IsHovered()
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
				GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
				)

			-- background & text
			draw.RoundedBox(12, 0, 0, w, h, default)
			if hovered then draw.RoundedBox(12, 0, 0, w, h, hover) end
		end
		
		function wrap:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(30), GetDynamicTall(text, w - combo:GetWide() - 20))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		wrap.Paint = function(self, w, h)
			local hovered = self:IsHovered()
			local bga = hovered and 200 or 125
			local bg = Color( 125, 125, 125, 0 )
			
			if enabled then
				bg = Color( 58, 193, 0, bga )
			end
			
			draw.RoundedBox(6, 0, 0, w, h, bg)
			DrawWrappedText(self, GetDisplayText(), w - combo:GetWide() - 20, 10)
		end

		for _, entry in ipairs(st.content or {}) do
			combo:AddChoice(entry[1], entry[2])
		end

		-- Default value
		if st.convar then
			local cv = GetConVar(st.convar)
			if cv then
				local val = cv:GetString() -- ConVar value as string
				local matched = false

				for _, v in ipairs(st.content or {}) do
					-- Detect numeric vs string
					if type(v[2]) == "number" then
						if tonumber(val) == v[2] then
							combo:SetValue(v[1], v[2])
							matched = true
							break
						end
					else
						if val == tostring(v[2]) then
							combo:SetValue(v[1], v[2])
							matched = true
							break
						end
					end
				end

				if not matched and #st.content > 0 then
					combo:SetValue(st.content[1][1], st.content[1][2])
				end
			end
		elseif st.text then
			combo:SetValue(UVString(st.text), nil)
		end

		combo.OnSelect = function(_, val, data)
			if st.convar then
				if st.sv and string.match(st.convar, 'unitvehicle_') then
					net.Start("UVUpdateSettings")
					net.WriteTable({ [st.convar] = data })
					net.SendToServer()
				else
					GetConVar(st.convar):SetString( data )
				end
			end
			if st.func then
				st.func(combo)
			end
		end

		combo.Button.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					local cv = GetConVar(st.convar)
					descPanel.SelectedDefault = cv and cv:GetDefault() or "?"
					descPanel.SelectedCurrent = cv and cv:GetString() or "?"
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
			if promptBar then promptBar.Prompts = { "uv.prompt.open", "uv.prompt.reset" } end
		end

		combo.Button.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				end
			end
			if promptBar then promptBar.Prompts = nil end
		end

		wrap.OnMousePressed = function(self, mc)
			if mc == MOUSE_RIGHT and st.convar then
				local cv = GetConVar(st.convar)
				if not cv then return end

				local def = cv:GetDefault() -- default value as string
				local matched = false

				-- find matching display text
				for _, v in ipairs(st.content or {}) do
					if tostring(v[2]) == tostring(def) then
						combo:SetValue(v[1], v[2])   -- set both text and data
						UVMenu.PlaySFX("hover")
						matched = true
						break
					end
				end

				-- fallback if no match found
				if not matched and #st.content > 0 then
					combo:SetValue(st.content[1][1], st.content[1][2])
				end

				if st.sv and string.match(st.convar, 'unitvehicle_') then
					net.Start("UVUpdateSettings")
					net.WriteTable({ [st.convar] = def })
					net.SendToServer()
				else
					GetConVar(st.convar):SetString( def )
				end
			end
		end

		return wrap
	end

	---- button ----
	if st.type == "button" then
		local btn = vgui.Create("DButton", parent)
		btn:Dock(TOP)
		btn:DockMargin(6, 6, 6, 6)
		function btn:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(30), GetDynamicTall(text, w * 0.95))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		btn:SetText("")
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
				GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
				)

			-- background & text
			draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, default)
			if hovered then draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, hover) end
			DrawWrappedText(self, GetDisplayText(), w * 0.95, w*0.5, nil, true)
		end
		
		btn.DoClick = function(self)
			if st.playsfx then UVMenu.PlaySFX(st.playsfx) end
			if st.func then st.func(self) end
			if st.convar and not st.func then
				RunConsoleCommand(st.convar)
			end
		end
		btn.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
			if promptBar then promptBar.Prompts = st.prompts or nil end
		end
		btn.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedConVar = ""
				end
			end
			if promptBar then promptBar.Prompts = nil end
		end

		return btn
	end

	---- button ----
	if st.type == "buttonlr" then
		local panel = vgui.Create("DPanel", parent)
		panel:Dock(TOP)
		panel:DockMargin(8, 4, 8, 4)
		panel:SetTall(UV.ScaleH(40))
		panel.Paint = nil

		local btn = vgui.Create("DButton", panel)
		btn:Dock(LEFT)
		btn:DockMargin(6, 6, 6, 6)
		btn:SetWide(UV.ScaleW(400))
		btn:SetText("")
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
				GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
				)

			-- background & text
			draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, default)
			if hovered then draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, hover) end
			DrawWrappedText(self, UVString(st.text) or "-", w * 0.95, w*0.5, nil, true)
		end
		
		btn.DoClick = function(self)
			if st.playsfx then UVMenu.PlaySFX(st.playsfx) end
			if st.func then st.func(self) end
			if st.convar and not st.func then
				RunConsoleCommand(st.convar)
			end
		end
		btn.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
			if promptBar then promptBar.Prompts = st.prompts or nil end
		end
		btn.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedConVar = ""
				end
			end
			if promptBar then promptBar.Prompts = nil end
		end

		local btn2 = vgui.Create("DButton", panel)
		btn2:Dock(RIGHT)
		btn2:DockMargin(6, 6, 6, 6)
		btn2:SetWide(UV.ScaleW(400))
		btn2:SetText("")
		btn2.Paint = function(self, w, h)
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
				GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
				)

			-- background & text
			draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, default)
			if hovered then draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, hover) end
			DrawWrappedText(self, UVString(st.text2) or "+", w * 0.95, w*0.5, nil, true)
		end
		
		btn2.DoClick = function(self)
			if st.playsfx then UVMenu.PlaySFX(st.playsfx) end
			if st.func2 then st.func2(self) end
			if st.convar2 and not st.func2 then
				RunConsoleCommand(st.convar2)
			end
		end
		btn2.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
			if promptBar then promptBar.Prompts = st.prompts or nil end
		end
		btn2.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedConVar = ""
				end
			end
			if promptBar then promptBar.Prompts = nil end
		end

		return panel
	end

	---- button with scroll wheel functionality ----
	if st.type == "buttonsw" then
		local val = st.start or st.min or 1
		local min = st.min or 0
		local max = st.max or 10

		local btn = vgui.Create("DButton", parent)
		btn:Dock(TOP)
		btn:DockMargin(6, 6, 6, 6)
		function btn:PerformLayout()
			local w = self:GetWide()
			if w <= 0 then return end
			local text = UVString(st.text):find("%%s") and string.format(GetDisplayText(), val) or GetDisplayText()
			local newTall = math.max(UV.ScaleH(30), GetDynamicTall(text, w*0.95))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		btn:SetText("")

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
				GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
				)

			draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, default)
			if hovered then draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, hover) end

			local display = UVString(st.text)
			if display:find("%%s") then
				display = string.format(GetDisplayText(), val)
			end

			DrawWrappedText(self, display, w * 0.95, w*0.5, nil, true)
		end

		-- Adjust value with mouse wheel
		btn.OnMouseWheeled = function(self, delta)
			val = math.Clamp(val + delta, min, max)
			return true
		end

		btn.DoClick = function(self)
			if st.func then st.func(self, val) end
		end

		btn.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
			if promptBar then promptBar.Prompts = { "uv.prompt.confirm", "uv.prompt.incdec" } end
		end

		btn.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedConVar = ""
				end
			end
			if promptBar then promptBar.Prompts = nil end
		end

		return btn
	end

	---- color remains as basic DColorMixer or DColorButton (user requested keep as-is) ----
	---- TODO: right now, this has an issue with applying server color rgbs ----
	if st.type == "color" or st.type == "coloralpha" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(6, 4, 6, 4)
		function p:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(120), GetDynamicTall(text, w - UV.ScaleW(440)))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end

		-- Check for existence of color convars
		local base = st.convar
		local cv_r = GetConVar(base .. "_r")
		local cv_g = GetConVar(base .. "_g")
		local cv_b = GetConVar(base .. "_b")
		local cv_a = GetConVar(base .. "_a") -- optional
		local invalidtext = " "

		if not cv_r or not cv_g or not cv_b then
			invalidtext = "INVALID COL. CONVAR"
		end
		
		p.Paint = function(self, w, h)
			draw.SimpleText(GetDisplayText(), "UVMostWantedLeaderboardFont", 0, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			
			draw.SimpleText(invalidtext, "UVMostWantedLeaderboardFont", w * 0.99, h/2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		local allowAlpha = st.type == "coloralpha" and cv_a ~= nil

		-- Initial color
		local initial = Color(cv_r:GetInt(), cv_g:GetInt(), cv_b:GetInt(), allowAlpha and cv_a:GetInt() or 255)

		local mixer = vgui.Create("DColorMixer", p)
		mixer:Dock(RIGHT)
		mixer:SetWide(UV.ScaleW(440))
		mixer:DockMargin(6, 6, 6, 6)
		mixer:SetColor(initial)
		mixer:SetPalette(false)
		mixer:SetAlphaBar(allowAlpha)
		mixer:SetWangs(true)
		mixer:SetConVarR(base .. "_r")
		mixer:SetConVarG(base .. "_g")
		mixer:SetConVarB(base .. "_b")
		if allowAlpha then
			mixer:SetConVarA(base .. "_a")
		end

		p.OnCursorEntered = function()
			-- UVMenu.PlaySFX("hover")
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedConVar = st.convar .. "_r/" .. "_g/" .. "_b/" .. (allowAlpha and "_a/" or "")
					descPanel.SelectedCurrent = cv_r:GetInt() .. ", " .. cv_g:GetInt() .. ", " .. cv_b:GetInt() .. (allowAlpha and ", " .. cv_r:GetInt() or "")
					descPanel.SelectedDefault = cv_r:GetDefault() .. ", " .. cv_g:GetDefault() .. ", " .. cv_b:GetDefault() .. (allowAlpha and ", " .. cv_r:GetDefault() or "")
				end
			end
			if promptBar then promptBar.Prompts = { "uv.prompt.reset" } end
		end

		p.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedConVar = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedDefault = ""
				end
			end
			if promptBar then promptBar.Prompts = nil end
		end

		mixer.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedConVar = st.convar .. "_r/" .. "_g/" .. "_b/" .. (allowAlpha and "_a/" or "")
					descPanel.SelectedCurrent = cv_r:GetInt() .. ", " .. cv_g:GetInt() .. ", " .. cv_b:GetInt() .. (allowAlpha and ", " .. cv_r:GetInt() or "")
					descPanel.SelectedDefault = cv_r:GetDefault() .. ", " .. cv_g:GetDefault() .. ", " .. cv_b:GetDefault() .. (allowAlpha and ", " .. cv_r:GetDefault() or "")
				end
			end
			if promptBar then promptBar.Prompts = { "uv.prompt.reset" } end
		end

		mixer.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedConVar = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedDefault = ""
				end
			end
			if promptBar then promptBar.Prompts = nil end
		end
		
		p.OnMousePressed = function(self, mc)
			if mc == MOUSE_RIGHT then
				if cv_r and cv_g and cv_b then
					local r = tonumber(cv_r:GetDefault())
					local g = tonumber(cv_g:GetDefault())
					local b = tonumber(cv_b:GetDefault())
					local a = cv_a and tonumber(cv_a:GetDefault()) or 255
					
					mixer:SetColor(Color(r, g, b, a))

					-- Push to convars
					if st.sv and string.match(base, 'unitvehicle_') then
						net.Start("UVUpdateSettings")
						net.WriteTable({
							[base .. "_r"] = r,
							[base .. "_g"] = g,
							[base .. "_b"] = b,
							[base .. "_a"] = cv_a and a or nil
						})
						net.SendToServer()
					else
						GetConVar(base .. "_r"):SetInt( r )
						GetConVar(base .. "_g"):SetInt( g )
						GetConVar(base .. "_b"):SetInt( b )
						if cv_a then GetConVar(base .. "_a"):SetInt( a ) end
					end

					UVMenu.PlaySFX("hover")
				end
			end
		end

		return p
	end

	---- keybind button ----
	if st.type == "keybind" then
		local wrap = vgui.Create("DButton", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		function wrap:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(35), GetDynamicTall(text, w * 0.5))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end

		wrap:SetText("")
		wrap:SetCursor("hand")

		local cv = GetConVar(st.convar)
		local function GetKeyName()
			if not cv then return "Invalid ConVar!" end
			return string.upper(input.GetKeyName(cv:GetInt()) or "-")
		end

		local function GetDefaultKeyName()
			if not cv then return "Invalid ConVar!" end
			return string.upper(input.GetKeyName(cv:GetDefault()) or "-")
		end
		
		local function GetKeyGlyph(cv, size) -- Same, but glyphs!
			if not cv then return "Invalid ConVar!" end

			local key = input.GetKeyName(cv:GetInt())
			if not key then key = "-" end

			return UVKeybindIcon(key, size)
		end

		-- Register with your existing keybind system
		KeyBindButtons[st.slot] = { st.convar, wrap }

		wrap.Paint = function(self, w, h)
			local hovered = self:IsHovered()
			local isActive = tonumber(UVSettingKeybind) == st.slot
			
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
				GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
				)

			-- background & text
			draw.RoundedBox(6, w*0.66, 0, w*0.33, h, default)
			if isActive then draw.RoundedBox( 6, w*0.66, 0, w*0.33, h, Color(255, 180, 0, 80 + math.sin(RealTime()*6)*40) ) end
			if hovered then draw.RoundedBox(6, w*0.66, 0, w*0.33, h, hover) end

			DrawWrappedText(self, GetDisplayText(), w * 0.45, 10, nil)
			local text = isActive and UVString("uv.controls.anybutton") or GetKeyGlyph(cv, "Big")
			
			markup.Parse( "<font=UVMostWantedLeaderboardFont>" .. text .. "</font>", w ):Draw(w * 0.82, h * 0.5, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		wrap.DoClick = function()
			if UVSettingKeybind then return end

			-- Temporarily allow keyboard input just like slider text entry
			if IsValid(UV.SettingsFrame) then
				UV.SettingsFrame:SetKeyboardInputEnabled(true)
			end

			RunConsoleCommand("uv_keybinds", tostring(st.slot))
		end

		-- When keybind finishes, keyboard input is released in your existing net.Receive
		wrap.Think = function(self)
			if UVSettingKeybind == st.slot then
				self:InvalidateLayout(true)
			end

			if not UVSettingKeybind and IsValid(UV.SettingsFrame) then
				UV.SettingsFrame:SetKeyboardInputEnabled(false)
			end
		end

		wrap.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				if cv then
					descPanel.SelectedDefault = GetDefaultKeyName()
					descPanel.SelectedCurrent = GetKeyName()
					descPanel.SelectedConVar = st.convar
				end
			end
			if promptBar then promptBar.Prompts = { "uv.prompt.keybind" } end
		end

		wrap.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				descPanel.SelectedDefault = ""
				descPanel.SelectedCurrent = ""
				descPanel.SelectedConVar = ""
			end
			if promptBar then promptBar.Prompts = nil end
		end

		return wrap
	end

	if st.type == "timer" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:SetTall(36)
		p:DockMargin(6, 6, 6, 2)

		local duration = tonumber(st.duration) or 0
		p._endTime = CurTime() + duration
		p._fired = false

		p.Paint = function(self, w, h)
			local bg = Color(
				GetConVar("uvmenu_col_label_r"):GetInt(),
				GetConVar("uvmenu_col_label_g"):GetInt(),
				GetConVar("uvmenu_col_label_b"):GetInt(),
				GetConVar("uvmenu_col_label_a"):GetInt()
			)

			draw.RoundedBox(4, 0, 0, w, h, bg)

			local remaining = math.max(0, self._endTime - CurTime())

			-- Optional precision (default = integer)
			local precision = st.precision or 0
			local displayTime = precision > 0
				and string.format("%." .. precision .. "f", remaining)
				or tostring(math.ceil(remaining))

			-- Allow formatted text
			local text
			if st.format then
				text = string.format(st.format, displayTime)
			else
				-- st.text may be localized
				local base = UVString(st.text)
				text = string.format(base, displayTime)
			end

			draw.SimpleText(
				text,
				"UVMostWantedLeaderboardFont",
				w * 0.5,
				h * 0.5,
				color_white,
				TEXT_ALIGN_CENTER,
				TEXT_ALIGN_CENTER
			)
		end

		p.Think = function(self)
			if self._fired then return end

			if CurTime() >= self._endTime then
				self._fired = true

				if st.func then
					st.func(self)
				end
			end
		end

		if st.desc then
			p.OnCursorEntered = function()
				if descPanel then
					descPanel.Desc = st.desc or ""
				end
			end

			p.OnCursorExited = function()
				if descPanel then
					descPanel.Desc = ""
				end
			end
		end

		return p
	end

	if st.type == "vehicleoverride" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:SetTall(UV.ScaleH(220))
		p:DockMargin(0, 8, 0, 8)

		p.Paint = function(self, w, h)
			local cv = GetConVar(st.convar)
			local vehnum = 0
			for _, veh in string.gmatch(cv:GetString(), "%S+") do
				vehnum = vehnum + 1
			end
			
			draw.SimpleText( string.format( UVString(st.text), vehnum ), "UVMostWantedLeaderboardFont", w * 0.5, h * 0.05, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		-- Vehicle tree belongs to THIS panel
		local vehicleTree = vgui.Create("DTree", p)
		vehicleTree:Dock(BOTTOM)
		vehicleTree:SetTall(UV.ScaleH(160))
		vehicleTree:DockMargin(80, 4, 80, 4)

		-- /// Vehicle Override Code /// --
		local selectedRacers = {}
		
		local glideNode
		local glideDataRequested = false
		local lvsNode
		local lvsDataRequested = false
		local racerconvar = GetConVar(st.convar)

		local function ParseConvar()
			local t = {}
			for class in string.gmatch(GetConVar(st.convar):GetString(), "%S+") do
				t[class] = true
			end
			return t
		end

		local function UpdateRacersConvar()
			local out = {}

			for class, _ in pairs(selectedRacers) do
				table.insert(out, class)
			end
			table.sort(out)

			local str = table.concat(out, " ")
			-- RunConsoleCommand(st.convar, str)
			if st.sv and string.match(st.convar, 'unitvehicle_') then
				net.Start("UVUpdateSettings")
				net.WriteTable({ [st.convar] = str })
				net.SendToServer()
			else
				racerconvar:SetString( str )
			end
		end

		local classToNode = {} -- lookup so textbox edits update icons

		local function RefreshNodeIcons()
			for class, node in pairs(classToNode) do
				if IsValid(node) then
					if selectedRacers[class] then
						node:SetIcon("icon16/tick.png")
					else
						node:SetIcon("icon16/car.png")
					end
				end
			end
		end

		local function UpdateFolderIcon(folderNode)
			if not IsValid(folderNode) then return end

			local hasSelectedChild = false
			for _, child in ipairs(folderNode:GetChildren() or {}) do
				if child.ClassName and selectedRacers[child.ClassName] then
					hasSelectedChild = true
					break
				end
				for _, gc in ipairs(child.GetChildren and child:GetChildren() or {}) do
					if gc.ClassName and selectedRacers[gc.ClassName] then
						hasSelectedChild = true
						break
					end
				end
			end

			if folderNode.SetIcon then
				if hasSelectedChild then
					folderNode:SetIcon("icon16/folder_add.png")
				else
					local expanded = folderNode.Expander and folderNode.Expander.IsExpanded and folderNode.Expander:IsExpanded()
					if expanded then
						folderNode:SetIcon("icon16/folder_add.png")
					else
						folderNode:SetIcon("icon16/folder.png")
					end
				end
			end
		end

		-- ADD VEHICLE NODES
		local function AddVehicleNodes(parentNode, vehicles)
			table.sort(vehicles, function(a, b) return (a.name or "") < (b.name or "") end)

			selectedRacers = ParseConvar()

			function parentNode:DoRightClick()
				local addAll = true

				for _, veh in ipairs( vehicles ) do
					local class = veh.class
					if selectedRacers[class] then addAll = false break end
				end

				for _, veh in ipairs( vehicles ) do
					local class = veh.class
					selectedRacers[class] = addAll or nil
					if veh.node then veh.node:SetIcon( addAll and "icon16/tick.png" or "icon16/car.png" ) end
				end

				UpdateRacersConvar()
				UpdateFolderIcon( parentNode )
			end

			for _, veh in ipairs(vehicles) do
				local class = veh.class
				local node = parentNode:AddNode(veh.name or class)
				node.ClassName = class
				veh.node = node

				classToNode[class] = node

				if selectedRacers[class] then
					node:SetIcon("icon16/tick.png")
				else
					node:SetIcon("icon16/car.png")
				end
				
				if promptBar then 
					parentNode.OnCursorEntered = function() promptBar.Prompts = { "uv.prompt.reset" } end
					parentNode.OnCursorExited = function() promptBar.Prompts = nil end
				end
			
				node:SetTooltip(UVString("uv.airacer.overridelist.desc"))

				function node:DoRightClick()
					if selectedRacers[class] then
						selectedRacers[class] = nil
						self:SetIcon("icon16/car.png")
					else
						selectedRacers[class] = true
						self:SetIcon("icon16/tick.png")
					end

					UpdateRacersConvar()
					UpdateFolderIcon(parentNode)
				end
			end

			UpdateFolderIcon(parentNode)
		end

		local function BuildVehicleTree()
			vehicleTree:Clear()
			classToNode = {}
			selectedRacers = ParseConvar()

			-- LVS
			local lvsVehicles = list.Get("LVSVehicles") or {}
			if next(lvsVehicles) then
				local lvsNode = vehicleTree:AddNode("[LVS]")
				AddVehicleNodes(lvsNode, lvsVehicles)
			end

			-- HL2 Jeeps
			local baseVehicles = list.Get("Vehicles") or {}
			local baseCategories = {}
			for class, data in pairs(baseVehicles) do
				local cat = data.Category or "Other"
				baseCategories[cat] = baseCategories[cat] or {}
				table.insert(baseCategories[cat], {name = data.PrintName or class, class = class})
			end
			for catName, vehs in SortedPairs(baseCategories) do
				local catNode = vehicleTree:AddNode(catName)
				AddVehicleNodes(catNode, vehs)
			end

			-- Simfphys
			local simfphysVehicles = list.Get("simfphys_vehicles") or {}
			if next(simfphysVehicles) then
				local simNode = vehicleTree:AddNode("[simfphys]")
				local simCategories = {}
				for class, data in pairs(simfphysVehicles) do
					local cat = data.Category or "Other"
					simCategories[cat] = simCategories[cat] or {}
					table.insert(simCategories[cat], {name = data.Name or class, class = class})
				end
				for catName, vehs in SortedPairs(simCategories) do
					local catNode = simNode:AddNode(catName)
					AddVehicleNodes(catNode, vehs)
				end
			end

			-- Glide placeholder
			glideNode = vehicleTree:AddNode(string.format(UVString("uv.base.selectload"), UVString("uv.base.glide")))
			glideNode:SetExpanded(false)
			glideDataRequested = false

			-- LVS placeholder
			lvsNode = vehicleTree:AddNode(string.format(UVString("uv.base.selectload"), "[" .. UVString("uv.base.lvs") .. "]"))
			lvsNode:SetExpanded(false)
			lvsDataRequested = false
		end

		BuildVehicleTree()

		-- Request server data when Glide node is selected
		function glideNode:OnNodeSelected()
			if glideDataRequested then return end
			glideDataRequested = true

			net.Start("RequestGlideVehicles")
			net.SendToServer()
		end

		-- Request server data when LVS node is selected
		function lvsNode:OnNodeSelected()
			if lvsDataRequested then return end
			lvsDataRequested = true

			net.Start("RequestLVSVehicles")
			net.SendToServer()
		end

		-- if glideDataRequested then return end
		-- glideDataRequested = true

		-- net.Start("RequestGlideVehicles")
		-- net.SendToServer()

		-- Receive Glide vehicle data
		net.Receive("GlideVehiclesTable", function()
			local glideVehicles = net.ReadTable()
			local glideCategories = list.Get("GlideCategories") or {}

			if IsValid(glideNode) then
				glideNode:SetText("Glide")
			end

			-- Always show Default first
			if glideVehicles["Default"] then
				local defaultNode = glideNode:AddNode("Default")
				AddVehicleNodes(defaultNode, glideVehicles["Default"])
			end

			-- Populate Glide categories
			for catID, catData in SortedPairs(glideCategories) do
				local vehicles = glideVehicles[catID] or {}
				if #vehicles > 0 then
					local catNode = glideNode:AddNode(catData.name or catID)
					AddVehicleNodes(catNode, vehicles)
				end
			end
		end)

		-- Receive LVS vehicle data
		net.Receive("LVSVehiclesTable", function()
			local lvsVehicles = net.ReadTable()
			local lvsCategories = list.Get("LVSVehicles") or {}

			if IsValid(lvsNode) then
				lvsNode:SetText("[LVS]")
			end

			-- Always show Default first
			if lvsVehicles["Default"] then
				local defaultNode = lvsNode:AddNode("Default")
				AddVehicleNodes(defaultNode, lvsVehicles["Default"])
			end
			

			-- Populate LVS categories
			for catID, catData in pairs(lvsVehicles) do
				local vehicles = lvsVehicles[catID] or {}
				if #vehicles > 0 then
					local catNode = lvsNode:AddNode(catData.name or catID)
					AddVehicleNodes(catNode, vehicles)
				end
			end
		end)

		-- /// End of Vehicle Override Code /// --
		
		p.OnMousePressed = function(self, mouse)
			if mouse == MOUSE_RIGHT then
				-- RunConsoleCommand(st.convar, "")
				if st.sv and string.match(st.convar, 'unitvehicle_') then
					net.Start("UVUpdateSettings")
					net.WriteTable({ [st.convar] = "" })
					net.SendToServer()
				else
					racerconvar:SetString( "" )
				end
				
				selectedRacers = {}

				vehicleTree:Clear()
				classToNode = {}

				-- Rebuild nodes (call a function instead of duplicating)
				BuildVehicleTree()
				
				glideDataRequested = true
				net.Start("RequestGlideVehicles")
				net.SendToServer()

				lvsDataRequested = true
				net.Start("RequestLVSVehicles")
				net.SendToServer()

				UVMenu.PlaySFX("confirm")
			end
		end

		if st.desc then
			p.OnCursorEntered = function()
				if descPanel then
					descPanel.Desc = st.desc or ""
				end
			end

			p.OnCursorExited = function()
				if descPanel then
					descPanel.Desc = ""
				end
			end
			
			vehicleTree.OnCursorEntered = function()
				if descPanel then
					descPanel.Desc = st.desc or ""
				end
			end

			vehicleTree.OnCursorExited = function()
				if descPanel then
					descPanel.Desc = ""
				end
			end
		end
		
		if promptBar then 
			p.OnCursorEntered = function() promptBar.Prompts = { "uv.prompt.clear.list" } end
			p.OnCursorExited = function() promptBar.Prompts = nil end
			
			-- vehicleTree.OnCursorEntered = function() promptBar.Prompts = { "uv.prompt.reset" } end
			-- vehicleTree.OnCursorExited = function() promptBar.Prompts = nil end
		end
		
		return p
	end

	if st.type == "voiceprofile" then
		local panel = vgui.Create("DPanel", parent)
		panel:Dock(TOP)
		panel:DockMargin(8, 4, 8, UV.ScaleH(1))
		panel:SetTall(st.voicevar and UV.ScaleH(240) or UV.ScaleH(90))
		panel.Paint = nil

		local voiceCVar = st.voicevar and GetConVar(st.voicevar)
		local profileCVar = st.profilevar and GetConVar(st.profilevar)

		-- Left
		local left = vgui.Create("DPanel", panel)
		left:Dock(TOP)
		left:SetWide(UV.ScaleW(300))
		left:DockMargin(3, 3, 3, 3)
		left.Paint = function(self, w, h)
			local text = UVString(GetDisplayText()) or "???"
			DrawWrappedText(self, text, w * 0.95, w * 0.5, w * 0 - 5, true, "UVSettingsFontBig")
		end

		-- Right
		local right = vgui.Create("DPanel", panel)
		right:Dock(FILL)
		right:DockMargin(6, 6, 6, 6)
		right.Paint = nil

		-- Profile combo
		local profileCombo = vgui.Create("UVCombo", right)
		profileCombo:Dock(TOP)
		profileCombo:SetTall(UV.ScaleH(22))
		profileCombo.Paint = function(self, w, h)
			local hovered = self.Button:IsHovered()
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
				GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
				)

			-- background & text
			draw.RoundedBox(12, 0, 0, w, h, default)
			if hovered then draw.RoundedBox(12, 0, 0, w, h, hover) end
		end

		-- Populate profiles (1:1 with uvunitmanager)
		local profiles = {}
		local _, folders = file.Find("sound/chatter2/*", "GAME")
		if folders then
			for _, v in ipairs(folders) do
				profileCombo:AddChoice(v, v)
				profiles[v] = true
			end
		end

		local scroll
		
		-- Helpers
		local function getVoiceTable()
			if not voiceCVar then return {} end
			local str = voiceCVar:GetString() or ""
			local tbl = {}
			for entry in string.gmatch(str, "([^,]+)") do
				tbl[string.Trim(entry)] = true
			end
			return tbl
		end

		local function refreshList(profile)
			if not scroll then return end
			scroll:Clear()

			local _, folders = file.Find("sound/chatter2/" .. profile .. "/*", "GAME")
			if not folders then return end

			local selected = getVoiceTable()

			for _, folder in ipairs(folders) do
				if folder ~= "dispatch" and folder ~= "misc" then
					local btn = scroll:Add("DButton")
					btn:Dock(TOP)
					btn:DockMargin(0, 0, 0, 4)
					btn:SetTall(UV.ScaleH(24))
					btn:SetText("")

					btn.Selected = selected[folder]

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
							GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
						)

						local col = self.Selected and active or default

						-- background & text
						draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, col)
						if hovered then draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, hover) end
						DrawWrappedText(self, folder, w * 0.95, w*0.5, 0, true, "UVSettingsFontSmall")
					end

					btn.DoClick = function(self)
						self.Selected = not self.Selected
						selected[folder] = self.Selected

						local newList = {}
						for k, v in pairs(selected) do
							if v then table.insert(newList, k) end
						end

						if st.sv and string.match(st.voicevar, "unitvehicle_") then
							net.Start("UVUpdateSettings")
							net.WriteTable({ [st.voicevar] = table.concat(newList, ",") })
							net.SendToServer()
						else
							GetConVar(st.voicevar):SetString( table.concat(newList, ",") )
						end

						if self.Selected then
							if folder == "cross" and profile == "nfs most wanted 2005" then
								surface.PlaySound("ui/uvcross.mp3")
							else
								local files = file.Find("sound/chatter2/" .. profile .. "/" .. folder .. "/onscene/*", "GAME")
								table.Shuffle(files)

								if next(files) then
									surface.PlaySound("chatter2/" .. profile .. "/" .. folder .. "/onscene/" .. files[1])
								end
							end
						end
					end

					btn.OnCursorEntered = function()
						if descPanel then
							descPanel.Desc = st.desc or ""
							
							if st.voicevar then
								descPanel.SelectedDefault = GetConVar(st.voicevar):GetDefault() or "?"
								descPanel.SelectedCurrent = GetConVar(st.voicevar):GetString() or "?"
								descPanel.SelectedConVar = st.voicevar or "?"
							end
						end
						
						if promptBar then promptBar.Prompts = { "uv.prompt.toggle" } end
					end

					btn.OnCursorExited = function()
						if descPanel then
							descPanel.Desc = ""
							if st.voicevar then
								descPanel.SelectedDefault = ""
								descPanel.SelectedCurrent = ""
								descPanel.SelectedConVar = ""
							end
						end
						if promptBar then promptBar.Prompts = nil end
					end
				end
			end
		end

		if voiceCVar then
			scroll = vgui.Create("DScrollPanel", right)
			scroll:Dock(FILL)
			scroll:DockMargin(0, 6, 0, 0)
			scroll.Paint = function(self, w, h)
				draw.RoundedBox(5, 0, 0, w, h, Color(115, 115, 115, 255))
				draw.RoundedBox(5, 1, 1, w - 2, h - 2, Color(0, 0, 0))
			end

			local function clear()
				if st.sv and string.match(st.voicevar, "unitvehicle_") then
					net.Start("UVUpdateSettings")
					net.WriteTable({ [st.voicevar] = " " })
					net.SendToServer()
				else
					-- For some UNKNOWN REASON, convar is not set immediately using RunConsoleCommand before running refreshList
					local convar = GetConVar(st.voicevar)
					if convar then
						convar:SetString("")
					else
						RunConsoleCommand(st.voicevar, "")
					end
				end

				refreshList(profileCombo.Value)
			end

			-- UV.BuildSetting( panel, { type = "button", text = "Clear" } )
		end

		-- Profile select
		profileCombo.OnSelect = function(_, val, data)
			if not data or data == "" then return end
			if scroll then scroll:Clear() end
			profileCombo:SetValue(data)

			if st.sv and string.match(st.profilevar, "unitvehicle_") then
				net.Start("UVUpdateSettings")
				net.WriteTable({ [st.profilevar] = data })
				net.SendToServer()
			else
				GetConVar(st.profilevar):SetString( data )
			end

			if st.voicevar and string.match(st.voicevar, "unitvehicle_") and st.sv then
				net.Start("UVUpdateSettings")
				net.WriteTable({ [st.voicevar] = "" })
				net.SendToServer()
			elseif st.voicevar then
				GetConVar(st.voicevar):SetString( "" )
			end
			
			timer.Simple(0.1, function()
				refreshList(data)
			end)
		end

		left.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				
				if st.profilevar then
					descPanel.SelectedDefault = GetConVar(st.profilevar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.profilevar):GetString() or "?"
					descPanel.SelectedConVar = st.profilevar or "?"
				end
			end
		end

		left.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.profilevar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				end
			end
		end

		right.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				
				if st.profilevar then
					descPanel.SelectedDefault = GetConVar(st.profilevar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.profilevar):GetString() or "?"
					descPanel.SelectedConVar = st.profilevar or "?"
				end
			end
		end

		right.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				if st.profilevar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				end
			end
		end

		profileCombo.Button.OnCursorEntered = function()
			if descPanel then
				descPanel.Desc = st.desc or ""
				
				if st.profilevar then
					descPanel.SelectedDefault = GetConVar(st.profilevar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.profilevar):GetString() or "?"
					descPanel.SelectedConVar = st.profilevar or "?"
				end
			end
			if promptBar and st.profilevar then promptBar.Prompts = { "uv.prompt.open" } end
		end

		profileCombo.Button.OnCursorExited = function()
			if descPanel then
				descPanel.Desc = ""
				
				if st.profilevar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				end
			end
			if promptBar then promptBar.Prompts = nil end
		end

		-- Init
		timer.Simple(0, function()
			if not IsValid(profileCombo) then return end
			local profile = profileCVar and profileCVar:GetString()
			if profile and profile ~= "" then
				profileCombo:SetValue(profile)
				refreshList(profile)
			-- else
			-- 	for name in pairs(profiles) do
			-- 		profileCombo:SetValue(name)
			-- 		-- RunConsoleCommand(profileCVar:GetName(), name)
			-- 		if st.sv and string.match(st.profilevar, "unitvehicle_") then
			-- 			net.Start("UVUpdateSettings")
			-- 			net.WriteTable({ [st.profilevar] = name })
			-- 			net.SendToServer()
			-- 		else
			-- 			profileCVar:SetString( name )
			-- 		end
			-- 		refreshList(name)
			-- 		break
			-- 	end
			end
		end)

		return panel
	end
	
	if st.type == "presets" then
		local panel = vgui.Create("DPanel", parent)
		panel:Dock(TOP)
		--panel:DockMargin(8, 4, 8, 4)
		panel:SetTall(UV.ScaleH(600))

		panel.Paint = function(self, w, h)
			local a = self:GetAlpha()
			surface.SetDrawColor( GetConVar("uvmenu_col_desc_r"):GetInt(), GetConVar("uvmenu_col_desc_g"):GetInt(), GetConVar("uvmenu_col_desc_b"):GetInt(), math.floor(GetConVar("uvmenu_col_desc_a"):GetInt() * (a / 255)) )
			surface.DrawRect(0, 0, w, h)
		end

		local scroll = vgui.Create("DScrollPanel", panel)
		scroll:Dock(FILL)
		scroll:DockMargin(0, 6, 0, 0)
		scroll.Paint = nil

		local presetName = ""
		local textbox = nil

		local presetArray = UVPresets[st.preset]

		local function addButton(name)
			local preset = presetArray[name]
			local btn = scroll:Add("DButton")
			btn:Dock(TOP)
			btn:DockMargin(0, 0, 6, 6)
			btn:SetTall(UV.ScaleH(30))
			btn:SetText("")

			btn.Paint = function(self, w, h)
				--btn:SetVisible(string.Trim(presetName) == "" or string.match(name:lower(), presetName:lower()))
				if not presetArray[name] then btn:Remove() return end

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
					GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
				)
				draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, default)
				if hovered then draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, hover) end
				DrawWrappedText(self, preset, w * 0.95, w*0.5, nil, true)
			end

			btn.DoClick = function(self)
				if st.preset == 'uvunitmanager' then
					if st.importonly and st.func then st.func(self, name, preset) return end
					UVMenu.CloseCurrentMenu(true)
					UVMenu.PlaySFX("clickopen")
					timer.Simple(tonumber(GetConVar("uvmenu_close_speed"):GetString()) or 0.2, function()
						UVMenu.PlaySFX("menuopen") -- This shouldn't be necessary but ah well
						UVMenu.CurrentMenu = UVMenu:Open({
							Name = " ",
							Width  = UV.ScaleW(800),
							Height = UV.ScaleH(400),
							DynamicHeight = true,
							HideCloseButton = true,
							UnfocusClose = false,
							Tabs = {
								{ TabName = "uv.hm.presets.warning", Icon = "unitvehicles/icons/generic_alert.png", ShowIcon = true, 
									{ type = "infosimple", text = string.format( UVString("uv.hm.presets.confirm"), preset ) },
									{ type = "button", text = "openurl.yes", prompts = {"uv.prompt.confirm"}, func = 
									function(self2)
										net.Start("UVPresets_Load")
										net.WriteString('uvunitmanager')
										net.WriteString(name)
										net.SendToServer()
										--UVUnitManagerLoadPresetV2(name, preset)
										UVMenu.PlaySFX("clickopen")
										UVMenu.CloseCurrentMenu(true)
										timer.Simple(tonumber(GetConVar("uvmenu_close_speed"):GetString()) or 0.2, function()
											UVMenu.PlaySFX("menuopen") -- This shouldn't be necessary but ah well
											UVMenu.OpenMenu(UVMenu.HeatManager, true)
										end)
									end
									},
									{ type = "button", text = "openurl.nope", prompts = {"uv.prompt.return"}, func = 
									function(self2)
										UVMenu.PlaySFX("clickback")
										UVMenu.CloseCurrentMenu(true)
										timer.Simple(tonumber(GetConVar("uvmenu_close_speed"):GetString()) or 0.2, function()
											UVMenu.PlaySFX("menuopen") -- This shouldn't be necessary but ah well
											UVMenu.OpenMenu(UVMenu.HeatManager, true)
										end)
									end
									},
								}

							}
						})
					end)
				end
			end

			btn.DoRightClick = function(self)
				textbox:SetValue(preset)
				presetName = preset
			end
					
			btn.OnCursorEntered = function() 
				if promptBar then 
					if st.importonly then
						promptBar.Prompts = { "uv.prompt.presetl" }
					else
						promptBar.Prompts = { "uv.prompt.presetl", "uv.prompt.presetr" }
					end
				end
			end
			btn.OnCursorExited = function() if promptBar then promptBar.Prompts = nil end end
		end

		local function refreshButtons()
			scroll:Clear()

			local buttonNames = {}
			for name, _ in pairs(presetArray) do
				table.insert(buttonNames, name)
			end
			table.sort(buttonNames, function(a, b)
				return tostring(a):lower() < tostring(b):lower()
			end)
	
			for _, name in ipairs(buttonNames) do
				addButton( name )
			end
		end

		refreshButtons()

		-- local exportPanel
		-- if not st.importonly then
		-- 	exportPanel = vgui.Create("DButton", panel)
		-- 	exportPanel:Dock(BOTTOM)
		-- 	exportPanel:DockMargin(6, 6, 6, 6)
		-- 	exportPanel:SetWide(UV.ScaleW(450))
		-- 	exportPanel:SetText(" ")
		-- 	function exportPanel:PerformLayout()
		-- 		local text = UVString("uv.hm.presets.export")
		-- 		local w = self:GetWide()
		-- 		if w <= 0 then return end
		-- 		local newTall = math.max(UV.ScaleH(30), GetDynamicTall(text, w * 0.95))
		-- 		if self:GetTall() ~= newTall then self:SetTall(newTall) end
		-- 	end
		-- 	exportPanel.Paint = function(self, w, h)
		-- 		local hovered = self:IsHovered()
		-- 		local default = Color( 
		-- 			GetConVar("uvmenu_col_button_r"):GetInt(),
		-- 			GetConVar("uvmenu_col_button_g"):GetInt(),
		-- 			GetConVar("uvmenu_col_button_b"):GetInt(),
		-- 			GetConVar("uvmenu_col_button_a"):GetInt() * (presetName == "" and 0.1 or 1)
		-- 		)
		-- 		local hover = Color( 
		-- 			GetConVar("uvmenu_col_button_hover_r"):GetInt(),
		-- 			GetConVar("uvmenu_col_button_hover_g"):GetInt(),
		-- 			GetConVar("uvmenu_col_button_hover_b"):GetInt(),
		-- 			GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4)) * (presetName == "" and 0.1 or 1)
		-- 		)
		-- 		draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, default)
		-- 		if hovered then draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, hover) end
		-- 		DrawWrappedText(self, UVString("uv.hm.presets.export"), w * 0.95, w*0.5, nil, true, nil, nil, 
		-- 		presetName == "" and Color(255,255,255,50) or nil)
		-- 	end

		-- 	exportPanel.OnCursorEntered = function()
		-- 		if descPanel then descPanel.Desc = "uv.hm.presets.export.desc" end
		-- 		if promptBar and presetName ~= "" then promptBar.Prompts = { "uv.prompt.export" } end
		-- 	end
			
		-- 	exportPanel.OnCursorExited = function()
		-- 		if descPanel then descPanel.Desc = "" end
		-- 		if promptBar then promptBar.Prompts = nil end
		-- 	end
			
		-- 	exportPanel.DoClick = function(self)
		-- 		if string.Trim(presetName) ~= "" then
		-- 			UVUnitManagerExportPreset(presetName)
		-- 		else
		-- 			notification.AddLegacy(UVString("uv.hm.presets.presetname.require"), NOTIFY_UNDO, 5)
		-- 		end
		-- 	end
		-- end

		--

		local panelBottom
		if not st.importonly then
			panelBottom = vgui.Create("DPanel", panel)
			panelBottom:Dock(BOTTOM)
			panelBottom:DockMargin(6, 6, 6, 6)
			panelBottom:SetTall(UV.ScaleH(100))
			panelBottom.Paint = function(self, w, h)
				--draw.RoundedBox(4, 0, 0, w, h, Color(119,119,119,200))
			end

			textbox = vgui.Create("DTextEntry", panelBottom)
			textbox:Dock(TOP)
			textbox:DockMargin(6, 6, 6, 6)
			textbox:SetWide(UV.ScaleW(250))
			textbox:SetTall(UV.ScaleH(35))
			textbox:SetFont("UVSettingsFont")
			textbox:SetTextColor(color_white)
			textbox:SetHighlightColor(Color(58,193,0))
			textbox:SetCursorColor(Color(58,193,0))
			textbox:SetPlaceholderColor( Color(174, 174, 174) )
			textbox.Paint = function(self2, w, h)
				draw.RoundedBox(4, 0, 0, w, h, Color(119,119,119,200))
				self2:DrawTextEntryText(color_white, Color(58,193,0), color_white)
				if not self2:IsEditing() and self2:GetText() == "" then
					markup.Parse( UVReplaceKeybinds( "<color=255,255,255,100><font=UVSettingsFont>" .. UVString("uv.hm.presets.presetname") .. "</font></color>" ), w * 0.95 ):Draw( 8, h * 0.5, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
			end

			textbox.OnTextChanged = function(self)
				presetName = self:GetValue()
			end

			local typing = false

			textbox.OnGetFocus = function()
				typing = true
				if IsValid(UV.SettingsFrame) then
					UV.SettingsFrame:SetKeyboardInputEnabled(true)
				end
			end

			textbox.OnLoseFocus = function()
				typing = false
				if IsValid(UV.SettingsFrame) then
					UV.SettingsFrame:SetKeyboardInputEnabled(false)
				end
			end
		end

		--

		local saveBtn
		
		if not st.importonly then
			saveBtn = vgui.Create("DButton", panelBottom)
			saveBtn:Dock(RIGHT)
			saveBtn:DockMargin(6, 6, 6, 6)
			saveBtn:SetWide(UV.ScaleW(400))
			saveBtn:SetTall(UV.ScaleH(35))
			saveBtn:SetText(" ")

			saveBtn.DoClick = function(self)
				presetName = textbox:GetValue()
				
				if st.preset == 'uvunitmanager' then
					local data = {}

					-- for key, value in pairs(UVUnitsConVars) do
					-- 	local newKey = 'unitvehicle_unit_' .. key
					-- 	local convar = GetConVar(newKey)
					-- 	if convar then
					-- 		data[newKey] = convar:GetString()
					-- 	end
					-- end

					if string.Trim(presetName) ~= "" then
						-- local presetFile

						-- for file, name in pairs(presetArray) do
						-- 	if name == presetName then
						-- 		presetFile = file
						-- 		break
						-- 	end
						-- end

						net.Start("UVPresets_Save")
						net.WriteString('uvunitmanager')
						net.WriteString(presetName)
						net.SendToServer()
						--presets.Add(st.preset, presetName, data)
						refreshButtons()
						notification.AddLegacy(string.format(UVString("uv.tool.saved"), presetName), NOTIFY_UNDO, 5)
					else
						notification.AddLegacy(UVString("uv.hm.presets.presetname.require"), NOTIFY_UNDO, 5)
					end
				end
			end

			saveBtn.OnCursorEntered = function()
				if descPanel then descPanel.Desc = "uv.hm.presets.save.desc" end
				if promptBar and presetName ~= "" then promptBar.Prompts = { "uv.prompt.presets" } end
			end
			
			saveBtn.OnCursorExited = function()
				if descPanel then descPanel.Desc = "" end
				if promptBar then promptBar.Prompts = nil end
			end
			
			saveBtn.Paint = function(self, w, h)
				local hovered = self:IsHovered()

				local default = Color( 
					GetConVar("uvmenu_col_button_r"):GetInt(),
					GetConVar("uvmenu_col_button_g"):GetInt(),
					GetConVar("uvmenu_col_button_b"):GetInt(),
					GetConVar("uvmenu_col_button_a"):GetInt() * (presetName == "" and 0.1 or 1)
				)
				local hover = Color( 
					GetConVar("uvmenu_col_button_hover_r"):GetInt(),
					GetConVar("uvmenu_col_button_hover_g"):GetInt(),
					GetConVar("uvmenu_col_button_hover_b"):GetInt(),
					GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4)) * (presetName == "" and 0.1 or 1)
				)
				
				draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, default)
				if hovered then draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, hover) end
				DrawWrappedText(self, UVString("uv.hm.presets.save"), w * 0.95, w*0.5, nil, true, nil, nil, 
				presetName == "" and Color(255,255,255,50) or nil)
			end
		end

		--

		local deleteBtn
		
		if not st.importonly then
			deleteBtn = vgui.Create("DButton", panelBottom)
			deleteBtn:Dock(LEFT)
			deleteBtn:DockMargin(6, 6, 6, 6)
			deleteBtn:SetWide(UV.ScaleW(400))
			deleteBtn:SetTall(UV.ScaleH(35))
			deleteBtn:SetText(" ")

			deleteBtn.DoClick = function(self)
				if string.Trim(presetName) ~= "" then
					local presetFile

					for file, name in pairs(presetArray) do
						if name == presetName then
							presetFile = file
							break
						end
					end
					
					net.Start("UVPresets_Remove")
					net.WriteString('uvunitmanager')
					net.WriteString(presetFile)
					net.SendToServer()

					presetArray[presetFile] = nil
					notification.AddLegacy(string.format(UVString("uv.tool.deleted"), presetName), NOTIFY_UNDO, 5)
					-- if presets.Exists(st.preset, presetName) then 
					-- 	presets.Remove(st.preset, presetName)
					-- 	presetArray[presetName] = nil
					-- 	notification.AddLegacy(string.format(UVString("uv.tool.deleted"), presetName), NOTIFY_UNDO, 5)
					-- end			
				end
			end

			deleteBtn.Paint = function(self, w, h)
				local hovered = self:IsHovered()
				local default = Color( 
					GetConVar("uvmenu_col_button_r"):GetInt(),
					GetConVar("uvmenu_col_button_g"):GetInt(),
					GetConVar("uvmenu_col_button_b"):GetInt(),
					GetConVar("uvmenu_col_button_a"):GetInt() * (presetName == "" and 0.1 or 1)
				)
				local hover = Color( 
					GetConVar("uvmenu_col_button_hover_r"):GetInt(),
					GetConVar("uvmenu_col_button_hover_g"):GetInt(),
					GetConVar("uvmenu_col_button_hover_b"):GetInt(),
					GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4)) * (presetName == "" and 0.1 or 1)
				)
				draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, default)
				if hovered then draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, hover) end
				DrawWrappedText(self, UVString("uv.hm.presets.delete"), w * 0.95, w*0.5, nil, true, nil, nil, 
				presetName == "" and Color(255,255,255,50) or nil)
			end
			
			deleteBtn.OnCursorEntered = function()
				if descPanel then descPanel.Desc = "uv.hm.presets.delete.desc" end
				if promptBar and presetName ~= "" then promptBar.Prompts = { "uv.prompt.presetd" } end
			end
			
			deleteBtn.OnCursorExited = function()
				if descPanel then descPanel.Desc = "" end
				if promptBar then promptBar.Prompts = nil end
			end
		end

		return panel
	end
	
	if st.type == "unitselect" or st.type == "drivermodel" then
		local panel = vgui.Create("DPanel", parent)
		panel:Dock(TOP)
		panel:DockMargin(8, 4, 8, 4)
		panel:SetTall(UV.ScaleH(300))
		panel.Paint = nil

		local title = vgui.Create("DLabel", panel)
		title:Dock(TOP)
		title:SetTall(UV.ScaleH(40))
		title:SetText("")
		title:SetContentAlignment(5)
		title.Paint = function(self, w, h)
			local text = UVString(GetDisplayText()) or "???"
			DrawWrappedText(self, text, w * 0.95, w * 0.5, 2.5, true, "UVSettingsFontBig")
		end

		local body = vgui.Create("DPanel", panel)
		body:Dock(FILL)
		body:DockMargin(0, 4, 0, 4)
		body.Paint = nil

		local left = vgui.Create("DScrollPanel", body)
		left:Dock(LEFT)
		left:SetWide(UV.ScaleW(400))
		left:DockMargin(6, 0, 3, 0)
		left.Paint = function(self, w, h)
			draw.RoundedBox(5, 0, 0, w, h, Color(115, 115, 115))
			draw.RoundedBox(5, 1, 1, w - 2, h - 2, Color(0, 0, 0))
		end

		local right = vgui.Create("DScrollPanel", body)
		right:Dock(FILL)
		right:DockMargin(3, 0, 6, 0)
		right.Paint = function(self, w, h)
			draw.RoundedBox(5, 0, 0, w, h, Color(115, 115, 115))
			draw.RoundedBox(5, 1, 1, w - 2, h - 2, Color(0, 0, 0))
		end

		local vehicleBases = {
			{ id = 1, name = "HL2", path = "prop_vehicle_jeep>>units", type = "txt"  },
			{ id = 2, name = "Simfphys", path = "simfphys>>units", type = "txt"  },
			{ id = 3, name = "Glide", path = "glide>>units", type = "json" },
			{ id = 4, name = "LVS", path = "lvs>>units", type = "json" },
			{ id = 5, name = "DriverModel", path = "drivermodels", type = "json" }
		}
		
		local activeFilterBaseId = 0 -- 0 = show all

		if st.type == "drivermodel" then
			activeFilterBaseId = 5
		end
		
		local filterBar = vgui.Create("DIconLayout", panel)
		filterBar:Dock(TOP)
		filterBar:SetTall(UV.ScaleH(60))
		filterBar:SetSpaceX(4)
		filterBar:SetSpaceY(4)
		filterBar:DockMargin(UV.ScaleW(6), 0, UV.ScaleW(6), UV.ScaleW(6))
		filterBar.Paint = nil

		filterBar.OnSizeChanged = function(self, w)
			local spacing = self:GetSpaceX()
			-- local spacing = self:GetWide()
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
		
		-- Bottom warning panel
		local warningPanel = vgui.Create("DLabel", panel)
		warningPanel:Dock(TOP)
		warningPanel:SetTall(0) -- start hidden
		warningPanel:SetText("")
		warningPanel:SetTextColor(Color(255, 100, 100))
		warningPanel:SetContentAlignment(5)
		warningPanel.Paint = nil

		local originalTall = panel:GetTall()

		local function updateWarning(tbl)
			local list = {}
			for k, v in pairs(tbl) do
				if v then table.insert(list, k) end
			end
			local str = table.concat(list, " ")

			if #str > 1000 then -- used to be 256, you can set this to higher although you probably shouldn't
				warningPanel:SetText("/// Too many units selected! ///")
				warningPanel:SetTall(UV.ScaleH(20))
				panel:SetTall(originalTall + UV.ScaleH(20))
				return true
			else
				warningPanel:SetText("")
				warningPanel:SetTall(0)
				panel:SetTall(originalTall)
				return false
			end
		end

		local function setUnitTable(tbl)
			local list = {}
			for k, v in pairs(tbl) do
				if v then table.insert(list, k) end
			end

			local str = table.concat(list, " ")

			local overLimit = updateWarning(tbl)

			if st.sv then
				net.Start("UVUpdateSettings")
				net.WriteTable({ [st.convar] = str })
				net.SendToServer()
			else
				local cvar = GetConVar(st.convar)
				if cvar then
					cvar:SetString(str)
				end
			end

			return overLimit
		end

		local function getUnitTable()
			local cvar = GetConVar(st.convar)
			if not cvar then return {} end

			local tbl = {}
			for entry in string.gmatch(cvar:GetString() or "", "([^%s]+)") do
				tbl[string.Trim(entry)] = true
			end
			return tbl
		end

		local function getAvailableUnits()
			local entries = {}

			for _, base in ipairs(vehicleBases) do
				local files = UV_GetFiles( base.path ) or {}
				for _, filename in ipairs(files) do
					table.insert(entries, {
						filename = filename, -- stored value
						base  = base.name,
						display  = st.type == "unitselect" and "[ " .. base.name .. " ] " .. filename or filename,
						baseId   = base.id
					})
				end
			end

			return entries
		end

		local selected = getUnitTable()

		local function refreshLists()
			left:Clear()
			right:Clear()

			local availableUnits = {}
			local availableUnitsList = getAvailableUnits()
			for _, entry in ipairs(availableUnitsList) do
				availableUnits[entry.filename] = entry
			end

			local selectedEntries = {}
			for filename, value in pairs(selected) do
				if not value then continue end
				local match = availableUnits[filename]
				if match then
					table.insert(selectedEntries, {
						filename = filename,
						base = match.base,
						display = match.display,
						baseId = match.baseId,
						exists = true
					})
				else
					local baseId = 0
					local displayBase = "Unknown"
					for _, base in ipairs(vehicleBases) do
						if filename:EndsWith("." .. base.type) then
							baseId = base.id
							displayBase = base.name
							break
						end
					end
					table.insert(selectedEntries, {
						filename = filename,
						base = displayBase,
						display = "[ " .. displayBase .. " ] " .. filename .. " (missing)",
						baseId = baseId,
						exists = false
					})
				end
			end

			local unselEntries = {}
			for _, entry in ipairs(availableUnitsList) do
				if not selected[entry.filename] then
					table.insert(unselEntries, entry)
				end
			end

			for _, entry in ipairs(selectedEntries) do
				if (activeFilterBaseId ~= 0 and entry.baseId ~= activeFilterBaseId) or (st.type == "unitselect" and entry.baseId == 5) then
					continue
				end

				local btn = right:Add("DButton")
				btn:Dock(TOP)
				btn:DockMargin(0, 0, 0, 4)
				btn:SetTall(UV.ScaleH(24))
				btn:SetText("")
				btn.Selected = true
				btn.Missing = not entry.exists

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
					
					local col
					if self.Missing then
						col = Color(200, 30, 30, 235)
					else
						col = active
					end
					draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, col)
					if hovered then
						draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, hover)
					end

					local textCol = self.Missing and Color(255,60,60) or nil
					DrawWrappedText(self, entry.display, w * 0.95, w * 0.05, 0, nil, "UVSettingsFontSmall", nil, textCol)
				end

				btn.DoClick = function()
					local tmpSelected = table.Copy(selected)
					tmpSelected[entry.filename] = not tmpSelected[entry.filename]

					local overLimit = setUnitTable(tmpSelected)
					if overLimit then return end

					selected[entry.filename] = tmpSelected[entry.filename]
					btn.Selected = selected[entry.filename]
					refreshLists()
				end

				btn.OnCursorEntered = function()
					if promptBar then promptBar.Prompts = { "uv.prompt.unitselect" } end
				end

				btn.OnCursorExited = function()
					if promptBar then promptBar.Prompts = nil end
				end
			end

			for _, entry in ipairs(unselEntries) do
				if (activeFilterBaseId ~= 0 and entry.baseId ~= activeFilterBaseId) or (st.type == "unitselect" and entry.baseId == 5) then
					continue
				end

				local btn = left:Add("DButton")
				btn:Dock(TOP)
				btn:DockMargin(0, 0, 0, 4)
				btn:SetTall(UV.ScaleH(24))
				btn:SetText("")
				btn.Selected = false

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

					local col = default
					draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, col)
					if hovered then
						draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, hover)
					end

					DrawWrappedText(self, entry.display, w * 0.95, w * 0.05, 0, nil, "UVSettingsFontSmall")
				end

				btn.DoClick = function()
					local tmpSelected = table.Copy(selected)
					tmpSelected[entry.filename] = not tmpSelected[entry.filename]

					local overLimit = setUnitTable(tmpSelected)
					if overLimit then return end

					selected[entry.filename] = tmpSelected[entry.filename]
					btn.Selected = selected[entry.filename]
					refreshLists()
				end

				btn.OnCursorEntered = function()
					if promptBar then promptBar.Prompts = { "uv.prompt.unitselect" } end
				end

				btn.OnCursorExited = function()
					if promptBar then promptBar.Prompts = nil end
				end
			end
		end

		local function addFilterButton(text, baseId)
			local btn = vgui.Create("DButton", filterBar)
			btn:SetTall(24)
			btn:SetText(" ")

			btn.Paint = function(self, w, h)
				local selected = (activeFilterBaseId == baseId)
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
					GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime() * 4))
				)

				local col = selected and active or default
				draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, col)
				if hovered then
					draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, hover)
				end

				draw.SimpleTextOutlined(text, "UVSettingsFontSmall", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.25, color_black)
			end

			btn.DoClick = function()
				activeFilterBaseId = baseId
				refreshLists()
			end
		end

		if st.type == "unitselect" then
			addFilterButton(UVString("all"), 0)
			addFilterButton("HL2", 1)
			addFilterButton("Simfphys", 2)
			addFilterButton("Glide", 3)
			addFilterButton("LVS", 4)
		end

		timer.Simple(0, function()
			if IsValid(panel) then
				refreshLists()
			end
		end)

		return panel
	end

	if st.type == "textbox" then
		local panel = vgui.Create("DTextEntry", parent)
		panel:Dock(TOP)
		panel:DockMargin(6, 6, 6, 6)
		panel:SetTall(UV.ScaleH(40))
		panel:SetText(GetConVar(st.convar):GetString())

		panel.OnTextChanged = function(self)
			GetConVar(st.convar):SetString(self:GetValue())
		end

		return panel
	end

	if st.type == "bindoverride" then
		local panel = vgui.Create("DPanel", parent)
		panel:Dock(TOP)
		panel:DockMargin(8, 4, 8, 4)
		panel:SetTall(UV.ScaleH(250))
		panel.Paint = nil

		local selectedToken = nil
		local selectedGlyph = nil
		local activeGlyphFilter = "kb" -- "kb", "xbox", "ps", "switch"

		local bodyleft = vgui.Create("DPanel", panel)
		bodyleft:Dock(LEFT)
		bodyleft:DockMargin(0, 4, 0, 4)
		bodyleft:SetWide(UV.ScaleW(260))
		bodyleft.Paint = function(self, w, h)
			draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, Color(0,0,0,200))
			DrawWrappedText(self, UVString("uv.controls.glyphs.action"), w * 0.5, w*0.5, h * 0.0, true)
		end

		bodyleft.OnCursorEntered = function() if descPanel then descPanel.Desc = "uv.controls.glyphs.action.desc" end end
		bodyleft.OnCursorExited = function() if descPanel then descPanel.Desc = "" end end

		local bodymiddle = vgui.Create("DPanel", panel)
		bodymiddle:Dock(FILL)
		bodymiddle:DockMargin(0, 4, 0, 4)
		bodymiddle.Paint = function(self, w, h)
			draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, Color(0,0,0,200))
			DrawWrappedText(self, UVString("uv.controls.glyphs.glyph"), w * 0.5, w*0.5, h * 0.0, true)
		end

		bodymiddle.OnCursorEntered = function() if descPanel then descPanel.Desc = "uv.controls.glyphs.glyph.desc" end end
		bodymiddle.OnCursorExited = function() if descPanel then descPanel.Desc = "" end end

		local bodyright = vgui.Create("DPanel", panel)
		bodyright:Dock(RIGHT)
		bodyright:DockMargin(0, 4, 0, 4)
		bodyright:SetWide(UV.ScaleW(260))
		bodyright.Paint = function(self, w, h)
			draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, Color(0,0,0,200))
			DrawWrappedText(self, UVString("uv.controls.glyphs.active"), w * 1, w*0.5, h * 0.0, true)
		end

		bodyright.OnCursorEntered = function() if descPanel then descPanel.Desc = "uv.controls.glyphs.active.desc" end end
		bodyright.OnCursorExited = function() if descPanel then descPanel.Desc = "" end end

		-- Tokens
		local left = vgui.Create("DScrollPanel", bodyleft)
		left:Dock(FILL)
		left:SetWide(UV.ScaleW(260))
		left:DockMargin(6, 30, 3, 0)

		-- Glyphs
		local glyphFilterBar = vgui.Create("DPanel", bodymiddle)
		glyphFilterBar:Dock(TOP)
		glyphFilterBar:SetTall(UV.ScaleH(26))
		glyphFilterBar:DockMargin(6, UV.ScaleH(30), 6, 2)
		glyphFilterBar.Paint = nil
		
		local function AddGlyphFilterButton(text, id)
			local btn = vgui.Create("DButton", glyphFilterBar)
			btn:Dock(LEFT)
			btn:DockMargin(0, 0, 3, 0)
			btn:SetWide(UV.ScaleW(55))
			btn:SetText("")

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

				local col = activeGlyphFilter == id and active or default
				draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, col)
				if hovered then
					draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, hover)
				end

				DrawWrappedText(self, text, w * 0.9, w * 0.5, h * 0.1, true, "UVSettingsFontSmall")
			end

			btn.DoClick = function()
				activeGlyphFilter = id
				BuildGlyphList()
			end
			
			btn.OnCursorEntered = function()
				if promptBar then promptBar.Prompts = { "uv.prompt.filter" } end
			end
			
			btn.OnCursorExited = function()
				if promptBar then promptBar.Prompts = nil end
			end
		end
		
		-- AddGlyphFilterButton(UVString("all"), "all")
		AddGlyphFilterButton("KB", "kb")
		AddGlyphFilterButton("Xbox", "xbox")
		AddGlyphFilterButton("PS", "ps")
		AddGlyphFilterButton("Switch", "switch")

		local mid = vgui.Create("DScrollPanel", bodymiddle)
		mid:Dock(FILL)
		mid:DockMargin(6, 3, 3, 0)

		local midLayout = vgui.Create("DIconLayout", mid)
		midLayout:Dock(FILL)
		midLayout:SetSpaceX(UV.ScaleW(2))
		midLayout:SetSpaceY(UV.ScaleH(6))

		-- Selected / Active
		local right = vgui.Create("DScrollPanel", bodyright)
		right:Dock(FILL)
		right:DockMargin(3, 30, 6, 0)

		local tokenButtons = {}
		local glyphButtons = {}

		local function ClearSelections()
			selectedToken = nil
			selectedGlyph = nil

			for btn in pairs(tokenButtons) do btn.selected = false end
			for btn in pairs(glyphButtons) do btn.selected = false end
		end

		local function TryCommit()
			if not selectedToken or not selectedGlyph then return end

			local raw = UVGlyphSet:GetString()
			local entry = selectedToken .. " " .. selectedGlyph
			UVGlyphSet:SetString(raw ~= "" and (raw .. ", " .. entry) or entry)

			ClearSelections()
			RefreshOverrides()
			BuildTokenList()
		end

		local PresetTokens = {
			{ name = UVString("uv.ptech") .. " 1", token = "key:unitvehicle_pursuittech_keybindslot_1" },
			{ name = UVString("uv.ptech") .. " 2", token = "key:unitvehicle_pursuittech_keybindslot_2" },
			{ name = UVString("uv.keybind.resetposition"), token = "key:unitvehicle_keybind_resetposition" },
			{ name = UVString("uv.keybind.showresults"), token = "key:unitvehicle_keybind_raceresults" },
			{ name = UVString("uv.keybind.skipsong"), token = "key:unitvehicle_keybind_skipsong" },
			{ name = UVString("uv.keybind.prevsong"), token = "key:unitvehicle_keybind_prevsong" },
			{ name = "+jump", token = "+jump" },
			{ name = "+use", token = "+use" },
			{ name = "+reload", token = "+reload" },
			{ name = "+attack", token = "+attack" },
			{ name = "+attack2", token = "+attack2" },
			{ name = "invnext", token = "invnext" },
			{ name = "invprev", token = "invprev" },
			{ name = "+speed", token = "+speed" },
			-- { name = "Controller Navigation", token = "ContrNavi" },
		}
		
		local TokenToName = {}

		for _, entry in ipairs(PresetTokens) do
			TokenToName[entry.token] = entry.name
		end

		function BuildTokenList()
			left:Clear()
			tokenButtons = {}

			local used = {}
			for entry in string.gmatch(UVGlyphSet:GetString(), "([^,]+)") do
				local t = string.Trim(entry):match("^(%S+)")
				if t then used[t] = true end
			end

			for _, entry in ipairs(PresetTokens) do
				if used[entry.token] then continue end

				local btn = left:Add("DButton")
				btn:Dock(TOP)
				btn:DockMargin(0, 0, 0, 4)
				btn:SetTall(UV.ScaleH(28))
				function btn:PerformLayout()
					local text = entry.name
					local w = self:GetWide()
					if w <= 0 then return end
					local newTall = math.max(UV.ScaleH(28), GetDynamicTall(text, w * 0.9, "UVSettingsFontSmall"))
					if self:GetTall() ~= newTall then self:SetTall(newTall) end
				end
				btn:SetText("")
				btn.selected = false

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

					local col = self.selected and active or default
					draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, col)
					if hovered then
						draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, hover)
					end

					DrawWrappedText(self, entry.name, w * 0.9, w * 0.5, h * 0.1, true, "UVSettingsFontSmall")
				end

				btn.DoClick = function()
					selectedToken = entry.token
					for b in pairs(tokenButtons) do b.selected = false end
					btn.selected = true
					TryCommit()
				end
			
				btn.OnCursorEntered = function()
					if promptBar then promptBar.Prompts = { "uv.prompt.select" } end
				end
				
				btn.OnCursorExited = function()
					if promptBar then promptBar.Prompts = nil end
				end
				
				tokenButtons[btn] = entry
			end
		end
		
		local function SortedKeys(tbl)
			local keys = {}
			for k in pairs(tbl) do
				keys[#keys + 1] = k
			end

			table.sort(keys, function(a, b)
				-- numeric keys first (1, 2, 3...)
				local na, nb = tonumber(a), tonumber(b)
				if na and nb then return na < nb end
				if na then return true end
				if nb then return false end

				-- F-keys grouped
				local fa = a:match("^f(%d+)$")
				local fb = b:match("^f(%d+)$")
				if fa and fb then return tonumber(fa) < tonumber(fb) end
				if fa then return true end
				if fb then return false end

				-- fallback alphabetical
				return a < b
			end)

			return keys
		end

		local function AddGlyphButton(code)
			local btn = midLayout:Add("DButton")
			local bw, bh = UV.ScaleW(35), UV.ScaleH(35)
			btn:SetSize(bw, bh)
			btn:SetText("")
			btn.selected = false

			local mk = markup.Parse(UVKeybindIcon(code))

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

				local col = self.selected and active or default
				draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, col)
				if hovered then
					draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, hover)
				end

				mk:Draw(w * 0.5, h * 0.5, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			btn.DoClick = function()
				selectedGlyph = code
				for b in pairs(glyphButtons) do b.selected = false end
				btn.selected = true
				TryCommit()
			end

			btn.OnCursorEntered = function()
				if descPanel then descPanel.Desc = UVKeybindIcon(code, "Big") end
				if promptBar then promptBar.Prompts = { "uv.prompt.select" } end
			end
			
			btn.OnCursorExited = function()
				if descPanel then descPanel.Desc = "" end
				if promptBar then promptBar.Prompts = nil end
			end

			glyphButtons[btn] = code
		end

		function BuildGlyphList()
			midLayout:Clear()
			glyphButtons = {}

			if activeGlyphFilter == "kb" then
				for _, k in ipairs(SortedKeys(UVKeyGlyphs.kb)) do
					AddGlyphButton("kb." .. k)
				end
			end

			if activeGlyphFilter == "xbox" then
				for _, k in ipairs(SortedKeys(UVKeyGlyphs.xbox)) do
					AddGlyphButton("xbox." .. k)
				end
			end

			if activeGlyphFilter == "ps" then
				for _, k in ipairs(SortedKeys(UVKeyGlyphs.ps)) do
					AddGlyphButton("ps." .. k)
				end
			end

			if activeGlyphFilter == "switch" then
				for _, k in ipairs(SortedKeys(UVKeyGlyphs.switch)) do
					AddGlyphButton("switch." .. k)
				end
			end

			midLayout:InvalidateLayout(true)
			mid:InvalidateLayout(true)
			mid:PerformLayout()

			local vbar = mid:GetVBar()
			if IsValid(vbar) then
				vbar:SetEnabled(true)
				vbar:SetVisible(true)
			end
		end

		BuildGlyphList()

		function RefreshOverrides()
			right:Clear()

			for entry in string.gmatch(UVGlyphSet:GetString(), "([^,]+)") do
				entry = string.Trim(entry)

				local token, glyph = entry:match("^(%S+)%s+(%S+)$")
				if not token or not glyph then continue end

				-- Resolve display name
				local displayName = TokenToName[token] or token
				local glyphMarkup = markup.Parse(UVKeybindIcon(glyph))

				local btn = right:Add("DButton")
				btn:Dock(TOP)
				btn:DockMargin(0, 0, 0, 4)
				btn:SetTall(UV.ScaleH(28))
				function btn:PerformLayout()
					local text = displayName
					local w = self:GetWide()
					if w <= 0 then return end
					local newTall = math.max(UV.ScaleH(28), GetDynamicTall(text, w * 0.77, "UVSettingsFontSmall"))
					if self:GetTall() ~= newTall then self:SetTall(newTall) end
				end
				btn:SetText("")

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

					-- LEFT: action name
					DrawWrappedText( self, displayName, w * 0.77, w * 0.05, h * 0.1, false, "UVSettingsFontSmall" )

					-- RIGHT: glyph
					glyphMarkup:Draw( w * 0.92, h * 0.5, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				end

				btn.DoClick = function()
					local out = {}
					for e in string.gmatch(UVGlyphSet:GetString(), "([^,]+)") do
						if string.Trim(e) ~= entry then
							out[#out + 1] = string.Trim(e)
						end
					end
					UVGlyphSet:SetString(table.concat(out, ", "))
					RefreshOverrides()
					BuildTokenList()
				end
							
				btn.OnCursorEntered = function()
					if promptBar then promptBar.Prompts = { "uv.prompt.remove" } end
				end
				
				btn.OnCursorExited = function()
					if promptBar then promptBar.Prompts = nil end
				end
			end
		end

		timer.Simple(0, function()
			BuildTokenList()
			RefreshOverrides()
		end)

		return panel
	elseif st.type == "uvtrax" then
		local panel = vgui.Create("DPanel", parent)
		panel:Dock(TOP)
		panel:DockMargin(8, 4, 8, 4)
		panel:SetTall(UV.ScaleH(400))
		panel.Paint = nil

		local selectedPlaylist = nil
		local activeTrackType = "race"

		local totalTracks = 0
		local enabledTracks = 0

		local TRACK_TYPES = { "race", "ending", "intro", "transition" }
		local TRACK_TYPE_LABELS = {
			race = "Race",
			ending = "Ending",
			intro = "Intro",
			transition = "Transition",
		}

		local LIST_BUILD_FUNCTIONS = {}

		local function isTrackDisabled(plist, ttype, path)
			if not UVTraxSettings or not UVTraxSettings.playlists or not UVTraxSettings.playlists[plist] then return false end
			return UVTraxSettings.playlists[plist][ttype] and UVTraxSettings.playlists[plist][ttype][path]
		end

		local function getPlaylistNames()
			local out = {}

			for name in pairs(UVPlaylists or {}) do
				table.insert( out, name )
			end

			table.sort(out)
			return out
		end

		local bodyleft = vgui.Create("DPanel", panel)
		bodyleft:Dock(LEFT)
		bodyleft:DockMargin(0, 4, 0, 4)
		bodyleft:SetWide(UV.ScaleW(180))

		bodyleft.Paint = function(self, w, h)
			draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, Color(0, 0, 0, 200))
			-- DrawWrappedText(self, UVString("uv.audio.uvtrax.playlists") or "Playlists", w * 0.9, w * 0.5, 4, true)
			DrawWrappedText(self, UVString("uv.audio.uvtrax.profiles"), w * 0.9, w * 0.5, 4, true)
		end

		bodyleft.OnCursorEntered = function() if descPanel then descPanel.Desc = st.desc or "" end end
		bodyleft.OnCursorExited = function() if descPanel then descPanel.Desc = "" end end

		--

		local bodymid = vgui.Create("DPanel", panel)
		bodymid:Dock(FILL)
		bodymid:DockMargin(0, 4, 0, 4)

		bodymid.Paint = function(self, w, h)
			draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, Color(0, 0, 0, 200))
			DrawWrappedText(self, (TRACK_TYPE_LABELS[activeTrackType] or activeTrackType) .. " – " .. (UVString("uv.audio.uvtrax.tracks") or "Tracks"), w * 0.9, w * 0.5, 4, true)
		end

		--

		-- local bodyright = vgui.Create("DPanel", panel)
		-- bodyright:Dock(RIGHT)
		-- bodyright:DockMargin(0, 4, 0, 4)
		-- bodyright:SetWide(UV.ScaleW(200))
		-- bodyright.Paint = function(self, w, h)
		-- 	draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, Color(0, 0, 0, 200))
		-- 	DrawWrappedText(self, UVString("uv.audio.uvtrax.library") or "Add from library", w * 0.9, w * 0.5, 4, true)
		-- end

		local left = vgui.Create("DScrollPanel", bodyleft)
		left:Dock(FILL)
		left:DockMargin(6, 30, 3, 0)

		local typeBar = vgui.Create("DPanel", bodymid)
		typeBar:Dock(TOP)
		typeBar:SetTall(UV.ScaleH(26))
		typeBar:DockMargin(6, UV.ScaleH(30), 6, 2)
		typeBar.Paint = nil

		local itemCount = vgui.Create("DPanel", typeBar)
		itemCount:Dock(RIGHT)
		itemCount:DockMargin(0, 0, 6, 0)
		itemCount:SetWide(UV.ScaleW(100))
		itemCount:SetText("")
		-- itemCount:SetWide(UV.ScaleW(100))
		-- itemCount:SetText("")
		-- itemCount:SetFont("UVSettingsFontSmall")
		-- itemCount:SetTextColor(Color(255, 255, 255, 255))
		-- itemCount:SetTextInset(0, 0)
		-- itemCount:SetText("")
		
		itemCount.Paint = function(self, w, h)
			draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, Color(0, 0, 0, 200))
			DrawWrappedText(self, enabledTracks .. " / " .. totalTracks, w * 0.9, w * 0.5, h * 0.1, true, "UVSettingsFontSmall")
		end

		itemCount.OnCursorEntered = function()
			if descPanel then
				-- descPanel.Desc = UVString("uv.audio.uvtrax.profiles.resettoggle")
				descPanel.Desc = UVString("uv.audio.uvtrax.profiles.loaded")
			end
			if promptBar then promptBar.Prompts = { "uv.prompt.toggletracks" } end
		end
		itemCount.OnCursorExited = function()
			if descPanel then descPanel.Desc = "" end
			if promptBar then promptBar.Prompts = nil end
		end

		itemCount.OnMousePressed = function(self, code)
			if code == MOUSE_RIGHT then
				if selectedPlaylist and activeTrackType then
					local playlist = UVPlaylists[selectedPlaylist] and UVPlaylists[selectedPlaylist][activeTrackType]
					if not playlist then return end

					local disabled = enabledTracks == 0

					for _, track in ipairs(playlist) do
						UVTraxSetTrackDisabled( selectedPlaylist, activeTrackType, track.path, not disabled )
					end

					LIST_BUILD_FUNCTIONS.M()
				end
			end
		end

		local function addTypeButton(label, ttype)
			local btn = vgui.Create("DButton", typeBar)
			btn:Dock(LEFT)
			btn:DockMargin(0, 0, 3, 0)
			btn:SetWide(UV.ScaleW(90))
			btn:SetText("")

			btn.Paint = function(self, w, h)
				local hovered = self:IsHovered()

				local default = Color(GetConVar("uvmenu_col_button_r"):GetInt(), GetConVar("uvmenu_col_button_g"):GetInt(), GetConVar("uvmenu_col_button_b"):GetInt(), GetConVar("uvmenu_col_button_a"):GetInt())
				local active = Color(GetConVar("uvmenu_col_bool_active_r"):GetInt(), GetConVar("uvmenu_col_bool_active_g"):GetInt(), GetConVar("uvmenu_col_bool_active_b"):GetInt(), GetConVar("uvmenu_col_button_a"):GetInt())
				local hover = Color(GetConVar("uvmenu_col_button_hover_r"):GetInt(), GetConVar("uvmenu_col_button_hover_g"):GetInt(), GetConVar("uvmenu_col_button_hover_b"):GetInt(), GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime() * 4)))

				local col = activeTrackType == ttype and active or default

				draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, col)
				if hovered then draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, hover) end
				DrawWrappedText(self, label, w * 0.9, w * 0.5, h * 0.1, true, "UVSettingsFontSmall")
			end

			btn.DoClick = function()
				activeTrackType = ttype
				timer.Simple(0, function() LIST_BUILD_FUNCTIONS.M() end)
			end

			btn.OnCursorEntered = function()
				if promptBar then promptBar.Prompts = { "uv.prompt.filter" } end
			end
			
			btn.OnCursorExited = function()
				if promptBar then promptBar.Prompts = nil end
			end
		end

		for _, ttype in ipairs(TRACK_TYPES) do
			addTypeButton(TRACK_TYPE_LABELS[ttype], ttype)
		end

		local mid = vgui.Create("DScrollPanel", bodymid)
		mid:Dock(FILL)
		mid:DockMargin(6, 4, 3, 0)

		-- local right = vgui.Create("DScrollPanel", bodyright)
		-- right:Dock(FILL)
		-- right:DockMargin(6, 30, 3, 0)
		

		local function addPlaylistBtn(name, isSelected, onClick)
			local btn = vgui.Create("DButton", left)
			btn:Dock(TOP)
			btn:DockMargin(0, 0, 0, 4)
			-- btn:SetTall(UV.ScaleH(28))
			function btn:PerformLayout()
				local text = name
				local w = self:GetWide()
				if w <= 0 then return end
				local newTall = math.max(UV.ScaleH(24), GetDynamicTall(text, w * 0.9, "UVSettingsFontSmall", "UVSettingsFontSmall"))
				if self:GetTall() ~= newTall then self:SetTall(newTall) end
			end
			btn:SetText("")

			btn.selected = isSelected

			btn.Paint = function(self, w, h)
				self.selected = selectedPlaylist and selectedPlaylist == name
				local hovered = self:IsHovered()

				local default = Color(GetConVar("uvmenu_col_button_r"):GetInt(), GetConVar("uvmenu_col_button_g"):GetInt(), GetConVar("uvmenu_col_button_b"):GetInt(), GetConVar("uvmenu_col_button_a"):GetInt())
				local active = Color(GetConVar("uvmenu_col_bool_active_r"):GetInt(), GetConVar("uvmenu_col_bool_active_g"):GetInt(), GetConVar("uvmenu_col_bool_active_b"):GetInt(), GetConVar("uvmenu_col_button_a"):GetInt())
				local hover = Color(GetConVar("uvmenu_col_button_hover_r"):GetInt(), GetConVar("uvmenu_col_button_hover_g"):GetInt(), GetConVar("uvmenu_col_button_hover_b"):GetInt(), GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime() * 4)))

				local col = self.selected and active or default

				draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, col)
				if hovered then draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, hover) end
				DrawWrappedText(self, name, w * 0.9, w * 0.5, h * 0.0, true, "UVSettingsFontSmall")
			end

			btn.DoClick = onClick

			btn.OnCursorEntered = function()
				if descPanel then descPanel.Desc = name end
				if promptBar then promptBar.Prompts = { "uv.prompt.select" } end
			end
			btn.OnCursorExited = function()
				if descPanel then descPanel.Desc = "" end
				if promptBar then promptBar.Prompts = nil end
			end

			return brn
		end

		local playlistButtons = {}

		local function BuildLeftList()
			left:Clear()

			local collection = getPlaylistNames()

			for _, playlistName in ipairs( collection ) do
				local btn = addPlaylistBtn( playlistName, playlistName == selectedPlaylist, function()
					selectedPlaylist = playlistName
					LIST_BUILD_FUNCTIONS.M()
				end )

				if btn then table.insert( playlistButtons, btn ) end
			end
		end LIST_BUILD_FUNCTIONS.L = BuildLeftList

		local trackButtons = {}

		local function updateItemCount()
			local i = 0
			local e = 0

			for _, v in pairs(trackButtons) do
				i = i + 1
				if not v.disabled then e = e + 1 end
			end
			
			totalTracks = i
			enabledTracks = e
		end

		local currentSource = nil

		local function loadPreview( path )
			if currentSource then
				currentSource:Stop()
				currentSource = nil
				timer.Remove( "UVTraxPreview" )
			end

			sound.PlayFile( path, "noblock", function(source) 
				if IsValid(source) then
					currentSource = source
					currentSource:Play()
					currentSource:SetTime( currentSource:GetLength() / 2, true )

					timer.Create( "UVTraxPreview", currentSource:GetLength() / 2, 1, function()
						if IsValid(currentSource) then
							currentSource:Stop()
							currentSource = nil
						end
					end)
				end
			end )
		end

		local function addTrackBtn( track, playlist, trackType )
			local btn = vgui.Create( 'DButton', mid )
			
			btn:Dock(TOP)
			btn:DockMargin(0, 0, 0, 4)
			btn:SetTall(UV.ScaleH(28))
			btn:SetText("")

			btn.disabled = isTrackDisabled( playlist, trackType, track.path )

			local playing = false
			local btnText = (track.artist or "Unknown Artist") .. " – " .. (track.title or "Unknown Title")
			local kaomoji = ""
			local kaomojiPool = {
				"ヽ(・∀・)ﾉ",
				"(´｡• ω •｡`)",
				"(｡•̀ᴗ-)✧",
				"＼(＾▽＾)／",
				"(„• ֊ •„)／",
				"✧｡ ( ◡̀_◡́) ✧*｡",
				"(⌁° ‸ °⌁)",
				"♡⸜(˵˃ ‸ ˂˵)",
				"⸜(｡˃ ᵕ ˂ )⸝♡",
				"◝(ᵔᴗᵔ)◜",
				"≽(•⩊ •マ≼",
				"( ˶ˆᴗˆ˵ )",
				"٩(^ᴗ^ )و ´-",
				"₍₍⚞(˶˃ ▽ ˂˶)⚟⁾⁾",
				"(  •̀ ᴗ •́  )",
				"(˃ᴗ˂)",
				"( ˶o˶˶o˶) !!",
				"(๑ > ᴗ < ๑)"
			}
			
			local frames = {
				"♩ ♪ ♫ ♬ ", 
				"♪ ♫ ♬ ♩ ", 
				"♫ ♬ ♩ ♪ ",
				"♬ ♩ ♪ ♫ ",
			}

			btn.Paint = function(self, w, h)
				local hovered = self:IsHovered()

				local default = Color(GetConVar("uvmenu_col_button_r"):GetInt(), GetConVar("uvmenu_col_button_g"):GetInt(), GetConVar("uvmenu_col_button_b"):GetInt(), GetConVar("uvmenu_col_button_a"):GetInt())
				local active = Color(GetConVar("uvmenu_col_bool_active_r"):GetInt(), GetConVar("uvmenu_col_bool_active_g"):GetInt(), GetConVar("uvmenu_col_bool_active_b"):GetInt(), GetConVar("uvmenu_col_button_a"):GetInt())
				local hover = Color(GetConVar("uvmenu_col_button_hover_r"):GetInt(), GetConVar("uvmenu_col_button_hover_g"):GetInt(), GetConVar("uvmenu_col_button_hover_b"):GetInt(), GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime() * 4)))
				local playingColor = Color( 102, 0, 255 )
				local playingHover = Color( 102, 0, 255, 0 * math.abs( math.sin(RealTime() * 4) ) )

				local col = self.disabled and default or active

				draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, col)
				if hovered then draw.RoundedBox(12, w * 0.0125, 0, w * 0.9875, h, (playing and playingColor) or hover) end
				local animStr = ""
				if playing then
					local t = CurTime()
					local idx = math.floor( t * 6 ) % #frames + 1
					animStr = frames[idx]
				end
				DrawWrappedText(self, playing and (animStr .. " " .. btnText .. " " .. kaomoji) or btnText, w * 0.9, w * 0.5, h * 0.1, true, "UVSettingsFontSmall")
			end

			-- btn.DoClick = function()
			-- 	btn.disabled = not btn.disabled

			-- 	UVTraxSetTrackDisabled( playlist, trackType, track.path, btn.disabled )
			-- 	updateItemCount()
			-- end

			btn.OnMousePressed = function(self, code)
				if code == MOUSE_RIGHT then
					if currentSource then
						currentSource:Stop()
						currentSource = nil
						timer.Remove( "UVTraxPreview" )
						playing = false
						return
					end

					local luck = math.random(1, 4)
					if luck == 1 then kaomoji = kaomojiPool[math.random(1, #kaomojiPool)] else kaomoji = "" end
					playing = true
					loadPreview( track.path )
				elseif code == MOUSE_LEFT then
					btn.disabled = not btn.disabled

					UVTraxSetTrackDisabled( playlist, trackType, track.path, btn.disabled )
					updateItemCount()
				end
			end

			btn.OnCursorEntered = function()
				if currentSource then
					currentSource:Stop()
					currentSource = nil
					timer.Remove( "UVTraxPreview" )
				end

				if descPanel then
					-- descPanel.Desc = btnText .. "\n\n" .. UVString("uv.audio.uvtrax.tracks.toggle") .. "\n" .. UVString("uv.audio.uvtrax.tracks.preview")
					descPanel.Desc = btnText
				end
				if promptBar then promptBar.Prompts = { "uv.prompt.toggle", "uv.prompt.previewtrack" } end
			end
			btn.OnCursorExited = function()
				if currentSource then
					currentSource:Stop()
					currentSource = nil
					timer.Remove( "UVTraxPreview" )
				end

				playing = false

				if descPanel then descPanel.Desc = "" end
				if promptBar then promptBar.Prompts = nil end
			end

			return btn
		end

		local function BuildMidList()
			mid:Clear()

			if not selectedPlaylist then return false end
			if not activeTrackType then return false end

			local playlist = UVPlaylists[selectedPlaylist]
			if not playlist then return false end

			local tracks = playlist[activeTrackType] or {}

			trackButtons = {}
			for _, track in ipairs(tracks) do table.insert( trackButtons, addTrackBtn( track, selectedPlaylist, activeTrackType ) ) end
			updateItemCount()
		end LIST_BUILD_FUNCTIONS.M = BuildMidList

		timer.Simple(0, function()
			if not IsValid(left) then return end
			if not selectedPlaylist and UVPlaylists then
				local names = getPlaylistNames()
				selectedPlaylist = names[1]
			end
			BuildLeftList()
			BuildMidList()
			--BuildRightList()
		end)

		if st.text then
			panel.OnCursorEntered = function()
				if descPanel then
					descPanel.Desc = st.desc or ""
				end
			end
			panel.OnCursorExited = function()
				if descPanel then
					descPanel.Desc = ""
				end
			end
		end

		return panel
	end

	-- fallback: do nothing
	return nil
end

UV_WrapCache = UV_WrapCache or {}

function UV_WrapText(text, font, maxwidth)
	local cacheKey = font .. "|" .. tostring(maxwidth) .. "|" .. text

	-- return cached result if it exists
	local cached = UV_WrapCache[cacheKey]
	if cached then
		return cached
	end

	-- compute wrapped lines
	surface.SetFont(font)

	local lines = {}
	local curline = ""

	local words = string.Explode(" ", text)

	local function utf8_chars(str)
		return string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*")
	end

	for _, word in ipairs(words) do
		local test = (curline == "" and word) or (curline .. " " .. word)
		local w = surface.GetTextSize(test)

		if w > maxwidth then
			if surface.GetTextSize(word) > maxwidth then
				for char in utf8_chars(word) do
					local test2 = curline .. char
					if surface.GetTextSize(test2) > maxwidth then
						if curline ~= "" then
							table.insert(lines, curline)
						end
						curline = char
					else
						curline = test2
					end
				end
			else
				if curline ~= "" then
					table.insert(lines, curline)
				end
				curline = word
			end
		else
			curline = test
		end
	end

	if curline ~= "" then
		table.insert(lines, curline)
	end

	-- store result
	UV_WrapCache[cacheKey] = lines
	return lines
end

-- Plays Sound SFX for the menu
function UVMenu.PlaySFX(name, overrideSet)
    if not GetConVar("uvmenu_sound_enabled"):GetBool() then return end
    name = tostring(name or "")
    local setName = overrideSet or GetConVar("uvmenu_sound_set"):GetString() or "MW"
    local setTbl = UVMenu.Sounds[setName] or UVMenu.Sounds["MW"]
    if not setTbl then return end
    local snd = setTbl[name]
    if not snd or snd == "" then return end
	
    surface.PlaySound(snd)
end

function UVMenu.EstimateTabHeight(tab, availableWidth)
	local h = 0

	if tab.TabName and tab.TabName ~= "" then
		local text = UVString(tab.TabName)
		local base = math.max(UV.ScaleH(48), GetDynamicTall(text, availableWidth - 44, "UVFont5") )

		h = h + base
	end

	for _, st in ipairs(tab) do
		if istable(st) and st.type and UV.ShouldDrawSetting(st) then
			local base
			local text = UVString(st.text) or ""

			if st.type == "info" then
				local rawText = UVReplaceKeybinds(text, "Small")
				rawText = UVDiscordTextFormat(text)

				local available = availableWidth - 20
				if available < 1 then available = 1 end

				local mk = markup.Parse( "<font=UVSettingsFontSmall>" .. rawText .. "</font>", available )

				base = (mk and mk:GetHeight() or 0) + 20
			elseif st.type == "infosimple" then
				base = math.max(UV.ScaleH(32), GetDynamicTall(text, availableWidth * 0.95, "UVMostWantedLeaderboardFont", "UVMostWantedLeaderboardFont"))
			elseif st.type == "info_flags" then
				local rowHeight = 16
				local rowSpacing = 4
				local count = #(st.entries or {})

				base = count * (rowHeight + rowSpacing)
			elseif st.type == "image" then
				base = math.floor((availableWidth / 16) * 9)
			elseif st.type == "label" then
				base = math.max( UV.ScaleH(36), GetDynamicTall(UVString(text), availableWidth * 0.8) )
			elseif st.type == "slider" then
				base = math.max( UV.ScaleH(30), GetDynamicTall(UVString(text), availableWidth * 0.4) )
			elseif st.type == "combo" then
				base = math.max( UV.ScaleH(30), GetDynamicTall(UVString(text), availableWidth - UV.ScaleH(330) - 20) )
			elseif st.type == "button" or st.type == "buttonsw" then
				base = math.max( UV.ScaleH(30), GetDynamicTall(UVString(text), availableWidth * 0.95) )
			elseif st.type == "buttonlr" then
				base = UV.ScaleH(40)
			elseif st.type == "color" or st.type == "coloralpha" then
				base = math.max( UV.ScaleH(120), GetDynamicTall(UVString(text), availableWidth - UV.ScaleW(440)) )
			elseif st.type == "keybind" then
				base = math.max( UV.ScaleH(30), GetDynamicTall(UVString(text), availableWidth * 0.5) )
			elseif st.type == "timer" then
				base = UV.ScaleH(36)
			elseif st.type == "vehicleoverride" then
				base = UV.ScaleH(220)
			elseif st.type == "voiceprofile" then
				base = st.voicevar and UV.ScaleH(240) or UV.ScaleH(90)
			elseif st.type == "presets" then
				base = UV.ScaleH(600)
			elseif st.type == "unitselect" then
				base = UV.ScaleH(300)
			elseif st.type == "uvtrax" then
				base = UV.ScaleH(500)
			else
				base = UV.ScaleH(30)
			end

			h = h + base + UV.ScaleH(12)
		end
	end

	return h
end

-- Helper to open menus safely
function UVMenu.OpenMenu(menuFunc, dontsave)
    if not dontsave and menuFunc then
        UVMenu.LastMenu = menuFunc
    end

    if UVMenu.CurrentMenu and IsValid(UVMenu.CurrentMenu) then
        -- Close current menu first
        UVMenu.CloseCurrentMenu(true)
        -- Delay opening new menu to allow closing animation to start
        timer.Simple(tonumber(GetConVar("uvmenu_close_speed"):GetString()) or 0.2, function()
            if menuFunc then
                menuFunc()
                -- Update CurrentMenu to the newly created frame
                UVMenu.CurrentMenu = UV.SettingsFrame
				UVMenu.PlaySFX("menuopen")
            end
        end)
        return
    end

    -- Open menu immediately if nothing is open
    if menuFunc then
        menuFunc()
        UVMenu.CurrentMenu = UV.SettingsFrame
    end
end

-- Close the currently open menu with animation
function UVMenu.CloseCurrentMenu(noCloseSound)
    local frame = UVMenu.CurrentMenu or UV.SettingsFrame
    if not IsValid(frame) or frame._closing then return end

    -- Play close sound unless explicitly disabled OR convars disallow
    if not noCloseSound and GetConVar("uvmenu_sound_enabled"):GetBool() then UVMenu.PlaySFX("menuclose") end

    frame._closing = true
    frame._closeStart = CurTime()

    local closeSpeed = tonumber(GetConVar("uvmenu_close_speed"):GetString()) or 0.2
    frame._closeFadeDur = closeSpeed * 0.5
    frame._closeShrinkDur = closeSpeed
    frame._closeShrinkStart = frame._closeStart + frame._closeFadeDur * 0.5

    UVMenu.CurrentMenu = nil
end

-- Opens a UVMenu menu
function UVMenu:Open(menu)
    local CurrentMenu = menu or {}
    local Name = CurrentMenu.Name or UVString("uv.unitvehicles")
	
	local BaseMenuW = 1400
	local BaseMenuH = 900
	local Width = CurrentMenu.Width or math.min( UV.ScaleW(BaseMenuW), ScrW() * 0.92 )
	
	if CurrentMenu.DynamicHeight and CurrentMenu.Tabs and #CurrentMenu.Tabs == 1 then
		local SCROLL_SAFETY = math.max(UV.ScaleH(14), UV.ScaleH(1))
		
		local tab = CurrentMenu.Tabs[1]
		local contentH = UVMenu.EstimateTabHeight(tab, CurrentMenu.Width)

		local chromePadding = UV.ScaleH(140)

		local maxH = ScrH() * 0.92
		local desiredH = contentH + chromePadding

		if desiredH >= maxH then
			CurrentMenu.Height = maxH - SCROLL_SAFETY
		else
			CurrentMenu.Height = desiredH
		end
	end

	local Height = CurrentMenu.Height or math.min( UV.ScaleH(BaseMenuH), ScrH() * 0.92 )

    local ShowDesc = CurrentMenu.Description == true and not GetConVar("uvmenu_hide_description"):GetBool()
    local Tabs = CurrentMenu.Tabs or {}
    local UnfocusClose = CurrentMenu.UnfocusClose == true
	local HideCloseButton = CurrentMenu.HideCloseButton == true
	local HidePrompts = GetConVar("uvmenu_hide_prompts"):GetBool()
	
	if CurrentMenu.Description == true and GetConVar("uvmenu_hide_description"):GetBool() then
		Width = math.max(
			UV.ScaleW(1000),
			Width * 0.75
		)
	end

    if IsValid(UV.SettingsFrame) then UV.SettingsFrame:Remove() end
    gui.EnableScreenClicker(true)

    local sw, sh = ScrW(), ScrH()
    local fw, fh = Width, Height
    local fx, fy = (sw - fw) * 0.5, (sh - fh) * 0.5
    local watchedConvars = {}
	local watchedConds = {}

    local frame = vgui.Create("DFrame")
    UV.SettingsFrame = frame
    frame:SetSize(0, 0)
	frame:Center()
    frame:SetPos(fx + fw * 0.5, fy + fh * 0.5)
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame:MakePopup()
    frame:SetKeyboardInputEnabled(false)
	
	frame.Tabs = CurrentMenu.Tabs or {}

    frame.TargetWidth = fw
    frame.TargetHeight = fh

    local animStart = CurTime()
    local animDur = tonumber(GetConVar("uvmenu_open_speed"):GetString()) or 0.2
    local primaryFadeStart = animStart + animDur * 0.5
    local primaryFadeDur = animDur * 1.25
    local secondaryFadeStart = animStart + animDur * 0.5
    local secondaryFadeDur = animDur * 1.25

    frame._open_animStart = animStart
    frame._open_animDur = animDur
    frame._open_primaryFadeStart = primaryFadeStart
    frame._open_primaryFadeEnd = primaryFadeStart + primaryFadeDur
    frame._open_secondaryFadeStart = secondaryFadeStart
    frame._open_secondaryFadeEnd = secondaryFadeStart + secondaryFadeDur
    frame._closing = false

    frame.TitleAlpha = 0

    -- Right description panel
    local descPanel
    if ShowDesc then
        descPanel = vgui.Create("DPanel", frame)
        descPanel:Dock(RIGHT)
        descPanel:SetWide(math.Clamp(fw * 0.25, UV.ScaleW(220), UV.ScaleW(380)))
        descPanel.Paint = function(self, w, h)
            local a = self:GetAlpha()
            surface.SetDrawColor( GetConVar("uvmenu_col_desc_r"):GetInt(), GetConVar("uvmenu_col_desc_g"):GetInt(), GetConVar("uvmenu_col_desc_b"):GetInt(), math.floor(GetConVar("uvmenu_col_desc_a"):GetInt() * (a / 255)) )
            surface.DrawRect(0, 0, w, h)

			if self.SelectedConVar then
				draw.SimpleText(self.SelectedConVar, "UVMostWantedLeaderboardFont2", w * 0.5, h * 0.98 - 40, Color(175, 175, 175, a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			if self.SelectedDefault and self.SelectedDefault ~= "" then
				draw.SimpleText( string.format( UVString("uv.settings.default"), self.SelectedDefault ), "UVMostWantedLeaderboardFont2", 10, h * 0.98 - 20, Color(175, 175, 175, a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			if self.SelectedCurrent and self.SelectedCurrent ~= "" then
				draw.SimpleText(string.format( UVString("uv.settings.current"), self.SelectedCurrent ), "UVMostWantedLeaderboardFont2", 10, h * 0.98, Color(175, 175, 175, a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			
            if self.Text and a > 5 then
				local xPadding, yPadding = UV.ScaleW(10), UV.ScaleH(10)
				local wrapWidth = w - xPadding * 2

				local desc = UVReplaceKeybinds(UVString(self.Desc) or "")

				local markupText = "<font=UVMostWantedLeaderboardFont2>" .. "<color=255,255,255," .. a .. ">" .. desc .. "</color></font>"

				local mk = markup.Parse(markupText, wrapWidth)
				mk:Draw(xPadding, yPadding, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
        end

        descPanel.Text = ""
        descPanel.Desc = ""
        descPanel.SelectedConVar = ""
        descPanel.SelectedDefault = ""
        descPanel.SelectedCurrent = ""
        descPanel:SetAlpha(0)
    end

    -- Center scroll panel
    local center = vgui.Create("DScrollPanel", frame)
    center:Dock(FILL)
    center:DockMargin(8, 8, 8, 8)
    center:SetAlpha(0)

	local sbar = center:GetVBar()
	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	end
	function sbar.btnUp:Paint(w, h)
		draw.SimpleTextOutlined( "▲", "UVMostWantedLeaderboardFont2", w * 0.5, h * 0.5, Color( 255, 255, 255, self:IsHovered() and 255 * math.abs(math.sin(RealTime()*4)) or 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, color_black )
	end
	function sbar.btnDown:Paint(w, h)
		draw.SimpleTextOutlined( "▼", "UVMostWantedLeaderboardFont2", w * 0.5, h * 0.5, Color( 255, 255, 255, self:IsHovered() and 255 * math.abs(math.sin(RealTime()*4)) or 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, color_black )
	end
	function sbar.btnGrip:Paint(w, h)
		local hovered = self:IsHovered()
		local default = Color( GetConVar("uvmenu_col_button_r"):GetInt(), GetConVar("uvmenu_col_button_g"):GetInt(), GetConVar("uvmenu_col_button_b"):GetInt(), GetConVar("uvmenu_col_button_a"):GetInt() )
		local hover = Color( GetConVar("uvmenu_col_button_hover_r"):GetInt(), GetConVar("uvmenu_col_button_hover_g"):GetInt(), GetConVar("uvmenu_col_button_hover_b"):GetInt(), GetConVar("uvmenu_col_button_hover_a"):GetInt() )

		draw.RoundedBox(12, 0, 0, w, h, hovered and hover or default)
	end

    -- Left tabs panel (only if >1 tab)
    local tabsPanel
    if #Tabs > 1 then
        tabsPanel = vgui.Create("DScrollPanel", frame)
        tabsPanel:Dock(LEFT)
        tabsPanel:SetWide(UV.ScaleW(300))
		tabsPanel:Dock(LEFT)
        tabsPanel.Paint = function(self, w, h)
			surface.SetDrawColor(
				GetConVar("uvmenu_col_tabs_r"):GetInt(),
				GetConVar("uvmenu_col_tabs_g"):GetInt(),
				GetConVar("uvmenu_col_tabs_b"):GetInt(),
				GetConVar("uvmenu_col_tabs_a"):GetInt()
			)
			surface.DrawRect(0, 0, w, h)
		end

        tabsPanel:SetAlpha(0)
    end
	
	-- Bottom input prompt bar
	local promptBar
	if not HidePrompts then
		promptBar = vgui.Create("DPanel", frame)
		promptBar:Dock(BOTTOM)
		promptBar:SetTall(UV.ScaleH(32.5))
		promptBar:DockMargin(8, 0, 8, 8)
		promptBar:SetAlpha(0)

		promptBar.Prompts = nil

		promptBar.Paint = function(self, w, h)
			local a = self:GetAlpha()
			if a <= 5 then return end
			if not self.Prompts or #self.Prompts == 0 then return end

			local xPadding, yPadding = UV.ScaleW(10), UV.ScaleH(5)
			local wrapWidth = w - xPadding * 2

			local resolved = {}
			
			-- if GetConVar("unitvehicle_controllermode"):GetBool() then
				-- table.insert(resolved, UVString("uv.prompt.navigate"))
			-- end
			
			for _, prompt in ipairs(self.Prompts) do
				local phrase = UVString(prompt)
				table.insert(resolved, phrase)
			end

			local text = table.concat(resolved, "      ")

			if GetConVar("unitvehicle_controllermode"):GetBool() then
				text = string.Replace(text, "+attack2", "+reload")
				text = string.Replace(text, "+attack", "+jump")
			end

			text = UVReplaceKeybinds(text)

			local markupText =
				"<font=UVSettingsFont>" ..
				"<color=255,255,255," .. a .. ">" ..
				text ..
				"</color></font>"

			local mk = markup.Parse(markupText, wrapWidth)
			
			surface.SetFont("UVSettingsFont")
            surface.SetDrawColor( 
				GetConVar("uvmenu_col_desc_r"):GetInt(),
				GetConVar("uvmenu_col_desc_g"):GetInt(),
				GetConVar("uvmenu_col_desc_b"):GetInt(),
				math.floor(GetConVar("uvmenu_col_desc_a"):GetInt() * (a / 255))
			)
			surface.DrawRect(0, 0, mk:GetWidth() + (xPadding * 2), h)
			
			mk:Draw(xPadding, yPadding, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end

    local closeBtn = vgui.Create("DButton", frame)
    closeBtn:SetSize(20, 20)
    closeBtn:SetText("")
    closeBtn:SetFont("DermaDefaultBold")
	if HideCloseButton then
		closeBtn:SetVisible(false)
		closeBtn:SetMouseInputEnabled(false)
		closeBtn:SetKeyboardInputEnabled(false)
	end

    closeBtn.DoClick = function()
        UVMenu.CloseCurrentMenu()
    end
    closeBtn.Paint = function(self, w, h)
        local hovered = self:IsHovered()
        local bg = hovered and Color(200, 60, 60, self:GetAlpha()) or Color(140, 50, 50, self:GetAlpha())
        draw.RoundedBox(4, 0, 0, w, h, bg)
        draw.SimpleText("X", "DermaDefaultBold", w / 2, h / 2, Color(255, 255, 255, self:GetAlpha()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    closeBtn:SetAlpha(0)

	local primaryGroup = {}

	if not HideCloseButton then
		table.insert(primaryGroup, closeBtn)
	end

    local secondaryGroup = {center}
    if tabsPanel then table.insert(secondaryGroup, tabsPanel) end
    if descPanel then table.insert(secondaryGroup, descPanel) end
	if promptBar then table.insert(secondaryGroup, promptBar) end

    local CURRENT_TAB = 1

    -- Build tab content
    local function BuildTab(tabIndex)
        center.CurrentTabIndex = tabIndex
        center:Clear()
        if descPanel then
            descPanel.Text = ""
            descPanel.Desc = ""
        end

		local tab = Tabs[tabIndex]
		if not tab then return end

		if not tab.NoTitle then
			local title = vgui.Create("DLabel", center)
			title:SetText("")
			title:Dock(TOP)
			title:DockMargin(6, 6, 6, 12)

			function title:PerformLayout()
				local text = UVString(tab.TabName)
				local w = self:GetWide()
				if w <= 0 then return end
				local newTall = math.max(UV.ScaleH(48), GetDynamicTall(text, w - 44, "UVFont5"))
				if self:GetTall() ~= newTall then
					self:SetTall(newTall)
				end
			end

			title.Paint = function(self, w, h)
				DrawWrappedText(
					self,
					UVString(tab.TabName) or ("Tab " .. tostring(tabIndex)),
					w - 44,
					w * 0.5,
					nil,
					true,
					"UVFont5"
				)

				if tab.Icon and tab.ShowIcon then
					local mat = Material(tab.Icon, "smooth")
					local iconSize = tab.IconSize or UV.ScaleW(40)
					local iconY = (h - iconSize) / 2

					surface.SetDrawColor(255, 255, 255, self:GetAlpha())
					surface.SetMaterial(mat)
					surface.DrawTexturedRect(0, iconY, iconSize, iconSize)
					surface.DrawTexturedRect(w - iconSize, iconY, iconSize, iconSize)
				end
			end
		end

        watchedConvars = {} -- reset
        for k2, entry in ipairs(tab) do
            if istable(entry) and entry.type then
				if entry.parentconvar then watchedConvars[entry.parentconvar] = true end
				if entry.requireparentconvar then watchedConvars[entry.requireparentconvar] = true end
				if entry.requireparentconvarfloat then watchedConvars[entry.requireparentconvarfloat] = true end
				if entry.requireparentconvarvariable then watchedConvars[entry.requireparentconvarvariable] = true end
				if entry.cond then
					table.insert(watchedConds, entry)
				end
            end
        end

        for k2, entry in ipairs(tab) do
            if istable(entry) and entry.type then
                local pnl = UV.BuildSetting(center, entry, descPanel, promptBar)
                if IsValid(pnl) then
                    pnl:SetVisible(UV.ShouldDrawSetting(entry))
                    pnl:SetAlpha(0)
                end
            end
        end
    end

    local lastValues = {}

    local function SetGroupAlpha(group, a)
        for _, pnl in ipairs(group) do
            if IsValid(pnl) and pnl.SetAlpha then pnl:SetAlpha(a) end
        end
    end

    local function SetCenterChildrenAlpha(a)
        for _, child in ipairs(center:GetChildren()) do
            if IsValid(child) and child.SetAlpha then
                child:SetAlpha(a)
            end
        end
    end

    local function SetAlphaRecursive(panel, a)
        if not IsValid(panel) then return end
        if panel.SetAlpha then panel:SetAlpha(a) end
        for _, child in ipairs(panel:GetChildren()) do
            SetAlphaRecursive(child, a)
        end
    end

    frame.Think = function(self)
        if not self._closing then
            local elapsed = CurTime() - self._open_animStart
            local p = math.Clamp(elapsed / self._open_animDur, 0, 1)

            local w = Lerp(p, 0, self.TargetWidth)
            local h = Lerp(p, 0, self.TargetHeight)
            local x = fx + (fw * 0.5) - (w * 0.5)
            local y = fy + (fh * 0.5) - (h * 0.5)
            self:SetSize(w, h)
            self:SetPos(x, y)

            if not HideCloseButton and IsValid(closeBtn) then
				closeBtn:SetPos(math.max(self:GetWide() - 24, 8), 4)
			end

            local primaryA = 0
            if CurTime() >= self._open_primaryFadeStart then
                primaryA = math.Clamp((CurTime() - self._open_primaryFadeStart) / (self._open_primaryFadeEnd - self._open_primaryFadeStart), 0, 1) * 255
            end
            self.TitleAlpha = primaryA
            SetGroupAlpha(primaryGroup, primaryA)

            local secondaryA = 0
            if CurTime() >= self._open_secondaryFadeStart then
                secondaryA = math.Clamp((CurTime() - self._open_secondaryFadeStart) / (self._open_secondaryFadeEnd - self._open_secondaryFadeStart), 0, 1) * 255
            end
            SetGroupAlpha(secondaryGroup, secondaryA)
            SetAlphaRecursive(center, secondaryA)

            -- unfocus auto-close
			if UnfocusClose and input.IsMouseDown(MOUSE_LEFT) then
				local mx, my = gui.MousePos()
				if mx and my then
					local fx2, fy2 = self:GetPos()
					local fw2, fh2 = self:GetSize()

					local clickedInsideDropdown = false
					for _, pnl in ipairs(UVMenu.OpenDropdowns or {}) do
						if IsValid(pnl) then
							local px, py = pnl:LocalToScreen(0, 0)
							local pw, ph = pnl:GetSize()
							if mx >= px and mx <= px + pw and my >= py and my <= py + ph then
								clickedInsideDropdown = true
								break
							end
						end
					end

					if not clickedInsideDropdown and (mx < fx2 or mx > fx2 + fw2 or my < fy2 or my > fy2 + fh2) then
						timer.Simple(0, function()
							if IsValid(self) then UVMenu.CloseCurrentMenu() end
						end)
					end
				end
			end

            local shouldRefresh = false
			for cvName in pairs(watchedConvars) do
				local cv = GetConVar(cvName)
				if cv then
					local val

					-- Determine type by which setting is using it
					local isVariable = false
					for _, tab in ipairs(Tabs) do
						for _, entry in ipairs(tab) do
							if entry.requireparentconvarvariable == cvName then
								isVariable = true
								break
							end
						end
					end

					if isVariable then
						val = cv:GetString()
					else
						val = cv:GetString() -- fallback: still track as string for safety
					end

					if lastValues[cvName] ~= val then
						lastValues[cvName] = val
						shouldRefresh = true
					end
				end
			end

			for _, entry in ipairs(watchedConds) do
				local ok = entry.cond and entry.cond()

				if lastValues[entry] ~= ok then
					lastValues[entry] = ok
					shouldRefresh = true
				end
			end

            if shouldRefresh then
                BuildTab(center.CurrentTabIndex)
            end
        else
            local now = CurTime()
            local fadeStart = self._closeStart
            local fadeEnd = fadeStart + self._closeFadeDur
            local shrinkStart = self._closeShrinkStart
            local shrinkEnd = shrinkStart + self._closeShrinkDur

            local fadeT = 0
            if now <= fadeStart then
                fadeT = 0
            elseif now >= fadeEnd then
                fadeT = 1
            else
                fadeT = (now - fadeStart) / (fadeEnd - fadeStart)
            end
            local invFade = 1 - fadeT
            local fadeA = math.floor(invFade * 255)

            self.TitleAlpha = fadeA
            SetGroupAlpha(primaryGroup, fadeA)
            SetGroupAlpha(secondaryGroup, fadeA)
            SetCenterChildrenAlpha(fadeA)

            local shrinkT = 0
            if now <= shrinkStart then
                shrinkT = 0
            elseif now >= shrinkEnd then
                shrinkT = 1
            else
                shrinkT = (now - shrinkStart) / (shrinkEnd - shrinkStart)
            end
            local w = Lerp(shrinkT, self.TargetWidth, 0)
            local h = Lerp(shrinkT, self.TargetHeight, 0)
            local x = fx + (fw * 0.5) - (w * 0.5)
            local y = fy + (fh * 0.5) - (h * 0.5)
            self:SetSize(w, h)
            self:SetPos(x, y)

            if now >= math.max(fadeEnd, shrinkEnd) then
                if IsValid(self) then
                    self:Remove()
                end
                gui.EnableScreenClicker(false)
                UV.SettingsFrame = nil
            end
        end
    end

    frame.Paint = function(self, w, h)
		local bg = Color( GetConVar("uvmenu_col_bg_r"):GetInt(), GetConVar("uvmenu_col_bg_g"):GetInt(), GetConVar("uvmenu_col_bg_b"):GetInt(), GetConVar("uvmenu_col_bg_a"):GetInt() )
		draw.RoundedBox(0, 0, 0, w, h, bg)

        local titleColor = Color(255, 255, 255, math.Clamp(math.floor(self.TitleAlpha), 0, 255))
		draw.SimpleTextOutlined(Name, "UVMostWantedLeaderboardFont", w * 0.01, 0, titleColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, color_black)
    end

    -- Build tabs if more than 1
    local TAB_START_OFFSET = 15
    local TAB_BUTTON_HEIGHT = UV.ScaleH(64)
    local TAB_BUTTON_PADDING = 0
    local TAB_SIDE_PADDING = 6
    local TAB_CORNER_RADIUS = 4

    if tabsPanel then
        tabsPanel:DockPadding(0, TAB_START_OFFSET, 0, 0)
		local uv_tab_hover_last = uv_tab_hover_last or 0
        for i, tab in ipairs(Tabs) do
            if not UV.PlayerCanSeeSetting(tab) then continue end

            local btn = vgui.Create("DButton", tabsPanel)
            btn:Dock(TOP)
            btn:DockMargin(0, 0, 0, TAB_BUTTON_PADDING)
            btn:SetTall(tab.Icon and UV.ScaleH(64) or UV.ScaleH(48))
            btn:SetText("")

            btn.Paint = function(self, w, h)
				local a = self:GetAlpha()
				local isSelected = (CURRENT_TAB == i)
				local hovered = self:IsHovered()

				local pulse = math.abs(math.sin(RealTime() * 4))

				local baseAlpha  = 75
				local hoverAlpha = 175 * pulse

				local default = Color(
					GetConVar("uvmenu_col_tab_default_r"):GetInt(),
					GetConVar("uvmenu_col_tab_default_g"):GetInt(),
					GetConVar("uvmenu_col_tab_default_b"):GetInt(),
					baseAlpha
				)

				local active = Color(
					GetConVar("uvmenu_col_tab_active_r"):GetInt(),
					GetConVar("uvmenu_col_tab_active_g"):GetInt(),
					GetConVar("uvmenu_col_tab_active_b"):GetInt(),
					baseAlpha
				)

				local hoverCol = Color(
					GetConVar("uvmenu_col_tab_hover_r"):GetInt(),
					GetConVar("uvmenu_col_tab_hover_g"):GetInt(),
					GetConVar("uvmenu_col_tab_hover_b"):GetInt(),
					hoverAlpha
				)
				local bg = isSelected and active or default

				draw.RoundedBox( TAB_CORNER_RADIUS, TAB_SIDE_PADDING, 4, w - TAB_SIDE_PADDING * 2, h - 8, bg )

				if hovered then
					draw.RoundedBox( TAB_CORNER_RADIUS, TAB_SIDE_PADDING, 4, w - TAB_SIDE_PADDING * 2, h - 8, hoverCol )
				end

                if tab.Icon then
                    local mat = Material(tab.Icon, "smooth")
                    local iconSize = UV.ScaleW(40)
                    local iconX = TAB_SIDE_PADDING + 2
                    local iconY = (h - iconSize) / 2
                    surface.SetDrawColor(255, 255, 255, self:GetAlpha())
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
                end
				
				if a > 5 then
					DrawWrappedText(self, UVString(tab.TabName or "Tab"), self:GetWide() - ((tab.Icon and self:GetWide() * 0.15 or self:GetWide() * 0.085)) * 2, tab.Icon and UV.ScaleW(60) or UV.ScaleW(20), nil, false, "UVMostWantedLeaderboardFont", "UVMostWantedLeaderboardFont2")
				end
            end

			btn.OnCursorEntered = function()
				if tab.Desc and descPanel then descPanel.Desc = tab.Desc or "" end
				if promptBar then promptBar.Prompts = tab.Prompts or { "uv.prompt.tab" } end
			end
			
			btn.OnCursorExited = function()
				if descPanel then descPanel.Desc = "" end
				if promptBar then promptBar.Prompts = nil end
			end
		
            btn.DoClick = function()
				if tab.playsfx then UVMenu.PlaySFX(tab.playsfx) end
				if tab.func then tab.func(self) return end
                CURRENT_TAB = i
                BuildTab(i)
                tabsPanel:InvalidateLayout(true)
            end

            if i == 1 then BuildTab(1) end
        end
    else
        -- Only 1 tab → just build that tab directly
        BuildTab(1)
    end

    frame.OnRemove = function()
        gui.EnableScreenClicker(false)
        if UV.SettingsFrame == frame then UV.SettingsFrame = nil end
    end
end

hook.Add("PlayerBindPress", "UVMenu_ControllerMode", function(ply, bind, pressed) -- Controller mode uwu?
    if not pressed then return end
    if not IsValid(UVMenu.CurrentMenu) then return end

    local cvar = GetConVar("unitvehicle_controllermode")
    if not cvar or not cvar:GetBool() then return end

    local hovered = vgui.GetHoveredPanel()
    if not IsValid(hovered) then return end

    if bind == "+jump" then
        if hovered.DoClick then
            hovered:DoClick()
        elseif hovered.OnMousePressed then
            hovered:OnMousePressed(MOUSE_LEFT)
            if hovered.OnMouseReleased then
                hovered:OnMouseReleased(MOUSE_LEFT)
            end
        end

        return true
    end

	if bind == "+reload" then
		local hovered = vgui.GetHoveredPanel()
		if IsValid(hovered) then
			hovered:MouseCapture(true)
			hovered:OnMousePressed(MOUSE_RIGHT)
			hovered:OnMouseReleased(MOUSE_RIGHT)
			hovered:MouseCapture(false)
		end

		return true
	end
end)