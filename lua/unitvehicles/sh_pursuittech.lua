if SERVER then return end

local PURSUIT_TECH_TYPES = {}
local UV_PT = {}

--

UV_PT.Killswitch = {
    Hit = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "uv.ptech.killswitch.hit"
        local targetString = "uv.ptech.killswitch.hit.you"

        UV_UI.general.events.CenterNotification({
            text = string.format( (displayMe and UVString( userString )) or UVString( targetString ), (displayMe and UVString( tbl.Target )) or UVString( tbl.User )),
			color = not displayMe and Color(255, 0, 0) or nil,
			immediate = not displayMe and true or nil,
			critical = not displayMe and true or nil,
			time = not displayMe and 3 or 1,
		})
    end,
    Locking = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "uv.ptech.killswitch.activated"
        local targetString = "uv.ptech.killswitch.lockingon"

        UV_UI.general.events.CenterNotification({
            text = (displayMe and UVString( userString )) or UVString(targetString),
			color = not displayMe and Color(255, 0, 0) or nil,
			immediate = not displayMe and true or nil,
        })
    end,
    Counter = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end
		local String = "uv.ptech.killswitch.dodged"
		
        UV_UI.general.events.CenterNotification({
            text = UVString( String ),
        })
    end,
    EngineRestarting = function(tbl)
        local userString = "uv.ptech.killswitch.engine.on"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
			immediate = true,
			critical = true,
			time = 3,
        })
    end,
    NoTarget = function(tbl)
        local userString = "uv.ptech.killswitch.novalid"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
			-- immediate = true,
			-- critical = true,
        })
    end,
    TooFar = function(tbl)
        local userString = "uv.ptech.killswitch.getclose"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
			-- immediate = true,
			-- critical = true,
        })
    end
}
UV_PT.Skyhammer = {
    Hit = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "uv.ptech.skyhammer.hit"
        local targetString = "uv.ptech.skyhammer.hit.you"

        UV_UI.general.events.CenterNotification({
            text = string.format( (displayMe and UVString( userString )) or UVString( targetString ), (displayMe and UVString( tbl.Target )) or UVString( tbl.User )),
			color = not displayMe and Color(255, 0, 0) or nil,
			immediate = not displayMe and true or nil,
			critical = not displayMe and true or nil,
			time = not displayMe and 3 or 1,
		})
    end,
    Locking = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "uv.ptech.skyhammer.activated"
        local targetString = "uv.ptech.skyhammer.lockingon"

        UV_UI.general.events.CenterNotification({
            text = (displayMe and UVString( userString )) or UVString(targetString),
			color = not displayMe and Color(255, 0, 0) or nil,
			immediate = not displayMe and true or nil,
        })
    end,
    Counter = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end
		local String = "uv.ptech.skyhammer.dodged"
		
        UV_UI.general.events.CenterNotification({
            text = UVString( String ),
        })
    end,
    EngineRestarting = function(tbl)
        local userString = "uv.ptech.killswitch.engine.on"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
			immediate = true,
			critical = true,
			time = 3,
        })
    end
}
UV_PT.ESF = {
    Use = function(tbl)
        local userString = "uv.ptech.esf.activated"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end,
    Deactivate = function(tbl)
        local userString = "ESF Deactivated!"

        -- UV_UI.general.events.CenterNotification({
            -- text = UVString( userString ),
        -- })
    end,
    Hit = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "uv.ptech.esf.hit"
        local targetString = "uv.ptech.esf.hit.you"

        UV_UI.general.events.CenterNotification({
            text = string.format( (displayMe and UVString( userString )) or UVString( targetString ), (displayMe and UVString( tbl.Target )) or UVString( tbl.User )),
        })
    end,
    Counter = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "You ESF-countered %s!"
        local targetString = "%s countered your ESF!"

        UV_UI.general.events.CenterNotification({
            text = string.format( (displayMe and UVString( userString )) or UVString( targetString ), (displayMe and UVString( tbl.Target )) or UVString( tbl.User )),
        })
    end
}
UV_PT.Jammer = {
    Use = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "uv.ptech.jammer.activated"
        local targetString = "uv.ptech.jammer.hit.you"

        UV_UI.general.events.CenterNotification({
            -- text = string.format( (displayMe and UVString( userString )) or UVString( targetString ), (displayMe and UVString( tbl.Target )) or UVString( tbl.User )),
			text = displayMe and UVString( userString ) or UVString( targetString ),
        })
    end,
    Hit = function(...)
        --not used, handled in use
        --print('Hit!', 'Jammer')
    end
}
UV_PT.Shockwave = {
    Hit = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

		local userString = "uv.ptech.shockwave.hit"
		local targetString = "uv.ptech.shockwave.hit.you"

        local display = nil

        if displayMe then
            local targets = tbl.Target or {}
		    local firstName = targets[1] or "UNKNOWN"
		    local extraCount = #targets - 1

		-- Build name string: "Name" or "Name (+X)"
		    display = UVString( firstName )
		    if extraCount > 0 then
			    display = string.format("%s (+%d)", UVString( firstName ), extraCount)
		    end
        else
            display = UVString( tbl.User )
        end

		-- Format text with nameDisplay
		local formattedText = string.format(
			(displayMe and UVString( userString )) or UVString( targetString ),
			display
		)

		-- Trigger notification
		UV_UI.general.events.CenterNotification({
			text = formattedText,
		})

    end,
    Use = function(...)
        local userString = "uv.ptech.shockwave.activated"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end
}
UV_PT.Spikestrip = {
    Use = function(tbl)
        local userString = "uv.ptech.spikes.activated"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end,
    Hit = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

		local userString = "uv.ptech.spikes.hit"
        local targetString = "uv.ptech.spikes.hit.you"

        local display = nil

        if displayMe then
            local targets = tbl.Target or {}
		    local firstName = targets[1] or "UNKNOWN"
		    local extraCount = #targets - 1

		-- Build name string: "Name" or "Name (+X)"
		    display = UVString( firstName )
		    if extraCount > 0 then
			    display = string.format("%s (+%d)", UVString( firstName ), extraCount)
		    end
        else
            display = UVString( tbl.User )
        end

		-- Format text with nameDisplay
		local formattedText = string.format(
			(displayMe and UVString( userString )) or UVString( targetString ),
			display
		)

		-- Trigger notification
		UV_UI.general.events.CenterNotification({
			text = formattedText,
		})

    end,
}
UV_PT.StunMine = {
    Hit = function(tbl)
        --print(tbl.User, tbl.Target)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "uv.ptech.stunmine.hit"
        local targetString = "uv.ptech.stunmine.hit.you"

        UV_UI.general.events.CenterNotification({
            text = string.format( (displayMe and UVString( userString )) or UVString( targetString ), (displayMe and UVString( tbl.Target )) or UVString( tbl.User ) ),
        })
    end,
    Counter = function(tbl)
        -- local displayMe = false
        -- if tbl.User ~= LocalPlayer():Nick() then
            -- displayMe = true
        -- end

        -- local userString = "You Stun mine-countered %s!"
        -- local targetString = "%s countered your stun mine!"

        -- UV_UI.general.events.CenterNotification({
            -- text = string.format( (displayMe and UVString( userString )) or UVString( targetString ), (displayMe and tbl.Target) or tbl.User),
        -- })
    end,
    Use = function(tbl)
        local userString = "uv.ptech.stunmine.activated"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end,
}
UV_PT.RepairKit = {
    Use = function(...)
        local userString = "uv.ptech.repairkit.activated"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end
}
UV_PT.PowerPlay = {
    NoPB = function(...)
        local userString = "uv.ptech.powerplay.nopb"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end,
    Use = function(...)
        local userString = "uv.ptech.powerplay.activated"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end
}
UV_PT.EMP = {
    Hit = function( tbl )
        local user = tbl[1]
        local target = tbl[2]

        local carEntIndex = user[1]
        local carCreationID = user[2]
        local carCallsign = user[3]

        local targetEntIndex = target[1]
        local targetCreationID = target[2]
        local targetCallsign = target[3]

        local target = Entity( targetEntIndex )
        if not IsValid( target ) then return end

        local targetCreationID = target:GetCreationID()
        if targetCreationID ~= targetCreationID then return end

        UVEMPLockingStart = nil
        UVEMPLockingTarget = nil
        UVEMPLockingSource = nil

        local userString = "uv.ptech.emp.hit"
        local isTargetLocal = targetCallsign == LocalPlayer():Nick()

        if isTargetLocal then
            userString = userString .. ".you"
        end

        target:EmitSound( "gadgets/emp/fire.wav", 75, 100, 1, CHAN_STATIC )

        userString = UVString( userString )
        UV_UI.general.events.CenterNotification({
            text = string.format(
                UVString( userString ), 
                ( isTargetLocal and UVString( carCallsign ) ) or UVString( targetCallsign ) 
            ),
        })
    end,
    Missed = function( tbl )
        local userString = "uv.ptech.emp.missed"

        UVEMPLockingStart = nil
        UVEMPLockingTarget = nil
        UVEMPLockingSource = nil

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end,
    Locking = function( tbl )
        local user = tbl[1]
        local target = tbl[2]

        local carEntIndex = user[1]
        local carCreationID = user[2]
        local carCallsign = user[3]

        local targetEntIndex = target[1]
        local targetCreationID = target[2]
        local targetCallsign = target[3]

        local target = Entity( targetEntIndex )
        if not IsValid( target ) then return end

        local targetCreationID = target:GetCreationID()
        if targetCreationID ~= targetCreationID then return end

        local user = Entity( carEntIndex )
        if not IsValid( user ) then return end

        local userCreationID = user:GetCreationID()
        if userCreationID ~= carCreationID then return end

        UVEMPLockingStart = CurTime()
        UVEMPLockingSource = user
        UVEMPLockingTarget = target

        --print('Locking', target)
        local userString = "uv.ptech.emp.lockingon"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end,
    NoTarget = function( tbl )
        local userString = "uv.ptech.emp.notarget"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end
}
UV_PT.ShockRam = {
    Hit = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end
		
		local userString = "uv.ptech.shockram.hit"
		local targetString = "uv.ptech.shockram.hit.you"

        local display = nil

        if displayMe then
            local targets = tbl.Target or {}
		    local firstName = targets[1] or "UNKNOWN"
		    local extraCount = #targets - 1

		-- Build name string: "Name" or "Name (+X)"
		    display = UVString( firstName )
		    if extraCount > 0 then
			    display = string.format("%s (+%d)", UVString( firstName ), extraCount)
		    end
        else
            display = UVString( tbl.User )
        end

		-- Format text with nameDisplay
		local formattedText = string.format(
			(displayMe and UVString( userString )) or UVString( targetString ),
			display
		)

		-- Trigger notification
		UV_UI.general.events.CenterNotification({
			text = formattedText,
		})

    end,
    Use = function(...)
        local userString = "uv.ptech.shockram.activated"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end
}
UV_PT.GPSDart = {
    Use = function(...)
        local userString = "uv.ptech.gpsdart.activated"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end
}
UV_PT.Juggernaut = {
    Use = function(...)
        local userString = "uv.ptech.juggernaut.activated"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end
}
UV_PT.Ghost = {
    Use = function(...)
        local userString = "uv.ptech.ghost.activated"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end
}
UV_PT.Grappler = {
    Use = function(...)
        local userString = "uv.ptech.grappler.activated"

        UV_UI.general.events.CenterNotification({
            text = UVString( userString ),
        })
    end
}

--

function onEvent( self, eventType, ... )
    local event = UV_PT[self] and UV_PT[self][eventType]
    if event then event( ... ) end
end

hook.Add( "onPTEvent", "PT", onEvent )