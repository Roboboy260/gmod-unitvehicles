UV_UI.general = UV_UI.general or {}

local function uv_general()
    local hudyes = GetConVar("cl_drawhud"):GetBool()
    if not hudyes then return end

    local w = UV_GetW()
	local h = UV_GetH()
	
    local vehicle = LocalPlayer():GetVehicle()
    if not IsValid(vehicle) then
        UVHUDPursuitTech = nil
        return
    end

    UVHUDPursuitTech = vehicle.PursuitTech or (IsValid(vehicle:GetParent()) and vehicle:GetParent().PursuitTech) or nil
    if not UVHUDPursuitTech then return end

    local PT_Replacement_Strings = {
        ['EMP'] = 'uv.ptech.emp.short',
        ['ESF'] = 'uv.ptech.esf.short',
        ['Killswitch'] = 'uv.ptech.killswitch.short',
        ['Jammer'] = 'uv.ptech.jammer.short',
        ['Shockwave'] = 'uv.ptech.shockwave.short',
        ['Stunmine'] = 'uv.ptech.stunmine.short',
        ['Spikestrip'] = 'uv.ptech.spikes.short',
        ['Repair Kit'] = 'uv.ptech.repairkit.short',
        ['Power Play'] = 'uv.ptech.powerplay.short',
        ['Shock Ram'] = 'uv.ptech.shockram.short',
        ['GPS Dart'] = 'uv.ptech.gpsdart.short',
        ['Juggernaut'] = 'uv.ptech.juggernaut.short',
		['Ghost'] = 'uv.ptech.ghost.short',
		['Grappler'] = 'uv.ptech.grappler.short',
    }

	local hudconvar = GetConVar("unitvehicle_speedometer"):GetString()
	local xConVar = GetConVar("uvspeedo_" .. hudconvar .. "_x")
	local yConVar = GetConVar("uvspeedo_" .. hudconvar .. "_y")

	local hudpos = { x = xConVar and xConVar:GetFloat() or 0.815, y = yConVar and yConVar:GetFloat() or 0.6 }
	local racing = UV_UI.speedometer[hudconvar]
	local offsets = racing and racing.offsets
	local hudoffset = { x = offsets and offsets.x or 0, y = offsets and offsets.y or 0 }
	
	if not GetConVar("unitvehicle_speedometer_enable"):GetBool() then
		hudpos = { x = 0.824, y = 0.6 }
		hudoffset = { x = 0, y = 0 }
	end

	-- local debugjam = true
    -- if not debugjam then
    if not uvclientjammed then
        for i = 1, 2 do
            local keyCode = GetConVar("unitvehicle_pursuittech_keybindslot_" .. i):GetInt()
            local tech = UVHUDPursuitTech[i]

            local xOffset = UV_UI.XScaled( w * (hudpos.x - hudoffset.x) )
            local y = UV_UI.Y( h * (hudpos.y - hudoffset.y) )
            local xOffsetI = UV_UI.XScaled( w * (hudpos.x - hudoffset.x) + ((i - 1) * (h * 0.105)) )
            local bw, bh = w * 0.06, h * 0.06
            local x = xOffsetI
            local textX = xOffset + (bw * 0.5) + ((i - 1) * (h * 0.105))

            local bgColor = Color(0, 0, 0, 225)
            local fillOverlayColor = nil
            local fillFrac = 0
            local showFillOverlay = false
            local textColor = Color(255, 255, 255, 125)
            local keyColor = Color(255, 255, 255, 125)
            local ammoText, techText = " - ", " - "

            if tech then
                if input.IsKeyDown(keyCode) and not gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
                    net.Start("UVPTUse")
                    net.WriteInt(i, 16)
                    net.SendToServer()
                end

                local timeSinceUsed = CurTime() - tech.LastUsed
                local duration = tech.Duration or 0
                local inDuration = duration > 0 and timeSinceUsed <= duration
                local inCooldown = tech.Ammo > 0 and timeSinceUsed <= (duration > 0 and duration + tech.Cooldown or tech.Cooldown)

                if inDuration then
                    fillFrac = math.Clamp(timeSinceUsed / duration, 0, 1)
                    showFillOverlay = true
                elseif inCooldown then
                    fillFrac = math.Clamp((timeSinceUsed - duration) / tech.Cooldown, 0, 1)
                    showFillOverlay = true
                end

                if showFillOverlay then
                    local blink = 255 * math.abs(math.sin(RealTime() * 3))
                    fillOverlayColor = Color(blink, blink, 0, 175)
                else
                    bgColor = tech.Ammo > 0 and Color(100, 255, 100, 175) or Color(200, 0, 0, 175)
                    textColor = tech.Ammo > 0 and Color(255, 255, 255) or Color(255, 75, 75)
                    keyColor = tech.Ammo > 0 and Color(255, 255, 255) or Color(255, 75, 75)
                end

                ammoText = tech.Ammo > 0 and tech.Ammo or " - "
                techText = UVString(PT_Replacement_Strings[tech.Tech]) or tech.Tech
            end

            if hudyes then
				if i == 1 then
					surface.SetMaterial(UVMaterials["PT_LEFT_BG"])
				else
					surface.SetMaterial(UVMaterials["PT_RIGHT_BG"])
				end
				surface.SetDrawColor(Color(0,0,0,125))
                surface.DrawTexturedRect(x, y, bw, bh)

				if i == 1 then
					surface.SetMaterial(UVMaterials["PT_LEFT"])
				else
					surface.SetMaterial(UVMaterials["PT_RIGHT"])
				end
                surface.SetDrawColor(bgColor)
                surface.DrawTexturedRect(x, y, bw, bh)

				if showFillOverlay and fillOverlayColor then
					surface.SetDrawColor(fillOverlayColor)

					if i == 1 then
						surface.SetMaterial(UVMaterials["PT_LEFT"])
						local T = math.Clamp(fillFrac * bw, 0, bw)
						surface.DrawTexturedRectUV( x, y, T, bh, 0, 0, T / bw, 1 )
					else
						surface.SetMaterial(UVMaterials["PT_RIGHT"])
						local T = math.Clamp(fillFrac * bw, 0, bw)
						surface.DrawTexturedRectUV( x, y, T, bh, 0, 0, T / bw, 1 )
					end
				end

				draw.SimpleTextOutlined( techText, "UVMostWantedLeaderboardFont2", textX, y + (h * 0.0075), textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0))
				draw.SimpleTextOutlined( ammoText, "UVMostWantedLeaderboardFont", textX, y + (h * 0.0275), textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0))

				local mk = markup.Parse( UVReplaceKeybinds( "[key:unitvehicle_pursuittech_keybindslot_" .. i .. "]", "Big" ), w )
				mk:Draw(x + (bw * 0.5), y - (bh * 0.45), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            end
        end
	else
		local xOffset = w * (hudpos.x - hudoffset.x)
		local bw, bh = w * 0.06, h * 0.06
		local textX = xOffset + (bw * 0.95)
		local y = h * (hudpos.y - hudoffset.y) + (bh * 0.25)

		local blink = 255 * math.abs(math.sin(RealTime() * 6))

		draw.SimpleTextOutlined( UVString("uv.ptech.jammer.hit.you"), "UVMostWantedLeaderboardFont", textX, y, Color(255, 0, 0, blink), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,blink))
    end
