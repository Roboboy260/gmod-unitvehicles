resource.AddSingleFile("resource/fonts/VCR_OSD_MONO_1.001.ttf")

--convars
local HeatLevels = GetConVar("unitvehicle_heatlevels")
local DetectionRange = GetConVar("unitvehicle_detectionrange")
local PlayMusic = GetConVar("unitvehicle_playmusic")
local NeverEvade = GetConVar("unitvehicle_neverevade")
local BustedTimer = GetConVar("unitvehicle_bustedtimer")
local CanWreck = GetConVar("unitvehicle_canwreck")
local Chatter = GetConVar("unitvehicle_chatter")
local SpeedLimit = GetConVar("unitvehicle_speedlimit")
local AutoHealth = GetConVar("unitvehicle_autohealth")
local MinHeatLevel = GetConVar("unitvehicle_unit_minheat")
local MaxHeatLevel = GetConVar("unitvehicle_unit_maxheat")
local SpikeStripDuration = GetConVar("unitvehicle_spikestripduration")
local Pathfinding = GetConVar("unitvehicle_pathfinding")
local VCModELSPriority = GetConVar("unitvehicle_vcmodelspriority")
local CallResponse = GetConVar("unitvehicle_callresponse")
local Headlights = GetConVar("unitvehicle_enableheadlights")
local SpawnMainUnits = GetConVar("unitvehicle_spawnmainunits")
local RepairCooldown = GetConVar("unitvehicle_repaircooldown")
local RepairRange = GetConVar("unitvehicle_repairrange")
local RacerTags = GetConVar("unitvehicle_racertags")
local RacerPursuitTech = GetConVar("unitvehicle_racerpursuittech")
local DisengageOnHeatChange = GetConVar("unitvehicle_disengageonheatchange")

--unit convars
local UVUHelicopterBusting = GetConVar("unitvehicle_unit_helicopterbusting")

local dvd = DecentVehicleDestination

NETWORK_STRINGS = {
	-- Pursuit Tech
	"UV_SendPursuitTech",
	"UVPTUse",
	"UVPTEvent",
	
	"UVWeaponESFEnable",
	"UVWeaponESFDisable",

	"UVWeaponJuggernautEnable",
	"UVWeaponJuggernautDisable",

	"UVWeaponGrapplerEnable",
	"UVWeaponGrapplerDisable",
	
	"UVWeaponJammerEnable",
	"UVWeaponJammerDisable",

	"UVWeaponSkyhammerEnable",
	"UVWeaponSkyhammerDisable",
	
	-- Repair Shop
	"UVHUDRepairCooldown",
	"UVHUDRepair",
	"UVHUDRepairAvailable",
	"UVHUDRefilledPT",
	"UVHUDRepairCommander",
	"uvrepairsimfphys",
	"UVRepairShopAdjust",
	"UVRepairShopRetrieve",
	"UVRepairShopCreate",
	"UVRepairShopDeleteFile",
	"UVRepairShopRefresh",
	"UVRepairShopLoad",
	"UVRepairShopLoadAll",
	"UVRepairShopMarkAll",
	"UVRepairShopMarkAllResponse",

	-- Driver Model
	"UVDriverModelManagerAdjust",
	"UVDriverModelManagerRetrieve",
	"UVDriverModelManagerRetrieveColor",
	"UVDriverModelManagerCreate",
	"UVDriverModelManagerDeleteFile",
	"UVDriverModelManagerRefresh",
	"UVDriverModelManagerLoad",
	"UVDriverModelManagerOpenModelMenu",
	
	-- Pursuit Table
	"UVGet_PursuitTable",
	"UVSet_PursuitTable",

	-- Pursuit Scopes
	"UV_SetScope",
	"UV_RemoveScope",
	"UV_GetAllScopes",
	"UV_SetGlobal",

	-- Chatter / Sounds
	"UV_Chatter",
	"UV_Sound",
	
	-- Settings
	"UVGetSettings_Local",
	"UVUpdateSettings",
	
	-- Keybinds
	'UVGetNewKeybind',
	'UVPTKeybindRequest',

	-- Pursuit
	"UVHUDBackuptimer",
	"UVHUDStopBackupTimer",
	"UVHUDStopPursuit",
	"UVHUDStartPursuitCountdown",
	"UVHUDStartPursuitNotification",
	
	-- Busted / Busting
	"UVBusted",
	"UVHUDUpdateBusting",
	"UVHUDBusting",
	"UVHUDStopBusting",
	"UVHUDStopBustingTimeLeft",
	"UVHUDEnemyBusted",
	
	-- Wanted
	"UVHUDWanted",
	
	-- Evading
	"UVHUDEvading",
	
	-- Cooldown
	"UVHUDCooldown",
	"UVHUDStopCooldown",
	"UVHUDHiding",
	"UVHUDStopHiding",

	-- Fined
	"UVPullOver",
	"UVFined",
	"UVFineArrest",
	
	-- Wanted Suspects
	"UVHUDWantedSuspects",
	
	-- Wanted Vehicles
	"UV_AddWantedVehicle",
	"UV_RemoveWantedVehicle",
		
	-- Cop Mode Busting
	"UVHUDCopModeBusting",
	"UVHUDStopCopModeBusting",
	
	-- Debrief
	"UVHUDBustedDebrief",
	"UVHUDEscapedDebrief",
	"UVHUDCopModeEscapedDebrief",
	"UVHUDCopModeBustedDebrief",
	"UVHUDWreckedDebrief",
	
	-- Player unit respawn
	"UVHUDRespawnInUV",
	"UVCancelUnitRespawn",
	"UVSpawnQueueUpdate",

	-- Player unit select
	"UVHUDRespawnInUVGetInfo",
	"UVHUDRespawnInUVSelect",
	"UVHUDRespawnInUVPlyMsg",
	
	-- Commander
	"UVHUDOneCommander",
	"UVHUDStopOneCommander",
	
	-- Unit Takedown
	"UVUnitTakedown",
	
	-- Heat level
	"UVHUDHeatLevelIncrease",
	"UVHUDTimeTillNextHeat",

	-- Infractions
	"UVInfractions",
	
	-- Pursuit breakers
	"UVHUDPursuitBreakers",
	"UVAddPursuitBreaker",
	"UVTriggerPursuitBreaker",
	"UVPursuitBreakerAdjust",
	"UVPursuitBreakerRetrieve",
	"UVPursuitBreakerCreate",
	"UVPursuitBreakerDeleteFile",
	"UVPursuitBreakerRefresh",
	"UVPursuitBreakerLoad",
	"UVPursuitBreakerLoadAll",
	"UVPursuitBreakerMarkAll",
	"UVPursuitBreakerMarkAllResponse",
	
	-- Roadblocks
	"UVAddRoadblock",
	"UVTriggerRoadblock",
	"UVRoadblocksAdjust",
	"UVRoadblocksRetrieve",
	"UVRoadblocksCreate",
	"UVRoadblocksDeleteFile",
	"UVRoadblocksRefresh",
	"UVRoadblocksLoad",
	"UVRoadblocksLoadAll",
	"UVRoadblocksMarkAll",
	"UVRoadblocksMarkAllResponse",
	
	-- Unit Vehicle Add/Remove
	"UVHUDAddUV",
	"UVHUDReAddUV",
	"UVHUDRemoveUV",
	
	-- Unit Manager
	"UVUnitManagerAdjustUnit",
	"UVUnitManagerGetUnitInfo",
	"UVUnitManagerGetUnitAssignment",
	"UVUnitManagerSaveUnit",
	"UVUnitManagerDeleteFile",
	"UVUnitManagerAddAirModel",

	-- Traffic Manager
	"UVTrafficManagerAdjustTraffic",
	"UVTrafficManagerGetTrafficInfo",
	"UVTrafficManagerSaveTraffic",
	"UVTrafficManagerDeleteFile",

	-- Racer Manager
	"UVRacerManagerAdjustRacer",
	"UVRacerManagerGetRacerInfo",
	"UVRacerManagerSaveRacer",
	"UVRacerManagerDeleteFile",

	-- Racers
	"UVUpdateRacerName",
	"UVUpdateSuspectVisibility",
	"UVRacerJoin",
	
	-- Race creation
	"UVRace_UpdatePos",
	"UVRace_SelectID",
	"UVRace_SetID",
	"UVRace_SetSpeedLimit",
	"UVStartRace",
	"UVRace_TrackReady",
	"UVRace_RacersList",
	"UVRace_HideRacersList",
	"UVRace_ToolMode",
	
	"UVRace_NodeAdd",
	"UVRace_NodeRemove",
	"UVRace_NodeLinks",
	"UVRace_NodeSelect",
	"UVRace_NodeSettings",
	"UVRace_UpdateNodeSettings",
	"UVRace_ClearAllNodes",

	-- Race
	"uvrace_begin",
	"uvrace_start",
	"uvrace_end",
	"uvrace_participants",
	"uvrace_notification",
	"uvrace_decline",
	"uvrace_sendmessage",
	"uvrace_replace",
	"uvrace_disqualify",
	"uvrace_checkpointcomplete",
	"uvrace_checkpointsplit",
	"uvrace_lapcomplete",
	"uvrace_racecomplete",
	"uvrace_info",
	"uvrace_invite",
	"uvrace_racerinvited",
	"uvrace_announcebestlaptime",
	'UVResetPosition',
	"UVRace_BeginEndCountdown",
	"UVRace_StopEndCountdown",
	"UVActionCamStart",
	"UVActionCamStop",

	-- Race List
	"UVRace_RaceList_Set",
	"UVRace_RaceList_Add",
	"UVRace_RaceList_Remove",

	-- Resetting
	"uvresetcountdown",
	"uvresetfailed",
	"uvresetpenalty",

	-- Headlights
	"UVToggleHeadlights",
	
	-- Glide Nodes
	"RequestGlideVehicles",
	"GlideVehiclesTable",
	
	-- LVS Nodes
	"RequestLVSVehicles",
	"LVSVehiclesTable",
	
	-- DV Warning
	"UV_OpenDVWarning",
	
	-- Data Replacement for SERVER
	"UV_HasPendingReplace",
	"UV_RequestServerReplace",
	"UV_ConfirmServerReplace",
	"UV_OpenReplaceMenu",

	-- Content reader
	"UVContent_Add",
	"UVContent_Remove",

	-- Presets
	"UVPresets_Add",
	"UVPresets_Remove",
	"UVPresets_Set",
	"UVPresets_Save",
	"UVPresets_Load",
}

for _, v in pairs( NETWORK_STRINGS ) do
	util.AddNetworkString( v )
end

-- Allow content reader to load up the names first
hook.Add( "UVContentEvent", "UV_LoadNames", function( operation, path, fileName )
	if operation ~= "Initialize" then return end

	local files = UV_GetFiles( "names" )
	local names = {
		Racers = {},
		Units = {},
	}

	for _, file in pairs(files) do
		local collection = util.JSONToTable( UV_LoadFile( "names", file ) )

		if collection then
			if collection.Racers then
				table.Add( names.Racers, collection.Racers )
			end
			if collection.Units then
				table.Add( names.Units, collection.Units )
			end
		end
	end

	UVNames = names
	hook.Remove( "UVContentEvent", "UV_LoadNames" )
end)

timer.Simple(5, function()
	if not DecentVehicleDestination then
		PrintMessage( HUD_PRINTTALK, "/// Unit Vehicles requires Decent Vehicles to be installed! /// https://steamcommunity.com/sharedfiles/filedetails/?id=1587455087")
	end
	if not Glide then
		PrintMessage( HUD_PRINTTALK, "/// Unit Vehicles recommends Glide! Attempting to spawn default vehicles from the Unit Manager may cause errors! /// https://steamcommunity.com/sharedfiles/filedetails/?id=3389728250")
	end
end)

-- --DEFAULT PRESETS
-- local datafiles, datafolders = file.Find("data_static/uvdefaultdata/*", "GAME")

-- for _, folder in ipairs(datafolders) do
--     local path = "unitvehicles/" .. folder
--     if not file.IsDir(path, "DATA") then
--         file.CreateDir(path)
--     end

--     local datafiles2, datafolders2 = file.Find("data_static/uvdefaultdata/"..folder.."/*", "GAME")
--     if datafiles2 then
--         for _, filename in ipairs(datafiles2) do
--             local source = "data_static/uvdefaultdata/" .. folder .. "/" .. filename
--             local destination = "unitvehicles/" .. folder .. "/" .. filename
--             if file.Exists(source, "GAME") then
--                 file.Write(destination, file.Read(source, "GAME"))
--             end
--         end
--     end

--     for _, folder2 in ipairs(datafolders2) do
--         local subpath = path .. "/" .. folder2
--         if not file.IsDir(subpath, "DATA") then
--             file.CreateDir(subpath)
--         end
--         local datafiles3, datafolders3 = file.Find("data_static/uvdefaultdata/"..folder.."/"..folder2.."/*", "GAME")
--         if datafiles3 then
--             for _, filename in ipairs(datafiles3) do
--                 local source = "data_static/uvdefaultdata/" .. folder .. "/" .. folder2 .. "/" .. filename
--                 local destination = "unitvehicles/" .. folder .. "/" .. folder2 .. "/" .. filename
--                 if file.Exists(source, "GAME") then
--                     file.Write(destination, file.Read(source, "GAME"))
--                 end
--             end
--         end
--     end

-- end

concommand.Add("uv_spawnvehicles", function(ply)
	if ply and not ply:IsSuperAdmin() then return end
	
	PrintMessage( HUD_PRINTTALK, "Spawning Unit Vehicle(s)...")
	
	UVApplyHeatLevel()
	UVAutoSpawn(ply)
	
	uvIdleSpawning = CurTime()
	UVPresenceMode = true
	
	UVRestoreResourcePoints()
end)

