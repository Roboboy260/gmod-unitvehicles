UV.RegisterHUD( "original", "Original", true )

-- [[ Convars ]] --
-- Racing
-- CreateClientConVar("uvhud_original_race_raceramount", 4, true, false)
-- local maxracernrcv = GetConVar("uvhud_original_race_raceramount"):GetString()

-- UVMenu.CustomizeHUD = UVMenu.CustomizeHUD or {}
-- UVMenu.CustomizeHUD.original = function()
	-- UVMenu.CurrentMenu = UVMenu:Open({
		-- Name = " ",
		-- Width  = UV.ScaleW(1200),
		-- Height = UV.ScaleH(760),
		-- DynamicHeight = true,
		-- Description = true,
		-- UnfocusClose = true,
		-- Tabs = {
			-- { TabName = "uv.ui.custhud",
				-- { type = "label", text = "uv.ui.original" },
				-- { type = "button", text = "uv.back", playsfx = "clickback", prompts = {"uv.prompt.return"},
						-- func = function(self2) UVMenu.OpenMenu(UVMenu.Settings) end
				-- },
				-- { type = "infosimple", text = "uv.ui.custhud.race" },
				-- { type = "slider", text = "uv.ui.custhud.raceramount", desc = "uv.ui.custhud.raceramount.desc", convar = "uvhud_original_race_raceramount", min = 4, max = 18, decimals = 0 },
			-- },
		-- }
	-- })
-- end

UV_UI.racing.original = UV_UI.racing.original or {}
UV_UI.pursuit.original = UV_UI.pursuit.original or {}

UV_UI.pursuit.original.states = {
    TagsColor = Color(255,255,255,255),
    WrecksColor = Color(255,255,255,255),
    UnitsColor = Color(255,255,255,255),
    BustedColor = Color(255, 255, 255, 50),
    EvasionColor = Color(255, 255, 255, 50),
    
    TakedownText = nil,
}

UV_UI.racing.original.states = {
    FrozenTime = false,
    FrozenTimeValue = 0
}

UV_UI.racing.original.noready = true