end

UV_UI.general.main = uv_general

UV_UI.general.states = {
	notificationQueue = {},
	notificationActive = false,
	closing = false,
	closingStartTime = nil,
	ptext = nil,
	startTime = nil,
}

UV_UI.general.events = {
	CenterNotification = function(params)
		local ptext = params.text or "REPLACEME"
		local pcol = params.color or Color( 255, 255, 255 )
		local immediate = params.immediate or nil
		local iscritical = params.critical or nil
		local notitimer = params.timer or 1
		
		-- Legacy notification (Original UI Exclusive)
		if UVIsUsingOGHUD() then
			LocalPlayer():PrintMessage(HUD_PRINTCENTER, ptext)
			return
		end

		local StartClosing
		local closing = false
		local closeStartTime = nil

		-- Handle queue logic
		if UV_UI.general.states.notificationActive then
			if immediate then
				-- Retain critical entries only
				local retainedQueue = {}
				for _, v in ipairs(UV_UI.general.states.notificationQueue) do
					if v.critical then
						table.insert(retainedQueue, v)
					end
				end

				UV_UI.general.states.notificationQueue = retainedQueue
				table.insert(UV_UI.general.states.notificationQueue, 1, params)

				timer.Simple(0, function()
					if not closing and StartClosing then
						StartClosing()
					end
				end)
			else
				table.insert(UV_UI.general.states.notificationQueue, params)
			end
			return
		end

		UV_UI.general.states.notificationActive = true

		local hookName = "UV_CENTERNOTI_PURSUITTECH"
		local displayDuration = 3
		local w = UV_GetW()
		local h = UV_GetH()
		local startTime = CurTime()
		local closing = false
		local closeStartTime = nil

		local delay = 0.1
		local expandDuration = 0.15
		local whiteFadeInDuration = 0.0175
		local blackFadeOutDuration = 0.65

		local expandStart = delay
		local whiteStart = expandStart + expandDuration
		local blackStart = whiteStart + whiteFadeInDuration

		-- Remove any prior hook
		hook.Remove("HUDPaint", hookName)

		StartClosing = function()
			if closing then return end
			closing = true
			closeStartTime = CurTime()

			-- Ensure we clean everything after closing finishes
			timer.Create("UV_CENTERNOTI_CLEANUP", expandDuration, 1, function()
				hook.Remove("HUDPaint", hookName)
				UV_UI.general.states.notificationActive = false

				if #UV_UI.general.states.notificationQueue > 0 then
					local nextParams = table.remove(UV_UI.general.states.notificationQueue, 1)
					-- If the queued entry has 'immediate', allow mid-close interruption next round
					timer.Simple(0, function()
						UV_UI.general.events.CenterNotification(nextParams)
					end)
				end
			end)
		end

		-- Mid-life force-close handler for 'immediate' queueing
		timer.Create("UV_CENTERNOTI_FORCECHECK", 0.05, 0, function()
			if CurTime() - startTime >= notitimer and not closing and #UV_UI.general.states.notificationQueue > 0 then
				StartClosing()
				timer.Remove("UV_CENTERNOTI_FORCECHECK")
			end
		end)

		-- Regular close trigger
		timer.Create("UV_CENTERNOTI_TIMER", displayDuration - expandDuration, 1, function()
			if not closing then
				StartClosing()
			end
			timer.Remove("UV_CENTERNOTI_FORCECHECK")
		end)

		hook.Add("HUDPaint", hookName, function()
			local showhud = GetConVar("cl_drawhud"):GetBool()
			local now = CurTime()
			local realTime = RealTime()
			local animTime = now - startTime
			local barProgress = 0
			local currentWidth
			local text = UVString(UV_CurrentSubtitle)
			local hasValidSubtitle = UV_CurrentSubtitle and text ~= "" and text ~= UV_CurrentSubtitle and CurTime() < (UV_SubtitleEnd or 0)
			local subconvar = (GetConVar("unitvehicle_subtitles"):GetBool() and hasValidSubtitle) or (UVHUDDisplayPursuit and UVHUDActiveBar)

			if closing then
				local closeAnimTime = now - closeStartTime
				barProgress = 1 - math.Clamp(closeAnimTime / expandDuration, 0, 1)
				currentWidth = Lerp(barProgress, 0, w)
			else
				if animTime >= expandStart then
					barProgress = math.Clamp((animTime - expandStart) / expandDuration, 0, 1)
				end
				currentWidth = Lerp(barProgress, 0, w)
			end

			local barHeight = h * 0.175
			local barX = UV_UI.XScaled( (w - currentWidth) / 2 )
			local barY = UV_UI.Y( h * (subconvar and 0.575 or 0.675) )

			-- Color Fade Logic
			local colorVal = 0
			if animTime >= whiteStart and animTime < blackStart then
				local p = (animTime - whiteStart) / whiteFadeInDuration
				colorVal = Lerp(math.Clamp(p, 0, 1), 0, 255)
			elseif animTime >= blackStart then
				local p = (animTime - blackStart) / blackFadeOutDuration
				colorVal = Lerp(math.Clamp(p, 0, 1), 255, 0)
			end

			if closing then
				-- Fade out during closing
				local closeAnimTime = now - closeStartTime
				local fade = 1 - math.Clamp(closeAnimTime / expandDuration, 0, 1)
				colorVal = colorVal * fade
			end
			
			
			if not showhud then return end

			-- Draw bar
			surface.SetMaterial(UVMaterials["COOLDOWNBG_WORLD"])
			surface.SetDrawColor(Color(0, 0, 0))
			surface.DrawTexturedRect(barX, barY, currentWidth, barHeight)
			
			surface.SetMaterial(UVMaterials["PT_BG"])
			surface.SetDrawColor(Color(colorVal, colorVal, colorVal, 150))
			surface.DrawTexturedRect(barX, barY, currentWidth, barHeight)

			-- Text
			if animTime >= whiteStart then
				local outlineAlpha = math.Clamp(255 - colorVal, 0, 255)

				if closing then
					local closeAnimTime = now - closeStartTime
					local fade = 1 - math.Clamp(closeAnimTime / expandDuration, 0, 1)
					outlineAlpha = outlineAlpha * fade
				end
				
				mw_noti_draw(showhud and ptext, "UVFont5Shadow", UV_UI.XScaled( w * 0.5), UV_UI.Y( h * (subconvar and 0.66 or 0.76) ), pcol, pcolbg) -- Subconvar > barY + 0.095
			end
		end)
	end,
}