concommand.Add( "uv_setheat", function( ply, cmd, args )
	if ply and not ply:IsSuperAdmin() then return end
	for _, v in pairs( UVPursuitScopes ) do
		v.Heat = math.Clamp( (tonumber(args[1]) or 1), 1, MAX_HEAT_LEVEL )
		_highestHeatLevel = v.Heat
	end

	if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() and UVTargeting then
		local units = ents.FindByClass("npc_uv*")
		local random_entry = math.random(#units)
		local unit = units[random_entry]
		UVChatterReportHeat(unit, _highestHeatLevel)
	end

	timer.Simple(0.5, function()
		UVRestoreResourcePoints()
	end)
end)

function UV_DespawnVehicles(ply)
	UVPresenceMode = false
	
	-- PrintMessage( HUD_PRINTTALK, "Despawning Unit Vehicle(s)!")
	
	for k, v in pairs(ents.FindByClass("npc_uv*")) do
		v:Remove()
	end
	for k, v in pairs(ents.FindByClass("uvair")) do
		v:Remove()
	end
	
	UVRestoreResourcePoints()
end

concommand.Add("uv_despawnvehicles", function(ply)
	if ply and not ply:IsSuperAdmin() then return end
	UV_DespawnVehicles(ply)
end)

concommand.Add("uv_resetallsettings", function(ply)
	if ply and not ply:IsSuperAdmin() then return end
	
	ply:EmitSound("buttons/button15.wav", 0, 100, 0.5, CHAN_STATIC)
	
	HeatLevels:Revert()
	DetectionRange:Revert()
	PlayMusic:Revert()
	RacingMusic:Revert()
	NeverEvade:Revert()
	BustedTimer:Revert()
	CanWreck:Revert()
	Chatter:Revert()
	SpeedLimit:Revert()
	AutoHealth:Revert()
	MinHeatLevel:Revert()
	MaxHeatLevel:Revert()
	SpikeStripDuration:Revert()
	Pathfinding:Revert()
	VCModELSPriority:Revert()
	CallResponse:Revert()
	Headlights:Revert()
	SpawnMainUnits:Revert()
	RepairCooldown:Revert()
	RepairRange:Revert()
	RacerTags:Revert()
end)

function UV_StartPursuit(ply, skipCountdown)
	if UVTargeting or UVCounterActive then return end

	skipCountdown = skipCountdown or false

	if SpawnMainUnits:GetBool() then
		UVAutoSpawn(nil)
		
		uvIdleSpawning = CurTime()
		UVPresenceMode = true
	end
	
	-- immediate pursuit
	if skipCountdown then
		RunConsoleCommand("ai_ignoreplayers", "0")
		UVCounterActive = false

		for _, v in pairs(UVPotentialSuspects) do
			UVAddToWantedListVehicle(v)
		end

		for _, veh in pairs(UVWantedTableVehicle) do
			UV_InitiatePursuit(veh)
		end

		UVTargeting = true

		-- Random police unit announcement
		UVChatterPursuitStartAcknowledge(Entity(1))

		timer.Simple(5, function()
			if not UVTargeting then return end
			local _, v = next( UVWantedTableVehicle )
			if v then
				UVChatterDispatchCallVehicleDescription( Entity(1), v )
				UVSoundChatter(Entity(1), nil, "heat" .. UVHeatLevel, nil, "DISPATCH")
			end
		end)	
		return
	end

	-- Normal start
	net.Start("UVHUDStartPursuitNotification")
	net.WriteString("uv.hud.chase.starting")
	net.Broadcast()

	UVApplyHeatLevel()
	UVRestoreResourcePoints()
	UVCounterActive = true

	if IsValid(ply) then
		ply:EmitSound("ui/pursuit/startingpursuit/chaseresuming_start.wav", 0, 100, 0.5, CHAN_STATIC)
	end

	timer.Create("uv_pursuit_start", 1, 6, function()
		local time = timer.RepsLeft("uv_pursuit_start")

		for _, plyTarget in ipairs(player.GetAll()) do
			net.Start("UVHUDStartPursuitCountdown")
			net.WriteInt(time, 11)
			net.Send(plyTarget)
		end

		if time > 1 then
			if time <= 4 and IsValid(ply) then
				ply:EmitSound("ui/pursuit/startingpursuit/chaseresuming_" .. (time - 1) .. ".wav")
			end
		else
			if UVTargeting then return end
			if IsValid(ply) then
				ply:EmitSound("ui/pursuit/startingpursuit/chaseresuming_go.wav", 0, 100, 0.5, CHAN_STATIC)
			end

			RunConsoleCommand("ai_ignoreplayers", "0")
			UVCounterActive = false

			for _, v in pairs(UVPotentialSuspects) do
				UVAddToWantedListVehicle(v)
			end

			for _, veh in pairs(UVWantedTableVehicle) do
				UV_InitiatePursuit(veh)
			end

			UVTargeting = true

			-- Random police unit announcement
			UVChatterPursuitStartAcknowledge(Entity(1))

			timer.Simple(5, function()
				if not UVTargeting then return end
				local _, v = next( UVWantedTableVehicle )
				if v then
					UVChatterDispatchCallVehicleDescription( Entity(1), v )
					UVSoundChatter(Entity(1), nil, "heat" .. UVHeatLevel, nil, "DISPATCH")
				end
			end)	
		end
	end)
end

concommand.Add("uv_startpursuit", function(ply, cmd, args)
	if ply and not ply:IsSuperAdmin() then return end
	local skipCountdown = tonumber(args[1]) == 1

	UV_StartPursuit(ply, skipCountdown)
end)

function UV_StopPursuit(ply)
	UV_DespawnVehicles()
	
	timer.Simple(0, function()
		for _, v in pairs(UVPursuitScopes) do
			v.InPursuit = false

			local ent = Entity(v.EntIndex)
			if IsValid(ent) then ent.inunitview = false end
		end	
	end)
end

concommand.Add("uv_stoppursuit", function(ply)
	if ply and not ply:IsSuperAdmin() then return end
	UV_StopPursuit(ply)
end)

concommand.Add("uv_wantedtable", function(ply)
	print("Bounty: "..string.Comma(UVBounty))
	print("/// Wanted Vehicles ///")
	PrintTable(UVWantedTableVehicle)
	print("/// Wanted Drivers ///")
	PrintTable(UVWantedTableDriver)
	print("/// Potential Suspects ///")
	PrintTable(UVPotentialSuspects)
end)

concommand.Add("uv_clearbounty", function(ply)
	if ply and not ply:IsSuperAdmin() then return end
	PrintMessage( HUD_PRINTTALK, "Bounty cleared" )
	
	for _, v in pairs(UVPursuitScopes) do
		v.Bounty = 0
		v.Heat = 1
	end
end)

function UVApplyHeatLevel()
	local minHeat = MinHeatLevel:GetInt()
	local maxHeat = MaxHeatLevel:GetInt()
	
	if minHeat > maxHeat then
		UVHeatLevel = MaxHeatLevel:GetInt()
	end
end

function UVUpdateHeatLevel()
	-- local ply = Entity(1)
	-- if not ply then return end
	
	-- UVHeatLevel = CalculateHeatLevel(UVBounty, UVHeatLevel)
	-- ApplyHeatSettings(UVHeatLevel)
	HandleVehicleSpawning()
end

function CalculateHeatLevel(bounty, currentHeat)
	local maxHeat = MaxHeatLevel:GetInt()
	local minHeat = MinHeatLevel:GetInt()
	local newHeat = currentHeat or 1
	
	for level = (currentHeat or 0) + 1, maxHeat do
		local condition = level > minHeat
		local convar = GetConVar("unitvehicle_unit_heatminimumbounty" .. level)
		
		if condition and convar then
			local minBounty = convar:GetInt()
			
			if bounty >= minBounty then
				newHeat = level
			else 
				break 
			end
		end
	end
	
	if newHeat < minHeat then newHeat = minHeat end
	return newHeat
end

function UV_ClearRacer(ply)
	for _, v in pairs(ents.FindByClass("npc_racervehicle")) do
		if not v.temporary then
			if IsValid(v.v) then
				v.v:Remove()
			end
			v:Remove()
		end
	end
end

concommand.Add("uv_clearracers", function(ply)
	if ply and not ply:IsSuperAdmin() then return end
	UV_ClearRacer(ply)
end)

function TriggerHeatLevelEffects(level, veh)
	if level < 2 then return end
	
	if level == MaxHeatLevel then
	    PrintMessage(HUD_PRINTCENTER, "HEAT LEVEL " .. level .. "!")
	end
	
	-- if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() and UVTargeting then
	-- 	local units = ents.FindByClass("npc_uv*")
	-- 	local random_entry = math.random(#units)
	-- 	local unit = units[random_entry]
	-- 	UVChatterReportHeat(unit, level)
	-- end
	local occupants = UVGetVehicleOccupants(veh)
	
	if UVTargeting then
		UVRelaySoundToClients("ui/pursuit/heatlevelrise.wav", false, occupants)
	end
	
	net.Start("UVHUDHeatLevelIncrease")
	net.Send(occupants)
end

function NumberToWords(num)
	local words = {"One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"}
	return words[num] or tostring(num)
end

function UVDisengageUnits()
	for unit, _ in pairs( UVUnitVehicles ) do
		if not IsValid(unit) or not unit.UnitVehicle or unit.UnitVehicle:IsPlayer() or not unit.unitscript then continue end

		local unitType = string.sub( unit.UnitVehicle:GetClass(), 7 )
		local assignedUnits = string.Trim( GetConVar( 'unitvehicle_unit_units' .. unitType .. UVHeatLevel ):GetString() )

		if not assignedUnits then continue end

		unit.disengaging = string.find( assignedUnits, unit.unitscript ) == nil
	end
	-- for k, NPC in pairs(ents.FindByClass("npc_uv*")) do
	-- 	if not NPC.v then continue end
	-- 	if not NPC.v.unitscript or NPC.v.rhino then continue end
	-- 	if NPC:GetClass() == "npc_uvcommander" then continue end

	-- 	local UnitsPatrol = string.Trim( GetConVar( 'unitvehicle_unit_unitspatrol' .. UVHeatLevel ):GetString() )
	-- 	local UnitsSupport = string.Trim( GetConVar( 'unitvehicle_unit_unitssupport' .. UVHeatLevel ):GetString() )
	-- 	local UnitsPursuit = string.Trim( GetConVar( 'unitvehicle_unit_unitspursuit' .. UVHeatLevel ):GetString() )
	-- 	local UnitsInterceptor = string.Trim( GetConVar( 'unitvehicle_unit_unitsinterceptor' .. UVHeatLevel ):GetString() )
	-- 	local UnitsSpecial = string.Trim( GetConVar( 'unitvehicle_unit_unitsspecial' .. UVHeatLevel ):GetString() )
	-- 	local UnitsRhino = string.Trim( GetConVar( 'unitvehicle_unit_unitsrhino' .. UVHeatLevel ):GetString() )
	-- 	local UnitsCommander = string.Trim( GetConVar( 'unitvehicle_unit_unitscommander' .. UVHeatLevel ):GetString() )

	-- 	local AssignedUnits = UnitsPatrol .. " " .. UnitsSupport .. " " .. UnitsPursuit .. " " .. UnitsInterceptor .. " " .. UnitsSpecial .. " " .. UnitsRhino .. " " .. UnitsCommander
	-- 	if not AssignedUnits then return end

	-- 	if string.find(AssignedUnits, NPC.v.unitscript) then
	-- 		if NPC.v.disengaging then
	-- 			NPC.v.disengaging = nil
	-- 		end
	-- 	else
	-- 		if not NPC.v.disengaging then
	-- 			NPC.v.disengaging = true
	-- 		end
	-- 	end
	-- end
end

function ApplyHeatSettings(heatLevel)
	heatLevel = math.Clamp(heatLevel or 1, 1, MaxHeatLevel:GetInt())
	
	UVMaxUnits = GetConVar("unitvehicle_unit_maxunits"..heatLevel):GetInt()
	-- Commented lines are now per scope (or in the case of UVBountyMultiplier, it was never even utilized lmao.)
	--UVBountyMultiplier = heatLevel
	--UVBountyTime = GetConVar("unitvehicle_unit_bountytime"..heatLevel):GetInt()
	--UVCooldownTimer = GetConVar("unitvehicle_unit_cooldowntimer"..heatLevel):GetInt()
	UVBackupTimerMax = GetConVar("unitvehicle_unit_backuptimer"..heatLevel):GetInt()
	
	UVBustSpeed = (GetConVar("unitvehicle_unit_bustspeed"..heatLevel):GetInt()*17.6)^2 --MPH to in/s^2
	
	uvRoadblockDeployable = GetConVar("unitvehicle_unit_roadblocks"..heatLevel):GetInt() == 1
	uvHelicopterDeployable = GetConVar("unitvehicle_unit_helicopters"..heatLevel):GetInt() == 1

	if DisengageOnHeatChange:GetBool() then
		UVDisengageUnits()
	end
end

local function CheckVehicleLimit()
	local activeUnits = ents.FindByClass("npc_uv*")
	local activeUnitsCount = 0
	local wreckedUnitsCount = #UVWreckedVehicles

	for _, unit in pairs(activeUnits) do
		if unit.v.roadblocking then continue end
		activeUnitsCount = activeUnitsCount + 1
	end

	if #UVWreckedVehicles > 0 then
		for k, car in pairs(UVWreckedVehicles) do
			if #UVPotentialSuspects > 0 then
				local closestsuspect
				local closestdistancetosuspect
				local suspects = UVPotentialSuspects
				local r = math.huge
				local closestdistancetosuspect, closestsuspect = r^2
				for i, w in pairs(suspects) do
					local carpos = car:WorldSpaceCenter()
					local distance = carpos:DistToSqr(w:WorldSpaceCenter())
					if distance < closestdistancetosuspect then
						closestdistancetosuspect, closestsuspect = distance, w
					end
				end
				if (car.markedfordeletion and closestdistancetosuspect > 25000000) or (not car.uvbusted and closestdistancetosuspect > 100000000) then
					car:Remove()
					wreckedUnitsCount = wreckedUnitsCount - 1
				end
			end
		end
	end

	local totalUnits = activeUnitsCount + wreckedUnitsCount
	return totalUnits < UVMaxUnits and totalUnits < UVGlobalPursuit.ResourcePoints or activeUnitsCount < 1
end

local function CheckSpawnChance(chance)
    if chance <= 0 then return false end
    if chance >= 100 then return true end

    local roll = math.random(1, 100)

    if roll <= chance then
        return true
    else
        return false
    end
end

-- Helper function for vehicle spawning logic
function HandleVehicleSpawning(Patrolling)
	
	if UVJammerDeployed then return end
	if not CheckVehicleLimit() then return end

	-- Handle other special spawns

	if not SpawnMainUnits:GetBool() then return end

	local rbchance = GetConVar( "unitvehicle_unit_roadblocks_chance" .. UVHeatLevel ):GetInt()
	local helichance = GetConVar( "unitvehicle_unit_helicopters_chance" .. UVHeatLevel ):GetInt()
	local helilimit = GetConVar( "unitvehicle_unit_helicopters_limit" .. UVHeatLevel ):GetInt()

	local canSpawnRoadblock = uvRoadblockDeployable and next(ents.FindByClass("npc_uv*")) ~= nil and table.Count(UVLoadedRoadblocks) < UVRBMax:GetInt() and CheckSpawnChance(rbchance)
	local canSpawnHelicopter = uvHelicopterDeployable and #ents.FindByClass("uvair") < helilimit and CheckSpawnChance(helichance)

	local pool = {
		'normal',
	}

	if canSpawnRoadblock then
		table.insert(pool, 'roadblock')
	end
	if canSpawnHelicopter then
		table.insert(pool, 'helicopter')
	end
	if UVCommanderRespawning then
		table.insert(pool, 'commander')
	end

	local random = pool[math.random(#pool)]

	local funcs = {
		['helicopter'] = function()
			UVAutoSpawn(nil, nil, true)
		end,
		['roadblock'] = function()
			local units = ents.FindByClass("npc_uv*")
			local unit = units[math.random(#units)]
			if not UVDeployRoadblock(unit) then UVAutoSpawn(nil) end
		end,
		['normal'] = function()
			UVAutoSpawn(nil)
		end,
	}

	funcs[random]()
end

function UVResetStats()
	if next(UVWantedTableVehicle) == nil and next(UVWantedTableDriver) == nil then
		UVBounty = 0
		UVHeatLevel = 1
		
		if timer.Exists("UVTimeTillNextHeat") then
			timer.Remove("UVTimeTillNextHeat")
		end
	end
	UVDeploys = 0
	UVWrecks = 0
	UVTags = 0
	UVRoadblocksDodged = 0
	UVSpikestripsDodged = 0
	if UVBounty == 0 then
		UVHeatLevel = MinHeatLevel:GetInt()
	end
	if UVEnemyEscaping then
		UVEnemyEscaping = nil
	end
	if UVTimer then
		UVTimer = nil
	end
end

function UVRestoreResourcePoints()
	UVResourcePointsRefreshing = true

	if not UVOneCommanderActive then
		UVOneCommanderDeployed = nil
	else
		UVOneCommanderDeployed = true
	end

	timer.Simple(1, function()
		if UVResourcePointsRefreshing then
			UVResourcePointsRefreshing = false
		end
	end)
	
	local unitsAvailableConVar = GetConVar( "unitvehicle_unit_unitsavailable" .. UVHeatLevel )
	
	UVUpdateGlobalPursuit('ResourcePoints', unitsAvailableConVar:GetInt())
	UVBackupUnderway = nil
end

function UVRequestVectorsnavmesh( start, goal, carwidth )
	local startArea = navmesh.GetNearestNavArea( start )
	local goalArea = navmesh.GetNearestNavArea( goal )
	
	if UVEnemyEscaping then
		local navmeshtable = navmesh.GetAllNavAreas()
		if next(navmeshtable) ~= nil then
			goalArea = navmeshtable[math.random(#navmeshtable)] --Go to a random spot when searching
		end
	end
	
	if not carwidth then
		carwidth = 0
	end

	return UVEstablishVectorsnavmesh( startArea, goalArea, carwidth )
end

function UVEstablishVectorsnavmesh( start, goal, carwidth )
	if ( not IsValid( start ) or not IsValid( goal ) ) then return nil end
	if ( start == goal ) then return true end
	
	local directDistance = start:GetCenter():Distance( goal:GetCenter() )
	if directDistance > 1000000 then
		return false
	end
	
	start:ClearSearchLists()
	start:AddToOpenList()
	
	local cameFrom = {}
	local heuristicCache = {}
	
	start:SetCostSoFar( 0 )

	local initialHeuristic = UVheuristic_cost_estimate(start, goal)
	heuristicCache[start:GetID() .. "_" .. goal:GetID()] = initialHeuristic
	
	start:SetTotalCost( initialHeuristic )
	start:UpdateOnOpenList()

	local i = 0
	local maxIterations = 5000
	local startTime = SysTime()
	local maxTime = 0.016
	
	while ( not start:IsOpenListEmpty() ) do
		if SysTime() - startTime > maxTime then
			return false
		end
		
		i = i + 1
		local current = start:PopOpenList()
		
		if ( current == goal or i > maxIterations ) then
			return table.Reverse( UVreconstruct_path( cameFrom, current ) )
		end
		
		current:AddToClosedList()
		
		if current:GetCostSoFar() > directDistance * 3 then
			return false
		end
		
		for k, neighbor in pairs( current:GetAdjacentAreas() ) do
			--print(current:ComputeAdjacentConnectionHeightChange(neighbor), neighbor:IsUnderwater())
			if ( neighbor:IsUnderwater() or 
			current:ComputeAdjacentConnectionHeightChange(neighbor) > 1 ) then
				continue
			end

			-- if carwidth and carwidth > 0 then
			-- 	local areaWidth = neighbor:GetSizeX()
			-- 	if areaWidth < carwidth then
			-- 		continue
			-- 	end
			-- end
			
			local cacheKey = neighbor:GetID() .. "_" .. goal:GetID()
			local neighborHeuristic = heuristicCache[cacheKey]
			if not neighborHeuristic then
				neighborHeuristic = UVheuristic_cost_estimate( neighbor, goal )
				heuristicCache[cacheKey] = neighborHeuristic
			end
			
			local newCostSoFar = current:GetCostSoFar() + UVheuristic_cost_estimate( current, neighbor )
			
			if ( ( neighbor:IsOpen() or neighbor:IsClosed() ) ) then
				continue
			end
			
			neighbor:SetCostSoFar( newCostSoFar )
			neighbor:SetTotalCost( newCostSoFar + neighborHeuristic )
			
			if ( neighbor:IsClosed() ) then
				neighbor:RemoveFromClosedList()
			end
			
			if ( neighbor:IsOpen() ) then
				neighbor:UpdateOnOpenList()
			else
				neighbor:AddToOpenList()
			end
			
			cameFrom[neighbor:GetID()] = current:GetID()
		end
	end

	return false
end

function UVheuristic_cost_estimate( start, goal )
	return start:GetCenter():Distance( goal:GetCenter() )
end

function UVreconstruct_path( cameFrom, current )
	local total_path = { current }
	
	current = current:GetID()
	local maxPathLength = 1000
	local pathLength = 0
	
	while ( cameFrom[ current ] and pathLength < maxPathLength ) do
		pathLength = pathLength + 1
		current = cameFrom[ current ]
		table.insert( total_path, navmesh.GetNavAreaByID( current ) )
	end
	
	-- If we hit the max length, something went wrong
	if pathLength >= maxPathLength then
		return false
	end

	--print(#total_path)
	
	return total_path
end

function UVdrawThePath( path, time )
	local prevArea
	
	for _, area in pairs( path ) do
		debugoverlay.Sphere( area:GetCenter(), 8, time or 9, color_white, true  )
		if ( prevArea ) then
			debugoverlay.Line( area:GetCenter(), prevArea:GetCenter(), time or 9, color_white, true )
		end
		
		area:Draw()
		prevArea = area
	end
end

function UVPassConVarFilter(v)
	
	if v.uvbusted then
		return false
	end
	
	if v:GetClass() == "prop_vehicle_prisoner_pod" then 
		return false 
	end

	if v.IsSimfphyscar or v.LVS then
		if not v:IsInitialized() then return false end
		if v.LVS and v.BaseClass.ClassName ~= "lvs_base_wheeldrive" then return false end
	end
	
	local innocent = IsValid(v.DecentVehicle) or IsValid(v.TrafficVehicle) or IsValid(v.UnitVehicle)
	
	if (v:GetClass() == "prop_vehicle_jeep" or v.IsSimfphyscar or v.IsGlideVehicle or v.LVS) then
		return (IsValid(v.MadVehicle) or (UVGetDriver(v) and UVGetDriver(v):IsPlayer()) or IsValid(v.RacerVehicle)) and not innocent or IsValid(v.UVWanted)
	end
	
	return false
end

function UVStraightToWaypoint(origin, waypoint)
	if not origin or not waypoint then
		return
	end
	
	--local originpos = util.TraceLine({start = origin, endpos = (origin+Vector(0,0,-1000)), mask = MASK_NPCWORLDSTATIC}).HitPos
	--local waypointpos = util.TraceLine({start = waypoint, endpos = (waypoint+Vector(0,0,-1000)), mask = MASK_NPCWORLDSTATIC}).HitPos
	
	local tr = util.TraceLine({start = origin, endpos = waypoint, mask = MASK_NPCWORLDSTATIC}).Fraction==1
	return tobool(tr)
end

hook.Add("OnEntityCreated", "UVCollisionGlide", function(glidevehicle) --Override Glide collisions for the time being 
	if not Glide then return end

	if ( glidevehicle.IsGlideVehicle ) then
		local oldphysCollide = glidevehicle.PhysicsCollide
		glidevehicle.PhysicsCollide = function( car, coldata, ent )
			oldphysCollide(car, coldata, ent)
			
			local ourOldVel = coldata.OurOldVelocity:Length()
			local ourNewVel = coldata.OurNewVelocity:Length()
			local resultVel = ourOldVel
			local object = coldata.HitEntity

			if ourOldVel > ourNewVel then --slowed
				resultVel = ourOldVel - ourNewVel
			else --sped up
				resultVel = ourNewVel - ourOldVel
			end

			local dot = coldata.OurOldVelocity:GetNormalized():Dot(coldata.HitNormal)
			dot = math.abs(dot) / 2
			local dmg = resultVel * dot

			if dmg >= ActionCamCrashThreshold:GetInt() then
				local driver = UVGetDriver(car)
				if driver and not object.PursuitBreaker and not object.UVRoadblock then
					UVActionCam(driver, "Crash")
				end
			end
			
			if dmg >= 100 and car.wrecked then
				UVDetachWheels(car, coldata.HitPos)
			end

			if (dmg >= 100 or object.juggernauton) and car.RacerVehicle and (object:IsVehicle() or object.LVS) then
                car.RacerVehicle:AddEnemy(object)
            end

			if object.PursuitBreakerActive then
				local driver = car.UnitVehicle or car.TrafficVehicle
                    
				if driver then
					UVPlayerWreck(car)
					return
				end	
			end

			if car.DecentVehicle or car.TrafficVehicle or object.rammed then
				UVRamVehicle(car)
			end

			if car.grappleron and object.UVWanted then --Grappler
				UVGrapple(car, object)
			end

			if car.juggernauton and not object:IsWorld() then --Juggernaut
				local ourOldVel = coldata.OurOldVelocity
				local ourOldAngVel = coldata.OurOldAngularVelocity
				local objectPhys = object:GetPhysicsObject()
				local Phys = car:GetPhysicsObject()
				local force = car:GetVelocity():LengthSqr()

				local carPos = car:WorldSpaceCenter()
				local vectorDifference = object:WorldSpaceCenter() - carPos
				local angle = vectorDifference:Angle()

				objectPhys:ApplyForceCenter(angle:Forward()*force)

				--Preserve momentum
        		Phys:SetVelocity(ourOldVel)
				Phys:SetAngleVelocityInstantaneous(ourOldAngVel)

				local sounds = {
					"gadgets/juggernaut/impact_hard1.wav",
					"gadgets/juggernaut/impact_hard2.wav",
					"gadgets/juggernaut/impact_hard3.wav",
					"gadgets/juggernaut/impact_medium1.wav",
					"gadgets/juggernaut/impact_medium2.wav",
					"gadgets/juggernaut/impact_medium3.wav",
					"gadgets/juggernaut/impact_soft1.wav",
					"gadgets/juggernaut/impact_soft2.wav",
					"gadgets/juggernaut/impact_soft3.wav",
				}
				
				if not car.juggernauthit then
					car.juggernauthit = true
					car:EmitSound(sounds[math.random(1, #sounds)])
					timer.Simple(1, function()
						if IsValid(car) then
							car.juggernauthit = nil
						end
					end)
				end
			end

			if car.esfon and (object:IsVehicle() or object.LVS) and not (object.UnitVehicle and car.UnitVehicle) then --ESF

				if not object.UnitVehicle and not car.UnitVehicle then
					if not RacerFriendlyFire:GetBool() then return end
				end

				local enemyVehicle = object

				local enemyDriver = UVGetDriver(enemyVehicle)
				local power
				local damage
				if car.UnitVehicle then
					power = UVUnitPTESFPower:GetInt()
					damage = UVUnitPTESFDamage:GetFloat()
					if UVIsPTUpgraded(car) then
						power = power * 2
						damage = damage * 2
					end
				else
					power = UVPTESFPower:GetInt()
					damage = UVPTESFDamage:GetFloat()
				end

				local carPos = car:WorldSpaceCenter()
				local enemyVehiclePhys = enemyVehicle:GetPhysicsObject()
				local vectorDifference = enemyVehicle:WorldSpaceCenter() - carPos
				local angle = vectorDifference:Angle()
				local force = power * (1 - (vectorDifference:Length()/1000))

				enemyVehiclePhys:ApplyForceCenter(angle:Forward()*force)
				UVRamVehicle(enemyVehicle)

				if object.UnitVehicle or (object.UVWanted and not AutoHealth:GetBool()) or not (object.UnitVehicle and object.UVWanted) then
					damage = (table.HasValue(UVCommanders, object) and UVPTESFCommanderDamage:GetFloat()) or damage
					UVDamage(object, damage)
				end

				ReportPTEvent( car, enemyVehicle, 'ESF', 'Hit' )

				local e = EffectData()
				e:SetEntity(enemyVehicle)
				util.Effect("entity_remove", e)
				enemyVehicle:EmitSound("gadgets/esf/impact.wav")
				car.uvesfhit = true
				UVDeactivateESF(car)
				if car.UnitVehicle then
					UVChatterESFHit(car.UnitVehicle)
				end

			end
			if car.UVWanted then --SUSPECT
				local scope = UVGetScope(car)
				if object:IsWorld() or object.DecentVehicle or object.TrafficVehicle then --Crashed into world
					if dmg >= 100 and (scope and not scope.EnemyEscaping) and UVTargeting then
						if object:IsWorld() then
							if Chatter:GetBool() and UVTargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
								local units = ents.FindByClass("npc_uv*")
								local random_entry = math.random(#units)	
								local unit = units[random_entry]
								if IsValid(unit.e) and car == unit.e then
									UVChatterEnemyCrashed(unit) 
								end
							end
						elseif object.DecentVehicle or object.TrafficVehicle then
							if Chatter:GetBool() and UVTargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
								local units = ents.FindByClass("npc_uv*")
								local random_entry = math.random(#units)	
								local unit = units[random_entry]
								if IsValid(unit.e) and car == unit.e then
									if object.Sockets and next(object.Sockets) ~= nil then
										UVChatterHitTrafficSemi(unit)
									else
										UVChatterHitTraffic(unit)
									end
								end
							end
						end
					end
				end
				if object.UVRoadblock and not object.UVRoadblock.RoadBlockHit then --Crashed into roadblock
					object.UVRoadblock.RoadBlockHit = true

					local driver = UVGetDriver(car)
					if driver and ourOldVel > ActionCamRoadblockThreshold:GetInt() then
						UVActionCam(driver, "Roadblock")
					end

					if Chatter:GetBool() and UVTargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)	
						local unit = units[random_entry]
						if IsValid(unit.e) and car == unit.e then
							UVChatterRoadblockHit(unit) 
						end
					end
				end
			elseif car.UnitVehicle then --UNIT NPC
				local driver = UVGetDriver(car)
				local NPC = ((IsValid(driver) and driver) or car.UnitVehicle)--car.UnitVehicle
				if NPC and (NPC:IsNPC() or NPC:IsPlayer()) then
					if (not UVTargeting and UVPassConVarFilter(object) or UVTargeting and object.UVWanted) then
						UVRamVehicle(car)
					end

					if coldata.TheirOldVelocity:Length() > ourOldVel then
						UVAddInfraction(object, 'rampolice', true)
					end

					if object.UVWanted and not car.tagged then
						car.tagged = true
						UVTags = UVTags + 1
						local scope = UVGetScope(object)
						if scope then
							scope.Tags = scope.Tags + 1
						end
						hook.Run( "UV_Event", "onUnitTagged", object, car )
						if car.rhino and not car.rhinohit then
							car.rhinohit = true
							if Chatter:GetBool() and UVTargeting and not NPC:IsPlayer() and not car.roadblocking and not car.disperse then
								UVSoundChatter(NPC, NPC.voice, "rhinohit", 1)
							end
						end
					end

					if dmg >= 100 and object.UVWanted then
						if Chatter:GetBool() then
							if coldata.TheirOldVelocity:Length() > ourOldVel then
								if not NPC:IsPlayer() then
									UVChatterRammed(NPC)
								end
								UVDeactivateKillSwitch(car)
							else
								if not NPC:IsPlayer() then
									UVChatterRammedEnemy(NPC)
								end
							end
						end
						if not NPC.ramming and not NPC:IsPlayer() then
							NPC.ramming = true
							NPC:SetHorn(true)
						end
						timer.Simple(math.random(1,5), function()
							if NPC and not NPC:IsPlayer() then
								if NPC.ramming then
									NPC.ramming = nil
									NPC:SetHorn(false)
									NPC:ChangeELSSiren()
								end
							end
						end)
					end
				end
				if (NPC and NPC:IsPlayer()) and not UVTargeting and not UVEnemyEscaped and not UVEnemyBusted and table.HasValue(UVPotentialSuspects, object) then
					UVTargeting = true
				end
				if dmg >= 100 and NPC:IsNPC() then
					NPC.emergencystop = true
				end
			elseif car.TrafficVehicle then --TRAFFIC
				if dmg >= 100 then
					if IsValid(car.TrafficVehicle) then
						car.TrafficVehicle.emergencystop = true
					end
				end
			end
			if not object.UnitVehicle and not object:IsWorld() then --CALL HANDLER
				if object:IsVehicle() then --Hit And Run
					UVAddInfraction(car, 'ram')
				elseif not object:IsPlayer() and not object:IsNPC() then --Damage to Property
					if object.PursuitBreaker then UVCallInitiate(car, 'property') end
					UVAddInfraction(car, 'property')
				end
			end
		end
	end
	
end)

hook.Add("simfphysPhysicsCollide", "UVCollisionSimfphys", function(car, coldata, ent)
	if not IsValid(car) or car:GetClass() ~= "gmod_sent_vehicle_fphysics_base" then return end

	local ourOldVel = coldata.OurOldVelocity:Length()
	local ourNewVel = coldata.OurNewVelocity:Length()
	local resultVel = ourOldVel
	local object = coldata.HitEntity

	if ourOldVel > ourNewVel then --slowed
		resultVel = ourOldVel - ourNewVel
	else --sped up
		resultVel = ourNewVel - ourOldVel
	end

	local dot = coldata.OurOldVelocity:GetNormalized():Dot(coldata.HitNormal)
	dot = math.abs(dot) / 2
	local dmg = resultVel * dot

	if dmg >= ActionCamCrashThreshold:GetInt() then
		local driver = UVGetDriver(car)
		if driver and not object.PursuitBreaker and not object.UVRoadblock then
			UVActionCam(driver, "Crash")
		end
	end
	
	if dmg >= 100 and car.wrecked then
		UVDetachWheels(car, coldata.HitPos)
	end

	if (dmg >= 100 or object.juggernauton) and car.RacerVehicle and (object:IsVehicle() or object.LVS) then
        car.RacerVehicle:AddEnemy(object)
    end

	if car.DecentVehicle or car.TrafficVehicle or object.rammed then
		UVRamVehicle(car)
	end

	if object.PursuitBreakerActive then
		local driver = car.UnitVehicle or car.TrafficVehicle
			
		if driver then
			UVPlayerWreck(car)
			return
		end	
	end

	if car.grappleron and object.UVWanted then --Grappler
		UVGrapple(car, object)
	end

	if car.juggernauton and not object:IsWorld() then --Juggernaut
		local ourOldVel = coldata.OurOldVelocity
		local ourOldAngVel = coldata.OurOldAngularVelocity
		local objectPhys = object:GetPhysicsObject()
		local Phys = car:GetPhysicsObject()
		local force = car:GetVelocity():LengthSqr()

		local carPos = car:WorldSpaceCenter()
		local vectorDifference = object:WorldSpaceCenter() - carPos
		local angle = vectorDifference:Angle()

		objectPhys:ApplyForceCenter(angle:Forward()*force)

		--Preserve momentum
    	Phys:SetVelocity(ourOldVel)
		Phys:SetAngleVelocityInstantaneous(ourOldAngVel)

		local sounds = {
			"gadgets/juggernaut/impact_hard1.wav",
			"gadgets/juggernaut/impact_hard2.wav",
			"gadgets/juggernaut/impact_hard3.wav",
			"gadgets/juggernaut/impact_medium1.wav",
			"gadgets/juggernaut/impact_medium2.wav",
			"gadgets/juggernaut/impact_medium3.wav",
			"gadgets/juggernaut/impact_soft1.wav",
			"gadgets/juggernaut/impact_soft2.wav",
			"gadgets/juggernaut/impact_soft3.wav",
		}
		
		if not car.juggernauthit then
			car.juggernauthit = true
			car:EmitSound(sounds[math.random(1, #sounds)])
			timer.Simple(1, function()
				if IsValid(car) then
					car.juggernauthit = nil
				end
			end)
		end
	end

	if car.esfon and (object:IsVehicle() or object.LVS) and not (object.UnitVehicle and car.UnitVehicle) then --ESF
		if not object.UnitVehicle and not car.UnitVehicle then
			if not RacerFriendlyFire:GetBool() then return end
		end

		local enemyVehicle = object

		local enemyDriver = UVGetDriver(enemyVehicle)
		local power
		local damage

		if car.UnitVehicle then
			power = UVUnitPTESFPower:GetInt()
			damage = UVUnitPTESFDamage:GetFloat()
			if UVIsPTUpgraded(car) then
				power = power * 2
				damage = damage * 2
			end
		else
			power = UVPTESFPower:GetInt()
			damage = UVPTESFDamage:GetFloat()
		end

		local carPos = car:WorldSpaceCenter()
		local enemyVehiclePhys = enemyVehicle:GetPhysicsObject()
		local vectorDifference = enemyVehicle:WorldSpaceCenter() - carPos
		local angle = vectorDifference:Angle()
		local force = power * (1 - (vectorDifference:Length()/1000))

		enemyVehiclePhys:ApplyForceCenter(angle:Forward()*force)
		UVRamVehicle(enemyVehicle)

		if object.UnitVehicle or (object.UVWanted and not AutoHealth:GetBool()) or not (object.UnitVehicle and object.UVWanted) then
			damage = (table.HasValue(UVCommanders, object) and UVPTESFCommanderDamage:GetFloat()) or damage
			UVDamage(object, damage)
		end

		ReportPTEvent( car, enemyVehicle, 'ESF', 'Hit' )

		local e = EffectData()
		e:SetEntity(enemyVehicle)
		util.Effect("entity_remove", e)
		enemyVehicle:EmitSound("gadgets/esf/impact.wav")
		car.uvesfhit = true
		UVDeactivateESF(car)

		if car.UnitVehicle then
			UVChatterESFHit(car.UnitVehicle)
		end
	end
	if car.UVWanted then --SUSPECT
		local scope = UVGetScope(car)
		if object:IsWorld() or object.DecentVehicle or object.TrafficVehicle then --Crashed into world
			if dmg >= 100 and (scope and not scope.EnemyEscaping) and UVTargeting then
				if object:IsWorld() then
					if Chatter:GetBool() and UVTargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)	
						local unit = units[random_entry]
						if not IsValid(unit.e) then return end
						UVChatterEnemyCrashed(unit)
					end
				elseif object.DecentVehicle or object.TrafficVehicle then
					if Chatter:GetBool() and UVTargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)	
						local unit = units[random_entry]
						if not IsValid(unit.e) then return end
						UVChatterHitTraffic(unit)
					end
				end
			end
		end

		if object.UVRoadblock and not object.UVRoadblock.RoadBlockHit then --Crashed into roadblock
			object.UVRoadblock.RoadBlockHit = true

			local driver = UVGetDriver(car)
			if driver and ourOldVel > ActionCamRoadblockThreshold:GetInt() then
				UVActionCam(driver, "Roadblock")
			end

			if Chatter:GetBool() and UVTargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if IsValid(unit.e) and car == unit.e then
					UVChatterRoadblockHit(unit) 
				end
			end
		end

	elseif car.UnitVehicle then --UNIT NPC
		local driver = UVGetDriver(car)
		local NPC = ((IsValid(driver) and driver) or car.UnitVehicle)--car.UnitVehicle

		if NPC and (NPC:IsNPC() or NPC:IsPlayer()) then
			if (not UVTargeting and UVPassConVarFilter(object) or UVTargeting and object.UVWanted) then
				UVRamVehicle(car)
			end

			if coldata.TheirOldVelocity:Length() > ourOldVel then
				UVAddInfraction(object, 'rampolice', true)
			end

			if object.UVWanted and not car.tagged then
				car.tagged = true
				UVTags = UVTags + 1
				local scope = UVGetScope(object)
				if scope then
					scope.Tags = scope.Tags + 1
				end
				hook.Run( "UV_Event", "onUnitTagged", object, car )
				if car.rhino and not car.rhinohit then
					car.rhinohit = true
					if Chatter:GetBool() and UVTargeting and not NPC:IsPlayer() and not car.roadblocking and not car.disperse then
						UVSoundChatter(NPC, NPC.voice, "rhinohit", 1)
					end
				end
			end

			if dmg >= 100 and object.UVWanted then
				if Chatter:GetBool() then
					if coldata.TheirOldVelocity:Length() > ourOldVel then
						if not NPC:IsPlayer() then
							UVChatterRammed(NPC)
						end
						UVDeactivateKillSwitch(car)
					else
						if not NPC:IsPlayer() then
							UVChatterRammedEnemy(NPC)
						end
					end
				end
				if not NPC.ramming and not NPC:IsPlayer() then
					NPC.ramming = true
					NPC:SetHorn(true)
				end
				timer.Simple(math.random(1,5), function()
					if not NPC then return end
					if NPC.ramming and not NPC:IsPlayer() then
						NPC.ramming = nil
						NPC:SetHorn(false)
						NPC:ChangeELSSiren()
					end
				end)
			end
		end
		if (NPC and NPC:IsPlayer()) and not UVTargeting and not UVEnemyEscaped and not UVEnemyBusted and table.HasValue(UVPotentialSuspects, object) then
			UVTargeting = true
		end
		if dmg >= 100 and NPC:IsNPC() then
			NPC.emergencystop = true
		end
	elseif car.TrafficVehicle then --TRAFFIC
		if dmg >= 100 then
			if IsValid(car.TrafficVehicle) then
				car.TrafficVehicle.emergencystop = true
			end
		end
	end

	if not object.UnitVehicle and not object:IsWorld() then --CALL HANDLER
		if object:IsVehicle() then --Hit And Run
			UVAddInfraction(car, 'ram')
		elseif not object:IsPlayer() and not object:IsNPC() then --Damage to Property
			if object.PursuitBreaker then UVCallInitiate(car, 'property') end
			UVAddInfraction(car, 'property')
		end
	end
end)

hook.Add("OnEntityCreated", "UVCollisionJeep", function(vehicle)
	if not vehicle:GetClass() == "prop_vehicle_jeep" then return end
	vehicle:AddCallback("PhysicsCollide", function(car, coldata)
		if not IsValid(car) or car:GetClass() ~= "prop_vehicle_jeep" then return end

		local ourOldVel = coldata.OurOldVelocity:Length()
		local ourNewVel = coldata.OurNewVelocity:Length()
		local resultVel = ourOldVel
		local object = coldata.HitEntity

		if ourOldVel > ourNewVel then --slowed
			resultVel = ourOldVel - ourNewVel
		else --sped up
			resultVel = ourNewVel - ourOldVel
		end

		local dot = coldata.OurOldVelocity:GetNormalized():Dot(coldata.HitNormal)
		dot = math.abs(dot) / 2
		local dmg = resultVel * dot

		if car.wrecked and dmg >= 10 then
			local e = EffectData()
			e:SetOrigin(coldata.HitPos)
			util.Effect("cball_explode", e)
		end

		if (dmg >= 100 or object.juggernauton) and car.RacerVehicle and (object:IsVehicle() or object.LVS) then
            car.RacerVehicle:AddEnemy(object)
        end

		if car.DecentVehicle or car.TrafficVehicle or object.rammed then
			UVRamVehicle(car)
		end

		if object.PursuitBreakerActive then
			local driver = car.UnitVehicle or car.TrafficVehicle
				
			if driver then
				UVPlayerWreck(car)
				return
			end	
		end

		if car.UnitVehicle or (car.UVWanted and not AutoHealth:GetBool()) then --DAMAGE
			if not car.healthset then
				if car.uvclasstospawnon == "npc_uvcommander" or car.UVCommander then
					local health = UVUOneCommanderHealth:GetInt()
					car:SetMaxHealth(UVUOneCommanderHealth:GetInt())
					car:SetHealth(health)
				else
					local mass = vehicle:GetPhysicsObject():GetMass()
					vehicle:SetMaxHealth(mass)
					vehicle:SetHealth(mass)
				end
				car.healthset = true
			end
			if not vcmod_main and dmg >= 10 then
				car:SetHealth(car:Health()-dmg)
				local e = EffectData()
				e:SetOrigin(coldata.HitPos)
				if car:Health() <= (car:GetMaxHealth()/4) then
					util.Effect("cball_explode", e)
				else
					util.Effect("StunstickImpact", e)
				end
				if car:Health() <= car:GetMaxHealth()/4 and not car.jeepdamaged then 
					car.jeepdamaged = true
					if car:LookupAttachment("vehicle_engine") > 0 then
						ParticleEffectAttach("smoke_burning_engine_01", PATTACH_POINT_FOLLOW, car, car:LookupAttachment("vehicle_engine"))
					end
				end
			end
		end

		if car.grappleron and object.UVWanted then --Grappler
			UVGrapple(car, object)
		end

		if car.juggernauton and not object:IsWorld() then --Juggernaut
			local ourOldVel = coldata.OurOldVelocity
			local ourOldAngVel = coldata.OurOldAngularVelocity
			local objectPhys = object:GetPhysicsObject()
			local Phys = car:GetPhysicsObject()
			local force = car:GetVelocity():LengthSqr()

			local carPos = car:WorldSpaceCenter()
			local vectorDifference = object:WorldSpaceCenter() - carPos
			local angle = vectorDifference:Angle()

			objectPhys:ApplyForceCenter(angle:Forward()*force)

			--Preserve momentum
    		Phys:SetVelocity(ourOldVel)
			Phys:SetAngleVelocityInstantaneous(ourOldAngVel)

			local sounds = {
				"gadgets/juggernaut/impact_hard1.wav",
				"gadgets/juggernaut/impact_hard2.wav",
				"gadgets/juggernaut/impact_hard3.wav",
				"gadgets/juggernaut/impact_medium1.wav",
				"gadgets/juggernaut/impact_medium2.wav",
				"gadgets/juggernaut/impact_medium3.wav",
				"gadgets/juggernaut/impact_soft1.wav",
				"gadgets/juggernaut/impact_soft2.wav",
				"gadgets/juggernaut/impact_soft3.wav",
			}
			
			if not car.juggernauthit then
				car.juggernauthit = true
				car:EmitSound(sounds[math.random(1, #sounds)])
				timer.Simple(1, function()
					if IsValid(car) then
						car.juggernauthit = nil
					end
				end)
			end
		end

		if car.esfon and (object:IsVehicle() or object.LVS) and not (object.UnitVehicle and car.UnitVehicle) then --ESF
			if not object.UnitVehicle and not car.UnitVehicle then
				if not RacerFriendlyFire:GetBool() then return end
			end

			local enemyVehicle = object

			local enemyDriver = UVGetDriver(enemyVehicle)
			local power
			local damage
			if car.UnitVehicle then
				power = UVUnitPTESFPower:GetInt()
				damage = UVUnitPTESFDamage:GetFloat()
				if UVIsPTUpgraded(car) then
					power = power * 2
					damage = damage * 2
				end
			else
				power = UVPTESFPower:GetInt()
				damage = UVPTESFDamage:GetFloat()
			end
			local carPos = car:WorldSpaceCenter()
			local enemyVehiclePhys = enemyVehicle:GetPhysicsObject()
			local vectorDifference = enemyVehicle:WorldSpaceCenter() - carPos
			local angle = vectorDifference:Angle()
			local force = power * (1 - (vectorDifference:Length()/1000))
			enemyVehiclePhys:ApplyForceCenter(angle:Forward()*force)
			UVRamVehicle(enemyVehicle)
			if object.UnitVehicle or (object.UVWanted and not AutoHealth:GetBool()) or not (object.UnitVehicle and object.UVWanted) then
				damage = (table.HasValue(UVCommanders, object) and UVPTESFCommanderDamage:GetFloat()) or damage
				UVDamage(object, damage)
			end

			ReportPTEvent( car, enemyVehicle, 'ESF', 'Hit' )

			local e = EffectData()
			e:SetEntity(enemyVehicle)
			util.Effect("entity_remove", e)
			enemyVehicle:EmitSound("gadgets/esf/impact.wav")
			car.uvesfhit = true
			UVDeactivateESF(car)
			if car.UnitVehicle then
				UVChatterESFHit(car.UnitVehicle)
			end
		end

		if car.UVWanted then --SUSPECT
			local scope = UVGetScope(car)
			if object:IsWorld() or object.DecentVehicle or object.TrafficVehicle then --Crashed into world
				if dmg >= 100 and (scope and not scope.EnemyEscaping) and UVTargeting then
					if object:IsWorld() then
						if Chatter:GetBool() and UVTargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
							local units = ents.FindByClass("npc_uv*")
							local random_entry = math.random(#units)	
							local unit = units[random_entry]
							if not IsValid(unit.e) then return end
							UVChatterEnemyCrashed(unit)
						end
					elseif object.DecentVehicle or object.TrafficVehicle then
						if Chatter:GetBool() and UVTargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
							local units = ents.FindByClass("npc_uv*")
							local random_entry = math.random(#units)	
							local unit = units[random_entry]
							if not IsValid(unit.e) then return end
							UVChatterHitTraffic(unit)
						end
					end
				end
			end
			if object.UVRoadblock and not object.UVRoadblock.RoadBlockHit then --Crashed into roadblock
				object.UVRoadblock.RoadBlockHit = true

				local driver = UVGetDriver(car)
				if driver and ourOldVel > ActionCamRoadblockThreshold:GetInt() then
					UVActionCam(driver, "Roadblock")
				end

				if Chatter:GetBool() and UVTargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if IsValid(unit.e) and car == unit.e then
						UVChatterRoadblockHit(unit) 
					end
				end
			end

		elseif car.UnitVehicle then --UNIT NPC
			local driver = UVGetDriver(car)
			local NPC = ((IsValid(driver) and driver) or car.UnitVehicle)--car.UnitVehicle
			if NPC and (NPC:IsNPC() or NPC:IsPlayer()) then
				if (not UVTargeting and UVPassConVarFilter(object) or UVTargeting and object.UVWanted) then
					UVRamVehicle(car)
				end

				if coldata.TheirOldVelocity:Length() > ourOldVel then
					UVAddInfraction(object, 'rampolice', true)
				end
				
				if object.UVWanted and not car.tagged then
					car.tagged = true
					UVTags = UVTags + 1
					local scope = UVGetScope(object)
					if scope then
						scope.Tags = scope.Tags + 1
					end
					hook.Run( "UV_Event", "onUnitTagged", object, car )
					if car.rhino and not car.rhinohit then
						car.rhinohit = true
						if Chatter:GetBool() and UVTargeting and not car.roadblocking and not car.disperse then
							UVSoundChatter(NPC, NPC.voice, "rhinohit", 1)
						end
					end
				end

				if dmg >= 100 and object.UVWanted then
					if Chatter:GetBool() then
						if coldata.TheirOldVelocity:Length() > ourOldVel then
							UVChatterRammed(NPC)
							UVDeactivateKillSwitch(car)
						else
							UVChatterRammedEnemy(NPC)
						end
					end
					if not NPC.ramming then
						NPC.ramming = true
						NPC:SetHorn(true)
					end
					timer.Simple(math.random(1,5), function()
						if not NPC then return end
						if NPC.ramming then
							NPC.ramming = nil
							NPC:SetHorn(false)
							NPC:ChangeELSSiren()
						end
					end)
				end
			end

			if (NPC and NPC:IsPlayer()) and not UVTargeting and not UVEnemyEscaped and not UVEnemyBusted and table.HasValue(UVPotentialSuspects, object) then
				UVTargeting = true
			end
			if dmg >= 100 and NPC:IsNPC() then
				NPC.emergencystop = true
			end
		elseif car.TrafficVehicle then --TRAFFIC
			if dmg >= 100 then
				if IsValid(car.TrafficVehicle) then
					car.TrafficVehicle.emergencystop = true
				end
			end
		end
		if not object.UnitVehicle and not object:IsWorld() then --CALL HANDLER
			if object:IsVehicle() then --Hit And Run
				UVAddInfraction(car, 'ram')
			elseif not object:IsPlayer() and not object:IsNPC() then --Damage to Property
				if object.PursuitBreaker then UVCallInitiate(car, 'property') end
				UVAddInfraction(car, 'property')
			end
		end
	end)
end)

hook.Add("OnEntityCreated", "UVCollisionLVS", function(lvsvehicle)
	if not lvsvehicle.LVS then return end
	if not LVS or lvsvehicle.BaseClass.ClassName ~= "lvs_base_wheeldrive" then return end

	if ( lvsvehicle.LVS ) then
		lvsvehicle.CalcThrottle = function( car, ply )
			local FullThrottle = ply:GetInfoNum( "unitvehicle_lvsalwaysfullthrottle", 0 )

			local KeyThrottle = ply:lvsKeyDown( "CAR_THROTTLE" )
			local KeyBrakes = ply:lvsKeyDown( "CAR_BRAKE" )

			if car:GetReverse() and not car:IsManualTransmission() then
				KeyThrottle = ply:lvsKeyDown( "CAR_BRAKE" )
				KeyBrakes = ply:lvsKeyDown( "CAR_THROTTLE" )
			end
		
			local ThrottleValue = (FullThrottle == 1 or ply:lvsKeyDown( "CAR_THROTTLE_MOD" )) and car:GetMaxThrottle() or 0.5
			local Throttle = KeyThrottle and ThrottleValue or 0
		
			if not car:IsLegalInput() then
				car:LerpThrottle( 0 )
				car:LerpBrake( (KeyThrottle or KeyBrakes) and 1 or 0 )
			
				return
			end
		
			car:LerpThrottle( Throttle )
			car:LerpBrake( KeyBrakes and 1 or 0 )
		end
		
		local oldphysCollide = lvsvehicle.PhysicsCollide
		lvsvehicle.PhysicsCollide = function( car, coldata, ent )
			oldphysCollide(car, coldata, ent)

			local ourOldVel = coldata.OurOldVelocity:Length()
			local ourNewVel = coldata.OurNewVelocity:Length()
			local resultVel = ourOldVel
			local object = coldata.HitEntity

			if ourOldVel > ourNewVel then --slowed
				resultVel = ourOldVel - ourNewVel
			else --sped up
				resultVel = ourNewVel - ourOldVel
			end

			local dot = coldata.OurOldVelocity:GetNormalized():Dot(coldata.HitNormal)
			dot = math.abs(dot) / 2
			local dmg = resultVel * dot

			if dmg >= ActionCamCrashThreshold:GetInt() then
				local driver = UVGetDriver(car)
				if driver and not object.PursuitBreaker and not object.UVRoadblock then
					UVActionCam(driver, "Crash")
				end
			end
			
			if dmg >= 100 and car.wrecked then
				UVDetachWheels(car, coldata.HitPos)
			end

			if (dmg >= 100 or object.juggernauton) and car.RacerVehicle and (object:IsVehicle() or object.LVS) then
                car.RacerVehicle:AddEnemy(object)
            end

			if object.PursuitBreakerActive then
				local driver = car.UnitVehicle or car.TrafficVehicle
                    
				if driver then
					UVPlayerWreck(car)
					return
				end	
			end

			if car.DecentVehicle or car.TrafficVehicle or object.rammed then
				UVRamVehicle(car)
			end

			if car.grappleron and object.UVWanted then --Grappler
				UVGrapple(car, object)
			end

			if car.juggernauton and not object:IsWorld() then --Juggernaut
				local ourOldVel = coldata.OurOldVelocity
				local ourOldAngVel = coldata.OurOldAngularVelocity
				local objectPhys = object:GetPhysicsObject()
				local Phys = car:GetPhysicsObject()
				local force = car:GetVelocity():LengthSqr()

				local carPos = car:WorldSpaceCenter()
				local vectorDifference = object:WorldSpaceCenter() - carPos
				local angle = vectorDifference:Angle()

				objectPhys:ApplyForceCenter(angle:Forward()*force)

				--Preserve momentum
        		Phys:SetVelocity(ourOldVel)
				Phys:SetAngleVelocityInstantaneous(ourOldAngVel)

				local sounds = {
					"gadgets/juggernaut/impact_hard1.wav",
					"gadgets/juggernaut/impact_hard2.wav",
					"gadgets/juggernaut/impact_hard3.wav",
					"gadgets/juggernaut/impact_medium1.wav",
					"gadgets/juggernaut/impact_medium2.wav",
					"gadgets/juggernaut/impact_medium3.wav",
					"gadgets/juggernaut/impact_soft1.wav",
					"gadgets/juggernaut/impact_soft2.wav",
					"gadgets/juggernaut/impact_soft3.wav",
				}
				
				if not car.juggernauthit then
					car.juggernauthit = true
					car:EmitSound(sounds[math.random(1, #sounds)])
					timer.Simple(1, function()
						if IsValid(car) then
							car.juggernauthit = nil
						end
					end)
				end
			end

			if car.esfon and (object:IsVehicle() or object.LVS) and not (object.UnitVehicle and car.UnitVehicle) then --ESF

				if not object.UnitVehicle and not car.UnitVehicle then
					if not RacerFriendlyFire:GetBool() then return end
				end

				local enemyVehicle = object

				local enemyDriver = UVGetDriver(enemyVehicle)
				local power
				local damage
				if car.UnitVehicle then
					power = UVUnitPTESFPower:GetInt()
					damage = UVUnitPTESFDamage:GetFloat()
					if UVIsPTUpgraded(car) then
						power = power * 2
						damage = damage * 2
					end
				else
					power = UVPTESFPower:GetInt()
					damage = UVPTESFDamage:GetFloat()
				end

				local carPos = car:WorldSpaceCenter()
				local enemyVehiclePhys = enemyVehicle:GetPhysicsObject()
				local vectorDifference = enemyVehicle:WorldSpaceCenter() - carPos
				local angle = vectorDifference:Angle()
				local force = power * (1 - (vectorDifference:Length()/1000))

				enemyVehiclePhys:ApplyForceCenter(angle:Forward()*force)
				UVRamVehicle(enemyVehicle)

				if object.UnitVehicle or (object.UVWanted and not AutoHealth:GetBool()) or not (object.UnitVehicle and object.UVWanted) then
					damage = (table.HasValue(UVCommanders, object) and UVPTESFCommanderDamage:GetFloat()) or damage
					UVDamage(object, damage)
				end

				ReportPTEvent( car, enemyVehicle, 'ESF', 'Hit' )

				local e = EffectData()
				e:SetEntity(enemyVehicle)
				util.Effect("entity_remove", e)
				enemyVehicle:EmitSound("gadgets/esf/impact.wav")
				car.uvesfhit = true
				UVDeactivateESF(car)
				if car.UnitVehicle then
					UVChatterESFHit(car.UnitVehicle)
				end

			end
			if car.UVWanted then --SUSPECT
				local scope = UVGetScope(car)
				if object:IsWorld() or object.DecentVehicle or object.TrafficVehicle then --Crashed into world
					if dmg >= 100 and (scope and not scope.EnemyEscaping) and UVTargeting then
						if object:IsWorld() then
							if Chatter:GetBool() and UVTargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
								local units = ents.FindByClass("npc_uv*")
								local random_entry = math.random(#units)	
								local unit = units[random_entry]
								if IsValid(unit.e) and car == unit.e then
									UVChatterEnemyCrashed(unit) 
								end
							end
						elseif object.DecentVehicle or object.TrafficVehicle then
							if Chatter:GetBool() and UVTargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
								local units = ents.FindByClass("npc_uv*")
								local random_entry = math.random(#units)	
								local unit = units[random_entry]
								if IsValid(unit.e) and car == unit.e then
									if object.Sockets and next(object.Sockets) ~= nil then
										UVChatterHitTrafficSemi(unit)
									else
										UVChatterHitTraffic(unit)
									end
								end
							end
						end
					end
				end
				if object.UVRoadblock and not object.UVRoadblock.RoadBlockHit then --Crashed into roadblock
					object.UVRoadblock.RoadBlockHit = true

					local driver = UVGetDriver(car)
					if driver and ourOldVel > ActionCamRoadblockThreshold:GetInt() then
						UVActionCam(driver, "Roadblock")
					end

					if Chatter:GetBool() and UVTargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)	
						local unit = units[random_entry]
						if IsValid(unit.e) and car == unit.e then
							UVChatterRoadblockHit(unit) 
						end
					end
				end
			elseif car.UnitVehicle then --UNIT NPC
				local driver = UVGetDriver(car)
				local NPC = ((IsValid(driver) and driver) or car.UnitVehicle)--car.UnitVehicle
				if NPC and (NPC:IsNPC() or NPC:IsPlayer()) then
					if (not UVTargeting and UVPassConVarFilter(object) or UVTargeting and object.UVWanted) then
						UVRamVehicle(car)
					end

					if coldata.TheirOldVelocity:Length() > ourOldVel then
						UVAddInfraction(object, 'rampolice', true)
					end

					if object.UVWanted and not car.tagged then
						car.tagged = true
						UVTags = UVTags + 1
						local scope = UVGetScope(object)
						if scope then
							scope.Tags = scope.Tags + 1
						end
						hook.Run( "UV_Event", "onUnitTagged", object, car )
						if car.rhino and not car.rhinohit then
							car.rhinohit = true
							if Chatter:GetBool() and UVTargeting and not NPC:IsPlayer() and not car.roadblocking and not car.disperse then
								UVSoundChatter(NPC, NPC.voice, "rhinohit", 1)
							end
						end
					end

					if dmg >= 100 and object.UVWanted then
						if Chatter:GetBool() then
							if coldata.TheirOldVelocity:Length() > ourOldVel then
								if not NPC:IsPlayer() then
									UVChatterRammed(NPC)
								end
								UVDeactivateKillSwitch(car)
							else
								if not NPC:IsPlayer() then
									UVChatterRammedEnemy(NPC)
								end
							end
						end
						if not NPC.ramming and not NPC:IsPlayer() then
							NPC.ramming = true
							NPC:SetHorn(true)
						end
						timer.Simple(math.random(1,5), function()
							if NPC and not NPC:IsPlayer() then
								if NPC.ramming then
									NPC.ramming = nil
									NPC:SetHorn(false)
									NPC:ChangeELSSiren()
								end
							end
						end)
					end
				end
				if (NPC and NPC:IsPlayer()) and not UVTargeting and not UVEnemyEscaped and not UVEnemyBusted and table.HasValue(UVPotentialSuspects, object) then
					UVTargeting = true
				end
				if dmg >= 100 and NPC:IsNPC() then
					NPC.emergencystop = true
				end
			elseif car.TrafficVehicle then --TRAFFIC
				if dmg >= 100 then
					if IsValid(car.TrafficVehicle) then
						car.TrafficVehicle.emergencystop = true
					end
				end
			end
			if not object.UnitVehicle and not object:IsWorld() then --CALL HANDLER
				if object:IsVehicle() then --Hit And Run
					UVAddInfraction(car, 'ram')
				elseif not object:IsPlayer() and not object:IsNPC() then --Damage to Property
					if object.PursuitBreaker then UVCallInitiate(car, 'property') end
					UVAddInfraction(car, 'property')
				end
			end
		end
	end
	
end)

--Vehicle Explosion
hook.Add( "EntityRemoved", "UVExplosionGlide", function( vehicle, fullUpdate )
	if ( fullUpdate ) then return end

	if vehicle.IsGlideVehicle and vehicle:GetChassisHealth() < 1 then
		if vehicle.UnitVehicle and not vehicle.wrecked then
			UVPlayerWreck(vehicle)
		end

		local occupied = IsValid(vehicle.DecentVehicle) or IsValid(vehicle.TrafficVehicle) or IsValid(vehicle.UnitVehicle) or vehicle.UVWanted or vehicle.wrecked

		if occupied then
			for _, v in pairs(UVWantedTableVehicle) do
				local dist = v:GetPos():Distance2DSqr(vehicle:GetPos())
				if dist < 1000000 then UVAddInfraction(v, 'homicide') end
			end
		end
	end
end )

hook.Add( "simfphysOnDestroyed", "UVExplosionSimfphys", function(vehicle, gib) 
	if vehicle.UnitVehicle and not vehicle.wrecked then
		UVPlayerWreck(vehicle)
	end

	local occupied = IsValid(vehicle.DecentVehicle) or IsValid(vehicle.TrafficVehicle) or IsValid(vehicle.UnitVehicle) or vehicle.UVWanted or vehicle.wrecked

	if occupied then
		for _, v in pairs(UVWantedTableVehicle) do
			local dist = v:GetPos():Distance2DSqr(vehicle:GetPos())
			if dist < 1000000 then UVAddInfraction(v, 'homicide') end
		end
	end
end)

hook.Add("VC_engineExploded", "UVExplosionVCMod", function(vehicle, silent)
	if vehicle.UnitVehicle and not vehicle.wrecked then
		UVPlayerWreck(vehicle)
	end

	local occupied = IsValid(vehicle.DecentVehicle) or IsValid(vehicle.TrafficVehicle) or IsValid(vehicle.UnitVehicle) or vehicle.UVWanted or vehicle.wrecked

	if occupied then
		for _, v in pairs(UVWantedTableVehicle) do
			local dist = v:GetPos():Distance2DSqr(vehicle:GetPos())
			if dist < 1000000 then UVAddInfraction(v, 'homicide') end
		end
	end
end)

--Run Over
hook.Add("PlayerDeath", "UVRunOverDeathPlayer", function(victim, inflictor, attacker)
    if IsValid(inflictor) and inflictor:IsVehicle() then
        UVAddInfraction(inflictor, 'homicide')
    end
end)

hook.Add("OnNPCKilled", "UVRunOverDeathPlayerNPC", function( npc, attacker, inflictor )
	if IsValid(inflictor) and inflictor:IsVehicle() then
        UVAddInfraction(inflictor, 'homicide')
    end
end)

function UVRamVehicle(vehicle)
	if vehicle.rammed then
		vehicle.rammed = nil
	end

	vehicle.rammed = true

	if math.random(0,10) == 1 then
		vehicle.honkwhenrammed = true
	end

	timer.Create("UVRamVehicle"..vehicle:EntIndex(), 3, 1, function() 
		if IsValid(vehicle) and not vehicle.wrecked then 
			vehicle.rammed = nil
			vehicle.honkwhenrammed = nil
		end 
	end)
end

function UVAddToWantedListVehicle(vehicle)
	if not vehicle:IsValid() then return end

	if not vehicle.UVWanted then
		vehicle.UVWanted = vehicle
	end

	local driver = UVGetDriver(vehicle)
	local scope = UVCreateScope(vehicle)
	
	if not table.HasValue(UVWantedTableVehicle, vehicle) then
		table.insert(UVWantedTableVehicle, vehicle)
		
		net.Start( "UV_AddWantedVehicle" )
		--net.WriteEntity( vehicle )
		net.WriteInt( vehicle:EntIndex(), 32 )
		net.WriteInt( vehicle:GetCreationID(), 32 )
		net.Broadcast()
		
		vehicle:CallOnRemove( "UVWantedVehicleRemoved", function(ent)
			if table.HasValue(UVWantedTableVehicle, ent) then
				table.RemoveByValue(UVWantedTableVehicle, ent)
			end
			
			net.Start( "UV_RemoveWantedVehicle" )
			net.WriteInt( ent:EntIndex(), 32 )
			net.WriteInt( ent:GetCreationID(), 32 )
			net.Broadcast()
		end)
	end
end

function UVApplyAutoHealth(vehicle)
	if not AutoHealth:GetBool() then return end
	if vehicle.LVS then
		vehicle.MaxHealth = math.huge
		vehicle:SetHP(math.huge)
		vehicle:GetEngine():SetMaxHP(math.huge)
		vehicle:GetEngine():SetHP(math.huge)
		return
	end
	if vehicle:GetClass() == "prop_vehicle_jeep" then
		if vcmod_main then
			vehicle:VC_repairFull_Admin()
			if not vehicle:VC_hasGodMode() then
				vehicle:VC_setGodMode(true)
			end
		else
			vehicle:SetMaxHealth(math.huge)
			vehicle:SetHealth(math.huge)
		end
	end
	if vehicle.IsSimfphyscar then
		vehicle.simfphysoldhealth = vehicle:GetMaxHealth()
		vehicle:SetBulletProofTires(true)
		vehicle:SetMaxHealth(math.huge)
		vehicle:SetCurHealth(math.huge)
		vehicle:SetOnFire( false )
		vehicle:SetOnSmoke( false )
		net.Start( "simfphys_lightsfixall" )
		net.WriteEntity( vehicle )
		net.Broadcast()
		
		net.Start( "uvrepairsimfphys" )
		net.WriteEntity( vehicle )
		net.Broadcast()
	end
	if vehicle.IsGlideVehicle then
		vehicle:SetChassisHealth(math.huge)
		vehicle:SetEngineHealth(math.huge)
		vehicle:UpdateHealthOutputs()
		vehicle.FallOnCollision = nil
		for k, v in pairs(vehicle.wheels) do
			if v.params then
				v.params.isBulletProof = true
			end
		end
	end
end

function UVGiveRacerPursuitTech(vehicle)
	if not RacerPursuitTech:GetBool() then return end

	local pttable = {
		"EMP",
		"ESF",
		"Power Play",
		"Repair Kit",
		"Spikestrip",
		"Juggernaut",
		"Ghost",
		"Jammer",
		"Shockwave",
		"Stunmine",
	}

	if not vehicle.PursuitTech then
		vehicle.PursuitTech = {}
		
		for i=1, 2, 1 do
			local selected_pt = pttable[math.random(#pttable)]
			table.remove(pttable, table.KeyFromValue(pttable, selected_pt))

			UVAddPursuitTech( vehicle, selected_pt, i, nil, nil )
			
			-- local sanitized_pt = string.lower(string.gsub(selected_pt, " ", ""))
			-- local sel_k, sel_v
			
			-- for k,v in pairs(vehicle.PursuitTech) do
			-- 	if v.Tech == selected_pt then
			-- 		sel_k, sel_v = k, v
			-- 		vehicle.PursuitTech[k] = nil
			-- 		break
			-- 	end
			-- end
			
			-- local ammo_count = GetConVar("uvpursuittech_" .. sanitized_pt .. "_maxammo"):GetInt()
			-- ammo_count = ammo_count > 0 and ammo_count or math.huge
			
			-- vehicle.PursuitTech[i] = {
			-- 	Tech = selected_pt,
			-- 	Ammo = ammo_count,
			-- 	Cooldown = GetConVar("uvpursuittech_" .. sanitized_pt .. "_cooldown"):GetInt(),
			-- 	LastUsed = -math.huge,
			-- }
		end
		
		table.insert(UVRVWithPursuitTech, vehicle)
		
		vehicle:CallOnRemove( "UVRVWithPursuitTechRemoved", function(car)
			if table.HasValue(UVRVWithPursuitTech, car) then
				table.RemoveByValue(UVRVWithPursuitTech, car)
			end
		end)

		-- timer.Simple(1, function()
		-- 	for i=1,2 do
		-- 		UVReplicatePT( vehicle, i )
		-- 	end
		-- end)
	end
end

local MUTATOR_FUNCTIONS = {
	['Multiply'] = function( baseValue, multiplier, info ) 
		return math.Clamp( baseValue * ( multiplier * ( multiplier == 1 and 1 or info.Modifier ) ), info.Min or 0, info.Max or math.huge )
	end,
	['Static'] = function( baseValue, multiplier, info ) 
		return multiplier <= info.Max and baseValue or info.Modifier
	end,
	['ModifierComparison'] = function( baseValue, multiplier, info ) 
		return baseValue * ( multiplier > info.Modifier and info.Max or info.Min )
	end
}

local POLICE_VEHICLE_BASE_PERFORMANCE_SETS = {
	['Simfphys'] = {
		['Efficiency'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['MaxTraction'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['BrakePower'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1,
				['Min'] = 0,
				['Max'] = math.huge
			}
		}
	},
	['Glide'] = {
		['BrakePower'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		-- Note: The cornering accuracy of the AI on Glide heavily depends on SteerConeMaxAngle, this also applies for units
		-- originally i only kept SteerConeChangeRate for Infmap use, comment out again if not plausible -aux
		-- ['SteerConeChangeRate'] = {
		-- 	['DataType'] = "NetworkVar",
		-- 	['IsCatchup'] = true,
		-- 	['Info'] = {
		-- 		['Type'] = "Multiply",
		-- 		['Modifier'] = 1.25,
		-- 		['Min'] = 0,
		-- 		['Max'] = math.huge
		-- 	}
		-- },
		-- ['SteerConeMaxSpeed'] = {
		-- 	['DataType'] = "NetworkVar",
		-- 	['IsUnit'] = true,
		-- 	['Info'] = {
		-- 		['Type'] = "Multiply",
		-- 		['Modifier'] = 1,
		-- 		['Min'] = 0,
		-- 		['Max'] = math.huge
		-- 	}
		-- },
		['SteerConeMaxAngle'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1.25,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['MaxRPM'] = {
			['DataType'] = "NetworkVar",
			['IsCatchup'] = true,
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 0.75,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['MaxRPMTorque'] = {
			--['IsUnit'] = true,
			['IsCatchup'] = true,
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 0.75,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['MinRPMTorque'] = {
			--['IsUnit'] = true,
			['IsCatchup'] = true,
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 0.75,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['ForwardTractionMax'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 2,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['SideTractionMax'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['SideTractionMaxAng'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['SideTractionMin'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['SuspensionLength'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "ModifierComparison",
				['Modifier'] = 1,
				['Min'] = 1,
				['Max'] = 0.75
			}
		},
		['SpringStrength'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "ModifierComparison",
				['Modifier'] = 1,
				['Min'] = 1,
				['Max'] = 1.25
			}
		},
		['SpringDamper'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "ModifierComparison",
				['Modifier'] = 1,
				['Min'] = 1,
				['Max'] = 1.5
			}
		},
		-- ['PowerDistribution'] = {
		-- 	['DataType'] = "NetworkVar",
		-- 	['IsUnit'] = true,
		-- 	['IsCatchup'] = true,
		-- 	['Info'] = {
		-- 		['Type'] = "Static",
		-- 		['Modifier'] = 0.1,
		-- 		['Min'] = 1,
		-- 		['Max'] = 1.2,
		-- 	}
		-- },
	},
	['prop_vehicle_jeep'] = {

	}
}

local RACER_VEHICLE_BASE_PERFORMANCE_SETS = {
	['Simfphys'] = {
		['Efficiency'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['MaxTraction'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['BrakePower'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1,
				['Min'] = 0,
				['Max'] = math.huge
			}
		}
	},
	['Glide'] = {
		['BrakePower'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		-- Note: The cornering accuracy of the AI on Glide heavily depends on SteerConeMaxAngle, this also applies for units
		-- originally i only kept SteerConeChangeRate for Infmap use, comment out again if not plausible -aux
		['SteerConeChangeRate'] = {
			['DataType'] = "NetworkVar",
			['IsCatchup'] = true,
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1.25,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		-- ['SteerConeMaxSpeed'] = {
		-- 	['DataType'] = "NetworkVar",
		-- 	['IsUnit'] = true,
		-- 	['Info'] = {
		-- 		['Type'] = "Multiply",
		-- 		['Modifier'] = 1,
		-- 		['Min'] = 0,
		-- 		['Max'] = math.huge
		-- 	}
		-- },
		['SteerConeMaxAngle'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1.25,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['MaxRPM'] = {
			['DataType'] = "NetworkVar",
			['IsCatchup'] = true,
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 0.75,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['MaxRPMTorque'] = {
			--['IsUnit'] = true,
			['IsCatchup'] = true,
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 0.75,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['MinRPMTorque'] = {
			--['IsUnit'] = true,
			['IsCatchup'] = true,
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 0.75,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['ForwardTractionMax'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 2,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['SideTractionMax'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['SideTractionMaxAng'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['SideTractionMin'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "Multiply",
				['Modifier'] = 1,
				['Min'] = 0,
				['Max'] = math.huge
			}
		},
		['SuspensionLength'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "ModifierComparison",
				['Modifier'] = 1,
				['Min'] = 1,
				['Max'] = 0.75
			}
		},
		['SpringStrength'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "ModifierComparison",
				['Modifier'] = 1,
				['Min'] = 1,
				['Max'] = 1.25
			}
		},
		['SpringDamper'] = {
			['DataType'] = "NetworkVar",
			['Info'] = {
				['Type'] = "ModifierComparison",
				['Modifier'] = 1,
				['Min'] = 1,
				['Max'] = 1.5
			}
		},
		['PowerDistribution'] = {
			['DataType'] = "NetworkVar",
			['IsCatchup'] = true,
			['Info'] = {
				['Type'] = "Static",
				['Modifier'] = 0.1,
				['Min'] = 1,
				['Max'] = 1.2,
			}
		},
	},
	['prop_vehicle_jeep'] = {

	}
}


function UVSetVehiclePerformanceMultiplier( vehicle, mult, catchup )
	mult = tonumber(mult) or 1

	local isSimfphysVehicle = vehicle.IsSimfphyscar
	local isGlideVehicle = vehicle.IsGlideVehicle

	local performanceSets = vehicle.UnitVehicle and POLICE_VEHICLE_BASE_PERFORMANCE_SETS or RACER_VEHICLE_BASE_PERFORMANCE_SETS
	local needle = nil

	if vehicle.IsSimfphyscar then
		needle = performanceSets['Simfphys']
	elseif vehicle.IsGlideVehicle then
		needle = performanceSets['Glide']
	else
		needle = performanceSets['prop_vehicle_jeep']
	end

	if not vehicle.__UVOriginalPerformance then vehicle.__UVOriginalPerformance = {} end

	for stat, data in pairs( needle ) do
		local multiplier = mult
		if mult > 1 then
			if data.IsCatchup and not catchup then multiplier = 1 end
		end
		if data.DataType == "NetworkVar" then
			local getFunc = vehicle['Get'..stat]
			local setFunc = vehicle['Set'..stat]

			if isfunction( getFunc ) and isfunction( setFunc ) then
				if not vehicle.__UVOriginalPerformance[stat] then vehicle.__UVOriginalPerformance[stat] = getFunc() end
				setFunc( vehicle, MUTATOR_FUNCTIONS[data.Info.Type](
					vehicle.__UVOriginalPerformance[stat], 
					multiplier, 
					data.Info
				) )
			end
		end
	end

	if isGlideVehicle then
		vehicle:UpdateWheelParameters()
		vehicle:UpdatePowerDistribution()
	end
end

function UVIsSeenByUnit(vehicle)
	local units = UVUnitVehicles
	local airUnits = ents.FindByClass("uvair")

	local vScope = UVGetScope(vehicle)
	local visualrange = (vScope and (vScope.Hiding or (not vScope.InPursuit and UVCheckIfHiding(vehicle)))) and 1000000 or 25000000

	for w, _ in pairs(units) do
		if not IsValid(w) then continue end
		local withinRange = w:GetPos():DistToSqr(vehicle:GetPos()) < visualrange
		if not withinRange then continue end

		local seen = UVVisualOnTarget(w, vehicle)

		if seen then
			return true
		end
	end

	for _, w in pairs(airUnits) do
		if not IsValid(w) then continue end
		local withinRange = w:GetPos():DistToSqr(vehicle:GetPos()) < visualrange
		if not withinRange then continue end

		local seen = UVVisualOnTarget(w, vehicle)
		if seen then
			return true
		end
	end

	return false
end

--[[
	/// INFRACTIONS LIST ///
	'speed' = Speeding (reach 10+ MPH over the limit set by the closest DV waypoint or unitvehicle_speedlimit, whichever is lower)
	'veryspeed' = Excessive Speeding (reach 50+ MPH over the limit set by the closest DV waypoint or unitvehicle_speedlimit, whichever is lower)
	'reckless' = Reckless Driving (reach 100+ MPH over the limit set by the closest DV waypoint or unitvehicle_speedlimit, whichever is lower)
	'assault' = Ramming a Police Vehicle (hit a Unit)
	'ram' = Hit & Run (hit a Traffic)
	'property' = Damage to Property (hit a non-vehicle entity)
	'resist' = Resisting Arrest (enter cooldown)
	'offroad' = Driving off Roadway (drive on a non-road surface)
	'streetrace' = Street Racing (commit an infraction while in a race event)
	'resource' = Overuse of Resources (trigger the backup timer)
	'endanger' = Public Endangerment (use a Pursuit Tech/cause a Traffic vehicle to swerve out of your way)
	'homicide' = Vehicular Homicide (cause a vehicle to explode/run over a pedestrian)

	*you must be seen by the Unit or be reported by a witness for an infraction to be counted, except for Resisting Arrest and Overuse of Resources
	*infractions can be repeated and counted for calculating fines, but only inform the client if they have commited a NEW one
]]

--[[
	Fine Due = INFRACTION_FINE * UVHeatLevel
]]
UVINFRACTION_FINE = {
	['speed'] = 150,
	['veryspeed'] = 350,
	['reckless'] = 1000,
	['rampolice'] = 350,
	['ram'] = 300,
	['property'] = 100,
	['resist'] = 300,
	['offroad'] = 50,
	['streetrace'] = 5000,
	['resource'] = 100,
	['endanger'] = 200,
	['homicide'] = 10000,
}

local PRE_INFRACTION_COUNT = {
	['speed'] = 1,
	['veryspeed'] = 2,
	['reckless'] = 3,
	['rampolice'] = 4,
	['ram'] = 3,
	['property'] = 1,
	['resist'] = 2,
	['offroad'] = 1,
	['streetrace'] = 5,
	['resource'] = 1,
	['endanger'] = 2,
	['homicide'] = 10,
}

local INFRACTION_COOLDOWN = {
	['speed'] = 10,
	['veryspeed'] = 10,
	['reckless'] = 10,
	['rampolice'] = 10,
	['ram'] = 10,
	['property'] = 10,
	['resist'] = 10,
	['offroad'] = 10,
	['streetrace'] = 10,
	['resource'] = 10,
	['endanger'] = 10,
	['homicide'] = 0,
}

local function updatepreinfraction(vehicle, infraction)
	local ctimeout = 3

	if CurTime() > UVPreInfractionCountCooldown + ctimeout then
		UVPreInfractionCount = UVPreInfractionCount + (PRE_INFRACTION_COUNT[infraction] or 1)

		if UVPreInfractionCount >= 10 and UVPassConVarFilter(vehicle) and isfunction(UVCallInitiate) then
			UVCallInitiate(vehicle, infraction)
		end

		UVPreInfractionCountCooldown = CurTime()
	end
end

local function updateinfraction(vehicle, infraction)
	if not vehicle.InfractionCooldown then 
		vehicle.InfractionCooldown = {}
	elseif vehicle.InfractionCooldown[infraction] and CurTime() - vehicle.InfractionCooldown[infraction] < INFRACTION_COOLDOWN[infraction] then
		return
	end

	vehicle.InfractionCooldown[infraction] = CurTime()

    if vehicle.Infractions[infraction] then
        vehicle.Infractions[infraction] = vehicle.Infractions[infraction] + 1
    else
        vehicle.Infractions[infraction] = 1
		
		local number = table.Count(vehicle.Infractions)
		local driver = UVGetDriver(vehicle)

		if driver and driver:IsPlayer() then
			net.Start('UVInfractions')
				net.WriteString(infraction)
				net.WriteInt(number, 5)
			net.Send(driver)
		end
    end

	local scope = UVGetScope(vehicle)
	if not scope then return end

	for k, v in pairs(vehicle.Infractions) do
		scope.FinesDue = scope.FinesDue + (UVINFRACTION_FINE[k] or 0) * (UVHeatLevel / 10)
	end
end

function UVClearInfractions(vehicle)
	vehicle.Infractions = {}
	vehicle.InfractionCooldown = {}
end

function UVAddInfraction(vehicle, infraction, reported)
	if not infraction or not IsValid(vehicle) or not UVPassConVarFilter(vehicle) then return end
	
	if not reported and not UVIsSeenByUnit(vehicle) then --Pre Infraction system
		updatepreinfraction(vehicle, infraction)
		return
	end

	UVAddToWantedListVehicle(vehicle)

	if not vehicle.Infractions then vehicle.Infractions = {} end

	if infraction == 'reckless' then
		updateinfraction(vehicle, 'speed')
		updateinfraction(vehicle, 'veryspeed')
    elseif infraction == 'veryspeed' then
        updateinfraction(vehicle, 'speed')
    end

	updateinfraction(vehicle, infraction)

	if UVRaceTable and UVRaceTable['Participants'] and UVRaceTable['Participants'][vehicle] then
        updateinfraction(vehicle, 'streetrace')
    end

	return true
end

function UVGetIfSomeoneDriving()
	for k, v in pairs(player.GetAll()) do
		if IsValid(v) and v:InVehicle() then
			return true
		end
	end
	return false
end

function UVAddUnit(vehicle, ply)
	timer.Simple( 0.1, function()
		if not vehicle then return end
		
		net.Start("UVHUDAddUV")
		net.WriteInt(vehicle:EntIndex(), 32)
		net.WriteInt(vehicle:GetCreationID(), 32)
		net.WriteString("unit")
		net.Broadcast()
	end)

	if ply then
		vehicle.UnitVehicle = ply
		vehicle.callsign = ply:Nick()
	end

	UVUnitVehicles[vehicle] = vehicle
	
	if vehicle.IsSimfphyscar then
		vehicle:SetBulletProofTires(true)
	end
	if vehicle:GetClass() == "prop_vehicle_jeep" then
		local mass = vehicle:GetPhysicsObject():GetMass()
		vehicle:SetMaxHealth(mass)
		vehicle:SetHealth(mass)
	end
	if vehicle.IsGlideVehicle then
		for k, v in pairs(vehicle.wheels) do
			if v.params then
				v.params.isBulletProof = true
			end
		end
	end
end

local FormationVectors = {
    -- Far Front
    ["Front Front Front"]            = Vector(0, 900, 0),

    -- Mid Front
    ["Front Front"]                  = Vector(0, 600, 0),
    ["Left Front Front"]             = Vector(-200, 600, 0),
    ["Right Front Front"]            = Vector(200, 600, 0),

    -- Near Front
    ["Front"]                        = Vector(0, 300, 0),
    ["Left Front"]                   = Vector(-200, 300, 0),
    ["Right Front"]                  = Vector(200, 300, 0),
    ["Left Left Front"]              = Vector(-400, 300, 0),
    ["Right Right Front"]            = Vector(400, 300, 0),

    -- Sides
    ["Left"]                         = Vector(-200, 0, 0),
    ["Right"]                        = Vector(200, 0, 0),

    -- Near Rear
    ["Rear"]                         = Vector(0, -300, 0),
    ["Left Rear"]                    = Vector(-200, -300, 0),
    ["Right Rear"]                   = Vector(200, -300, 0),
    ["Left Left Rear"]               = Vector(-400, -300, 0),
    ["Right Right Rear"]             = Vector(400, -300, 0),

    -- Mid Rear
    ["Rear Rear"]                    = Vector(0, -600, 0),
    ["Left Rear Rear"]               = Vector(-200, -600, 0),
    ["Right Rear Rear"]              = Vector(200, -600, 0),
	["Left Left Rear Rear"] 		 = Vector(-400, -600, 0),
	["Right Right Rear Rear"]        = Vector(400, -600, 0),

    -- Far Rear
    ["Rear Rear Rear"]               = Vector(0, -900, 0),
    ["Left Left Rear Rear Rear"]     = Vector(-400, -900, 0),
    ["Right Right Rear Rear Rear"]   = Vector(400, -900, 0),
}

UVGlobalStrategy = {
	["None"] = {
		["None"] = {}
	},
	["Passive"] = {
		["Follow Left"] = {
			"Rear",
			"Left Rear",
			"Right Rear"
		},
		["Follow Right"] = {
			"Rear",
			"Right Rear",
			"Left Rear"
		},
		["Herd Left"] = {
			"Rear",
			"Left",
			"Right"
		},
		["Herd Right"] = {
			"Rear",
			"Left",
			"Right"
		},
		["Diagonal Left"] = {
			"Left Rear",
			"Right Rear",
			"Left Front",
			"Right Front"
		},
		["Diagonal Right"] = {
			"Right Rear",
			"Left Rear",
			"Right Front",
			"Left Front"
		},
		["Triangle Left"] = {
			"Front Front",
			"Left Rear",
			"Right Rear",
		},
		["Triangle Right"] = {
			"Front Front",
			"Right Rear",
			"Left Rear"
		},
		["Reverse Triangle Left"] = {
			"Left Front Front",
			"Right Front Front",
			"Rear"
		},
		["Reverse Triangle Right"] = {
			"Right Front Front",
			"Left Front Front",
			"Rear"
		}
	},
	["Aggressive"] = {
		["Box Left"] = {
			"Front",
			"Rear",
			"Left",
			"Right",
			"Left Front",
			"Right Front",
			"Left Rear",
			"Right Rear",
		},
		["Box Right"] = {
			"Front",
			"Rear",
			"Right",
			"Left",
			"Right Front",
			"Left Front",
			"Right Rear",
			"Left Rear"
		},
		["Rolling Roadblock Left"] = {
			"Front",
			"Rear",
			"Left Front",
			"Right Front",
			"Left Left Front",
			"Right Right Front",
			"Left Rear",
			"Right Rear",
			"Left Left Rear",
			"Right Right Rear"
		},
		["Rolling Roadblock Right"] = {
			"Front",
			"Rear",
			"Right Front",
			"Left Front",
			"Right Right Front",
			"Left Left Front",
			"Right Rear",
			"Left Rear",
			"Right Right Rear",
			"Left Left Rear"
		},
		["Spearhead Left"] = {
			"Front Front",
			"Rear Rear",
			"Left Front",
			"Right Front",
			"Left Left",
			"Right Right",
			"Left Rear",
			"Right Rear",
			"Left Left Rear Rear",
			"Right Right Rear Rear"
		},
		["Spearhead Right"] = {
			"Front Front",
			"Rear Rear",
			"Right Front",
			"Left Front",
			"Right Right",
			"Left Left",
			"Right Rear",
			"Left Rear",
			"Right Right Rear Rear",
			"Left Left Rear Rear"
		}
	}
}

UVCurrentStrategy = "None"
UVCurrentFormation = "None"
UVCurrentFormationPoints = {}

local function ChangeFormation( strategy, formation )
	UVCurrentStrategy = strategy
	UVCurrentFormation = formation
	UVCurrentFormationPoints = UVGlobalStrategy[strategy][formation]

	if next(UVUnitsChasing) == nil then return end
	local randomunit = UVUnitsChasing[math.random(1, #UVUnitsChasing)]
	local chatter = UVCurrentStrategy == "Aggressive" and UVChatterAggressive(randomunit) or UVChatterPassive(randomunit) 
end

function UVUpdateGlobalStrategy()
    if next(UVUnitsChasing) == nil then return end

	local strategyoptions = {
		["Aggressive"] = 0,
		["Passive"] = 0
	}

	--More aggressive units will make the strategy aggressive, and vice versa
	for k, v in pairs(UVUnitsChasing) do
		if v.aggressive then
			strategyoptions["Aggressive"] = strategyoptions["Aggressive"] + 1
		else
			strategyoptions["Passive"] = strategyoptions["Passive"] + 1
		end
	end

	local currentStrategy = strategyoptions["Aggressive"] > strategyoptions["Passive"] and "Aggressive" or "Passive"

	--Clear existing formations
    local AvailableUnits = {}
    for k, v in pairs(UVUnitsChasing) do
        if v.formationpoint then
            v.formationpoint = nil
        end
        table.insert(AvailableUnits, v)
    end

	local currentFormationPoints, currentFormation = table.Random(UVGlobalStrategy[currentStrategy])

	if math.random(1, 10) == 1 then
		ChangeFormation(currentStrategy, currentFormation)
	end

    if UVCurrentFormationPoints and next(UVCurrentFormationPoints) ~= nil then
        local centerPos = Vector(0, 0, 0)
        local centerYaw = 0
        local validCount = 0

        for i = 1, #AvailableUnits do
            local unit = AvailableUnits[i]
            if unit.e and unit.e:IsValid() then
                centerPos = centerPos + unit.e:GetPos()
                validCount = validCount + 1
                
                if centerYaw == 0 then
                    if unit.e.IsSimfphyscar and unit.e.VehicleData and unit.e.VehicleData.LocalAngForward then
                        centerYaw = unit.e.VehicleData.LocalAngForward.y - 90
                    elseif unit.e.GetForward then
                        centerYaw = unit.e:GetForward().y - 90
                    end
                end
            end
        end

        if validCount > 0 then
            centerPos = centerPos / validCount
        end
        local centerAng = Angle(0, centerYaw, 0)

        local mappedPoints = {}
        for i = 1, #UVCurrentFormationPoints do
            local localPt = FormationVectors[UVCurrentFormationPoints[i]] or vector_origin
            local worldPt = Vector(localPt.x, localPt.y, localPt.z)
            worldPt:Rotate(centerAng)
            worldPt = centerPos + worldPt
            
            mappedPoints[i] = {
                localPt = localPt,
                worldPt = worldPt
            }
        end

        for i = 1, #mappedPoints do
            if #AvailableUnits == 0 then break end

            local ptData = mappedPoints[i]
            local worldPt = ptData.worldPt
            local localPt = ptData.localPt

            local closestUnitIdx = -1
            local closestDist = math.huge
            local closestUnit = nil

            for j = 1, #AvailableUnits do
                local unit = AvailableUnits[j]
                if unit.e and unit.e:IsValid() then
                    local distSqr = unit.e:GetPos():DistToSqr(worldPt)
                    if distSqr < closestDist then
                        closestDist = distSqr
                        closestUnitIdx = j
                        closestUnit = unit
                    end
                end
            end

            if closestUnit then
                local finalPoint = Vector(localPt.x, localPt.y, localPt.z)

                if closestUnit.e then
                    if closestUnit.e.IsSimfphyscar and closestUnit.e.VehicleData and closestUnit.e.VehicleData.LocalAngForward then
                        finalPoint:Rotate(Angle(0, (closestUnit.e.VehicleData.LocalAngForward.y - 90), 0))
                    elseif closestUnit.e.IsGlideVehicle and closestUnit.e.GetForward then
                        finalPoint:Rotate(Angle(0, (closestUnit.e:GetForward().y - 90), 0))
                    end
                end

                closestUnit.formationpoint = finalPoint

                local lastIdx = #AvailableUnits
                if closestUnitIdx ~= lastIdx then
                    AvailableUnits[closestUnitIdx] = AvailableUnits[lastIdx]
                end
                AvailableUnits[lastIdx] = nil
            end
        end
    end
end

function UVEndTrafficStop( target )
	local targetScope = UVGetScope(target)
	if not targetScope or not targetScope.IsBeingPulledOver then return end

	targetScope.IsBeingPulledOver = false

	if target.TargetingUnit then
		target.TargetingUnit.TargetingVehicle = nil
		target.TargetingUnit = nil
	end

	target.TrafficStopTimeout = nil
end

function UVInitiateTrafficStop( unit, target )
	local targetScope = UVGetScope(target)
	if not targetScope or targetScope.IsBeingPulledOver or targetScope.InPursuit then return end

	targetScope.IsBeingPulledOver = true

	local targetOccupants = UVGetVehicleOccupants(target)
	local unitOccupants = UVGetVehicleOccupants(unit) 

	table.Add( targetOccupants, unitOccupants )

	net.Start( "UVPullOver" )
	net.Send( targetOccupants )

	target.TargetingUnit = unit
	target.TrafficStopTimeout = 10
	unit.TargetingVehicle = target
end

function UVBustEnemy(self, enemy, finearrest)
	if not IsValid(self) or not IsValid(enemy) or (enemy.uvbusted and not finearrest) then return end

	local callsign = self:IsPlayer() and self:Nick() or ( self.callsign or "uv.unitvehicles" )

	enemy.uvbusted = true
	enemy.UVBustingProgress = 0
	enemy.UVBustingPenaltyMult = enemy.UVBustingPenaltyMult or 1
	
	-- if UVRaceTable['Participants'] then
	-- 	if UVRaceTable['Participants'][enemy] then
	-- 		UVRaceTable['Participants'][enemy].Busted = true
	-- 	end
	-- end
	if enemy.UVWanted then
		enemy.UVWanted = nil
	end

	if table.HasValue(UVWantedTableVehicle, enemy) then
		table.RemoveByValue(UVWantedTableVehicle, enemy)
	end

	net.Start( "UV_RemoveWantedVehicle" )
	net.WriteInt( enemy:EntIndex(), 32 )
	net.WriteInt( enemy:GetCreationID(), 32 )
	net.Broadcast()

	local timeacknowledge = 5
	local enemyDriver = UVGetDriver(enemy)

	local enemyScope = UVGetScope(enemy)
	if not enemyScope then return end
	
	if enemyScope.InPursuit or self.UVAir or finearrest then --Arrest
		if table.HasValue(UVPotentialSuspects, enemy) then
			table.RemoveByValue(UVPotentialSuspects, enemy)
		end

		local e = UVGetVehicleMakeAndModel(enemy)
		if Chatter:GetBool() then
			if finearrest then
				net.Start( "UVFineArrest" )
				net.Send(IsValid(enemyDriver) and enemyDriver or {})
				timeacknowledge = UVChatterFineArrest(self) or 5
			else
				timeacknowledge = UVChatterArrest(self) or 5
			end
		end

		UVRelaySoundToClients("ui/pursuit/busted.wav", false)
		if IsValid(enemyDriver) and enemyDriver:IsPlayer() then
			net.Start('UVBusted')
			net.WriteTable({
				['Racer'] = enemyDriver:GetName(),
				['Cop'] = callsign
			})
			net.Broadcast()
		else
			net.Start('UVBusted')
			net.WriteTable({
				['Racer'] = enemy.racer or "Racer "..enemy:EntIndex(),
				['Cop'] = callsign
			})
			net.Broadcast()
		end
		local v = EffectData()
		v:SetEntity(enemy)
		util.Effect("phys_freeze", v)

		UVPlayerWreck(enemy)

		timer.Simple(timeacknowledge, function()
			if Chatter:GetBool() and IsValid(self) then
				if not self.UVAir then
					UVChatterArrestAcknowledge(self)
				else
					UVChatterArrestAcknowledge(self)
				end
			end
		end)
		enemyScope.EnemyBusted = true
		timer.Simple(1, function()
			enemyScope.InPursuit = false
		end)
		--enemyScope.InPursuit = false
		enemyScope.EnemyEscaping = false
		enemyScope.InCooldown = false
		enemyScope.IsEvading = false
		if enemyDriver and enemyDriver:IsPlayer() and not enemy.DecentVehicle and not enemy.TrafficVehicle then
			local driver = enemyDriver
			local bustedtable = {}
			bustedtable["Unit"] = callsign
			bustedtable["Deploys"] = enemyScope and enemyScope.Deploys
			bustedtable["Wrecks"] = enemyScope and enemyScope.Wrecks
			bustedtable["Tags"] = enemyScope and enemyScope.Tags
			bustedtable["Bounty"] = enemyScope and string.Comma( enemyScope.Bounty )
			bustedtable["Roadblocks"] = UVRoadblocksDodged
			bustedtable["Spikestrips"] = UVSpikestripsDodged
			local infractionstable = enemy.Infractions or {}
			timer.Create('MakeArrest'..driver:EntIndex(), 3, 1, function()
				if not finearrest then
					net.Start( "UVHUDBustedDebrief" )
					net.WriteTable(bustedtable)
					net.WriteTable(infractionstable)
					net.WriteInt(enemyScope.FinesDue, 32)
					net.Send(driver)
				end
				UVRemoveScope(enemy)
				driver:KillSilent()
				driver:SetNoDraw(true)
				driver:Spectate(OBS_MODE_DEATHCAM)
				driver:SpectateEntity(driver)
				net.Start( "UVHUDStopBusting" )
				net.Send( UVGetVehicleOccupants(enemy) )
			end)
			net.Start( "UVHUDEnemyBusted" )
			net.Send(driver)
			if table.HasValue(UVWantedTableDriver, enemyDriver) then
				table.RemoveByValue(UVWantedTableDriver, enemyDriver)
			end
		end

		hook.Run( 'UV_Event', 'onSuspectBusted', enemy, self, finearrest )

		self.chasing = nil
		UVEnemyBusted = true
		if not enemyDriver then
			UVRemoveScope(enemy)
		end
		self.aggressive = nil
		timer.Simple(timeacknowledge, function()
			if #UVWantedTableVehicle == 0 then
				UVTargeting = nil
			end
			UVEnemyBusted = nil
		end)
		self.displaybusting = nil
	else --Fine
		local stoppedUnits = {}
		enemyScope.InPursuit = false
		enemyScope.EnemyEscaping = false
		enemyScope.IsEvading = false
		enemyScope.InCooldown = false
		enemy.UVHUDBusting = nil
		enemy.UVHUDBustingDelayed = nil
		UVEndTrafficStop( enemy )
		local occupants = UVGetVehicleOccupants( enemy )
		local e = UVGetVehicleMakeAndModel(enemy)
		if not enemy.UVFinedCount then
			enemy.UVFinedCount = 0
		end
		enemy.UVFinedCount = enemy.UVFinedCount + 1
		if enemy.UVFinedCount >= 3 then
			net.Start( "UVHUDStopBusting" )
			net.Send(occupants)
			UVBustEnemy(self, enemy, true)
			return
		end
		local busted = hook.Run( 'UV_Event', 'onSuspectFined', enemy, self, enemyScope.FinesDue )
		if busted then
			net.Start( "UVHUDStopBusting" )
			net.Send(occupants)
			UVBustEnemy(self, enemy, true)
			return
		end
		if Chatter:GetBool() and IsValid(self.v) then
			UVChatterFinePaid(self)
		end
		timer.Simple(0.01, function()
			--UVTargeting = nil
			--self.chasing = nil
			for k, v in pairs(ents.FindByClass("npc_uv*")) do
				if v.e == enemy then
					v.stopped = true
					stoppedUnits[v] = true
					-- v:ForgetEnemy()
				end
			end
			net.Start( "UVHUDStopBusting" )
			net.Send(occupants)
			net.Start( "UVHUDUpdateBusting" )
			net.WriteEntity(enemy)
			net.WriteFloat(0)
			net.Broadcast()
		end)
		local driver = (enemyDriver and enemyDriver:IsPlayer()) and enemyDriver or nil
		timer.Simple(0, function()				
			table.Add( occupants, (self and self:IsPlayer() and UVGetVehicleOccupants( UVGetVehicle( self ) )) or {} )
			net.Start( "UVFined" )
			net.WriteUInt( enemy.UVFinedCount, 2 )
			net.WriteUInt( enemyScope.FinesDue, 32 )
			net.Send(occupants)
			enemyScope.FinesDue = 0
			enemyScope.Bounty = 0
			enemyScope.Heat = 1
			enemyScope.TimeTillNextHeatEnd = 0
		end)
		if driver then
			driver:EmitSound("ui/pursuit/fined.wav", 0, 100, 0.5)
		end
		self.aggressive = nil
		timer.Simple(10, function()
			for k, v in pairs(stoppedUnits) do
				if k.stopped then k.stopped = nil end
				if IsValid(k) then
					k:ForgetEnemy()
				end
			end
			enemy.uvbusted = nil
		end)
	end

	if #UVWantedTableVehicle == 0 then
		for k, car in pairs(UVGetPlayerCops(true)) do
			UVSetELS(false, car)
			UVSetELSSound(false, car)
		end
	end

	--Clear record
	UVClearInfractions(enemy)

end

function UVDelayRoadblock()
	if UVRoadblockDelayed then return end
	UVRoadblockDelayed = true
	timer.Simple(0.5, function()
		UVRoadblockDelayed = false
	end)
end

local COLORS = {
	-- REDS
	{ name = 'red', article = 'a', color = Color(255, 0, 0) },
	{ name = 'red', article = 'a', color = Color(200, 0, 0) },
	{ name = 'red', article = 'a', color = Color(220, 20, 60) },
	{ name = 'red', article = 'a', color = Color(255, 69, 0) },

	-- BEIGES
	{ name = 'beige', article = 'a', color = Color(245, 245, 220) },
	{ name = 'beige', article = 'a', color = Color(222, 184, 135) },
	{ name = 'beige', article = 'a', color = Color(210, 180, 140) },

	-- BLACKS
	{ name = 'black', article = 'a', color = Color(0, 0, 0) },
	{ name = 'black', article = 'a', color = Color(30, 30, 30) },
	{ name = 'black', article = 'a', color = Color(50, 50, 50) },

	-- BLUES
	{ name = 'blue', article = 'a', color = Color(0, 0, 255) },
	{ name = 'blue', article = 'a', color = Color(0, 0, 200) },
	{ name = 'blue', article = 'a', color = Color(65, 105, 225) },
	{ name = 'blue', article = 'a', color = Color(70, 130, 180) },
	{ name = 'blue', article = 'a', color = Color(0, 191, 255) },

	-- BROWNS
	{ name = 'brown', article = 'a', color = Color(139, 69, 19) },
	{ name = 'brown', article = 'a', color = Color(160, 82, 45) },
	{ name = 'brown', article = 'a', color = Color(165, 42, 42) },
	{ name = 'brown', article = 'a', color = Color(210, 105, 30) },

	-- GOLDS
	{ name = 'gold', article = 'a', color = Color(255, 215, 0) },
	{ name = 'gold', article = 'a', color = Color(218, 165, 32) },
	{ name = 'gold', article = 'a', color = Color(184, 134, 11) },

	-- GREENS
	{ name = 'green', article = 'a', color = Color(0, 255, 0) },
	{ name = 'green', article = 'a', color = Color(0, 128, 0) },
	{ name = 'green', article = 'a', color = Color(34, 139, 34) },
	{ name = 'green', article = 'a', color = Color(50, 205, 50) },
	{ name = 'green', article = 'a', color = Color(60, 179, 113) },

	-- ORANGES
	{ name = 'orange', article = 'an', color = Color(255, 165, 0) },
	{ name = 'orange', article = 'an', color = Color(255, 140, 0) },
	{ name = 'orange', article = 'an', color = Color(255, 120, 0) },

	-- PINKS
	{ name = 'pink', article = 'a', color = Color(255, 192, 203) },
	{ name = 'pink', article = 'a', color = Color(255, 105, 180) },
	{ name = 'pink', article = 'a', color = Color(255, 182, 193) },

	-- PURPLES
	{ name = 'purple', article = 'a', color = Color(128, 0, 128) },
	{ name = 'purple', article = 'a', color = Color(148, 0, 211) },
	{ name = 'purple', article = 'a', color = Color(186, 85, 211) },

	-- SILVERS
	{ name = 'silver', article = 'a', color = Color(192, 192, 192) },
	{ name = 'silver', article = 'a', color = Color(169, 169, 169) },
	{ name = 'silver', article = 'a', color = Color(211, 211, 211) },

	-- WHITES
	{ name = 'white', article = 'a', color = Color(255, 255, 255) },
	{ name = 'white', article = 'a', color = Color(245, 245, 245) },
	{ name = 'white', article = 'a', color = Color(250, 250, 250) },

	-- YELLOWS
	{ name = 'yellow', article = 'a', color = Color(255, 255, 0) },
	{ name = 'yellow', article = 'a', color = Color(255, 255, 102) },
	{ name = 'yellow', article = 'a', color = Color(255, 255, 153) },
}

local function UVGetColorMagnitude( c1, c2 )
	local c1 = c1:ToTable()
	local c2 = c2:ToTable()

	local magnitude = 0

	for i = 1, 3 do
		magnitude = magnitude + ( c1[i] - c2[i] ) ^ 2
	end

	return magnitude
end

function UVColor( ent )
	local vehicleColor = ent:GetColor()
	local shortestDistance = math.huge
	local closestColor = nil

	for _, cArray in pairs( COLORS ) do
		local distance = UVGetColorMagnitude( vehicleColor, cArray.color )

		if distance < shortestDistance then
			shortestDistance = distance
			closestColor = cArray
		end
	end

	return closestColor
end

function UVColorName(ent)
	
	-- if not IsValid(ent) then return end
	
	-- if ent:GetSkin() ~= 0 then
	-- 	return "a custom"
	-- end
	
	-- local color = ent:GetColor()
	-- local rgba = color:ToTable()
	-- local alpha = table.remove(rgba)
	
	-- local rgbtable = {
	-- 	{255, 0, 0},
	-- 	{255, 0, 97},
	-- 	{255, 0, 191},
	-- 	{255, 0, 255},
	-- 	{220, 0, 255},
	-- 	{127, 0, 255},
	-- 	{29, 0, 255},
	-- 	{0, 63, 255},
	-- 	{0, 161, 255},
	-- 	{0, 255, 255},
	-- 	{0, 255, 157},
	-- 	{0, 255, 63},
	-- 	{33, 255, 0},
	-- 	{127, 255, 0},
	-- 	{225, 255, 0},
	-- 	{255, 255, 0},
	-- 	{255, 191, 0},
	-- 	{255, 170, 0},
	-- 	{255, 93, 0},
	-- 	{127, 0, 0},
	-- 	{127, 0, 95},
	-- 	{63, 0, 127},
	-- 	{0, 31, 127},
	-- 	{0, 127, 127},
	-- 	{0, 127, 31},
	-- 	{63, 127, 0},
	-- 	{127, 95, 0},
	-- 	{127, 63, 63},
	-- 	{127, 63, 111},
	-- 	{95, 63, 127},
	-- 	{63, 79, 127},
	-- 	{63, 127, 127},
	-- 	{63, 127, 79},
	-- 	{95, 127, 63},
	-- 	{127, 111, 63},
	-- 	{255, 127, 127},
	-- 	{255, 127, 223},
	-- 	{191, 127, 255},
	-- 	{127, 159, 255},
	-- 	{127, 255, 255},
	-- 	{0, 255, 255},
	-- 	{127, 255, 159},
	-- 	{191, 255, 127},
	-- 	{255, 223, 127},
	-- 	{255, 255, 255},
	-- 	{218, 218, 218},
	-- 	{182, 182, 182},
	-- 	{145, 145, 145},
	-- 	{109, 109, 109},
	-- 	{72, 72, 72},
	-- 	{36, 36, 36},
	-- 	{0, 0, 0},
	-- }
	
	-- local colornametable = {
	-- 	"a red",
	-- 	"a razzmatazz",
	-- 	"a hot magenta",
	-- 	"a magenta",
	-- 	"a psychedelic purple",
	-- 	"an electric indigo",
	-- 	"a blue",
	-- 	"a blue",
	-- 	"a deep sky blue",
	-- 	"an aqua",
	-- 	"a medium spring green",
	-- 	"a free speech green",
	-- 	"a harlequin",
	-- 	"a chartreuse",
	-- 	"a chartreuse yellow",
	-- 	"a yellow",
	-- 	"an amber",
	-- 	"an orange",
	-- 	"a safety orange",
	-- 	"a maroon",
	-- 	"an eggplant",
	-- 	"an indigo",
	-- 	"a navy",
	-- 	"a teal",
	-- 	"a green",
	-- 	"a green",
	-- 	"an olive",
	-- 	"a stiletto",
	-- 	"a cadillac",
	-- 	"a gigas",
	-- 	"a jacksons purple",
	-- 	"a ming",
	-- 	"an amazon",
	-- 	"a dingley",
	-- 	"a yellow metal",
	-- 	"a vivid tangerine",
	-- 	"a neon pink",
	-- 	"a heliotrope",
	-- 	"a maya blue",
	-- 	"an electric blue",
	-- 	"a cyan",
	-- 	"a mint green",
	-- 	"a mint green",
	-- 	"a salomie",
	-- 	"a white",
	-- 	"a gainsboro",
	-- 	"a silver",
	-- 	"a suva gray",
	-- 	"a dim gray",
	-- 	"a charcoal",
	-- 	"a nero",
	-- 	"a black",
	-- }
	
	-- local index = 0
	
	-- for k, v in pairs(rgbtable) do
	-- 	index = index + 1
	-- 	if rgba[1] == v[1] and rgba[2] == v[2] and rgba[3] == v[3] then
	-- 		return colornametable[index]
	-- 	end
	-- end
	
	-- return "a"
	
end

function UVCheckIfBeingBusted(enemy)
	
	local enemyDriver = UVGetDriver(enemy)
	local btimeout = BustedTimer:GetFloat()
	local closestunit
	local closestdistancetounit
		
	local closestunit = enemy.closestunit or nil
	local closestdistancetounit = enemy.closestdistancetounit or math.huge
	
	if not closestunit then closestunit = enemy end

	local _LocalUVBustSpeed = UVBustSpeed or 5
	
	if enemy.hasreset then
		_LocalUVBustSpeed = _LocalUVBustSpeed * (enemy.UVBustingPenaltyMult or 1)
	end

	local velocity = enemy:GetVelocity():LengthSqr()

	local scope = UVGetScope(enemy)
	
	if not enemy.uvbusted and btimeout and btimeout > 0 and velocity < _LocalUVBustSpeed and not scope.EnemyEscaping and (scope.InPursuit or scope.IsBeingPulledOver) and
	(closestdistancetounit < 250000 or closestunit.CloseToTarget) then
		if not enemy.UVHUDBusting and not enemy.UVHUDBustingDelayed then
			enemy.UVHUDBusting = true
			enemy.UVHUDBustingDelayed = true
			local key = "VehicleReset_"..enemy:EntIndex()
            if timer.Exists( key ) then
                timer.Remove(key)
				if enemyDriver and enemyDriver:IsPlayer() then
                	net.Start("uvresetfailed")
                	net.WriteString("uv.resetting.cancel")
                	net.Send(enemyDriver)
				end
			end
			timer.Simple(1, function()
				enemy.UVHUDBustingDelayed = nil
			end)
			if Chatter:GetBool() and IsValid(closestunit) and scope.InPursuit then
				UVChatterBusting(closestunit.UnitVehicle)
			end
			if IsValid(enemyDriver) then
				enemyDriver:EmitSound("ui/pursuit/busting_start.wav", 0, 100, 0.5)
			end
			net.Start( "UVHUDCopModeBusting" )
			net.WriteEntity(enemy)
			net.Broadcast()
		end
		if not enemy.uvbustingincrease then
			enemy.uvbustingincrease = true
			enemy.UVBustingLastProgress = CurTime()
			enemy.UVBustingLastProgress2 = enemy.UVBustingProgress
		end
		enemy.UVBustingProgress = enemy.UVBustingLastProgress2 + (CurTime() - enemy.UVBustingLastProgress) * (enemy.UVBustingPenaltyMult or 1)
		if enemy.UVBustingProgress >= (btimeout-1) and not enemy.nearbust then
			enemy.nearbust = true
			if Chatter:GetBool() and IsValid(closestunit) and scope.InPursuit then
				UVChatterCloseToArrest(closestunit.UnitVehicle)
			end
		end
	else
		if enemy.UVHUDBusting then
			if enemy.uvbustingincrease then
				enemy.uvbustingincrease = false
				enemy.UVBustingLastProgress = CurTime()
				enemy.UVBustingLastProgress2 = enemy.UVBustingProgress
				if enemy.nearbust then
					if not enemy.UVHighestBustingProgress then
						enemy.UVHighestBustingProgress = enemy.UVBustingProgress
					elseif enemy.UVBustingProgress > enemy.UVHighestBustingProgress then
						enemy.UVHighestBustingProgress = enemy.UVBustingProgress
					end
				end
			end
			if (enemy.UVBustingProgress <= 0 or enemy.uvbusted) and not enemy.UVHUDBustingDelayed then
				enemy.UVHUDBusting = nil
				enemy.UVHUDBustingDelayed = true
				timer.Simple(1, function()
					enemy.UVHUDBustingDelayed = nil
				end)
				net.Start( "UVHUDStopBusting" )
				net.Broadcast()
				-- check if enemy is moving fast enough to consider them to be attempting evasion after busting
				if not enemy.uvbusted and velocity >= 300000 and scope.IsBeingPulledOver then
					UV_InitiatePursuit(enemy)
					if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)	
						local unit = units[random_entry]
						if not IsValid(unit.e) then return end
						UVChatterPursuitStartRanAway(unit)
					end
				end
				if Chatter:GetBool() and IsValid(closestunit.UnitVehicle) and scope.InPursuit then
					UVChatterBustEvaded(closestunit.UnitVehicle)
				end
				if IsValid(enemyDriver) then
					if enemy.UVHighestBustingProgress then
						net.Start( "UVHUDStopBustingTimeLeft" )
							net.WriteFloat(enemy.UVHighestBustingProgress)
						net.Send(enemyDriver)
					end
					enemyDriver:EmitSound("ui/pursuit/busting_whoosh_high.wav", 0, 100, 0.5)
				end
				enemy.UVHighestBustingProgress = nil
				if enemy.nearbust then
					enemy.nearbust = nil
				end
				net.Start( "UVHUDStopCopModeBusting" )
				net.WriteEntity(enemy)
				net.Broadcast()
			end
			enemy.UVBustingProgress = enemy.UVBustingLastProgress2 - (CurTime() - enemy.UVBustingLastProgress)
		end 
		enemy.UVStartBustingEnemy = false
	end
	
	--Display busting
	if enemy.UVHUDBusting then
		if enemyDriver then
			net.Start( "UVHUDBusting" )
			net.WriteString(enemy.UVBustingProgress)
			net.Send(enemyDriver)
		end
		if btimeout and btimeout > 0 and not enemy.uvbusted and enemy.UVBustingProgress >= btimeout then --Bust conditions.
			UVBustEnemy(closestunit.UnitVehicle, enemy)
		end
		UVLosing = CurTime()
	else
		UVBusting = CurTime()
		enemy.UVBustingProgress = 0
		enemy.UVBustingLastProgress = CurTime()
		enemy.UVBustingLastProgress2 = enemy.UVBustingProgress
	end
	
	if enemy.UVBustingProgress ~= 0 then
		net.Start('UVHUDUpdateBusting')
		net.WriteEntity(enemy)
		net.WriteFloat(enemy.UVBustingProgress)
		net.Broadcast()
	end
	
	if UVCheckIfWrecked(enemy) or not enemy.uvbusted and enemy:WaterLevel() > 2 or IsValid(UVGetDriver(enemy)) and UVGetDriver(enemy):Health() <= 0 then --Bust conditions.
		UVBustEnemy(enemy, enemy)
	end
	
end

function UVCheckIfWrecked(enemy)
	if not IsValid(enemy) then return end //or AutoHealth:GetBool()
	if enemy:IsFlagSet(FL_DISSOLVING) then return true end
	if enemy.IsScar then
		return enemy:IsDestroyed()
	elseif enemy.IsSimfphyscar then
		return enemy:GetCurHealth() <= 0 or enemy:OnFire() or enemy.destroyed or enemy:WaterLevel() > 2
	elseif enemy.IsGlideVehicle then
		return enemy:GetEngineHealth() <= 0 or enemy:GetIsEngineOnFire()
	elseif enemy.LVS then
		local vehEngine = enemy:GetEngine()
		return (enemy:GetHP() <= 0 or enemy.ExplodedAlready) or (vehEngine and (vehEngine:GetHP() <= 0 or vehEngine:GetDestroyed())) or enemy:WaterLevel() > 2
	elseif vcmod_main and isfunction(enemy.VC_GetHealth) then
		local health = enemy:VC_GetHealth(false)
		return (isnumber(health) and health <= 0) or enemy:WaterLevel() > 2
	elseif enemy:GetClass() == "prop_vehicle_jeep" then
		local health = enemy:Health()
		return health < 0 or enemy:WaterLevel() > 2 --Unless set, health is 0
	end
end

function UVCheckIfHiding(vehicle)
	if not IsValid(vehicle) then return false end
	if vehicle:GetVelocity():LengthSqr() < 10000 then
		if vehicle.IsGlideVehicle then
			return vehicle:GetEngineState() == 0
		elseif vehicle.IsSimfphyscar then
			return vehicle:EngineActive() == false
		elseif vehicle.LVS then
			return not vehicle:GetEngineActive()
		else
			return true
		end
	end
	return false
end

function UVVisualOnTarget(unit, target)
	if not unit or not target then
		return
	end
	if unit.wrecked then return end
	
	local tr = util.TraceLine({start = unit:WorldSpaceCenter(), endpos = target:WorldSpaceCenter(), mask = (InfMap and MASK_ALL or MASK_OPAQUE), filter = {unit, target, 'glide_wheel', table.GetKeys(UVUnitVehicles)}}).Fraction==1
	return tobool(tr)
end

function UVGetDir(v1, v2)
	return (v2 - v1):GetNormalized()
end

function UVGetAng(A, B)
	return A:GetNormalized():Dot(B:GetNormalized())
end

function UVGetAng3(A, B, C)
	return UVGetAng(B - A, C - B)
end

function UVCheckIfRedlineSimfphys(vehicle) --angle fix
	local category = UVGetVehicleMakeAndModel(vehicle, true)
	local categories = {
		["NFS Police Cars"] = true,
		["Redline Bonus Cars"] = true,
		["Redline Cars"] = true,
		["Redline NFS Ports"] = true,
		["Redline Police Cars"] = true,
		["Redline Service Vehicles"] = true
	}
	return categories[category]
end

function UVGetVehicleMakeAndModel(vehicle, category)
	if not IsValid(vehicle) then return end
	if vehicle.IsSimfphyscar then
		local c = vehicle:GetSpawn_List()
		if ( not list.Get( "simfphys_vehicles" )[ c ] ) then return "Vehicle" end
		local t = list.Get( "simfphys_vehicles" )[ c ]
		if category then
			local category = t.Category
			return category or ""
		else
			local name = t.Name
			return name or "Vehicle"
		end
	elseif vehicle.IsGlideVehicle or vehicle.LVS then
		return vehicle.PrintName or "Vehicle"
	elseif vehicle:GetClass() == "prop_vehicle_jeep" then
		local c = vehicle:GetVehicleClass()
		if ( not list.Get( "Vehicles" )[ c ] ) then return "Vehicle" end
		local t = list.Get( "Vehicles" )[ c ]
		if category then
			local category = t.Category
			return category or ""
		else
			local name = t.Name
			return name or "Vehicle"
		end
	end
	return "Vehicle"
end

function UVDeployRoadblock(self)
	if not UVTargeting then return end
	local deployed = false
	
	if UVAutoLoadRoadblock() then
		deployed = true
		if Chatter:GetBool() and IsValid(self.v) then
			UVChatterRoadblockDeployed(self)
		end
	end
	return deployed
end

local function WreckVehicle(vehicle)
	if not IsValid(vehicle) or vehicle.wrecked then return end

	vehicle.wrecked = true

	if vehicle.IsGlideVehicle then
		vehicle:SetEngineHealth(0)
		vehicle:UpdateHealthOutputs()
		vehicle.UnflipForce = 0
		vehicle.AngularDrag = vector_origin
		if vehicle.CanSwitchHeadlights then
			vehicle:SetHeadlightState(0)
		end
	elseif vehicle.LVS then
		vehicle:SetHP(0)
		vehicle:StopEngine()
	elseif vehicle.IsSimfphyscar then
		vehicle:SetCurHealth(0)
		vehicle:SetLightsEnabled(false)
	elseif vehicle:GetClass() == "prop_vehicle_jeep" then
		vehicle:EmitSound( "vehicles/v8/vehicle_rollover"..math.random(1,2)..".wav" )
		if vehicle:LookupAttachment("vehicle_engine") > 0 then
			ParticleEffectAttach("smoke_burning_engine_01", PATTACH_POINT_FOLLOW, vehicle, vehicle:LookupAttachment("vehicle_engine"))
		end
		local e = EffectData()
		e:SetEntity(vehicle)
		util.Effect("entity_remove", e)
	end

	local distancedespawntime = 10
	local despawntime = 50
	
	table.insert(UVWreckedVehicles, vehicle)

	timer.Simple(distancedespawntime, function()
		if IsValid(vehicle) then
			vehicle.markedfordeletion = true
			timer.Simple(despawntime, function()
				if IsValid(vehicle) then
					vehicle:Remove()
				end
			end)
		end
	end)

	UVDeactivateGrappler(vehicle)
	UVDeactivateKillSwitch(vehicle)
	UVDeactivateESF(vehicle)

	net.Start("UVHUDRemoveUV")
	net.WriteInt(vehicle:EntIndex(), 32)
	net.WriteInt(vehicle:GetCreationID(), 32)
	net.Broadcast()

	hook.Run( 'UV_Event', 'onWreck', vehicle )
end

function UVUnitShouldBeWrecked(vehicle)
	if not vehicle then return end
	if vehicle:IsFlagSet(FL_DISSOLVING) then return true end
	if vehicle.IsScar then
		return vehicle:IsDestroyed()
	elseif vehicle.IsSimfphyscar then
		return vehicle:GetCurHealth() <= 0 or vehicle:OnFire() or vehicle.destroyed
	elseif vehicle.IsGlideVehicle then
		return vehicle:GetEngineHealth() <= 0 or vehicle:GetIsEngineOnFire()
	elseif vehicle.LVS then
		local vehEngine = vehicle:GetEngine()
		return (vehicle:GetHP() <= 0 or vehicle.ExplodedAlready) or (vehEngine and (vehEngine:GetHP() <= 0 or vehEngine:GetDestroyed()))
	elseif isfunction(vehicle.VC_GetHealth) then
		local health = vehicle:VC_GetHealth(false)
		return isnumber(health) and health <= 0
	end
end

function UVUnitIsWrecked(vehicle)
	if UVUnitShouldBeWrecked(vehicle) then
		return true
	end

	local vehiclePhys = vehicle:GetPhysicsObject()
	local vehicleAngles = vehiclePhys:GetAngles()
	local vehicleVelSqr = vehicle:GetVelocity():LengthSqr()

	local isNPC = vehicle.UnitVehicle and vehicle.UnitVehicle:IsNPC()
	local isJeepNoHealth = vehicle:Health() < 0 and vehicle:GetClass() == "prop_vehicle_jeep"
	local isCommander = vehicle.uvclasstospawnon == "npc_uvcommander"
	local isFlipped = vehiclePhys:IsValid() and vehicleAngles.z > 90 and vehicleAngles.z < 270
	local isFlipCrashAllowed = not isCommander and not vehicle.RacerVehicle and CanWreck:GetBool()
	local isFlipCrash = isFlipCrashAllowed and isFlipped and (( vehicle.rammed ) or ( vehicleVelSqr < 10000 and ( vehicle.UnitVehicle and vehicle.UnitVehicle.stuck )))

	local isUnderwater = vehicle:WaterLevel() > 2
	local isOnFire = vehicle:IsOnFire()
	local isOtherPlayerWrecked = UVUnitShouldBeWrecked(vehicle)

	local wrecked = isJeepNoHealth
		or isFlipCrash
		or isUnderwater
		or isOnFire
		or isOtherPlayerWrecked

	return wrecked
end

local function BountyValue(car)
	local class = car.uvclasstospawnon

	if class == "npc_uvpatrol" then
		return UVUBountyPatrol:GetInt()
	elseif class == "npc_uvsupport" then
		return UVUBountySupport:GetInt()
	elseif class == "npc_uvpursuit" then
		return UVUBountyPursuit:GetInt()
	elseif class == "npc_uvinterceptor" then
		return UVUBountyInterceptor:GetInt()
	elseif class == "npc_uvspecial" then
		if car.rhino then
			return UVUBountyRhino:GetInt()
		else
			return UVUBountySpecial:GetInt()
		end
	elseif class == "npc_uvcommander" then
		return UVUBountyCommander:GetInt()
	end

	return 0
end

function UVPlayerWreck(vehicle)
	if IsValid(vehicle) and vehicle.wrecked then return end

	WreckVehicle(vehicle)

	local DriverEntity = vehicle.UnitVehicle or vehicle.RacerVehicle or vehicle.TrafficVehicle

	if vehicle.UnitVehicle then
		local enemy = vehicle.e or (DriverEntity:IsNPC() and DriverEntity.e)
		
		--Unit functions below
		if table.HasValue(UVCommanders, vehicle) then
			UVCommanders = {}
		end

		if table.HasValue(UVUnitsChasing, vehicle) then
			table.RemoveByValue(UVUnitsChasing, vehicle)
		end

		local bounty = BountyValue(vehicle)

		if not timer.Exists("uvcombotime") then
			timer.Create("uvcombotime", 5, 1, function() 
				UVComboBounty = 1 
				timer.Remove("uvcombotime")
			end)
		else
			timer.Remove("uvcombotime")
			timer.Create("uvcombotime", 5, 1, function() 
				if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() and UVComboBounty >= 3 then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					UVChatterMultipleUnitsDown(unit)
				end
				UVComboBounty = 1
				timer.Remove("uvcombotime")
			end)
		end

		local v = UVGetVehicleMakeAndModel(vehicle)
		local name = ( vehicle.UnitVehicle and vehicle.UnitVehicle.callsign ) or (IsValid( UVGetDriver(vehicle) ) and UVGetDriver(vehicle):GetName()) or "Unit"
		local bountyplus = (bounty)*(UVComboBounty)

		local enemydriver = UVGetDriver(enemy)

		if IsValid(enemydriver) then 
			UVNotifyCenter({enemydriver}, "uv.hud.combo", "UNITS_DISABLED", name, v, bountyplus, UVComboBounty, enemydriver:IsPlayer())
		end

		local scope = UVGetScope(enemy)

		if scope then
			scope.Wrecks = scope.Wrecks + 1
			scope.Bounty = scope.Bounty + bountyplus
		end

		UVWrecks = UVWrecks + 1

		hook.Run( "UV_Event", "onUnitWrecked", enemy, vehicle )

		if not UVResourcePointsRefreshing and UVGlobalPursuit.ResourcePoints > 1 and not UVOneCommanderActive then
			UVUpdateGlobalPursuit('ResourcePoints', UVGlobalPursuit.ResourcePoints - 1)
		end

		UVSetELS(false, vehicle)
		UVSetELSSound(false, vehicle)

		local driver = UVGetDriver(vehicle)
		if driver and driver:IsPlayer() then
			local bustedtable = {}
			-- If UVGame is defined, it means we are playing the gamemode.
			-- We want to disallow this as the gamemode handles spawning on it's own.
			if not UVGame then
				net.Start( "UVHUDWreckedDebrief" )
				net.Send(driver)
			end
			driver:KillSilent()
			driver:SetNoDraw(true)
			driver:Spectate(OBS_MODE_DEATHCAM)
			driver:SpectateEntity(driver)
		end

		UVComboBounty = UVComboBounty + 1
	end

	if vehicle.UnitVehicle or vehicle.RacerVehicle then
		local centerPos = vehicle:WorldSpaceCenter()
		local radius = ActionCamTakedownThreshold:GetInt()

		local foundEntities = ents.FindInSphere(centerPos, radius)
		local playersInRange = {}

		for _, ent in ipairs(foundEntities) do
		    if IsValid(ent) and ent:IsPlayer() then
		        table.insert(playersInRange, ent)
		    end
		end

		for _, ply in ipairs(playersInRange) do
		    UVActionCam(ply, "Takedown", vehicle)
		end
	end

	if DriverEntity and DriverEntity:IsNPC() then
		DriverEntity.wrecked = true

		if Chatter:GetBool() and vehicle.UnitVehicle then
			UVChatterWreck(DriverEntity)
		end

		SafeRemoveEntity(DriverEntity)
	end
end

function UVNavigateDVWaypointOptimized( self, vectors )
	if not dvd or not dvd.Waypoints or next( dvd.Waypoints ) == nil then
		self.NavigateBlind = true
		return
	end

	local startPos = self.v:WorldSpaceCenter()
	local endPos = isvector( vectors ) and vectors or (istable( vectors ) and vectors[1] or startPos)
	local maxWaypoints = 4
	local minStepSq = 625 
	local route = {}
	local lastAdded = nil
	local viewOrigin = startPos

	for i = 0, maxWaypoints - 1 do
		local t = ( maxWaypoints > 1 ) and ( i / (maxWaypoints - 1) ) or 0
		local samplePos = startPos + ( endPos - startPos ) * t
		local wp = dvd.GetNearestWaypoint( samplePos )
		if wp and wp.Target then
			local v = wp.Target
			if ( lastAdded == nil or v:DistToSqr( lastAdded ) > minStepSq ) then
				table.insert( route, v )
				lastAdded = v
				viewOrigin = v
			end
		end
	end
	if next( route ) == nil then
		return
	end

	self.tableroutetoenemy = route
	if isfunction(self.RecordNavigationPath) then
		self:RecordNavigationPath(vectors)
	end
	self.PathMode = "dv"
	return self.tableroutetoenemy
end

function UVNavigateDVWaypoint(self, vectors, full)
	if UVEnemyEscaping then
		vectors = dvd.Waypoints[math.random(#dvd.Waypoints)].Target
	end
	
	local FromSelfToEnemy = dvd.GetRouteVector(self.v:GetPos(), vectors)
	local FromEnemyToSelf = dvd.GetRouteVector(vectors, self.v:GetPos())
	
	if not FromSelfToEnemy and not FromEnemyToSelf then
		self.NavigateBlind = true
		return --Unable to get route
	end

	local options = {
		[true] = FromSelfToEnemy and table.Reverse( FromSelfToEnemy ),
		[false] = FromEnemyToSelf,
	}

	local selfToEnemy = FromSelfToEnemy and #FromSelfToEnemy or math.huge
	local enemyToSelf = FromEnemyToSelf and #FromEnemyToSelf or math.huge

	operationStack = options[selfToEnemy <= enemyToSelf]

	-- if FromSelfToEnemy and FromEnemyToSelf then
	-- 	print("operationStack", #FromSelfToEnemy <= #FromEnemyToSelf)
	-- 	operationStack = options[(#FromSelfToEnemy <= #FromEnemyToSelf)]
	-- else
	-- 	operationStack = options[ FromSelfToEnemy and true or false ]
	-- end

	if operationStack then
		self.tableroutetoenemy = {}

		local maxNewWaypoints = 100
		local added = 0

		for i, v in ipairs( operationStack ) do
			if added >= maxNewWaypoints then break end

			local targetVec = v["Target"]
			local found = false

			for _, existingVec in pairs( self.tableroutetoenemy ) do
				if existingVec[1] == targetVec[1] and existingVec[2] == targetVec[2] and existingVec[3] == targetVec[3] then
					found = true
					break
				end
			end

			if not found then
				table.insert( self.tableroutetoenemy, targetVec )
				added = added + 1
			end
		end

		if added > 0 and added < maxNewWaypoints then 
			table.insert( self.tableroutetoenemy, vectors )
		end

		if isfunction(self.RecordNavigationPath) then
			self:RecordNavigationPath(vectors)
		end
		self.PathMode = "dv"
		return self.tableroutetoenemy
	end
end

function UVNavigateNavmesh(self, vectors)
	-- THIS IS THE CAUSE OF THE FUCKING LAG PROBLEMS WHEN CAR TAKES OFF!!!
	--print("UVNavigateNavmesh")
	if IsValid(self.v) and isfunction(self.IsNavigationGrounded) and not self:IsNavigationGrounded() then
		return false
	end

	local CNavAreaFromSelfToEnemy = UVRequestVectorsnavmesh(self.v:WorldSpaceCenter(), vectors, self.v.width)
	--print(type(CNavAreaFromSelfToEnemy), (type(CNavAreaFromSelfToEnemy) == "table" and #CNavAreaFromSelfToEnemy))
	-- WHEN YOU ARE MID AIR, IT CAN TAKE TOO LONG TO GET THE ROUTE AND IT WILL LAG THE GAME!!! THEN IT RETURNS FALSE!!!
	-- KILL IT!!
	
	if istable(CNavAreaFromSelfToEnemy) then --Get the route
		self.tableroutetoenemy = {}
		local closestpoint = self.v:WorldSpaceCenter()
		for k, v in pairs(CNavAreaFromSelfToEnemy) do
			table.insert(self.tableroutetoenemy, v:GetClosestPointOnArea(closestpoint))
			closestpoint = v:GetCenter()
		end
		if isfunction(self.RecordNavigationPath) then
			self:RecordNavigationPath(vectors)
		end
		self.PathMode = "navmesh"
		return self.tableroutetoenemy
	else
		self.NavigateBlind = true
		return --Unable to get route
	end
end

local function GetClosestWheel(pos, wheeltable)
	if not pos or wheeltable then return end

    local closestWheel = nil
    local mindist = math.huge
        
    for _, wheel in pairs(wheeltable) do
        
        local dist = wheel:GetPos():DistToSqr(pos)
        if (dist < mindist) then
            mindist = dist
            closestwheel = wheel
        end
    end
    
    return closestwheel
end

function UVDetachWheels(vehicle, location)
	--A wheel closest to the location will detach, otherwise get a random wheel

	if not WheelsDetaching:GetBool() then return end

	timer.Simple(0, function()
		if not IsValid(vehicle) then return end

		if vehicle.IsGlideVehicle and vehicle.wheels then

			if next(vehicle.wheels) == nil then return end
			
			local wheelmathchance = math.random(1,2)
			local wheel = GetClosestWheel(location, vehicle.wheels) or vehicle.wheels[math.random(1, #vehicle.wheels)]

			if wheel and wheelmathchance == 1 then
				local wheelphys = vehicle:GetPhysicsObject() --Glide wheels don't have a physics object

				local wheelmodel = wheel:GetModel()
				local wheelpos = wheel:GetPos()
				local wheelang = wheel:GetAngles()
				local wheelcolor = wheel:GetColor()
				local wheelmat = wheel:GetMaterial()

				local wheelvelocity = wheelphys:GetVelocity()
				local wheelangvel = wheelphys:GetAngleVelocity()

				table.RemoveByValue(vehicle.wheels, wheel)
				wheel:Remove()

				local wreckedwheel = ents.Create("prop_physics")
				wreckedwheel:SetModel(wheelmodel)
				wreckedwheel:SetPos(wheelpos)
				wreckedwheel:SetAngles(wheelang)
				wreckedwheel:SetColor(wheelcolor)
				wreckedwheel:SetMaterial(wheelmat)
				wreckedwheel:SetVelocity(wheelvelocity)
				wreckedwheel:Spawn()

				local wreckedwheelphys = wreckedwheel:GetPhysicsObject()
				wreckedwheelphys:SetVelocity(wheelvelocity)
				wreckedwheelphys:SetAngleVelocity(wheelangvel)

				timer.Simple(60, function()
					if IsValid(wreckedwheel) then
						wreckedwheel:Remove()
					end
				end)
			end

		elseif vehicle.IsSimfphyscar and vehicle.Wheels then

			if next(vehicle.Wheels) == nil then return end

			local wheelmathchance = math.random(1,2)
			local wheel = GetClosestWheel(location, vehicle.Wheels) or vehicle.Wheels[math.random(1, #vehicle.Wheels)]

			if wheel and wheelmathchance == 1 then
				constraint.RemoveAll(wheel)
			end

		elseif vehicle.LVS and vehicle:GetWheels() then

			local wheeltable = vehicle:GetWheels()
			if next(wheeltable) == nil then return end

			local wheelmathchance = math.random(1,2)
			local wheel = GetClosestWheel(location, wheeltable) or wheeltable[math.random(1, #wheeltable)]

			if wheel and wheelmathchance == 1 then
				constraint.RemoveAll(wheel)
			end
			
		end
		
	end)
	
end

local ActionCamSettings = {
    ["RaceStart"] = {
		Convar = ActionCamRaceStart,
        Duration = 4
    },
    ["RaceFinish"] = {
		Convar = ActionCamRaceFinish,
        Duration = 5,
        TimeScale = 0.25,
		AIControl = true
    },
    ["Crash"] = {
		Convar = ActionCamCrash,
        Duration = 3,
        TimeScale = 0.5
    },
    ["Jump"] = {
		Convar = ActionCamJump,
        Duration = 3,
        TimeScale = 0.25
    },
    ["Spotted"] = {
		Convar = ActionCamSpotted,
        Duration = 2.7,
        TimeScale = 0.001
    },
    ["Roadblock"] = {
		Convar = ActionCamRoadblock,
        Duration = 3,
        TimeScale = 0.25
    },
    ["Takedown"] = {
		Convar = ActionCamTakedown,
        Duration = 3,
        TimeScale = 0.5
    },
    ["PursuitBreaker"] = {
		Convar = ActionCamPursuitBreaker,
        Duration = 5,
        AIControl = true
    }
}

function UVActionCam(ply, type, entity, pbdata)
	if not IsValid(ply) or not ply:IsPlayer() or ply.ActionCam or not ActionCam:GetBool() or not ActionCamSettings[type].Convar:GetBool() then return end
	
	local vehicle = UVGetVehicle(ply)
	if not IsValid(vehicle) or IsValid(vehicle) and vehicle:GetNWBool( "SpeedbreakerInUse" ) then return end

	UVPlayersInActionCam = UVPlayersInActionCam or {}
	table.insert(UVPlayersInActionCam, ply)

	if ActionCamSettings[type].AIControl and not vehicle.UnitVehicle then
		ply.ActionCamAIControl = true

		--blackbox style trick (SINGLEPLAYER ONLY)
		if game.SinglePlayer() and not vehicle.ghoston then
			vehicle.aicontrolled = true --AI should not use juggernaut and ghost
			timer.Simple(0, function()
				vehicle:SetCollisionGroup(20)
			end)
		end

		local uv = ents.Create("npc_racervehicle")
		uv:SetPos(vehicle:GetPos())
		uv.temporary = true
		uv.vehicle = vehicle
		uv:Spawn()
		uv:Activate()
	end

	ply.ActionCam = true
	ply.ActionCamTime = RealTime() + ActionCamSettings[type].Duration or 5
	
	pbdata = pbdata or {}

	net.Start("UVActionCamStart")
		net.WriteString(type)
		net.WriteFloat(ActionCamSettings[type].Duration or 5)
		net.WriteEntity(entity)
		net.WriteTable(pbdata)
	net.Send(ply)

	if game.SinglePlayer() and ActionCamSettings[type].TimeScale then
		CF_CanSetTimeScale = false
		game.SetTimeScale(ActionCamSettings[type].TimeScale)
	end
end

hook.Add("Glide_CanPlayerVehicleInput", "UVActionCamOverrideControlsGlide", function(ply, vehicle, action, pressed)
	if ply.ActionCamAIControl then return false end
end)

function UVCFEligibleToUse(NPC)
	local vehicle = NPC.v
	return (vehicle.RacerVehicle and UseNitrousRacer:GetBool()) or (vehicle.UnitVehicle and not vehicle.roadblocking and UseNitrousUnit:GetBool())
end

local function UVCFActivateNitrous(NPC, seconds)
	NPC.usenitrous = true 
	timer.Simple(seconds, function()
		NPC.usenitrous = false
	end)
end

function UVCFInitialize(NPC)
	NPC.usenitrous = false
	
	--NPCs will decide when to use nitrous based on the amount
	NPC.preferrednitroustable = {
		0.25,
		0.5,
		0.75,
		1
	}
	NPC.preferrednitrousamount = NPC.preferrednitroustable[ math.random( 1, #NPC.preferrednitroustable ) ]
	
	local car = NPC.v
	local index = NPC:EntIndex()

	if car.RacerVehicle then --Give racers some nice colors
		local r = math.random(0, 255)
		local g = math.random(0, 255)
		local b = math.random(0, 255)

		net.Start( "cfnitrouscolor" )
    	    net.WriteEntity(car)
    	    net.WriteInt(r, 9)
    	    net.WriteInt(g, 9)
    	    net.WriteInt(b, 9)
			net.WriteBool(car.NitrousBurst)
			net.WriteBool(car.NitrousEnabled)
    	net.Broadcast()
	end

	timer.Create( "UVCFNitrous" .. index, 1, 0, function()
		if not IsValid(NPC) or not IsValid(car) then
			timer.Remove( "UVCFNitrous" .. index )
			return
		end

		local amount = car:GetNWFloat( 'NitrousAmount' )
		if amount >= NPC.preferrednitrousamount and UVCFEligibleToUse(NPC) then
			local seconds = math.random(1,5)
			UVCFActivateNitrous(NPC, seconds)
		end

		local chance = math.random(1,60)
		if chance == 1 then
			NPC.preferrednitrousamount = NPC.preferrednitroustable[ math.random( 1, #NPC.preferrednitroustable ) ]
		end
	end)

end

net.Receive("UVToggleHeadlights", function(len, ply)
	local NPC = net.ReadEntity()
	local bool = net.ReadBool()

	if not NPC.v then return end
	
	if bool then
		if NPC.v.IsGlideVehicle then
            NPC.v:SetHeadlightState( 1 )
		elseif NPC.v.IsSimfphyscar and NPC.v:IsInitialized() then
			NPC.v:SetLightsEnabled(true)
        elseif vcmod_main and NPC.v:GetClass() == "prop_vehicle_jeep" then
            NPC.v:VC_setRunningLights( true )
        end
	else
		if NPC.v.IsGlideVehicle then
            NPC.v:SetHeadlightState( 0 )
		elseif NPC.v.IsSimfphyscar and NPC.v:IsInitialized() then
			NPC.v:SetLightsEnabled(false)
        elseif vcmod_main and NPC.v:GetClass() == "prop_vehicle_jeep" then
            NPC.v:VC_setRunningLights( false )
        end
	end
end)

-- net.Receive("RequestGlideVehicles", function(len, ply)
	-- if not ply:IsSuperAdmin() then return end
	-- if not GlideRequestCooldown or CurTime() - GlideRequestCooldown > 1 then
		-- GlideRequestCooldown = CurTime()
	-- else
		-- return
	-- end

	-- local glideVehicles = {}

	-- for className, scripted in pairs(scripted_ents.GetList() or {}) do
		-- if scripted.Base == "base_glide_car" and istable(scripted.t) and scripted.t.GlideCategory then
			-- local cat = scripted.t.GlideCategory or "Default"
			-- glideVehicles[cat] = glideVehicles[cat] or {}
			-- table.insert(glideVehicles[cat], {
				-- name  = scripted.t.PrintName or className,
				-- class = className -- Use key directly, guaranteed valid
			-- })
		-- end
	-- end

	-- local totalCategories = table.Count(glideVehicles)

	-- for category, vehicles in pairs(glideVehicles) do
		-- net.Start("GlideVehiclesTable")
		-- net.WriteTable({ [category] = vehicles })
		-- net.Send(ply)
	-- end
-- end)

net.Receive("RequestGlideVehicles", function(len, ply)
	if not ply:IsSuperAdmin() then return end

	-- Simple cooldown
	if not GlideRequestCooldown or CurTime() - GlideRequestCooldown > 1 then
		GlideRequestCooldown = CurTime()
	else
		return
	end

	local glideVehicles = {}

	-- Collect all Glide vehicles into categories
	for className, scripted in pairs(scripted_ents.GetList() or {}) do
		if scripted.Base == "base_glide_car" and istable(scripted.t) and scripted.t.GlideCategory then
			local cat = scripted.t.GlideCategory or "Default"
			glideVehicles[cat] = glideVehicles[cat] or {}
			table.insert(glideVehicles[cat], {
				name  = scripted.t.PrintName or className,
				class = className
			})
		end
	end

	-- Send the *entire* table in a single message
	net.Start("GlideVehiclesTable")
	net.WriteTable(glideVehicles)
	net.Send(ply)
end)

net.Receive("RequestLVSVehicles", function(len, ply)
	if not ply:IsSuperAdmin() then return end

	-- Simple cooldown
	if not LVSRequestCooldown or CurTime() - LVSRequestCooldown > 1 then
		LVSRequestCooldown = CurTime()
	else
		return
	end

	local lvsVehicles = {}	

	-- Collect all LVS vehicles into categories
	for className, scripted in pairs(scripted_ents.GetList() or {}) do
		if scripted.Base == "lvs_base_wheeldrive" and istable(scripted.t) then	
			local cat = scripted.t.Category or "Default"
			lvsVehicles[cat] = lvsVehicles[cat] or {}
			table.insert(lvsVehicles[cat], {
				name  = scripted.t.PrintName or className,
				class = className
			})
		end
	end

	-- Send the *entire* table in a single message
	net.Start("LVSVehiclesTable")
	net.WriteTable(lvsVehicles)
	net.Send(ply)
end)