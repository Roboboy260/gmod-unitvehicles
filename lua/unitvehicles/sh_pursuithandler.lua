AddCSLuaFile()

MAX_HEAT_LEVEL = 10 -- You could theoretically change this :)

local dvd = DecentVehicleDestination

-- wait a few seconds :^)
timer.Simple(5, function()
	physenv.SetPerformanceSettings(
		{
			['MaxVelocity'] = 99999, ['MaxAngularVelocity'] = 99999
		}
	)
end)

--Sound--
local UVSoundSource
local UVSoundLoop
local UVSoundMiscSource
local UVLoadedSounds

local PURSUIT_MUSIC_FILEPATH = "uvpursuitmusic"

local showhud = GetConVar("cl_drawhud")

local SpawnCooldownTable = {}

UV_CurrentSubtitle = ""
UV_SubtitleEnd = 0
UV_CurrentSubtitleCallsign = ""

UVCounterActive = false -- Is the Race or Pursuit countdown active?
local ShouldArchive = (SERVER or game.SinglePlayer()) and FCVAR_ARCHIVE or nil

PT_Slots_Replacement_Strings = {
	[1] = "uv.ptech.slot.right",
	[2] = "uv.ptech.slot.left"
}

local Control_Strings = {
	[1] = "uv.ptech.slot.left",
	[2] = "uv.ptech.slot.right",
	[3] = "uv.keybind.skipsong",
	[4] = "uv.keybind.resetposition",
	[5] = "uv.keybind.showresults"
}

local Colors = {
	['Yellow'] = Color(255, 255, 0),
	['White'] = Color(255, 255, 255),
	['RacerTheme'] = Color(255, 221, 142, 107),
	['RacerThemeShade'] = Color(166, 142, 85, 107),
	['CopTheme'] = Color(61, 184, 255, 107),--Color(148, 142, 255, 107),
	['CopThemeShade'] = Color(41, 149, 212, 107)--Color(93, 85, 166, 107)
}

function UVGetVehicle(driver)
	if not IsValid(driver) then return false end
	
	local seat = driver:GetVehicle()
	if not IsValid(seat) then return false end
	
	if seat.IsSimfphyscar or seat:GetClass() == "prop_vehicle_jeep" then
		return seat
	else
		return seat:GetParent()
	end
	
end

function UVGetDriver(vehicle)
	if not IsValid(vehicle) then return nil end

	if vehicle.IsSimfphyscar or vehicle:GetClass() == "prop_vehicle_jeep" then
		return vehicle:GetDriver()
	elseif vehicle.IsGlideVehicle then
		if not vehicle.seats or next(vehicle.seats) == nil then return nil end

		local seat = vehicle.seats[1]

		if IsValid( seat ) then
			local driver = seat:GetDriver()
			return (IsValid(driver) and driver) or nil
		end
	elseif vehicle.LVS then
		local driverSeat = vehicle:GetDriverSeat()
		if IsValid(driverSeat) then
			return driverSeat:GetDriver()
		end
	end

	return nil
end

function UVGetDriverName(vehicle)
	local driver = UVGetDriver(vehicle)
    local driverName = IsValid(driver) and driver:GetName()

    if not driverName then
        driverName = (vehicle.UnitVehicle and vehicle.UnitVehicle.callsign) or vehicle.racer or 'Racer ' .. vehicle:EntIndex()
    end

	return driverName
end

UVPursuitScopes = {}

UV_SCOPE_DEFAULTS = {
	InPursuit = false,
	InCooldown = false,
	IsEvading = false,
	IsBeingPulledOver = false,
	PursuitStart = 0,
	Heat = 1,
	UnitsChasing = 0,
	Deploys = 0,
	-- PursuitLength = 0,
	Wrecks = 0,
	Tags = 0,
	Bounty = 0,
	EnemyEscaped = false,
	EnemyBusted = false,
	EnemyEscaping = false,
	BountyTimer = 0,
	BountyTimerProgress = 0,
	ComboBounty = 1,
	CooldownTimer = 20,
	CooldownTimerProgress = 0,
	CooldownProgressTimeout = 0,
	BustSpeed = 10,
	Busting = 0,
	BustingProgress = 0,
	BustingLastProgress = 0,
	BustingLastProgress2 = 0,
	Losing = 0,
	TimeTillNextHeatEnd = 0,
	Hiding = false,
	FinesDue = 0,
}

UV_SCOPE_REPLICATED_KEYS = {
	["InPursuit"] = true,
	["InCooldown"] = true,
	["IsEvading"] = true,
	["PursuitStart"] = true,
	["Heat"] = true,
	["UnitsChasing"] = true,
	["Deploys"] = true,
	-- ["PursuitLength"] = true,
	["Wrecks"] = true,
	["Tags"] = true,
	["Bounty"] = true,
	["EnemyEscaped"] = true,
	["EnemyBusted"] = true,
	["EnemyEscaping"] = true,
	--["BountyTimerProgress"] = true,
	["BountyTime"] = true,
	["ComboBounty"] = true,
	["CooldownTimer"] = true,
	["CooldownTimerProgress"] = true,
	["BustSpeed"] = true,
	["BustingProgress"] = true,
	["BustingLastProgress2"] = true,
	["Losing"] = true,
	["TimeTillNextHeatEnd"] = true,
	["Hiding"] = true,
	["IsBeingPulledOver"] = true,
	["FinesDue"] = true
}

function UVScopeKey(veh)
	if not IsValid(veh) then return nil end
	return veh:EntIndex() .. "_" .. veh:GetCreationID()
end

function UVGetScope(veh)
	local key = UVScopeKey(veh)
	if not key then return nil end
	return UVPursuitScopes[key]
end

function UVGetScopeByKey(key)
	if not key then return nil end
	return UVPursuitScopes[key]
end

UVGlobalPursuit = {
	ResourcePoints = 10,
	CommanderActive = false,
	PursuitStart = 0,
}

function UVGetActiveScope()
	if SERVER then return nil end
	local veh = UVGetVehicle(LocalPlayer())
	if not veh then return nil end
	return UVGetScope(veh)
end

function UV_GetActiveBounty()
	local scope = UVGetActiveScope()
	return scope and scope.Bounty or 0
end

function UV_GetActiveHeat()
	local scope = UVGetActiveScope()
	return scope and scope.Heat or 1
end

function UV_GetActiveTimeTillNextHeat()
	local scope = UVGetActiveScope()
	if not scope or scope.TimeTillNextHeatEnd == 0 then return nil end
	return math.max(0, scope.TimeTillNextHeatEnd - CurTime())
end

function UV_GetDominantScope()
	local bestScope = nil
	local bestHeat = 0
	local bestBounty = 0

	for _, scope in pairs(UVPursuitScopes) do
		if scope.InPursuit then
			if scope.Heat > bestHeat or (scope.Heat == bestHeat and scope.Bounty > bestBounty) then
				bestHeat = scope.Heat
				bestBounty = scope.Bounty
				bestScope = scope
			end
		end
	end

	return bestScope
end

function UV_GetInPursuitCount()
	local count = 0
	 
	for _, v in pairs( UVPursuitScopes ) do
		if v.InPursuit then count = count + 1 end
	end

	return count
end

function UV_GetEscapingCount()
	local count = 0
	for _, v in pairs( UVPursuitScopes ) do
		if v.EnemyEscaping then count = count + 1 end
	end
	return count
end

function UV_GetBustedCount()
	local count = 0
	for _, v in pairs( UVPursuitScopes ) do
		if v.EnemyBusted then count = count + 1 end
	end
	return count
end

function UV_GetCopDisplayHeat()
	local scope = UV_GetDominantScope()
	return scope and scope.Heat or 1
end

function UV_GetCopDisplayBounty()
	local scope = UV_GetDominantScope()
	return scope and scope.Bounty or 0
end

function UV_GetCopEvadeProgress()
	local inPursuitCount = 0
	local evadingOrCooldownCount = 0

	for _, scope in pairs(UVPursuitScopes) do
		if scope.InPursuit then
			inPursuitCount = inPursuitCount + 1
			if scope.IsEvading or scope.InCooldown then
				evadingOrCooldownCount = evadingOrCooldownCount + 1
			end
		end
	end

	if inPursuitCount == 0 then return 0 end
	return evadingOrCooldownCount / inPursuitCount
end

function UV_GetCopAllInCooldown()
	local inPursuitCount = 0
	local cooldownCount = 0

	for _, scope in pairs(UVPursuitScopes) do
		if scope.InPursuit then
			inPursuitCount = inPursuitCount + 1
			if scope.InCooldown then
				cooldownCount = cooldownCount + 1
			end
		end
	end

	if inPursuitCount == 0 then return false end
	return cooldownCount == inPursuitCount
end

function UV_IsInCooldown( target )
	local scope = UVGetScope( target )
	return UVEnemyEscaping or ( scope and scope.InCooldown )
end

function UV_InitiatePursuit( target )
	local scope = UVGetScope( target )
	if not scope or scope.InPursuit then return end
	
	UVEndTrafficStop( target )
	scope.InPursuit = true
	scope.EnemyEscaped = false
	scope.EnemyEscaping = false
	scope.InCooldown = false
	scope.Deploys = 0
	scope.Wrecks = 0
	scope.Tags = 0
	scope.Losing = 0
	scope.PursuitStart = CurTime()

	hook.Run('UV_Event', 'onSuspectSpotted', target)
end

--Sound spam check--

function UVDelaySound()
	if UVSoundDelayed then return end
	UVSoundDelayed = true
	timer.Simple(1, function()
		UVSoundDelayed = false
	end)
end

local PursuitFilePathsTable = {}