UV_UI.racing.general = {}
UV_UI.pursuit.general = {}

UV_UI.racing.general.SplitDiffCache = UV_UI.racing.general.SplitDiffCache or {}

local function general_racing_main( ... )
    local w = UV_GetW()
    local h = UV_GetH()
    
    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)

    local racer_count = #string_array
    if racer_count <= 1 then return end

    local checkpoint_count = #my_array["Checkpoints"]
    
    -- Find local player's index
    local myIndex
    for i = 1, #string_array do
        if string_array[i][2] then -- is_local_player
            myIndex = i
            break
        end
    end
    if not myIndex then return end

    local aheadText, behindText = "N/A", "N/A"

    -- Check nearest ahead racer
    for i = myIndex - 1, 1, -1 do
        local entry = string_array[i]
        if entry[3] == "Lap" and entry[4] then
			local laps = math.abs(entry[4])
			local lapText = (laps > 1) and UVString("uv.race.suffix.laps") or UVString("uv.race.suffix.lap")
			aheadText = string.format(lapText, laps)
            break
        elseif entry[4] then
            aheadText = string.format("%.2f", math.abs(entry[4]))
            break
        end
    end

    -- Check nearest behind racer
    for i = myIndex + 1, #string_array do
        local entry = string_array[i]
        if entry[3] == "Lap" and entry[4] then
			local laps = math.abs(entry[4])
			local lapText = (laps > 1) and UVString("uv.race.suffix.laps") or UVString("uv.race.suffix.lap")
			behindText = string.format(lapText, laps)
            break
        elseif entry[4] then
            behindText = string.format("%.2f", math.abs(entry[4]))
            break
        end
    end

	-- draw.SimpleTextOutlined( -- Debug
		-- "DEBUG Leaderboard Diffs - Ahead: " .. aheadText .. " | Behind: " .. behindText,
		-- "DermaDefaultBold",
		-- ScrW() * 0.5,
		-- 20,
		-- Color(255, 255, 0),
		-- TEXT_ALIGN_CENTER,
		-- TEXT_ALIGN_TOP,
		-- 1,
		-- Color(0,0,0)
	-- )
	
	UV_UI.racing.general.SplitDiffCache[my_vehicle] = { -- Store said debug data
		Ahead = aheadText,
		Behind = behindText,
		LastCheckpoint = checkpoint_count -- optional
	}