UV_UI.racing.original.events = {
    onLapComplete = function( participant, new_lap, old_lap, lap_time, lap_time_cur, is_local_player, is_global_best, lap_final, local_finished, user_finished, suppress_lap_ui )
		local name = UVHUDRaceInfo.Participants[participant] and UVHUDRaceInfo.Participants[participant].Name or "Unknown"
        local laptimeprefixcolor = Color(255, 255, 255)
        local laptimeprefix = string.format(UVString("uv.race.laptime.original"), old_lap, name)
        local laptimecolor = Color(255, 255, 0)
        local laptime = UVDisplayTimeRace( lap_time )

		if is_global_best then
			laptimeprefix = string.format(UVString("uv.race.fastest.laptime.original"), old_lap, name)
            laptimecolor = Color(0, 255, 255)
		end

        chat.AddText(laptimeprefixcolor, laptimeprefix, laptimecolor, " " .. laptime)

        if participant:GetDriver() ~= LocalPlayer() then return end
        
        UV_UI.racing.original.states.FrozenTime = true
        UV_UI.racing.original.states.FrozenTimeValue = lap_time
        
        if timer.Exists( "_OG_TIME_FROZEN_DELAY" ) then timer.Remove( "_OG_TIME_FROZEN_DELAY" ) end
        timer.Create("_OG_TIME_FROZEN_DELAY", 3, 1, function()
            UV_UI.racing.original.states.FrozenTime = false
        end)

    end,

    onRaceStartTimer = function(data)
		local starttime = data.starttime
        local noready = data.noReadyText

        --The font used does not support special characters and is therefore not localized.
		local countdownTexts = {
			[4] = 3,
			[3] = 2,
			[2] = 1,
			[1] = "GO!"
		}

        local textToShow = countdownTexts[starttime]
        
        local now = CurTime()
        local hookID = "UV_RaceCountdown_Original_" .. tostring(now)

        hook.Add("HUDPaint", hookID, function()
            if starttime > 4 and GetConVar("unitvehicle_preraceinfo"):GetInt() == 0 then
			    draw.DrawText( "GET READY", "UVFont7", ScrW()/2, ScrH()/3, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		    elseif textToShow then
		    	draw.DrawText( textToShow, "UVFont7", ScrW()/2, ScrH()/3, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		    end
        end)

        timer.Simple(1, function()
            hook.Remove("HUDPaint", hookID)
        end)
	end,

    onWrongWay = function(timestamp, isWrongWay)
        local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
		local soundfiles = file.Find("sound/uvracesfx/" .. theme .. "/wrongway/*", "GAME")
		if soundfiles and #soundfiles > 0 then
			table.Shuffle(soundfiles)
			local audio_path = "uvracesfx/" .. theme .. "/wrongway/" .. soundfiles[1]
			surface.PlaySound(audio_path)
		end

        local now = CurTime()
        local hookID = "UV_RaceCountdown_Original_" .. tostring(now)

        hook.Add("HUDPaint", hookID, function()
            draw.DrawText( "WRONG WAY", "UVFont7", ScrW()/2, ScrH()/3, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end)

        timer.Simple(1.5, function()
            hook.Remove("HUDPaint", hookID)
        end)
	end,

    onParticipantDisqualified = function(data)
		local participant = data.Participant
		local is_local_player = data.is_local_player
		
		local info = UVHUDRaceInfo.Participants[participant]
		local name = info and info.Name or "Unknown"

		if not info then return end

		local disqtext = string.format(UVString("uv.race.wrecked.original"))
		if is_local_player then 
            disqtext = string.format(UVString("uv.chase.wrecked"))
            chat.AddText(Color(255, 0, 0), disqtext)
        else
            chat.AddText(Color(255, 0, 0), name, Color(255, 255, 255), " " .. disqtext)
        end

	end,

    onRaceEnd = function( sortedRacers, stringArray )
        if not istable(sortedRacers) or #sortedRacers == 0 then
            chat.AddText(Color(255, 255, 255), string.format(UVString("uv.race.finished.statserror")))
            return
        end

        PrintTable(sortedRacers)
        chat.AddText(Color(255, 255, 255), string.format(UVString("uv.race.finished.viewstats.original")))
        
    end
}

UV_UI.pursuit.original.events = {
    -- _onUpdate = function( data_name, ...)
    --     if data_name == 'Wrecks' then
    --         UV_UI.pursuit.mostwanted.callbacks.onUnitWreck( ... )
    --     elseif data_name == 'Tags' then
    --         UV_UI.pursuit.mostwanted.callbacks.onUnitTag( ... )
    --     elseif data_name == 'ChasingUnits' then
    --         UV_UI.pursuit.mostwanted.callbacks.onChasingUnitsChange( ... )
    --     end
    -- end,
    onUnitTakedown = function( unitType, name, bounty, bountyCombo, isPlayer )
		local uname = isPlayer and UVString( unitType ) or name -- Fallback
		
		if GetConVar("unitvehicle_vehiclenametakedown"):GetBool() then
			uname = name and string.Trim(UVString(name), "#") or nil
		end
		
		local text = string.format( UVString( "uv.hud.original.takedown" ), uname, bounty, bountyCombo )
        LocalPlayer():PrintMessage(HUD_PRINTCENTER, text)
	end,
    onUnitWreck = function(...)
        
        hook.Remove("Think", "MW_WRECKS_COLOR_PULSE")
        
        if timer.Exists("MW_WRECKS_COLOR_PULSE_DELAY") then timer.Remove("MW_WRECKS_COLOR_PULSE_DELAY") end
        UV_UI.pursuit.mostwanted.states.WrecksColor = Color(255,255,0, 150)
        
        timer.Create("MW_WRECKS_COLOR_PULSE_DELAY", 1, 1, function()
            hook.Add("Think", "MW_WRECKS_COLOR_PULSE", function()
                UV_UI.pursuit.mostwanted.states.WrecksColor.b = UV_UI.pursuit.mostwanted.states.WrecksColor.b + 600 * RealFrameTime()
                if UV_UI.pursuit.mostwanted.states.WrecksColor.b >= 255 then hook.Remove("Think", "MW_WRECKS_COLOR_PULSE") end
            end)
        end)
        
    end,
    onUnitTag = function(...)
        
        hook.Remove("Think", "MW_TAGS_COLOR_PULSE")
        if timer.Exists("MW_TAGS_COLOR_PULSE_DELAY") then timer.Remove("MW_TAGS_COLOR_PULSE_DELAY") end
        
        UV_UI.pursuit.mostwanted.states.TagsColor = Color(255,255,0, 150)
        
        timer.Create("MW_TAGS_COLOR_PULSE_DELAY", 1, 1, function()
            
            hook.Add("Think", "MW_TAGS_COLOR_PULSE", function()
                UV_UI.pursuit.mostwanted.states.TagsColor.b = UV_UI.pursuit.mostwanted.states.TagsColor.b + 600 * RealFrameTime()
                if UV_UI.pursuit.mostwanted.states.TagsColor.b >= 255 then hook.Remove("Think", "MW_TAGS_COLOR_PULSE") end
            end)
            
        end)
        
    end,
    onResourceChange = function(...)
        
        local new_data = select( 1, ... )
        local old_data = select( 2, ... )
        
        hook.Remove("Think", "MW_RP_COLOR_PULSE")
        UV_UI.pursuit.mostwanted.states.UnitsColor = (new_data < (old_data or 0) and Color(255,50,50, 150)) or Color(50,255,50, 150)
        --UVResourcePointsColor = (rp_num < UVResourcePoints and Color(255,50,50)) or Color(50,255,50)
        
        local clrs = {}
        
        for _, v in pairs( { 'r', 'g', 'b' } ) do
            if UV_UI.pursuit.mostwanted.states.UnitsColor[v] ~= 255 then table.insert(clrs, v) end
        end 
        
        -- if timer.Exists("UVWrecksColor") then
        -- 	timer.Remove("UVWrecksColor")
        -- end
        local val = 50
        
        hook.Add("Think", "MW_RP_COLOR_PULSE", function()
            val = val + 200 * RealFrameTime()
            -- UVResourcePointsColor.b = val
            -- UVResourcePointsColor.g = val
            for _, v in pairs( clrs ) do
                UV_UI.pursuit.mostwanted.states.UnitsColor[v] = val
            end
            
            if val >= 255 then hook.Remove("Think", "MW_RP_COLOR_PULSE") end
        end)
        
    end,
    onChasingUnitsChange = function(...)
        
    end,
    onHeatLevelUpdate = function(...)
        
    end,
    onRacerBusted = function( racer, cop, lp )
		local cnt = string.format(UVString("uv.hud.racer.arrested.original"), racer, UVString(cop))

		chat.AddText(Color(255, 0, 0), cnt)
	end,
    onCopBustedDebrief = function(...)
        local w = UV_GetW()
        local h = UV_GetH()
        
        local bustedtable = select( 1, ... )

        local tipstring = UV.Tips.Units
	    local randomTipText = tipstring[math.random(1, #tipstring)]
        
        --------------------------------------
        
        local time = UVDisplayTime(UVTimerProgress)
        local deploys = bustedtable["Deploys"]
        local roadblocksdodged = bustedtable["Roadblocks"]
        local spikestripsdodged = bustedtable["Spikestrips"]
        local bounty = bustedtable["Bounty"] or 0
        local tags = bustedtable["Tags"] or 0
        local wrecks = bustedtable["Wrecks"] or 0
        local suspects = UVHUDWantedSuspectsNumber or 0
        
        -- Tip
        local TipsPanel = vgui.Create("DFrame")
        
        TipsPanel:SetSize(math.Round(w), math.Round(h))
        TipsPanel:SetBackgroundBlur(true)
        TipsPanel:ShowCloseButton(false)
        TipsPanel:Center()
        TipsPanel:SetTitle("")
        TipsPanel:SetDraggable(false)
        TipsPanel:MakePopup()
        TipsPanel:SetKeyboardInputEnabled(false)
        TipsPanel:SetMouseInputEnabled( false )
        
        TipsPanel.Paint = function(self, w, h)
            draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,225))

		    local tiptext = "<color=255,255,255><font=UVFont2-Smaller>" .. UVReplaceKeybinds( string.format(UVString("uv.tip"), UVString(randomTipText) ), "Big") .. "</font></color>"
		    markup.Parse(tiptext, w):Draw(w*0.5, h, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        end
        
        local ResultPanel = vgui.Create("DFrame")
        local OK = vgui.Create("DButton")
        
        ResultPanel:Add(OK)
        ResultPanel:SetSize(math.Round(w*0.52), math.Round(h*0.56))
        ResultPanel:SetBackgroundBlur(true)
        ResultPanel:ShowCloseButton(false)
        ResultPanel:Center()
        ResultPanel:SetTitle("")
        ResultPanel:SetDraggable(false)
        ResultPanel:MakePopup()
        ResultPanel:SetKeyboardInputEnabled(false)
        
        OK:SetText(UVString("addons.confirm"))
        OK:SetSize(ResultPanel:GetWide() * 5 / 16, 22)
        OK:Dock(BOTTOM)
        
        local timetotal = 30
        local timestart = CurTime()
        
        ResultPanel.Paint = function(self, w, h)
            local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
            local lang = UVString
            
            draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,225))
            draw.SimpleText("/// " .. lang("uv.chase.busted") .. " ///", "UVFont", w*0.5, h*0.01, Color(0, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText(string.format( lang("uv.results.suspects.busted"), unit ), "UVFont2", w*0.5, h*0.075, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.bounty"), "UVFont2", w*0.01, h*0.15, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.time"), "UVFont2", w*0.01, h*0.25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.units.deployed"), "UVFont2", w*0.01, h*0.35, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.units.damaged"), "UVFont2", w*0.01, h*0.45, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.units.destroyed"), "UVFont2", w*0.01, h*0.55, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.dodged.blocks"), "UVFont2", w*0.01, h*0.65, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.dodged.spikes"), "UVFont2", w*0.01, h*0.75, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            
            draw.SimpleText( bounty, "UVFont2", w*0.99, h*0.15, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( time, "UVFont2", w*0.99, h*0.25, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( deploys, "UVFont2", w*0.99, h*0.35, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( tags, "UVFont2", w*0.99, h*0.45, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( wrecks, "UVFont2", w*0.99, h*0.55, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( roadblocksdodged, "UVFont2", w*0.99, h*0.65, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( spikestripsdodged, "UVFont2", w*0.99, h*0.75, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            
            -- Time remaining and closing
            local contenttext = UVReplaceKeybinds("[+jump] " .. UVString("uv.results.continue") .. " (" .. math.max(0, timeremaining) .. ")", "Big")
            --draw.DrawText( "[ " .. UVBindButton("+jump") .. " ] " .. UVString("uv.results.continue"), "UVFont2", w*0.01, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
            local markuptext = "<color=255,255,255><font=UVFont2>".. contenttext .. "</font></color>"
            markup.Parse(markuptext):Draw(w*0.01, h*0.85, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            
            if timeremaining < 1 then
                hook.Remove("CreateMove", "JumpKeyCloseDebrief")
                self:Close()
                TipsPanel:Close()
            end
            
        end
        
        function OK:DoClick() 
            hook.Remove("CreateMove", "JumpKeyCloseDebrief")
            ResultPanel:Close()
            TipsPanel:Close()
        end

		hook.Add("CreateMove", "JumpKeyCloseDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end

			if ply:KeyPressed(IN_JUMP) then
				if IsValid(ResultPanel) then
					hook.Remove("CreateMove", "JumpKeyCloseDebrief")
					ResultPanel:Close()
                    TipsPanel:Close()
				end
			end
		end)
    end,
    onCopEscapedDebrief = function(...)
        
        local w = UV_GetW()
        local h = UV_GetH()
        
        local escapedtable = select( 1, ... )

        local tipstring = UV.Tips.Units
	    local randomTipText = tipstring[math.random(1, #tipstring)]
        
        --------------------------------------
        
        local time = UVDisplayTime(UVTimerProgress)
        local deploys = escapedtable["Deploys"]
        local roadblocksdodged = escapedtable["Roadblocks"]
        local spikestripsdodged = escapedtable["Spikestrips"]
        local bounty = escapedtable["Bounty"] or 0
        local tags = escapedtable["Tags"] or 0
        local wrecks = escapedtable["Wrecks"] or 0
        local suspects = UVHUDWantedSuspectsNumber or 0

        -- Tip
        local TipsPanel = vgui.Create("DFrame")
        
        TipsPanel:SetSize(math.Round(w), math.Round(h))
        TipsPanel:SetBackgroundBlur(true)
        TipsPanel:ShowCloseButton(false)
        TipsPanel:Center()
        TipsPanel:SetTitle("")
        TipsPanel:SetDraggable(false)
        TipsPanel:MakePopup()
        TipsPanel:SetKeyboardInputEnabled(false)
        TipsPanel:SetMouseInputEnabled( false )
        
        TipsPanel.Paint = function(self, w, h)
            draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,225))

		    local tiptext = "<color=255,255,255><font=UVFont2-Smaller>" .. UVReplaceKeybinds( string.format(UVString("uv.tip"), UVString(randomTipText) ), "Big") .. "</font></color>"
		    markup.Parse(tiptext, w):Draw(w*0.5, h, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        end
        
        local ResultPanel = vgui.Create("DFrame")
        local OK = vgui.Create("DButton")
        
        ResultPanel:Add(OK)
        ResultPanel:SetSize(math.Round(w*0.52), math.Round(h*0.56))
        ResultPanel:SetBackgroundBlur(true)
        ResultPanel:ShowCloseButton(false)
        ResultPanel:Center()
        ResultPanel:SetTitle("")
        ResultPanel:SetDraggable(false)
        ResultPanel:MakePopup()
        ResultPanel:SetKeyboardInputEnabled(false)
        
        OK:SetText(UVString("addons.confirm"))
        OK:SetSize(ResultPanel:GetWide() * 5 / 16, 22)
        OK:Dock(BOTTOM)
        
        local timetotal = 30
        local timestart = CurTime()
        
        ResultPanel.Paint = function(self, w, h)
            local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
            local lang = UVString
            
            draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,225))
            draw.SimpleText("--- " .. lang("uv.chase.evade") .. " ---", "UVFont", w*0.5, h*0.01, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText( string.format( lang("uv.results.suspects.escaped.num"), UVHUDWantedSuspectsNumber), "UVFont2", w*0.5, h*0.075, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.bounty"), "UVFont2", w*0.01, h*0.15, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.time"), "UVFont2", w*0.01, h*0.25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.units.deployed"), "UVFont2", w*0.01, h*0.35, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.units.damaged"), "UVFont2", w*0.01, h*0.45, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.units.destroyed"), "UVFont2", w*0.01, h*0.55, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.dodged.blocks"), "UVFont2", w*0.01, h*0.65, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.dodged.spikes"), "UVFont2", w*0.01, h*0.75, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            
            draw.SimpleText( bounty, "UVFont2", w*0.99, h*0.15, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( time, "UVFont2", w*0.99, h*0.25, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( deploys, "UVFont2", w*0.99, h*0.35, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( tags, "UVFont2", w*0.99, h*0.45, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( wrecks, "UVFont2", w*0.99, h*0.55, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( roadblocksdodged, "UVFont2", w*0.99, h*0.65, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( spikestripsdodged, "UVFont2", w*0.99, h*0.75, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            
            -- Time remaining and closing
            local contenttext = UVReplaceKeybinds("[+jump] " .. UVString("uv.results.continue") .. " (" .. math.max(0, timeremaining) .. ")", "Big")
            --draw.DrawText( "[ " .. UVBindButton("+jump") .. " ] " .. UVString("uv.results.continue"), "UVFont2", w*0.01, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
            local markuptext = "<color=255,255,255><font=UVFont2>".. contenttext .. "</font></color>"
            markup.Parse(markuptext):Draw(w*0.01, h*0.85, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            if timeremaining < 1 then
                hook.Remove("CreateMove", "JumpKeyCloseDebrief")
                self:Close()
                TipsPanel:Close()
            end
            
        end
        
        function OK:DoClick() 
            hook.Remove("CreateMove", "JumpKeyCloseDebrief")
            ResultPanel:Close()
            TipsPanel:Close()
        end
        
		hook.Add("CreateMove", "JumpKeyCloseDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end

			if ply:KeyPressed(IN_JUMP) then
				if IsValid(ResultPanel) then
					hook.Remove("CreateMove", "JumpKeyCloseDebrief")
					ResultPanel:Close()
                    TipsPanel:Close()
				end
			end
		end)
    end,
    onRacerEscapedDebrief = function(...)
        if UVHUDDisplayRacing then return end
        
        local w = UV_GetW()
        local h = UV_GetH()
        
        local escapedtable = select( 1, ... )

        local tipstring = UV.Tips.Racer
	    local randomTipText = tipstring[math.random(1, #tipstring)]
        
        --------------------------------------
        
        local time = UVDisplayTime(UVTimerProgress)
        local deploys = escapedtable["Deploys"]
        local roadblocksdodged = escapedtable["Roadblocks"]
        local spikestripsdodged = escapedtable["Spikestrips"]
        local bounty = escapedtable["Bounty"] or 0
        local tags = escapedtable["Tags"] or 0
        local wrecks = escapedtable["Wrecks"] or 0
        local finesdue = UVFinesDue or 0

        -- Tip
        local TipsPanel = vgui.Create("DFrame")
        
        TipsPanel:SetSize(math.Round(w), math.Round(h))
        TipsPanel:SetBackgroundBlur(true)
        TipsPanel:ShowCloseButton(false)
        TipsPanel:Center()
        TipsPanel:SetTitle("")
        TipsPanel:SetDraggable(false)
        TipsPanel:MakePopup()
        TipsPanel:SetKeyboardInputEnabled(false)
        TipsPanel:SetMouseInputEnabled( false )

        local bly = (h / 2) + (math.Round(h*0.56)/2)
        
        TipsPanel.Paint = function(self, w, h)
            draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,225))

            local finesduetext = "<color=255,255,255><font=UVFont2-Smaller>" .. UVString("uv.results.chase.fines") .. ": $" .. UVFinesDue .. "</font></color>"
            markup.Parse(finesduetext, w):Draw((w / 2), bly, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		    local tiptext = "<color=255,255,255><font=UVFont2-Smaller>" .. UVReplaceKeybinds( string.format(UVString("uv.tip"), UVString(randomTipText) ), "Big") .. "</font></color>"
		    markup.Parse(tiptext, w):Draw(w*0.5, h, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        end
        
        local ResultPanel = vgui.Create("DFrame")
        local OK = vgui.Create("DButton")
        
        ResultPanel:Add(OK)
        ResultPanel:SetSize(math.Round(w*0.52), math.Round(h*0.56))
        ResultPanel:SetBackgroundBlur(true)
        ResultPanel:ShowCloseButton(false)
        ResultPanel:Center()
        ResultPanel:SetTitle("")
        ResultPanel:SetDraggable(false)
        ResultPanel:MakePopup()
        ResultPanel:SetKeyboardInputEnabled(false)
        
        OK:SetText(UVString("addons.confirm"))
        OK:SetSize(ResultPanel:GetWide() * 5 / 16, 22)
        OK:Dock(BOTTOM)
        
        local timetotal = 30
        local timestart = CurTime()
        
        ResultPanel.Paint = function(self, w, h)
            local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
            local lang = UVString
            
            draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,225))
            draw.SimpleText("--- " .. lang("uv.chase.evade") .. " ---", "UVFont", w*0.5, h*0.01, Color(0, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText( lang("uv.results.escapedfrom"), "UVFont2", w*0.5, h*0.075, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.bounty"), "UVFont2", w*0.01, h*0.15, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.time"), "UVFont2", w*0.01, h*0.25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.units.deployed"), "UVFont2", w*0.01, h*0.35, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.units.damaged"), "UVFont2", w*0.01, h*0.45, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.units.destroyed"), "UVFont2", w*0.01, h*0.55, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.dodged.blocks"), "UVFont2", w*0.01, h*0.65, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.dodged.spikes"), "UVFont2", w*0.01, h*0.75, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            
            draw.SimpleText( bounty, "UVFont2", w*0.99, h*0.15, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( time, "UVFont2", w*0.99, h*0.25, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( deploys, "UVFont2", w*0.99, h*0.35, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( tags, "UVFont2", w*0.99, h*0.45, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( wrecks, "UVFont2", w*0.99, h*0.55, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( roadblocksdodged, "UVFont2", w*0.99, h*0.65, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( spikestripsdodged, "UVFont2", w*0.99, h*0.75, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            
            -- Time remaining and closing
            local contenttext = UVReplaceKeybinds("[+jump] " .. UVString("uv.results.continue") .. " (" .. math.max(0, timeremaining) .. ")", "Big")
            --draw.DrawText( "[ " .. UVBindButton("+jump") .. " ] " .. UVString("uv.results.continue"), "UVFont2", w*0.01, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
            local markuptext = "<color=255,255,255><font=UVFont2>".. contenttext .. "</font></color>"
            markup.Parse(markuptext):Draw(w*0.01, h*0.85, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
            if timeremaining < 1 then
                hook.Remove("CreateMove", "JumpKeyCloseDebrief")
                self:Close()
                TipsPanel:Close()
            end
            
        end
        
        function OK:DoClick() 
            hook.Remove("CreateMove", "JumpKeyCloseDebrief")
            ResultPanel:Close()
            TipsPanel:Close()
        end
        
		hook.Add("CreateMove", "JumpKeyCloseDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end

			if ply:KeyPressed(IN_JUMP) then
				if IsValid(ResultPanel) then
					hook.Remove("CreateMove", "JumpKeyCloseDebrief")
					ResultPanel:Close()
                    TipsPanel:Close()
				end
			end
		end)
    end,
    onRacerBustedDebrief = function(...)
        local w = UV_GetW()
        local h = UV_GetH()
        
        local bustedtable = select( 1, ... )

        local tipstring = UV.Tips.Racer
	    local randomTipText = tipstring[math.random(1, #tipstring)]
        
        --------------------------------------
        
        local time = UVDisplayTime(UVTimerProgress)
        local unit = UVString(bustedtable["Unit"]) or "Unknown"
        local deploys = bustedtable["Deploys"]
        local roadblocksdodged = bustedtable["Roadblocks"]
        local spikestripsdodged = bustedtable["Spikestrips"]
        local bounty = bustedtable["Bounty"] or 0
        local tags = bustedtable["Tags"] or 0
        local wrecks = bustedtable["Wrecks"] or 0
        local finesdue = UVFinesDue or 0

        -- Tip
        local TipsPanel = vgui.Create("DFrame")
        
        TipsPanel:SetSize(math.Round(w), math.Round(h))
        TipsPanel:SetBackgroundBlur(true)
        TipsPanel:ShowCloseButton(false)
        TipsPanel:Center()
        TipsPanel:SetTitle("")
        TipsPanel:SetDraggable(false)
        TipsPanel:MakePopup()
        TipsPanel:SetKeyboardInputEnabled(false)
        TipsPanel:SetMouseInputEnabled( false )

        local bly = (h / 2) + (math.Round(h*0.56)/2)
        
        TipsPanel.Paint = function(self, w, h)
            draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,225))

            local finesduetext = "<color=255,255,255><font=UVFont2-Smaller>" .. UVString("uv.results.chase.fines") .. ": $" .. (UVFinesDue or 0) .. "</font></color>"
            markup.Parse(finesduetext, w):Draw((w / 2), bly, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		    local tiptext = "<color=255,255,255><font=UVFont2-Smaller>" .. UVReplaceKeybinds( string.format(UVString("uv.tip"), UVString(randomTipText) ), "Big") .. "</font></color>"
		    markup.Parse(tiptext, w):Draw(w*0.5, h, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        end
        
        local ResultPanel = vgui.Create("DFrame")
        local OK = vgui.Create("DButton")
        
        ResultPanel:Add(OK)
        ResultPanel:SetSize(math.Round(w*0.52), math.Round(h*0.56))
        ResultPanel:SetBackgroundBlur(true)
        ResultPanel:ShowCloseButton(false)
        ResultPanel:Center()
        ResultPanel:SetTitle("")
        ResultPanel:SetDraggable(false)
        ResultPanel:MakePopup()
        ResultPanel:SetKeyboardInputEnabled(false)
        
        OK:SetText(UVString("addons.confirm"))
        OK:SetSize(ResultPanel:GetWide() * 5 / 16, 22)
        OK:Dock(BOTTOM)
        
        local timetotal = 30
        local timestart = CurTime()
        
        ResultPanel.Paint = function(self, w, h)
            local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
            local lang = UVString
            
            draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,225))
            draw.SimpleText("/// " .. lang("uv.chase.busted") .. " ///", "UVFont", w*0.5, h*0.01, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText(string.format( lang("uv.results.bustedby"), unit ), "UVFont2", w*0.5, h*0.075, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.bounty"), "UVFont2", w*0.01, h*0.15, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.time"), "UVFont2", w*0.01, h*0.25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.units.deployed"), "UVFont2", w*0.01, h*0.35, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.units.damaged"), "UVFont2", w*0.01, h*0.45, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.units.destroyed"), "UVFont2", w*0.01, h*0.55, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.dodged.blocks"), "UVFont2", w*0.01, h*0.65, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( UVString("uv.results.chase.dodged.spikes"), "UVFont2", w*0.01, h*0.75, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            
            draw.SimpleText( bounty, "UVFont2", w*0.99, h*0.15, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( time, "UVFont2", w*0.99, h*0.25, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( deploys, "UVFont2", w*0.99, h*0.35, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( tags, "UVFont2", w*0.99, h*0.45, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( wrecks, "UVFont2", w*0.99, h*0.55, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( roadblocksdodged, "UVFont2", w*0.99, h*0.65, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( spikestripsdodged, "UVFont2", w*0.99, h*0.75, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            
            -- Time remaining and closing
            local contenttext = UVReplaceKeybinds("[+jump] " .. UVString("uv.results.continue") .. " (" .. math.max(0, timeremaining) .. ")", "Big")
            --draw.DrawText( "[ " .. UVBindButton("+jump") .. " ] " .. UVString("uv.results.continue"), "UVFont2", w*0.01, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
            local markuptext = "<color=255,255,255><font=UVFont2>".. contenttext .. "</font></color>"
            markup.Parse(markuptext):Draw(w*0.01, h*0.85, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			if UVHUDWantedSuspects and #UVHUDWantedSuspects > 0 then
				local spawnastext = UVReplaceKeybinds("[+reload] " .. UVString("uv.pm.spawnas"), "Big")
				local markuptext2 = "<color=255,255,255><font=UVFont2>".. spawnastext .. "</font></color>"
				markup.Parse(markuptext2):Draw(w*0.99, h*0.85, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			end

            if timeremaining < 1 then
                hook.Remove("CreateMove", "JumpKeyCloseDebrief")
                self:Close()
                TipsPanel:Close()
            end
            
        end
        
        function OK:DoClick() 
            hook.Remove("CreateMove", "JumpKeyCloseDebrief")
            ResultPanel:Close()
            TipsPanel:Close()
        end

		hook.Add("CreateMove", "JumpKeyCloseDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end

			if ply:KeyPressed(IN_JUMP) then
				if IsValid(ResultPanel) then
					hook.Remove("CreateMove", "JumpKeyCloseDebrief")
					hook.Remove("CreateMove", "ReloadKeyCloseDebrief")
					ResultPanel:Close()
                    TipsPanel:Close()
				end
			end
		end)

		if UVHUDWantedSuspects and #UVHUDWantedSuspects > 0 then
			hook.Add("CreateMove", "ReloadKeyCloseDebrief", function()
				local ply = LocalPlayer()
				if not IsValid(ply) then return end

				if ply:KeyPressed(IN_RELOAD) then
					if IsValid(ResultPanel) then
						hook.Remove("CreateMove", "JumpKeyCloseDebrief")
						hook.Remove("CreateMove", "ReloadKeyCloseDebrief")
						ResultPanel:Close()
                        TipsPanel:Close()

						net.Start("UVHUDRespawnInUVGetInfo")
						net.SendToServer()
					end
				end
			end)
		end
    end,

    onPullOverRequest = function(...)
        local ply = LocalPlayer()
		ply:PrintMessage(HUD_PRINTCENTER, UVHUDCopMode and UVString("uv.hud.fine.pullover.unit") or UVString("uv.hud.fine.pullover"))
	end,

	onFined = function( finenr, finesdue )
        local ply = LocalPlayer()
		ply:PrintMessage(HUD_PRINTCENTER, string.format( UVHUDCopMode and UVString("uv.hud.fine.fined.unit") or UVString("uv.hud.fine.fined"), finenr))
		timer.Simple(3, function()
			ply:PrintMessage(HUD_PRINTCENTER, string.format( UVString("uv.hud.fine.cost"), finesdue))
		end)
	end,

    onInfraction = function(text, number)

        text = UVString("uv.results.infractions") .. " " .. number .. ": " .. text

		UV_UI.general.events.CenterNotification({
            text = text,
		})
        
	end,
}

local function original_racing_main( ... )
    local w = UV_GetW()
    local h = UV_GetH()
    
    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)
    
    local racer_count = #string_array
    local lang = UVString
    
    local checkpoint_count = #my_array["Checkpoints"]
    
    ------------------------------------
    
    local element1 = {}
    if UVHUDRaceInfo.Info.Laps > 1 then
        element1 = {
            {x = 0, y = h / 7},
            {x = w * 0.35, y = h / 7},
            {x = w * 0.25, y = h / 3},
            {x = 0, y = h / 3}
        }
    else
        element1 = {
            {x = 0, y = h / 7},
            {x = w * 0.35, y = h / 7},
            {x = w * 0.25, y = h / 3.5},
            {x = 0, y = h / 3.5}
        }
    end
    -- HUD Background
    surface.SetDrawColor(0, 0, 0, 200)
    draw.NoTexture()
    surface.DrawPoly(element1)
    
    -- All HUD Text (I mean, it *works*...)
    draw.DrawText(lang("uv.race.orig.time") ..UVDisplayTimeRace((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0) .."\n"
    ..lang("uv.race.orig.check") ..checkpoint_count .."/"
    ..GetGlobalInt("uvrace_checkpoints") .."\n" 
    ..(UVHUDRaceInfo.Info.Laps > 1 and lang("uv.race.orig.lap") 
    ..my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps .. "\n" or "") 
    ..lang("uv.race.orig.pos") 
    .. UVHUDRaceCurrentPos 
    .. "/" 
    .. UVHUDRaceCurrentParticipants, "UVFont", 10, h / 7, Color(255, 255, 255), TEXT_ALIGN_LEFT)

    local current_time = nil 

    if UV_UI.racing.original.states.FrozenTime then
        current_time = UVDisplayTimeRace( UV_UI.racing.original.states.FrozenTimeValue )
    elseif not my_array.LastLapTime then
        current_time = UVDisplayTimeRace( (UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0 )
    else
        current_time = UVDisplayTimeRace( CurTime() - my_array.LastLapCurTime )
    end

    -- Timer
    draw.DrawText(
        "\n"..string.format(UVString("uv.race.hud.time.ug")).." "..(current_time or UVDisplayTimeRace( 0 )).." \n"
        ..string.format(UVString("uv.race.hud.best.ug")).." "..(UVDisplayTimeRace(my_array.BestLapTime or 0)).." ",
        "UVFont4",
        w,
        h / 7,
        Color(255, 255, 255),
        TEXT_ALIGN_RIGHT
    )
    
    -- Racer List
    -- for i = 1, math.Clamp(racer_count, 1, GetConVar("uvhud_original_race_raceramount"):GetString()), 1 do
    for i = 1, math.Clamp(racer_count, 1, 16), 1 do
        local entry = string_array[i]
        
        local racer_name = entry[1]
        local is_local_player = entry[2]
        local mode = entry[3]
        local diff = entry[4]
        -- local racercount = i * (racer_count > 8 and w*0.0135 or w*0.0115)
        local racerpos = 3.75

        local Strings = {
            ["Time"] = "%s",
            ["Lap"] = lang("uv.race.suffix.lap"),
            ["Laps"] = lang("uv.race.suffix.laps"),
            ["Finished"] = lang("uv.race.suffix.finished"),
            ["Disqualified"] = lang("uv.race.suffix.dnf"),
            ["Busted"] = lang("uv.race.suffix.busted"),
        }
        
        local status_text = ""
        
		if entry[3] then
			local status_string = Strings[entry[3]]

			if status_string then
				local args = {}

				if entry[4] then
					local num = tonumber(entry[4])

					if entry[3] == "Lap" and num then
						-- choose singular/plural string
						local lapString = (math.abs(num) > 1) and Strings["Laps"] or Strings["Lap"]
						-- rebuild status_string so the format target is correct
						status_string = lapString
						num = ((num > 0 and "+") or "-") .. tostring(math.abs(num))
					elseif num then
						num = ((num > 0 and "+") or "-") .. string.format("%.2f", math.abs(num))
					end

					table.insert(args, num)
				end

				status_text = (#args <= 0) and " (" .. status_string .. ")" or " (" .. string.format(status_string, unpack(args)) .. ")"
			end
		end
        
        if UVHUDRaceInfo.Info.Laps > 1 then
            racerpos = 3.15
        end
        
        local color = nil
        
        if is_local_player then
            color = UVColors.Original_LocalPlayer
        elseif entry[3] == "Disqualified" or entry[3] == "Busted" then
            color = UVColors.Original_Disqualified
        else
            color = UVColors.Original_Others
        end
        
        local text = (i .. ". " .. racer_name .. status_text)
        
        draw.DrawText(text,"UVFont4",10,(h / racerpos) + i * ((racer_count > 10 and 20) or 28),color,TEXT_ALIGN_LEFT)
    end
end

local function original_pursuit_main( ... )
    local hudyes = GetConVar("cl_drawhud"):GetBool()
    
    if not hudyes then return end
    if not UVHUDDisplayPursuit then return end
    -- if UVHUDDisplayRacing then return end
    
    
    local vehicle = LocalPlayer():GetVehicle()
    
    local w = UV_GetW()
    local h = UV_GetH()
    local lang = UVString
    
    local UnitsChasing = tonumber(UVUnitsChasing)
    local UVBustTimer = BustedTimer:GetFloat()
    
    local states = UV_UI.pursuit.original.states
    
    local UVWrecksColor = states.WrecksColor
    local UVTagsColor = states.TagsColor
    local UVUnitsColor = states.UnitsColor
    
    if vehicle == NULL then return end
    
    if UVHUDCopMode and not UVHUDDisplayNotification then
        UVHUDDisplayBusting = false
    end
    
    if UVHUDCopMode and next(UVHUDWantedSuspects) ~= nil then
        local ply = LocalPlayer()
        
        UVClosestSuspect = nil
        UVHUDDisplayBusting = false
        
        local closestDistance = math.huge
        
        for _, suspect in pairs(UVHUDWantedSuspects) do
            if IsValid(suspect) then
                local dist = ply:GetPos():DistToSqr(suspect:GetPos())
                
                if (#UVHUDWantedSuspects == 1 or dist < 250000) and dist < closestDistance then
                    closestDistance = dist
                    UVClosestSuspect = suspect
                end 
            end
        end
        
        if UVClosestSuspect then
            if UVClosestSuspect.beingbusted then
                UVHUDDisplayBusting = true
                UVBustingProgress = UVClosestSuspect.UVBustingProgress or 0
                
                local blink = math.floor(RealTime()*8)==math.Round(RealTime()*8) and 255 or 0
                states.BustedColor = Color(255, blink, blink)
            end
        end
    end
		
	local bottomyplus = 0

	if UVHUDActiveBar then
		bottomyplus = -(h * 0.075)
	end

	local bottomy = h * 0.9 + bottomyplus
		
    if UVHUDDisplayPursuit and hudyes and vehicle ~= NULL then
        outofpursuit = CurTime()
        
        local UVHeatBountyMin
        local UVHeatBountyMax
        local element1 = {
            { x = w/1.35, y = h/20 },
            { x = w/1.155, y = 0 },
            { x = w, y = 0 },
            { x = w, y = h/7 },
            { x = w/1.35, y = h/7 },
        }
        surface.SetDrawColor( 0, 0, 0, 200)
        draw.NoTexture()
        surface.DrawPoly( element1 )

        -- DrawIcon(UVMaterials['CLOCK'], w/1.135, h*0.07, .05, Color(255,255,255))
        
        draw.DrawText( "⏰", "UVFont2",w/1.32, h/20, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )
        
        draw.DrawText( UVTimer, "UVFont2",w/1.005, h/20, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )
        surface.SetFont( "UVFont2" )
        surface.SetTextColor(255,255,255)
        surface.SetTextPos( w/1.35, h/10 ) 
        surface.DrawText( UVString("uv.hud.bounty") )
        draw.DrawText( UVBounty, "UVFont2",w/1.005, h/10, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )

        -- Fines due
        if UVFinesDue and not UVHUDCopMode then
            draw.DrawText(
                UVString("uv.results.chase.fines") .. ": $" .. UVFinesDue .. " ",
                "UVFont4",
                w,
                h / 7,
                Color(255, 255, 255),
                TEXT_ALIGN_RIGHT
            )
        end
        
        -- if UVHeatLevel == 1 then
        --     UVHeatBountyMin = UVUHeatMinimumBounty1:GetInt()
        --     UVHeatBountyMax = UVUHeatMinimumBounty2:GetInt()
        -- elseif UVHeatLevel == 2 then
        --     UVHeatBountyMin = UVUHeatMinimumBounty2:GetInt()
        --     UVHeatBountyMax = UVUHeatMinimumBounty3:GetInt()
        -- elseif UVHeatLevel == 3 then
        --     UVHeatBountyMin = UVUHeatMinimumBounty3:GetInt()
        --     UVHeatBountyMax = UVUHeatMinimumBounty4:GetInt()
        -- elseif UVHeatLevel == 4 then
        --     UVHeatBountyMin = UVUHeatMinimumBounty4:GetInt()
        --     UVHeatBountyMax = UVUHeatMinimumBounty5:GetInt()
        -- elseif UVHeatLevel == 5 then
        --     UVHeatBountyMin = UVUHeatMinimumBounty5:GetInt()
        --     UVHeatBountyMax = UVUHeatMinimumBounty6:GetInt()
        -- elseif UVHeatLevel == 6 then
        --     UVHeatBountyMin = UVUHeatMinimumBounty6:GetInt()
        --     UVHeatBountyMax = math.huge
        -- end
        
        local UVHeatMinConVar = GetConVar( 'unitvehicle_unit_heatminimumbounty' .. UVHeatLevel )
        local UVHeatMaxConVar = GetConVar( 'unitvehicle_unit_heatminimumbounty' .. UVHeatLevel + 1 )
        
        UVHeatBountyMin = ( UVHeatMinConVar and UVHeatMinConVar:GetInt() ) or math.huge
        UVHeatBountyMax = ( UVHeatMaxConVar and UVHeatMaxConVar:GetInt() ) or math.huge
        
        draw.DrawText( "♨ " .. UVHeatLevel, "UVFont2", w/1.105, h/120, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )
        
        -- local hl10 = 0
        -- if UVHeatLevel > 9 then hl10 = w * 0.01 end
        -- DrawIcon(UVMaterials['HEAT'], w/1.135 - hl10, h*0.027, .05, Color(255,255,255))
        
        surface.SetDrawColor(Color(109,109,109,200))
        surface.DrawRect(w/1.099,h/120,w/20+60,39)
        surface.SetDrawColor(Color(255,255,255))
        local HeatProgress = 0
        if MaxHeatLevel:GetInt() ~= UVHeatLevel then
            if UVUTimeTillNextHeatEnabled:GetInt() == 1 and UVTimeTillNextHeat then --Time till next heat level
                local timedHeatConVar = GetConVar( 'unitvehicle_unit_timetillnextheat' .. UVHeatLevel )
                
                local maxtime = timedHeatConVar and timedHeatConVar:GetInt() or 0
                HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
            else
                HeatProgress = ((UVBountyNo - UVHeatBountyMin) / (UVHeatBountyMax - UVHeatBountyMin))
            end
        end
        local B = math.Clamp((HeatProgress)*(w/20+60),0,w/20+60)
        local blinkhalf = math.floor(RealTime()*2)==math.Round(RealTime()*2) and 255 or 0
        local blink = math.floor(RealTime()*4)==math.Round(RealTime()*4) and 255 or 0
        local blink2 = math.floor(RealTime()*6)==math.Round(RealTime()*6) and 255 or 0
        local blink3 = math.floor(RealTime()*8)==math.Round(RealTime()*8) and 255 or 0
        
        if HeatProgress >= 0.75 and HeatProgress < 1 then
            surface.SetDrawColor(Color(255,blinkhalf,blinkhalf))
        elseif HeatProgress >= 1 then
            surface.SetDrawColor(Color(255,0,0))
        end

        UVResourcePointsColor = Color( 255, 255, 255)

        local num = UVBackupTimerSeconds or 0
        if UVHUDDisplayBackupTimer and num <= 10 and math.floor(num)~=math.Round(num) then
			UVResourcePointsColor = Color( 255, 255, 0)
		end
        
        surface.DrawRect(w/1.099,h/120,B,39)
        local ResourceText = "⛉\n"..UVResourcePoints
        if UVOneCommanderActive then
            if not UVHUDCommanderLastHealth or not UVHUDCommanderLastMaxHealth then
                UVHUDCommanderLastHealth = 0
                UVHUDCommanderLastMaxHealth = 0
            end
            if IsValid(UVHUDCommander) then
                if UVHUDCommander.IsSimfphyscar then
                    UVHUDCommanderLastHealth = UVHUDCommander:GetCurHealth()
                    UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()-(UVHUDCommander:GetMaxHealth()*0.3)
                elseif UVHUDCommander.IsGlideVehicle then
                    local enginehealth = UVHUDCommander:GetEngineHealth()
                    UVHUDCommanderLastHealth = UVHUDCommander:GetChassisHealth()*enginehealth
                    UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
                elseif vcmod_main then
                    UVHUDCommanderLastHealth = UVUOneCommanderHealth:GetInt()*(UVHUDCommander:VC_getHealth()/100) --vcmod returns % health clientside
                    UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
                else
                    UVHUDCommanderLastHealth = UVHUDCommander:Health()
                    UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
                end
                UVRenderCommander(UVHUDCommander)
            end
            local healthratio = UVHUDCommanderLastHealth/UVHUDCommanderLastMaxHealth
            local healthcolor
            local blink = math.floor(RealTime()*4)==math.Round(RealTime()*4) and 255 or 0
            local blink2 = math.floor(RealTime()*6)==math.Round(RealTime()*6) and 255 or 0
            local blink3 = math.floor(RealTime()*8)==math.Round(RealTime()*8) and 255 or 0
            
            if healthratio >= 0.5 then
                healthcolor = Color(255, 255, 255, 200)
            elseif healthratio >= 0.25 then
                healthcolor = Color(255, blink, blink, 200)
            else
                healthcolor = Color(255, blink2, blink2, 200)
            end
            
            ResourceText = "⛊\n∞"
            local element3 = {
                { x = w/3, y = 0 },
                { x = w/3+12+w/3, y = 0 },
                { x = w/3+12+w/3-25, y = h/20 },
                { x = w/3+25, y = h/20 },
            }
            surface.SetDrawColor( 0, 0, 0, 200)
            draw.NoTexture()
            surface.DrawPoly( element3 )
            if healthratio > 0 then
                surface.SetDrawColor(Color(109,109,109,200))
                surface.DrawRect(w/3+25,h/20,w/3-38,8)
                surface.SetDrawColor(healthcolor)
                local T = math.Clamp((healthratio)*(w/3-38),0,w/3-38)
                surface.DrawRect(w/3+25,h/20,T,8)
            end
            
            local cname = lang("uv.unit.commander")
            if IsValid(UVHUDCommander) then
                local driver = UVHUDCommander:GetDriver()
                if IsValid(driver) and driver:IsPlayer() then
                    cname = driver:Nick()
                end
            end
            
            draw.DrawText( "⛊ " .. cname .. " ⛊", "UVFont2",w/2,0, Color(0, 161, 255), TEXT_ALIGN_CENTER )
        end

        local element2 = {
            { x = w/3, y = bottomy + (h * 0.01)+28+12 },
            { x = w/3+12+w/3, y = bottomy + (h * 0.01)+28+12 },
            { x = w/3+12+w/3-25, y = bottomy + (h * 0.1) },
            { x = w/3+25, y = bottomy + (h * 0.1) },
        }
        draw.NoTexture()
        surface.SetDrawColor( 0, 0, 0, 200)
        surface.DrawPoly( element2 )
        
        local iconhigh = 0

        if UVHUDDisplayBusting or (UVHUDDisplayCooldown and not UVHUDCopMode) then
            iconhigh = h*0.035
        end
        
        if not UVHUDDisplayNotification then
            if (UnitsChasing ~= 0 or NeverEvade:GetBool()) and not UVHUDDisplayCooldown or BustingProgress ~= 0 then
                EvadingProgress = 0
                local busttime = math.Round((BustedTimer:GetFloat()-UVBustingProgress),3)
                
                if BustingProgress == 0 then
                    if not UVHUDDisplayBackupTimer then
                        local uloc, utype = "uv.hud.original.chase.unit", UnitsChasing
                        if not UVHUDCopMode then
                            if UnitsChasing ~= 1 then 
                                uloc = "uv.hud.original.chase.units"
                            end
                        else
                            utype = UVHUDWantedSuspectsNumber
                            uloc = "uv.chase.suspects"
                        end
                        
                        draw.DrawText( string.format( lang(uloc), utype ), "UVFont-Smaller",w/2,bottomy + (h * 0.05), UVResourcePointsColor, TEXT_ALIGN_CENTER )
                    else
                        draw.DrawText( string.format( lang("uv.chase.backupin"), UVBackupTimer ), "UVFont-Smaller",w/2,bottomy + (h * 0.05), UVResourcePointsColor, TEXT_ALIGN_CENTER )
                    end
                else
                    local busttext = ""
                    if busttime >= 3 then
                        busttext = lang("uv.chase.busting")
                        bustcol = Color( 255, 0, 0)
                    elseif busttime >= 2 then
                        busttext = "! " .. lang("uv.chase.busting") .. " !"
                        bustcol = Color( 255, blink, blink)
                    elseif busttime >= 1 then
                        busttext = "!! " .. lang("uv.chase.busting") .. " !!"
                        bustcol = Color( 255, blink2, blink2)
                    elseif busttime >= 0 then
                        busttext = "!!! " .. lang("uv.chase.busting") .. " !!!"
                        bustcol = Color( 255, blink3, blink3)
                    end
                    draw.DrawText( busttext, "UVFont-Smaller",w/2,bottomy + (h * 0.05), bustcol, TEXT_ALIGN_CENTER )
                    iconhigh = h*0.035
                end
                --UVSoundHeat(UVHeatLevel)
            elseif not UVHUDDisplayCooldown then
                if not EvadingProgress then
                    EvadingProgress = 0
                    UVEvadingProgress = EvadingProgress
                end
                
                draw.DrawText( lang("uv.chase.evading"), "UVFont-Smaller",w/2,bottomy + (h * 0.05), Color( 0, 255, 0), TEXT_ALIGN_CENTER )
                
                surface.SetDrawColor( 0, 0, 0, 200)
                surface.DrawRect( w/3,bottomy + (h * 0.01),w/3+12, 40 )
                surface.SetDrawColor(Color( 0, 255, 0))
                surface.DrawRect(w/3,bottomy + (h * 0.01),12,40)
                surface.DrawRect(w*2/3,bottomy + (h * 0.01),12,40)
                surface.DrawRect(w/3+12,bottomy + (h * 0.01),w/3-12,12)
                surface.DrawRect(w/3+12,bottomy + (h * 0.01)+28,w/3-12,12)
                surface.SetDrawColor(Color( 0, 255, 0))
                local T = math.Clamp((UVEvadingProgress)*(w/3-20),0,w/3-20)
                surface.DrawRect(w/3+16,bottomy + (h * 0.01)+16,T,8)
                --UVSoundHeat(UVHeatLevel)
                iconhigh = h*0.035
            else
                EvadingProgress = 0
                local color = Color(0,0,255)
                
                if UVHUDCopMode then
                    local blink = math.floor(RealTime()*2)==math.Round(RealTime()*2) and 255 or 0
                    color = Color( blink, blink, 255)
                end
                
                local text = (UVHUDCopMode and "/// "..lang("uv.chase.cooldown").." ///") or lang("uv.chase.cooldown")
                draw.DrawText( text, "UVFont-Smaller",w/2,bottomy + (h * 0.05), color, TEXT_ALIGN_CENTER )
                iconhigh = not UVHUDCopMode and h*0.035 or iconhigh
            end
        else
            EvadingProgress = 0
            draw.DrawText( UVNotification, "UVFont-Smaller",w/2,bottomy + (h * 0.05), UVNotificationColor, TEXT_ALIGN_CENTER )
        end

        -- DrawIcon(UVMaterials['UNITS_DISABLED'], w * 0.68, h * 0.975, 0.06, UVWrecksColor)
        draw.DrawText( "☠ " .. UVWrecks, "UVFont3", w * 0.67, bottomy + (h * 0.05), UVWrecksColor, TEXT_ALIGN_LEFT )
        
        -- DrawIcon(UVMaterials['UNITS_DAMAGED'], w * 0.3275, h * 0.975, 0.06, UVTagsColor)
        draw.DrawText( UVTags .. " ☄", "UVFont3", w * 0.335, bottomy + (h * 0.05), UVTagsColor, TEXT_ALIGN_RIGHT )
        
        -- DrawIcon(UVMaterials['UNITS'], w / 2, h * 0.885 - iconhigh, .06, UVUnitsColor)
        draw.DrawText( ResourceText, "UVFont3", w/2, bottomy - (h * 0.05) - iconhigh, UVResourcePointsColor, TEXT_ALIGN_CENTER )
    end
    
    if vehicle == NULL then 
        UVHUDPursuitTech = nil
        return 
    end
    
    if UVHUDDisplayBusting and not UVHUDDisplayCooldown and hudyes then
        if not BustingProgress or BustingProgress == 0 then
            BustingProgress = CurTime()
        end
        surface.SetDrawColor( 0, 0, 0, 200)
        surface.DrawRect( w/3,bottomy + (h * 0.01),w/3+12, 40 )
        surface.SetDrawColor(Color(255,0,0))
        surface.DrawRect(w/3,bottomy + (h * 0.01),12,40)
        surface.DrawRect(w*2/3,bottomy + (h * 0.01),12,40)
        surface.DrawRect(w/3+12,bottomy + (h * 0.01),w/3-12,12)
        surface.DrawRect(w/3+12,bottomy + (h * 0.01)+28,w/3-12,12)
        surface.SetDrawColor(Color(255,0,0))
        
        local T = math.Clamp((UVBustingProgress/UVBustTimer)*(w/3-20),0,w/3-20)
        surface.DrawRect(w/3+16,bottomy + (h * 0.01)+16,T,8)   
    else
        BustingProgress = 0
    end
    
    if UVHUDDisplayCooldown and hudyes then
        if not CooldownProgress or CooldownProgress == 0 then
            CooldownProgress = CurTime()
        end
        
        --UVSoundCooldown(UVHeatLevel)
        
        if not UVHUDCopMode then
            surface.SetDrawColor( 0, 0, 0, 200)
            surface.DrawRect( w/3,bottomy + (h * 0.01),w/3+12, 40 )
            surface.SetDrawColor(Color(0,0,255))
            surface.DrawRect(w/3,bottomy + (h * 0.01),12,40)
            surface.DrawRect(w*2/3,bottomy + (h * 0.01),12,40)
            surface.DrawRect(w/3+12,bottomy + (h * 0.01),w/3-12,12)
            surface.DrawRect(w/3+12,bottomy + (h * 0.01)+28,w/3-12,12)
            surface.SetDrawColor(Color(0,0,255))
            local T = math.Clamp((UVCooldownTimer)*(w/3-20),0,w/3-20)
            surface.DrawRect(w/3+16,bottomy + (h * 0.01)+16,T,8)
        end
        
        EvadingProgress = 0
    else
        CooldownProgress = 0
    end
end

UV_UI.racing.original.main = original_racing_main
UV_UI.pursuit.original.main = original_pursuit_main