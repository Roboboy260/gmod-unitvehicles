UV.RegisterHUD( "mostwanted", "NFS: Most Wanted", true, true )

-- [[ Convars ]] --
-- Racing
CreateClientConVar("uvhud_mostwanted_race_raceramount", 4, true, false)

UVMenu.CustomizeHUD = UVMenu.CustomizeHUD or {}
UVMenu.CustomizeHUD.mostwanted = function()
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = " ",
		Width  = UV.ScaleW(1200),
		Height = UV.ScaleH(760),
		DynamicHeight = true,
		Description = true,
		UnfocusClose = true,
		Tabs = {
			{ TabName = "uv.ui.custhud",
				{ type = "label", text = "NFS: Most Wanted" },
				{ type = "button", text = "uv.back", playsfx = "clickback", prompts = {"uv.prompt.return"},
						func = function(self2) UVMenu.OpenMenu(UVMenu.Settings) end
				},
				{ type = "infosimple", text = "uv.ui.custhud.race" },
				{ type = "slider", text = "uv.ui.custhud.raceramount", desc = "uv.ui.custhud.raceramount.desc", convar = "uvhud_mostwanted_race_raceramount", min = 4, max = 18, decimals = 0 },
			},
		}
	})
end

local _last_backup_pulse_second = 0

UV_UI.racing.mostwanted = UV_UI.racing.mostwanted or {}
UV_UI.pursuit.mostwanted = UV_UI.pursuit.mostwanted or {}

UV_UI.pursuit.mostwanted.states = {
    TagsColor = Color(255,255,255,150),
    WrecksColor = Color(255,255,255,150),
    UnitsColor = Color(255,255,255,150),
    BustedColor = Color(255, 255, 255, 50),
    EvasionColor = Color(255, 255, 255, 50),
    
    TakedownText = nil,

    infractions = {},
    infractionactive = false,
    lastInfractionTime = 0,
}

UV_UI.racing.mostwanted.states = {
    LapCompleteText = nil,
	notificationQueue = {},
	notificationActive = nil,
	
	notificationQueue2 = {}, -- Alt Noti.
	notificationActive2 = nil,
}