end

UV_UI.racing.general.main = general_racing_main

UV_UI.pursuit.general.scannerConfig = {
	radius = 30,
	innerRadius = 14,
	blipRadius = 8,
	maxRange = 10000,
	maxArc = 360,
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

	local corner8tex, corner32tex = surface.GetTextureID("gui/corner8"), surface.GetTextureID("gui/corner32")
	local function drawCircle(x, y, radius, seg)
		surface.SetTexture(radius <= 8 and corner8tex or corner32tex)
		surface.DrawTexturedRectUV( x-radius, y-radius, radius, radius, 0, 0, 1, 1 )
		surface.DrawTexturedRectUV( x, y-radius, radius, radius, 1, 0, 0, 1 )
		surface.DrawTexturedRectUV( x-radius, y, radius, radius, 0, 1, 1, 0 )
		surface.DrawTexturedRectUV( x, y, radius, radius, 1, 1, 0, 0 )
		draw.NoTexture()
	end

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

	if not found then return end

	local realDistance = math.sqrt(closestDist)

	-- Range limit
	if realDistance > maxRange then return end

	surface.SetDrawColor(0,0,0,200)
	drawCircle(centerx, centery, radius, 50)

	local distanceFrac = math.Clamp(realDistance / maxRange, 0, 1)
	local beepfrequency = math.Clamp(distanceFrac, 0.1, 1)

	if beepfrequency >= 1 then
		drawCircle(centerx, centery, innerRadius, 50)
		return
	end

	surface.SetDrawColor(255,255,255,255)
	drawCircle(centerx, centery, innerRadius, 50)

	local angleDiff = math.AngleDifference(
		forwardYaw,
		(closestPos - enemypos):Angle().y
	)

	local angle = math.rad(angleDiff) + math.pi/2

	surface.SetMaterial(UVMaterials["SCANNER_ARROW"])
	surface.SetDrawColor(255,255,255,255)

	-- Rotate relative to forward
	surface.DrawTexturedRectRotated(
		centerx,
		centery,
		radius * 2.5,   -- size
		radius * 2.5,
		-angleDiff       -- rotation in degrees
	)

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

	local beepcolor = Beeped and Color(0,255,0) or Color(0,0,0)

	surface.SetDrawColor(beepcolor)
	drawCircle(centerx, centery, blipRadius, 50)
end

UV_UI.pursuit.general.scanner = ScannerCode