function PopulatePursuitFilePaths( theme )
	if PursuitFilePathsTable[theme] then return end
	PursuitFilePathsTable[theme] = {}

	local path = PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/"
	
	local function scanFolderRecursive(basePath, tbl)
		local _, folders = file.Find( "sound/" .. basePath .. "*", "GAME")
		for _, folder in pairs(folders) do
			if folder ~= "." and folder ~= ".." then
				local subfolderPath = basePath .. folder .. "/"
				local files2, folders2 = file.Find("sound/" .. subfolderPath .. "*", "GAME")

				if not tbl[folder] then
					tbl[folder] = {}
				end

				if #folders2 == 0 then
					for _, v in pairs( files2 ) do
						table.insert(tbl[folder], subfolderPath .. v)
					end
				else
					for _, v in pairs( folders2 ) do
						tbl[folder][v] = {}
					end
				end

				-- for _, folderName in pairs(folders) do
				-- 	local filePath = subfolderPath .. fileName
				-- 	if not file.IsDir(filePath, "GAME") then
				-- 		table.insert(tbl[folder], filePath)
				-- 	end
				-- end

				-- Recursively scan subfolders
				scanFolderRecursive(subfolderPath, tbl[folder])
			end
		end
	end

	scanFolderRecursive(path, PursuitFilePathsTable[theme])
	-- local introFiles = file.Find(path .. "intro/*", "GAME")
	-- if introFiles and #introFiles > 0 then
	-- 	PursuitFilePathsTable[theme].intro = {}
	-- 	for _, v in ipairs(introFiles) do
	-- 		PursuitFilePathsTable[theme].intro[#PursuitFilePathsTable[theme].intro + 1] = path .. "intro/" .. v	
	-- 	end
	-- end

	-- local transitionFiles = file.Find(path .. "transition/*", "GAME")
	-- if transitionFiles and #transitionFiles > 0 then
	-- 	PursuitFilePathsTable[theme].transition = {}
	-- 	for _, v in ipairs(transitionFiles) do
	-- 		PursuitFilePathsTable[theme].transition[#PursuitFilePathsTable[theme].transition + 1] = path .. "transition/" .. v	
	-- 	end
	-- end

	-- local heatFiles = file.Find(path .. "heat/*", "GAME")
	-- if heatFiles and #heatFiles > 0 then
	-- 	PursuitFilePathsTable[theme].heat = {}
	-- 	for _, v in ipairs(heatFiles) do
	-- 		PursuitFilePathsTable[theme].heat[#PursuitFilePathsTable[theme].heat + 1] = path .. "heat/" .. v	
	-- 	end
	-- end

	-- local bustedFiles = file.Find(path .. "busted/*", "GAME")
	-- if bustedFiles and #bustedFiles > 0 then
	-- 	PursuitFilePathsTable[theme].busted = {}
	-- 	for _, v in ipairs(bustedFiles) do
	-- 		PursuitFilePathsTable[theme].busted[#PursuitFilePathsTable[theme].busted + 1] = path .. "busted/" .. v	
	-- 	end
	-- end

	-- local escapedFiles = file.Find(path .. "escaped/*", "GAME")
	-- if escapedFiles and #escapedFiles > 0 then
	-- 	PursuitFilePathsTable[theme].escaped = {}
	-- 	for _, v in ipairs(escapedFiles) do
	-- 		PursuitFilePathsTable[theme].escaped[#PursuitFilePathsTable[theme].escaped + 1] = path .. "escaped/" .. v	
	-- 	end
	-- end

	return PursuitFilePathsTable[theme]
end
--print("hhahahaha")

function UVSoundHeat(heatlevel)
	if not PlayMusic:GetBool() then return end
	if (not RacingMusicPriority:GetBool()) and RacingMusic:GetBool() and UVHUDDisplayRacing then return end
	if RacingThemeOutsideRace:GetBool() and RacingMusic:GetBool() then UVSoundRacing() return end
	if UVPlayingHeat or UVSoundDelayed then return end

	if timer.Exists("UVPursuitThemeReplay") then
		timer.Remove("UVPursuitThemeReplay")
	end

	heatlevel = heatlevel or 1

	local _lastheatlevel = lastHeatlevel

	if PursuitThemePlayRandomHeat:GetBool() then
		if PursuitThemePlayRandomHeatType:GetString() == "everyminutes" then
			heatlevel = UVSelectedHeatTrack
			_lastheatlevel = UVLastHeatLevel or 1
		else
			heatlevel = math.random( 1, MAX_HEAT_LEVEL )
		end
	end

	if not lastHeatlevel then
		_lastheatlevel = heatlevel
	end

	heatlevel = tostring(heatlevel)
	_lastheatlevel = tostring(_lastheatlevel)

	local theme = PursuitTheme:GetString()

	local soundtable

	-- if UVHeatLevelIncrease then
	-- 	UVPlayingHeat = false
	-- 	soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/transition/*", "GAME")

	-- 	-- Only play if folder exists and has sound files
	-- 	if soundtable and #soundtable > 0 then
	-- 		UVPlaySound("uvpursuitmusic/" .. theme .. "/transition/" .. soundtable[math.random(1, #soundtable)], false)
	-- 	end
	-- else
	-- 	UVPlayingHeat = true
	-- 	soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/" .. heat .. "/*", "GAME")

	-- 	-- Fallback to heat1 if the desired heat folder is missing or empty
	-- 	if not soundtable or #soundtable == 0 then
	-- 		soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/heat1/*", "GAME")
	-- 		if soundtable and #soundtable > 0 then
	-- 			UVPlaySound("uvpursuitmusic/" .. theme .. "/heat1/" .. soundtable[math.random(1, #soundtable)], true)
	-- 		end
	-- 	else
	-- 		UVPlaySound("uvpursuitmusic/" .. theme .. "/" .. heat .. "/" .. soundtable[math.random(1, #soundtable)], true)
	-- 	end
	-- end

	-- timer.Create("UVPursuitThemeRandom", 600, 0, function()
	-- 	if PursuitThemePlayRandomHeat:GetBool() then
	-- 		UVSoundHeat(math.random(1, MAX_HEAT_LEVEL))
	-- 	end
	-- end)

	if not PursuitFilePathsTable[theme] then
		PopulatePursuitFilePaths(theme)
		UVResetRandomHeatTrack()
	end

	if UVHeatLevelIncrease then
		UVHeatLevelIncrease = false
		UVHeatPlayTransition = true
		UVHeatPlayIntro = true
	end
	
	if UVHeatPlayTransition then
		UVHeatPlayTransition = false
		UVHeatPlayMusic = true
	--local transitionArray = (PursuitFilePathsTable[theme].transition and PursuitFilePathsTable[theme].transition[heatlevel]) or {}
		local transitionArray = PursuitFilePathsTable[theme].transition and (PursuitFilePathsTable[theme].transition[_lastheatlevel] or PursuitFilePathsTable[theme].transition["default"]) or {}

		if transitionArray and #transitionArray > 0 then
			table.Shuffle(transitionArray)
			local transitionTrack = transitionArray[1]

			if transitionTrack then
				UVPlaySound(transitionTrack, true)
				UVPlayingHeat = true
			end
		end

		if heatlevel ~= _lastheatlevel then
			lastHeatlevel = tonumber( heatlevel )
		end
	-- local transitionTrack = UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/transition/" .. heatlevel )
	-- if transitionTrack then
	-- 	UVPlaySound(transitionTrack, true)
	-- 	UVPlayingHeat = true
	-- end
	elseif UVHeatPlayIntro then
		UVHeatPlayIntro = false
		UVHeatPlayMusic = true

		--local introArray = (PursuitFilePathsTable[theme].intro and PursuitFilePathsTable[theme].intro[heatlevel]) or {}
		local introArray = (PursuitFilePathsTable[theme].intro and (PursuitFilePathsTable[theme].intro[heatlevel] or PursuitFilePathsTable[theme].intro["default"]))

		if introArray and #introArray > 0 then
			table.Shuffle(introArray)
			local introTrack = introArray[1]

			if introTrack then
				UVPlaySound(introTrack, true)
				UVPlayingHeat = true
			end
		end

		-- local introTrack = UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/intro/" .. heatlevel )
		-- if introTrack then
		-- 	UVPlaySound(introTrack, true)
		-- 	UVPlayingHeat = true
		-- end
	elseif UVHeatPlayMusic then
		-- local musicTrack = UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/heat/" .. heatlevel ) or UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/heat/5" )
		-- if musicTrack then
		-- 	UVPlaySound(musicTrack, true)
		-- 	UVPlayingHeat = true
		-- end

		--local heatArray = (PursuitFilePathsTable[theme].heat and PursuitFilePathsTable[theme].heat[heatlevel]) or {}
		local heatArray = PursuitFilePathsTable[theme].heat and (PursuitFilePathsTable[theme].heat[heatlevel] or PursuitFilePathsTable[theme].heat["default"]) or {}

		if heatArray and #heatArray > 0 then
			table.Shuffle(heatArray)
			local heatTrack = heatArray[1]

			if heatTrack then
				-- if PursuitThemePlayRandomHeat:GetBool() and PursuitThemePlayRandomHeatType:GetString() == "everyminutes" then
				-- 	UVHeatPlayTransition = true
				-- end
				UVPlaySound(heatTrack, true, false)
				UVPlayingHeat = true
			end
		end
	end

	UVPlayingRace = false
	-- UVPlayingHeat is handled above
	UVPlayingBusting = false
	UVPlayingCooldown = false
	UVPlayingBusted = false
	UVPlayingEscaped = false
end

function UVSoundBusting(heatlevel)
	if not PlayMusic:GetBool() then return end
	if (not RacingMusicPriority:GetBool()) and RacingMusic:GetBool() and UVHUDDisplayRacing then return end
	if RacingThemeOutsideRace:GetBool() and RacingMusic:GetBool() then UVSoundRacing() return end
	if UVPlayingBusting or UVSoundDelayed then return end

	if timer.Exists("UVPursuitThemeReplay") then
		timer.Remove("UVPursuitThemeReplay")
	end

	local theme = PursuitTheme:GetString()
	--local soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/busting/*", "GAME")

	-- if not soundtable or #soundtable == 0 then UVSoundHeat( UVHeatLevel ) return end

	-- UVPlaySound("uvpursuitmusic/" .. theme .. "/busting/" .. soundtable[math.random(1, #soundtable)], true)

	heatlevel = heatlevel or 1

	if not PursuitFilePathsTable[theme] then
		PopulatePursuitFilePaths(theme)
		UVResetRandomHeatTrack()
	end

	if PursuitThemePlayRandomHeat:GetBool() then
		if PursuitThemePlayRandomHeatType:GetString() == "everyminutes" then
			heatlevel = UVSelectedHeatTrack
		else
			heatlevel = math.random( 1, MAX_HEAT_LEVEL )
		end
	end

	heatlevel = tostring(heatlevel)


	-- local bustingSound = UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/busting/" .. heatlevel ) or UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/busting/5" )
	-- if bustingSound then
	-- 	UVPlaySound(bustingSound, true)
	-- else
	-- 	UVSoundHeat( UVHeatLevel )
	-- 	return
	-- end
	
	--local bustingArray = (PursuitFilePathsTable[theme].busting and PursuitFilePathsTable[theme].busting[heatlevel]) or {}
	local bustingArray = PursuitFilePathsTable[theme].busting and (PursuitFilePathsTable[theme].busting[heatlevel] or PursuitFilePathsTable[theme].busting["default"]) or {}

	if bustingArray and #bustingArray > 0 then
		table.Shuffle(bustingArray)
		local bustingTrack = bustingArray[1]

		if bustingTrack then
			UVHeatPlayIntro = false
			UVHeatPlayTransition = false
			UVPlaySound(bustingTrack, true)
		else
			UVSoundHeat( UVHeatLevel )
			return
		end
	else
		UVSoundHeat( UVHeatLevel )
		return
	end

	UVPlayingRace = false
	UVPlayingHeat = false
	UVPlayingBusting = true
	UVPlayingCooldown = false
	UVPlayingBusted = false
	UVPlayingEscaped = false
end

function UVSoundCooldown(heatlevel)
	if not PlayMusic:GetBool() then return end
	if (not RacingMusicPriority:GetBool()) and RacingMusic:GetBool() and UVHUDDisplayRacing then return end
	if RacingThemeOutsideRace:GetBool() and RacingMusic:GetBool() then UVSoundRacing() return end
	if UVPlayingCooldown or UVSoundDelayed then return end

	if timer.Exists("UVPursuitThemeReplay") then
		timer.Remove("UVPursuitThemeReplay")
	end

	local theme = PursuitTheme:GetString()
	heatlevel = heatlevel or 1

	if not PursuitFilePathsTable[theme] then
		PopulatePursuitFilePaths(theme)
		UVResetRandomHeatTrack()
	end

	if PursuitThemePlayRandomHeat:GetBool() then
		if PursuitThemePlayRandomHeatType:GetString() == "everyminutes" then
			heatlevel = UVSelectedHeatTrack
		else
			heatlevel = math.random( 1, MAX_HEAT_LEVEL )
		end
	end

	heatlevel = tostring(heatlevel)

	local appendingString = "low"

	local vehicle = LocalPlayer():GetVehicle()
	local isValid = IsValid(vehicle)
	local physObj = nil
	if isValid then
		vehicle = IsValid(vehicle:GetParent()) and vehicle:GetParent() or vehicle
		physObj = IsValid(vehicle:GetPhysicsObject()) and vehicle:GetPhysicsObject() or vehicle
	end


	appendingString = (physObj and physObj:GetVelocity():LengthSqr() > 500000) and "high" or "low"

	local cooldownArray = PursuitFilePathsTable[theme].cooldown and (PursuitFilePathsTable[theme].cooldown[heatlevel] or PursuitFilePathsTable[theme].cooldown["default"])
	cooldownArray = cooldownArray and cooldownArray[appendingString or 'low'] or (cooldownArray and cooldownArray['default'] or {})

	if cooldownArray and #cooldownArray > 0 then
		table.Shuffle(cooldownArray)
		local cooldownTrack = cooldownArray[1]

		if cooldownTrack then
			UVPlaySound(cooldownTrack, true)
		else
			UVSoundHeat( UVHeatLevel )
			return
		end
	else
		UVSoundHeat( UVHeatLevel )
		return
	end

	UVPlayingRace = false
	UVPlayingHeat = false
	UVPlayingBusting = false
	UVPlayingCooldown = true
	UVPlayingBusted = false
	UVPlayingEscaped = false
end

function UVSoundBusted(heatlevel)
	if not PlayMusic:GetBool() then return end
	if UVPlayingBusted or UVSoundDelayed then return end

	if timer.Exists("UVPursuitThemeReplay") then
		timer.Remove("UVPursuitThemeReplay")
	end

	if UVSoundLoop then
		UVStopSound()
		UVLoadedSounds = nil
		UVSoundLoop:Stop()
		UVSoundLoop = nil
	end

	local theme = PursuitTheme:GetString()
	heatlevel = heatlevel or 1

	if PursuitThemePlayRandomHeat:GetBool() then
		if PursuitThemePlayRandomHeatType:GetString() == "everyminutes" then
			heatlevel = UVSelectedHeatTrack
		else
			heatlevel = math.random( 1, MAX_HEAT_LEVEL )
		end
	end

	heatlevel = tostring(heatlevel)

	if not PursuitFilePathsTable[theme] then
		PopulatePursuitFilePaths(theme)
		UVResetRandomHeatTrack()
	end

	local bustedArray = PursuitFilePathsTable[theme].busted and (PursuitFilePathsTable[theme].busted[heatlevel] or PursuitFilePathsTable[theme].busted["default"]) or {}

	if bustedArray and #bustedArray > 0 then
		table.Shuffle(bustedArray)
		local bustedTrack = bustedArray[1]

		if bustedTrack then
			UVPlaySound(bustedTrack, false, true, nil, true)
		else
			UVSoundHeat( UVHeatLevel )
			return
		end
	else
		return
	end

	UVPlayingRace = false
	UVPlayingHeat = false
	UVPlayingBusting = false
	UVPlayingCooldown = false
	UVPlayingBusted = true
	UVPlayingEscaped = true
end

function UVSoundEscaped(heatlevel)
	if not PlayMusic:GetBool() then return end
	if (not RacingMusicPriority:GetBool()) and RacingMusic:GetBool() and UVHUDDisplayRacing then return end
	if RacingThemeOutsideRace:GetBool() and RacingMusic:GetBool() then UVSoundRacing() return end
	if UVPlayingEscaped or UVSoundDelayed then return end

	if timer.Exists("UVPursuitThemeReplay") then
		timer.Remove("UVPursuitThemeReplay")
	end

	if UVSoundLoop then
		UVSoundLoop:Stop()
		UVSoundLoop = nil
	end

	local theme = PursuitTheme:GetString()
	heatlevel = heatlevel or 1

	if PursuitThemePlayRandomHeat:GetBool() then
		if PursuitThemePlayRandomHeatType:GetString() == "everyminutes" then
			heatlevel = UVSelectedHeatTrack
		else
			heatlevel = math.random( 1, MAX_HEAT_LEVEL )
		end
	end

	heatlevel = tostring(heatlevel)

	if not PursuitFilePathsTable[theme] then
		PopulatePursuitFilePaths(theme)
		UVResetRandomHeatTrack()
	end

	local escapedArray = PursuitFilePathsTable[theme].escaped and (PursuitFilePathsTable[theme].escaped[heatlevel] or PursuitFilePathsTable[theme].escaped["default"]) or {}

	if escapedArray and #escapedArray > 0 then
		table.Shuffle(escapedArray)
		local escapedTrack = escapedArray[1]

		if escapedTrack then
			UVPlaySound( escapedTrack, false, false, nil, true )
		else
			UVSoundHeat( UVHeatLevel )
			return
		end
	else
		UVSoundHeat( UVHeatLevel )
		return
	end

	UVPlayingRace = false
	UVPlayingHeat = false
	UVPlayingBusting = false
	UVPlayingCooldown = false
	UVPlayingBusted = true
	UVPlayingEscaped = true
end
 
if CLIENT then
	cvars.RemoveChangeCallback("unitvehicle_pursuitthemevolume", "UV_PursuitVolumeChanged")
	cvars.AddChangeCallback("unitvehicle_pursuitthemevolume", function(convar, old, new)
		local vol = tonumber(new)
		if not vol then return end

		if IsValid(UVSoundLoop) then
			UVSoundLoop:SetVolume(vol)
		end

		if IsValid(UVSoundSource) then
			UVSoundSource:SetVolume(vol)
		end
	end, "UV_PursuitVolumeChanged")
end
 
function UVInitSound( src, loop, stoploop, timeout, applyMusicVolume )
	if not IsValid(src) then UVStopSound() return end

	if loop then
		UVSoundLoop = src
		src:SetVolume(PursuitVolume:GetFloat())
	else
		UVSoundSource = src
	end

	if applyMusicVolume then
		src:SetVolume(PursuitVolume:GetFloat())
	end

	src:EnableLooping(loop)
	src:Play()

	local duration = src:GetLength()

	if duration > 0 then
		expectedEndTime = RealTime() + duration + (timeout or 0)
	end

	UVLoadedSounds = src

	UVDelaySound()
	hook.Remove("Think", "CheckSoundFinished")
	
	hook.Add("Think", "CheckSoundFinished", function()
		if expectedEndTime then
			if RealTime() >= expectedEndTime then
				hook.Remove("Think", "CheckSoundFinished")
				UVStopSound()
			end
		end
	end)
end

function UVPlaySound( FileName, Loop, StopLoop, Timeout, applyMusicVolume, func )
	if UVLoadedSounds ~= FileName then
		if Loop or StopLoop then
			if UVSoundLoop then
				UVSoundLoop:Stop()
				UVSoundLoop = nil
			end
		else
			if UVSoundSource then
				UVSoundSource:Stop()
				UVSoundSource = nil
			end
		end
	end 

	local expectedEndTime

	UVDelaySound()

	if UVLoadedSounds ~= FileName or (not UVSoundLoop) then
		sound.PlayFile("sound/"..FileName, "noblock", function(source, err, errname)
			if func and source then func() end
			UVInitSound(source, Loop, StopLoop, Timeout, applyMusicVolume)
		end)
	end
end

function UVStopSound()
	UVPlayingRace = false
	UVPlayingHeat = false
	UVPlayingBusting = false
	UVPlayingCooldown = false
	UVPlayingBusted = false
	UVPlayingEscaped = false
	UVSoundDelayed = false
end

function UVDisplayTime(time)
	time = time or 0
	local formattedtime
	local hours = math.floor( time / 3600 )
	if hours < 1 then
		formattedtime = string.FormattedTime( time, "%02i:%02i.%02i" )
	else --1 hour pursuit challenge completed
		formattedtime = hours..":"..string.FormattedTime( time, "%02i:%02i.%02i" )
	end
	return formattedtime
end

HEAT_SETTINGS = {
	'bountytime',
	'timetillnextheat',
	'heatminimumbounty',
	'maxunits',
	'unitsavailable',
	'bustspeed',
	'backuptimer',
	'cooldowntimer',
	'roadblocks',
	'roadblocks_chance',
	'helicopters',
	'helicopters_chance',
	'helicopters_limit'
}

HEAT_DEFAULTS = {
	['maxunits'] = {
		['1'] = 2,
		['2'] = 4,
		['3'] = 6,
		['4'] = 8,
		['5'] = 10,
		['6'] = 10,
		['7'] = 10,
		['8'] = 10,
		['9'] = 10,
		['10'] = 10
	},
	['bountytime'] = {
		['1'] = 1000,
		['2'] = 5000,
		['3'] = 10000,
		['4'] = 50000,
		['5'] = 100000,
		['6'] = 500000,
		['7'] = 1000000,
		['8'] = 5000000,
		['9'] = 10000000,
		['10'] = 50000000
	},
	['timetillnextheat'] = {
		['Enabled'] = 0,
		['1'] = 120,
		['2'] = 120,
		['3'] = 180,
		['4'] = 180,
		['5'] = 240,
		['6'] = 240,
		['7'] = 300,
		['8'] = 300,
		['9'] = 360,
	},
	['heatminimumbounty'] = {
		['1'] = 1000,
		['2'] = 10000,
		['3'] = 50000,
		['4'] = 250000,
		['5'] = 1000000,
		['6'] = 5000000,
		['7'] = 7500000,
		['8'] = 10000000,
		['9'] = 25000000,
		['10'] = 50000000
	},
	['unitsavailable'] = {
		['1'] = 10,
		['2'] = 20,
		['3'] = 30,
		['4'] = 40,
		['5'] = 50,
		['6'] = 60,
		['7'] = 70,
		['8'] = 80,
		['9'] = 90,
		['10'] = 100
	},
	['bustspeed'] = {
		['1'] = 10,
		['2'] = 10,
		['3'] = 15,
		['4'] = 15,
		['5'] = 20,
		['6'] = 20,
		['7'] = 20,
		['8'] = 20,
		['9'] = 20,
		['10'] = 20
	},
	['backuptimer'] = {
		['1'] = 120,
		['2'] = 120,
		['3'] = 90,
		['4'] = 90,
		['5'] = 60,
		['6'] = 60,
		['7'] = 60,
		['8'] = 60,
		['9'] = 60,
		['10'] = 60
	},
	['cooldowntimer'] = {
		['1'] = 20,
		['2'] = 40,
		['3'] = 60,
		['4'] = 80,
		['5'] = 100,
		['6'] = 120,
		['7'] = 140,
		['8'] = 160,
		['9'] = 180,
		['10'] = 200
	},
	['roadblocks'] = {
		['1'] = 0,
		['2'] = 1,
		['3'] = 1,
		['4'] = 1,
		['5'] = 1,
		['6'] = 1,
		['7'] = 1,
		['8'] = 1,
		['9'] = 1,
		['10'] = 1
	},
	['roadblocks_chance'] = {
		['1'] = 0,
		['2'] = 10,
		['3'] = 20,
		['4'] = 30,
		['5'] = 40,
		['6'] = 50,
		['7'] = 60,
		['8'] = 70,
		['9'] = 80,
		['10'] = 90
	},
	['helicopters'] = {
		['1'] = 0,
		['2'] = 0,
		['3'] = 0,
		['4'] = 1,
		['5'] = 1,
		['6'] = 1,
		['7'] = 1,
		['8'] = 1,
		['9'] = 1,
		['10'] = 1
	},
	['helicopters_chance'] = {
		['1'] = 0,
		['2'] = 0,
		['3'] = 0,
		['4'] = 10,
		['5'] = 20,
		['6'] = 30,
		['7'] = 40,
		['8'] = 50,
		['9'] = 60,
		['10'] = 70
	},
	['helicopters_limit'] = {
		['1'] = 0,
		['2'] = 0,
		['3'] = 0,
		['4'] = 1,
		['5'] = 1,
		['6'] = 2,
		['7'] = 2,
		['8'] = 2,
		['9'] = 2,
		['10'] = 2
	}
}

local PRESET_MAP = {
	['uvunitmanager'] = {},
	['uvpursuittech'] = {}
}

local PRESET_START_CONVARS = {
	['uvunitmanager'] = {
		'unitvehicle_unit_',
		'uvunitmanager_'
	}
}

local conVarList = PRESET_MAP['uvunitmanager']
UVUnitsConVars = conVarList

conVarList["selected_heat"] = 1

conVarList["vehiclebase"] = 3
conVarList["commanderrepair"] = 1
conVarList["onecommanderhealth"] = 5000
conVarList["helicoptermodel"] = "Default"
conVarList["helicopterbarrels"] = 1
conVarList["helicopterspikestrip"] = 1
conVarList["helicopterskyhammer"] = 1
conVarList["helicopterbusting"] = 1
conVarList["helicopterminfuel"] = 60
conVarList["helicoptermaxfuel"] = 180

conVarList["pursuittech"] = 1
conVarList["pursuittech_esf"] = 1
conVarList["pursuittech_emp"] = 1
conVarList["pursuittech_spikestrip"] = 1
conVarList["pursuittech_killswitch"] = 1
conVarList["pursuittech_repairkit"] = 1
conVarList["pursuittech_shockram"] = 1
conVarList["pursuittech_gpsdart"] = 1
conVarList["pursuittech_grappler"] = 1

conVarList["minheat"] = 1
conVarList["maxheat"] = 6

conVarList["bountypatrol"] = 1000
conVarList["bountysupport"] = 5000
conVarList["bountypursuit"] = 10000
conVarList["bountyinterceptor"] = 20000
conVarList["bountyair"] = 75000
conVarList["bountyspecial"] = 25000
conVarList["bountycommander"] = 100000
conVarList["bountyrhino"] = 50000

local defaultdrivermodeltable = {
	"police.json, police_fem.json", --Patrol
	"police.json, police_fem.json", --Support
	"police.json, police_fem.json", --Pursuit
	"police.json, police_fem.json", --Interceptor
	"combine_soldier.json", --Special
	"combine_super_soldier.json", --Commander
	"combine_soldier_prisonguard.json", --Rhino
}

local defaultvoicetable = {
	"cop1, cop2, cop3, cop4, cop5, cop6, cop7, cop8", --Patrol
	"cop1, cop2, cop3, cop4, cop5, cop6, cop7, cop8", --Support
	"cop1, cop2, cop3, cop4, cop5, cop6, cop7, cop8", --Pursuit
	"cop1, cop2, cop3, cop4, cop5, cop6, cop7, cop8", --Interceptor
	"cop1, cop2, cop3, cop4, cop5, cop6, cop7, cop8", --Special
	"commander1", --Commander
	"cop1, cop2, cop3, cop4, cop5, cop6, cop7, cop8", --Rhino
	"air1", --Air
}

for index, v in pairs( {'Patrol', 'Support', 'Pursuit', 'Interceptor', 'Special', 'Commander', 'Rhino', 'Air'} ) do
	local lowercaseUnit = string.lower( v )
	local conVarKey = string.format( '%s_voice', lowercaseUnit )
	local conVarKeyVoiceProfile = string.format( '%s_voiceprofile', lowercaseUnit )
	conVarList[conVarKey] = defaultvoicetable[index]
	conVarList[conVarKeyVoiceProfile] = "default"
end

for _, v in pairs( {'Misc', 'Dispatch'} ) do
	local lowercaseType = string.lower( v )
	local conVarKey = string.format( '%s_voiceprofile', lowercaseType )
	conVarList[conVarKey] = "default"
end

for index, v in pairs( {'Patrol', 'Support', 'Pursuit', 'Interceptor', 'Special', 'Commander', 'Rhino'} ) do
	local lowercaseUnit = string.lower( v )
	local conVarKey = string.format( '%s_drivermodel', lowercaseUnit )
	local conVarKeyDriverModelProfile = string.format( '%s_drivermodel', lowercaseUnit )
	conVarList[conVarKey] = defaultdrivermodeltable[index]
	conVarList[conVarKeyDriverModelProfile] = "default"
end

local unitsheat1 = {
	"default_crownvic.json", --Patrol
	"", --Support
	"", --Pursuit
	"", --Interceptor
	"", --Special
	"", --Commander
	"" --Rhino
}

local unitsheat2 = {
	"default_crownvic.json", --Patrol
	"default_explorer.json", --Support
	"", --Pursuit
	"", --Interceptor
	"", --Special
	"", --Commander
	"" --Rhino
}

local unitsheat3 = {
	"default_crownvic.json", --Patrol
	"default_explorer.json", --Support
	"default_chargerbee.json", --Pursuit
	"", --Interceptor
	"", --Special
	"", --Commander
	"" --Rhino
}

local unitsheat4 = {
	"", --Patrol
	"default_explorer.json", --Support
	"default_chargerbee.json", --Pursuit
	"default_corvettec7.json", --Interceptor
	"", --Special
	"", --Commander
	"" --Rhino
}

local unitsheat5 = {
	"", --Patrol
	"", --Support
	"default_chargerbee.json", --Pursuit
	"default_corvettec7.json", --Interceptor
	"default_coloradozr2.json", --Special
	"default_viperelite.json", --Commander
	"default_rhinotruck.json" --Rhino
}

local unitsheat6 = {
	"", --Patrol
	"", --Support
	"", --Pursuit
	"default_corvettec7.json", --Interceptor
	"default_coloradozr2.json", --Special
	"default_viperelite.json", --Commander
	"default_rhinotruck.json" --Rhino
}

for i = 1, MAX_HEAT_LEVEL do
	local prevIterator = i - 1
	
	local timeTillNextHeatId = ((prevIterator == 0 and 'enabled') or prevIterator)
	
	for index, v in pairs( {'Patrol', 'Support', 'Pursuit', 'Interceptor', 'Special', 'Commander', 'Rhino'} ) do
		local lowercaseUnit = string.lower( v )
		local conVarKey = string.format( 'units%s%s', lowercaseUnit, i )
		local chanceConVarKey = string.format( 'units%s%s_chance', lowercaseUnit, i )
		local limitConVarKey = string.format( 'units%s%s_limit', lowercaseUnit, i )
		
		-------------------------------------------
		if i == 1 then
			conVarList[conVarKey] = unitsheat1[index]
		elseif i == 2 then
			conVarList[conVarKey] = unitsheat2[index]
		elseif i == 3 then
			conVarList[conVarKey] = unitsheat3[index]
		elseif i == 4 then
			conVarList[conVarKey] = unitsheat4[index]
		elseif i == 5 then
			conVarList[conVarKey] = unitsheat5[index]
		elseif i == 6 then
			conVarList[conVarKey] = unitsheat6[index]
		else
			conVarList[conVarKey] = ""
		end
		
		conVarList[chanceConVarKey] = 100
		conVarList[limitConVarKey] = 0
	end
	
	for _, conVar in pairs( HEAT_SETTINGS ) do
		local conVarKey = conVar .. ((conVar == 'timetillnextheat' and timeTillNextHeatId) or i)
		local check = (conVar == "timetillnextheat")
		
		conVarList[conVarKey] = HEAT_DEFAULTS[conVar][tostring( ( check and timeTillNextHeatId ) or i )] or 0
	end
end

local LEGACY_CONVARS = {
	["rhinos"] = {
		Replacement = "unitsrhino",
		HasNumber = true,
	},
}

local PROTECTED_CONVARS = {
	['selected_heat'] = true,
}

local DEFAULTS = {
	['selected_heat'] = 1,
	['minheat'] = 1,
	['maxheat'] = 6
}

NETWORK_STRINGS = {
	"UV_SendPursuitTech"
}

-- ========================
-- Racer Pursuit Tech ConVars
-- ========================
-- PT Duration
UVPTPTDuration = CreateConVar("uvpursuittech_ptduration", 60, {FCVAR_ARCHIVE, FCVAR_REPLICATED})

-- ESF
UVPTESFDuration = CreateConVar("uvpursuittech_esf_duration", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTESFPower = CreateConVar("uvpursuittech_esf_power", 1000000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTESFDamage = CreateConVar("uvpursuittech_esf_damage", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTESFCommanderDamage = CreateConVar("uvpursuittech_esf_damagecommander", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTESFMaxAmmo = CreateConVar("uvpursuittech_esf_maxammo", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
UVPTESFCooldown = CreateConVar("uvpursuittech_esf_cooldown", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")

-- Jammer
UVPTJammerDuration = CreateConVar("uvpursuittech_jammer_duration", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTJammerMaxAmmo = CreateConVar("uvpursuittech_jammer_maxammo", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
UVPTJammerCooldown = CreateConVar("uvpursuittech_jammer_cooldown", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")

-- Shockwave
UVPTShockwavePower = CreateConVar("uvpursuittech_shockwave_power", 1000000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTShockwaveDamage = CreateConVar("uvpursuittech_shockwave_damage", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTShockwaveCommanderDamage = CreateConVar("uvpursuittech_shockwave_damagecommander", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTShockwaveMaxAmmo = CreateConVar("uvpursuittech_shockwave_maxammo", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
UVPTShockwaveCooldown = CreateConVar("uvpursuittech_shockwave_cooldown", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")

-- Spike Strip
UVPTSpikestripDamage = CreateConVar("uvpursuittech_spikestrip_damage", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTSpikestripCommanderDamage = CreateConVar("uvpursuittech_spikestrip_damagecommander", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTSpikeStripDuration = CreateConVar("uvpursuittech_spikestrip_duration", 60, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTSpikeStripMaxAmmo = CreateConVar("uvpursuittech_spikestrip_maxammo", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
UVPTSpikeStripCooldown = CreateConVar("uvpursuittech_spikestrip_cooldown", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")

-- Stun Mine
UVPTStunMinePower = CreateConVar("uvpursuittech_stunmine_power", 1000000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTStunMineDamage = CreateConVar("uvpursuittech_stunmine_damage", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTStunMineCommanderDamage = CreateConVar("uvpursuittech_stunmine_damagecommander", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTStunMineMaxAmmo = CreateConVar("uvpursuittech_stunmine_maxammo", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
UVPTStunMineCooldown = CreateConVar("uvpursuittech_stunmine_cooldown", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")

-- EMP
UVPTEMPDamage = CreateConVar("uvpursuittech_emp_damage", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTEMPCommanderDamage = CreateConVar("uvpursuittech_emp_damagecommander", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTEMPForce = CreateConVar("uvpursuittech_emp_force", 100, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTEMPMaxAmmo = CreateConVar("uvpursuittech_emp_maxammo", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
UVPTEMPCooldown = CreateConVar("uvpursuittech_emp_cooldown", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")
UVPTEMPMaxDistance = CreateConVar("uvpursuittech_emp_maxdistance", 1000, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Distance")

-- Juggernaut
UVPTJuggernautDuration = CreateConVar("uvpursuittech_juggernaut_duration", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTJuggernautMaxAmmo = CreateConVar("uvpursuittech_juggernaut_maxammo", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
UVPTJuggernautCooldown = CreateConVar("uvpursuittech_juggernaut_cooldown", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")

-- Ghost
UVPTGhostDuration = CreateConVar("uvpursuittech_ghost_duration", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPTGhostMaxAmmo = CreateConVar("uvpursuittech_ghost_maxammo", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
UVPTGhostCooldown = CreateConVar("uvpursuittech_ghost_cooldown", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")

-- RepairKit
UVPTRepairKitMaxAmmo = CreateConVar("uvpursuittech_repairkit_maxammo", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
UVPTRepairKitCooldown = CreateConVar("uvpursuittech_repairkit_cooldown", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")

-- Powerplay
UVPTPowerPlayMaxAmmo = CreateConVar("uvpursuittech_powerplay_maxammo", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
UVPTPowerPlayCooldown = CreateConVar("uvpursuittech_powerplay_cooldown", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")

-- ========================
-- Unit Pursuit Tech ConVars
-- ========================
-- PT Duration
UVUnitPTDuration = CreateConVar("uvpursuittech_ptduration_unit", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED})

-- ESF
UVUnitPTESFDuration = CreateConVar("uvpursuittech_esf_duration_unit", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTESFPower = CreateConVar("uvpursuittech_esf_power_unit", 1000000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTESFDamage = CreateConVar("uvpursuittech_esf_damage_unit", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTESFMaxAmmo = CreateConVar("uvpursuittech_esf_maxammo_unit", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Pursuit Tech Max Ammo")
UVUnitPTESFCooldown = CreateConVar("uvpursuittech_esf_cooldown_unit", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Pursuit Tech Cooldown")

-- Spike Strip
UVUnitPTSpikeStripDamage = CreateConVar("uvpursuittech_spikestrip_damage_unit", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTSpikeStripDuration = CreateConVar("uvpursuittech_spikestrip_duration_unit", 60, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTSpikeStripMaxAmmo = CreateConVar("uvpursuittech_spikestrip_maxammo_unit", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Pursuit Tech Max Ammo")
UVUnitPTSpikeStripCooldown = CreateConVar("uvpursuittech_spikestrip_cooldown_unit", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Pursuit Tech Cooldown")
UVUnitPTSpikeStripRoadblockFriendlyFire = CreateConVar("unitvehicle_spikestriproadblockfriendlyfire",0,{FCVAR_ARCHIVE, FCVAR_REPLICATED})

-- KillSwitch
UVUnitPTKillSwitchLockOnTime = CreateConVar("uvpursuittech_killswitch_lockontime_unit", 3, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTKillSwitchDisableDuration = CreateConVar("uvpursuittech_killswitch_disableduration_unit", 2.5, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTKillSwitchMaxAmmo = CreateConVar("uvpursuittech_killswitch_maxammo_unit", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTKillSwitchCooldown = CreateConVar("uvpursuittech_killswitch_cooldown_unit", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED})

-- EMP
UVUnitPTEMPDamage = CreateConVar("uvpursuittech_emp_damage_unit", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTEMPForce = CreateConVar("uvpursuittech_emp_force_unit", 100, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTEMPMaxAmmo = CreateConVar("uvpursuittech_emp_maxammo_unit", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTEMPCooldown = CreateConVar("uvpursuittech_emp_cooldown_unit", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTEMPMaxDistance = CreateConVar("uvpursuittech_emp_maxdistance_unit", 1000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})

-- RepairKit
UVUnitPTRepairKitMaxAmmo = CreateConVar("uvpursuittech_repairkit_maxammo_unit", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
UVUnitPTRepairKitCooldown = CreateConVar("uvpursuittech_repairkit_cooldown_unit", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")

-- ShockRam
UVUnitPTShockRamPower = CreateConVar("uvpursuittech_shockram_power_unit", 1000000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTShockRamDamage = CreateConVar("uvpursuittech_shockram_damage_unit", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTShockRamMaxAmmo = CreateConVar("uvpursuittech_shockram_maxammo_unit", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTShockRamCooldown = CreateConVar("uvpursuittech_shockram_cooldown_unit", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED})

-- GPS Dart
UVUnitPTGPSDartDuration = CreateConVar("uvpursuittech_gpsdart_duration_unit", 300, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTGPSDartMaxAmmo = CreateConVar("uvpursuittech_gpsdart_maxammo_unit", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTGPSDartCooldown = CreateConVar("uvpursuittech_gpsdart_cooldown_unit", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED})

-- Grappler
UVUnitPTGrapplerDuration = CreateConVar("uvpursuittech_grappler_duration_unit", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTGrapplerDisableDuration = CreateConVar("uvpursuittech_grappler_disableduration_unit", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTGrapplerLength = CreateConVar("uvpursuittech_grappler_length_unit", 1000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTGrapplerStrength = CreateConVar("uvpursuittech_grappler_strength_unit", 10000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTGrapplerMaxAmmo = CreateConVar("uvpursuittech_grappler_maxammo_unit", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUnitPTGrapplerCooldown = CreateConVar("uvpursuittech_grappler_cooldown_unit", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED})

HeatLevels = CreateConVar("unitvehicle_heatlevels", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "If set to 1, Heat Levels will increase from its minimum value to its maximum value during a pursuit." )
if SERVER then HeatLevels:SetBool(true) end
DetectionRange = CreateConVar("unitvehicle_detectionrange", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Minimum spawning distance to the vehicle in studs when manually spawning Units. Use greater values if you have trouble spawning Units.")
NeverEvade = CreateConVar("unitvehicle_neverevade", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, you won't be able to evade the Unit Vehicles. Good luck.")
BustedTimer = CreateConVar("unitvehicle_bustedtimer", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Time in seconds before the enemy gets busted. Set this to 0 to disable.")
SpawnCooldown = CreateConVar("unitvehicle_spawncooldown", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Time in seconds before player units can spawn again. Set this to 0 to disable.")
CanWreck = CreateConVar("unitvehicle_canwreck", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Unit Vehicles can crash out. Set this to 0 to disable.")
Chatter = CreateConVar("unitvehicle_chatter", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units' radio chatter can be heard.")
SpeedLimit = CreateConVar("unitvehicle_speedlimit", 60, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Speed limit in MPH for idle Units to enforce. Patrolling Units still enforces speed limits set on DV Waypoints. Set this to 0 to disable.")
AutoHealthRacer = CreateConVar("unitvehicle_autohealthracer", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, all racers will have unlimited vehicle health and your health as a racer will be set according to your vehicle's mass.")
AutoHealth = CreateConVar("unitvehicle_autohealth", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, all suspects will have unlimited vehicle health and your health as a suspect will be set according to your vehicle's mass.")
WheelsDetaching = CreateConVar("unitvehicle_wheelsdetaching", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, wrecked vehicles will have their wheels detached.")
MinHeatLevel = CreateConVar("unitvehicle_unit_minheat", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Sets the minimum Heat Level achievable during pursuits (1-6). Use high Heat Levels for more aggressive Units on your tail and vice versa.")
MaxHeatLevel = CreateConVar("unitvehicle_unit_maxheat", 6, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Sets the maximum Heat Level achievable during pursuits (1-6). Use low Heat Levels for less aggressive Units on your tail and vice versa.")
SpikeStripDuration = CreateConVar("unitvehicle_spikestripduration", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicle: Time in seconds before the tires gets reinflated after hitting the spikes. Set this to 0 to disable reinflating tires.")
Pathfinding = CreateConVar("unitvehicle_pathfinding", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units uses A* pathfinding algorithm on navmesh/Decent Vehicle Waypoints to navigate. Impacts computer performance.")
VCModELSPriority = CreateConVar("unitvehicle_vcmodelspriority", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units using base HL2 vehicles will attempt to use VCMod ELS over Photon if both are installed.")
CallResponse = CreateConVar("unitvehicle_callresponse", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units will spawn and respond to the location regarding various calls.")
Headlights = CreateConVar("unitvehicle_enableheadlights", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: AI Vehicles will shine their headlights. 0 = Off, 1 = Automatic, 2 = Always on")
UseNitrousRacer = CreateConVar("unitvehicle_usenitrousracer", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Racer vehicles will use nitrous.")
UseNitrousUnit = CreateConVar("unitvehicle_usenitrousunit", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Unit vehicles will use nitrous.")
CustomizeRacer = CreateConVar("unitvehicle_customizeracer", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Randomizes color/skin/bodygroups when spawning AI Racers")
SpawnMainUnits = CreateConVar("unitvehicle_spawnmainunits", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, main AI Units (Patrol, Support, etc.) will spawn to patrol/chase.")
DVWaypointsPriority = CreateConVar("unitvehicle_dvwaypointspriority", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units will attempt to navigate on Decent Vehicle Waypoints FIRST instead of navmesh (if both are installed).")
DVWaypointsDistanceBased = CreateConVar("unitvehicle_dvwaypointsdistancebased", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units will use a distance-based approach to navigate on Decent Vehicle Waypoints. 0 = Direct engaging when suspect is in view, 1 = Navigate via waypoints if too far from suspect.")
DVNavigationOptimized = CreateConVar("unitvehicle_dvnavioptimized", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: EXPERIMENTAL! If set to 1, when navigating on DV Waypoints an optimized pathfinding algorithm will be used. Disable if you are encountering issues with Units navigating.")
RepairCooldown = CreateConVar("unitvehicle_repaircooldown", 60, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicle: Time in seconds between each repair. Set this to 0 to make all repair shops a one-time use.")
RepairRange = CreateConVar("unitvehicle_repairrange", 100, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicle: Distance in studs between the repair shop and the vehicle to repair.")
-- RacerTags = CreateConVar("unitvehicle_racertags", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Racers and Commander Units will have name tags above their vehicles.")
RacerPursuitTech = CreateConVar("unitvehicle_racerpursuittech", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Racers will spawn with pursuit tech (spike strips, ESF, etc.).")
RacerFriendlyFire = CreateConVar("unitvehicle_racerfriendlyfire", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Racers will be able to attack eachother with Pursuit Tech.")
OptimizeRespawn = CreateConVar("unitvehicle_optimizerespawn", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units will be teleported ahead of the suspect instead of despawning (does not work with simfphys).")
TrafficStreaming = CreateConVar("unitvehicle_trafficstreaming", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Traffic and patrolling Units will despawn when they are too far away from the player, thus allowing new ones to spawn.")
RandomPlayerUnits = CreateConVar("unitvehicle_randomplayerunits", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, player-controlled Units will be chosen randomly from the available units.")
TractionControl = CreateConVar("unitvehicle_tractioncontrol", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units and Racer Vehicles will apply reduced throttle when wheel spinning.")
DisengageOnHeatChange = CreateConVar("unitvehicle_disengageonheatchange", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI Units will fall back if their vehicle does not match any assigned vehicles when Heat Level changes.")
CanExitVehicle = CreateConVar("unitvehicle_canexitvehicle", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, players can exit their vehicle during pursuits or races.")
UnitDifficulty = CreateConVar( "unitvehicle_unitdifficulty", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Increases Unit AI difficulty." )
UnitCatchup = CreateConVar( "unitvehicle_unitcatchup", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit AI catch-up." )
DriverModel = CreateConVar( "unitvehicle_drivermodel", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, driver models will spawn depending on the NPC class." )

ActionCam = CreateConVar("unitvehicle_actioncam", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, the camera will show dramatic angles during certain events. Gameplay may slow down.")
ActionCamWrecked = CreateConVar("unitvehicle_actioncam_wrecked", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, the camera will show a dramatic angle when you get wrecked, busted or killed.")
ActionCamRaceStart = CreateConVar("unitvehicle_actioncam_racestart", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, the camera will show a dramatic angle when you start a race.")
ActionCamRaceFinish = CreateConVar("unitvehicle_actioncam_racefinish", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, the camera will show a dramatic angle when you finish a race. Your vehicle will be taken over by an AI temporarily.")
ActionCamCrash = CreateClientConVar("unitvehicle_actioncam_crash", 1, true, false, "Unit Vehicles: If set to 1, the camera will show a dramatic angle when you crash your vehicle.")
ActionCamCrashThreshold = CreateClientConVar("unitvehicle_actioncam_crashthreshold", 500, true, false, "Unit Vehicles: Damage to trigger.")
ActionCamJump = CreateConVar("unitvehicle_actioncam_jump", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, the camera will show a dramatic angle when you hit a jump.")
ActionCamJumpThreshold = CreateConVar("unitvehicle_actioncam_jumpthreshold", 200, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Height to trigger.")
ActionCamSpotted = CreateConVar("unitvehicle_actioncam_spotted", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, the game will slow down and the camera will point to the closest Unit when starting a pursuit.")
ActionCamRoadblock = CreateConVar("unitvehicle_actioncam_roadblock", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, the camera will show a dramatic angle when you hit roadblocks.")
ActionCamRoadblockThreshold = CreateConVar("unitvehicle_actioncam_roadblockthreshold", 1000, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Speed to trigger.")
ActionCamTakedown = CreateConVar("unitvehicle_actioncam_takedown", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, the camera will show a dramatic angle when you take down Racers or Units.")
ActionCamTakedownThreshold = CreateConVar("unitvehicle_actioncam_takedownthreshold", 1000, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Distance to trigger.")
ActionCamPursuitBreaker = CreateConVar("unitvehicle_actioncam_pursuitbreaker", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, the camera will show a dramatic angle when you hit Pursuit Breakers. Your vehicle will be taken over by an AI temporarily.")

UVUOneCommanderHealth = CreateConVar("unitvehicle_unit_onecommanderhealth", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUCommanderRepair = CreateConVar("unitvehicle_unit_commanderrepair", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED},"Unit Vehicles: If set to 1, Commander Units can utilize the Repair Shop to repair themselves.")

UVUTimeTillNextHeatEnabled = CreateConVar("unitvehicle_unit_timetillnextheatenabled", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Heat Levels will progress automatically based on the time until the next heat level.")

UVTVehicleBase = CreateConVar("unitvehicle_traffic_vehiclebase", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "\n1 = Default Vehicle Base (prop_vehicle_jeep)\n2 = simfphys\n3 = Glide")
UVTAssignTraffic = CreateConVar("unitvehicle_traffic_assigntraffic", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Spawns Traffic Vehicles only from the list. Otherwise, spawns a random Traffic Vehicle from the database.")
UVTSpawnCondition = CreateConVar("unitvehicle_traffic_spawncondition", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "\n1) Never \n2) When driving \n3) Always")
UVTMaxTraffic = CreateConVar("unitvehicle_traffic_maxtraffic", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Max amount of Traffic Vehicles roaming.")
UVTTrafficVehicles = CreateConVar("unitvehicle_traffic_vehicles", "", {ShouldArchive}, "Assigned Traffic Vehicles (for override mode)")
UVTDriverModels = CreateConVar("unitvehicle_traffic_drivermodel", "", {ShouldArchive}, "Assigned Traffic Driver Models")

--racer convars
UVRVehicleBase = CreateConVar("unitvehicle_racer_vehiclebase", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "\n1 = Default Vehicle Base (prop_vehicle_jeep)\n2 = simfphys\n3 = Glide")
UVRAssignRacers = CreateConVar("unitvehicle_racer_assignracers", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Spawns Racer Vehicles only from the list. Otherwise, spawns a random Racer Vehicle from the database.")
UVRRacers = CreateConVar("unitvehicle_racer_racers", "", {ShouldArchive}, "Assigned Racer Vehicles")
UVRSpawnCondition = CreateConVar("unitvehicle_racer_spawncondition", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "\n1) Never \n2) When driving \n3) Always")
UVRMaxRacer = CreateConVar("unitvehicle_racer_maxracer", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Max amount of Racer Vehicles roaming.")
UVRDriverModels = CreateConVar("unitvehicle_racer_drivermodel", "", {ShouldArchive}, "Assigned Racer Driver Models")

--unit convars
UVUVehicleBase = CreateConVar("unitvehicle_unit_vehiclebase", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "\n1 = Default Vehicle Base (prop_vehicle_jeep)\n2 = simfphys\n3 = Glide")

UVUPursuitTech = CreateConVar("unitvehicle_unit_pursuittech", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can use weapons (spike strips, ESF, EMP, etc.).")
UVUPursuitTech_ESF = CreateConVar("unitvehicle_unit_pursuittech_esf", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with ESF.")
UVUPursuitTech_EMP = CreateConVar("unitvehicle_unit_pursuittech_emp", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with EMP.")
UVUPursuitTech_Spikestrip = CreateConVar("unitvehicle_unit_pursuittech_spikestrip", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with spike strips.")
UVUPursuitTech_Killswitch = CreateConVar("unitvehicle_unit_pursuittech_killswitch", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with killswitch.")
UVUPursuitTech_RepairKit = CreateConVar("unitvehicle_unit_pursuittech_repairkit", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with repair kits.")
UVUPursuitTech_ShockRam = CreateConVar("unitvehicle_unit_pursuittech_shockram", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with shock rams.")
UVUPursuitTech_GPSDart = CreateConVar("unitvehicle_unit_pursuittech_gpsdart", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with gps darts.")
UVUPursuitTech_Grappler = CreateConVar("unitvehicle_unit_pursuittech_grappler", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with gps darts.")

UVUHelicopterModel = CreateConVar("unitvehicle_unit_helicoptermodel", "Default", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Helicopter model to use with Air Unit.")
UVUHelicopterBarrels = CreateConVar("unitvehicle_unit_helicopterbarrels", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "1 = Barrels\n0 = No Barrels")
UVUHelicopterSpikeStrip = CreateConVar("unitvehicle_unit_helicopterspikestrip", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "1 = Spike Strips\n0 = No Spike Strips")
UVUHelicopterSkyhammer = CreateConVar("unitvehicle_unit_helicopterskyhammer", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "1 = Skyhammer\n0 = No Skyhammer")
UVUHelicopterBusting = CreateConVar("unitvehicle_unit_helicopterbusting", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "1 = Helicopter can bust racers\n0 = Helicopter cannot bust racers")
UVUHelicopterMinFuel = CreateConVar("unitvehicle_unit_helicopterminfuel", 60, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Minimum Fuel Time before the Air Unit runs out of fuel and leaves the pursuit.")
UVUHelicopterMaxFuel = CreateConVar("unitvehicle_unit_helicoptermaxfuel", 180, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Maximum Fuel Time before the Air Unit runs out of fuel and leaves the pursuit.")

UVUBountyPatrol = CreateConVar("unitvehicle_unit_bountypatrol", 1000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUBountySupport = CreateConVar("unitvehicle_unit_bountysupport", 5000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUBountyPursuit = CreateConVar("unitvehicle_unit_bountypursuit", 10000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUBountyInterceptor = CreateConVar("unitvehicle_unit_bountyinterceptor", 20000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUBountyAir = CreateConVar("unitvehicle_unit_bountyair", 75000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUBountySpecial = CreateConVar("unitvehicle_unit_bountyspecial", 25000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUBountyCommander = CreateConVar("unitvehicle_unit_bountycommander", 100000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVUBountyRhino = CreateConVar("unitvehicle_unit_bountyrhino", 50000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})

local ReplicatedVars = {
	["unitvehicle_racer_racers"] = true,
	["unitvehicle_traffic_vehicles"] = true,

	["unitvehicle_racer_drivermodel"] = true,
	["unitvehicle_traffic_drivermodel"] = true,
}

for index, v in pairs( {'Patrol', 'Support', 'Pursuit', 'Interceptor', 'Special', 'Commander', 'Rhino', 'Air'} ) do
	local lowercaseUnit = string.lower( v )

	ReplicatedVars["unitvehicle_unit_" .. lowercaseUnit .. "_voice"] = true
	ReplicatedVars["unitvehicle_unit_" .. lowercaseUnit .. "_voiceprofile"] = true

	CreateConVar( "unitvehicle_unit_" .. lowercaseUnit .. "_voice", defaultvoicetable[index], {ShouldArchive})
	CreateConVar( "unitvehicle_unit_" .. lowercaseUnit .. "_voiceprofile", "default", {ShouldArchive})

	if lowercaseUnit ~= 'air' then
		ReplicatedVars["unitvehicle_unit_" .. lowercaseUnit .. "_drivermodel"] = true
		
		CreateConVar( "unitvehicle_unit_" .. lowercaseUnit .. "_drivermodel", defaultdrivermodeltable[index], {ShouldArchive})
	end
end

for _, v in pairs( {'Misc', 'Dispatch'} ) do
	local lowercaseType = string.lower( v )
	CreateConVar( "unitvehicle_unit_" .. lowercaseType .. "_voiceprofile", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
end

for i = 1, MAX_HEAT_LEVEL do
	local prevIterator = i - 1

	local timeTillNextHeatId = ((prevIterator == 0 and 'enabled') or prevIterator)

	for _, v in pairs( {'Patrol', 'Support', 'Pursuit', 'Interceptor', 'Special', 'Commander', 'Rhino'} ) do
		local lowercaseUnit = string.lower( v )
		local conVarKey = string.format( 'units%s%s', lowercaseUnit, i )

		-------------------------------------------

		ReplicatedVars["unitvehicle_unit_" .. conVarKey] = true

		CreateConVar( "unitvehicle_unit_" .. conVarKey, "", {ShouldArchive})
		CreateConVar( "unitvehicle_unit_" .. conVarKey .. "_chance", 100, {FCVAR_REPLICATED, FCVAR_ARCHIVE})
		CreateConVar( "unitvehicle_unit_" .. conVarKey .. "_limit", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE})
	end

	for _, conVar in pairs( HEAT_SETTINGS ) do
		local conVarKey = conVar .. ((conVar == 'timetillnextheat' and timeTillNextHeatId) or i)
		local check = (conVar == "timetillnextheat")

		CreateConVar( "unitvehicle_unit_" .. conVarKey, HEAT_DEFAULTS[conVar][tostring( ( check and timeTillNextHeatId ) or i )] or 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	end
end

UVPBMax = CreateConVar("unitvehicle_pursuitbreaker_maxpb", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVPBSpawnCondition = CreateConVar("unitvehicle_pursuitbreaker_spawncondition", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "\n1) Never \n2) When driving \n3) Always")
UVPBCooldown = CreateConVar("unitvehicle_pursuitbreaker_pbcooldown", 60, {FCVAR_ARCHIVE, FCVAR_REPLICATED})

UVRSMax = CreateConVar("unitvehicle_repairshop_maxrs", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVRSSpawnCondition = CreateConVar("unitvehicle_repairshop_spawncondition", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "\n1) Never \n2) When driving \n3) Always")

UVRBMax = CreateConVar("unitvehicle_roadblock_maxrb", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
UVRBOverride = CreateConVar("unitvehicle_roadblock_override", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})

UnitVehicles = true

--[[

	For presets:
	Client: Table<sequential> name
	Server: Table[name] = data

]]
UVPresets = {}

if SERVER then
	local PRESET_TYPES = {
		["uvunitmanager"] = true,
		["uvpursuittech"] = true,
	}

	function UV_AddPreset( type, fileName, data )
		if not UVPresets[type] then UVPresets[type] = {} end
		UVPresets[type][fileName] = data

		net.Start("UVPresets_Add")
		net.WriteString(type)
		net.WriteString(fileName)
		net.WriteString(data.Name or fileName)
		net.Broadcast()
	end
	
	function UV_RemovePreset( type, fileName, deleteFile )
		if UVPresets[type] then UVPresets[type][fileName] = nil end
		if deleteFile then
			local isWorkshop = UV_IsWorkshop( "preset_import>>" .. type, fileName )
			
			-- The reason I check for X == false is because UV_IsWorkshop returns nil if the file is not found
			if isWorkshop == false then
				UV_RemoveFile( "preset_import>>" .. type, fileName )
			end
		end

		net.Start("UVPresets_Remove")
		net.WriteString(type)
		net.WriteString(fileName)
		net.Broadcast()
	end

	function UV_LoadPreset( type, fileName )
		local data = util.JSONToTable( UV_LoadFile( "preset_import>>" .. type, fileName ) )
		if not data then return end

		if type == "uvunitmanager" then
			UVUnitLoadPreset( data.Data )
			return
		end

		for convarName, convarValue in pairs( PRESET_MAP[type] ) do
			local convar = GetConVar( convarName )

			if convar then
				convar:SetString( data.Data[convarName] or convarValue )
			end
		end
	end

	function UV_SavePreset( type, name, data )
		if not data then
			data = {}

			for key, _ in pairs( PRESET_MAP[type] ) do
				local newKey = type == "uvunitmanager" and 'unitvehicle_unit_' .. key or key
				local convar = GetConVar(newKey)
				if convar then
					data[newKey] = convar:GetString()
				end
			end
		end

		local jsonArray = {
			['Name'] = name,
			['Data'] = data
		}

		if not file.IsDir( 'unitvehicles/preset_import', 'DATA' ) then
			file.CreateDir( 'unitvehicles/preset_import' )
		end

		if not file.IsDir( 'unitvehicles/preset_import/' .. type, 'DATA' ) then
			file.CreateDir( 'unitvehicles/preset_import/' .. type )
		end

		file.Write( 'unitvehicles/preset_import/' .. type .. '/' .. string.lower( name ) .. '.json', util.TableToJSON( jsonArray ) )
		UV_AddFile( 'preset_import>>' .. type, string.lower( name ) .. '.json', 'unitvehicles/preset_import/' .. type .. '/', 'DATA' )

		return jsonArray
	end

	function UV_SendPresets( ply )
		local networkData = {}

		for type, _ in pairs( PRESET_TYPES ) do
			networkData[type] = {}
			if not UVPresets[type] then continue end

			for file, data in pairs(UVPresets[type]) do
				networkData[type][file] = data.Name or file
			end
		end

		local compressedData = util.Compress(util.TableToJSON(networkData))

		net.Start("UVPresets_Set")
		net.WriteString("__ALL")
		net.WriteUInt(#compressedData, 16)
		net.WriteData(compressedData, #compressedData)
		net.Send(ply)
	end

	function UV_PopulatePresets()
		for type, _ in pairs( PRESET_TYPES ) do
			UVPresets[type] = {}
			local networkData = {}
			
			local files = UV_GetFiles( "preset_import>>" .. type )

			for _, file in ipairs(files) do
				local data = util.JSONToTable( UV_LoadFile( "preset_import>>" .. type, file ) )
				UVPresets[type][file] = data
				networkData[file] = data.Name or file
			end

			local compressedData = util.Compress(util.TableToJSON(networkData))

			net.Start("UVPresets_Set")
			net.WriteString(type)
			net.WriteUInt(#compressedData, 16)
			net.WriteData(compressedData, #compressedData)
			net.Broadcast()
		end
	end

	function UV_DefinePresetTemplate( type, template )
		if not PRESET_TYPES[type] then return end
		PRESET_MAP[type] = template
	end

	hook.Add( "UVContentEvent", "UV_PopulatePresets", function( operation, path, fileName )
		if operation ~= "Initialize" then return end

		UV_PopulatePresets()
		hook.Remove( "UVContentEvent", "UV_PopulatePresets" )
	end )

	net.Receive("UVPresets_Remove", function( len, ply )
		if ply and not ply:IsSuperAdmin() then return end

		local type = net.ReadString()
		local fileName = net.ReadString()

		UV_RemovePreset( type, fileName, true )
	end)

	net.Receive("UVPresets_Load", function( len, ply )
		if ply and not ply:IsSuperAdmin() then return end

		local type = net.ReadString()
		local filename = net.ReadString()

		UV_LoadPreset( type, filename )
	end)

	net.Receive("UVPresets_Save", function( len, ply )
		if ply and not ply:IsSuperAdmin() then return end

		local type = net.ReadString()
		local name = net.ReadString()

		local data = UV_SavePreset(type, name)
		UV_AddPreset(type, string.lower(name) .. '.json', data)
	end)

	local function _setConVar( cvar, value )
		UV_UpdateSettings({ ["unitvehicle_unit_" .. cvar] = value })
		-- net.Start("UVUpdateSettings")
		-- net.WriteTable({ ["unitvehicle_unit_" .. cvar] = value })
		-- net.SendToServer()
	end

	--[[
		- data is a table of convar names and values
	]]
	function UVUnitLoadPreset( data )
		local warned = false
		local count = 0
		local count1 = 0

		for key, value in pairs(conVarList) do
			local incomingData = data[key] or data["unitvehicle_unit_" .. key] or data["uvunitmanager_" .. key]
			local cont

			-- MUST BE FIXED TO USE UVUPDATESETTINGS
			if string.match(key, "_chance") and not incomingData then
				_setConVar( key, 100 )
				cont = true 
			end

			if string.match(key, "_limit") and not incomingData then
				_setConVar( key, 0 )
				cont = true 
			end

			if cont then
				cont = nil
				continue
			end

			if not incomingData and GetConVar("unitvehicle_unit_" .. key) and not PROTECTED_CONVARS[key] then
				_setConVar( key, DEFAULTS[key] or "" )
			end
		end

		for incomingCV, incomingValue in pairs(data) do
			-- local isOldFormat = string.match( incomingCV, "uvunitmanager_" )
			-- incomingCV = isOldFormat and string.Split( incomingCV, "uvunitmanager_" )[2] or incomingCV
			local variable = string.Split( incomingCV, "unitvehicle_unit_" )[2] or string.Split( incomingCV, "uvunitmanager_" )[2]

			count1 = count1 + 1
			--local cvNoNumber = string.sub( incomingCV, 1, string.len(incomingCV) - 1 )

			local cvNoNumber = nil
			local number = nil

			local _incomingCV = variable

			while string.match( _incomingCV:sub(-1), "%d" ) and _incomingCV ~= "" do
				number = _incomingCV:sub( -1 )
				cvNoNumber = _incomingCV:sub( 1, -2 )
				_incomingCV = cvNoNumber
			end

			local numberIterator = 0

			if LEGACY_CONVARS[_incomingCV] then
				if LEGACY_CONVARS[_incomingCV].HasNumber then
					_setConVar( LEGACY_CONVARS[_incomingCV].Replacement .. number, incomingValue  )
				else
					_setConVar( LEGACY_CONVARS[_incomingCV].Replacement, incomingValue )
				end
			elseif not PROTECTED_CONVARS[variable] then
				_setConVar( variable, incomingValue )
			end
		end
	end


	-- Last replicated scope fields per key; UVScopeThink diffs against this (see UVReplicate*).
	local UV_SCOPE_LAST_REPLICATED = {}
	local UV_SCOPE_LAST_VALUES = {}

	UVHUDPursuit = nil
	UVHUDBusting = nil
	UVHUDCooldown = nil

	--Exiting the vehicle during pursuits or races
	hook.Add("CanExitVehicle", "UVExitingVehicleWhlistInPursuit", function( veh, ply)
		local vehicle_entity = veh:GetParent()

		if CanExitVehicle:GetBool() then return true end

		if UVTargeting then return false end
		if (IsValid(vehicle_entity) and vehicle_entity.uvraceparticipant) or veh.uvraceparticipant then return false end
	end)

	--LVS: Disable vehicle engine
	hook.Add( "LVS.IsEngineStartAllowed", "UVLVSIsEngineStartAllowed", function( v )
		if v.uvbusted or v.uvenginedisabled then return false end
	end)

	--Non-collision damage to prop_vehicle_jeep UVs
	hook.Add( "EntityTakeDamage", "UVDamage", function( target, dmginfo )
		if VC then return end
		if target.v and target.v:GetClass() == "prop_vehicle_jeep" and target.v.UnitVehicle then
			local damage = target:GetMaxHealth()*(dmginfo:GetDamage()*10)
			UVDamage(target.v, damage)
		end
	end )

	hook.Add("PostCleanupMap", "UVCleanup", function()
		UVTargeting = nil
		UVResetStats()
		UVPresenceMode = false
		UVCallLocation = nil
		uvcallexists = nil
		UVHiding = nil
		UVCommanderLastHealth = nil
		UVCommanderLastEngineHealth = nil
		UVCommanders = {}
		UVWantedTableDriver = {}
		UVPlayerUnitTablePlayers = {}
		UVJammerDeployed = nil
		UVPreInfractionCount = 0

		-- Clear all pursuit scopes
		for key, _ in pairs(UVPursuitScopes) do
			net.Start("UV_RemoveScope")
			net.WriteString(key)
			net.Broadcast()
		end
		UVPursuitScopes = {}
		UV_SCOPE_LAST_REPLICATED = {}

		UVGlobalPursuit = {
			ResourcePoints = 0,
			CommanderActive = false,
			PursuitStart = 0,
		}

		local serializedJson = util.TableToJSON(UVGlobalPursuit)
		local compressedJson = util.Compress(serializedJson)
		local messageSize = #compressedJson
		net.Start("UV_SetGlobal")
		net.WriteBool(true)
		net.WriteUInt(messageSize, 16)
		net.WriteData(compressedJson, messageSize)
		net.Broadcast()

		if next(UVLoadedPursuitBreakers) ~= nil then
			for k, v in pairs(UVLoadedPursuitBreakers) do
				net.Start("UVTriggerPursuitBreaker")
				net.WriteInt(k, 32)
				net.Broadcast()
			end
		end
		UVLoadedPursuitBreakers = {}
		UVLoadedPursuitBreakersLoc = {}
		UVLoadedRepairShops = {}
		UVLoadedRepairShopsLoc = {}
		UVLoadedRoadblocks = {}
		UVLoadedRoadblocksLoc = {}
		UVWreckedVehicles = {}
	end)

	--[[
	
	Scopes manipulation functions

	]]--

	function UVCreateScope( veh, scopeData )
		if veh.UnitVehicle then return end

		local key = isstring(veh) and veh or UVScopeKey(veh)
		if not key then return nil end
		if UVPursuitScopes[key] then return UVPursuitScopes[key] end

		local scope = table.Copy( scopeData or {} )

		for k, v in pairs( UV_SCOPE_DEFAULTS ) do
			if not scope[k] then scope[k] = v end
		end

		scope.EntIndex = veh:EntIndex()
		scope.CreationID = veh:GetCreationID()
		-- scope.EntIndex = veh:EntIndex()
		-- scope.CreationID = veh:GetCreationID()
		-- scope.BountyTimer = CurTime()
		-- scope.Busting = CurTime()
		-- scope.BustingProgress = CurTime()
		-- scope.BustingLastProgress = CurTime()
		-- scope.Losing = 0
		-- scope.CooldownProgressTimeout = CurTime()

		UVPursuitScopes[key] = scope
		UV_SCOPE_LAST_VALUES[key] = table.Copy(scope)

		UVReplicateFullScope(key, scope)

		return scope
	end

	function UVRemoveScope( veh )
		local key = isstring( veh ) and veh or UVScopeKey( veh )
		if not key then return end

		UV_SCOPE_LAST_REPLICATED[key] = nil
		UV_SCOPE_LAST_VALUES[key] = nil
		UVPursuitScopes[key] = nil

		net.Start( "UV_RemoveScope" )
		net.WriteString( key )
		net.Broadcast()
	end

	function UVUpdateScope( veh, deltaTable )
		local key = isstring(veh) and veh or UVScopeKey( veh )
		if not key or not UVPursuitScopes[key] then return end

		local scope = UVPursuitScopes[key]
		local replicateDelta = {}
		local changed = false

		for k, v in pairs( deltaTable ) do
			if scope[k] ~= v then
				scope[k] = v
				changed = true
				if UV_SCOPE_REPLICATED_KEYS[k] then replicateDelta[k] = v end
			end
		end

		if changed and next( replicateDelta ) then UVReplicateScopeDelta( key, replicateDelta ) end
	end

	function UVReplicateFullScope( key, scope, _players )
		local replicateData = {}
		local last = UV_SCOPE_LAST_REPLICATED[key] or {}

		for k, v in pairs( UV_SCOPE_REPLICATED_KEYS ) do
			replicateData[k] = scope[k]
			if not _players then
				last[k] = replicateData[k]
			end
		end

		replicateData.EntIndex = scope.EntIndex
		replicateData.CreationID = scope.CreationID

		UV_SCOPE_LAST_REPLICATED[key] = last

		local serializedJson = util.TableToJSON(replicateData)
		local compressedJson = util.Compress(serializedJson)
		local messageSize = #compressedJson

		net.Start("UV_SetScope")
		net.WriteString(key)
		net.WriteUInt(messageSize, 16)
		net.WriteData(compressedJson, messageSize)
		if _players then
			net.Send(_players)
		else
			net.Broadcast()
		end
	end

	function UVReplicateScopeDelta( key, deltaTable )
		for k, v in pairs(deltaTable) do
			if not UV_SCOPE_REPLICATED_KEYS[k] then deltaTable[k] = nil continue end
			UV_SCOPE_LAST_REPLICATED[key][k] = v
		end

		local serializedJson = util.TableToJSON(deltaTable)
		local compressedJson = util.Compress(serializedJson)
		local messageSize = #compressedJson

		net.Start("UV_SetScope")
		net.WriteString(key)
		net.WriteUInt(messageSize, 16)
		net.WriteData(compressedJson, messageSize)
		net.Broadcast()
	end

	-- function UVReplicateFullScopeTo(key, scope, ply)
	-- 	local replicateData = {}

	-- 	for i = 1, #UV_SCOPE_REPLICATED_KEYS do
	-- 		local rk = UV_SCOPE_REPLICATED_KEYS[i]
	-- 		replicateData[rk] = scope[rk]
	-- 	end

	-- 	replicateData.EntIndex = scope.EntIndex
	-- 	replicateData.CreationID = scope.CreationID

	-- 	local serializedJson = util.TableToJSON(replicateData)
	-- 	local compressedJson = util.Compress(serializedJson)
	-- 	local messageSize = #compressedJson

	-- 	net.Start("UV_SetScope")
	-- 	net.WriteString(key)
	-- 	net.WriteUInt(messageSize, 16)
	-- 	net.WriteData(compressedJson, messageSize)
	-- 	net.Send(ply)
	-- end

	function UVUpdateGlobalPursuit(key, value)
		if value == nil then value = false end
		if UVGlobalPursuit[key] == value then return end

		UVGlobalPursuit[key] = value

		local serializedJson = util.TableToJSON({[key] = value})
		local compressedJson = util.Compress(serializedJson)
		local messageSize = #compressedJson

		net.Start("UV_SetGlobal")
		net.WriteBool(false)
		net.WriteUInt(messageSize, 16)
		net.WriteData(compressedJson, messageSize)
		net.Broadcast()
	end

	function UVGetPursuitRecipients()
		local recipients = {}

		for _, ply in player.Iterator() do
			local veh = UVGetVehicle( ply )

			if IsValid( veh ) then
				local scope = UVGetScope( veh )

				if ( scope and scope.InPursuit ) or veh.UnitVehicle then
					table.insert(recipients, ply)
				end
			end
		end

		return recipients
	end

	function UVGetVehicleOccupants(veh)
		local occupants = {}
		if not IsValid(veh) then return occupants end

		for _, ply in player.Iterator() do
			if UVGetVehicle(ply) == veh then
				table.insert( occupants, ply )
			end
		end

		return occupants
	end

	local _scopeSyncThrottle = 0
	local _highestHeatLevel = 0

	function UVScopeThink()
		local now = CurTime()
		-- InPursuit is set manually by unit spotting (visibility) or uv_startpursuit only

		-- Per-scope tick (we sync changes based on the UV_SCOPE_LAST_REPLICATED diffs)
		local lastValues = UV_SCOPE_LAST_VALUES[key] or {}

		for key, scope in pairs( UVPursuitScopes ) do
			local veh = Entity( scope.EntIndex )
			if not IsValid( veh ) then continue end

			-- Bounty accumulation
			if not scope.InPursuit then
				scope.BountyTimer = now
				scope.Hiding = false
			else
				if not scope.EnemyEscaping then
					scope.BountyTimerProgress = now - scope.BountyTimer
					scope.Hiding = false
				else
					scope.BountyTimer = now - scope.BountyTimerProgress
				end
			end

			local botimeout = 10
			if not scope.EnemyEscaping and scope.BountyTimerProgress >= botimeout then
				local bountyTime = GetConVar('unitvehicle_unit_bountytime' .. scope.Heat):GetInt()
				scope.Bounty = scope.Bounty + bountyTime
				scope.BountyTimer = now
			end

			-- Losing/escape progression
			local ltimeout = (scope.CooldownTimer + 5)

			if scope.InPursuit and not scope.EnemyEscaped then
				if scope.Losing >= 5 then
					if not scope.EnemyEscaping then
						hook.Run('UV_Event', 'onSuspectEscaping', veh)
						scope.EnemyEscaping = true
						scope.InCooldown = true
						scope.IsEvading = true
						scope.CooldownProgressTimeout = now
					end

					if scope.EnemyEscaping then
						local cooldowntimer = GetConVar('unitvehicle_unit_cooldowntimer' .. scope.Heat):GetInt()
						if scope.Hiding then
							cooldowntimer = cooldowntimer / 4
						end
						local cooldownprogresstick = 0.01
						local cooldownprogress = ((1 / cooldowntimer) * cooldownprogresstick)
						if now > scope.CooldownProgressTimeout + cooldownprogresstick then
							scope.CooldownTimerProgress = scope.CooldownTimerProgress + cooldownprogress
							scope.CooldownProgressTimeout = now
						end
					end
				else
					if scope.EnemyEscaping and not scope.EnemyEscaped and not scope.EnemyBusted then
						hook.Run('UV_Event', 'onSuspectEscapingEnd', veh)
						scope.EnemyEscaping = false
						scope.InCooldown = false
						scope.IsEvading = false
						scope.CooldownTimerProgress = 0
					end
				end

				-- call off pursuit for scope if escaped
				if scope.CooldownTimerProgress >= 1 then
					hook.Run('UV_Event', 'onSuspectEscaped', veh)
					scope.CooldownTimerProgress = 0
					scope.InPursuit = false
					scope.EnemyEscaped = true
					scope.EnemyEscaping = false
					scope.IsEvading = false
					scope.InCooldown = false
				end

				-- Never evade option
				if NeverEvade:GetBool() and not scope.EnemyEscaping then
					scope.Losing = 0
				end
			end

			-- Heat level management
			if scope.InPursuit then
				local timedHeatEnabled = UVUTimeTillNextHeatEnabled:GetInt() == 1
				local enemyEscaping = scope.EnemyEscaping
				
				if timedHeatEnabled then
					local isTimeHeatDefined = scope.TimeTillNextHeatEnd > 0
					local canHeatTransition = ( now >= scope.TimeTillNextHeatEnd and isTimeHeatDefined )

					if not enemyEscaping and canHeatTransition then
						local nextHeat = scope.Heat + 1
						if nextHeat <= MaxHeatLevel:GetInt() then
							scope.Heat = nextHeat
							hook.Run( 'UV_Event', 'onHeatLevelIncrease', veh, nextHeat )
							TriggerHeatLevelEffects( nextHeat, veh )
							local timeTillNextHeatConVar = GetConVar( 'unitvehicle_unit_timetillnextheat' .. nextHeat )
							local nextInterval = timeTillNextHeatConVar and timeTillNextHeatConVar:GetInt() or 120
							scope.TimeTillNextHeatEnd = now + nextInterval
						else
							scope.TimeTillNextHeatEnd = 0
						end
					elseif not isTimeHeatDefined and scope.Heat < MaxHeatLevel:GetInt() then
						local timeTillNextHeatConVar = GetConVar( 'unitvehicle_unit_timetillnextheat' .. scope.Heat )
						local interval = timeTillNextHeatConVar and timeTillNextHeatConVar:GetInt() or 120
						scope.TimeTillNextHeatEnd = now + interval
					end
				else
					local newHeatLevel = CalculateHeatLevel( scope.Bounty, scope.Heat )
					if newHeatLevel ~= scope.Heat then
						scope.Heat = newHeatLevel
						hook.Run( 'UV_Event', 'onHeatLevelIncrease', veh, newHeatLevel )
						TriggerHeatLevelEffects( newHeatLevel, veh )
					end
				end
			end

			-- Pause heat timer during cooldown
			if scope.EnemyEscaping and scope.TimeTillNextHeatEnd > 0 then
				scope.TimeTillNextHeatEnd = scope.TimeTillNextHeatEnd + ( now - ( scope._lastThinkTime or now ) )
			end
			scope._lastThinkTime = now

			-- Per-scope SFX transitions (only to that vehicle's occupants)
			local occupants = UVGetVehicleOccupants( veh )

			if not scope._lastInPursuitState and scope.InPursuit then
				if #occupants > 0 then
					local sfx = scope.Heat <= 3 and "ui/pursuit/start.wav" or "ui/pursuit/start_wanted_level_high.wav"
					UVRelaySoundToClients( sfx, false, occupants )
				end
			end
			scope._lastInPursuitState = scope.InPursuit

			if not scope._lastEscapingState and scope.EnemyEscaping then
				if #occupants > 0 then
					UVRelaySoundToClients( "ui/pursuit/escaping.wav", false, occupants )
				end
			elseif scope._lastEscapingState and not scope.EnemyEscaping and not scope.EnemyEscaped and not scope.EnemyBusted then
				if #occupants > 0 then
					UVRelaySoundToClients( "ui/pursuit/resume.wav", false, occupants )
				end
			end
			scope._lastEscapingState = scope.EnemyEscaping

			if not scope._lastEscapedState and scope.EnemyEscaped then
				if #occupants > 0 then
					UVRelaySoundToClients( "ui/pursuit/escaped.wav", false, occupants )
					net.Start( "UVHUDStopPursuit" )
					net.Send( occupants )

					local escapedtable = {
						["PursuitLength"] = CurTime() - scope.PursuitStart,
						["Deploys"] = scope.Deploys,
						["Roadblocks"] = UVRoadblocksDodged or 0,
						["Spikestrips"] = UVSpikestripsDodged or 0,
						["Bounty"] = string.Comma( scope.Bounty or 0 ),
						["Tags"] = scope.Tags or 0,
						["Wrecks"] = scope.Wrecks or 0,
					}
					local infractionstable = IsValid( veh ) and veh.Infractions or {}
					local finesdue = scope.FinesDue

					net.Start( "UVHUDEscapedDebrief" )
					net.WriteTable( escapedtable )
					net.WriteTable( infractionstable )
					net.WriteInt( finesdue, 32 )
					net.Send( occupants )
				end
			end
			scope._lastEscapedState = scope.EnemyEscaped

			-- compare last sync vals with current
			local last = UV_SCOPE_LAST_REPLICATED[key] or {}
			local delta = {}

			local hasChanges = false

			for k, v in pairs( UV_SCOPE_REPLICATED_KEYS ) do
				if scope[k] ~= last[k] then
					delta[k] = scope[k]
					hasChanges = true
				end
				last[k] = scope[k]
			end
			if hasChanges then
				UVReplicateScopeDelta( key, delta )
			end

			local lastValues = UV_SCOPE_LAST_VALUES[key] or {}
			local deltaValues = {}

			for k, v in pairs( scope ) do
				if lastValues[k] ~= v then
					deltaValues[k] = v
					lastValues[k] = v
				end
			end

			if next(deltaValues) then hook.Run( 'UV_Event', 'onScopeChanged', veh, deltaValues ) end
		end

		-- if now > _scopeSyncThrottle then
		-- 	_scopeSyncThrottle = now + 0.1
		-- end

		-- backward-compat globals from scopes (until i fully migrate them to scopes across the luas xd)
		local anyInPursuit = false
		local anyEscaping = false
		local anyBusted = false
		local anyEscaped = false
		local InPursuitCount = 0
		local EscapingCount = 0
		local BustedCount = 0
		local EscapedCount = 0
		local maxHeat = 1
		local totalBounty = 0
		local totalDeploys = 0
		local totalWrecks = 0
		local totalTags = 0
		local totalUnitsChasing = 0

		for _, scope in pairs( UVPursuitScopes ) do
			if scope.InPursuit then
				anyInPursuit = true
				InPursuitCount = InPursuitCount + 1
			end
			if scope.EnemyEscaping then
				anyEscaping = true
				EscapingCount = EscapingCount + 1
			end
			if scope.EnemyBusted then
				anyBusted = true
				BustedCount = BustedCount + 1
			end
			if scope.EnemyEscaped then
				anyEscaped = true
				EscapedCount = EscapedCount + 1
			end
			if scope.Heat > maxHeat then maxHeat = scope.Heat end
			totalBounty = totalBounty + scope.Bounty
			totalDeploys = totalDeploys + scope.Deploys
			totalWrecks = totalWrecks + scope.Wrecks
			totalTags = totalTags + scope.Tags
			totalUnitsChasing = totalUnitsChasing + scope.UnitsChasing
		end

		-- pursuit just ended
		if ( not anyInPursuit ) and UVTargeting then
			timer.Simple(0, function()
				for k, v in pairs(ents.FindByClass("npc_uv*")) do
					v:ForgetEnemy()
				end	
			end)
			if anyBusted then
				hook.Run( 'UV_Event', 'onPursuitEnd', 'Busted' )
			elseif anyEscaped then
				hook.Run( 'UV_Event', 'onPursuitEnd', 'Escaped' )
			end
		end

		-- Losing states management
		if anyInPursuit then
			if EscapingCount == InPursuitCount and UVPursuitState ~= 'LOSING' then
				UVPursuitState = 'LOSING'
				if Chatter:GetBool() and not UVCalm then
					local unitCollection = ents.FindByClass( "npc_uv*" )

					if next( unitCollection ) ~= nil then

						local unit = unitCollection[math.random(#unitCollection)]
						UVChatterLosing(unit)

						timer.Remove('UVChatterLosingUpdate')
						timer.Create('UVChatterLosingUpdate', math.random(10, 20), 1, function()
							if UVPursuitState == 'LOSING' then
								UVChatterLosingUpdate(unit)
							end
						end)

					end

				end
			elseif UVPursuitState == 'LOSING' and EscapingCount ~= InPursuitCount then
				UVPursuitState = 'NONE'
				if Chatter:GetBool() and not UVCalm then
					local airUnits = ents.FindByClass( "uvair" )
					local unitCollection = ents.FindByClass( "npc_uv*" )

					local unit = ( next( airUnits ) ~= nil and airUnits[math.random(#airUnits)] ) or ( next( unitCollection ) ~= nil and unitCollection[math.random(#unitCollection)] )
					if unit and not (unit.crashing or unit.disengaging) then UVChatterFoundEnemy(unit) end
				end
			end
		else
			UVPursuitState = 'NONE'
			timer.Remove('UVChatterLosingUpdate')
		end

		UVTargeting = anyInPursuit or nil
		UVEnemyEscaping = anyEscaping or nil
		UVEnemyBusted = anyBusted or nil
		UVEnemyEscaped = anyEscaped or nil
		UVHeatLevel = maxHeat
		-- UVBounty = totalBounty
		-- UVDeploys = totalDeploys
		-- UVWrecks = totalWrecks
		-- UVTags = totalTags

		if _highestHeatLevel ~= maxHeat then
			if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() and UVTargeting and not _SkipHeatLevelReporting then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)
				local unit = units[random_entry]
				UVChatterReportHeat(unit, maxHeat)
			end
			
			ApplyHeatSettings( maxHeat )
		end

		_highestHeatLevel = maxHeat
		_SkipHeatLevelReporting = false
	end

	function UVGetPlayerCops( onlyVehicles )
		local cops = {}
		
		for unit, _ in pairs( UVUnitVehicles ) do
			if unit.UnitVehicle and unit.UnitVehicle:IsPlayer() then
				if onlyVehicles then
					table.insert( cops, unit )
				else
					table.insert( cops, unit.UnitVehicle )
				end
			end
		end

		return cops
	end

	UVBustSpeed = 10
	UVCooldownTimer = 20
	UVCooldownTimerProgress = 0
	UVCooldownProgressTimeout = CurTime()
	UVBounty = 0
	UVHeatLevel = 1
	UVWrecks = 0
	UVDeploys = 0
	UVTags = 0
	UVRoadblocksDodged = 0
	UVSpikestripsDodged = 0
	UVComboBounty = 1
	UVBountyTimer = CurTime()
	UVBountyTime = 0
	UVBountyTimerProgress = 0
	UVBusting = CurTime()
	UVBustingProgress = CurTime()
	UVBustingLastProgress = CurTime()
	UVBustingLastProgress2 = 0
	UVLosing = CurTime()
	UVBackupTimer = CurTime()
	UVPreInfractionCount = 0
	UVPreInfractionCountCooldown = CurTime()
	UVUnitsChasing = {}
	UVWantedTableVehicle = {}
	UVWantedTableDriver = {}
	UVPotentialSuspects = {}
	UVMaxUnits = 3
	UVTacticFormationNo = 1
	UVVehicleInitializing = {}
	UVPlayerUnitTablePlayers = {}
	UVCommanders = {}
	UVRVWithPursuitTech = {}
	UVLoadedPursuitBreakers = {}
	UVLoadedPursuitBreakersLoc = {}
	UVLoadedRepairShops = {}
	UVLoadedRepairShopsLoc = {}
	UVLoadedRoadblocks = {}
	UVLoadedRoadblocksLoc = {}
	UVWreckedVehicles = {}
	UVUnitVehicles = {}
	UVPlayersInActionCam = {}

	hook.Add('UV_Event', 'onPursuitEvent', function( type, result )
		if type == 'onPursuitEnd' then
			if result == 'Busted' then
				
			elseif result == 'Escaped' then
				for k, v in pairs(ents.FindByClass("uvair")) do
					v.disengaging = true
				end
				
				if #ents.FindByClass("npc_uv*") > 0 then
					local units = ents.FindByClass("npc_uv*")
					if Chatter:GetBool() then
						UVChatterLost(units[math.random(#units)])
					end
				end
			end
		end
	end)

	--Think
	hook.Add("Think", "UVServerThink", function()
		UVScopeThink()

		--One Commander Active
		if UVOneCommanderActive then
			if not UVCommanderRespawning and next(UVCommanders) == nil then
				UVOneCommanderActive = nil
				UVCommanderLastHealth = nil
				UVCommanderLastEngineHealth = nil
				net.Start( "UVHUDStopOneCommander" )
				net.Broadcast()
			end
			for k, v in pairs( UVCommanders ) do
				if not IsValid(v) then
					table.RemoveByValue(UVCommanders, v)
				end
			end
		end

		if next(UVCommanders) ~= nil then
			UVOneCommanderActive = true
			net.Start("UVHUDOneCommander")
			net.WriteEntity(UVCommanders[1])
			net.Broadcast()
		end

		--Commander cleanup when not targeting
		if not UVTargeting then
			if UVOneCommanderDeployed then
				if not UVOneCommanderActive then
					UVOneCommanderDeployed = nil
				end
			end
			if UVCommanderRespawning then
				UVCommanderRespawning = nil
			end
			if UVCommanderLastHealth then
				UVCommanderLastHealth = nil
				UVCommanderLastEngineHealth = nil
			end
		end

		--Wrecked vehicles
		for i = 1, #UVWreckedVehicles do
			local car = UVWreckedVehicles[i]
			if not IsValid(car) then
				table.remove(UVWreckedVehicles, i)
			end
		end

		--Idle presence
		if not UVTargeting and (UVPresenceMode) and uvIdleSpawning - CurTime() + 5 <= 0 then
			HandleVehicleSpawning(true)
			uvIdleSpawning = CurTime()
		end

		--Deploying backup
		if not UVTargeting then
			UVBackupTimer = CurTime()
		end

		local backupTimeout = 2

		if backupTimeout then
			if CurTime() > UVBackupTimer + backupTimeout then
				if HeatLevels:GetBool() then
					UVUpdateHeatLevel()
				end
				if #UVUnitsChasing < 2 then
					UVTacticFormationNo = math.random(0,6)
				end
				UVChangeTactics(UVTacticFormationNo)
				UVBackupTimer = CurTime()
			end
		end

		--Actual backup timer
		if UVTargeting then
			if UVGlobalPursuit.ResourcePoints < UVMaxUnits then
				if not UVBackupUnderway then
					UVResourcePointsTimer = CurTime()
					UVResourcePointsTimerMax = UVBackupTimerMax
					UVBackupUnderway = true

					for _, v in pairs(UVWantedTableVehicle) do
						local scope = UVGetScope(v)
						if scope.InPursuit then UVAddInfraction(v, 'resource', true) end
					end

					timer.Simple(1, function()
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)
						local unit = units[random_entry]
						local uvchatter = math.random(1,10)
						if unit and Chatter:GetBool() then
							UVChatterBackupOnTheWay(unit)
						end
					end)
				else
					net.Start( "UVHUDBackuptimer" )
					net.WriteString(UVResourcePointsTimerLeft)
					net.Broadcast()
				end

				if not UVResourcePointsTimerMax then
					UVResourcePointsTimerMax = UVBackupTimerMax
				end

				UVResourcePointsTimerLeft = (UVResourcePointsTimer - CurTime() + UVResourcePointsTimerMax)
				if UVResourcePointsTimerLeft <= 10 then
					if not UVBackupTenSeconds then
						UVBackupTenSeconds = true
						--Entity(1):EmitSound("ui/pursuit/backup/countdown_start.wav", 0, 100, 0.5, CHAN_STATIC)
						--Entity(1):EmitSound("ui/pursuit/backup/countdown_tick.wav", 0, 100, 0.5, CHAN_STATIC)
						UVRelaySoundToClients("ui/pursuit/backup/countdown_start.wav", false)
						UVRelaySoundToClients("ui/pursuit/backup/countdown_tick.wav", false)
						timer.Create( "UVBackupTenSecondsTick", 1, 9, function() 
							if not UVTargeting then return end
							UVRelaySoundToClients("ui/pursuit/backup/countdown_tick.wav", false)
						end)
						for i=6,9 do
							timer.Simple( i + 1, function()
								if not UVTargeting then return end
								if i == 9 then
									UVRelaySoundToClients("ui/pursuit/backup/countdown_end.wav", false)
								else
									UVRelaySoundToClients("ui/pursuit/backup/countdown_".. 9 - i ..".wav", false)
								end
							end)
						end
					end
				else
					if UVBackupTenSeconds then
						UVBackupTenSeconds = nil
					end
				end
				if UVResourcePointsTimerLeft <= 0 and UVBackupUnderway then
					net.Start( "UVHUDStopBackupTimer" )
					net.Broadcast()
					UVResourcePointsTimer = CurTime()
					UVRestoreResourcePoints()
					--PrintMessage( HUD_PRINTCENTER, "REINFORCEMENTS INCOMING!")
					if next(ents.FindByClass("npc_uv*")) ~= nil then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)
						local unit = units[random_entry]
						local uvchatter = math.random(1,10)
						if Chatter:GetBool() then
							UVChatterBackupOnScene(unit)
						end
					end
				end
			else
				if UVBackupUnderway then
					UVBackupUnderway = nil
					-- net.Start( "UVHUDStopBackupTimer" )
					-- net.Broadcast()
				end
				UVResourcePointsTimer = CurTime()
				-- net.Start( "UVHUDStopBackupTimer" )
				-- net.Broadcast()
			end
		end

		if next(UVVehicleInitializing) ~= nil then
			for k, car in pairs(UVVehicleInitializing) do
				if IsValid(car) and ((isfunction(car.IsInitialized) and car:IsInitialized()) or car.IsGlideVehicle or (car.LVS and car:IsInitialized()) or car:GetClass() == "prop_vehicle_jeep") then
					if car.uvclasstospawnon == "npc_uvcommander" then
						local health = car.uvlasthealth or UVUOneCommanderHealth:GetInt()
						local enginehealth = car.uvlastenginehealth or 1.0
						if car.IsSimfphyscar then
							car:SetCurHealth(health)
						elseif car.IsGlideVehicle then
							car.MaxChassisHealth = UVUOneCommanderHealth:GetInt()
							car:SetChassisHealth( health )
							car:SetEngineHealth( enginehealth )
							car:UpdateHealthOutputs()
						elseif car:GetClass() == "prop_vehicle_jeep" then
							if vcmod_main then
								car:VC_setHealthMax(UVUOneCommanderHealth:GetInt())
								car:VC_setHealth(health)
							else
								car:SetMaxHealth(UVUOneCommanderHealth:GetInt())
								car:SetHealth(health)
							end
						end
						UVCommanderRespawning = nil
					else
						if car:GetClass() == "prop_vehicle_jeep" and not vcmod_main then
							local mass = car:GetPhysicsObject():GetMass()
							car:SetMaxHealth(mass)
							car:SetHealth(mass)
						end
					end

					if not car.UnitVehicle then 
						local uv = ents.Create(car.uvclasstospawnon) 
						uv:SetPos(car:GetPos())
						uv.uvscripted = true
						uv.vehicle = car
						uv:Spawn()
						uv:Activate()
					else
						if UVTargeting then
							UVSetELS(true, car)
							UVSetELSSound(true, car)
						end
						car.UnitVehicle.uvplayerlastvehicle = car
						if car.IsSimfphyscar then
							car.UnitVehicle:EnterVehicle( car.DriverSeat )
						elseif car.IsGlideVehicle then
							local seat = car.seats[1]
							if IsValid(seat) then
								car.UnitVehicle:EnterVehicle(seat)
							end
						elseif car:GetClass() == "prop_vehicle_jeep" then
							car.UnitVehicle:EnterVehicle(car)
						elseif car.LVS then
							car.UnitVehicle:EnterVehicle(car:GetDriverSeat())
						end

						net.Start("UVHUDAddUV")
						net.WriteInt(car:EntIndex(), 32)
						net.WriteInt(car:GetCreationID(), 32)
						net.WriteString("unit")
						net.Broadcast()

						UVUnitVehicles[car] = car
					end
					
					table.RemoveByValue(UVVehicleInitializing, car)
				end
			end
		end

		local visible_suspects = {}
		
		for unit, _ in pairs(UVUnitVehicles) do
			if not IsValid(unit) or not unit.UnitVehicle or unit.wrecked then
				UVUnitVehicles[unit] = nil
				continue
			end

			if unit.uvkillswitching then
				UVKillSwitchCheck(unit)
			end

			if unit.UnitVehicle:IsPlayer() then
				if UVUnitIsWrecked(unit) then
					UVPlayerWreck(unit)
				end
			end
		end

		UVUnitsHavePlayers = next(UVGetPlayerCops()) ~= nil
		
		for _, v in pairs(UVWantedTableVehicle) do
			local last_visible_value = v.inunitview
			
			local vScope = UVGetScope(v)
			if not vScope then continue end
			local visualrange = (vScope.Hiding or (not vScope.InPursuit and UVCheckIfHiding(v))) and 1000000 or 25000000
			vScope.UnitsChasing = 0
			
			v.closestunit = nil
			v.closestdistancetounit = nil
			v.inunitview = false
			--local check = false
			
			-- Visibility check for helicopter, should they have busting enabled.
			for _, j in pairs(ents.FindByClass("uvair")) do
				if (not (j.Downed and j.disengaging and j.crashing)) and j:GetTarget() == v then
					local isInRange = j:DistIgnoreZ( v:GetPos() ) <= ( vScope.Hiding and 2000 or 10000 )
					
					if isInRange and ( v.inunitview or UVVisualOnTarget( j, v ) ) then
						v.inunitview = true
						vScope.UnitsChasing = vScope.UnitsChasing + 1
						--check = true
						local closestunit = v.closestunit
						local closestdistancetounit = v.closestdistancetounit
						
						local dist = j:GetPos():DistToSqr(v:GetPos())
						if UVUHelicopterBusting:GetBool() and ( not closestunit or dist < closestdistancetounit ) then
							v.closestunit = j
							v.closestdistancetounit = dist
						end
					end
				end
			end
			
			-- Every 0.5 seconds, we update the visibility of the wanted vehicle.
			-- Had to reduce the interval to save up on a little performance
			if not check and (not _LAST_VISIBLE_UPDATE or _LAST_VISIBLE_UPDATE < CurTime() - 0.5) then
				for unit, _ in pairs(UVUnitVehicles) do
					local dist = unit:GetPos():DistToSqr(v:GetPos())
					local withinRange = dist < visualrange
					if withinRange and ( v.inunitview or UVVisualOnTarget( unit, v ) ) then
						vScope.UnitsChasing = vScope.UnitsChasing + 1
						v.inunitview = true
						
						local closestunit = v.closestunit
						local closestdistancetounit = v.closestdistancetounit
						
						if not closestunit or dist < closestdistancetounit then
							v.closestunit = unit
							v.closestdistancetounit = dist
							if unit.UnitVehicle and unit.UnitVehicle:IsPlayer() then
								unit.e = v
							end
						end
					end
				end
			end
			
			if v.gpsdarttagged and next(v.gpsdarttagged) ~= nil then
				v.inunitview = true
			end
			
			v._lastVisibilityChange = v._lastVisibilityChange or 0
			local now = CurTime()
			
			if last_visible_value ~= v.inunitview then
				v._lastVisibilityChange = now
				
				net.Start("UVUpdateSuspectVisibility")
				net.WriteEntity(v)
				net.WriteBool(v.inunitview)
				net.Broadcast()
			end
			
			-- Right now, whether a vehicle is pursuable is determined by:
			-- 1. The vehicle's bounty is greater than or equal to the minimum bounty required for pursuit.
			-- 2. The vehicle has fines due of at least $500 ONLY IF there is an active pursuit going on.
			-- 3. The vehicle is currently involved in an active race.
			-- This might change in the future, but for now this is the logic for pursuing vehicles during existing pursuits.
			-- I was considering making only certain infractions immediately start a pursuit, but meh...
			local isPursuable = vScope.Bounty >= GetConVar("unitvehicle_unit_heatminimumbounty1"):GetInt() or ( UVTargeting and vScope.FinesDue >= 500 ) or v.uvraceparticipant
			local isClosestCopPlayer = v.closestunit and v.closestunit.UnitVehicle:IsPlayer()
			
			-- If a suspect is being pulled over, we don't want the timeout to be reached even if the vehicle is complying.
			-- Basically, instead of relying on a constantly ticking timer, we just decrease it if the vehicle is moving.
			-- This allows the cop to actually get to the suspect without triggering a pursuit due to it taking too long.
			-- If any pursuit starts (UVTargeting is true), the traffic stop is called off so that the Unit can join the chase.
			-- (unless isPursuable is true, in which case the pulled over suspect will be added to the chase)
			if vScope.IsBeingPulledOver then
				local vehicleVelocity = v:GetVelocity():Length2DSqr()
				
				if vehicleVelocity > 10000 then 
					v.TrafficStopTimeout = v.TrafficStopTimeout - FrameTime() 
				end
				
				-- If the traffic stop timeout is reached, 
				-- we end the traffic stop and mark the vehicle as pursuable.
				if v.TrafficStopTimeout <= 0 then
					if v.TargetingUnit and v.TargetingUnit.UnitVehicle and v.TargetingUnit.UnitVehicle:IsNPC() then
						UVChatterPursuitStartRanAway( v.TargetingUnit.UnitVehicle, v )
					end
					UVEndTrafficStop(v)
					UV_InitiatePursuit(v)
				end
				
				if UVTargeting then 
					local isUnitPlayer = IsValid(v.TargetingUnit) and v.TargetingUnit.UnitVehicle:IsPlayer()
					if not isUnitPlayer then
						UVEndTrafficStop(v) 
					end
				end
			end
			
			if v.inunitview then
				if vScope.InPursuit then
					vScope.Losing = 0
				elseif not vScope.IsBeingPulledOver then
					-- if the closest unit is a player, we let them decide whether to target or not
					-- we use their ELS system to decide this.
					if isClosestCopPlayer then
						local canInitiate = UVGetELS( v.closestunit )
						
						if canInitiate then
							if not isPursuable then
								UVInitiateTrafficStop( v.closestunit, v )
							end
						else
							isPursuable = false
						end
					end
				end
			else
				if vScope.InPursuit then
					if NeverEvade:GetBool() and not vScope.EnemyEscaping then
						vScope.Losing = 0
					else
						vScope.Losing = math.Clamp( vScope.Losing + FrameTime(), 0, 5 )
					end
				end
			end
			
			if v.inunitview and not vScope.InPursuit and isPursuable then
				if v.closestunit then
					if v.closestunit.UnitVehicle:IsNPC() then
						UVChatterPursuitStartWanted(v.closestunit.UnitVehicle, v)
					else
						UVChatterPursuitStartAcknowledge(v.closestunit.UnitVehicle)
					end
				end
				UV_InitiatePursuit(v)
				hook.Run('UV_Event', 'onSuspectSpotted', v)
			end
			
			if not v.UVBustingProgress then
				v.UVBustingProgress = 0
			end
			
			if not v.UVBustingLastProgress then 
				v.UVBustingLastProgress = CurTime()
			end
			
			if not v.UVBustingLastProgress2 then 
				v.UVBustingLastProgress2 = CurTime()
			end
			
			UVCheckIfBeingBusted(v)
		end
		
		for _key, _scope in pairs(UVPursuitScopes) do
			local _veh = Entity(_scope.EntIndex)
			if IsValid(_veh) and _scope.EnemyEscaping then
				_scope.Hiding = UVCheckIfHiding(_veh)
			else
				_scope.Hiding = false
			end
			if _scope.Hiding then anyHiding = true end
		end

		for _, v in pairs(UVPotentialSuspects) do
			local vph = v:GetPhysicsObject()
			if not vph then return end

			local vAngles = vph:GetAngles()
			local vVelo = vph:GetVelocity()
			local vAnglesVelo = vph:GetAngleVelocity()

			local scope = UVGetScope(v)

			--Stunt jump
			if not v.UVStuntJump then
				local onground = util.QuickTrace(v:WorldSpaceCenter(), -vector_up * ActionCamJumpThreshold:GetInt(), {v})
				if not onground.Hit and vVelo:LengthSqr() > 30976 then
					v.UVStuntJump = true

					local driver = UVGetDriver(v)
					if driver then
						UVActionCam(driver, "Jump")
					end

					timer.Simple(10, function()
						v.UVStuntJump = nil
					end)

					if not scope.vEscaping and scope.InPursuit then
						local randomno = math.random(1,2)
						local units = ents.FindByClass("npc_uv*")
						local airUnits = ents.FindByClass("uvair")
						table.Merge(units, airUnits)

						local randomUnit = units[math.random(1, #units)]
						UVChatterStuntJump(randomUnit)
					end
				end
			end

			--Stunt roll
			if not v.UVStuntRoll then
				if vAngles.z > 90 and vAngles.z < 270 and vVelo:LengthSqr() < 10000 then
					v.UVStuntRoll = true

					timer.Simple(10, function()
						v.UVStuntRoll = nil
					end)

					if not scope.vEscaping and scope.InPursuit then
						local randomno = math.random(1,2)
						local units = ents.FindByClass("npc_uv*")
						local airUnits = ents.FindByClass("uvair")
						table.Merge(units, airUnits)

						local randomUnit = units[math.random(1, #units)]
						UVChatterStuntRoll(randomUnit)
					end
				end
			end

			--Stunt spin
			if not v.UVStuntSpin then
				if vAnglesVelo.z > 180 then
					v.UVStuntSpin = true

					timer.Simple(10, function()
						v.UVStuntSpin = nil
					end)

					if not scope.vEscaping and scope.InPursuit then
						local randomno = math.random(1,2)
						local units = ents.FindByClass("npc_uv*")
						local airUnits = ents.FindByClass("uvair")
						table.Merge(units, airUnits)

						local randomUnit = units[math.random(1, #units)]
						UVChatterStuntSpin(randomUnit)
					end
				end
			end
		end

		--Idle chatter
		if #ents.FindByClass("npc_uv*") > 0 and not UVTargeting then
			if not (timer.Exists("uvidletalk")) then
				timer.Create("uvidletalk", 10, 0, function()
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)
					local unit = units[random_entry]
					local uvchatter = math.random(1,10)
					if Chatter:GetBool() then
						if uvchatter == 1 then
							UVChatterDispatchIdleTalk(unit)
						elseif uvchatter == 2 then
							UVChatterIdleTalk(unit)
						end
					end
				end)
			end
		else
			if timer.Exists("uvidletalk") then
				timer.Remove("uvidletalk")
			end
		end

		-- Escape/cooldown progression is handled per-scope in UVScopeThink.
		-- This section only fires side effects (chatter, sounds) on global state transitions.
		-- TODO: Rewrite a bit

		-- -- Global escape transition chatter (SFX is now per-scope in UVScopeThink)
		-- if not _uvLastEscapingState and UVEnemyEscaping then
		-- 	if Chatter:GetBool() and not UVCalm and not UVEnemyBusted then
		-- 		if next(ents.FindByClass("npc_uv*")) ~= nil then
		-- 			local units = ents.FindByClass("npc_uv*")
		-- 			local unit = units[math.random(#units)]
		-- 			UVChatterLosing(unit)
		-- 			timer.Simple(math.random(10, 20), function()
		-- 				if UVEnemyEscaping then
		-- 					UVChatterLosingUpdate(unit)
		-- 				end
		-- 			end)
		-- 		end
		-- 	end
		-- elseif _uvLastEscapingState and not UVEnemyEscaping and not UVEnemyEscaped and not UVEnemyBusted then
		-- 	if Chatter:GetBool() and not UVCalm and not UVEnemyBusted then
		-- 		local airUnits = ents.FindByClass("uvair")
		-- 		if next(airUnits) ~= nil then
		-- 			local unit = airUnits[math.random(#airUnits)]
		-- 			if not (unit.crashing or unit.disengaging) then
		-- 				UVChatterFoundEnemy(unit)
		-- 			elseif next(ents.FindByClass("npc_uv*")) ~= nil then
		-- 				local units = ents.FindByClass("npc_uv*")
		-- 				UVChatterFoundEnemy(units[math.random(#units)])
		-- 			end
		-- 		elseif next(ents.FindByClass("npc_uv*")) ~= nil then
		-- 			local units = ents.FindByClass("npc_uv*")
		-- 			UVChatterFoundEnemy(units[math.random(#units)])
		-- 		end
		-- 	end
		-- end
		-- _uvLastEscapingState = UVEnemyEscaping

		-- -- shit that fires on all escape
		-- if not _uvLastEscapedState and UVEnemyEscaped and not UVTargeting then
		-- 	for k, v in pairs(ents.FindByClass("npc_uv*")) do
		-- 		v:ForgetEnemy()
		-- 	end
		-- 	for k, v in pairs(player.GetAll()) do
		-- 		v:SetHealth(100)
		-- 		v:SetMaxHealth(100)
		-- 		if v:InVehicle() then
		-- 			local car = v:GetVehicle()
		-- 			if car:GetClass() == "prop_vehicle_jeep" and vcmod_main then
		-- 				car:VC_repairFull_Admin()
		-- 				if car:VC_hasGodMode() then
		-- 					car:VC_setGodMode(false)
		-- 				end
		-- 			elseif car.IsSimfphyscar then
		-- 				if car.simfphysoldhealth then
		-- 					car:SetMaxHealth(car.simfphysoldhealth)
		-- 					car:SetCurHealth(car.simfphysoldhealth)
		-- 					car.simfphysoldhealth = nil
		-- 				end
		-- 				if istable(car.Wheels) then
		-- 					for i = 1, table.Count(car.Wheels) do
		-- 						local Wheel = car.Wheels[i]
		-- 						if IsValid(Wheel) then
		-- 							Wheel:SetDamaged(false)
		-- 							Wheel.UVTireDeflatable = nil
		-- 						end
		-- 					end
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- 	for k, v in pairs(ents.FindByClass("uvair")) do
		-- 		v.disengaging = true
		-- 	end
		-- 	if #ents.FindByClass("npc_uv*") > 0 then
		-- 		local units = ents.FindByClass("npc_uv*")
		-- 		if Chatter:GetBool() then
		-- 			UVChatterLost(units[math.random(#units)])
		-- 		end
		-- 	end
		-- end
		-- _uvLastEscapedState = UVEnemyEscaped and not UVTargeting

		if CurTime() > (uv_next_racer_name_check or 0) then 
			uv_next_racer_name_check = CurTime() + 5

			for _, v in pairs(UVWantedTableVehicle) do
				if v.racer then
					net.Start( "UVUpdateRacerName" )
					net.WriteEntity( v )
					net.WriteString( v.racer )
					net.Broadcast()
				end
			end
		end

		--Players in Action Cam
		for _, ply in pairs(UVPlayersInActionCam) do
			if not IsValid(ply) then 
				table.RemoveByValue(UVPlayersInActionCam, ply)
				continue 
			end

			if ply.ActionCam and RealTime() >= ply.ActionCamTime then
				table.RemoveByValue(UVPlayersInActionCam, ply)

				ply.ActionCamAIControl = nil

				local vehicle = UVGetVehicle(ply)
				if IsValid(vehicle) then
					vehicle.aicontrolled = nil

					if not vehicle.ghoston and vehicle:GetCollisionGroup() == 20 then
						vehicle:SetCollisionGroup(0)
					end
	
					if vehicle.RacerVehicle then
						vehicle.RacerVehicle:Remove()
					end
				end

				net.Start("UVActionCamStop")
				net.Send(ply)

				ply.ActionCam = nil

				game.SetTimeScale(1.0)
				CF_CanSetTimeScale = true
			end
		end

		--HUD Triggers
		if UVTargeting then

			if not UVHUDPursuit then
				UVRestoreResourcePoints()
				if game.SinglePlayer() and ActionCamSpotted:GetBool() then --SPOTTED CAMERA
					local ply = Entity(1)
					local v = UVGetVehicle(ply)
					local vScope = UVGetScope(v)
					if vScope and vScope.InPursuit then
						local closestunit
						local closestdistancetounit
	
						local units = ents.FindByClass("npc_uv*")
						local airUnits = ents.FindByClass("uvair")
						local playerUnits = UVGetPlayerCops(true)
	
						table.Add( units, airUnits )
						table.Add( units, playerUnits )
	
						local r = math.huge
						local closestdistancetounit, closestunit = r^2
	
						for i, w in pairs(units) do
							local plypos = ply:WorldSpaceCenter()
							local distance = plypos:DistToSqr(w:WorldSpaceCenter())
							if distance < closestdistancetounit and UVStraightToWaypoint(plypos, w:WorldSpaceCenter()) then
								if w:GetClass() ~= 'uvair' then
									closestdistancetounit, closestunit = distance, w.v
								else
									closestdistancetounit, closestunit = distance, w
								end
							end
						end
	
						if closestunit then
							UVActionCam(ply, "Spotted", closestunit)
						end	
					end
				end

				for k, v in pairs(UVGetPlayerCops(true)) do
					UVSetELS(true, v)
					UVSetELSSound(true, v)
				end
			end

			if not UVHUDPursuit then
				UVUpdateGlobalPursuit('PursuitStart', CurTime())
				UVHUDScreenFlashStartTime = CurTime()
			end

			UVHUDPursuit = true

		else
			if UVHUDPursuit then
				UVHUDPursuit = nil
				UVHUDBusting = nil
				net.Start( "UVHUDStopBusting" )
				net.Broadcast()

				if uvhudtimestopped then return end
				uvhudtimestopped = true

				local debrieftable = {
					["Deploys"] = UVDeploys,
					["Bounty"] = string.Comma( UVBounty or 0 ),
					["Tags"] = UVTags or 0,
					["Wrecks"] = UVWrecks or 0,
					["Roadblocks"] = UVRoadblocksDodged or 0,
					["Spikestrips"] = UVSpikestripsDodged or 0,
					["PursuitLength"] = CurTime() - UVGlobalPursuit.PursuitStart,
				}

				if not UVEnemyEscaped then
					net.Start( "UVHUDCopModeBustedDebrief" )
					net.WriteTable(debrieftable)
					net.Send(UVGetPlayerCops())
				else
					net.Start( "UVHUDCopModeEscapedDebrief" )
					net.WriteTable(debrieftable)
					net.Send(UVGetPlayerCops())
				end

				UVUpdateGlobalPursuit('PursuitStart', 0)

				timer.Simple(1, function()
					uvhudtimestopped = nil
					if not UVTargeting then
						UVResetStats()
					end
				end)
			end

		end

		if UVEnemyBusted and next(UVWantedTableVehicle) == nil then
			net.Start( "UVHUDEnemyBusted" )
			net.Broadcast()
		end

		-- Cooldown and hiding are now derived from active scope on client
        if UVTargeting then
            if not UVEnemyBusted and next(UVWantedTableVehicle) == nil then
                UVTargeting = nil
            end
        end
	end)
	
	net.Receive("UVCancelUnitRespawn", function(len, ply)
		if ply.uvspawningunit then
			timer.Remove(ply.uvspawningunit.timer)
			ply.uvspawningunit = nil
			
			net.Start("UVSpawnQueueUpdate")
			net.WriteString("") -- empty vehicle = clear
			net.WriteInt(0, 16)
			net.WriteString("")
			net.Send(ply)

			net.Start("UVHUDRespawnInUVPlyMsg")
			net.WriteString("uv.chase.select.spawn.cancel")
			net.Send(ply)
		end
	end)

	function UVHUDRespawn( ply, unit, unitnpc, isrhino, unitname, relocate )
		local timerName = "UVSpawnQueue_" .. ply:SteamID64()

		if ply.uvspawningunit then
			net.Start( "UVHUDRespawnInUVPlyMsg" )
			net.WriteString("uv.chase.select.spam")
			net.Send(ply)
			return
		end

		if (UVOneCommanderActive or UVOneCommanderDeployed) and unitnpc == "npc_uvcommander" then --Trying to spawn a Commander when it shouldn't...
			ply:PrintMessage( HUD_PRINTTALK, UVString("uv.chase.select.commander.deployed") )

			local UnitsPatrol = string.Trim( GetConVar( 'unitvehicle_unit_unitspatrol' .. UVHeatLevel ):GetString() )
			local UnitsSupport = string.Trim( GetConVar( 'unitvehicle_unit_unitssupport' .. UVHeatLevel ):GetString() )
			local UnitsPursuit = string.Trim( GetConVar( 'unitvehicle_unit_unitspursuit' .. UVHeatLevel ):GetString() )
			local UnitsInterceptor = string.Trim( GetConVar( 'unitvehicle_unit_unitsinterceptor' .. UVHeatLevel ):GetString() )
			local UnitsSpecial = string.Trim( GetConVar( 'unitvehicle_unit_unitsspecial' .. UVHeatLevel ):GetString() )
			local UnitsRhino = string.Trim( GetConVar( 'unitvehicle_unit_unitsrhino' .. UVHeatLevel ):GetString() )
			local UnitsCommander = ""

			net.Start("UVHUDRespawnInUVSelect")
			net.WriteString(UnitsPatrol)
			net.WriteString(UnitsSupport)
			net.WriteString(UnitsPursuit)
			net.WriteString(UnitsInterceptor)
			net.WriteString(UnitsSpecial)
			net.WriteString(UnitsRhino)
			net.WriteString(UnitsCommander)
			net.Send(ply)
			return
		end

		local playercontrolled = {
			["unit"] = unit,
			["unitnpc"] = unitnpc
		}

		local cooldown = SpawnCooldownTable[ply] and math.Round(SpawnCooldown:GetInt() - (CurTime() - SpawnCooldownTable[ply])) or 0
		local cooldownmsg = ""

		local plymsg = { msg = "uv.chase.select.spawning", unit = unit, cooldown = nil }

		if IsValid(ply.uvplayerlastvehicle) and ply.uvplayerlastvehicle.wrecked then
			if relocate then return end

			SpawnCooldownTable[ply] = CurTime()

			ply:EmitSound("ui/redeploy/redeploy" .. math.random(1, 4) .. ".wav")

			ply:ExitVehicle()
			ply:Spawn()

			UVAutoSpawn(ply, isrhino, nil, playercontrolled)
			plymsg.msg = "uv.chase.select.spawning"

			if RandomPlayerUnits:GetBool() then plymsg.msg = "uv.chase.select.spawning.random" end

			net.Start( "UVHUDRespawnInUVPlyMsg" )
			net.WriteString(plymsg.msg)
			net.WriteString(unitname)
			net.Send(ply)
		else
			if not SpawnCooldownTable[ply] then
				SpawnCooldownTable[ply] = 0
			else
				if CurTime() - SpawnCooldownTable[ply] < SpawnCooldown:GetInt() then

					plymsg.msg = "uv.chase.select.spawning.cooldown"
					plymsg.cooldown = cooldown
					
					if RandomPlayerUnits:GetBool() then plymsg.msg = "uv.chase.select.spawning.cooldown.random" end
					if relocate then plymsg.msg = "uv.chase.select.spawning.cooldown.relocate" end
					
					net.Start("UVSpawnQueueUpdate")
					net.WriteString(unitname)      -- vehicle/unit name
					net.WriteInt(cooldown, 16) -- cooldown in seconds
					net.WriteString(plymsg.msg) -- player message
					net.Send(ply)
				end
			end

			ply.uvspawningunit = {
				unit = unit,
				unitnpc = unitnpc,
				timer = timerName,
				cooldown = cooldown
			}

			local vehicle = UVGetVehicle( ply )
			local isInUnitVehicle = IsValid( vehicle ) and vehicle.UnitVehicle == ply

			if relocate and not isInUnitVehicle then return end

			-- timer.Simple(cooldown, function()
			timer.Create(timerName, cooldown, 1, function()
				SpawnCooldownTable[ply] = CurTime()
				ply.uvspawningunit = nil
				net.Start( "UVHUDRespawnInUVPlyMsg" )
				
				if relocate then
					net.WriteString("uv.chase.select.spawning.relocate")
				else
					if RandomPlayerUnits:GetBool() then
						net.WriteString("uv.chase.select.spawning.random")
					else
						net.WriteString("uv.chase.select.spawning")
					end
				end

				net.WriteString(unitname)
				net.Send(ply)
				
				net.Start("UVSpawnQueueUpdate")
				net.WriteString("") -- empty vehicle = clear
				net.WriteInt(0, 16)
				net.Send(ply)

				local newVehicle = UVGetVehicle( ply )

				if relocate then
					if not IsValid(newVehicle) or newVehicle ~= vehicle then return end

					ply:EmitSound("ui/redeploy/redeploy" .. math.random(1, 4) .. ".wav")

					UVOptimizeRespawn( vehicle, ply )
					return 
				end

				if IsValid(ply.uvplayerlastvehicle) and not ply.uvplayerlastvehicle.wrecked then
					if table.HasValue(UVUnitsChasing, ply.uvplayerlastvehicle) then
						table.RemoveByValue(UVUnitsChasing, ply.uvplayerlastvehicle)
					end

					ply.uvplayerlastvehicle:Remove()
				end

				ply:EmitSound("ui/redeploy/redeploy" .. math.random(1, 4) .. ".wav")

				ply:ExitVehicle()
				ply:Spawn()

				UVAutoSpawn(ply, isrhino, nil, playercontrolled)
			end)
		end
	end

	net.Receive("UVHUDRespawnInUV", function( length, ply )
		if UVGame then return end

		local isInUnitVehicle = net.ReadBool()
		local unit = net.ReadString()
		local unitnpc = net.ReadString()
		local isrhino = net.ReadBool()
		local unitname = net.ReadString()

		-- if isInUnitVehicle then
		-- 	local vehicle = UVGetVehicle( ply )

		-- 	if IsValid( vehicle ) and vehicle.UnitVehicle == ply then
		-- 		UVOptimizeRespawn( vehicle, ply )
		-- 	end

		-- 	return 
		-- end

		UVHUDRespawn(ply, unit, unitnpc, isrhino, unitname, isInUnitVehicle)
	end)
	
	net.Receive("UVHUDRespawnInUVGetInfo", function( length, ply )
		if UVGame then
			local vehicle = UVGetVehicle( ply )
			local isInUnitVehicle = IsValid( vehicle ) and vehicle.UnitVehicle == ply

			if isInUnitVehicle then
				UVHUDRespawn(ply, "", "", false, "Random", true)
				return
			end
		end

		if RandomPlayerUnits:GetBool() then
			UVHUDRespawn(ply, "", "", false, "Random")
			return
		end

		local UnitsPatrol = string.Trim( GetConVar( 'unitvehicle_unit_unitspatrol' .. UVHeatLevel ):GetString() )
		local UnitsSupport = string.Trim( GetConVar( 'unitvehicle_unit_unitssupport' .. UVHeatLevel ):GetString() )
		local UnitsPursuit = string.Trim( GetConVar( 'unitvehicle_unit_unitspursuit' .. UVHeatLevel ):GetString() )
		local UnitsInterceptor = string.Trim( GetConVar( 'unitvehicle_unit_unitsinterceptor' .. UVHeatLevel ):GetString() )
		local UnitsSpecial = string.Trim( GetConVar( 'unitvehicle_unit_unitsspecial' .. UVHeatLevel ):GetString() )
		local UnitsRhino = string.Trim( GetConVar( 'unitvehicle_unit_unitsrhino' .. UVHeatLevel ):GetString() )
		local UnitsCommander = string.Trim( GetConVar( 'unitvehicle_unit_unitscommander' .. UVHeatLevel ):GetString() )
		
		if UVOneCommanderActive or UVOneCommanderDeployed then
			UnitsCommander = ""
		end

		if RandomPlayerUnits:GetBool() then
			UnitsPatrol = ""
			UnitsSupport = ""
			UnitsPursuit = ""
			UnitsInterceptor = ""
			UnitsSpecial = ""
			UnitsRhino = ""
			UnitsCommander = ""
		end

		local vehicle = UVGetVehicle( ply )
		local isInUnitVehicle = IsValid( vehicle ) and vehicle.UnitVehicle == ply

		net.Start("UVHUDRespawnInUVSelect")
		net.WriteBool(isInUnitVehicle)
		net.WriteString(UnitsPatrol)
		net.WriteString(UnitsSupport)
		net.WriteString(UnitsPursuit)
		net.WriteString(UnitsInterceptor)
		net.WriteString(UnitsSpecial)
		net.WriteString(UnitsRhino)
		net.WriteString(UnitsCommander)
		net.Send(ply)
	end)

	-- net.Receive("UVHUDReAddUV", function( length, ply )
	-- 	local unitindex = net.ReadInt(32)
	-- 	local typestring = net.ReadString()
	-- 	local unit = Entity(unitindex)
	-- 	if not IsValid(unit) then return end
	-- 	net.Start("UVHUDAddUV")
	-- 	net.WriteInt(unitindex, 32)
	-- 	net.WriteString(typestring)
	-- 	net.Send(ply)
	-- end)

	gameevent.Listen( "player_activate" )
	hook.Add( "player_activate", "UV_PlayerDataReplicator", function( data ) 
		local id = data.userid				-- Same as Player:UserID() for the speaker
		local ply = Player(id)

		print('Unit Vehicles:', 'Initializing for -', ply)
		-- Send all pursuit scopes to connecting player
		if next(UVPursuitScopes) then
			local allScopeData = {}
			local i = 0
			for key, scope in pairs(UVPursuitScopes) do
				i = i + 1
				timer.Simple(i * 0.01, function()
					UVReplicateFullScope(key, scope, ply)
				end)
			end
		end

		-- Send global pursuit state
		local serializedJson = util.TableToJSON(UVGlobalPursuit)
		local compressedJson = util.Compress(serializedJson)
		local messageSize = #compressedJson

		net.Start("UV_SetGlobal")
		net.WriteBool(true)
		net.WriteUInt(messageSize, 16)
		net.WriteData(compressedJson, messageSize)
		net.Send(ply)

		for v, _ in pairs( UVUnitVehicles ) do
			net.Start( "UVHUDAddUV" )
			net.WriteInt( v:EntIndex(), 32 )
			net.WriteInt( v:GetCreationID(), 32 )
			net.WriteString( "unit" )
			net.Send( ply )
		end

		for _, v in pairs( UVWantedTableVehicle ) do
			net.Start( "UV_AddWantedVehicle" )
			net.WriteInt( v:EntIndex(), 32 )
			net.WriteInt( v:GetCreationID(), 32 )
			net.Send( ply )
		end

		if not ply:IsListenServerHost() then
			for convarKey, _ in pairs(ReplicatedVars) do
				net.Start( "UVGetSettings_Local" )
				net.WriteString(convarKey)
				net.WriteString(GetConVar(convarKey):GetString())
				net.Send(ply)
			end
		end

	end )

	function UV_UpdateSettings( array )
		for key, value in pairs(array) do
			if string.match(key, 'unitvehicle_') or string.match(key, 'uvpursuittech_') then
				local convarType = type(value)
				local convar = GetConVar(key)

				if convar then
					--[[
						So for some fucking reason unbeknownst to me, RunConsoleCommand convars refuse to work for certain strings, 
						yet it works if you set it using the ConVar::SetX functions, bullshit.
					]]
					convar:SetString(value)

					if ReplicatedVars[key] then
						for _, v in ipairs( ents.FindByClass("player") ) do
							if not v:IsListenServerHost() then
								net.Start( "UVGetSettings_Local" )
								net.WriteString(key)
								net.WriteString(value)
								net.Send(v)
							end
						end
					end
				end
			end
		end
	end

	net.Receive("UVUpdateSettings", function(len, ply)
		if ply and not ply:IsSuperAdmin() then return end
		local array = net.ReadTable()
		
		UV_UpdateSettings(array)
	end)

	concommand.Add( "uv_setbounty", function( ply, cmd, args )
		if not ply:IsSuperAdmin() then return end
		UVBounty = tonumber(args[1]) or 0
	end)

else -- CLIENT Settings | HUD/Options

	local displaying_busted = false 
	UVSettingKeybind = false

	local UVHUDScreenFlashHeatUp = 0

	UVDeploys = 0
	UVUnitsChasing = 0
	UVBustingProgress = 0

	local UVClosestSuspect = nil

	UVHUDBlipSoundTime = CurTime()
	UVHUDScannerPos = Vector(0,0,0)

	KeyBindButtons = {}
	UnitTable = {}
	EntityQueue = {}
	CleanupTask = {}

	local unitBlipColors = {
	    [1] = Color(0, 0, 255),
		[2] = color_white,
	    [3] = Color(150, 0, 0),
	    [4] = color_white
	}

	UNIT_BLIPS = UNIT_BLIPS or {}

	local function RegisterUnitBlip(id)
	    UNIT_BLIPS[id] = id
	end

	local function UnregisterUnitBlip(id)
	    UNIT_BLIPS[id] = nil
	end

	local unitBlipColorsCurrent = 1

	timer.Create("UpdateUnitBlips", 0.035, 0, function()
	    if table.IsEmpty(UNIT_BLIPS) then return end

	    local currentFlashColor = unitBlipColors[unitBlipColorsCurrent]
		unitBlipColorsCurrent = unitBlipColorsCurrent % #unitBlipColors + 1
	
	    local disabledColor = unitBlipColors[2]
	    local inactiveColor = unitBlipColors[3]

	    for id, data in pairs(UNIT_BLIPS) do
	        local blip = GMinimap:FindBlipByID(data)

	        if not blip then
	            UnregisterUnitBlip(id)
	            continue
	        end

	        if blip.disabled then
	            blip.color = disabledColor
	        elseif not IsPursuitActive then
	            blip.color = inactiveColor
	        else
	            blip.color = currentFlashColor
	        end
	    end
	end)

	PursuitTheme = CreateClientConVar("unitvehicle_pursuittheme", "", true, false, "Unit Vehicles: Pursuit Theme (string).")
	PursuitSFX = CreateClientConVar("unitvehicle_pursuitsfx", 1, true, false, "Unit Vehicles: If set to 1, Pursuit SFX will play.")
	PlayMusic = CreateClientConVar("unitvehicle_playmusic", 1, true, false, "Unit Vehicles: If set to 1, Pursuit themes will play.")
	PursuitThemePlayRandomHeat = CreateClientConVar("unitvehicle_pursuitthemeplayrandomheat", 0, true, false, "Unit Vehicles: If set to 1, random Heat Level songs will play during pursuits every 10 minutes.")
	PursuitThemePlayRandomHeatMinutes = CreateClientConVar("unitvehicle_pursuitthemeplayrandomheatminutes", 10, true, false, "Unit Vehicles: If set to 'Every X minutes', all Heat Level songs will play during pursuits every X minutes.")
	PursuitThemePlayRandomHeatType = CreateClientConVar("unitvehicle_pursuitthemeplayrandomheattype", "Sequential", true, false, "Unit Vehicles: If set to 'Sequential', random Heat Level songs will play after another. If set to 'Every 10 minutes', all Heat Level songs will play during pursuits every 10 minutes.")
	RacingMusic = CreateClientConVar("unitvehicle_racingmusic", 1, true, false, "Unit Vehicles: If set to 1, Racing music will play.")
	RacingMusicPriority = CreateClientConVar("unitvehicle_racingmusicpriority", 0, true, false, "Unit Vehicles: If set to 1, Racing music will play during pursuits while racing.")
	RacingThemeOutsideRace = CreateClientConVar("unitvehicle_racingmusicoutsideraces", 0, true, false, "Unit Vehicles: If set to 1, Racing music will play during pursuits even while not racing.")
	PursuitVolume = CreateClientConVar("unitvehicle_pursuitthemevolume", 1, true, false, "Unit Vehicles: Determines volume of the pursuit theme.")
	ChatterVolume = CreateClientConVar("unitvehicle_chattervolume", 1, true, false, "Unit Vehicles: Determines volume of the Unit Vehicles' radio chatter.")
	MuteCheckpointSFX = CreateClientConVar("unitvehicle_mutecheckpointsfx", 0, true, false, "Unit Vehicles: If set to 1, the SFX that plays when passing checkpoints will be silent.")
	UVTraxFreeroam = CreateClientConVar("unitvehicle_uvtraxinfreeroam", 0, true, false, "Unit Vehicles: If set to 1, UV TRAX™ will play in Freeroam whenever you're in a vehicle.")
	UVSubtitles = CreateClientConVar("unitvehicle_subtitles", 1, true, false, "Unit Vehicles: If set to 1, display subtitles when Cop Chatter is active. Only works for Default Chatter, and only in English.")
	UVVehicleNameTakedown = CreateClientConVar("unitvehicle_vehiclenametakedown", 0, true, false, "Unit Vehicles: If set to 1, Unit takedowns use the vehicle name instead of the unit name.")
	UVDisplayUnits = CreateClientConVar("unitvehicle_unitstype", 0, true, false, "Unit Vehicles: If set to 0 (or an invalid value), displays units in meters. If set to 1, displays units in feet. If set to 2, displays units in yards.")
	LVSAlwaysFullThrottle = CreateConVar( "unitvehicle_lvsalwaysfullthrottle", 0, {FCVAR_ARCHIVE, FCVAR_USERINFO}, "LVS Always Full Throttle." )

	RacerTags = CreateClientConVar("unitvehicle_racertags", 1, true, false, "Unit Vehicles: If set to 1, Racers and Commander Units will have name tags above their vehicles.")
	RacerTagsThickness = CreateClientConVar("unitvehicle_racertags_thickness", 1.5, true, false, "Unit Vehicles: Sets the thickness of the name tags, capped at 3.")
	RacerTagsDistance = CreateClientConVar("unitvehicle_racertags_distance", 100, true, false, "Unit Vehicles: Sets the distance the tags start to fade out.")
	RacerTagsMaxNr = CreateClientConVar("unitvehicle_racertags_max", 3, true, false, "Unit Vehicles: Sets the maximum amount of name tags on-screen at once.")

	UVControllerMode = CreateClientConVar("unitvehicle_controllermode", 0, true, false, "Unit Vehicles: If set to 1, certain actions in the UV Menu are swapped to work with more controller-friendly alternatives, such as JUMP instead of MOUSE1.")
	UVGlyphOverride = CreateClientConVar("unitvehicle_glyph_override", 0, true, false, "Unit Vehicles: If set to 1, it enables an override to display specified glyphs in the UV Menu and certain other elements rather than their accurate ones.")
	UVGlyphSet = CreateClientConVar("unitvehicle_glyph_set", "", true, false, "Unit Vehicles: The glyph set used for the Glyph Override.")

	UVPoliceScanner = CreateClientConVar("unitvehicle_policescanner", 1, true, false, "Unit Vehicles: If set to 1, the police scanner will be enabled.")
	UVPoliceScannerVehicle = CreateClientConVar("unitvehicle_policescanner_vehicle", 0, true, false, "Unit Vehicles: If set to 1, the police scanner will use your vehicle as its anchor rather than the camera viewpoint.")

	-- for i = 1, MAX_HEAT_LEVEL do
	-- 	local prevIterator = i - 1

	-- 	local timeTillNextHeatId = ((prevIterator == 0 and 'enabled') or prevIterator)

	-- 	for _, v in pairs( {'Patrol', 'Support', 'Pursuit', 'Interceptor', 'Special', 'Commander', 'Rhino'} ) do
	-- 		local lowercaseUnit = string.lower( v )
	-- 		local conVarKey = string.format( 'units%s%s', lowercaseUnit, i )

	-- 		-------------------------------------------

	-- 		CreateClientConVar( "unitvehicle_unit_" .. conVarKey, "", true, false)
	-- 	end

	-- 	for _, conVar in pairs( HEAT_SETTINGS ) do
	-- 		local conVarKey = conVar .. ((conVar == 'timetillnextheat' and timeTillNextHeatId) or i)
	-- 		local check = (conVar == "timetillnextheat")

	-- 		CreateClientConVar( "unitvehicle_unit_" .. conVarKey, HEAT_DEFAULTS[conVar][tostring( ( check and timeTillNextHeatId ) or i )] or 0, true, false)
	-- 	end
	-- end

	--UVUTimeTillNextHeatEnabled = CreateClientConVar("unitvehicle_unit_timetillnextheatenabled", 0, true, false)

	UVPTKeybindSlot1 = CreateClientConVar("unitvehicle_pursuittech_keybindslot_1", KEY_T, true, false)
	UVPTKeybindSlot2 = CreateClientConVar("unitvehicle_pursuittech_keybindslot_2", KEY_P, true, false)

	UVKeybindResetPosition = CreateClientConVar("unitvehicle_keybind_resetposition", KEY_M, true, false)
	UVKeybindShowRaceResults = CreateClientConVar("unitvehicle_keybind_raceresults", KEY_N, true, false)

	UVKeybindSkipSong = CreateClientConVar("unitvehicle_keybind_skipsong", KEY_RBRACKET, true, false)
	UVKeybindPrevSong = CreateClientConVar("unitvehicle_keybind_prevsong", KEY_LBRACKET, true, false)

	-- UVPBMax = CreateClientConVar("unitvehicle_pursuitbreaker_maxpb", 2, true, false)
	-- UVPBCooldown = CreateClientConVar("unitvehicle_pursuitbreaker_pbcooldown", 60, true, false)

	-- UVRBMax = CreateClientConVar("unitvehicle_roadblock_maxrb", 1, true, false)
	-- UVRBOverride = CreateClientConVar("unitvehicle_roadblock_override", 0, true, false)

	UVHUDTypeMain = CreateClientConVar("unitvehicle_hudtype_main", "mostwanted", true, false, "Unit Vehicles: Which HUD type to use when in races and pursuits.")
	UVHUDTypeBackup = CreateClientConVar("unitvehicle_hudtype_backup", "mostwanted", true, false, "Unit Vehicles: Which HUD type to use if main does not have a Pursuit UI.")

	UVHUDXDeadzone = CreateClientConVar("unitvehicle_hud_deadzone", 0, true, false, "Unit Vehicles: Increase to move UI elements closer to the center of the screen.")
	UVHUDXScale = CreateClientConVar("unitvehicle_hud_scale", 1, true, false, "Unit Vehicles: Increase or decrease the size of the UI elements.")

	UVUnitsColor = Color(255,255,255)

	UVSelectedHeatTrack = 1
	UVLastHeatChange = -math.huge

	UVHeatLevel = 1
	UVHUDWantedSuspects = {}

	function UVUnitManagerExportPreset( name )
		local jsonArray = {
			['Name'] = name,
			['Data'] = {}
		}

		for cVarKey, _ in pairs( conVarList ) do
			if table.HasValue( PROTECTED_CONVARS, cVarKey ) then continue end

			local newKey = 'unitvehicle_unit_' .. cVarKey
			local cVar = GetConVar( newKey )
			if cVar then
				jsonArray.Data[newKey] = cVar:GetString()
			end
		end

		if not file.IsDir( 'unitvehicles/preset_export', 'DATA' ) then
			file.CreateDir( 'unitvehicles/preset_export' )
		end

		if not file.IsDir( 'unitvehicles/preset_export/uvunitmanager', 'DATA' ) then
			file.CreateDir( 'unitvehicles/preset_export/uvunitmanager' )
		end

		file.Write( 'unitvehicles/preset_export/uvunitmanager/' .. name .. '.json', util.TableToJSON( jsonArray ) )
		chat.AddText( Color( 0, 150, 0 ), "Your preset has been exported!\nDestination: data/unitvehicles/preset_export/uvunitmanager/" .. name .. ".json" )
	end

	if not file.IsDir( 'data/unitvehicles/preset_import', 'GAME' ) then
		file.CreateDir( 'unitvehicles/preset_import' )
	end

	if not file.IsDir( 'data/unitvehicles/preset_import/uvunitmanager', 'GAME' ) then
		file.CreateDir( 'unitvehicles/preset_import/uvunitmanager' )
	end

	-- Exporting presets from presets lib into preset_import (new system)
	timer.Simple(5, function()
		if not LocalPlayer():IsListenServerHost() then return end

		local oldPresets = table.Copy( presets.GetTable("units") )
		local shownWarn = false

		for name, data in pairs(oldPresets) do
			local found

			if not UVPresets.uvunitmanager then break end
			if not shownWarn then
				chat.AddText( Color( 9, 255, 0), "[Unit Vehicles]: Local presets from the old system have been imported into the new system. You may need to reload the map for the presets to appear!\nPresets that share the same name as presets from currently mounted UV addons have been ignored.\nThis is the last time this message will be displayed.")
				shownWarn = true
			end

			presets.Remove( "units", name )
			
			for _, presetName in pairs( UVPresets.uvunitmanager ) do
				if name == presetName then
					found = true
					break
				end
			end

			if found then continue end

			local presetData = {
				Name = name,
				Data = data
			}

			if not file.IsDir( 'unitvehicles/preset_import/uvunitmanager', 'DATA' ) then
				file.CreateDir( 'unitvehicles/preset_import/uvunitmanager' )
			end

			file.Write( 'unitvehicles/preset_import/uvunitmanager/' .. string.lower( name ) .. '.json', util.TableToJSON( presetData ) )
		end

		oldPresets = table.Copy( presets.GetTable("pursuittech") )

		for name, data in pairs(oldPresets) do
			local found
			if not UVPresets.uvpursuittech then break end
			if not shownWarn then
				chat.AddText( Color( 9, 255, 0), "[Unit Vehicles]: Local presets from the old system have been imported into the new system. You may need to reload the map for the presets to appear!\nPresets share the same name as presets from currently mounted UV addons have been ignored.\nThis is the last time this message will be displayed.")
				shownWarn = true
			end
			presets.Remove( "pursuittech", name )

			for _, presetName in pairs( UVPresets.uvpursuittech ) do
				if name == presetName then
					found = true
					break
				end
			end

			if found then continue end

			local presetData = {
				Name = name,
				Data = data
			}

			if not file.IsDir( 'unitvehicles/preset_import/uvpursuittech', 'DATA' ) then
				file.CreateDir( 'unitvehicles/preset_import/uvpursuittech' )
			end

			file.Write( 'unitvehicles/preset_import/uvpursuittech/' .. string.lower( name ) .. '.json', util.TableToJSON( presetData ) )
		end
	end)

	local function InitEntity( entIndex, creationId, entType, entColor )
		local entity = Entity( entIndex )
		if not IsValid( entity ) then return end

		local localCreationId = entity:GetCreationID()

		if localCreationId ~= creationId then 
			return 
		end

		if entType == "unit" or entType == "air" then

			table.insert( UnitTable, entity )

			if GMinimap then
				local entClass = entity:GetClass()
				local unitIcon = (entType == "air" and "unitvehicles/icons/HELICOPTER_MINIMAP_ICON.png") or "unitvehicles/icons/MINIMAP_ICON_CAR.png"

				if entClass == "prop_vehicle_jeep" and entType ~= "air" then
					unitIcon = "unitvehicles/icons/MINIMAP_ICON_CAR_JEEP.png"
				end

				local blip, id = GMinimap:AddBlip({
					id = "UVBlip" .. entIndex,
					parent = entity,
					icon = unitIcon,
					scale = (entType == "air" and 2) or 1.4,
					color = Color( 150, 0, 0 ),
					alpha = 255
				})

				RegisterUnitBlip(id)
			end

		elseif entType == "roadblock" then

			if GMinimap then
				local blip, id = GMinimap:AddBlip( {
					id = "UVBlip" .. entIndex,
					parent = entity,
					icon = "unitvehicles/icons/MINIMAP_ICON_ROADBLOCK.png",
					scale = 1.4,
					color = Color( 255, 255, 0),
					alpha = 255
				} )
			end
			-- timer.Simple(0.1, function()
			-- 	blip.alpha = 255
			-- end)

		elseif entType == "repairshop" then

			if GMinimap then
				local blip, id = GMinimap:AddBlip( {
					id = "UVBlip" .. entIndex,
					parent = entity,
					icon = "unitvehicles/icons/repairshop.png",
					scale = 2,
					color = Color( 0, 255, 0),
					alpha = 255,
					lockIconAng = true
				} )
			end

		elseif entType == "racer" then
			table.insert( UVHUDWantedSuspects, entity )
		elseif entType == "drivermodel" then
			local vecCache = entColor:ToVector()
			entity.GetPlayerColor = function() return vecCache end
		end

		return true
		--EntityQueue[entIndex] = nil
	end

	net.Receive("UVHUDStartPursuitNotification", function()
		local text = UVString( net.ReadString() )

		if UVIsUsingOGHUD() then
			LocalPlayer():PrintMessage( HUD_PRINTTALK, UVString("uv.hud.chase.starting.original") )
			return
		end

		UV_UI.general.events.CenterNotification({
            text = text,
		})
	end)

	net.Receive("UVHUDStartPursuitCountdown", function()
		local starttime = net.ReadInt(11)

		if UVIsUsingOGHUD() then
			local countdownTexts = {
				[4] = 3,
				[3] = 2,
				[2] = 1,
				[1] = UVString("uv.race.go")
			}

			local textToShow = countdownTexts[starttime]
			if not textToShow then return end

			if starttime > 1 then
				LocalPlayer():PrintMessage( HUD_PRINTTALK, string.format(UVString("uv.hud.chase.starting.original.count"), textToShow) )
			else
				LocalPlayer():PrintMessage( HUD_PRINTTALK, textToShow )
			end

			return
		end

		local main = UVHUDTypeMain:GetString()
		local backup = UVHUDTypeBackup:GetString()

		if main == "" then return end

		local hudHandler = UV_UI.racing[main] and UV_UI.racing[main].events.onRaceStartTimer
		
		if not hudHandler then
			hudHandler = UV_UI.racing[backup] and UV_UI.racing[backup].events.onRaceStartTimer
		end

		if hudHandler then
			hudHandler({
				starttime = starttime,
				noBG = true,
				noReadyText = true,
			})
		else
			local countdownTexts = {
				[4] = 3,
				[3] = 2,
				[2] = 1,
				[1] = UVString("uv.race.go")
			}

			local textToShow = countdownTexts[starttime]
			if not textToShow then return end

			local startTime = CurTime()
			local duration = 1
			local hookName = "UV_PURSUITSTARTTIME"

			-- Replace existing hook cleanly
			hook.Remove("HUDPaint", hookName)
			hook.Add("HUDPaint", hookName, function()
				local elapsed = CurTime() - startTime
				if elapsed > duration then
					hook.Remove("HUDPaint", hookName)
					return
				end

				local x, y = ScrW() * 0.5, ScrH() * 0.45
				draw.SimpleTextOutlined(
					textToShow,
					"UVFont5",
					x, y,
					Color(255, 255, 255),
					TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
					3, Color(0, 0, 0, 255)
				)
			end)
		end
	end)

	net.Receive('UVGetNewKeybind', function()
		--if UVSettingKeybind then return end
		local slot = net.ReadInt(16)
		local key = net.ReadInt(16)

		local entry = KeyBindButtons[slot]

		if entry then
			local convar = GetConVar( entry[1] )

			if convar then
				convar:SetInt( key )
			end
		else
			warn("Invalid slot key; if you run into this please report it to a developer!")
		end

		UVSettingKeybind = false
	end)

	net.Receive("UV_SendPursuitTech", function()
		local car = net.ReadEntity()
		local slot = net.ReadUInt(2)
		local active = net.ReadBool()
		if not IsValid(car) then return end

		-- Entire table cleared
		if not active and slot == 0 then
			car.PursuitTech = nil
			return
		end

		if active then
			if not car.PursuitTech then car.PursuitTech = {} end
			if not car.PursuitTech[slot] then car.PursuitTech[slot] = {} end

			car.PursuitTech[slot].Tech = net.ReadString()
			car.PursuitTech[slot].Ammo = net.ReadUInt(8)
			car.PursuitTech[slot].Cooldown = net.ReadUInt(16)
			car.PursuitTech[slot].LastUsed = net.ReadFloat()
		elseif car.PursuitTech then
			car.PursuitTech[slot] = nil
			-- If both slots are now nil, clear the table completely for cleanliness
			if not car.PursuitTech[1] and not car.PursuitTech[2] then
				car.PursuitTech = nil
			end
		end
	end)

	-- ========================
	-- Scope Net Receivers (client)
	-- ========================

	net.Receive('UV_SetScope', function()
		local key = net.ReadString()
		local messageSize = net.ReadUInt(16)
		local recvData = net.ReadData(messageSize)

		local decompData = util.Decompress(recvData)
		local dataTable = util.JSONToTable(decompData)

		if not UVPursuitScopes[key] then
			UVPursuitScopes[key] = table.Copy(UV_SCOPE_DEFAULTS)
		end

		local scope = UVPursuitScopes[key]
		for k, v in pairs(dataTable) do
			local oldVal = scope[k]
			scope[k] = v

			if UV_UI_Events and UV_UI_Events[k] then
				local activeScope = UVGetActiveScope()
				if activeScope == scope then
					hook.Run('UIEventHook', 'pursuit', UV_UI_Events[k], v, oldVal)
				end
			end
		end
	end)

	net.Receive('UV_RemoveScope', function()
		local key = net.ReadString()
		UVPursuitScopes[key] = nil
	end)

	net.Receive('UV_GetAllScopes', function()
		local messageSize = net.ReadUInt(16)
		local recvData = net.ReadData(messageSize)

		local decompData = util.Decompress(recvData)
		local allScopes = util.JSONToTable(decompData)

		if allScopes then
			for key, scopeData in pairs(allScopes) do
				if not UVPursuitScopes[key] then
					UVPursuitScopes[key] = table.Copy(UV_SCOPE_DEFAULTS)
				end
				for k, v in pairs(scopeData) do
					UVPursuitScopes[key][k] = v
				end
			end
		end
	end)

	net.Receive('UV_SetGlobal', function()
		local fullReplace = net.ReadBool()
		local messageSize = net.ReadUInt(16)
		local recvData = net.ReadData(messageSize)

		local decompData = util.Decompress(recvData)
		local dataTable = util.JSONToTable(decompData)

		if dataTable then
			if dataTable.ResourcePoints and dataTable.ResourcePoints ~= (UVGlobalPursuit.ResourcePoints or 0) then
				hook.Run('UIEventHook', 'pursuit', 'onResourceChange', dataTable.ResourcePoints, UVGlobalPursuit.ResourcePoints or 0)
			end

			if fullReplace then
				UVGlobalPursuit = dataTable
			else
				for k, v in pairs(dataTable) do
					UVGlobalPursuit[k] = v
				end
			end
		end
	end)

	net.Receive('UVGetSettings_Local', function()
		local key = net.ReadString()
		local value = net.ReadString()

		local convar = GetConVar(key)
		if convar and string.match(key, 'unitvehicle_') then
			convar:SetString(value)
		end
	end)

	net.Receive('UVPresets_Remove', function()
		local type = net.ReadString()
		local fileName = net.ReadString()

		if UVPresets[type] then
			UVPresets[type][fileName] = nil
		end

		hook.Run('UVPresetsEvent', 'Remove', type, fileName)
	end)

	net.Receive('UVPresets_Add', function()
		local type = net.ReadString()
		local fileName = net.ReadString()
		local name = net.ReadString()

		if not UVPresets[type] then UVPresets[type] = {} end
		UVPresets[type][fileName] = name

		hook.Run('UVPresetsEvent', 'Add', type, fileName, name)
	end)

	net.Receive('UVPresets_Set', function()
		local type = net.ReadString()
		local messageSize = net.ReadUInt(16)
		local recvData = net.ReadData(messageSize)

		local setTable = util.JSONToTable( util.Decompress( recvData ) )

		if type == "__ALL" then
			UVPresets = setTable
		else
			UVPresets[type] = setTable
		end

		hook.Run('UVPresetsEvent', 'Set', type, setTable)
	end)

	unitvehicles = true

	local UVHUDCopsDamaged = Material("unitvehicles/icons/COPS_DAMAGED_ICON.png")
	local UVHUDCopsWrecked = Material("unitvehicles/icons/COPS_TAKENOUT_ICON.png")
	local UVHUDMilestoneBounty = Material("unitvehicles/icons/MILESTONE_PURSUITBOUNTY.png")
	local UVHUDMilestoneInfractions = Material("unitvehicles/icons/MILESTONE_INFRACTIONS.png")
	local UVHUDMilestoneRoadblocks = Material("unitvehicles/icons/MILESTONE_ROADBLOCKS.png")
	local UVHUDMilestoneSpikestrips = Material("unitvehicles/icons/MILESTONE_SPIKESTRIPS.png")
	local UVHUDPursuitBreaker = Material("unitvehicles/icons/WORLD_PURSUITBREAKER.png")
	local UVHUDBlipSound = "ui/pursuit/spotting_blip.wav"

	concommand.Add("uv_keybinds", function( ply, cmd, slot )
		if UVSettingKeybind then
			notification.AddLegacy( "You are already setting a keybind!", NOTIFY_ERROR, 5 )
			return
		end

		local slot = slot[1]

		net.Start("UVPTKeybindRequest")
		net.WriteInt(slot, 16)
		net.SendToServer()

		UVSettingKeybind = slot
		-- KeyBindButtons[tonumber(slot)][2]:SetText('PRESS A KEY NOW!')
	end)

	concommand.Add("uv_local_update_settings", function( ply )
		if not ply:IsSuperAdmin() then
			notification.AddLegacy( "You need to be a super admin to apply settings on server!", NOTIFY_ERROR, 5 )
			return
		end

		local convar_table = {}

		for convar_name, convar_type in pairs(LOCAL_CONVARS) do
			local convar = GetConVar(convar_name)
			local value = nil

			if convar_type == 'boolean' then
				value = convar:GetBool()
			elseif convar_type == 'integer' then
				value = convar:GetInt()
			elseif convar_type == 'string' then
				value = convar:GetString()
			end

			if value then
				convar_table[convar_name] = value
			end
		end

		net.Start("UVUpdateSettings")
		net.WriteTable(convar_table)
		net.SendToServer()

		notification.AddLegacy('Pursuit Settings applied!', NOTIFY_GENERIC, 3)
	end)

	concommand.Add("uv_spawn_as_unit", function(ply)
		if RandomPlayerUnits:GetBool() and not UVGame then
			UVMenu.UnitSelect( {}, {}, {}, UVHUDCopMode )
			return
		end

		net.Start("UVHUDRespawnInUVGetInfo")
		net.SendToServer()
	end)

	net.Receive("UVHUDBackupTimer", function()

		UVBackupProgress = net.ReadString()
		UVBackupTimerSeconds = tonumber(UVBackupProgress)
		UVBackupTimer = UVDisplayTime(UVBackupProgress)
		UVHUDDisplayBackupTimer = true

	end)

	net.Receive("UVHUDStopBackupTimer", function()

		UVHUDDisplayBackupTimer = nil

	end)

	net.Receive( "UVPullOver", function()
		hook.Run( 'UIEventHook', 'pursuit', 'onPullOverRequest' )
	end)

	net.Receive( "UVFined", function()
		local finenr = net.ReadUInt(2)
		local finesdue = net.ReadUInt(32)
		hook.Run( 'UIEventHook', 'pursuit', 'onFined', finenr, finesdue )
	end)

	net.Receive( "UVFineArrest", function()
		hook.Run( 'UIEventHook', 'pursuit', 'onFineArrest' )
	end)

	net.Receive("UVHUDTimer", function()

		UVTimerStart = net.ReadString()

		if not UVTimerWhenFroze then
			UVTimerWhenFroze = 0
		end
		if not UVCooldownProgress then
			UVCooldownProgress = 0
		end

		if not UVHUDDisplayCooldown and not UVBustedState then
			if UVTimerFroze then
				UVTimerFroze = nil
			end
		else
			if not UVTimerFroze then
				UVTimerWhenFroze = CurTime()-UVCooldownProgress
				UVTimerFroze = true
			end
		end

		if not UVTimerFroze then
			UVCooldownProgress = UVCooldownProgress
			UVTimerProgress = (CurTime() - tonumber(UVTimerStart)-UVCooldownProgress)
		else
			UVTimerProgress = UVTimerProgress
			UVCooldownProgress = (CurTime() - UVTimerWhenFroze)
		end

		UVTimer = UVDisplayTime(UVTimerProgress)

	end)

	net.Receive("UVHUDTimeTillNextHeat", function()

		local time = net.ReadFloat()
		if not time then return end
		UVTimeTillNextHeat = time

	end)

	net.Receive("UVHUDStopPursuit", function()

		UVHUDDisplayPursuit = nil
		UVTimerWhenFroze = 0
		UVCooldownProgress = 0
		UVHUDRaceInProgress = nil

		UVSoundEscaped(UVHeatLevel)

	end)

	net.Receive("UVHUDUpdateBusting", function()
		local ent = net.ReadEntity()
		local progress = net.ReadFloat()

		ent.UVBustingProgress = progress
	end)


	net.Receive("UVHUDBusting", function()
		local lang = UVString
		UVBustingProgress = net.ReadString()
		UVHUDDisplayBusting = true
		UVBustedColor = Color( 255, 255, 255, 50 )
		UVNotification = lang("uv.chase.busting")
		UVBustingTimeLeft = math.Round((BustedTimer:GetFloat()-UVBustingProgress),3)

		if UVBustingTimeLeft <= 0 then
			UVNotification = true
		end

	end)

	net.Receive("UVHUDStopBusting", function()

		UVHUDDisplayBusting = nil
		UVHUDDisplayNotification = nil

	end)

	net.Receive("UVHUDStopBustingTimeLeft", function()

		local timeleft = math.Round((BustedTimer:GetFloat() - net.ReadFloat()), 3)

		if not UVHUDDisplayNotification and not UVBustedState then
			UVNotificationColor = Color( 0, 255, 0)
			UVNotification = string.format(UVString("uv.chase.evadedtime"), timeleft)
			UVHUDDisplayNotification = true
			timer.Simple(2, function()
				if not UVHUDDisplayBusting then
					UVHUDDisplayNotification = nil
				end
			end)
		end

	end)

	net.Receive("UVHUDEnemyBusted", function()
		UVNotificationColor = Color(255, 0, 0)
		UVBustedColor = Color(255, 0, 0)
		local bustedtext = UVString("uv.chase.busted")
		if not UVHUDDisplayNotification then
			if UVHUDRaceInProgress and #UVHUDWantedSuspects < 1 then
				bustedtext = UVString("uv.race.shutdown")
			end
			UVBustedState = true
			UVNotification = "/// " .. bustedtext .. " ///"
			UVHUDDisplayNotification = true
			timer.Simple(5.1, function()
				UVBustedState = false
				UVHUDDisplayNotification = nil
			end)
		end

		if UVHUDDisplayPursuit and not UVPlayingRace and not UVActionCam then
			UVSoundBusted( UVHeatLevel )
		end
	end)

	net.Receive("UVHUDCopModeBusting", function()
		local enemy = net.ReadEntity()
		enemy.beingbusted = true
	end)

	net.Receive("UVHUDStopCopModeBusting", function()
		local enemy = net.ReadEntity()
		enemy.beingbusted = nil
	end)

	net.Receive("UVHUDOneCommander", function()
		UVHUDCommander = net.ReadEntity()
		if UVHUDCommander.IsGlideVehicle then 
			if UVHUDCommander.MaxChassisHealth ~= UVUOneCommanderHealth:GetInt() then
				UVHUDCommander.MaxChassisHealth = UVUOneCommanderHealth:GetInt()
			end
		end
		if not UVOneCommanderActive and IsValid(UVHUDCommander) then
			UVOneCommanderActive = true
			local MathSound = math.random(1,6)
			surface.PlaySound("ui/pursuit/commanderonscene/commanderonscene"..MathSound..".wav")
		end
	end)

	net.Receive("UVHUDStopOneCommander", function()
		UVOneCommanderActive = nil
	end)

	net.Receive("UVHUDHeatLevelIncrease", function()
		UVHUDScreenFlashHeatUp = CurTime()

		if not lastHeatlevel then
			lastHeatlevel = tonumber( UVHeatLevel )
		end
		
		UV_UI.general.events.CenterNotification({
			text = string.format( UVString("uv.hud.heatlvl"), UVHeatLevel + 1 )
		})

		if not UVPlayingRace and UVHUDDisplayPursuit then
			if not PursuitThemePlayRandomHeat:GetBool() or (PursuitThemePlayRandomHeat:GetBool() and PursuitThemePlayRandomHeatType:GetString() ~= "everyminutes") then
				UVHeatLevelIncrease = true
				UVStopSound()
			end
		end

		-- if not UVPlayingRace and (UVHUDDisplayPursuit and not (PursuitThemePlayRandomHeat:GetBool() and PursuitThemePlayRandomHeatType:GetString() == "everyminutes")) then
		-- 	UVHeatLevelIncrease = true
		-- 	UVStopSound()
		-- end
	end)

	net.Receive("UVHUDPursuitTech", function()
		local PursuitTech = net.ReadTable()
		UVHUDPursuitTech = PursuitTech
	end)

	net.Receive("UVHUDScanner", function()
		local posx = net.ReadInt(32)
		local posy = net.ReadInt(32)
		local posz = net.ReadInt(32)

		UVHUDScanner = true
		UVHUDScannerPos.x = posx
		UVHUDScannerPos.y = posy
		UVHUDScannerPos.z = posz
	end)

	net.Receive("UVHUDAddUV", function()
		local entIndex = net.ReadInt( 32 )
		local creationId = net.ReadInt( 32 )

		table.insert( EntityQueue, {
			entIndex = entIndex,
			creationId = creationId,
			entType = net.ReadString(),
			entColor = net.ReadColor()
		} )
	end)

	net.Receive("UVHUDRemoveUV", function()
		local entIndex = net.ReadInt(32)
		local creationId = net.ReadInt(32)

		table.insert(CleanupTask, {
			entIndex,
			creationId,
			function( entIndex, creationId )
				local entity = Entity( entIndex )

				if not IsValid(entity) then return true end
				if entity:GetCreationID() ~= creationId then return end

				if ent then
					table.RemoveByValue( UnitTable, ent )
				end

				if GMinimap then
					local blip = GMinimap:FindBlipByID("UVBlip" .. entIndex)
					if not blip then return end

					blip.color = Color( 255, 255, 255)
					blip.disabled = true
				end

				return true
			end
		})
	end)

	local corner8tex, corner32tex = surface.GetTextureID("gui/corner8"), surface.GetTextureID("gui/corner32")
	local function drawCircle(x, y, radius, seg)
		surface.SetTexture(radius <= 8 and corner8tex or corner32tex)
		surface.DrawTexturedRectUV( x-radius, y-radius, radius, radius, 0, 0, 1, 1 )
		surface.DrawTexturedRectUV( x, y-radius, radius, radius, 1, 0, 0, 1 )
		surface.DrawTexturedRectUV( x-radius, y, radius, radius, 0, 1, 1, 0 )
		surface.DrawTexturedRectUV( x, y, radius, radius, 1, 1, 0, 0 )
		draw.NoTexture()
	end

	hook.Add( "CanSeePlayerBlip", "RestrictPlayerBlipsExample", function( ply )
		if UVHUDCopMode then
			return false
		end
		return not UVHUDDisplayPursuit
	end )

	outofpursuit = 0

	function UVGetRandomHeat()
		local pursuitTheme = PursuitTheme:GetString()
		if not PursuitFilePathsTable[pursuitTheme] then return end

		local heatTable = PursuitFilePathsTable[PursuitTheme:GetString()].heat
		local heatCount = 0
		local isExcluded = false
		
		if heatTable then
			for i, v in pairs(heatTable) do
				if i ~= 'default' then
					heatCount = heatCount + 1
				end
			end
		end

		local newHeat = nil
		if heatCount > 0 then
			newHeat = math.random( 1, heatCount )
			while newHeat == UVSelectedHeatTrack and heatCount ~= 1 do
				newHeat = math.random( 1, heatCount )
			end
		else
			newHeat = 'default'
		end

		if not UVHeatPlayIntro then
			UVStopSound()
			if UVHUDDisplayPursuit then
				UVHeatPlayTransition = true
			end
		end

		UVLastHeatLevel = UVSelectedHeatTrack
		UVSelectedHeatTrack = newHeat
	end

	function UVResetRandomHeatTrack()
		if UVPlayingRace then return end
		UVLastHeatChange = CurTime()
		UVGetRandomHeat()
	end

	function UVIsUsingOGHUD()
		local main = UVHUDTypeMain:GetString()
		local backup = UVHUDTypeBackup:GetString()

		local hudHandler = UV_UI.pursuit[main] and UV_UI.pursuit[main].main

		if not hudHandler then
			hudHandler = UV_UI.pursuit[backup] and UV_UI.pursuit[backup].main
		end

		return UV_UI.pursuit.original and UV_UI.pursuit.original.main and hudHandler == UV_UI.pursuit.original.main
	end

	hook.Add("Think", "UVThink", function()

		local localPlayer = LocalPlayer()
		local vehicle = localPlayer:GetVehicle()
		local isValidVehicle = IsValid( vehicle )

		local var = UVKeybindSkipSong:GetInt()
		local varprev = UVKeybindPrevSong:GetInt()

		if isValidVehicle then
			if input.IsKeyDown(var) and not gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then localPlayer:ConCommand('uv_skipsong') end
			if input.IsKeyDown(varprev) and not gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then localPlayer:ConCommand('uv_prevsong') end
		end

		for i, v in pairs( EntityQueue ) do
			local ent = InitEntity( v.entIndex, v.creationId, v.entType, v.entColor )
			if ent then
				table.remove( EntityQueue, i )
			end
		end

		for i, array in pairs( CleanupTask ) do
			if array[3]( array[1], array[2] ) then
				table.remove( CleanupTask, i )
			end
		end

		if (not UVHUDDisplayPursuit) and ((not UVHUDDisplayRacing) or (not UVHUDRace)) then
			if not UVHUDRace and (RacingMusic:GetBool() and UVTraxFreeroam:GetBool()) and vehicle ~= NULL then
				UVSoundRacing()
			else
				UVStopSound()

				UVHUDDisplayBackupTimer = nil
				UVLoadedSounds = nil

				if UVSoundLoop then
					UVSoundLoop:Stop()
					UVSoundLoop = nil
				end
			end
		elseif (UVHUDDisplayPursuit or UVHUDDisplayRacing) then
			--if not RacingMusicPriority:GetBool() then
			if (UVHUDDisplayRacing and not RacingMusic:GetBool() and not UVHUDDisplayPursuit) or (UVHUDDisplayPursuit and not PlayMusic:GetBool()) then
				UVStopSound()
				if UVSoundLoop then
					UVSoundLoop:Stop()
					UVSoundLoop = nil
				end
			end
			--end
		end
		
		if UVHUDDisplayPursuit then
			if PursuitThemePlayRandomHeat:GetBool() and PursuitThemePlayRandomHeatType:GetString() == "everyminutes" then
				if CurTime() - UVLastHeatChange > PursuitThemePlayRandomHeatMinutes:GetInt() * 60 then
					UVResetRandomHeatTrack()
				end
			end
		else
			if UVLastHeatChange == -math.huge then
				UVResetRandomHeatTrack()
			end

			UVLastHeatChange = UVLastHeatChange + RealFrameTime()

			UVHeatPlayTransition = false
			UVHeatPlayIntro = true
		end

		UVHUDWantedSuspectsNumber = UV_GetInPursuitCount()

		if not UVHUDRaceInProgress and UVHUDWantedSuspectsNumber > 1 then
			UVHUDRaceInProgress = true
		end

		-- Per-scope HUD override: derive display values from the correct scope
		UVResourcePoints = UVGlobalPursuit.ResourcePoints or 0

		local _scopeVeh = UVGetVehicle(LocalPlayer())
		local _activeScope = IsValid(_scopeVeh) and UVGetScope(_scopeVeh) or nil

		IsPursuitActive = UV_GetInPursuitCount() > 0

		UVHUDCopMode = table.HasValue( UnitTable, UVGetVehicle( LocalPlayer() ) )

		if UVHUDCopMode and not _activeScope then
			local domScope = UV_GetDominantScope()
			if domScope then
				UVHeatLevel = domScope.Heat
				UVBounty = string.Comma(domScope.Bounty)
				UVBountyNo = domScope.Bounty
				UVDeploys = domScope.Deploys
				UVWrecks = domScope.Wrecks
				UVTags = domScope.Tags
				UVUnitsChasing = domScope.UnitsChasing
				UVTimeTillNextHeat = domScope.TimeTillNextHeatEnd > 0 and math.max(0, domScope.TimeTillNextHeatEnd - CurTime()) or nil
				UVTimerProgress = CurTime() - domScope.PursuitStart
				UVTimer = UVDisplayTime(UVTimerProgress)
				UVHUDDisplayCooldown = UV_GetCopAllInCooldown()
				UVEvadingProgress = UV_GetCopEvadeProgress()
			end
			UVHUDDisplayPursuit = domScope ~= nil
		elseif _activeScope then
			UVHUDCopMode = false
			UVHeatLevel = _activeScope.Heat
			UVBounty = string.Comma(_activeScope.Bounty)
			UVBountyNo = _activeScope.Bounty
			UVDeploys = _activeScope.Deploys
			UVWrecks = _activeScope.Wrecks
			UVTags = _activeScope.Tags
			UVFinesDue = string.Comma(_activeScope.FinesDue)
			UVUnitsChasing = _activeScope.UnitsChasing
			UVHUDDisplayPursuit = _activeScope.InPursuit
			UVHUDDisplayCooldown = _activeScope.InCooldown
			UVCooldownTimer = _activeScope.CooldownTimerProgress
			UVTimerProgress = CurTime() - _activeScope.PursuitStart
			UVTimer = UVDisplayTime(UVTimerProgress)
			--UVCooldownTimerProgress = _activeScope.CooldownTimerProgress
			UVTimeTillNextHeat = _activeScope.TimeTillNextHeatEnd > 0 and math.max(0, _activeScope.TimeTillNextHeatEnd - CurTime()) or nil
			if _activeScope.Losing then
				UVEvadingProgress = math.Clamp(_activeScope.Losing / 5, 0, 1)
			end
			if _activeScope.PursuitStart > 0 then
				PursuitStartTime = _activeScope.PursuitStart or 0
			end
			if _activeScope.Hiding and _activeScope.EnemyEscaping then
				local blink = math.floor(RealTime()*2)==math.Round(RealTime()*2) and 255 or 0
				UVNotificationColor = Color(blink, blink, 255)
				UVNotification = "--- " .. UVString("uv.chase.hiding") .. " ---"
				UVHUDDisplayNotification = true
				UVHUDDisplayHidingPrompt = true
			elseif not _activeScope.Hiding and UVHUDDisplayHidingPrompt then
				UVHUDDisplayNotification = nil
				UVHUDDisplayHidingPrompt = nil
			end
		else
			UVHUDDisplayPursuit = nil
		end

		if UVActionCam then			
			if UVPlayingRace then return end

			UVStopSound()
			if UVSoundLoop then
				UVSoundLoop:Stop()
				UVSoundLoop = nil
			end

			return
		end

		if not UVBustedState then
			if UVHUDDisplayPursuit then
				if not PlayMusic:GetBool() and not UVPlayingRace then 
					UVStopSound()
					if UVSoundLoop then
						UVSoundLoop:Stop()
						UVSoundLoop = nil
					end
				else
					if not UVHUDDisplayBusting and not UVHUDDisplayCooldown and not UVHUDDisplayNotification then
						UVSoundHeat( UVHeatLevel )
					elseif UVHUDDisplayCooldown then
						UVSoundCooldown( UVHeatLevel )
					elseif UVHUDDisplayBusting and (UVHUDCopMode and UVHUDWantedSuspectsNumber == 1) or not UVHUDCopMode then
						local UVBustTimer = BustedTimer:GetFloat()
						local timeLeft = ((UVHUDDisplayNotification and -1) or (UVBustTimer - UVBustingProgress))

						if timeLeft <= UVBustTimer * 0.7 then
							UVSoundBusting( UVHeatLevel )
						end
					end
				end
			end
		end
	end)
	
	local UVHUDScreenFlashDuration = 1.25

	local function DrawScreenFlash(startTime, color)
		if not startTime then return end
		local elapsed = CurTime() - tonumber(startTime)
		if elapsed >= UVHUDScreenFlashDuration then return end

		local alphaFrac
		if elapsed < (UVHUDScreenFlashDuration / 6) then
			-- Quick fade-in (first 1/6)
			alphaFrac = elapsed / (UVHUDScreenFlashDuration / 6)
		else
			-- Smooth fade-out (remaining 5/6)
			local fadeOutFrac = (elapsed - (UVHUDScreenFlashDuration / 6)) / (UVHUDScreenFlashDuration * (5/6))
			alphaFrac = 1 - (fadeOutFrac ^ 2)
		end

		local alpha = 255 * math.Clamp(alphaFrac, 0, 1)
		surface.SetMaterial(UVMaterials["SCREENFLASH_SMALL"])
		surface.SetDrawColor(color.r, color.g, color.b, alpha)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end

	hook.Add( "HUDPaint", "UVHUDPursuit", function() --HUD

		local localPlayer = LocalPlayer()
		local vehicle = localPlayer:GetVehicle()

		local w = ScrW()
		local h = ScrH()

		local hudyes = showhud:GetBool()
		local lang = UVString
		
		local main = UVHUDTypeMain:GetString()
		local backup = UVHUDTypeBackup:GetString()

		DrawScreenFlash(PursuitStartTime, Color(255, 255, 255)) -- white flash
		DrawScreenFlash(UVHUDScreenFlashHeatUp, Color(0, 0, 255))        -- blue flash

		-- local scope = UVGetScope(UVGetVehicle(LocalPlayer()))
		-- if scope then
		-- 	local details = {
		-- 		"InPursuit: " .. tostring(scope.InPursuit),
		-- 		"EnemyEscaping: " .. tostring(scope.EnemyEscaping),
		-- 		"EnemyEscaped: " .. tostring(scope.EnemyEscaped),
		-- 		"EnemyBusted: " .. tostring(scope.EnemyBusted),
		-- 		"Bounty: " .. tostring(scope.Bounty),
		-- 		"Heat: " .. tostring(scope.Heat),
		-- 		"Deploys: " .. tostring(scope.Deploys),
		-- 		"Wrecks: " .. tostring(scope.Wrecks),
		-- 		"Tags: " .. tostring(scope.Tags),
		-- 		"UnitsChasing: " .. tostring(scope.UnitsChasing),
		-- 	}

		-- 	for i, line in ipairs(details) do
		-- 		local ent = UVGetVehicle(LocalPlayer())
		-- 		if IsValid(ent) then
		-- 			local entPos = ent:GetPos()
		-- 			local ent2d = entPos:ToScreen()
		-- 			draw.DrawText(line, "DermaDefault", ent2d.x, ent2d.y + (i-1)*16, Color(255,255,255,255), 0)
		-- 		end
		-- 	end
		-- end

		local hudHandler = UV_UI.pursuit[main] and UV_UI.pursuit[main].main

		if not hudHandler then
			hudHandler = UV_UI.pursuit[backup] and UV_UI.pursuit[backup].main
		end

		if hudHandler then
			hudHandler()
		end

		local displayingracingandpursuit
		if UVIsUsingOGHUD() then
			displayingracingandpursuit = true -- Displays both racing and pursuit
		end

		if UV_UI.general then
			UV_UI.general.main()
		end

		local var = UVKeybindResetPosition:GetInt()

		if not displayingracingandpursuit then
			if not UVHUDCopMode and ((not UVHUDDisplayPursuit or UVHUDRace) and UVHUDDisplayBusting) then  -- Being fined/busted in a race
				local UVBustTimer = BustedTimer:GetFloat()
				local finetext = "uv.chase.fining"

				if UVHUDDisplayPursuit then
					finetext = "uv.chase.busting.other"
				end

				local bottomy = h * 0.89

				if not BustingProgress or BustingProgress == 0 then
					BustingProgress = CurTime()
				end

				local blink = 255 * math.abs(math.sin(RealTime() * 4))

				local timeLeft = ((UVHUDDisplayNotification and -1) or (UVBustTimer - UVBustingProgress))

				draw.SimpleTextOutlined( UVString(finetext), "UVMostWantedLeaderboardFont", w * 0.5, bottomy - h * 0.025, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.25, Color(0, 0, 0, 255) )

				surface.SetDrawColor(200, 200, 200, 125)
				surface.DrawRect(w * 0.4, bottomy, w * 0.2, h * 0.015)

				local T = math.Clamp((UVBustingProgress / UVBustTimer) * (w * 0.2), 0, w * 0.2)
				surface.SetDrawColor(255, 100, 100)
				surface.DrawRect(w * 0.4, bottomy, T, h * 0.015)
			else
				BustingProgress = 0
			end
		end
		
		local devMode = GetConVar("developer"):GetBool()
		
		-- if UVSubtitles:GetBool() and UV_CurrentSubtitle and CurTime() < (UV_SubtitleEnd or 0) then
			-- local text = lang(UV_CurrentSubtitle)
			-- local textcs = lang(UV_CurrentSubtitleCallsign or " ")
			-- local font = "UVMostWantedLeaderboardFont"
			-- local maxWidth = w * 0.4  -- maximum width of the subtitle block
			-- local bgPadding = 8
			-- local outlineAlpha = 150

			-- surface.SetFont(font)
			-- if text == "" or text == UV_CurrentSubtitle then -- invalid or missing localization; Active for debugging purposes
			-- else
				-- local lines = {}
				-- local currentLine = ""
				-- for word in text:gmatch("%S+") do
					-- local testLine = (currentLine == "" and "" or currentLine .. " ") .. word
					-- local textWidth, _ = surface.GetTextSize(testLine)
					-- if textWidth > maxWidth then
						-- if currentLine ~= "" then
							-- table.insert(lines, currentLine)
						-- end
						-- currentLine = word
					-- else
						-- currentLine = testLine
					-- end
				-- end
				-- if currentLine ~= "" then
					-- table.insert(lines, currentLine)
				-- end

				-- local lineHeight = select(2, surface.GetTextSize("A")) * 1.2
				-- local totalHeight = #lines * lineHeight + (h * 0.02)

				-- local bgX = w * 0.5 - maxWidth * 0.5 - bgPadding
				-- local bgY = h * 0.7275 - bgPadding
				-- local bgW = maxWidth + bgPadding * 2
				-- local bgH = totalHeight + bgPadding * 2

				-- draw.RoundedBox(12, bgX, bgY, bgW, bgH, Color(0, 0, 0, 150))

				-- for i, line in ipairs(lines) do
									
					-- draw.SimpleTextOutlined( textcs, font, w * 0.5, h * 0.725, Color(255, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.25, Color(0, 0, 0, outlineAlpha) )
					-- draw.SimpleTextOutlined( line, font, w * 0.5, h * 0.755 + (i - 1) * lineHeight, pcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.25, Color(0, 0, 0, outlineAlpha) )
				-- end
			-- end
		-- end

		-- if UVHUDCopMode and input.IsKeyDown(var) and not gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
		if input.IsKeyDown(var) and not gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
			local localPlayer = LocalPlayer()

			if localPlayer.uvspawningunit and not localPlayer.uvunitselectdelayed then
				net.Start("UVCancelUnitRespawn")
				net.SendToServer()

				localPlayer.uvunitselectdelayed = true
				timer.Simple(1, function()
					if localPlayer.uvunitselectdelayed then
						localPlayer.uvunitselectdelayed = nil
					end
				end)
			elseif not localPlayer.uvunitselectdelayed then
				LocalPlayer():ConCommand('uvrace_resetposition')
				localPlayer.uvunitselectdelayed = true
				timer.Simple(1, function()
					if localPlayer.uvunitselectdelayed then
						localPlayer.uvunitselectdelayed = nil
					end
				end)
			end
		end

		if UVHUDDisplayPursuit and vehicle ~= NULL then
			if UVOneCommanderActive and hudyes then
				if IsValid(UVHUDCommander) then
					UVRenderCommander(UVHUDCommander)
				end
			end
		end

		local entities = ents.GetAll()
		local box_color = Color(0, 255, 0)

		if not RacerTags:GetBool() or uvclientjammed then
			if GMinimap then
				for _, ent in pairs(UVHUDWantedSuspects) do
					if ent.displayedonhud then
						local curblip = GMinimap:FindBlipByID("UVBlip"..ent:EntIndex())

						if curblip then 
							curblip.alpha = 0
						end
					end
				end
			end
		end

		-- if RacerTags:GetBool() and UVHUDWantedSuspects and UVHUDCopMode and not uvclientjammed then
		if RacerTags:GetBool() and vehicle and UVHUDWantedSuspects and not uvclientjammed and (not UVHUDRace or UVHUDCopMode) then
			if next(UVHUDWantedSuspects) ~= nil then
				local renderQueue = {}

				for _, ent in pairs(UVHUDWantedSuspects) do
					if not IsValid(ent) then continue end
					if UVGetDriver(ent) == LocalPlayer() then continue end
					local dist = LocalPlayer():GetPos():Distance(ent:GetPos())
					table.insert(renderQueue, { vehicle = ent, dist = dist })
				end
				-- Sort so farther ones draw first, closer ones last (on top)
				table.sort(renderQueue, function(a, b)
					return a.dist < b.dist
				end)

				local maxSquares = RacerTagsMaxNr:GetInt() or 3
				local numToRender = math.min(#renderQueue, maxSquares)

				-- Render farthest first so closest overlays on top
				for i = numToRender, 1, -1 do
					local data = renderQueue[i]
					if data and IsValid(data.vehicle) then
						UVRenderEnemySquare(data.vehicle)
					end
				end

				-- Handle minimap blips *after* rendering
				-- if UVHUDCopMode then -- Only as a Cop
					for _, ent in pairs(UVHUDWantedSuspects) do
						if not IsValid(ent) then continue end

						if not GMinimap then continue end
						if not ent.displayedonhud then
							ent.displayedonhud = true
							local blip, id = GMinimap:AddBlip({
								id = "UVBlip" .. ent:EntIndex(),
								parent = ent,
								icon = "unitvehicles/icons/MINIMAP_ICON_CAR.png",
								scale = 1.4,
								color = Color(255, 191, 0),
							})
							if ent:GetClass() == "prop_vehicle_jeep" then
								blip.icon = "unitvehicles/icons/MINIMAP_ICON_CAR_JEEP.png" -- Icon points the other way
							end
						end
						
						if UVHUDCopMode and ent.displayedonhud then-- *This* only for Units
							local curblip = GMinimap:FindBlipByID("UVBlip" .. ent:EntIndex())
							if not curblip then continue end

							if (UVHUDCopMode and UVHUDDisplayCooldown) or not ent.inunitview then
								curblip.alpha = 0
							else
								curblip.alpha = 255
							end
						end
					end
				-- end
			end
		end

		if UVHUDRoadblocks then
			if next(UVHUDRoadblocks) ~= nil then
				for _, roadblock in pairs(UVHUDRoadblocks) do
					if roadblock.location and roadblock.name then
						UVRenderRoadblock(roadblock.location, roadblock.name)
					end
				end
			end
		end

		if UVHUDPursuitBreakers then
			if next(UVHUDPursuitBreakers) ~= nil then
				for _, pos in pairs(UVHUDPursuitBreakers) do
					UVRenderPursuitBreaker(pos)
				end
			end
		end

		if UVHUDMarkedPursuitBreakers then
			if next(UVHUDMarkedPursuitBreakers) ~= nil then
				for _, pb in pairs(UVHUDMarkedPursuitBreakers) do
					if pb.location and pb.name then
						UVRenderMarkedPursuitBreaker(pb.location, pb.name)
					end
				end
			end
		end

		if UVHUDMarkedRepairShops then
			if next(UVHUDMarkedRepairShops) ~= nil then
				for _, rs in pairs(UVHUDMarkedRepairShops) do
					if rs.location and rs.name then
						UVRenderMarkedRepairShop(rs.location, rs.name)
					end
				end
			end
		end

		local areUnitsPresent = (#UnitTable > 0)

		--Police Scanner
		if UVPoliceScanner:GetBool() and (not UVHUDDisplayPursuit or UVHUDDisplayCooldown) and not UVHUDCopMode and not uvclientjammed and localPlayer:InVehicle() and areUnitsPresent then
			local scannerHandler

			-- Main HUD scanner config
			local scannerConfig =
			(UV_UI.pursuit[main] and UV_UI.pursuit[main].scannerConfig)
			or (UV_UI.pursuit[backup] and UV_UI.pursuit[backup].scannerConfig)
			or UV_UI.pursuit.general.scannerConfig
			or {
				radius = 30,
				innerRadius = 14,
				blipRadius = 8,
				maxRange = 5000,
				maxArc = 360,
				posX = w/2,
				posY = h/10,
			}

			-- HUD scanner
			if UV_UI.pursuit[main] and UV_UI.pursuit[main].scanner then scannerHandler = UV_UI.pursuit[main].scanner end
			if not scannerHandler and UV_UI.pursuit[backup] and UV_UI.pursuit[backup].scanner then scannerHandler = UV_UI.pursuit[backup].scanner end
			
			if not scannerHandler then scannerHandler = UV_UI.pursuit.general.scanner end
			
			if scannerHandler then
				scannerHandler({
					radius = scannerConfig.radius,
					innerRadius = scannerConfig.innerRadius,
					blipRadius = scannerConfig.blipRadius,
					maxRange = scannerConfig.maxRange,
					maxArc = scannerConfig.maxArc,
					posX = scannerConfig.posX,
					posY = scannerConfig.posY,

					localPlayer = localPlayer,
					w = w,
					h = h
				})
			end
		end

		if UVEMPLockingTarget then
			local diff = CurTime() - (UVEMPLockingStart or 0)

			local isUnit = table.HasValue( UnitTable, UVEMPLockingTarget )
			local maxDistance = math.pow( ( isUnit and UVUnitPTEMPMaxDistance:GetInt() ) or UVPTEMPMaxDistance:GetInt(), 2 )

			if diff > 5 then 
				UVEMPLockingStart = nil
				UVEMPLockingTarget = nil
				UVEMPLockingSource = nil

				return
			end

			if not vehicle then return end
			if not IsValid(UVEMPLockingTarget) or not IsValid(UVEMPLockingSource) then return end

			local vector = UVEMPLockingTarget:WorldSpaceCenter()
			local screenPos = vector:ToScreen()

			local timeStamps = {
				5 * 0.2, 
				5 * 0.4, 
				5 * 0.6,
				5 * 1.0
			}

			local selectedTimeStamp = nil

			for _, timeStamp in pairs(timeStamps) do
				if diff <= timeStamp then
					selectedTimeStamp = timeStamp
					break
				end
			end

			local blink = math.sin(CurTime() * (selectedTimeStamp + 5)) * 10
			local spaceCount = #timeStamps - selectedTimeStamp
			local spaceString = string.rep(" ", spaceCount)
			local selectedColor = nil

			if UVIsVehicleInCone(UVEMPLockingSource, UVEMPLockingTarget, 90, maxDistance) then
				selectedColor = Color(255, 255 * blink, 255 * blink)
			else
				selectedColor = Color(255, 255, 255, 100)
			end

			draw.DrawText("[" .. spaceString .. " <> " .. spaceString .. "]", "UVFont4", screenPos.x, screenPos.y, selectedColor, TEXT_ALIGN_CENTER)
		end

	end)

	function UVMarkAllLocationsPB(pbs)
		if not UVHUDMarkedPursuitBreakers then
			UVHUDMarkedPursuitBreakers = {}
		else
			if next(UVHUDMarkedPursuitBreakers) ~= nil then
				return
			end
		end

		for k,pb in pairs(pbs) do
			local tabletoinsert = {}
			tabletoinsert.location = pb.location
			tabletoinsert.name = pb.name

			table.insert(UVHUDMarkedPursuitBreakers, tabletoinsert)

			timer.Simple(10, function()
				if not UVHUDMarkedPursuitBreakers then return end
				UVHUDMarkedPursuitBreakers = {}
			end)

		end
	end

	function UVMarkAllLocationsRS(rss)
		if not UVHUDMarkedRepairShops then
			UVHUDMarkedRepairShops = {}
		else
			if next(UVHUDMarkedRepairShops) ~= nil then
				return
			end
		end

		for k,rs in pairs(rss) do
			local tabletoinsert = {}
			tabletoinsert.location = rs.location
			tabletoinsert.name = rs.name

			table.insert(UVHUDMarkedRepairShops, tabletoinsert)

			timer.Simple(10, function()
				if not UVHUDMarkedRepairShops then return end
				UVHUDMarkedRepairShops = {}
			end)

		end
	end

	function UVMarkAllLocations(rbs)
		if not UVHUDRoadblocks then
			UVHUDRoadblocks = {}
		else
			if next(UVHUDRoadblocks) ~= nil then
				return
			end
		end

		for k,rb in pairs(rbs) do
			local tabletoinsert = {}
			tabletoinsert.location = rb.location
			tabletoinsert.name = rb.name

			table.insert(UVHUDRoadblocks, tabletoinsert)

			timer.Simple(10, function()
				if not UVHUDRoadblocks then return end
				UVHUDRoadblocks = {}
			end)

		end
	end

	function UVRenderRoadblock(pos, name)
		local localPlayer = LocalPlayer()
		local box_color = Color(255, 255, 0)

		if IsValid(localPlayer) then
			local pos = pos

			local MaxX, MinX, MaxY, MinY
			local isVisible = false

			local p = pos
			local screenPos = p:ToScreen()
			isVisible = screenPos.visible

			if MaxX ~= nil then
				MaxX, MaxY = math.max(MaxX, screenPos.x), math.max(MaxY, screenPos.y)
				MinX, MinY = math.min(MinX, screenPos.x), math.min(MinY, screenPos.y)
			else
				MaxX, MaxY = screenPos.x, screenPos.y
				MinX, MinY = screenPos.x, screenPos.y
			end

			local textX = (MinX + MaxX) / 2
			local textY = MinY - 20
			cam.Start2D()
			draw.DrawText(name.."\nv", "UVFont4", textX, textY - 30, box_color, TEXT_ALIGN_CENTER)
			cam.End2D()
		end
	end

	function UVRenderPursuitBreaker(pos)
		local localPlayer = LocalPlayer()

		if IsValid(localPlayer) then
			local w = ScrW()
			local h = ScrH()
			local pos = pos

			local screenPos = pos:ToScreen()
			if not screenPos.visible then return end
			
			local textX = screenPos.x
			local textY = screenPos.y -- This is in pixels and stays consistent
        
			-- Distance in meters
			local fadeAlpha = 1
			local fadeDist = 150

			local dist = localPlayer:GetPos():Distance(pos)
			local distMeters = dist * 0.01905

			if distMeters <= fadeDist then
				fadeAlpha = 1 * ((fadeDist - distMeters) / 25)
			elseif distMeters > fadeDist then
				fadeAlpha = 0
			end
			
			-- Edge fade (screen position based)
			local edgeFadeAlpha = 1

			local edgeStartX = w * 0.2
			local edgeEndX = w * 0.8
			local edgeStartY = h * 0.2
			local edgeEndY = h * 0.8

			-- Horizontal fade
			if textX < w * 0.05 or textX > w * 0.95 then
				edgeFadeAlpha = 0
			elseif textX < edgeStartX then
				edgeFadeAlpha = 1 * ((textX - w * 0.05) / (edgeStartX - w * 0.05))
			elseif textX > edgeEndX then
				edgeFadeAlpha = 1 * ((w * 0.95 - textX) / (w * 0.95 - edgeEndX))
			end

			-- Vertical fade
			if textY < h * 0.05 or textY > h * 0.95 then
				edgeFadeAlpha = math.min(edgeFadeAlpha, 0)
			elseif textY < edgeStartY then
				edgeFadeAlpha = math.min(edgeFadeAlpha, 1 * ((textY - h * 0.05) / (edgeStartY - h * 0.05)))
			elseif textY > edgeEndY then
				edgeFadeAlpha = math.min(edgeFadeAlpha, 1 * ((h * 0.95 - textY) / (h * 0.95 - edgeEndY)))
			end

			-- Combine with distance fade
			fadeAlpha = math.min(fadeAlpha, edgeFadeAlpha)
			
			-- Base size at some reference distance
			local baseSize = 50
			local referenceDist = 25

			-- Scale factor decreases with distance
			local minSize, maxSize = 0, 75
			local scale = math.Clamp(baseSize * (referenceDist / math.max(distMeters, 1)), minSize, maxSize)

			cam.Start2D()
			-- draw.DrawText(math.Round(distMeters) .. " m", "UVFont4", textX, textY - 65, Color(255, 0, 0, 255 * fadeAlpha), TEXT_ALIGN_CENTER)

			surface.SetDrawColor( 255, 127, 127, 255 * fadeAlpha)
			surface.SetMaterial(UVMaterials["PBREAKER"])
			surface.DrawTexturedRectRotated( textX, textY - 15, scale, scale, 0)

			cam.End2D()
		end
	end

	function UVRenderMarkedPursuitBreaker(pos, name)
		local localPlayer = LocalPlayer()
		local box_color = Color(255, 0, 0)

		if IsValid(localPlayer) then
			local pos = pos

			local MaxX, MinX, MaxY, MinY
			local isVisible = false

			local p = pos
			local screenPos = p:ToScreen()
			isVisible = screenPos.visible

			if MaxX ~= nil then
				MaxX, MaxY = math.max(MaxX, screenPos.x), math.max(MaxY, screenPos.y)
				MinX, MinY = math.min(MinX, screenPos.x), math.min(MinY, screenPos.y)
			else
				MaxX, MaxY = screenPos.x, screenPos.y
				MinX, MinY = screenPos.x, screenPos.y
			end

			local textX = (MinX + MaxX) / 2
			local textY = MinY - 20
			cam.Start2D()
			draw.DrawText(name.."\nv", "UVFont4", textX, textY - 30, box_color, TEXT_ALIGN_CENTER)
			cam.End2D()
		end
	end

	function UVRenderMarkedRepairShop(pos, name)
		local localPlayer = LocalPlayer()
		local box_color = Color(0, 255, 0)

		if IsValid(localPlayer) then
			local pos = pos

			local MaxX, MinX, MaxY, MinY
			local isVisible = false

			local p = pos
			local screenPos = p:ToScreen()
			isVisible = screenPos.visible

			if MaxX ~= nil then
				MaxX, MaxY = math.max(MaxX, screenPos.x), math.max(MaxY, screenPos.y)
				MinX, MinY = math.min(MinX, screenPos.x), math.min(MinY, screenPos.y)
			else
				MaxX, MaxY = screenPos.x, screenPos.y
				MinX, MinY = screenPos.x, screenPos.y
			end

			local textX = (MinX + MaxX) / 2
			local textY = MinY - 20
			cam.Start2D()
			draw.DrawText(name.."\nv", "UVFont4", textX, textY - 30, box_color, TEXT_ALIGN_CENTER)
			cam.End2D()
		end
	end
	
	net.Receive( "UVHUDRespawnInUVPlyMsg", function()
		local msg = net.ReadString()
		local unit = net.ReadString() or ""
		local cooldown = net.ReadString()
		local msgt = string.format( UVString(msg), UVString(unit), cooldown )
		
		if msg == "uv.chase.select.spawn.cancel" then
			UVHUD_CloseTimedBar("unit_spawn")
		end

		if (RandomPlayerUnits:GetBool() and cooldown) or not cooldown then
			msgt = string.format( UVString(msg), UVString(unit) )
		end

		UVMenu.CloseCurrentMenu()

		UV_UI.general.events.CenterNotification({
			text = msgt
		})
	end)
	
	net.Receive("UVSpawnQueueUpdate", function()
		local vehicle = net.ReadString()
		local cooldown = net.ReadInt(16)
		local msg = net.ReadString()

		if vehicle == "" and msg ~= "uv.chase.select.spawning.cooldown.relocate" then
			LocalPlayer().uvspawningunit = nil
		else
			LocalPlayer().uvspawningunit = {
				vehicle = vehicle,
				cooldown = cooldown,
				startTime = CurTime()
			}
			
			local rm = "uv.chase.select.spawning.cooldown.random"

			if msg == "uv.chase.select.spawning.cooldown.relocate" then
				UVHUD_AddTimedBar(
					"unit_spawn",
					cooldown,
					msg,
					10,
					string.format( UVString("uv.chase.select.spawning.cooldown2"), UVReplaceKeybinds( "[key:unitvehicle_keybind_resetposition]", "Big" ) ),
					nil
				)
				return
			end

			UVHUD_AddTimedBar( "unit_spawn", cooldown, msg, 10, string.format( UVString("uv.chase.select.spawning.cooldown2"), UVReplaceKeybinds( "[key:unitvehicle_keybind_resetposition]", "Big" ) ), msg ~= rm and {vehicle} or nil )
		end
	end)

	net.Receive("UVHUDRespawnInUVSelect", function()
		local isInUnitVehicle = net.ReadBool()
		local UnitsPatrol     = net.ReadString()
		local UnitsSupport    = net.ReadString()
		local UnitsPursuit    = net.ReadString()
		local UnitsInterceptor= net.ReadString()
		local UnitsSpecial    = net.ReadString()
		local UnitsRhino      = net.ReadString()
		local UnitsCommander  = net.ReadString()

		local unittable = {
			UnitsPatrol,
			UnitsSupport,
			UnitsPursuit,
			UnitsInterceptor,
			UnitsSpecial,
			UnitsRhino,
			UnitsCommander
		}

		local unittablename = {
			"uv.unit.patrol",
			"uv.unit.support",
			"uv.unit.pursuit",
			"uv.unit.interceptor",
			"uv.unit.special",
			"uv.unit.rhino",
			"uv.unit.commander"
		}

		local unittablenpc = {
			"npc_uvpatrol",
			"npc_uvsupport",
			"npc_uvpursuit",
			"npc_uvinterceptor",
			"npc_uvspecial",
			"npc_uvspecial",
			"npc_uvcommander"
		}

		UVMenu.OpenMenu(function()
			UVMenu.PlaySFX("menuopen")
			UVMenu.UnitSelect(unittable, unittablename, unittablenpc, isInUnitVehicle)
		end, true)
	end)

	net.Receive( "UV_AddWantedVehicle", function()
		local entIndex = net.ReadInt( 32 )
		local creationId = net.ReadInt( 32 )

		-- EntityQueue[entIndex] = {
		-- 	creationId,
		-- 	'racer'
		-- }
		table.insert( EntityQueue, {
			entIndex = entIndex,
			creationId = creationId,
			entType = "racer"
		} )
	end)

	net.Receive( "UV_RemoveWantedVehicle", function()
		local entIndex = net.ReadInt( 32 )
		local entity = Entity( entIndex )

		if entity then
			table.RemoveByValue( UVHUDWantedSuspects, entity )
			if GMinimap then
				local blip = GMinimap:FindBlipByID("UVBlip" .. entIndex)
				if not blip then return end

				blip.alpha = 0
			end
		end
	end)

	net.Receive( "UVUpdateSuspectVisibility" , function()
		local car = net.ReadEntity()
		local in_view = net.ReadBool()

		car.inunitview = in_view
	end)

	net.Receive( "UVRacerJoin" , function()
		local message = net.ReadString()
		chat.AddText(Color(127, 255, 159), message)
	end)

	net.Receive("UVHUDBustedDebrief", function()
		local debrieftable = net.ReadTable()
		local infractionstable = net.ReadTable()
		local finesdue = net.ReadInt(32)

		if UVHUDCopMode then return end

		local UVDeploys = debrieftable["Deploys"]
		local UVRoadblocksDodged = debrieftable["Roadblocks"]
		local UVSpikestripsDodged = debrieftable["Spikestrips"]

		timer.Simple(5, function()
			UVHUDDisplayBusting = false
			UVHUDDisplayNotification = false
		end)
				
		if UVMenu.CurrentMenu and IsValid(UVMenu.CurrentMenu) then
			UVMenu.CloseCurrentMenu()
			timer.Simple(0.5, function()
				hook.Run( 'UIEventHook', 'pursuit', 'onRacerBustedDebrief', debrieftable, infractionstable, finesdue )
			end)
			return
		end
		hook.Run( 'UIEventHook', 'pursuit', 'onRacerBustedDebrief', debrieftable, infractionstable, finesdue )
	end)

	net.Receive("UVHUDEscapedDebrief", function()
		local debrieftable = net.ReadTable()
		local infractionstable = net.ReadTable()
		local finesdue = net.ReadInt(32)

		if UVHUDCopMode then return end

		local UVDeploys = debrieftable["Deploys"]
		local UVRoadblocksDodged = debrieftable["Roadblocks"]
		local UVSpikestripsDodged = debrieftable["Spikestrips"]

		if UVMenu.CurrentMenu and IsValid(UVMenu.CurrentMenu) then
			UVMenu.CloseCurrentMenu()
			timer.Simple(0.5, function()
				hook.Run( 'UIEventHook', 'pursuit', 'onRacerEscapedDebrief', debrieftable, infractionstable, finesdue )
			end)
			return
		end
		hook.Run( 'UIEventHook', 'pursuit', 'onRacerEscapedDebrief', debrieftable, infractionstable, finesdue )
	end)

	net.Receive("UVHUDCopModeEscapedDebrief", function()
		local debrieftable = net.ReadTable()

		local UVDeploys = debrieftable["Deploys"]
		local UVRoadblocksDodged = debrieftable["Roadblocks"]
		local UVSpikestripsDodged = debrieftable["Spikestrips"]

		print("You lost ".. UVHUDWantedSuspectsNumber .." suspect(s)!\n" .. 
			"Total Bounty - " .. string.Comma(UVBounty).."\n" .. 
			"Pursuit Duration - " .. UVTimer .. "\n" ..
			"Police Vehicles Involved - " .. UVDeploys .. "\n" ..
			"Damaged Police Vehicles - " .. UVTags .. "\n" ..
			"Immobilized Police Vehicles - " .. UVWrecks .. "\n" ..
			"Roadblocks Dodged - " .. UVRoadblocksDodged .. "\n" ..
			"Spike Strips Dodged - " .. UVSpikestripsDodged
		)
		
		if UVMenu.CurrentMenu and IsValid(UVMenu.CurrentMenu) then
			UVMenu.CloseCurrentMenu()
			timer.Simple(0.5, function()
				hook.Run( 'UIEventHook', 'pursuit', 'onCopEscapedDebrief', debrieftable )
			end)
			return
		end

		UVSoundEscaped(UVHeatLevel)
		hook.Run( 'UIEventHook', 'pursuit', 'onCopEscapedDebrief', debrieftable )
	end)

	net.Receive("UVHUDCopModeBustedDebrief", function()
		local debrieftable = net.ReadTable()

		local UVDeploys = debrieftable["Deploys"]
		local UVRoadblocksDodged = debrieftable["Roadblocks"]
		local UVSpikestripsDodged = debrieftable["Spikestrips"]

		print("You caught all the suspect(s)!\n" .. 
			"Total Bounty - " .. string.Comma(UVBounty).."\n" .. 
			"Pursuit Duration - " .. UVTimer .. "\n" ..
			"Police Vehicles Involved - " .. UVDeploys .. "\n" ..
			"Damaged Police Vehicles - " .. UVTags .. "\n" ..
			"Immobilized Police Vehicles - " .. UVWrecks .. "\n" ..
			"Roadblocks Dodged - " .. UVRoadblocksDodged .. "\n" ..
			"Spike Strips Dodged - " .. UVSpikestripsDodged
		)
		
		if UVMenu.CurrentMenu and IsValid(UVMenu.CurrentMenu) then
			UVMenu.CloseCurrentMenu()
			timer.Simple(0.5, function()
				hook.Run( 'UIEventHook', 'pursuit', 'onCopBustedDebrief', debrieftable )
			end)
			return
		end
		hook.Run( 'UIEventHook', 'pursuit', 'onCopBustedDebrief', debrieftable )
	end)

	net.Receive( "UVUpdateRacerName" , function()
		local racer_vehicle = net.ReadEntity()
		local racer_name = net.ReadString()

		racer_vehicle.racer = racer_name
	end)

	net.Receive('UV_Sound', function()
		local array = net.ReadTable()
		if not PursuitSFX:GetBool() then return end

		local audio_file = "sound/"..array.FileName
		local parameters = array.Parameter
		local can_skip = array.CanSkip

		if can_skip and IsValid(uvsoundplaying) and parameters ~= 2 then
			uvsoundplaying:Stop()
		end

		sound.PlayFile(audio_file, "", function(source, err, errname)
			if IsValid(source) then
				if not can_skip then
					uvsoundplaying = source
				end
				source:Play()
			end
		end)
	end)
	
	net.Receive('UV_Chatter', function()
		local init_time = net.ReadFloat()
		local audio_file = "sound/"..net.ReadString()
		local can_skip = net.ReadBool()
		local hasCallsign = net.ReadBool()
		local callsign = nil 
		if hasCallsign then
			callsign = net.ReadString()
		end

		-- build subtitle key
		local rel = string.gsub(audio_file, "^sound/chatter2/", "")
		rel = string.gsub(rel, "%.mp3$", "")
		rel = string.gsub(rel, "/", ".")
		local key = "uvsub."..string.lower(rel)

		if lastCanSkip == false and IsValid(uvchatterplaying) then
			local state = uvchatterplaying:GetState()
			if state ~= GMOD_CHANNEL_STOPPED and init_time ~= lastInitTime then return end
		end

		local shouldStop = lastInitTime ~= init_time

		lastCanSkip = can_skip
		lastInitTime = init_time

		sound.PlayFile(audio_file, "", function(source, err, errname)
			if IsValid(source) then
				if IsValid(uvchatterplaying) and shouldStop then
					uvchatterplaying:Stop()
				end
				uvchatterplaying = source
				source:Play()
				source:SetVolume(ChatterVolume:GetFloat())
				
				local excludeSubstrings = {
					".misc.radioon",
					".misc.radiooff",
					".misc.emergency",
					".dispatch.idletalk",
					".bullhorn.",
				}

				-- local shouldUpdate = true
				-- for _, substr in ipairs(excludeSubstrings) do
					-- if string.find(key, substr, 1, true) then
						-- shouldUpdate = false
						-- break
					-- end
				-- end

				-- if shouldUpdate then
					-- UV_CurrentSubtitle = key
					-- UV_SubtitleEnd = CurTime() + source:GetLength()
					-- UV_CurrentSubtitleCallsign = callsign
				-- end
			end
		end)
	end)

	net.Receive('UVBusted', function()
		local array = net.ReadTable()

		local racer = array['Racer']
		local cop = array['Cop']
		local lp = false

		if racer == LocalPlayer():GetName() then lp = true end

		UVHUD_CloseTimedBar("reset_penalty")
		hook.Run( 'UIEventHook', 'pursuit', 'onRacerBusted', racer, cop, lp )
	end)

	net.Receive("UVHUDWreckedDebrief", function()
		UVMenu.OpenMenu(UVMenu.WreckedDebrief, true)
	end)

	net.Receive('UVInfractions', function()
		local text = net.ReadString()
		local number = net.ReadInt(5)
		
		-- text = UVString("uv.results.infractions") .. " " .. number .. ": " .. UVString("uv.infraction." .. text)

		-- UV_UI.general.events.CenterNotification({
            -- text = text,
		-- })
		
		text = UVString("uv.infraction." .. text)
		hook.Run( 'UIEventHook', 'pursuit', 'onInfraction', text, number )
	end)

	hook.Add("PopulateToolMenu", "UVMenu", function()
		spawnmenu.AddToolMenuOption("Options", "uv.unitvehicles", "UVClientOptions", UVString("uv.ui.menu"), "", "", function(panel)
			local option
			
			panel:Clear()

			panel:Help(UVString("uv.tweakinmenu"))
			local OpenMenu = vgui.Create("DButton")
			OpenMenu:SetText(UVString("uv.tweakinmenu.open"))
			OpenMenu:SetSize(280, 20)
			OpenMenu.DoClick = function()
				UVMenu.OpenMenu(UVMenu.Main)
				UVMenu.PlaySFX("menuopen")
			end
			panel:AddItem(OpenMenu)

		end)
	end)

	local theme = PursuitTheme:GetString()
	if theme then
		PopulatePursuitFilePaths(theme)
	end

end