UV_UI.racing.mostwanted.events = {
	notifState = {},
	CenterNotification = function( params )
		local immediate = params.immediate or false

		if UV_UI.racing.mostwanted.states.notificationActive then
			if immediate then
				hook.Remove("HUDPaint", "UV_CENTERNOTI_MW")
				UV_UI.racing.mostwanted.states.notificationActive = false
				UV_UI.racing.mostwanted.states.notificationQueue = {}
				timer.Simple(0, function()
					UV_UI.racing.mostwanted.events.CenterNotification(params)
				end)
				return
			else
				table.insert(UV_UI.racing.mostwanted.states.notificationQueue, params)
				return
			end
		end

		UV_UI.racing.mostwanted.states.notificationActive = true

		local ptext = params.text or "ERROR: NO TEXT"
		local ptextcol = params.textCol or Color(255, 255, 255)
		local ptextfont = params.textFont or "UVFont5Shadow"
		local piconMat = params.iconMaterial or UVMaterials["UNITS_DISABLED"]
		local ptextNoFall = params.textNoFall
		local ptextFlyRight = params.textFlyRight
		local pnoIcon = params.noIcon
		local ptextFlyRightNoFall = params.textFlyRightNoFall

		UV_UI.racing.mostwanted.events.notifState = {
			active = true,
			startTime = CurTime(),
			fadeStartTime = nil,

			phase1Duration = 2.5,
			fadeDuration = 0.3,
			startY = ScrH() * 0.325,
			midY = ScrH() * 0.4,
			finalY = ScrH() * 0.9,
			
			-- For Racing Noti
			startX = ScrW() * 0.5,
			midX = ScrW() * 0.6,
			finalX = ScrW() * 0.9,

			randomStart = Vector(math.Rand(ScrW() * 0.3, ScrW() * 0.6), math.Rand(ScrH() * 0.3, ScrH() * 0.5), 0),
			randomBurst1 = Vector(math.Rand(ScrW() * 0.3, ScrW() * 0.6), math.Rand(ScrH() * 0.3, ScrH() * 0.5), 0),
			randomBurst2 = Vector(math.Rand(ScrW() * 0.3, ScrW() * 0.6), math.Rand(ScrH() * 0.3, ScrH() * 0.5), 0),
			centerPos = Vector(ScrW() / 2, ScrH() * 0.275, 0),

			burstDuration = 0.025,
			burstDuration2 = 0.025,
			toCenterDuration = 0.1,
			holdDuration = 2.3,
		}

		local notifState = UV_UI.racing.mostwanted.events.notifState

        ----------------------------------------------------------------------------

        if timer.Exists( 'UV_CENTERNOTI_MW_TIMER' ) then timer.Remove( "UV_CENTERNOTI_MW_TIMER" ) end 

		local nextTriggerTime = notifState.burstDuration + notifState.burstDuration2 + notifState.toCenterDuration + notifState.holdDuration + (notifState.fadeDuration * 0.4)

		timer.Create("UV_CENTERNOTI_MW_TIMER", nextTriggerTime, 1, function()
			UV_UI.racing.mostwanted.states.notificationActive = false

			if #UV_UI.racing.mostwanted.states.notificationQueue > 0 then
				local nextParams = table.remove(UV_UI.racing.mostwanted.states.notificationQueue, 1)
				UV_UI.racing.mostwanted.events.CenterNotification(nextParams)
			end
		end)

		-- Cleanup hook fully after animation ends (optional safety)
		timer.Create("UV_CENTERNOTI_MW_TIMER_CLEANUP", 3, 1, function()
			hook.Remove("HUDPaint", "UV_CENTERNOTI_MW")
			notifState.active = false
		end)

		hook.Add("HUDPaint", "UV_CENTERNOTI_MW", function()
			local now = CurTime()
			local elapsed = now - notifState.startTime
			local pos = Vector()
			local alpha = 255

			if elapsed < notifState.burstDuration then
				-- Phase 1: teleport at randomStart
				pos = notifState.randomStart

			elseif elapsed < notifState.burstDuration + notifState.burstDuration2 then
				-- Phase 2: teleport at randomBurst1
				pos = notifState.randomBurst1

			elseif elapsed < notifState.burstDuration + notifState.burstDuration2 + notifState.toCenterDuration then
				-- Phase 3: teleport at randomBurst2
				pos = notifState.randomBurst2

			elseif elapsed < notifState.burstDuration + notifState.burstDuration2 + notifState.toCenterDuration + notifState.holdDuration then
				-- Phase 4: gradual downward motion from midY to finalY (no fade)
				if ptextNoFall then notifState.midY = notifState.startY end
				if ptextFlyRightNoFall then notifState.midX = notifState.startX end
				
				local holdElapsed = elapsed - (notifState.burstDuration + notifState.burstDuration2 + notifState.toCenterDuration)
				local t = math.Clamp(holdElapsed / notifState.holdDuration, 0, 1)
				if ptextFlyRight then
					pos = Vector(
						Lerp(t, notifState.startX, notifState.midX),
						notifState.midY,
						0
					)
				else
					pos = Vector(
						notifState.centerPos.x,
						Lerp(t, notifState.startY, notifState.midY),
						0
					)
				end
				alpha = 255

			else
				-- Phase 5: smooth fall + fade (as before)
				if not notifState.fadeStartTime then
					notifState.fadeStartTime = now
				end

				local fadeElapsed = now - notifState.fadeStartTime
				local t = math.Clamp(fadeElapsed / notifState.fadeDuration, 0, 1)

				if ptextFlyRight then
					pos = Vector(
						Lerp(t, notifState.midX, notifState.finalX),
						notifState.midY,
						0
					)
				else
					pos = Vector(
						notifState.centerPos.x,
						Lerp(t, notifState.midY, notifState.finalY),
						0
					)
				end
				alpha = Lerp(t, 255, 0)
			end

			mw_noti_draw(ptext, ptextfont, pos.x, pos.y, Color(ptextcol.r, ptextcol.g, ptextcol.b, alpha), Color(0, 0, 0, alpha))
			
			if not pnoIcon then
				local baseAlphaFactor = alpha / 255  -- alpha is between 0 and 255, normalize to 0-1
				local iconblink = 150 * math.abs(math.sin(RealTime() * 8)) * baseAlphaFactor
				local iconDiffY = ScrH() * 0.0525
				local iconStartY = notifState.startY - iconDiffY
				local iconY
				if not notifState.fadeStartTime then
					local t = math.Clamp(elapsed / notifState.phase1Duration, 0, 1)
					iconY = Lerp(t, iconStartY, notifState.midY - iconDiffY)
				else
					local fadeElapsed = now - notifState.fadeStartTime
					local fadeT = math.Clamp(fadeElapsed / notifState.fadeDuration, 0, 1)
					iconY = Lerp(fadeT, notifState.midY - iconDiffY, notifState.finalY - iconDiffY)
				end

				DrawIcon( piconMat, ScrW() / 2, iconY, 0.06, Color(255, 255, 255, alpha) )
				DrawIcon( UVMaterials['GLOW_ICON'], ScrW() / 2, iconY, 0.1, Color(223, 184, 127, iconblink) )
			end
        end)
	end,
	notifState2 = {},
	CenterNotification2 = function( params )
		local immediate = params.immediate or false

		if UV_UI.racing.mostwanted.states.notificationActive2 then
			if immediate then
				hook.Remove("HUDPaint", "UV_CENTERNOTI_MW2")
				UV_UI.racing.mostwanted.states.notificationActive2 = false
				UV_UI.racing.mostwanted.states.notificationQueue2 = {}
				timer.Simple(0, function()
					UV_UI.racing.mostwanted.events.CenterNotification2(params)
				end)
				return
			else
				table.insert(UV_UI.racing.mostwanted.states.notificationQueue2, params)
				return
			end
		end

		UV_UI.racing.mostwanted.states.notificationActive2 = true

		local ptext = params.text or "ERROR: NO TEXT"
		local ptextcol = params.textCol or Color(255, 255, 255)
		local ptextfont = params.textFont or "UVFont5Shadow"

		UV_UI.racing.mostwanted.events.notifState2 = {
			active = true,
			startTime = CurTime(),
			fadeStartTime = nil,

			-- Animation timing
			introDuration = 0.5,
			holdDuration = 3,
			outroDuration = 0.5,

			-- Positioning
			startY = ScrH() * 0.275,
			endY = ScrH() * 0.35,
			x = ScrW() * 0.5,
		}

		local notifState = UV_UI.racing.mostwanted.events.notifState2

        ----------------------------------------------------------------------------

		if timer.Exists("UV_CENTERNOTI_MW_TIMER2") then
			timer.Remove("UV_CENTERNOTI_MW_TIMER2")
		end

		-- Total duration = intro + hold + outro
		local nextTriggerTime = notifState.introDuration + notifState.holdDuration + notifState.outroDuration

		timer.Create("UV_CENTERNOTI_MW_TIMER2", nextTriggerTime, 1, function()
			UV_UI.racing.mostwanted.states.notificationActive2 = false

			if #UV_UI.racing.mostwanted.states.notificationQueue2 > 0 then
				local nextParams = table.remove(UV_UI.racing.mostwanted.states.notificationQueue2, 1)
				UV_UI.racing.mostwanted.events.CenterNotification2(nextParams)
			end
		end)

		-- Cleanup hook fully after animation ends (optional safety)
		timer.Create("UV_CENTERNOTI_MW_TIMER2_CLEANUP", nextTriggerTime + 0.25, 1, function()
			hook.Remove("HUDPaint", "UV_CENTERNOTI_MW2")
			notifState.active = false
		end)

		hook.Add("HUDPaint", "UV_CENTERNOTI_MW2", function()
			local now = CurTime()
			local elapsed = now - notifState.startTime
			local posY = notifState.startY
			local alpha = 0

			if elapsed < notifState.introDuration then
				-- Phase 1: fall in + fade in
				local t = math.Clamp(elapsed / notifState.introDuration, 0, 1)
				posY = Lerp(t, notifState.startY, notifState.endY)
				alpha = Lerp(t, 0, 255)

			elseif elapsed < notifState.introDuration + notifState.holdDuration then
				-- Phase 2: hold steady
				posY = notifState.endY
				alpha = 255

			elseif elapsed < notifState.introDuration + notifState.holdDuration + notifState.outroDuration then
				-- Phase 3: rise out + fade out
				local t = math.Clamp((elapsed - notifState.introDuration - notifState.holdDuration) / notifState.outroDuration, 0, 1)
				posY = Lerp(t, notifState.endY, notifState.startY)
				alpha = Lerp(t, 255, 0)

			else
				-- Animation fully done → cleanup
				if notifState.active then
					notifState.active = false
					hook.Remove("HUDPaint", "UV_CENTERNOTI_MW2")
				end
			end

			-- Draw text
			mw_noti_draw(ptext, ptextfont, notifState.x, posY, Color(ptextcol.r, ptextcol.g, ptextcol.b, alpha), Color(0, 0, 0, alpha))
		end)

	end,
    ShowResults = function(sortedRacers) -- Most Wanted
        local debriefcolor = Color(255, 183, 61)
        
		local w = UV_GetW()
		local h = UV_GetH()
        
        --------------------------------------
        
        local ResultPanel = vgui.Create("DFrame")
        local OK = vgui.Create("DButton")
        
        ResultPanel:Add(OK)
        ResultPanel:SetSize(w, h)
        ResultPanel:SetBackgroundBlur(true)
        ResultPanel:ShowCloseButton(false)
        ResultPanel:Center()
        ResultPanel:SetTitle("")
        ResultPanel:SetDraggable(false)
        ResultPanel:SetKeyboardInputEnabled(false)
		
        -- ResultPanel:MakePopup()
		ResultPanel:SetVisible(true)
		ResultPanel:MoveToFront()
		ResultPanel:RequestFocus()
		gui.EnableScreenClicker(true)

        OK:SetText("")
        OK:SetPos(w*0.2, h*0.7725)
        OK:SetSize(w*0.6, h*0.04)
        OK.Paint = function() end
        
        local timestart = CurTime()
        
        local revealStartTime = CurTime()
        local displaySequence = {}
        
        -- Data and labels
        local racersArray = {}
        
        for _, dict in pairs(sortedRacers) do
            table.insert(racersArray, dict)
        end
        
        table.sort(racersArray, function(a, b)
            local timeA = a.array and a.array.TotalTime
            local timeB = b.array and b.array.TotalTime
            
            -- Treat missing or non-numeric TotalTime as a large number (DNF)
            local tA = (type(timeA) == "number") and timeA or math.huge
            local tB = (type(timeB) == "number") and timeB or math.huge
            
            return tA < tB
        end)
        
        local h1, h2 = h*0.2475, h*0.2875
        local xLeft = w * 0.205
        local xMiddle = w * 0.3
        local xCar = w * 0.45
        local xRight = w * 0.795
        local revealInterval = 0.033
        
        local entriesToShow = 13
        local scrollOffset = 0
        
        local i = 0
        for place, dict in ipairs(racersArray) do
            local info = dict.array or {}
            i = i + 1
            
            local revealTime = revealStartTime + (i - 1) * revealInterval
            
            -- Staggered vertical layout
            local visibleIndex = i -- 1 to entriesToShow
            local yPos = (visibleIndex % 2 == 1) and h1 + math.floor(visibleIndex / 2) * h * 0.08
            or h2 + math.floor((visibleIndex - 1) / 2) * h * 0.08
            
            local name = info["Name"] or "Unknown"
            local totalTime = info["TotalTime"] and info["TotalTime"] or UVString("uv.race.suffix.dnf")
            
            if info["Busted"] then totalTime = UVString("uv.race.suffix.busted") end
            				
			surface.SetFont("UVFont5UI")
		   local vehname = info["VehicleName"]
		   vehname = vehname and string.Trim(UVString(vehname), "#") or "<UNKNOWN>"

			local ymax = w * 0.25
			local ynmax = w * 0.13
			textW = surface.GetTextSize(vehname)
			if textW > ymax then
				while surface.GetTextSize(vehname .. "...") > ymax do
					vehname = string.sub(vehname, 1, -2)
				end
				vehname = vehname .. "..."
			end
			
			textnW = surface.GetTextSize(name)
			if textnW > ynmax then
				while surface.GetTextSize(name .. "...") > ynmax do
					name = string.sub(name, 1, -2)
				end
				name = name .. "..."
			end
				
            local entry = {
                y = yPos,
                leftText = tostring(i),
                middleText = name,
				carText = vehname or "---",
                rightText = UV_FormatRaceEndTime(totalTime),
                revealTime = revealTime
            }
            
            table.insert(displaySequence, entry)
        end
        
        local flashDuration = 0.2 -- total time for flash animation
        local flashStartTime = nil
        local allRevealed = false
        
        local closing = false
        local closeStartTime = 0
                                
		if closing then gui.EnableScreenClicker(false) end
		
        local totalRevealTime = (revealInterval * entriesToShow) + flashDuration
        
        function ResultPanel:OnMouseWheeled(delta)
            if delta > 0 then
                scrollOffset = math.max(scrollOffset - 1, 0)
            elseif delta < 0 then
                local maxOffset = math.max(0, #displaySequence - entriesToShow)
                scrollOffset = math.min(scrollOffset + 1, maxOffset)
            end
            
            return true -- prevent further processing
        end
        
        ResultPanel.Paint = function(self, w, h)
            local curTime = CurTime()
            
            -- Check if all rows revealed
            local allEntriesRevealed = true
            for i, entry in ipairs(displaySequence) do
                if curTime < entry.revealTime then
                    allEntriesRevealed = false
                    break
                end
            end
            
            if allEntriesRevealed and not flashStartTime then
                flashStartTime = curTime
            end
            
            local flashProgress = flashStartTime and math.min((curTime - flashStartTime) / flashDuration, 1) or 0
            
            local textAlpha = 0
            local tabAlpha = 50
            
            if flashStartTime then
                if not closing then
                    textAlpha = Lerp(flashProgress, 0, 255)
                    if flashProgress < 0.5 then
                        tabAlpha = Lerp(flashProgress / 0.5, 0, 255)
                    else
                        tabAlpha = Lerp((flashProgress - 0.5) / 0.5, 255, 50)
                    end
                else
                    -- Reverse flash alpha during closing
                    textAlpha = Lerp(flashProgress, 255, 0)
                    if flashProgress < 0.5 then
                        tabAlpha = Lerp(flashProgress / 0.5, 50, 255)
                    else
                        tabAlpha = Lerp((flashProgress - 0.5) / 0.5, 255, 0)
                    end
                end
            end
            local blackBgAlpha = 0
            
            if not closing then
                -- Opening: ramp up to 235 in 0.05s
                local fadeInDuration = 0.05
                local elapsedSinceStart = curTime - timestart
                blackBgAlpha = Lerp(math.min(elapsedSinceStart / fadeInDuration, 1), 0, 235)
            else
                -- Closing: hold 235 until last 0.1s, then fade to 0
                local fadeOutDuration = 0.1
                local timeSinceCloseStart = curTime - closeStartTime
                local timeLeft = totalRevealTime - timeSinceCloseStart
                
                if timeLeft <= fadeOutDuration then
                    -- fade out from 235 to 0 in last 0.1 seconds
                    blackBgAlpha = Lerp(timeLeft / fadeOutDuration, 0, 235)
                else
                    blackBgAlpha = 235
                end
            end
            
            -- Main black background
            surface.SetDrawColor(0, 0, 0, blackBgAlpha)
            surface.DrawRect(0, 0, w, h)
            
            -- Draw rows and alternating backgrounds fully visible when revealed
            local xLeft = w * 0.2125
            local xRight = w * 0.7875
            local hStep = h * 0.04
            local elapsed, revealProgress, flashProgress
            local entriesCount = #displaySequence
            
            if closing then
                elapsed = curTime - closeStartTime
                revealProgress = math.Clamp(1 - (elapsed / totalRevealTime), 0, 1)
                flashProgress = math.Clamp(revealProgress * (flashDuration / totalRevealTime), 0, 1)
                
                -- Limit entriesToShow to the scrolling window
                entriesToShow = math.min(math.ceil(entriesCount * revealProgress), 13)
            else
                elapsed = curTime - revealStartTime
                revealProgress = math.Clamp(elapsed / (totalRevealTime - flashDuration), 0, 1)
                flashProgress = flashStartTime and math.min((curTime - flashStartTime) / flashDuration, 1) or 0
                
                -- Limit entriesToShow to the scrolling window
                entriesToShow = math.min(math.floor(entriesCount * revealProgress), 13)
            end
            
            local startIndex = scrollOffset + 1
            local endIndex = math.min(startIndex + entriesToShow - 1, #displaySequence)
            
            for i = startIndex, endIndex do
                local entry = displaySequence[i]
                local localIndex = i - startIndex + 1
                local yPos = (localIndex % 2 == 1)
                and h1 + math.floor(localIndex / 2) * h * 0.08
                or h2 + math.floor((localIndex - 1) / 2) * h * 0.08
                
                if localIndex % 2 == 0 then
                    surface.SetDrawColor(0, 0, 0, 50)
                else
                    surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, 25)
                end
                surface.DrawRect(w * 0.2, yPos, w * 0.6, hStep)
                
                if entry.leftText then
                    draw.SimpleText(entry.leftText, "UVFont5UI", xLeft, yPos, UVColors.MW_Racer, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
                if entry.middleText then
                    draw.SimpleText(entry.middleText, "UVFont5UI", xMiddle, yPos, UVColors.MW_Racer, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
                if entry.carText then
                    draw.SimpleText(entry.carText, "UVFont5UI", xCar, yPos, UVColors.MW_Racer, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
                if entry.rightText then
                    draw.SimpleText(entry.rightText, "UVFont5UI", xRight, yPos, UVColors.MW_Racer, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                end
            end
            
            if flashStartTime then
                -- Top tab background flash
                surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, tabAlpha)
                surface.DrawRect(w * 0.2, h * 0.1225, w * 0.6, h * 0.075)
                
                -- Upper-middle background flash (same alpha as tabs)
                surface.SetMaterial(UVMaterials['BACKGROUND_BIGGER'])
                surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, tabAlpha)
                surface.DrawTexturedRect(w * 0.2, h * 0.1975, w * 0.6, h * 0.05)
                
                -- Bottom tab background flash
                surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, tabAlpha)
                surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
                surface.DrawTexturedRect(w * 0.2, h * 0.7725, w * 0.6, h * 0.04)
                
                -- Icon and texts fade in (stay full alpha after flash)
                DrawIcon(UVMaterials['RESULTRACE'], w * 0.225, h * 0.1575, .07, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha))
                draw.DrawText(UVString("uv.results.standings"), "UVFont5", w * 0.25, h * 0.1375, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_LEFT)

                draw.DrawText(UVString("uv.results.race.pos"), "UVFont5UI", xLeft, h * 0.2, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_LEFT)
                draw.DrawText(UVString("uv.results.race.name"), "UVFont5UI", xMiddle, h * 0.2, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_LEFT)
                draw.DrawText(UVString("uv.results.race.car"), "UVFont5UI", xCar, h * 0.2, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_LEFT)
                draw.DrawText(UVString("uv.results.race.time"), "UVFont5UI", xRight, h * 0.2, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_RIGHT)
                
                local blink = 255 * math.abs(math.sin(RealTime() * 8))
                
                if scrollOffset > 0 then
                    draw.SimpleText("▲", "UVFont5UI", w * 0.5, h * 0.2175, Color(255,255,255,blink), TEXT_ALIGN_CENTER)
                end
                
                if scrollOffset < #displaySequence - entriesToShow then
                    draw.SimpleText("▼", "UVFont5UI", w * 0.5, h * 0.7625, Color(255,255,255,blink), TEXT_ALIGN_CENTER)
                end

				local conttext = markup.Parse("<color="..debriefcolor.r..","..debriefcolor.g..","..debriefcolor.b.."><font=UVFont5UI>" .. UVReplaceKeybinds("[+jump] " .. UVString("uv.results.continue"), "Big") .. "</font></color>")

				surface.SetAlphaMultiplier(textAlpha / 255)
				conttext:Draw(w * 0.205, h * 0.77, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				surface.SetAlphaMultiplier(1)
            end
            
            -- Show/Hide OK button with fade
            if flashStartTime then
                if textAlpha > 0 then
                    OK:SetEnabled(true)
                end
            else
                OK:SetEnabled(false)
            end
            
            -- Time since panel was created
            local elapsed = CurTime() - timestart
            
            -- Only start auto-close countdown after reveal + flash
            local autoCloseStartDelay = totalRevealTime
            local autoCloseDuration = 30  -- 30 seconds countdown
            
            local autoCloseTimer = 0
            local autoCloseRemaining = autoCloseDuration
            
            if elapsed > autoCloseStartDelay then
                autoCloseTimer = elapsed - autoCloseStartDelay
                autoCloseRemaining = math.max(0, autoCloseDuration - autoCloseTimer)
                
				draw.DrawText(string.format(UVString("uv.results.autoclose"), math.ceil(autoCloseRemaining)), "UVFont5", w * 0.79, h * 0.1375, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_RIGHT)
            
				if autoCloseRemaining <= 0 then
					hook.Remove("CreateMove", "JumpKeyCloseResults")
					if not closing then
						gui.EnableScreenClicker(false)
						surface.PlaySound( "uvui/mw/FE_COMMON_MB [4].wav" )
						closing = true
						closeStartTime = CurTime()
					end
				end
			else
				-- Before auto-close timer starts, show the text but no countdown
				draw.DrawText(string.format(UVString("uv.results.autoclose"), autoCloseDuration), "UVFont5", w * 0.79, h * 0.1375, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_RIGHT)
			end
		if closing then
			local elapsed = curTime - closeStartTime
			if elapsed >= totalRevealTime then
				hook.Remove("CreateMove", "JumpKeyCloseResults")
				if IsValid(ResultPanel) then
					ResultPanel:Close()
				end
			end
		end
	end

		function OK:DoClick()
			surface.PlaySound( "uvui/mw/FE_COMMON_MB [4].wav" )
			if not closing then
				gui.EnableScreenClicker(false)
				closing = true
				closeStartTime = CurTime()
			end
		end

		hook.Add("CreateMove", "JumpKeyCloseResults", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end

			if ply:KeyPressed(IN_JUMP) then
				if IsValid(ResultPanel) and not closing then
					gui.EnableScreenClicker(false)
					hook.Remove("CreateMove", "JumpKeyCloseResults")
						
					surface.PlaySound( "uvui/mw/FE_COMMON_MB [4].wav" )
					closing = true
					closeStartTime = CurTime()
				end
			end
		end)
	end,
	onRaceEnd = function( sortedRacers, stringArray )
		local triggerTime = CurTime()
		local duration = 10
		local glidetext = UVReplaceKeybinds( string.format( UVString("uv.race.finished.viewstats"),"[key:unitvehicle_keybind_raceresults]") )

		local glideicon = "unitvehicles/icons/INGAME_ICON_LEADERBOARD.png"
		
		-----------------------------------------

		if Glide then
			if not istable(sortedRacers) or #sortedRacers == 0 then
				glidetext = UVString("uv.race.finished.statserror")
				glideicon = "unitvehicles/icons/GENERIC_ALERT.png"
			end
				Glide.Notify({
					text = glidetext,
					lifetime = duration,
					immediate = true,
					icon = glideicon,
				}) 
		end
			
		hook.Add( "Think", "RaceResultDisplay", function()
			if CurTime() - triggerTime > duration then
				hook.Remove( 'Think', 'RaceResultDisplay' )
				return
			end
			
			if input.IsKeyDown( UVKeybindShowRaceResults:GetInt() ) and not gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
				hook.Remove( 'Think', 'RaceResultDisplay' )
				if UVMenu.CurrentMenu and IsValid(UVMenu.CurrentMenu) then
					UVMenu.CloseCurrentMenu()
					timer.Simple(0.5, function()
						UV_UI.racing.mostwanted.events.ShowResults(sortedRacers)
					end)
					return
				end
				UV_UI.racing.mostwanted.events.ShowResults(sortedRacers)
			end
		end)
	end,
	onLapComplete = function( participant, new_lap, old_lap, lap_time, lap_time_cur, is_local_player, is_global_best, lap_final, local_finished, user_finished, suppress_lap_ui )
		local name = UVHUDRaceInfo and UVHUDRaceInfo.Participants[participant] and UVHUDRaceInfo.Participants[participant].Name or "Unknown"
		
		local cps = GetGlobalInt("uvrace_checkpoints")
		local participant_count = UVHUDRaceInfo.Participants and table.Count(UVHUDRaceInfo.Participants) or 0

		local finishtext = (participant_count > 1 and cps > 1) and 
		UVString("uv.race.finished") .. "\n" .. string.format( UVString("uv.race.finishspot"), UVString("uv.race.pos.num." .. UVHUDRaceCurrentPos) )
		or UVString("uv.race.finished")

		if local_finished then 
			UV_UI.racing.mostwanted.events.CenterNotification({
				text = finishtext,
				textNoFall = true,
				noIcon = true,
				-- immediate = true,
			})
			return
		end
	
		if suppress_lap_ui then return end

		if is_global_best then
			UV_UI.racing.mostwanted.states.LapCompleteText = string.format(UVString("uv.race.fastest.laptime"), name, Carbon_FormatRaceTime( lap_time ) )
		else
			if is_local_player then
				UV_UI.racing.mostwanted.states.LapCompleteText = string.format(UVString("uv.race.laptime"), Carbon_FormatRaceTime( lap_time ) )
			else
				return
			end
		end
		UV_UI.racing.mostwanted.events.CenterNotification({
			text = UV_UI.racing.mostwanted.states.LapCompleteText,
			iconMaterial = UVMaterials['CLOCK'],
		})
	end,
	onParticipantDisqualified = function(data)
		local participant = data.Participant
		local is_local_player = data.is_local_player
		
		local info = UVHUDRaceInfo.Participants[participant]
		local name = info and info.Name or "Unknown"

		if not info then return end

		local disqtext = string.format(UVString("uv.race.wrecked"), name)
		if is_local_player then disqtext = UVString("uv.chase.wrecked") end

		UV_UI.racing.mostwanted.events.CenterNotification({
			text = disqtext,
			textNoFall = true,
			noIcon = true,
			immediate = is_local_player and true or false,
		})
	end,
	onRaceStartTimer = function(data)
		local starttime = data.starttime

		local countdownTexts = {
			[4] = 3,
			[3] = 2,
			[2] = 1,
			[1] = UVString("uv.race.go")
		}

		local textToShow = countdownTexts[starttime]
		if not textToShow then return end

		-- Determine extra options for the "GO!" notification
		local extraOpts = {}
		if starttime == 1 then
			extraOpts.textFlyRightNoFall = true
		end

		-- Call the notification function once
		UV_UI.racing.mostwanted.events.CenterNotification(
			table.Merge({
				text = textToShow,
				textCol = Color(0, 255, 0),
				textFont = "UVFont5WeightShadow",
				textFlyRight = true,
				noIcon = true,
				immediate = true
			}, extraOpts)
		)
	end,
	onLapSplit = function(participant, checkpoint, is_local_player, numParticipants)
		if not is_local_player then return end
		if numParticipants <= 1 then return end

		-- Use the participant vehicle directly
		local my_vehicle = participant
		if not IsValid(my_vehicle) then return end

		-- Pull cached diffs from general racing HUD
		local cached = UV_UI.racing.general.SplitDiffCache and UV_UI.racing.general.SplitDiffCache[my_vehicle]
		local aheadDiff, behindDiff = "N/A", "N/A"

		if cached then
			aheadDiff = cached.Ahead or "N/A"
			behindDiff = cached.Behind or "N/A"
		end

		-- CenterNoti itself
		local splittime = "--:--.---"
		local showahead = false
		local noticol = Color(0, 255, 0)

		if aheadDiff == "N/A" and behindDiff ~= "N/A" then -- 1st place
			splittime = "+ " .. behindDiff
		elseif aheadDiff ~= "N/A" then -- 2nd place or below
			splittime = "- " .. aheadDiff
			showahead = true
			noticol = Color(200, 75, 75)
		end
		
		local splittext = string.format( UVString("uv.race.splittime"), splittime )

		UV_UI.racing.mostwanted.events.CenterNotification2({
			text = splittext,
			textCol = noticol,
		})
	end,
	onWrongWay = function(timestamp, isWrongWay)
		if isWrongWay then
			UV_UI.racing.mostwanted.events.CenterNotification({
				text = UVString("uv.race.wrongway"),
				textNoFall = true,
				noIcon = true,
				immediate = true,
			})
		end
	end,
}

UV_UI.pursuit.mostwanted.events = {
    notifState = {},
    onUnitTakedown = function( unitType, name, bounty, bountyCombo, isPlayer )
		local uname = isPlayer and UVString( unitType ) or name -- Fallback
		
		if GetConVar("unitvehicle_vehiclenametakedown"):GetBool() then
			uname = name and string.Trim(UVString(name), "#") or nil
		end
		
		UV_UI.racing.mostwanted.events.CenterNotification({
			text = string.format( UVString( "uv.hud.mw.takedown" ), uname, bounty, bountyCombo ),
			immediate = true,
		})
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
		local cnt = string.format(UVString("uv.hud.racer.arrested"), racer, UVString(cop))
		
		if lp then
			cnt = UVString("uv.chase.busted")
		end

		UV_UI.racing.mostwanted.events.CenterNotification({
			text = cnt,
			textNoFall = true,
			noIcon = true,
			immediate = lp and true or false,
		})
	end,
    ShowDebrief = function(params) -- Most Wanted
        if UVHUDDisplayRacing then return end
        
        local debriefdata = params.dataTable or escapedtable
        local debriefcolor = params.color or Color(255, 183, 61)
        local debrieftextcolor = params.textcolor or UVColors.MW_Racer
        local debrieficon = params.iconMaterial or UVMaterials['RESULTCOP']
        local debrieftitletext = params.titleText or "Title Text"
		local debriefunitspawn = params.spawnAsUnit or false
        local finescost = string.Comma( params.finesdue or 0 )
        local infractiondata = params.infractionTable or false
        local unservedinfractions = 0

		if infractiondata then
			local count = 0
			for k, v in pairs(infractiondata) do
				count = count + 1
			end
			unservedinfractions = count
		end

		local w = UV_GetW()
		local h = UV_GetH()
        
        --------------------------------------
        
        local time = UVDisplayTime(UVTimerProgress)
        local unit = debriefdata["Unit"] or "Unknown"
        local deploys = debriefdata["Deploys"]
        local roadblocksdodged = debriefdata["Roadblocks"]
        local spikestripsdodged = debriefdata["Spikestrips"]
        local bounty = debriefdata["Bounty"] or 0
        local tags = debriefdata["Tags"] or 0
        local wrecks = debriefdata["Wrecks"] or 0
        local suspects = UVHUDWantedSuspectsNumber or 0
        
        local ResultPanel = vgui.Create("DFrame")
        local OK = vgui.Create("DButton")
        
        ResultPanel:Add(OK)
        ResultPanel:SetSize(w, h)
        ResultPanel:SetBackgroundBlur(true)
        ResultPanel:ShowCloseButton(false)
        ResultPanel:Center()
        ResultPanel:SetTitle("")
        ResultPanel:SetDraggable(false)
        ResultPanel:SetKeyboardInputEnabled(false)
		
        -- ResultPanel:MakePopup()
		ResultPanel:SetVisible(true)
		ResultPanel:MoveToFront()
		ResultPanel:RequestFocus()
		gui.EnableScreenClicker(true)

        OK:SetText("")
        OK:SetPos(w*0.2, h*0.7725)
        OK:SetSize(w*0.6, h*0.04)
		OK.Paint = function() end
        
        local timestart = CurTime()

        local revealStartTime = CurTime()
        local displaySequence = {}
		
		local isRebuilding = false
        
        -- Data and labels
		local showingInfractions = false
		local infractionKeys = {
			"speed",
			"veryspeed",
			"reckless",
			"rampolice",
			"ram",
			"property",
			"resist",
			"offroad",
			"streetrace",
			"resource",
			"endanger",
			"homicide"
		}
		
		local function BuildInfoLabels()
			local labels = {}

			if not showingInfractions then
				-- ORIGINAL VIEW
				labels = {
					{ label = UVString("uv.results.chase.bounty"), value = bounty },
					{ label = UVString("uv.results.chase.time"), value = time },
					{ label = UVString("uv.results.chase.units.deployed"), value = deploys },
					{ label = UVString("uv.results.chase.units.damaged"), value = tags },
					{ label = UVString("uv.results.chase.units.destroyed"), value = wrecks },
					{ label = UVString("uv.results.chase.dodged.blocks"), value = roadblocksdodged },
					{ label = UVString("uv.results.chase.dodged.spikes"), value = spikestripsdodged }
				}

				if infractiondata then
					table.insert(labels, {
						label = UVString("uv.results.chase.unserved"),
						value = unservedinfractions
					})
				end
				
				if params.finesdue then
					table.insert(labels, { label = UVString("uv.results.chase.fines"), value = "$" .. finescost } )
				end
			else
				-- INFRACTION VIEW
				if infractiondata then
					for _, key in ipairs(infractionKeys) do
						local value = infractiondata[key] or 0

						table.insert(labels, {
							label = UVString("uv.infraction." .. key),
							value = value
						})
					end
				end
			end

			return labels
		end
		
		local infoLabels = BuildInfoLabels()

        -- Build the sequence including empty tabs to keep layout intact
        local h1, h2 = h*0.2475, h*0.2875
        local xLeft = w * 0.205
        local xRight = w * 0.795
        local revealInterval = 0.033
        
        for i = 1, 13 do -- Total of 13 tabs
            local revealTime = revealStartTime + (i - 1) * revealInterval
            
            -- Alternate h1 and h2 for staggered layout
            local yPos = (i % 2 == 1) and h1 + math.floor(i / 2) * h * 0.08 or h2 + math.floor((i - 1) / 2) * h * 0.08
            local entry = {
                y = yPos,
                leftText = infoLabels[i] and infoLabels[i].label or nil,
                rightText = infoLabels[i] and tostring(infoLabels[i].value) or nil,
                revealTime = revealTime
            }
            table.insert(displaySequence, entry)
        end
        
        local flashDuration = 0.2 -- total time for flash animation
        local flashStartTime = nil
        local allRevealed = false
        
        local closing = false
        local closeStartTime = 0

        local totalRevealTime = (revealInterval * 13) + flashDuration

		local tipstring = params.faction == "Racer" and UV.Tips.Racer or UV.Tips.Units
		local randomTipText = tipstring[math.random(1, #tipstring)]

		local function RebuildDisplay()
			if isRebuilding then return end
			isRebuilding = true

			displaySequence = {}
			local infoLabels = BuildInfoLabels()

			for i = 1, 13 do
				local revealTime = CurTime() + (i - 1) * revealInterval
				
				local yPos = (i % 2 == 1)
					and h1 + math.floor(i / 2) * h * 0.08
					or h2 + math.floor((i - 1) / 2) * h * 0.08

				local entry = {
					y = yPos,
					leftText = infoLabels[i] and infoLabels[i].label or nil,
					rightText = infoLabels[i] and tostring(infoLabels[i].value) or nil,
					revealTime = revealTime
				}

				table.insert(displaySequence, entry)
			end

			revealStartTime = CurTime()
			flashStartTime = nil
		end
		
        ResultPanel.Paint = function(self, w, h)
            local curTime = CurTime()
            
            -- Check if all rows revealed
            local allEntriesRevealed = true
            for i, entry in ipairs(displaySequence) do
                if curTime < entry.revealTime then
                    allEntriesRevealed = false
                    break
                end
            end
            
			if allEntriesRevealed and not flashStartTime then
				flashStartTime = curTime
				isRebuilding = false
			end
            
            local flashProgress = flashStartTime and math.min((curTime - flashStartTime) / flashDuration, 1) or 0
            
            local textAlpha = 0
            local tabAlpha = 50
            
            if flashStartTime then
                if not closing then
                    textAlpha = Lerp(flashProgress, 0, 255)
                    if flashProgress < 0.5 then
                        tabAlpha = Lerp(flashProgress / 0.5, 0, 255)
                    else
                        tabAlpha = Lerp((flashProgress - 0.5) / 0.5, 255, 50)
                    end
                else
                    -- Reverse flash alpha during closing
                    textAlpha = Lerp(flashProgress, 255, 0)
                    if flashProgress < 0.5 then
                        tabAlpha = Lerp(flashProgress / 0.5, 50, 255)
                    else
                        tabAlpha = Lerp((flashProgress - 0.5) / 0.5, 255, 0)
                    end
                end
            end
            local blackBgAlpha = 0
            
            if not closing then
                -- Opening: ramp up to 235 in 0.05s
                local fadeInDuration = 0.05
                local elapsedSinceStart = curTime - timestart
                blackBgAlpha = Lerp(math.min(elapsedSinceStart / fadeInDuration, 1), 0, 235)
            else
                -- Closing: hold 235 until last 0.1s, then fade to 0
                local fadeOutDuration = 0.1
                local timeSinceCloseStart = curTime - closeStartTime
                local timeLeft = totalRevealTime - timeSinceCloseStart
                
                if timeLeft <= fadeOutDuration then
                    -- fade out from 235 to 0 in last 0.1 seconds
                    blackBgAlpha = Lerp(timeLeft / fadeOutDuration, 0, 235)
                else
                    blackBgAlpha = 235
                end
            end
            
            -- Main black background
            surface.SetDrawColor(0, 0, 0, blackBgAlpha)
            surface.DrawRect(0, 0, w, h)
            
            -- Draw rows and alternating backgrounds fully visible when revealed
            local xLeft = w * 0.2125
            local xRight = w * 0.7875
            local hStep = h * 0.04
            local elapsed, revealProgress, flashProgress, entriesToShow
            local entriesCount = #displaySequence
            
            if closing then
                elapsed = curTime - closeStartTime
                revealProgress = math.Clamp(1 - (elapsed / totalRevealTime), 0, 1)
                flashProgress = math.Clamp(revealProgress * (flashDuration / totalRevealTime), 0, 1)
                
                -- Calculate how many entries should still be visible (from the start)
                entriesToShow = math.ceil(entriesCount * revealProgress)
            else
                elapsed = curTime - revealStartTime
                revealProgress = math.Clamp(elapsed / (totalRevealTime - flashDuration), 0, 1)
                flashProgress = flashStartTime and math.min((curTime - flashStartTime) / flashDuration, 1) or 0
                
                entriesToShow = math.floor(entriesCount * revealProgress)
            end
            
            for i = 1, entriesCount do
                local drawEntry = false
                
                if closing then
                    -- When closing, show only the first 'entriesToShow' entries (reverse reveal)
                    drawEntry = i <= entriesToShow
                else
                    -- When opening, show up to entriesToShow
                    drawEntry = i <= entriesToShow
                end
                
                if drawEntry then
                    local entry = displaySequence[i]
                    local isEven = i % 2 == 0
                    
                    if isEven then
                        surface.SetDrawColor(0, 0, 0, 50) -- black background
                    else
                        surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, 25) -- orange background
                    end
                    surface.DrawRect(w * 0.2, entry.y, w * 0.6, hStep)
                    
                    if entry.leftText then
                        draw.SimpleText(entry.leftText, "UVFont5UI", xLeft, entry.y, Color(debrieftextcolor.r, debrieftextcolor.g, debrieftextcolor.b), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    end
                    if entry.rightText then
                        draw.SimpleText(entry.rightText, "UVFont5UI", xRight, entry.y, Color(debrieftextcolor.r, debrieftextcolor.g, debrieftextcolor.b), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                    end
                end
            end
            
            if flashStartTime then
                -- Top tab background flash
                surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, tabAlpha)
                surface.DrawRect(w * 0.2, h * 0.1225, w * 0.6, h * 0.075)
                
                -- Upper-middle background flash (same alpha as tabs)
                surface.SetMaterial(UVMaterials['BACKGROUND_BIGGER'])
                surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, tabAlpha)
                surface.DrawTexturedRect(w * 0.2, h * 0.1975, w * 0.6, h * 0.05)
                
                -- Bottom tab background flash
                surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, tabAlpha)
                surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
                surface.DrawTexturedRect(w * 0.2, h * 0.7725, w * 0.6, h * 0.04)
                
                -- Icon and texts fade in (stay full alpha after flash)
                DrawIcon(debrieficon, w * 0.225, h * 0.1575, .05, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha))
                draw.DrawText(UVString(showingInfractions and "uv.results.infractions" or "uv.results.pursuit"), "UVFont5", w * 0.25, h * 0.1375, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_LEFT)
                
                draw.DrawText(debrieftitletext, "UVFont5", w * 0.5, h * 0.2, Color(255, 255, 255, textAlpha), TEXT_ALIGN_CENTER)

				local conttexts = "<color="..debriefcolor.r..","..debriefcolor.g..","..debriefcolor.b.."><font=UVFont5UI>"
				local conttexte = "</font></color>"
				
				local conttext = conttexts .. UVReplaceKeybinds("[+jump] " .. UVString("uv.results.continue"), "Big") .. conttexte
				
				-- Infractions present
				if infractiondata then
					local infratext = "uv.results.infractions.lower"
					
					if showingInfractions then
						infratext = "uv.results.pursuit.lower"
					end
				
					conttext = conttext .. "     " .. conttexts .. UVReplaceKeybinds("[+speed] " .. UVString(infratext), "Big") .. conttexte
				end

				-- Spawn as a Unit
				if debriefunitspawn and (UVHUDWantedSuspects and #UVHUDWantedSuspects > 0) then
					conttext = conttext .. "     " .. conttexts .. UVReplaceKeybinds("[+reload] " .. UVString("uv.pm.spawnas"), "Big") .. conttexte
				end

				local tiptext = "<color="..debriefcolor.r..","..debriefcolor.g..","..debriefcolor.b.."><font=UVMostWantedLeaderboardFont>" .. UVReplaceKeybinds( string.format(UVString("uv.tip"), UVString(randomTipText) ) ) .. "</font></color>"

				surface.SetAlphaMultiplier(textAlpha / 255)
				markup.Parse(conttext):Draw(w * 0.205, h * 0.77, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				markup.Parse(tiptext, w * 0.59):Draw(w * 0.205, h * 0.815, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				surface.SetAlphaMultiplier(1)

            end
            
            -- Show/Hide OK button with fade
            if flashStartTime then
                if textAlpha > 0 then
                    OK:SetEnabled(true)
                end
            else
                OK:SetEnabled(false)
            end
            
            -- Time since panel was created
            local elapsed = CurTime() - timestart
            
            -- Only start auto-close countdown after reveal + flash
            local autoCloseStartDelay = totalRevealTime
            local autoCloseDuration = 30  -- 30 seconds countdown
            
            local autoCloseTimer = 0
            local autoCloseRemaining = autoCloseDuration
            
            if elapsed > autoCloseStartDelay then
                autoCloseTimer = elapsed - autoCloseStartDelay
                autoCloseRemaining = math.max(0, autoCloseDuration - autoCloseTimer)
                
				draw.DrawText(string.format(UVString("uv.results.autoclose"), math.ceil(autoCloseRemaining)), "UVFont5", w * 0.79, h * 0.1375, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_RIGHT)
			
				if autoCloseRemaining <= 0 then
					hook.Remove("CreateMove", "JumpKeyCloseDebrief")
					hook.Remove("CreateMove", "ReloadKeyCloseDebrief")
					surface.PlaySound( "uvui/mw/FE_COMMON_MB [4].wav" )
					gui.EnableScreenClicker(false)
					if not closing then
						closing = true
						closeStartTime = CurTime()
					end
				end
			else
				-- Before auto-close timer starts, show the text but no countdown
				draw.DrawText(string.format(UVString("uv.results.autoclose"), autoCloseDuration), "UVFont5", w * 0.79, h * 0.1375, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_RIGHT)
		end
		if closing then
			local elapsed = curTime - closeStartTime
			if elapsed >= totalRevealTime then
				hook.Remove("CreateMove", "JumpKeyCloseDebrief")
				hook.Remove("CreateMove", "ReloadKeyCloseDebrief")
				if IsValid(ResultPanel) then
					ResultPanel:Close()
				end
			end
		end
	end

		function OK:DoClick()
			surface.PlaySound( "uvui/mw/FE_COMMON_MB [4].wav" )
			if not closing then
				gui.EnableScreenClicker(false)
				hook.Remove("CreateMove", "JumpKeyCloseDebrief")
				hook.Remove("CreateMove", "ReloadKeyCloseDebrief")
				closing = true
				closeStartTime = CurTime()
			end
		end

		hook.Add("CreateMove", "JumpKeyCloseDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end

			if ply:KeyPressed(IN_JUMP) then
				if IsValid(ResultPanel) and not closing then
					gui.EnableScreenClicker(false)
					hook.Remove("CreateMove", "JumpKeyCloseDebrief")
					hook.Remove("CreateMove", "ReloadKeyCloseDebrief")
					hook.Remove("CreateMove", "UseKeyToggleInfractions")

					surface.PlaySound( "uvui/mw/FE_COMMON_MB [4].wav" )
					closing = true
					closeStartTime = CurTime()
				end
			end
		end)
		
		hook.Add("CreateMove", "UseKeyToggleInfractions", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			if isRebuilding then return end

			if ply:KeyPressed(IN_SPEED) then
				if IsValid(ResultPanel) and not closing and infractiondata then
					showingInfractions = not showingInfractions

					surface.PlaySound("uvui/mw/FE_COMMON_MB [5].wav")

					RebuildDisplay()
				end
			end
		end)

		if debriefunitspawn and (UVHUDWantedSuspects and #UVHUDWantedSuspects > 0) then
			hook.Add("CreateMove", "ReloadKeyCloseDebrief", function()
				local ply = LocalPlayer()
				if not IsValid(ply) then return end

				if ply:KeyPressed(IN_RELOAD) then
					if IsValid(ResultPanel) and not closing then
						gui.EnableScreenClicker(false)
						hook.Remove("CreateMove", "JumpKeyCloseDebrief")
						hook.Remove("CreateMove", "ReloadKeyCloseDebrief")
						hook.Remove("CreateMove", "UseKeyToggleInfractions")
						
						surface.PlaySound( "uvui/mw/FE_COMMON_MB [4].wav" )
						closing = true
						closeStartTime = CurTime()

						net.Start("UVHUDRespawnInUVGetInfo")
						net.SendToServer()
					end
				end
			end)
		end
	end,
	onRacerEscapedDebrief = function(escapedtable, infractionstable, finesdue)
		local params = {
			faction = "Racer",
			dataTable = escapedtable,
			infractionTable = infractionstable,
			finesdue = finesdue,
			color = Color(255, 183, 61),
			iconMaterial = UVMaterials['RESULTCOP'],
			titleText = UVString("uv.results.escapedfrom"),
		}
		UV_UI.pursuit.mostwanted.events.ShowDebrief(params)
	end,
	onRacerBustedDebrief = function(bustedtable, infractionstable, finesdue)
		local params = {
			faction = "Racer",
			dataTable = bustedtable,
			infractionTable = infractionstable,
			finesdue = finesdue,
			color = Color(255, 183, 61),
			iconMaterial = UVMaterials['RESULTCOP'],
			titleText = string.format( UVString("uv.results.bustedby"), UVString( bustedtable["Unit"] ) ),
			spawnAsUnit = true,
		}
		UV_UI.pursuit.mostwanted.events.ShowDebrief(params)
	end,
	onCopBustedDebrief = function(bustedtable)
		local params = {
			dataTable = bustedtable,
			color = Color(61, 183, 255),
			textcolor = Color(142, 221, 255, 107),
			iconMaterial = UVMaterials['RESULTCOP'],
			titleText = string.format( UVString("uv.results.suspects.busted"), bustedtable["Unit"] ),
		}
		UV_UI.pursuit.mostwanted.events.ShowDebrief(params)
	end,
	onCopEscapedDebrief = function(escapedtable)
		local params = {
			dataTable = escapedtable,
			color = Color(61, 183, 255),
			textcolor = Color(142, 221, 255, 107),
			iconMaterial = UVMaterials['RESULTCOP'],
			titleText = string.format(UVString("uv.results.suspects.escaped.num"), UVHUDWantedSuspectsNumber)
		}
		UV_UI.pursuit.mostwanted.events.ShowDebrief(params)
	end,
	onPullOverRequest = function(...)
		UV_UI.racing.mostwanted.events.CenterNotification({
			text = UVHUDCopMode and UVString("uv.hud.fine.pullover.unit") or UVString("uv.hud.fine.pullover"),
			textNoFall = true,
			noIcon = true,
			immediate = true,
		})
	end,
	onFined = function( finenr, finesdue )
		UV_UI.racing.mostwanted.events.CenterNotification({
			text = string.format( UVHUDCopMode and UVString("uv.hud.fine.fined.unit") or UVString("uv.hud.fine.fined"), finenr),
			textNoFall = true,
			noIcon = true,
			immediate = true,
		})
		timer.Simple(3, function()
			UV_UI.racing.mostwanted.events.CenterNotification({
				text = string.format( UVString("uv.hud.fine.cost"), finesdue),
				textNoFall = true,
				noIcon = true,
				immediate = true,
			})
		end)
	end,
	InfractionNoti = function()
		local state = UV_UI.pursuit.mostwanted.states

		local baseX = UV_UI.X(ScrW() * 0.1)
		local baseY = ScrH() * 0.125

		local squareSizeMin = ScrW() * 0.01
		local squareSizeMax = UV_UI.W(ScrW() * 0.125)
		
		local notitimer = 3

		hook.Add("HUDPaint", "UV_INFRACTIONS_HUD", function()
			local now = CurTime()

			-- Animated sections
			local timeSinceLast = now - state.lastInfractionTime
			local expandTime = 0.25

			local t = math.Clamp((now - (state.headerStart or now)) / expandTime, 0, 1)
			local fadeOut = math.Clamp((timeSinceLast - notitimer) / 0.3, 0, 1)

			-- local size = Lerp(t, squareSizeMin, squareSizeMax)
			local size = squareSizeMax
			local alpha = Lerp(t, 0, 255) * (1 - fadeOut)

			-- Main BG
			surface.SetDrawColor(223, 184, 127, alpha * 0.75)
			surface.SetMaterial(UVMaterials["INFRACTIONS_BG"])
			surface.DrawTexturedRectRotated(baseX, baseY, size, size, 0)
			
			-- Rotating circle-thing
			local rot = (RealTime() * 120) % 360

			surface.SetDrawColor(223, 184, 127, alpha)
			surface.SetMaterial(UVMaterials["INFRACTIONS_BG_RING"])
			surface.DrawTexturedRectRotated(baseX, baseY, size, size, rot)
			
			-- Infractions logo and its text
			local logoT = math.Clamp((now - (state.infractionLogoStart or now)) / 0.25, 0, 1)
			local logoScale = Lerp(logoT, 0.5, 1)

			local logoSize = size * 0.5 * logoScale
			local logoAlpha = 255 * logoT * (1 - fadeOut)
			local blink = math.abs(math.sin(RealTime() * 3))

			surface.SetMaterial(UVMaterials["INFRACTIONS_ICON"])
			surface.SetDrawColor(255, 255, 255, logoAlpha)
			surface.DrawTexturedRectRotated(baseX, baseY, logoSize, logoSize, 0)
			
			surface.SetDrawColor(223, 184, 127, logoAlpha * blink)
			surface.DrawTexturedRectRotated(baseX, baseY, logoSize, logoSize, 0)
			
			local numAlpha = 255 * logoT * (1 - fadeOut)

			draw.SimpleTextOutlined( tostring(state.infractionCount or 0), "UVFont5", baseX, baseY, Color(255, 255, 255, numAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, numAlpha) )

			-- Infractions List
			local spacing = ScrH() * 0.015
			local startY = (baseY * 0.15) + size

			for i = #state.infractions, 1, -1 do
				local inf = state.infractions[i]
				local life = now - inf.startTime

				-- Fade in
				local fadeIn = math.Clamp(life / 0.25, 0, 1)

				-- Start removing after 2s
				if life > notitimer and not inf.removing then
					inf.removing = true
					inf.removeStart = now
				end

				local removeT = 0
				if inf.removing then
					removeT = math.Clamp((now - inf.removeStart) / 0.3, 0, 1)
				end

				local alpha = 255 * fadeIn * (1 - removeT)

				-- Movement (down on spawn, up on remove)
				local yOffset = (i - 1) * spacing
				-- yOffset = yOffset + Lerp(1 - fadeIn, -10, 0) -- drop-in
				yOffset = yOffset + Lerp(1 - fadeIn, 20, 0) -- drop-in
				yOffset = yOffset + Lerp(removeT, 0, -20)    -- rise-out

				draw.SimpleTextOutlined( inf.text, "UVMostWantedLeaderboardFont2", baseX, startY + yOffset, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, alpha) )

				-- Remove finished
				if removeT >= 1 then
					table.remove(state.infractions, i)
				end
			end
			
			-- Header
			local headerT = math.Clamp((now - (state.headerStart or now)) / 0.25, 0, 1)
			local headerAlpha = 255 * headerT * (1 - fadeOut)
			
			draw.SimpleTextOutlined( UVString("uv.results.infractions"), "UVMostWantedLeaderboardFont", baseX, baseY + (size * 0.5), Color(223, 184, 127, headerAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, headerAlpha) )

			-- Cleanup
			if timeSinceLast > (notitimer + 0.3) and #state.infractions == 0 then
				hook.Remove("HUDPaint", "UV_INFRACTIONS_HUD")
				state.infractionactive = false
			end
		end)
	end,
	onInfraction = function(text, number)
		local state = UV_UI.pursuit.mostwanted.states

		state.lastInfractionTime = CurTime()

		table.insert(state.infractions, {
			text = text,
			startTime = CurTime(),
			removing = false
		})

		-- Restart animations
		state.headerStart = CurTime()
		state.infractionLogoStart = CurTime()

		-- Track count (use passed number or fallback)
		state.infractionCount = number or (state.infractionCount or 0) + 1

		if not state.infractionactive then
			state.infractionactive = true
			UV_UI.pursuit.mostwanted.events.InfractionNoti()
		end
	end
}

concommand.Add("uv_test_infraction", function() -- DEBUGGING
	local t = {
		"uv.infraction.speed",
		"uv.infraction.veryspeed",
		"uv.infraction.reckless",
		"uv.infraction.rampolice",
		"uv.infraction.ram",
		"uv.infraction.property",
		"uv.infraction.resist",
		"uv.infraction.offroad",
		"uv.infraction.streetrace",
		"uv.infraction.resource",
		"uv.infraction.endanger",
		"uv.infraction.homicide"
	}
	
    UV_UI.pursuit.mostwanted.events.onInfraction(UVString(t[math.random(#t)]))

	UV_UI.racing.mostwanted.events.CenterNotification({
		text = string.format( UVString("uv.hud.fine.fined"), 1),
		textNoFall = true,
		noIcon = true,
		immediate = true,
	})
	timer.Simple(2.5, function()
		UV_UI.racing.mostwanted.events.CenterNotification({
			text = string.format( UVString("uv.hud.fine.cost"), 1000),
			textNoFall = true,
			noIcon = true,
			immediate = true,
		})
	end)
end)

UV_UI.pursuit.mostwanted.scannerConfig = {
	radius = 30,
	innerRadius = 14,
	blipRadius = 8,
	maxRange = 10000,
	maxArc = 130,
	posX = ScrW() * 0.5,
	posY = ScrH() * 0.1,
}

local function ScannerCode(cfg)
    local radius = cfg.radius or 30
    local innerRadius = cfg.innerRadius or 14
    local blipRadius = cfg.blipRadius or 8
    local maxRange = cfg.maxRange or 10000
    local maxArc = cfg.maxArc or 360
    local centerx = cfg.posX
    local centery = cfg.posY

	local localPlayer = cfg.localPlayer
	local w, h = cfg.w, cfg.h

	local enemypos = localPlayer:GetPos()
	local closestDist = math.huge
	local found = false
	local closestPos
	local anyUnits = false

	-- Direction
	local forwardYaw

	if GetConVar("unitvehicle_policescanner_vehicle"):GetBool()
		and IsValid(localPlayer:GetVehicle()) then
		
		forwardYaw = localPlayer:GetVehicle():GetAngles().y + 90
	else
		forwardYaw = EyeAngles().y
	end

	for _, v in pairs(UnitTable) do
		if IsValid(v) then
			anyUnits = true

			local pos = v:GetPos()
			local dist = pos:DistToSqr(enemypos)

			local angleDiff = math.AngleDifference(
				forwardYaw,
				(pos - enemypos):Angle().y
			)

			if math.abs(angleDiff) <= maxArc / 2 then
				if dist < closestDist then
					closestDist = dist
					closestPos = pos
					found = true
				end
			end
		end
	end

	if not anyUnits then return end

	surface.SetMaterial(UVMaterials["SCANNER_BG"])
	surface.SetDrawColor(0,0,0,200)
    surface.DrawTexturedRect(UV_UI.XScaled(w * 0.375), centery - (h * 0.04), UV_UI.W(w * 0.25), h * 0.06)

	surface.SetMaterial(UVMaterials["SCANNER_MIDDLE"])
	surface.SetDrawColor(175,255,100)
    surface.DrawTexturedRect(UV_UI.XScaled(w * 0.48), centery - (h * 0.04), UV_UI.W(w * 0.04), h * 0.06)

	if not found then return end

	local realDistance = math.sqrt(closestDist)

	-- Range limit
	if realDistance > maxRange then return end

	local distanceFrac = math.Clamp(realDistance / maxRange, 0, 1)
	local beepfrequency = math.Clamp(distanceFrac, 0.1, 1)

	local angleDiff = math.AngleDifference(
		forwardYaw,
		(closestPos - enemypos):Angle().y
	)

	local angle = math.rad(angleDiff) + math.pi/2

	surface.SetMaterial(UVMaterials["SCANNER_ARROW"])
	surface.SetDrawColor(175,255,100,255)
	surface.DrawTexturedRectRotated( centerx, centery, UV_UI.W(w * 0.04), UV_UI.W(w * 0.04), -angleDiff )

	-- Beeping
	-- local Beeped = Beeped or nil
	if UVHUDBlipSoundTime < CurTime() then
		UVHUDBlipSoundTime = CurTime() + beepfrequency

		if PursuitSFX:GetBool() then
			surface.PlaySound("ui/pursuit/spotting_blip.wav")
		end

		Beeped = true
		timer.Simple(beepfrequency/2, function()
			Beeped = false
		end)
	end

	local beepcolor = Beeped and Color(175,255,100) or Color(0,0,0,0)

	surface.SetDrawColor(beepcolor)
	surface.SetMaterial(UVMaterials["SCANNER_LEDS"])
    surface.DrawTexturedRect(UV_UI.XScaled(w * 0.3415), centery - (h * 0.04), UV_UI.W(w * 0.1725), h * 0.06)
	
	surface.SetMaterial(UVMaterials["SCANNER_LEDS_INV"])
    surface.DrawTexturedRect(UV_UI.XScaled(w * 0.486), centery - (h * 0.04), UV_UI.W(w * 0.1725), h * 0.06)
end

UV_UI.pursuit.mostwanted.scanner = ScannerCode

-- Functions
local function mw_racing_main( ... )
	local w = UV_GetW()
	local h = UV_GetH()

	local scale = math.Clamp(UVHUDXScale:GetFloat(), 0.1, 1)
	local deadzone = math.Clamp(UVHUDXDeadzone:GetFloat(), 0, 500)

    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)

    local racer_count = #string_array
    local lang = UVString
    local checkpoint_count = #my_array["Checkpoints"]

    ------------------------------------
    -- Timer
    surface.SetMaterial(UVMaterials["RACE_BG_TIME"])
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawTexturedRect( UV_UI.X(w * 0.8), UV_UI.Y(h * 0.096), UV_UI.W(w * 0.19), h * 0.055 )

    DrawIcon( UVMaterials["CLOCK"], UV_UI.X(w * 0.815), UV_UI.Y(h * 0.124), 0.05, UVColors.MW_Accent )

    draw.DrawText(
        Carbon_FormatRaceTime((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0),
		"UVFont5UI", UV_UI.X(w * 0.965), UV_UI.Y(h * 0.1075), UVColors.MW_Accent, TEXT_ALIGN_RIGHT
	)

    -- Lap & Checkpoint Counter
    surface.SetDrawColor(0, 0, 0, 175)
    surface.DrawRect(
        UV_UI.X(w * 0.8),
        UV_UI.Y(h * 0.155),
        UV_UI.W(w * 0.174),
        h * 0.05
    )

    if UVHUDRaceInfo.Info.Laps > 1 then
        draw.DrawText(UVString("uv.race.hud.lap"),"UVFont5UI",
            UV_UI.X(w * 0.805), UV_UI.Y(h * 0.16), Color(255,255,255), TEXT_ALIGN_LEFT)

        draw.DrawText(my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps,"UVFont5UI",
            UV_UI.X(w * 0.97), UV_UI.Y(h * 0.16), Color(255,255,255), TEXT_ALIGN_RIGHT)
    else
        draw.DrawText(UVString("uv.race.hud.complete"),"UVFont5UI",
            UV_UI.X(w * 0.805), UV_UI.Y(h * 0.16), Color(255,255,255), TEXT_ALIGN_LEFT)

        draw.DrawText(
            math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%",
            "UVFont5UI",
            UV_UI.X(w * 0.97),
            UV_UI.Y(h * 0.16),
            Color(255,255,255),
            TEXT_ALIGN_RIGHT
        )
    end

    -- Position Counter
    if racer_count > 1 then
        surface.SetMaterial(UVMaterials["RACE_BG_POS"])
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawTexturedRect(
            UV_UI.X(w * 0.7175),
            UV_UI.Y(h * 0.094),
            UV_UI.W(w * 0.08),
            h * 0.112
        )

        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(
            UV_UI.X(w * 0.745),
            UV_UI.Y(h * 0.15),
            UV_UI.W(w * 0.04),
            h * 0.005
        )

        draw.DrawText(UVHUDRaceCurrentPos,"UVFont5",
            UV_UI.X(w * 0.765), UV_UI.Y(h * 0.107), UVColors.MW_Accent, TEXT_ALIGN_CENTER)

        draw.DrawText(UVHUDRaceCurrentParticipants,"UVFont5",
            UV_UI.X(w * 0.765), UV_UI.Y(h * 0.155), Color(255,255,255), TEXT_ALIGN_CENTER)
    end

    -- Racer List
    local alt = math.floor(CurTime() / 5) % 2 == 1
    for i = 1, math.Clamp(racer_count, 1, GetConVar("uvhud_mostwanted_race_raceramount"):GetString()) do
        if racer_count == 1 then return end

        local entry = string_array[i]
        
        local racer_name = entry[1]
        local is_local_player = entry[2]
        local mode = entry[3]
        local diff = entry[4]

        local racercount = i * (h * 0.025)
        
        local Strings = {
            ["Time"] = "%s",
            ["Lap"] = lang("uv.race.suffix.lap"),
            ["Laps"] = lang("uv.race.suffix.laps"),
            ["Finished"] = lang("uv.race.suffix.finished"),
            ["Disqualified"] = lang("uv.race.suffix.dnf"),
            ["Busted"] = lang("uv.race.suffix.busted"),
        }
        
        local status_text = "- - - - -"
        
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
						num = ((num > 0 and "+ ") or "- ") .. tostring(math.abs(num))
					elseif num then
						num = ((num > 0 and "+ ") or "- ") .. string.format("%.2f", math.abs(num))
					end

					table.insert(args, num)
				end

				status_text = (#args <= 0) and status_string or string.format(status_string, unpack(args))
			end
		end
        
        local color = Color(0, 0, 0)
        
        surface.SetDrawColor(125, 125, 125, 100)
        if entry[2] then
            surface.SetDrawColor(223, 184, 127, 175)
        end

        draw.NoTexture()
        surface.DrawRect( UV_UI.X(w * 0.7275), UV_UI.Y(h * 0.185) + racercount, UV_UI.W(w * 0.2475), h * 0.025 )

        local text = alt and (status_text) or (racer_name)

		surface.SetFont("UVMostWantedLeaderboardFont")
		local ymax = UV_UI.W(w * 0.2)
		textW = surface.GetTextSize(text)
		if textW > ymax then
			while surface.GetTextSize(text .. "...") > ymax do
				text = string.sub(text, 1, -2)
			end
			text = text .. "..."
		end

		draw.SimpleTextOutlined( i, "UVMostWantedLeaderboardFont", UV_UI.X(w * 0.73), UV_UI.Y(h * 0.185) + racercount, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 0.75, Color(0, 0, 0, 75) )
		draw.SimpleTextOutlined( text, "UVMostWantedLeaderboardFont", UV_UI.X(w * 0.97), UV_UI.Y(h * 0.185) + racercount, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 0.75, Color(0, 0, 0, 75) )
    end
end

local function mw_pursuit_main( ... )
    local hudyes = GetConVar("cl_drawhud"):GetBool()
    
    if not hudyes then return end
    if not UVHUDDisplayPursuit then return end
    if UVHUDDisplayRacing then return end
    
    local vehicle = LocalPlayer():GetVehicle()
    
	local w = UV_GetW()
	local h = UV_GetH()
	
	local scale = math.Clamp(UVHUDXScale:GetFloat(), 0.1, 1)
	local deadzone = math.Clamp(UVHUDXDeadzone:GetFloat(), 0, 500)

    local lang = UVString
    
    local UnitsChasing = tonumber(UVUnitsChasing)
    local UVBustTimer = BustedTimer:GetFloat()
    
    local states = UV_UI.pursuit.mostwanted.states
    
    local UVWrecksColor = states.WrecksColor
    local UVTagsColor = states.TagsColor
    local UVUnitsColor = states.UnitsColor
    
    --------------------------------------------------
    
    outofpursuit = CurTime()
    
    local UVHeatBountyMin
    local UVHeatBountyMax
    
    states.EvasionColor = Color(255, 255, 255, 50)
    states.BustedColor = Color(255, 255, 255, 50)
    
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
                
                local blink = 255 * math.abs(math.sin(RealTime() * 8))
                states.BustedColor = Color(255, blink, blink)
            end
        end
    end
    
    --if not UVHUDRace then
    local ResourceText = UVResourcePoints
    local theme_color = (UVHUDCopMode and table.Copy(UVColors.MW_Cop)) or table.Copy(UVColors.MW_Racer)
    
    -- [ Upper Right Info Box ] --
    -- Full BG
    if UVHUDCopMode then
        surface.SetDrawColor(61, 184, 255, 100 * math.abs(math.sin(RealTime() * 2.75))) -- Main border
    else
        surface.SetDrawColor(223, 184, 127, 100 * math.abs(math.sin(RealTime() * 2.75))) -- Main border
    end
    surface.SetMaterial(UVMaterials["PURSUIT_BG_PULSE"])
    surface.DrawTexturedRect(UV_UI.X(w * 0.7), UV_UI.Y(h * 0.101), UV_UI.W(w * 0.275), h * 0.1175)
    
    surface.SetDrawColor(0, 0, 0, 255) -- Timer BG
    surface.SetMaterial(UVMaterials["PURSUIT_BG_TOP"])
    surface.DrawTexturedRect(UV_UI.X(w * 0.7125), UV_UI.Y(h * 0.1075), UV_UI.W(w * 0.2575), h * 0.05)
    
    surface.SetDrawColor(0, 0, 0, 255) -- Bounty BG
    surface.SetMaterial(UVMaterials["PURSUIT_BG_BOTTOM"])
    surface.DrawTexturedRect(UV_UI.X(w * 0.707), UV_UI.Y(h * 0.16), UV_UI.W(w * 0.2625), h * 0.05)
    
    local milestoneamount = 0
    local milestoneh = 0
    
    if milestoneamount > 0 and not UVHUDCopMode then
        surface.SetDrawColor(0, 0, 0, 150) -- Milestone BG
        surface.DrawRect(UV_UI.X(w * 0.71), UV_UI.Y(h * 0.215), UV_UI.W(w * 0.2575), h * 0.035)
        
        draw.DrawText(UVString("uv.hud.milestones"),"UVFont5UI",UV_UI.X(w * 0.7125),UV_UI.Y(h * 0.2125),Color(255, 255, 255),TEXT_ALIGN_LEFT) -- Bounty Text
        draw.DrawText(milestoneamount, "UVFont5UI", UV_UI.X(w * 0.965), UV_UI.Y(h * 0.2125), Color(255, 255, 255), TEXT_ALIGN_RIGHT) -- Bounty Counter
        
        for i = 1, math.min(milestoneamount, 5) do
            surface.SetDrawColor(223, 184, 127, 150) -- Milestone Icon BG's
            surface.DrawRect(UV_UI.X(w * 0.71 + (i - 1) * (w * 0.05175)), UV_UI.Y(h * 0.25), UV_UI.W(w * 0.05075), h * 0.065)
            DrawIcon(UVMaterials["CLOCK_BG"], UV_UI.X(w * 0.735 + (i - 1) * (w * 0.05175)), UV_UI.Y(h * 0.28), .075, Color(255, 255, 255, 100))
        end
        milestoneh = UV_UI.Y(h * 0.1025)
    end
    
    -- Timer
    DrawIcon(UVMaterials["CLOCK"], UV_UI.X(w * 0.735), UV_UI.Y(h * 0.1325), .0625, UVHUDCopMode and UVColors.MW_Cop or UVColors.MW_Accent) -- Icon
    draw.DrawText(UVTimer, "UVFont5UI", UV_UI.X(w * 0.965), UV_UI.Y(h * 0.115), UVHUDCopMode and UVColors.MW_Cop or UVColors.MW_Accent, TEXT_ALIGN_RIGHT)
    
    -- Bounty
    draw.DrawText(UVString("uv.hud.bounty"),"UVFont5UI", UV_UI.X(w * 0.7175), UV_UI.Y(h * 0.1625), Color(255, 255, 255), TEXT_ALIGN_LEFT) -- Bounty Text
    draw.DrawText(UVBounty, "UVFont5UI", UV_UI.X(w * 0.965), UV_UI.Y(h * 0.1625), Color(255, 255, 255), TEXT_ALIGN_RIGHT) -- Bounty Counter
    
    -- Heat Level
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(UV_UI.X(w * 0.71), UV_UI.Y(h * 0.2175) + milestoneh, UV_UI.W(w * 0.036), h * 0.035)

    local UVHeatMinConVar = GetConVar( 'unitvehicle_unit_heatminimumbounty' .. UVHeatLevel )
    local UVHeatMaxConVar = GetConVar( 'unitvehicle_unit_heatminimumbounty' .. UVHeatLevel + 1 )
    
    UVHeatBountyMin = ( UVHeatMinConVar and UVHeatMinConVar:GetInt() ) or math.huge
    UVHeatBountyMax = ( UVHeatMaxConVar and UVHeatMaxConVar:GetInt() ) or math.huge
    
    DrawIcon(UVMaterials["HEAT"], UV_UI.X(w * 0.7175), UV_UI.Y(h * 0.2325) + milestoneh, .0375, Color(255, 255, 255)) -- Icon
    draw.DrawText(UVHeatLevel, "UVFont5UI", UV_UI.X(w * 0.733), UV_UI.Y(h * 0.214) + milestoneh, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    
    surface.SetDrawColor(Color(109, 109, 109, 200))
    surface.DrawRect(UV_UI.X(w * 0.7475), UV_UI.Y(h * 0.2175) + milestoneh, UV_UI.W(w * 0.22), h * 0.035)
    surface.SetDrawColor(Color(255, 255, 255))
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
    local B = math.Clamp((HeatProgress) * UV_UI.W(w * 0.22), 0, UV_UI.W(w * 0.22))
    local blink = 255 * math.abs(math.sin(RealTime() * 4))
    local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
    local blink3 = 255 * math.abs(math.sin(RealTime() * 8))

    local function blinkcolorinstant(min, max)
        return math.floor(RealTime()*6)==math.Round(RealTime()*6) and min or max
    end
    
    if HeatProgress >= 0.6 and HeatProgress < 0.75 then
        surface.SetDrawColor(Color(255, blink, blink))
    elseif HeatProgress >= 0.75 and HeatProgress < 0.9 then
        surface.SetDrawColor(Color(255, blink2, blink2))
    elseif HeatProgress >= 0.9 and HeatProgress < 1 then
        surface.SetDrawColor(Color(255, blink3, blink3))
    elseif HeatProgress >= 1 then
        surface.SetDrawColor(Color(255, 0, 0))
    end
    
    surface.DrawRect(UV_UI.X(w * 0.7475), UV_UI.Y(h * 0.2175) + milestoneh, B, UV_UI.Y(h * 0.035))
    
    -- [[ Commander Stuff ]]
    if UVOneCommanderActive then
        ResourceText = "⛊"
        
        surface.SetDrawColor(0, 0, 0, 200) -- Milestone BG
        surface.DrawRect(UV_UI.X(w * 0.71), h * 0.26 + milestoneh, UV_UI.W(w * 0.2575), h * 0.035)
        
        draw.DrawText("⛊","UVFont5UI-BottomBar",UV_UI.X(w * 0.71), h * 0.2525 + milestoneh, UVHUDCopMode and UVColors.MW_Cop or UVColors.MW_Accent,TEXT_ALIGN_LEFT)
        draw.DrawText("⛊","UVFont5UI-BottomBar",UV_UI.X(w * 0.965), h * 0.2525 + milestoneh, UVHUDCopMode and UVColors.MW_Cop or UVColors.MW_Accent,TEXT_ALIGN_RIGHT)
        
        local cname = UVString("uv.unit.commander")
        if IsValid(UVHUDCommander) then
            local driver = UVHUDCommander:GetDriver()
            if IsValid(driver) and driver:IsPlayer() then
                cname = driver:Nick()
            end
        end
        
        draw.DrawText(cname,"UVFont5UI-BottomBar", UV_UI.X(w * 0.8375), h * 0.255 + milestoneh, UVHUDCopMode and UVColors.MW_Cop or UVColors.MW_Accent,TEXT_ALIGN_CENTER)
        
        if not UVHUDCommanderLastHealth or not UVHUDCommanderLastMaxHealth then
            UVHUDCommanderLastHealth = 0
            UVHUDCommanderLastMaxHealth = 0
        end
        if IsValid(UVHUDCommander) then
            if UVHUDCommander.IsSimfphyscar then
                UVHUDCommanderLastHealth = UVHUDCommander:GetCurHealth()
                UVHUDCommanderLastMaxHealth =
                UVUOneCommanderHealth:GetInt() - (UVHUDCommander:GetMaxHealth() * 0.3)
            elseif UVHUDCommander.IsGlideVehicle then
                local enginehealth = UVHUDCommander:GetEngineHealth()
                UVHUDCommanderLastHealth = UVHUDCommander:GetChassisHealth() * enginehealth
                UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
            elseif vcmod_main then
                UVHUDCommanderLastHealth =
                UVUOneCommanderHealth:GetInt() * (UVHUDCommander:VC_getHealth() / 100) --vcmod returns % health clientside
                UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
            else
                UVHUDCommanderLastHealth = UVHUDCommander:Health()
                UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
            end
        end
        local healthratio = UVHUDCommanderLastHealth / UVHUDCommanderLastMaxHealth
        local healthcolor
        
        if healthratio >= 0.5 then
            healthcolor = Color(255, 255, 255, 200)
        elseif healthratio >= 0.25 then
            healthcolor = Color(255, blink, blink, 200)
        else
            healthcolor = Color(255, blink2, blink2, 200)
        end
        if healthratio > 0 then
            surface.SetDrawColor(Color(109, 109, 109, 200))
            surface.DrawRect(UV_UI.X(w * 0.71), h * 0.294 + milestoneh, UV_UI.W(w * 0.2575), h * 0.0125)
            surface.SetDrawColor(healthcolor)
            local T = math.Clamp((healthratio) * (UV_UI.W(w * 0.2575)), 0, UV_UI.W(w * 0.2575))
            surface.DrawRect(UV_UI.X(w * 0.71), h * 0.294 + milestoneh, T, h * 0.0125)
        end
    end
    
    -- [ Bottom Info Box ] --
	local bottomyplus = 0

    if UVHUDActiveBar then
        bottomyplus = -(h * 0.075)
    end

    local bottomy = UV_UI.Y(h * 0.8) + bottomyplus

    local middlergb = {
        r = 255,
        g = 255,
        b = 255,
        a = 255 * math.abs(math.sin(RealTime() * 4))
    }
    
    if not UVHUDDisplayCooldown then
        -- General Icons
        draw.DrawText( UVWrecks, "UVFont5UI", UV_UI.XScaled(w * 0.64), bottomy + h * 0.025, UVWrecksColor, TEXT_ALIGN_RIGHT)
        DrawIcon(UVMaterials["UNITS_DISABLED"], UV_UI.XScaled(w * 0.6525), bottomy + h * 0.04, 0.06, UVWrecksColor)
        
        draw.DrawText(UVTags, "UVFont5UI", UV_UI.XScaled(w * 0.3625), bottomy + h * 0.025, UVTagsColor, TEXT_ALIGN_LEFT)
        DrawIcon(UVMaterials["UNITS_DAMAGED"], UV_UI.XScaled(w * 0.35), bottomy + h * 0.04, 0.06, UVTagsColor)
        
        draw.DrawText(ResourceText,"UVFont5UI-BottomBar",UV_UI.XScaled(w * 0.5),bottomy + h * 0.025,UVUnitsColor,TEXT_ALIGN_CENTER)
        DrawIcon(UVMaterials["UNITS"], UV_UI.XScaled(w * 0.5), bottomy + h * 0.0, .07, UVUnitsColor)
        
        -- Evade Box, All BG
        surface.SetDrawColor(200, 200, 200, 100)
        surface.DrawRect(UV_UI.XScaled(w * 0.333), bottomy + h * 0.1, UV_UI.W(w * 0.34), h * 0.01)
        
        -- Evade Box, Busted Meter
        if UVHUDDisplayBusting and not UVHUDDisplayCooldown then
            if not BustingProgress or BustingProgress == 0 then
                BustingProgress = CurTime()
            end
            
            local timeLeft = ((UVHUDDisplayNotification and -1) or (UVBustTimer - UVBustingProgress))
            
            local playbusting = (UVHUDCopMode and UVHUDWantedSuspectsNumber == 1) or not UVHUDCopMode
            
            states.BustedColor = Color(255, blinkcolorinstant(0, 255), blinkcolorinstant(0, 255))
            
            local T = math.Clamp((UVBustingProgress / UVBustTimer) * (UV_UI.W(w * 0.1515)), 0, UV_UI.W(w * 0.1515))
            T = math.floor(T)
			surface.SetDrawColor(255, 0, 0, blinkcolorinstant(230, 255))
            surface.DrawRect(UV_UI.XScaled(w * 0.333) + (UV_UI.W(w * 0.1515) - T), bottomy + h * 0.1, T, h * 0.01)
            middlergb = {
                r = 255,
                g = 255,
                b = 255,
                a = 128
            }
        else
            UVBustedColor = Color(255, 255, 255, 50)
            BustingProgress = 0
        end
        
        -- Evade Box, Evade Meter
        if not UVHUDDisplayNotification and not UVHUDDisplayCooldown and UnitsChasing == 0 and BustingProgress == 0 then
            --UVSoundHeat(UVHeatLevel)
            if not EvadingProgress then
                EvadingProgress = 0
                UVEvadingProgress = EvadingProgress
            end
            
            local T = math.Clamp((UVEvadingProgress) * (UV_UI.W(w * 0.16225)), 0, UV_UI.W(w * 0.16225))
            surface.SetDrawColor(155, 207, 0, blinkcolorinstant(230, 255))
            surface.DrawRect(UV_UI.XScaled(w * 0.51), bottomy + h * 0.1, T, h * 0.01)
            middlergb = {
                r = 255,
                g = 255,
                b = 255,
                a = 128
            }
            
            states.EvasionColor = Color(blinkcolorinstant(155, 255), blinkcolorinstant(207, 255), blinkcolorinstant(0, 255))
        else
            EvadingProgress = 0
        end
        
        -- Evade Box, Middle
        surface.SetDrawColor(middlergb.r, middlergb.g, middlergb.b, middlergb.a)
        surface.DrawRect(UV_UI.XScaled(w * 0.49), bottomy + h * 0.1, UV_UI.W(w * 0.021), h * 0.01)
        
        -- Evade Box, Dividers
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(UV_UI.XScaled(w * 0.485), bottomy + h * 0.1, UV_UI.W(w * 0.005), h * 0.01)
        surface.DrawRect(UV_UI.XScaled(w * 0.4), bottomy + h * 0.1, UV_UI.W(w * 0.005), h * 0.01)
        
        surface.DrawRect(UV_UI.XScaled(w * 0.51), bottomy + h * 0.1, UV_UI.W(w * 0.005), h * 0.01)
        surface.DrawRect(UV_UI.XScaled(w * 0.6), bottomy + h * 0.1, UV_UI.W(w * 0.005), h * 0.01)
        
        -- Upper Box
        surface.SetDrawColor(0, 0, 0, 255)
        surface.SetMaterial(UVMaterials["PURSUIT_BG_BOTBAR_ALT"])
        surface.DrawTexturedRect(UV_UI.XScaled(w * 0.303), bottomy + h * 0.04, UV_UI.W(w * 0.4015), h * 0.06)
        
        draw.DrawText(UVString("uv.chase.busted"),"UVFont5UI",UV_UI.XScaled(w * 0.34),bottomy + h * 0.0625,states.BustedColor,TEXT_ALIGN_LEFT)
        draw.DrawText(UVString("uv.chase.evade"),"UVFont5UI",UV_UI.XScaled(w * 0.66),bottomy + h * 0.0625,states.EvasionColor,TEXT_ALIGN_RIGHT)
        
        -- Lower Box
        local shade_theme_color =
        (UVHUDCopMode and table.Copy(UVColors.MW_CopShade)) or table.Copy(UVColors.MW_RacerShade)
        local theme_color =
        (UVHUDCopMode and table.Copy(UVColors.MW_Cop)) or table.Copy(UVColors.MW_Racer)
        
        surface.SetDrawColor(theme_color:Unpack())
        surface.SetMaterial(UVMaterials["PURSUIT_BG_BOTBAR"])
        surface.DrawTexturedRect(UV_UI.XScaled(w * 0.302), bottomy + h * 0.1125, UV_UI.W(w * 0.4015), h * 0.06)
        
        local lbtext = "REPLACEME"
        local uloc, utype = "uv.chase.unit", UnitsChasing
        if not UVHUDCopMode then
            if UnitsChasing ~= 1 then
                uloc = "uv.chase.units"
            end
        else
            utype = UVHUDWantedSuspectsNumber
            uloc = "uv.chase.suspects"
        end
        
        --local color = Color(255,255,255)
        if not UVBackupColor then
            UVBackupColor = Color(255, 255, 255)
        end
        local num = UVBackupTimerSeconds
        
        if not UVHUDDisplayBackupTimer then
            lbtext = string.format(lang(uloc), utype)
        else
            if num then
                if num < 10 and _last_backup_pulse_second ~= math.floor(num) then
                    _last_backup_pulse_second = math.floor(num)
                    
                    hook.Remove("Think", "UVBackupColorPulse")
                    UVBackupColor = Color(255, 255, 0)
                    
                    hook.Add("Think","UVBackupColorPulse",function()
                        UVBackupColor.b = UVBackupColor.b + 600 * RealFrameTime()
                        if UVBackupColor.b >= 255 then
                            hook.Remove("Think", "UVBackupColorPulse")
                        end
                    end)
                end
            end
            
            lbtext = string.format(lang("uv.chase.backupin"), UVBackupTimer)
        end
        
        draw.DrawText(lbtext,"UVFont5UI", UV_UI.X(w * 0.5), bottomy + h * 0.11 * 1.001,UVBackupColor,TEXT_ALIGN_CENTER)
    else
        -- Lower Box
        -- Evade Box, All BG (Moved to inner if clauses)
        
        -- Evade Box, Cooldown Meter
        if UVHUDDisplayCooldown then
            if not CooldownProgress or CooldownProgress == 0 then
                CooldownProgress = CurTime()
            end
            
            --UVSoundCooldown(UVHeatLevel)
            EvadingProgress = 0
            
            -- Upper Box
            if not UVHUDCopMode then
                if UVHUDDisplayHidingPrompt then
                    local blink = 200 * math.abs(math.sin(RealTime() * 2))
                    
                    surface.SetDrawColor(0, 175, 0, 200)
                    surface.SetMaterial(UVMaterials["PURSUIT_BG_BOTBAR_ALT"])
                    surface.DrawTexturedRect(UV_UI.XScaled(w * 0.303), bottomy + h * 0.04, UV_UI.W(w * 0.4015), h * 0.06)
                    
                    DrawIcon(UVMaterials["HIDECAR"], UV_UI.XScaled(w * 0.5), bottomy + h * 0.035, .07, Color(blink, 255, blink))
                    draw.DrawText( UVString("uv.chase.hiding"), "UVFont5UI", UV_UI.XScaled(w * 0.5), bottomy + h * 0.0625, Color(255,255,255), TEXT_ALIGN_CENTER)
                end
                
                surface.SetDrawColor(255, 255, 255, 50)
                surface.DrawRect(UV_UI.XScaled(w * 0.333), bottomy + h * 0.1, UV_UI.W(w * 0.34), h * 0.01)
                
                local T = math.Clamp((UVCooldownTimer) * (UV_UI.W(w * 0.34)), 0, UV_UI.W(w * 0.34))
                surface.SetDrawColor(75, 75, 255)
                surface.DrawRect(UV_UI.XScaled(w * 0.333), bottomy + h * 0.1, T, h * 0.01)
                
                surface.SetDrawColor(0, 0, 0)
                surface.SetMaterial(UVMaterials["PURSUIT_BG_BOTBAR"])
                surface.DrawTexturedRect(UV_UI.XScaled(w * 0.302), bottomy + h * 0.1125, UV_UI.W(w * 0.4015), h * 0.06)
                
                draw.DrawText(UVString("uv.chase.cooldown"), "UVFont5UI", w * 0.5, bottomy + h * 0.11, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            else
                local shade_theme_color = (UVHUDCopMode and table.Copy(UVColors.MW_CopShade)) or table.Copy(UVColors.MW_RacerShade)
                local theme_color = (UVHUDCopMode and table.Copy(UVColors.MW_Cop)) or table.Copy(UVColors.MW_Racer)
                local blink = 255 * math.Clamp(math.abs(math.sin(RealTime())), .7, 1)
                
                surface.SetDrawColor(theme_color:Unpack())
                surface.SetMaterial(UVMaterials["PURSUIT_BG_BOTBAR"])
                surface.DrawTexturedRect(UV_UI.XScaled(w * 0.302), bottomy + h * 0.1125, UV_UI.W(w * 0.4015), h * 0.06)
                
                draw.DrawText(UVString("uv.chase.cooldown"), "UVFont5UI", w * 0.5, bottomy + h * 0.11, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                
                DrawIcon(UVMaterials["HIDECAR"], w * 0.5, bottomy + h * 0.075, .07, UVColors.MW_Cop)
            end
        else
            CooldownProgress = 0
        end
    end
end

UV_UI.pursuit.mostwanted.main = mw_pursuit_main
UV_UI.racing.mostwanted.main = mw_racing_main