AddCSLuaFile()

local UVRacePlayIntro = true
local UVRacePlayMusic = false 
local UVRacePlayTransition = false

local showhud = GetConVar("cl_drawhud")

UVHUDRaceFinishCountdownStarted = false
UVHUDRaceFinishEndTime = nil
UVHUDRaceFinishStartTime = nil
UVHUDRaceAnimTriggered = false
UVHUDRacePursuitEndTime = nil
UVHUDRacePursuitStartTime = nil

UVRace_UsingNodes = nil

UVRaceLaps = CreateConVar( "unitvehicle_racelaps", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Number of laps to complete. Set to 1 to have sprint races." )
UVRaceDNFTimer = CreateConVar( "unitvehicle_racednftimer", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How long, once one racer crosses the line, the rest have to finish before DNF'ing." )
UVRaceVisibleCheckpoints = CreateConVar( "unitvehicle_racevisiblecheckpoints", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether to show the checkpoints to the players." )
UVRacePursuitStart = CreateConVar( "unitvehicle_racepursuitstart", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How long, once one race begins, before a pursuit auto-starts." )
UVRacePursuitStop = CreateConVar( "unitvehicle_racepursuitstop", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "If a pursuit is active, immediately stop the pursuit when the race ends." )
UVRacePursuitStopDespawn = CreateConVar( "unitvehicle_racepursuitstop_despawn", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "If a pursuit is active, despawn all AI units when the race ends." )
UVRaceClearAI = CreateConVar( "unitvehicle_raceclearai", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Removes all AI and their vehicles when the race ends." )
UVRaceDifficulty = CreateConVar( "unitvehicle_racedifficulty", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Increases racing AI difficulty." )
UVRaceCatchup = CreateConVar( "unitvehicle_racercatchup", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enables catch-up mode for AI racers." )
UVRaceCatchupGap = CreateConVar( "unitvehicle_racercatchup_gap", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How far behind AI racers need to be to activate it." )
UVRaceReverseCatchup = CreateConVar( "unitvehicle_racercatchup_rev", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enables catch-up mode for AI racers." )
UVRaceReverseCatchupGap = CreateConVar( "unitvehicle_racercatchup_rev_gap", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How far behind AI racers need to be to activate it." )
UVRaceCautious = CreateConVar( "unitvehicle_racercautious", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enables cautious mode for AI racers, making them more aware of other racers and less aggressive." )
UVRaceCautiousRandom = CreateConVar( "unitvehicle_racercautiousrandomness", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether to randomize the cautious mode for AI racers, unitvehicle_racercautious must be ENABLED." )
UVRaceLegacySpawn = CreateConVar( "unitvehicle_racelegacyspawn", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether to use the legacy spawn method for spawning racers on grid slots." )

UVMenuFirstCreate = CreateConVar( "unitvehicle_uvmenu_firstsetup", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, whenever you open the UV Menu via the Context Menu, you'll be prompted to go through the first-time setup." )

-- Data Import
UVMenuDataReplaceSV = CreateConVar( "uvmenu_enabledatareplace_server", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If enabled, allows the server to replace data available through third-party addons." )

if CLIENT then
	CreateClientConVar("uvmenu_enabledataimport", 1, true, false)
	CreateClientConVar("uvmenu_enabledatareplace", 1, true, false)
end

function UVFormLeaderboard(racers, overrideVehicle)
	local lPr = CLIENT and LocalPlayer()
	local sorted_table = {}
	local lVehicle, lArray = nil, nil

	for vehicle, array in pairs(racers) do
		if IsValid(vehicle) and vehicle:GetDriver() == lPr then
			lVehicle = vehicle
			lArray = array
		end

		if overrideVehicle and vehicle == overrideVehicle then
			lVehicle = vehicle
			lArray = array
		end

		table.insert(sorted_table, {
			vehicle = vehicle,
			array = array
		})
	end

	if not lArray then 
		return sorted_table
	end

	local lCheckpointCount = #lArray.Checkpoints
	local leaderboardLines = {}

	-- Sort by: lap > checkpoints > checkpoint time
	-- table.sort(sorted_table, function(a, b)
	--     local aData, bData = a.array, b.array
	--     if aData.Lap ~= bData.Lap then
	--         return aData.Lap > bData.Lap
	--     end

	--     local aCP, bCP = #aData.Checkpoints, #bData.Checkpoints
	--     if aCP ~= bCP then
	--         return aCP > bCP
	--     end

	--     local aTime = aData.Checkpoints[aCP] or 0
	--     local bTime = bData.Checkpoints[bCP] or 0
	--     return aTime < bTime
	-- end)
	table.sort(sorted_table, function(a, b)
		local aData, bData = a.array, b.array
		-- if aData.Finished and not bData.Finished then
		--     return true
		-- elseif not aData.Finished and bData.Finished then
		--     return false
		-- end
		local function getStatusPriority(data)
			if data.Disqualified or data.Busted then return 3 end
			if data.Finished then return 1 end
			return 2
		end

		local aPriority = getStatusPriority(aData)
		local bPriority = getStatusPriority(bData)

		if aPriority ~= bPriority then
			return aPriority < bPriority
		end

		if aData.Finished and bData.Finished then
			local aLTime = aData.LastLapTime or math.huge
			local bLTime = bData.LastLapTime or math.huge
			if aLTime ~= bLTime then
				return aLTime < bLTime
			end
		end

		if aData.Lap ~= bData.Lap then
			return aData.Lap > bData.Lap
		end

		local aCP, bCP = #aData.Checkpoints, #bData.Checkpoints
		if aCP ~= bCP then
			return aCP > bCP
		end

		local aTime = aData.Checkpoints[aCP] or 0
		local bTime = bData.Checkpoints[bCP] or 0

		if aTime ~= bTime then
			return aTime < bTime
		end

		-- local aLTime = (aData.LastLapTime or math.huge) - UVHUDRaceInfo.Info.Time
		-- local bLTime = (bData.LastLapTime or math.huge) - UVHUDRaceInfo.Info.Time
		-- return aLTime < bLTime
	end)

	for i, v in ipairs(sorted_table) do
		local vehicle = v.vehicle
		local lang = UVString

		if not IsValid(vehicle) then
			--local line = string.format("%d. %s", i, v.array.Name)
			--local str = ''
			local mode = nil

			if v.array.Finished then
				--str = lang("uv.race.suffix.finished")
				mode = 'Finished'
			elseif v.array.Busted then
				--str = lang("uv.race.suffix.busted")
				mode = 'Busted'
			else
				--str = lang("uv.race.suffix.dnf")
				mode = 'Disqualified'
			end

			--line = line .. str

			--local selected_color = LBColors.Disqualified

			table.insert(leaderboardLines, {v.array.Name or "Racer", nil, mode})
		else
			local array = v.array
			local driver = vehicle:GetDriver()
			local is_local_player = (IsValid(driver) and driver == lPr) or (overrideVehicle and vehicle == overrideVehicle)
			local name = array.Name or "Racer"

			local diff = nil -- Display mode (Lap, Time, Finished, DNF/Busted)
			local mode = nil

			-- local line = string.format("%d. %s", i, name)
			-- local line = name

			if not is_local_player then
				local racerCPs = array.Checkpoints or {}
				local racerCount = #racerCPs
				local checkpointDiff = lCheckpointCount - racerCount
				local totalTimeDiff = 0

				if checkpointDiff ~= 0 then
					local aheadCPs = (checkpointDiff > 0) and lArray.Checkpoints or racerCPs
					local behindCPs = (aheadCPs == lArray.Checkpoints) and racerCPs or lArray.Checkpoints
					local behindCount = #behindCPs

					for j = 1, math.abs(checkpointDiff) do
						local idx = behindCount + j
						local timeNow = aheadCPs[idx]
						local timePrev = aheadCPs[idx - 1] or timeNow
						if timeNow then
							totalTimeDiff = totalTimeDiff + (timeNow - timePrev)
						end
					end

					if checkpointDiff > 0 then
						totalTimeDiff = -totalTimeDiff
					end
				else
					local localTime = lArray.Checkpoints[lCheckpointCount] or 0
					local otherTime = racerCPs[racerCount] or 0
					totalTimeDiff = localTime - otherTime
				end

				local sign = (totalTimeDiff >= 0) and "+" or "-"

				local str = "???"

				if v.array.Finished then
					mode = 'Finished'
					--str = lang("uv.race.suffix.finished")
				elseif v.array.Busted then
					mode = 'Busted'
					--str = lang("uv.race.suffix.busted")
				elseif v.array.Disqualified then
					mode = 'Disqualified'
					--str = lang("uv.race.suffix.dnf")
				elseif v.array.Lap ~= lArray.Lap then
					mode = 'Lap'
					local difference = v.array.Lap - lArray.Lap
					local ltext = "uv.race.suffix.lap"
					if math.abs( difference ) ~= 1 then ltext = "uv.race.suffix.laps" end
					--diff = ((difference > 0 and '+') or '-') ..math.abs( difference )
					diff = difference
					--str = string.format( lang(ltext), ((difference > 0 and '+') or '-') ..math.abs( difference ) )
				else
					mode = 'Time'
					--str = string.format("  (%s%.3f)", sign, math.abs(totalTimeDiff))
					diff = totalTimeDiff
				end

				--line = line .. str
			end

			local selected_color = nil

			-- if is_local_player then
			--     selected_color = LBColors.LocalPlayer
			-- elseif array.Disqualified or array.Busted then
			--     selected_color = LBColors.Disqualified
			-- else
			--     selected_color = LBColors.Others
			-- end

			table.insert(leaderboardLines, {name, is_local_player, mode, diff}) 
		end
	end

	--UVSortedRacers = sorted_table

	return sorted_table, leaderboardLines
end

UVRaceList = {}

if SERVER then	
	UVRaceTable = {}
	UVRaceCurrentParticipants = {}
	UVRaceStartTime = CurTime()
	
	UVRace_LoadedEntities = {}
	UVRace_LoadedConstraints = {}
	UVRace_Nodes = UVRace_Nodes or {}
	UVRace_CompiledPaths = UVRace_CompiledPaths or {}
	
	UVRaceInvites = UVRaceInvites or {}
	UVRaceFirstSplitTriggered = UVRaceFirstSplitTriggered or false

	-- For now I am sending all races to clients
	-- Perhaps we can send them on demand in the future ?

	hook.Add( "UVContentEvent", "UVRaceHandler_OnContentUpdate", function( operation, path, fileName )
		if operation ~= "Initialize" and path ~= 'races>>' .. game.GetMap() then return end

		-- JSON files are not races, they are race "extra" data
		-- Main race files are the TXT files
		if operation ~= "Initialize" and string.EndsWith( fileName, ".json" ) then return end
		
		if operation == "Add" or operation == "Refresh" then
			UV_AddRace( fileName )
		elseif operation == "Remove" then
			UV_RemoveRace( fileName )
		elseif operation == "Initialize" then
			UV_PopulateRaceList()
		end
	end )

	local dvd = DecentVehicleDestination

	local function extractFullRaceName( headerSplit )
		local raceName = ''
		local splitCopy = table.Copy(headerSplit)
	
		table.remove(splitCopy, 1)
	
		for _, v in ipairs(splitCopy) do
			if string.sub(v, 1, 1) == "'" then break end
			raceName = raceName .. v .. " "
		end
	
		return raceName
	end

	local function ParseRaceFile( path, fileName )
		local content = UV_LoadFile( path, fileName )
		if not content then return nil end
	
		local lines = string.Split(content, "\n")
		local header = lines[1] or ""
		local params = string.Split(header, " ")
		local raceName = extractFullRaceName( params ) or "Unknown"
		local author = header:match("'(.-)'") or "Unknown"
		local propCount = 0
		local nodeCount = 0
		local checkpointCount = 0
		local spawnCount = 0
	
		-- for _, line in ipairs(lines) do
		-- 	if string.match(line, "^%d+%s") then
		-- 		local t = string.Explode(" ", line)
		-- 		local id = tonumber(t[1])
		-- 		if id and #t >= 8 then
		-- 			if not checkpoints[id] then
		-- 				checkpoints[id] = {}
		-- 				table.insert(idList, id)
		-- 			end
		-- 			table.insert(checkpoints[id], {
		-- 				start = Vector(tonumber(t[2]), tonumber(t[3]), tonumber(t[4])),
		-- 				endp  = Vector(tonumber(t[5]), tonumber(t[6]), tonumber(t[7])),
		-- 			})
		-- 		end
		-- 	elseif string.match(line, "^spawn") then
		-- 		local t = string.Explode(" ", line)
		-- 		if #t >= 6 then
		-- 			table.insert(spawns, Vector(tonumber(t[2]), tonumber(t[3]), tonumber(t[4])))
		-- 		end
		-- 	end
		-- end

		for _, line in ipairs(lines) do
			if string.match(line, "^%d+%s") then
				local t = string.Explode(" ", line)
				local id = tonumber(t[1])
				if id and #t >= 8 then
					checkpointCount = checkpointCount + 1
				end
			elseif string.match(line, "^spawn") then
				spawnCount = spawnCount + 1
			end
		end
		
		local jsonContent = UV_LoadFile( path, string.Replace( fileName, ".txt", ".json" ) )
		if jsonContent then
			local jsonData = util.JSONToTable(jsonContent)
			
			if jsonData then
				-- Count props (duplicator saves entities inside an array-style table)
				if jsonData.Entities and istable(jsonData.Entities) then
					for _, ent in pairs(jsonData.Entities) do
						if istable(ent) and ent.Class then
							-- Optional: only count actual props
							if string.StartWith(ent.Class, "prop_") then
								propCount = propCount + 1
							end
						end
					end
				end
								
				-- Count path nodes
				if jsonData.Nodes and istable(jsonData.Nodes) then
					nodeCount = table.Count(jsonData.Nodes)
				end
			end
		end
	
		return {
			name = raceName:Replace("_", " "),
			author = author,
			checkpoints = checkpointCount,
			spawns = spawnCount,
			props = propCount,
			nodes = nodeCount,
		}
	end

	function UV_SendRaceList( ply )
		local compressedList = util.Compress( util.TableToJSON( UVRaceList ) )

		net.Start( "UVRace_RaceList_Set" )
		net.WriteUInt( #compressedList, 16 )
		net.WriteData( compressedList, #compressedList )
		net.Send( ply )
	end

	function UV_RemoveRace( raceFile )
		for i, v in ipairs(UVRaceList) do
			if v.file == raceFile then
				table.remove( UVRaceList, i )
				break
			end
		end

		net.Start( "UVRace_RaceList_Remove" )
		net.WriteString( raceFile )
		net.Broadcast()
	end

	function UV_AddRace( raceFile )
		local raceData = ParseRaceFile( 'races>>' .. game.GetMap(), raceFile )

		local raceEntry = {
			file = raceFile,
			data = raceData
		}

		table.insert( UVRaceList, raceEntry )

		local compressedEntry = util.Compress( util.TableToJSON( raceEntry ) )
		local msgSize = #compressedEntry

		net.Start( "UVRace_RaceList_Add" )
		net.WriteUInt( msgSize, 16 )
		net.WriteData( compressedEntry, msgSize )
		net.Broadcast()
	end

	function UV_PopulateRaceList()
		local races = UV_GetFiles( 'races>>' .. game.GetMap() )

		for _, race in ipairs(races) do
			if string.EndsWith( race, ".json" ) then continue end
			local raceData = ParseRaceFile( 'races>>' .. game.GetMap(), race )

			table.insert( UVRaceList, {
				file = race,
				data = raceData
			} )
		end
		
		local compressedList = util.Compress( util.TableToJSON( UVRaceList ) )
		local msgSize = #compressedList

		net.Start( "UVRace_RaceList_Set" )
		net.WriteUInt( msgSize, 16 )
		net.WriteData( compressedList, msgSize )
		net.Broadcast()
	end

	function UVRace_BuildCompiledPaths(step)
		local compiled = {}

		for fromID, node in pairs(UVRace_Nodes) do
			for toID in pairs(node.Links) do
				local other = UVRace_Nodes[toID]
				if other then
					compiled[#compiled + 1] = {
						From = fromID,
						To = toID,
						Points = UVRace_GenerateInternalPath(node, other, step),
						StartSpeed = node.SpeedLimit or 0,
						EndSpeed = other.SpeedLimit or 0
					}
				end
			end
		end

		return compiled
	end

	function UVRace_RebuildCompiledPaths()
		UVRace_CompiledPaths = {}

		for fromID, node in pairs(UVRace_Nodes) do
			for toID in pairs(node.Links) do
				local other = UVRace_Nodes[toID]
				if not other then continue end

				local points = UVRace_GenerateInternalPath(node, other, 200)
				if not points or #points < 2 then continue end

				UVRace_CompiledPaths[#UVRace_CompiledPaths + 1] = {
					From = fromID,
					To = toID,
					Points = points,
					StartSpeed = node.SpeedLimit or 0,
					EndSpeed = other.SpeedLimit or 0
				}
			end
		end
	end

	function UVRaceClearNodes()
		for id, _ in pairs(UVRace_Nodes) do
			-- Inform clients to remove the node
			net.Start("UVRace_NodeRemove")
				net.WriteUInt(id, 16)
			net.Broadcast()
		end

		UVRace_Nodes = {}
		UVRace_NextNodeID = 0

		net.Start("UVRace_ClearAllNodes")
		net.Broadcast()
		
		UVRace_RebuildCompiledPaths()
	end

	function UVRaceCheckFinishLine()
		local checkpoints = ents.FindByClass( "uvrace_checkpoint" )
		local highestid = 0

		for _, checkpoint in pairs( checkpoints ) do
			local id = checkpoint:GetID() or 0
			if id > highestid then
				highestid = id --Highest ID is the finish line
			end
		end

		for _, checkpoint in pairs( checkpoints ) do --Recheck all checkpoints just to be sure
			local id = checkpoint:GetID() or 0
			if id == highestid then
				checkpoint:SetFinishLine( true )
			else
				checkpoint:SetFinishLine( false )
			end
		end

		SetGlobalInt( "uvrace_checkpoints", highestid )

		return highestid
	end

	function UVRaceMakeCheckpoints( laps )
		UVRaceRemoveCheckpoints() --Remove old checkpoints

		for _, ent in ipairs(ents.FindByClass("uvrace_checkpoint")) do
			local pos = (InfMap and ent:GetLocalPos()) or ent:GetPos()
			local mpos = (InfMap and ent:GetLocalMaxPos()) or ent:GetMaxPos()
			local chunk = (InfMap and ent:GetChunk()) or nil
			local maxChunk = (InfMap and ent:GetChunkMax()) or nil

			local check = ents.Create("uvrace_brushpoint")

			check:SetPos(pos)
			check:SetPos1(pos)
			check:SetPos2(mpos)
			check:SetChunk(chunk)
			check:SetChunkMax(maxChunk)
			check:SetID(ent:GetID())
			check:SetSpeedLimit(ent:GetSpeedLimit())
			check:SetFinishLine(ent:GetFinishLine())

			check:Spawn()
		end

		timer.Simple(2, function()
			UVRaceStart( laps )
		end)
	end

	function UVRaceRemoveCheckpoints()
		for _, ent in ipairs(ents.FindByClass("uvrace_brush*")) do
			ent:Remove()
		end
	end

	function UVBroadcastRacerList()
		local list = {}
		local seen = {}

		-- Inject host dynamically
		for _, ply in ipairs(player.GetAll()) do
			if UVRaceCurrentHost and ply == UVRaceCurrentHost then
				local veh = UVGetVehicle(ply)
				if IsValid(veh) then
					local id = veh:EntIndex()
					list[#list + 1] = {
						id = id,
						name = ply:Nick(),
						status = "Host",
						isAI = false,
						vehiclename = veh.PrintName or veh.VehicleName or veh:GetClass()
					}
					seen[id] = true
					break -- only one host
				end
			end
		end

		for id, data in pairs(UVRaceInvites) do
			if not IsValid(data.ent) then
				UVRaceInvites[id] = nil
			end
		end

		for id, data in pairs(UVRaceInvites) do
			if IsValid(data.ent) and not seen[data.ent:EntIndex()] then
				table.insert(list, { id = data.ent:EntIndex(), name = data.name, status = data.status, isAI = data.isAI, vehiclename = data.vehiclename })
				seen[data.ent:EntIndex()] = true
			end
		end

		net.Start("UVRace_RacersList")
		net.WriteTable(list)
		net.Broadcast()
	end

	function UVSetInviteByVehicle(vehicle, name, status)
		if not IsValid(vehicle) then return end
		local id = vehicle:EntIndex()
		local entry = UVRaceInvites[id]
		local isAI = not (IsValid(vehicle:GetDriver()) and vehicle:GetDriver():IsPlayer())
		local vehname = vehicle.PrintName 
		or vehicle.VehicleName 
		or vehicle:GetClass()

		if not entry then
			UVRaceInvites[id] = { ent = vehicle, name = name or ("Racer "..id), status = status, isAI = isAI, vehiclename = vehname }
		else
			-- Only update the status, never duplicate
			entry.status = status
			entry.name = name or entry.name
			entry.ent = vehicle
			entry.isAI = isAI
			entry.vehiclename = vehname
		end

		UVBroadcastRacerList()
	end

	-- Use vehicles as participants
	function UVRaceAddParticipant( vehicle, driver, sendmsg )
		if not IsValid(vehicle) then return end
		if table.HasValue(UVRaceCurrentParticipants, vehicle) then return end

		local id = vehicle:EntIndex()
		local name = (IsValid(driver) and driver:IsPlayer() and driver:Nick()) 
			or (vehicle.racer or "Racer " .. id)

		if UVRaceInvites[id] and UVRaceInvites[id].status == "Accepted" then
			return
		end

		table.insert( UVRaceCurrentParticipants, vehicle )
		UVSetInviteByVehicle(vehicle, (IsValid(driver) and driver:IsPlayer() and driver:Nick()) or vehicle.racer, "Accepted")

		vehicle.raceinvited = false
		timer.Remove('RaceInviteExpire'..vehicle:EntIndex())

		local driver = UVGetDriver(vehicle)
		local is_player 

		vehicle.racefinished = false
		vehicle.uvraceparticipant = true
		vehicle.racedriver = driver
		vehicle.isresetting = false

		if sendmsg then
			-- PrintMessage( HUD_PRINTTALK, name .. " has joined the race!" )
		end

		vehicle:CallOnRemove( "uvrace_participantremoved", function( ent )
			local driver = UVGetDriver( vehicle )

			if vehicle.isresetting then return end
			UVSetInviteByVehicle(ent, nil, "Disqualified")
			UVRaceRemoveParticipant( ent, 'Disqualified' )
		end )
	end

	function UVRaceReplaceParticipant( old_vehicle, new_vehicle )
		if UVRaceTable.Participants then
			if UVRaceTable.Participants and UVRaceTable.Participants[ old_vehicle ] then
				UVRaceTable.Participants[ new_vehicle ] = UVRaceTable.Participants[ old_vehicle ]
				UVRaceTable.Participants[ old_vehicle ] = nil
				-- if reason then
				--     net.Start( "uvrace_disqualify" )
				--     net.WriteEntity(vehicle)
				--     net.WriteString(reason)
				--     net.Broadcast()

				--     UVRaceTable.Participants [vehicle][reason] = true
				-- end
			end
		end

		old_vehicle.isresetting = true
		new_vehicle.hasreset = CurTime()

		UVRaceAddParticipant(new_vehicle)
		UVRaceRemoveParticipant(old_vehicle)

		timer.Simple(10, function()
			new_vehicle.hasreset = false
		end)

		net.Start( "uvrace_replace" )
		net.WriteEntity(old_vehicle)
		net.WriteEntity(new_vehicle)
		net.Broadcast()
	end

	function UVRaceRemoveParticipant( vehicle, reason )
		if UVRaceTable.Participants then
			if UVRaceTable.Participants and UVRaceTable.Participants[ vehicle ] then
				if reason then
					net.Start( "uvrace_disqualify" )
					net.WriteEntity(vehicle)
					net.WriteString(reason)
					net.Broadcast()

					UVRaceTable.Participants [vehicle][reason] = true
				end
			end
		end

		if table.HasValue( UVRaceCurrentParticipants, vehicle ) then
			table.RemoveByValue( UVRaceCurrentParticipants, vehicle )
			local driver = UVGetDriver( vehicle )
			-- if IsValid(driver) and driver:IsPlayer() then
			--     net.Start( "uvrace_end" )             
			--     net.Send( driver )
			-- end
		end

		vehicle:GetPhysicsObject():EnableMotion( true )

		vehicle.uvraceparticipant = false
		vehicle.racedriver = nil
		vehicle.currentcheckpoint = nil
		vehicle.currentlap = nil
		vehicle.lastlaptime = nil
		vehicle.bestlaptime = nil
		vehicle.streetraceinfraction = nil
	end

	function UVRaceStart( laps ) --Start procedure
		if #UVRaceCurrentParticipants == 0 then
			UVRaceEnd()
			PrintMessage( HUD_PRINTTALK, "No participants found!" )
			return 
		end

		local checkpoints = ents.FindByClass( "uvrace_brushpoint" )
		local dragrace = false
		if #checkpoints == 0 then
			UVRaceEnd()
			PrintMessage( HUD_PRINTTALK, "No checkpoints found!" )
			return
		elseif #checkpoints == 1 then --If theres only 1 checkpoint, assume its a drag race
			-- UVRaceLaps:SetInt( 1 ) -- Why?
			dragrace = true
		end

		local spawns = ents.FindByClass( "uvrace_spawn" )
		if #spawns == 0 then
			UVRaceEnd()
			PrintMessage( HUD_PRINTTALK, "No spawns found!" )
			return 
		end

		table.Empty(UVRaceTable)

		UVCounterActive = true

		UVRaceTable['Participants'] = {}
		UVRaceTable['Info'] = {
			['Started'] = false,
			['VisibleCheckpoints'] = UVRaceVisibleCheckpoints:GetBool(),
			['Laps'] = dragrace and 1 or laps or UVRaceLaps:GetInt(),
			['Racers'] = 0,
			['Time'] = 0
		}

		local starttimer = 8
		for i, vehicle in pairs( UVRaceCurrentParticipants ) do
			local driver = vehicle:GetDriver()
			local vehiclename = vehicle.PrintName 
			or vehicle.VehicleName 
			or vehicle:GetClass()

			UVRaceTable['Participants'][vehicle] = {
				['Lap'] = 1,
				['Position'] = i,
				['Name'] = ((IsValid(driver) and driver:GetName()) or (vehicle.racer or "Racer "..vehicle:EntIndex())),
				['IsAI'] = (not IsValid(driver) or not driver:IsPlayer()),
				--['Laps'] = {},
				--['BestLapTime'] = CurTime(),
				--['LastLapTime'] = CurTime(),
				['Finished'] = false,
				['Disqualified'] = false,
				['Busted'] = false,
				['Checkpoints'] = {},
				['Vehicle'] = vehicle,
				['VehicleName'] = vehiclename,
			}

			if IsValid(driver) and driver:IsPlayer() then
				net.Start( "uvrace_start" )
				net.WriteInt( starttimer, 11 )
				net.Send( driver )
				UVActionCam(driver, "RaceStart")
			end

			UVSetVehicleActive( vehicle, true )
		end

		net.Start( "uvrace_info" )
		net.WriteTable( UVRaceTable )
		net.Broadcast()

		timer.Create( "uvrace_start", 1, starttimer, function()
			local time = timer.RepsLeft( "uvrace_start" )
			for _, vehicle in pairs( UVRaceCurrentParticipants ) do
				local driver = UVGetDriver( vehicle )
				if driver then
					net.Start( "uvrace_start" )
					net.WriteInt( time, 11 )
					net.Send( driver )
				end
			end
			if time == 1 then
				UVRaceBegin()
				UVCounterActive = false
			end
		end)

	end

	function UVRaceBegin()
		--Unfreeze all participants
		for _, vehicle in pairs( UVRaceCurrentParticipants ) do
			vehicle:GetPhysicsObject():EnableMotion( true )
			vehicle:PhysWake()
			if vehicle.PursuitTech then
				for i, v in pairs(vehicle.PursuitTech) do
					v.LastUsed = CurTime()
					UVReplicatePT( vehicle, i )
				end
			end

			-- if UVRaceTable['Participants'] and UVRaceTable['Participants'][vehicle] then
			--     UVRaceTable['Participants'][vehicle]['LastLapTime'] = CurTime()
			-- end
		end

		--unclaim all spawns
		for _, spawn in pairs( ents.FindByClass( "uvrace_spawn" ) ) do
			spawn.claimed = nil
		end

		UVRaceStartTime = CurTime()
		UVRaceInProgress = true

		if UVRace_Nodes and #UVRace_Nodes > 0 then
			UVRace_UsingNodes = true
		else
			UVRace_UsingNodes = nil
		end

		UVRaceTable['Info']['Time'] = UVRaceStartTime

		net.Start( "uvrace_begin" )
		net.WriteFloat(UVRaceStartTime)
		net.Broadcast()

		local ptimer = UVRacePursuitStart:GetInt()
		if ptimer > 0 then
			UVHUDRacePursuitStartTime = CurTime()
			UVHUDRacePursuitEndTime = CurTime() + ptimer
			timer.Create( "uvrace_startpursuit", ptimer, 1, function()
				UV_StartPursuit(nil, true)
			end)
		end
	end

	function UVRaceEnd()
		uvbestlaptime = nil
		UVRaceInEffect = nil
		UVRaceInProgress = nil
		UVRaceCurrentHost = nil
		UVRaceFirstSplitTriggered = nil
		UVRace_UsingNodes = nil
		
		for _, ent in ipairs(ents.FindByClass("npc_racervehicle")) do
			if ent.ClearDestination then
				ent:ClearDestination()
			end
			ent.UV_CurrentNode = nil
		end
		
		net.Start("UVRace_TrackReady")
			net.WriteString("?")
			net.WriteString("?")
			net.WriteString("?")
		net.Broadcast()
		
		for _, v in ipairs(ents.GetAll()) do
			if IsValid(v) and v:IsVehicle() then
				v.raceinvited = nil
				v.uvraceparticipant = nil
				v.racedriver = nil
				v.racefinished = nil
				timer.Remove("RaceInviteExpire" .. v:EntIndex())
			end
		end

		UVRaceInvites = {}
		UVRaceCurrentParticipants = {}
		UVRace_RacerList = {}
		UVBroadcastRacerList()
		
		table.Empty(UVRaceTable)

		for _, vehicle in pairs(UVRaceCurrentParticipants) do
			UVRaceRemoveParticipant(vehicle)
		end

		if timer.Exists("uvrace_start") then
			timer.Remove("uvrace_start")
		end

		if timer.Exists("uvrace_startpursuit") then
			timer.Remove("uvrace_startpursuit")
		end
		
		UVHUDRacePursuitStartTime = nil
		UVHUDRacePursuitEndTime = nil
			
		table.Empty(UVRaceCurrentParticipants)

		for _, ent in ipairs(ents.FindByClass("uvrace_brush*")) do
			ent:Remove()
		end

		for _, ent in ipairs(ents.FindByClass("uvrace_checkpoint")) do
			ent:Remove()
		end

		for _, ent in ipairs(ents.FindByClass("uvrace_spawn")) do
			ent:Remove()
		end

		for entityId, entityObject in pairs( UVRace_LoadedEntities ) do
			if IsValid( entityObject ) then entityObject:Remove() end
			UVRace_LoadedEntities[entityId] = nil
		end

		for entityId, entityObject in pairs( UVRace_LoadedConstraints ) do
			if IsValid( entityObject ) then entityObject:Remove() end
			UVRace_LoadedConstraints[entityId] = nil
		end

		UVRaceClearNodes()

		if UVRace_LoadedWaypoints then
			--dvd.Waypoints = {}
			--concommand.Run(ply. "dv_route_load")
			dvd.LoadWaypoints( 'decentvehicle/' .. game.GetMap() )
			UVRace_LoadedWaypoints = false
		end
		
		if UVTargeting and #UVWantedTableVehicle > 0 and UVRacePursuitStop:GetBool() then
			UV_StopPursuit()
			if UVRacePursuitStopDespawn:GetBool() then
				UV_DespawnVehicles()
			end
		end
		
		if UVRaceClearAI:GetBool() then
			UV_ClearRacer()
		end
	end

	function UVCheckLapTime( vehicle, name, time )
		if not uvbestlaptime then
			uvbestlaptime = time
			local timedifference = 0

			net.Start("uvrace_announcebestlaptime")
			net.WriteFloat( time )
			net.WriteString( name )
			net.WriteFloat( timedifference )
			net.Broadcast()

		else
			if time < uvbestlaptime then
				local timedifference = uvbestlaptime - time
				uvbestlaptime = time

				net.Start("uvrace_announcebestlaptime")
				net.WriteFloat( time )
				net.WriteString( name )
				net.WriteFloat( timedifference )
				net.Broadcast()
			end
		end
	end

	function UVCheckRaceDisqualification( vehicle )
		if vehicle.uvbusted then
			UVRaceRemoveParticipant( vehicle, 'Busted' )
			return
		end

		-- Damage check
		if UVCheckIfWrecked(vehicle) and not vehicle.hasreset then
			UVRaceRemoveParticipant( vehicle, 'Disqualified' )
			
			UVPlayerWreck(vehicle)

			return
		end
	end

	net.Receive("UVRace_BeginEndCountdown", function(len, ply)
		if UVHUDRaceFinishCountdownStarted then return end

		timer.Create("UVRaceFinishCountdown", GetConVar("unitvehicle_racednftimer"):GetInt(), 1, function()
			UVRaceEnd()
			
			timer.Simple(0, function() -- Delay slightly to avoid conflict
				net.Start("uvrace_end")
				net.Broadcast()
			end)
		end)
	end)
	
	net.Receive("UVRace_StopEndCountdown", function(len, ply)
		if timer.Exists("UVRaceFinishCountdown") then
			timer.Remove("UVRaceFinishCountdown")
		end
		
	end)

	hook.Add("player_activate", "UVRaceArrayInit", function( data )

		local id = data.userid
		local ply = Player(id)

		-- timer.Simple(3, function()
		--     UVNotifyCenter( {ply}, "uv.test" , 'Hi', 'uv.unit.racer')
		-- end)

		if UVRaceInProgress then
			net.Start( "uvrace_info" )
			net.WriteTable( UVRaceTable )
			net.Send( ply )
		end
	end)

	hook.Add("PostCleanupMap", "UVRaceCleanup", function()
		if not UVRaceInEffect then return end

		UVRaceEnd()

		net.Start( "uvrace_end" )
		net.Broadcast()
	end)
	
	function UVValidateParticipants()
		local toRemove = {}
		local changed = false

		for id, data in pairs(UVRaceInvites) do
			local veh = data.ent

			if not IsValid(veh) then
				toRemove[#toRemove + 1] = id
				continue
			end

			local driver = veh:GetDriver()

			if not IsValid(driver) then
				toRemove[#toRemove + 1] = id
				continue
			end

			if data.driver ~= driver then
				data.driver = driver
				data.name = driver:Nick()
				changed = true
			end

			if not data.isAI and not driver:IsPlayer() then
				toRemove[#toRemove + 1] = id
				continue
			end

			if veh.wrecked or veh.uvbusted then
				toRemove[#toRemove + 1] = id
				continue
			end
		end

		if #toRemove > 0 then
			for _, id in ipairs(toRemove) do
				UVRaceInvites[id] = nil
			end
			changed = true
		end

		if changed then
			UVBroadcastRacerList()
		end
	end

	hook.Add("PlayerLeaveVehicle", "UVRaceLeaveVehicle", function(ply, veh) -- Participant leaves vehicle pre-race? Update list!
		UVBroadcastRacerList()
	end)
	
	hook.Add("PlayerEnteredVehicle", "UVRaceEnteredVehicle", function(ply, veh) -- Participant enters vehicle pre-race? Update list!
		UVBroadcastRacerList()
	end)
	
	local nextValidate = 0

	hook.Add("Think", "UVRaceValidateParticipants", function()
		if not UVRaceInEffect or UVRacePrep then return end
		if CurTime() < nextValidate then return end

		nextValidate = CurTime() + 0.25
		UVValidateParticipants()
	end)
	
	-- local lastHostVeh

	-- hook.Add("Think", "UVRaceHostVehicleWatch", function()
	-- 	if not UVRaceInEffect then return end

	-- 	for _, ply in ipairs(player.GetAll()) do
	-- 		if ply:IsSuperAdmin() then
	-- 			local veh = ply:GetVehicle()
	-- 			if IsValid(veh) and veh ~= lastHostVeh then
	-- 				lastHostVeh = veh
	-- 				UVBroadcastRacerList()
	-- 			end
	-- 			break
	-- 		end
	-- 	end
	-- end)

	hook.Add( "Think", "UVRacing", function( ply )
		if not UVRaceInEffect then return end
		if UVRacePrep then return end

		if next( UVRaceCurrentParticipants ) ~= nil then
			local pos = 0
			--local player_table = {}

			for _, vehicle in pairs( UVRaceCurrentParticipants ) do
				if IsValid( vehicle ) then
					UVCheckRaceDisqualification( vehicle )
				end
			end

		elseif not UVRacePrep then
			UVRaceEnd()
			net.Start( "uvrace_end" )
			net.Broadcast()
		end

	end)

	net.Receive( "uvrace_invite", function( len, ply ) 
		local bool = net.ReadBool()
		local car = UVGetVehicle( ply )

		if not car then return end
		if not car.raceinvited then return end

		local id = car:EntIndex()
		local entry = UVRaceInvites[id]
		if not entry then return end

		if bool then
			UVRaceAddParticipant( car, ply, true )
			entry.status = "Accepted"
			entry.vehiclename = car.PrintName or car.VehicleName or car:GetClass()
		else
			car.raceinvited = false;
			timer.Remove( 'RaceInviteExpire'..car:EntIndex() )
			entry.status = "Declined"
			timer.Simple(3, function()
				if UVRaceInvites[id] and UVRaceInvites[id].status == "Declined" then
					UVRaceInvites[id] = nil
					UVBroadcastRacerList()
				end
			end)
		end

		UVBroadcastRacerList()
	end)

	-- Decent Vehicle Waypoints fuckery, please expose the methods next time

	if not dvd then return end

	local function WriteWaypoint(id) -- ty dv lmao, plz expose the methods next time
		local waypoint = dvd.Waypoints[id]
		net.WriteUInt(id, 24)
		net.WriteVector(waypoint.Target)
		if waypoint.Chunk and dvd.IsInfMap then
			net.WriteVector(waypoint.Chunk or Vector(0,0,0)) -- InfMap, this is however a separate addon that is upcoming :3
		end
		net.WriteEntity(waypoint.TrafficLight or NULL)
		net.WriteBool(waypoint.FuelStation)
		net.WriteBool(waypoint.UseTurnLights)
		net.WriteFloat(waypoint.WaitUntilNext)
		net.WriteFloat(waypoint.SpeedLimit)
		net.WriteInt(waypoint.Group, 8)
		net.WriteUInt(#waypoint.Neighbors, 14)
		for i, n in ipairs(waypoint.Neighbors) do
			net.WriteUInt(n, 24)
		end
	end

	local function OverwriteWaypoints(source)
		local Exceptions = {Target = true, TrafficLight = true}
		if source == dvd then return end
		dvd.CVars.ForceHeadlights:SetInt(source.ForceHeadlights and 1 or 0) -- Added from version 1.0.7
		dvd.CVars.DriveSide:SetInt(source.DriveSide or 0)
		dvd.DriveSide = source.DriveSide or 0
		--ClearUndoList()
		table.Empty(dvd.Waypoints)
	
		if player.GetCount() > 0 then
			net.Start "Decent Vehicle: Sync CVar"
			net.Broadcast()
			net.Start "Decent Vehicle: Clear waypoints"
			net.Broadcast()
		end
	
		for i, t in ipairs(ents.GetAll()) do
			if t.IsDVTrafficLight then t:Remove() end
		end
	
		for i, w in ipairs(source) do
			local new = dvd.AddWaypoint(w.Target)
			for key, value in pairs(w) do
				if Exceptions[key] then continue end
				new[key] = value
			end
		end
	
		for _, t in ipairs(source.TrafficLights) do
			local traffic = ents.Create(t.ClassName)
			if not IsValid(traffic) then continue end
			traffic:SetPos(t.Pos)
			traffic:SetAngles(t.Ang)
			traffic:Spawn()
			traffic:SetPattern(t.Pattern)
			traffic.Waypoints = t.Waypoints
			for _, id in ipairs(t.Waypoints) do
				if not dvd.Waypoints[id] then continue end
				dvd.Waypoints[id].TrafficLight = traffic
			end
	
			local p = traffic:GetPhysicsObject()
			if IsValid(p) then p:Sleep() end
		end
	
		hook.Run("Decent Vehicle: OnLoadWaypoints", source)
	
		if #dvd.Waypoints * player.GetCount() == 0 then return end
		net.Start "Decent Vehicle: Retrive waypoints"
		dvd.WriteWaypoint(1)
		net.Broadcast()
	end
	
	local function LoadWaypoints(path)
		local pngpath = string.format("data/%s.png", path)
		local txtpath = string.format("data/%s.txt", path)
		local scriptpath = string.format("scripts/vehicles/%s.txt", path)
		local p
		if file.Exists(txtpath, "GAME") then
			p = txtpath
		elseif file.Exists(scriptpath, "GAME") then
			p = scriptpath
		elseif file.Exists(pngpath, "GAME") then
			p = pngpath
		end
	
		if p then
			local t = util.JSONToTable(util.Decompress(file.Read(p, "GAME") or "") or "")
			OverwriteWaypoints(t)
		end
	end

	dvd.LoadWaypoints = LoadWaypoints
	dvd.OverwriteWaypoints = OverwriteWaypoints
	dvd.WriteWaypoint = WriteWaypoint

	local function KillCheckpoints(ply)
		if not ply:IsSuperAdmin() then return end
		for _, ent in ipairs(ents.FindByClass("uvrace_checkpoint")) do
			ent:Remove()
		end
	end
	concommand.Add("uvrace_killcps", KillCheckpoints)
	
	local function KillSpawns(ply)
		if not ply:IsSuperAdmin() then return end
		for _, ent in ipairs(ents.FindByClass("uvrace_spawn")) do
			ent:Remove()
		end
	end
	concommand.Add("uvrace_killspawns", KillSpawns)
	
	local function KillAll(ply)
		if not ply:IsSuperAdmin() then return end
		for _, ent in ipairs(ents.FindByClass("uvrace_*")) do
			ent:Remove()
		end
	end
	concommand.Add("uvrace_killall", KillAll)
	
	local function StopRace(ply, cmd, args)
		if not ply:IsSuperAdmin() then return end
		UVRaceEnd()
		UVCounterActive = false
		
		net.Start( "uvrace_end" )
		net.Broadcast()
		
	end
	concommand.Add("uvrace_stop", StopRace)
	
	local function ProcessVehiclesInBatches(vehicles, batchSize, delay, callback, doneCallback)
		batchSize = batchSize or 12
		delay = delay or 0.1

		local batchesProcessed = 0
		local totalBatches = math.ceil(#vehicles / batchSize)

		for i = 1, #vehicles, batchSize do
			local startIndex = i  -- capture i locally for timer closure
			timer.Simple(delay * ((startIndex-1)/batchSize), function()
				local batch = {}
				for j = startIndex, math.min(startIndex + batchSize - 1, #vehicles) do
					table.insert(batch, vehicles[j])
				end

				-- Chat feedback
				-- PrintMessage(HUD_PRINTTALK, "Batch-moved " .. #batch .. " vehicles.")
				-- print("Batch-moved", #batch, "vehicles.")

				-- Move this batch
				callback(batch)

				-- Track completion
				batchesProcessed = batchesProcessed + 1
				if batchesProcessed == totalBatches and doneCallback then
					doneCallback()
				end
			end)
		end
	end

	local function StartRace(ply, cmd, args)
		if not ply:IsSuperAdmin() then return end
		if UVRaceInEffect then return end

		UVRaceInEffect = true

		if UVCounterActive then
			net.Start("uvrace_decline")
			net.WriteString("uv.race.start.error.startingpursuit")
			net.Send(ply)
			return
		end

		-- if UVTargeting then
		-- 	net.Start("uvrace_decline")
		-- 	net.WriteString("uv.race.start.error.chased")
		-- 	net.Send(ply)
		-- 	return
		-- end

		UV_DespawnVehicles()

		
		for v, _ in pairs( UVUnitVehicles ) do
			if IsValid(v) then
				v:Remove()
			end
		end

		for _, v in pairs( ents.FindByClass("npc_trafficvehicle") ) do
			if IsValid(v) then
				v:Remove()
			end
		end

		-- Add player vehicle if not already a participant
		for _, v in ents.Iterator() do
			if not table.HasValue(UVRaceCurrentParticipants, v) then
				if (v.IsGlideVehicle or v.IsSimfphyscar or v:GetClass() == "prop_vehicle_jeep" or v.LVS) and not v.wrecked and not v.UnitVehicle then
					local driver = UVGetDriver(v)
					if IsValid(driver) and driver:IsPlayer() and driver == ply then
						UVRaceAddParticipant(v, nil, true)
					end
				end
			end
		end

		-- Randomize starting order
		table.Shuffle(UVRaceCurrentParticipants)

		local ready_drivers = 0
		local batchSize = 12
		local delay = 0.025
		local participantsToProcess = table.Copy(UVRaceCurrentParticipants)

		local function processBatch(batch)
			for _, v in ipairs(batch) do
				local driver = UVGetDriver(v)

				if cffunctions then 
					CFtoggleNitrous(v, false)
					CFtoggleSpeedbreaker(v, false)
				end

				local ent = nil

				if UVRaceLegacySpawn:GetBool() then
					ent = UVMoveToGridSlotLegacy(v, not (driver and driver:IsPlayer()))
				else
					ent = UVMoveToGridSlot(v)
				end

				if ent then
					ready_drivers = ready_drivers + 1
				else
					UVRaceRemoveParticipant(v)
					table.RemoveByValue(participantsToProcess, v)
				end
			end
		end

		local function doneAllBatches()
			if ready_drivers <= 0 then
				return
			end

			-- Start the race
			UVRacePrep = true
			UVRaceInEffect = true

			UVRaceMakeCheckpoints(tonumber(args[1]))
			net.Start("UVRace_HideRacersList")
			net.Broadcast()

			timer.Simple(2, function()
				UVRacePrep = false
			end)
		end

		-- Process all vehicles in batches
		ProcessVehiclesInBatches(participantsToProcess, batchSize, delay, processBatch, doneAllBatches)
	end
	concommand.Add("uvrace_startrace", StartRace)
	
	local function StartRaceInvite(ply, cmd, args)
		if not ply:IsSuperAdmin() then return end
		if UVRaceInEffect then return end
		
		-- if UVTargeting then
		-- 	net.Start("uvrace_decline")
		-- 	net.WriteString("uv.race.invite.error.chased")
		-- 	net.Send(ply)
		-- 	return
		-- end
		
		local invited_racers = {}
		
		for _, v in ents.Iterator() do
			if not table.HasValue(UVRaceCurrentParticipants, v) then
				if (v.IsGlideVehicle or v.IsSimfphyscar or v:GetClass() == "prop_vehicle_jeep" or v.LVS) and not v.wrecked and not v.UnitVehicle and not v.uvbusted then

					local driver = UVGetDriver(v)
					local is_player = IsValid(driver) and driver:IsPlayer()

					if not v.raceinvited and (v.RacerVehicle or (is_player and driver ~= ply)) then
						
						table.insert(invited_racers, (is_player and driver:GetName()) or (v.racer or "Racer "..v:EntIndex()))
						v.raceinvited = true
						v.lastraceinv = CurTime()
						
						local name = (is_player and driver:Nick()) or (v.racer or "Racer " .. v:EntIndex())

						UVSetInviteByVehicle(v, name, "Invited")

						if is_player then
							net.Start("uvrace_invite")
							net.Send(driver)
						end

						timer.Create("RaceInviteExpire"..v:EntIndex(), 10.25, 1, function()
							v.raceinvited = false
							UVRaceInvites[v:EntIndex()] = nil
							UVBroadcastRacerList()
						end)
					end
				end
			end
		end
		
		
		if #invited_racers > 0 then
			net.Start("uvrace_racerinvited")
			net.WriteTable(invited_racers)
			net.Send(ply)
		end
	end
	concommand.Add("uvrace_startinvite", StartRaceInvite)
	concommand.Add("uvrace_spawnai", function()
		UVAutoSpawnRacer()
	end)
	
	local function Import(ply, cmd, args)
		if not ply:IsSuperAdmin() then return end
		local raceBaseData = UV_LoadFile( 'races>>' .. game.GetMap(), args[1] )
		if not raceBaseData then return end

		if UVRace_LoadedWaypoints then
			--dvd.Waypoints = {}
			--concommand.Run("dv_route_load")
			dvd.LoadWaypoints( 'decentvehicle/' .. game.GetMap() )
			UVRace_LoadedWaypoints = false
		end

		for entityId, entityObject in pairs( UVRace_LoadedEntities ) do
			if IsValid( entityObject ) then entityObject:Remove() end
			UVRace_LoadedEntities[entityId] = nil
		end

		for entityId, entityObject in pairs( UVRace_LoadedConstraints ) do
			if IsValid( entityObject ) then entityObject:Remove() end
			UVRace_LoadedConstraints[entityId] = nil
		end

		UVRaceClearNodes()

		local jsonfilename = string.Replace( args[1], ".txt", ".json" )
		local raceExtraData = UV_LoadFile( 'races>>' .. game.GetMap(), jsonfilename )
		if raceExtraData then UVLoadRace( raceExtraData ) end
		
		timer.Simple(0.2, function()
			local entList = raceBaseData:Split("\n")

			local metaLine = entList[1]
			local trackName, author = "UNKNOWN", "UNKNOWN"

			if metaLine then
				local nameExtracted, authorExtracted = metaLine:match("^name%s+(.+)%s+'(.+)'$")
				if nameExtracted then trackName = nameExtracted end
				if authorExtracted then author = authorExtracted end
			end

			if UVRaceInEffect then
				UVRaceEnd()
			end

			--Delete all checkpoints and spawns
			for _, ent in ipairs(ents.FindByClass("uvrace_brush*")) do
				ent:Remove()
			end
			for _, ent in ipairs(ents.FindByClass("uvrace_checkpoint")) do
				ent:Remove()
			end
			for _, ent in ipairs(ents.FindByClass("uvrace_spawn")) do
				ent:Remove()
			end

			if not UVGame then
				undo.Create("UVRaceEnt")
				undo.SetPlayer(ply)
			end

			for _, data in ipairs(entList) do
				local params = data:Split(" ")

				local cid = tonumber(params[1])
				if cid then
					local check = ents.Create("uvrace_checkpoint")

					local speedlimit = tonumber(params[8]) or 0
					local posx, posy, posz = tonumber(params[2]), tonumber(params[3]), tonumber(params[4])
					local mx, my, mz = tonumber(params[5]), tonumber(params[6]), tonumber(params[7])

					--print(posx, posy, posz, mx, my, mz)

					local localposx, localposy, localposz = tonumber(params[9]), tonumber(params[10]), tonumber(params[11])
					local localmx, localmy, localmz = tonumber(params[12]), tonumber(params[13]), tonumber(params[14])
					local chunkx, chunky, chunkz = tonumber(params[15]), tonumber(params[16]), tonumber(params[17])
					local chunkmx, chunkmy, chunkmz = tonumber(params[18]), tonumber(params[19]), tonumber(params[20])

					local pos = Vector(posx, posy, posz)
					check:SetPos(pos)
					check:SetMaxPos(Vector(mx, my, mz))
					check:SetID(cid)
					check:SetSpeedLimit(speedlimit)
					if InfMap then
						check:SetLocalPos(Vector(localposx, localposy, localposz))
						check:SetLocalMaxPos(Vector(localmx, localmy, localmz))
						check:SetChunk(Vector(chunkx, chunky, chunkz))
						check:SetChunkMax(Vector(chunkmx, chunkmy, chunkmz))
					end
					check:Spawn()

					if not UVGame then
						undo.AddEntity(check)
						ply:AddCleanup("uvrace_ents", check)
					end
				elseif params[1] == "spawn" then
					local spawn = ents.Create("uvrace_spawn")

					local posx, posy, posz = tonumber(params[2]), tonumber(params[3]), tonumber(params[4])
					spawn:SetPos(Vector(posx, posy, posz))

					local angy = tonumber(params[5])
					spawn:SetAngles(Angle(0, angy, 0))

					spawn:SetGridSlot(tonumber(params[6]))

					spawn:Spawn()

					if not UVGame then
						undo.AddEntity(spawn)
						ply:AddCleanup("uvrace_ents", spawn)
					end
				end
			end

			if not UVGame then
				undo.AddFunction(function(undoTable, ent)
					if UVRace_LoadedWaypoints then
						--concommand.Run()
						dvd.LoadWaypoints( 'decentvehicle/' .. game.GetMap() )
						UVRace_LoadedWaypoints = false
					end

					UVRaceEnd()
					UVCounterActive = false
					UVRaceCurrentHost = nil
				
					net.Start( "uvrace_end" )
					net.Broadcast()
				end)
				undo.Finish()
			end

			local tname = args[1]:Split(".")[2]

			UVRaceCurrentHost = ply

			net.Start("UVRace_TrackReady")
			net.WriteString(trackName:Replace("_", " "))
			net.WriteString(author)
			net.WritePlayer(ply)
			net.Broadcast()
			UVBroadcastRacerList()
		end)
	end
	concommand.Add("uvrace_import", Import)

else -- CLIENT stuff
	UVHUDGlobalBestLapTime = UVHUDGlobalBestLapTime or nil
	UVHUDGlobalBestLapHolder = UVHUDGlobalBestLapHolder or nil
	UVPreRaceInfo = CreateClientConVar( "unitvehicle_preraceinfo", 0, true, false, "Set to 1 to have a cinematic-like race details list when a race begins." )
	--UVRaceDNFTimer = CreateClientConVar( "unitvehicle_racednftimer", 30, true, false, "How long, once one racer crosses the line, the rest have to finish before DNF'ing." )
	--UVRaceVisibleCheckpoints = CreateClientConVar( "unitvehicle_racevisiblecheckpoints", 1, true, false, "Whether to show the checkpoints to the players." )
	--UVRacePursuitStart = CreateClientConVar( "unitvehicle_racepursuitstart", 0, true, false, "How long, once one race begins, before a pursuit auto-starts." )
	--UVRacePursuitStop = CreateClientConVar( "unitvehicle_racepursuitstop", 0, true, false, "If a pursuit is active, immediately stop the pursuit when the race ends." )
	--UVRacePursuitStopDespawn = CreateClientConVar( "unitvehicle_racepursuitstop_despawn", 0, true, false, "If a pursuit is active, despawn all AI units when the race ends." )
	--UVRaceClearAI = CreateClientConVar( "unitvehicle_raceclearai", 0, true, false, "Removes all AI and their vehicles when the race ends." )

	UVRacingTheme = CreateClientConVar("unitvehicle_racetheme", "default", true, false, "Unit Vehicles: The theme of the current race.")
	UVRacingThemeShuffle = CreateClientConVar("unitvehicle_racetheme_shuffle", 1, true, false, "Unit Vehicles: If set to 1, the race theme will be shuffled.")
	UVRacingSFXTheme = CreateClientConVar("unitvehicle_sfxtheme", "unbound", true, false, "Unit Vehicles: The SFX theme of the current race.")
	
	UVGlideSpeedometer = CreateClientConVar("unitvehicle_speedometer_enable", 0, true, false, "Unit Vehicles: If enabled, allow Glide vehicles to utilize a custom speedometer from the chosen HUD Type, if it has one.")
	UVSpeedometer = CreateClientConVar("unitvehicle_speedometer", "mostwanted", true, false, "Unit Vehicles: Which custom speedometer to utilize.")

	-- local files, folders = file.Find( "sound/uvracemusic/*", "GAME" )
	-- if folders ~= nil then
	-- 	if not table.HasValue( folders, GetConVar("unitvehicle_racetheme"):GetString() ) then
	-- 		GetConVar("unitvehicle_racetheme"):SetString("default")
	-- 	end	
	-- end
	
	function UVSoundRacingStop()
		UVPlayingRace = false
		-- if UVPlayingRace then
		--     if timer.Exists("UVRaceMusicTransition") then
		--         timer.Remove("UVRaceMusicTransition")
		--     end

		--     UVPlayingRace = false
		-- end
	end

	function UVGetRandomSound(folder)
		local files = file.Find("sound/" .. folder .. "/*", "GAME")
		if files and #files > 0 then
			table.Shuffle(files)
			return folder .. "/" .. files[1]
		end
		return nil
	end

	function UVGetRaceMusicPath(theme, my_vehicle)
		local isFinalLap = IsValid(my_vehicle)
			and UVHUDRaceLaps > 1
			and UVHUDRaceLaps == UVHUDRaceInfo["Participants"][my_vehicle].Lap

		local endingPath = "uvracemusic/" .. theme .. "/ending"
		local racePath = "uvracemusic/" .. theme .. "/race"

		if isFinalLap then
			local endingTrack = UVGetRandomSound(endingPath)
			if endingTrack then return endingTrack end
		end

		return UVGetRandomSound(racePath)
	end

	local musicMetadata = {}

	local function loadMusicMetadata()
		local files = file.Find("data_static/music_*.json", "GAME")
		for _, filename in ipairs(files) do
			local path = "data_static/" .. filename
			local data = file.Read(path, "GAME")

			if data then
				local ok, tbl = pcall(util.JSONToTable, data)
				if ok and tbl then
					musicMetadata[filename] = tbl
				end
			end
		end
	end

	-- Call once at script load or addon init:
	loadMusicMetadata()

	local function escape_pattern(text)
		return text:gsub("([^%w])", "%%%1")
	end

	local function normalizePath(path)
		return string.lower(path):gsub("\\", "/")
	end

	local function caseInsensitiveLookup(metaTable, path)
		for key, value in pairs(metaTable) do
			if key:lower() == path:lower() then
				return value
			end
		end
		return nil
	end

	local function lookupTrackInMetadata(norm_path)
		for _, metaTable in pairs(musicMetadata) do
			local entry = caseInsensitiveLookup(metaTable, norm_path)
			if entry then
				return entry.artist, entry.title, entry.folder
			end
		end
		return nil
	end

	local placeholder_map = { -- Used for Official UV Trax Packs
		[",,"] = ".",
		[";;"] = "?",
		["-;-"] = "/",
		["=="] = ":",
		["-!-"] = "\"",
	}

	local ALLOWED_TRACKFOLDERS = {
		["race"] = true,
		["ending"] = true,
		["intro"] = true,
		["transition"] = true,
	}

	cvars.AddChangeCallback("unitvehicle_racetheme", function(_, _, new)
		UVCurrentPlaylist = UVTraxLoadPlaylist( new ) or UVTraxLoadPlaylist( "default" )
		if UVPlayingRace then UVStopSound() end
	end, "UVTraxPlaylists")

	cvars.AddChangeCallback("unitvehicle_racetheme_shuffle", function(_, _, new)
		UVCurrentPlaylist = UVTraxLoadPlaylist( GetConVar("unitvehicle_racetheme"):GetString() ) or UVTraxLoadPlaylist( "default" )
		if UVPlayingRace then UVStopSound() end
	end, "UVTraxPlaylists")

	UVDefaultPlaylists = {}
	UVPlaylists = {}

	if not file.IsDir("unitvehicles/uvtrax", "DATA") then file.CreateDir( "unitvehicles/uvtrax", "DATA" ) end
	if not file.IsDir("unitvehicles/uvtrax/playlists", "DATA") then file.CreateDir( "unitvehicles/uvtrax/playlists", "DATA" ) end
	if not file.Exists("unitvehicles/uvtrax/settings.json", "DATA") or util.JSONToTable( file.Read("unitvehicles/uvtrax/settings.json", "DATA") ) == nil then
		file.Write( "unitvehicles/uvtrax/settings.json", file.Read("data_static/uvtrax_settings.json", "GAME") )
	end

	UVTraxSettings = util.JSONToTable( file.Read("unitvehicles/uvtrax/settings.json", "DATA") )

	function UVTraxUpdateSettings( key, value )
		local stack = UVTraxSettings
		local hay = string.Explode( ">>", key )
		local needle = hay[#hay]

		for i, v in ipairs( hay ) do
			if i == #hay then break end
			if type( stack ) ~= "table" then stack = {} break end
			if stack[v] == nil then stack[v] = {} end
			
			stack = stack[v]
		end

		stack[needle] = value

		file.Write( "unitvehicles/uvtrax/settings.json", util.TableToJSON(UVTraxSettings, true) )
	end

	function UVTraxPopulatePlaylists()
		local _, themeFolders = file.Find( "sound/uvracemusic/*", "GAME" )
		if themeFolders == nil or not next(themeFolders) then return end

		--local curTime = CurTime()

		for _, themeFolder in ipairs( themeFolders ) do
			local _, trackFolders = file.Find( "sound/uvracemusic/" .. themeFolder .. "/*", "GAME" )
			if trackFolders == nil or not next( trackFolders ) then continue end

			UVPlaylists[themeFolder] = {}
			UVDefaultPlaylists[themeFolder] = true

			for _, trackFolder in ipairs( trackFolders ) do
				if not ALLOWED_TRACKFOLDERS[trackFolder] then continue end

				local tracks = file.Find( "sound/uvracemusic/" .. themeFolder .. "/" .. trackFolder .. "/*", "GAME" )
				if tracks == nil or not next( tracks ) then continue end

				UVPlaylists[themeFolder][trackFolder] = {}

				for _, track in ipairs( tracks ) do
					local trackPath = "sound/uvracemusic/" .. themeFolder .. "/" .. trackFolder .. "/" .. track
					local artist, title, folder = lookupTrackInMetadata(trackPath)

					if not artist and not title and not folder then
						for placeholder, char in pairs(placeholder_map) do
							track = string.gsub(track, escape_pattern(placeholder), char):gsub("%.mp3", ""):gsub("%.wav", ""):gsub("%.ogg", "")
						end

						local parts = string.Explode(" - ", track)
						artist = (#parts == 1) and "Unknown Artist" or parts[1]
						title = (#parts == 1) and track or parts[2]
						folder = themeFolder
					end

					table.insert( UVPlaylists[themeFolder][trackFolder], {
						path = trackPath,
						artist = artist,
						title = title,
						folder = folder,
					} )
				end
			end
		end

		local playlists = file.Find( "unitvehicles/uvtrax/playlists/*", "DATA" )
		for _, playlist in ipairs( playlists ) do
			local playlistData = util.JSONToTable( file.Read( "unitvehicles/uvtrax/playlists/" .. playlist, "DATA" ) )

			if playlistData then
				UVPlaylists[playlist:gsub(".json", "")] = playlistData
			end
		end

		--print(curTime - CurTime(), "seconds to populate playlists")
	end

	UVTraxPopulatePlaylists()

	UVTrackPointers = {
		["race"] = 0,
		["ending"] = 0,
		["intro"] = 0,
		["transition"] = 0,
	}

	function UVTraxModifyPlaylist( playlist, trackType, trackData )
		if not UVPlaylists[playlist] then return false end
		if UVDefaultPlaylists[playlist] then return false end

		for i, track in ipairs(UVPlaylists[playlist][trackType]) do
			if track.path == trackData.path then
				table.remove( UVPlaylists[playlist][trackType], i )
				return true
			end
		end

		table.insert( UVPlaylists[playlist][trackType], trackData )
		file.Write( "unitvehicles/uvtrax/playlists/" .. playlist .. ".json", util.TableToJSON(UVPlaylists[playlist], true) )
		return true
	end

	function UVTraxDeletePlaylist( playlist )
		if not UVPlaylists[playlist] then return false end
		if UVDefaultPlaylists[playlist] then return false end

		UVPlaylists[playlist] = nil
		file.Delete( "unitvehicles/uvtrax/playlists/" .. playlist .. ".json" )
		return true
	end

	function UVTraxCreatePlaylist( playlist )
		if UVPlaylists[playlist] then return false end

		for key, _ in pairs( UVDefaultPlaylists ) do
			if key:lower() == playlist:lower() then
				return false
			end
		end

		local playlistArray = {
			["race"] = {},
			["ending"] = {},
			["intro"] = {},
			["transition"] = {},
		}

		UVPlaylists[playlist] = playlistArray
		file.Write( "unitvehicles/uvtrax/playlists/" .. playlist .. ".json", util.TableToJSON(playlistArray, true) )
		return playlistArray
	end

	function UVTraxLoadPlaylist( playlist )
		if not playlist or not UVPlaylists[playlist] then return false end

		UVCurrentPlaylistString = playlist
		UVCurrentPlaylist = table.Copy( UVPlaylists[playlist] )

		for trackType, tracks in pairs(UVCurrentPlaylist) do
			local newTracks = {}

			for _, track in ipairs(tracks) do
				if not UVTraxSettings.playlists[playlist] then
					local array = {}
					for trackType, _ in pairs( ALLOWED_TRACKFOLDERS ) do array[trackType] = {} end
					UVTraxUpdateSettings( "playlists>>" .. playlist , array )
				end

				local isCustomPlaylist = not UVDefaultPlaylists[playlist]
				local isValid = not isCustomPlaylist or file.Exists( track.path, "GAME" )

				if not UVTraxSettings.playlists[playlist][trackType][track.path] and isValid then table.insert( newTracks, track ) end
			end

			if UVRacingThemeShuffle:GetBool() then
				table.Shuffle(newTracks)
			end

			UVCurrentPlaylist[trackType] = newTracks
		end

		for trackType, _ in pairs( UVTrackPointers ) do UVTrackPointers[trackType] = 0 end

		return UVCurrentPlaylist
	end

	function UVTraxSetTrackDisabled( playlist, trackType, trackPath, disabled )
		if not UVTraxSettings.playlists[playlist] then
			UVTraxUpdateSettings( "playlists>>" .. playlist , {
				["race"] = {},
				["ending"] = {},
				["intro"] = {},
				["transition"] = {},
			} )
		end

		UVTraxUpdateSettings( "playlists>>" .. playlist .. ">>" .. trackType .. ">>" .. trackPath, disabled or nil )

		if UVCurrentPlaylistString == playlist then
			UVCurrentPlaylist = UVTraxLoadPlaylist( playlist )
			if UVPlayingRace then UVStopSound() end
		end
	end

	--UVCurrentPlaylist = UVTraxLoadPlaylist( "test" )

	UVCurrentPlaylist = UVTraxLoadPlaylist(GetConVar("unitvehicle_racetheme"):GetString()) or UVTraxLoadPlaylist("default")
	-- print( UVTraxCreatePlaylist( "test" ) )
	
	-- local found = false
	-- for _, v in ipairs(UVPlaylists["test"]["race"]) do
	-- 	if v.path == "sound/uvracemusic/nightrunners/race/binary.mp3" then
	-- 		found = true
	-- 		break
	-- 	end
	-- end
	-- if not found then
	-- 	UVTraxModifyPlaylist( "test", "race", {
	-- 		path = "sound/uvracemusic/nightrunners/race/binary.mp3",
	-- 		artist = "asc",
	-- 		title = "binary",
	-- 		folder = "nightrunners",
	-- 	})
	-- end

	-- UVTraxModifyPlaylist( "test", "race", {
	-- 	path = "sound/uvracemusic/nightrunners/race/3c.mp3",
	-- 	artist = "Carbon",
	-- 	title = "Bending Light",
	-- 	folder = "nightrunners",
	-- })
	-- UVTraxToggleTrack( UVCurrentPlaylistString, "race", "sound/uvracemusic/nightrunners/race/3c.mp3", true )

	local function PlayRaceMusic(theme, my_vehicle)
		local track = UVGetRaceMusicPath(theme, my_vehicle)
		local jsonFiles = file.Find("data_static/music_*.json", "GAME")

		if track then
			UVPlaySound(track, true)
		end

		if not string.find(track, "/race/") then return end
		track = track:gsub("uvracemusic/" .. theme .. "/race/", ""):gsub("%.mp3", ""):gsub("%.wav", ""):gsub("%.ogg", "")

		-- Rebuild the full normalized path for lookup (lowercase, forward slash)
		local full_path = normalizePath("sound/uvracemusic/" .. theme .. "/race/" .. track .. ".mp3")

		-- Lookup metadata in JSON tables

		local artist, title, folder = lookupTrackInMetadata(full_path)
		local notificationText

		if artist and title and folder then -- Use metadata from JSON (original casing)
			notificationText = "<color=255,126,126>" .. UVString("uv.race.radio") .. "</color>\n" .. title .. "\n" .. "<color=200,200,200>" .. artist .. "\n" .. folder .. "</color>"
		else
			for placeholder, char in pairs(placeholder_map) do
				track = string.gsub(track, escape_pattern(placeholder), char)
			end
			if string.find(track, " - ", 1, true) then -- Fallback to parsing track name or showing raw track/folder
				local parts = string.Explode(" - ", track)
				notificationText = "<color=255,126,126>*" .. UVString("uv.race.radio") .. "</color>\n"  .. parts[2] .. "\n" .. "<color=200,200,200>" .. parts[1] .. "\n" .. theme .. "</color>"
			else
				notificationText = "<color=255,126,126>*" .. UVString("uv.race.radio") .. "</color>\n"  .. track .. "\n" .. "<color=200,200,200>" .. theme .. "</color>"
			end
		end

		if Glide then
			Glide.Notify({
				text = notificationText,
				icon = "unitvehicles/icons/ICON_EA_TRAX.png",
				lifetime = 3,
				immediate = true,
			})
		else
			chat.AddText( Color(255, 255, 255), "[", Color(255, 126, 126), UVString("uv.race.radio"), Color(255, 255, 255), "] ", Color(255, 255, 0), (artist and title) and (title .. " - " .. artist) or track, Color(255, 255, 255), " (", Color(200, 200, 200), theme, Color(255, 255, 255), ")")
		end
	end

	function UVTraxDisplayTrack( artist, title, folder, path )
		if title == "" or not title then return end
		local notificationText = "<color=255,126,126>" .. UVString("uv.race.radio") .. "</color>\n" .. title .. "\n" .. "<color=200,200,200>" .. artist .. "\n" .. folder .. "</color>\n\n" .. UVReplaceKeybinds( string.format( "%s " .. UVString("uv.keybind.prevsong"),"[key:unitvehicle_keybind_prevsong]") ) .. "\n" .. UVReplaceKeybinds( string.format( "%s " .. UVString("uv.keybind.skipsong"),"[key:unitvehicle_keybind_skipsong]") )

		if Glide then
			Glide.Notify({
				text = notificationText,
				icon = "unitvehicles/icons/ICON_EA_TRAX.png",
				lifetime = 3,
				immediate = true,
			})
		else
			chat.AddText( Color(255, 255, 255), "[", Color(255, 126, 126), UVString("uv.race.radio"), Color(255, 255, 255),"] ", Color(255, 255, 0), (artist and title) and (title .. " - " .. artist) or title, Color(255, 255, 255), " (", Color(200, 200, 200), folder, Color(255, 255, 255), ")")
		end
	end

	function UVTraxPlayNextTrack( trackType, increment, trackNumber )
		if not UVCurrentPlaylist[trackType] or #UVCurrentPlaylist[trackType] == 0 then return false end
		if not UVTrackPointers[trackType] then UVTrackPointers[trackType] = 0 end

		UVTrackPointers[trackType] = ( trackNumber or UVTrackPointers[trackType] + ( increment or 1 ) ) % #UVCurrentPlaylist[trackType]
		if UVTrackPointers[trackType] == 0 then UVTrackPointers[trackType] = #UVCurrentPlaylist[trackType] end

		UVPlayingRace = true

		local track = UVCurrentPlaylist[trackType][UVTrackPointers[trackType]]
		local path, artist, title, folder = track.path, track.artist, track.title, track.folder

		local func = function() UVTraxDisplayTrack( artist, title, folder, path ) end
		UVPlaySound( path:sub(1, 6) == "sound/" and path:gsub( "sound/", "", 1 ) or path, true, nil, nil, nil, func )

		return true
	end

	function UVSoundRacing(my_vehicle)
		if not UVTraxFreeroam:GetBool() and not RacingThemeOutsideRace:GetBool() then
			if not RacingMusic:GetBool() or (RacingMusicPriority:GetBool() and UVHUDDisplayPursuit) then return end
			if (not UVHUDRace) then return end 
		end

		if UVHUDDisplayRacing and not RacingMusic:GetBool() then return end
		if UVPlayingRace or UVPlayingEscaped or UVSoundDelayed then return end

		if timer.Exists("UVRaceMusicTransition") then
			timer.Remove("UVRaceMusicTransition")
		end

		if timer.Exists("UVPursuitThemeReplay") then
			timer.Remove("UVPursuitThemeReplay")
		end

		UVRacePlayMusic = true

		if UVRacePlayIntro then
			UVRacePlayIntro = false
			UVRacePlayTransition = false
		    UVTraxPlayNextTrack("intro", 1)
		elseif UVRacePlayTransition then
			UVRacePlayTransition = false
			UVTraxPlayNextTrack("transition", 1)
		elseif UVRacePlayMusic then
			UVRacePlayMusic = false
			UVRacePlayTransition = true

			local isVehicleValid = IsValid(my_vehicle)
			local hasMultipleLaps = UVHUDRaceLaps > 1
			local isFinalLap = isVehicleValid and hasMultipleLaps and UVHUDRaceLaps == UVHUDRaceInfo["Participants"][my_vehicle].Lap

			if not UVTraxPlayNextTrack(isFinalLap and "ending" or "race", 1) then
				UVTraxPlayNextTrack("race", 1)
			end
		end

		-- local theme = GetConVar("unitvehicle_racetheme"):GetString()

		-- if UVRacePlayIntro then
		-- 	UVRacePlayIntro = false
		-- 	UVPlayingRace = true
		-- 	--UVRacePlayMusic = true

		-- 	local introTrack = UVGetRandomSound("uvracemusic/" .. theme .. "/intro")
		-- 	if introTrack then
		-- 		UVPlaySound(introTrack, true)
		-- 	else
		-- 		PlayRaceMusic(theme, my_vehicle)
		-- 		UVRacePlayTransition = true
		-- 	end
		-- elseif UVRacePlayTransition then
		-- 	UVRacePlayTransition = false 
		-- 	UVPlayingRace = true

		-- 	local transitionTrack = UVGetRandomSound("uvracemusic/" .. theme .. "/transition")

		-- 	if transitionTrack then
		-- 		UVPlaySound(transitionTrack, true)
		-- 	else
		-- 		PlayRaceMusic(theme, my_vehicle)
		-- 		UVRacePlayTransition = true
		-- 	end
		-- elseif UVRacePlayMusic then
		-- 	UVPlayingRace = true
		-- 	UVRacePlayTransition = true
		-- 	--UVRacePlayMusic = false 

		-- 	PlayRaceMusic(theme, my_vehicle)
		-- end

		UVPlayingHeat = false
		UVPlayingBusting = false
		UVPlayingCooldown = false
		UVPlayingBusted = false
		UVPlayingEscaped = false
	end

	function UVDisplayTimeRace(time) -- include milliseconds in the string
		local formattedtime = string.FormattedTime( time )

		local hours = math.floor( time / 3600 )
		if hours < 1 then
			timestring = string.format( "%02d:%02d", formattedtime.m, formattedtime.s )
		else
			timestring = string.format( "%02d:%02d:%02d", formattedtime.h, formattedtime.m, formattedtime.s )
		end

		local milliseconds = math.floor( ( time - math.floor( time ) ) * 1000 )
		timestring = timestring .. string.format( ".%03d", milliseconds )

		return timestring
	end

	function UVStopRacing()
		if not UVHUDDisplayRacing then return end

		UVSoundRacingStop()

		--UVHUDRaceCurrentCheckpoint = nil;
		UVHUDDisplayRacing = false;
		--UVHUDRace = false;

		if _UVCurrentCheckpoint and _UVCurrentCheckpoint.blip then
			_UVCurrentCheckpoint.blip.alpha = 0
		end
		if _UVNextCheckpoint and _UVNextCheckpoint.blip then
			_UVNextCheckpoint.blip.alpha = 0
		end
	end

	--

	if not UVHUDRaceInfo then
		UVHUDRaceInfo = {}
	end

	if not UVHUDRaceTime or not UVHUDRace then
		UVHUDRaceTime = UVDisplayTimeRace(0)
	end

	if not UVHUDRaceLaps then
		UVHUDRaceLaps = 1
	end

	if not UVHUDRaceCurrentLap then
		UVHUDRaceCurrentLap = 1
	end

	if not UVHUDRaceCurrentParticipants then
		UVHUDRaceCurrentParticipants = 1
	end

	if not UVHUDDisplayRacing then
		UVHUDDisplayRacing = false
	end

	function UVRaceNotify( message, duration ) --, duration
		local duration = duration or 5

		UVHUDNotificationString = message
		UVHUDNotification = true 
		timer.Simple( duration, function()
			UVHUDNotification = false
		end)
	end

	concommand.Add( "uvrace_resetposition", function()
		if (not UVResetDelay) or (CurTime() - UVResetDelay > 1) then
			UVResetDelay = CurTime()
		else return end

		net.Start("UVResetPosition"); net.SendToServer()
	end)

	concommand.Add( "uv_skipsong", function()
		if (not UVSkipDelay) or (CurTime() - UVSkipDelay > 1) then
			UVSkipDelay = CurTime()
		else return end

		if not UVPlayingRace then return end
		UVTraxPlayNextTrack( "race", 1 )
	end)

	concommand.Add( "uv_prevsong", function()
		if (not UVPrevDelay) or (CurTime() - UVPrevDelay > 1) then
			UVPrevDelay = CurTime()
		else return end

		if not UVPlayingRace then return end
		UVTraxPlayNextTrack( "race", -1 )
	end)
	
	concommand.Add("uvrace_queryimport", function()
		UVMenu.OpenMenu(UVMenu.RaceManagerTrackSelect, true)
	end)
	
	concommand.Add("uvrace_racemenu", function()
		UVMenu.OpenMenu(UVMenu.RaceManagerStartRace, true)
	end)

	net.Receive( "uvrace_notification", function()
		UVRaceNotify( net.ReadString(), net.ReadFloat() )
	end)

	net.Receive( "uvrace_decline", function() 
		local lang = UVString

		-- chat.AddText(Color(255, 126, 126),lang( net.ReadString() ))
		
		UV_UI.general.events.CenterNotification({
            text = lang( net.ReadString() ),
			color = Color(255, 126, 126),
		})
	end)

	net.Receive( "uvrace_announcebestlaptime", function()
		local time = net.ReadFloat()
		local driver = net.ReadString()
		local timedifference = net.ReadFloat()
		local lang = UVString

		if timedifference ~= 0 then
			-- chat.AddText(Color(255, 255, 255), string.format(lang("uv.race.newbestlap.new"), driver), Color(0, 255, 255), UVDisplayTimeRace(time), Color(255, 255, 255), " (-"..math.Round(timedifference, 3)..")")
		else
			-- chat.AddText(Color(255, 255, 255), string.format(lang("uv.race.newbestlap"), driver), Color(0, 255, 255), UVDisplayTimeRace(time))
		end
	end)

	net.Receive( "uvrace_racerinvited", function() 
		local racers = net.ReadTable()

		for _, v in pairs(racers) do
			-- chat.AddText(Color(255, 255, 255), UVString("uv.race.invite.sentto"), Color(0,255,0), v)
		end
	end)

	-- Functions to edit racer attributes
	net.Receive( "uvrace_checkpointpassed", function() 
		local participant = net.ReadEntity()
		local checkpoint = net.ReadInt(11)
		local time = net.ReadInt(32)

		if UVRaceTable then
			if UVRaceTable['Participants'] and UVRaceTable['Participants'][participant] then
				UVRaceTable['Participants'][participant]['Checkpoints'][checkpoint] = time
			end
		end
	end)

	net.Receive( "uvrace_info", function()
		UVHUDRaceInfo = net.ReadTable()

		UVHUDRaceTime = UVDisplayTimeRace( UVHUDRaceInfo['Info']['Time'] )
		UVHUDRaceLaps = UVHUDRaceInfo['Info']['Laps']
		UVHUDRaceRacerCount = UVHUDRaceInfo['Info']['Racers']

		local my_vehicle, my_array

		for vehicle, array in pairs(UVHUDRaceInfo['Participants']) do
			if IsValid(vehicle) and vehicle:GetDriver() == LocalPlayer() then
				my_vehicle, my_array = vehicle, array
				break
			end
		end

		if my_array then
			UVHUDRaceCurrentCheckpoint = #my_array['Checkpoints']
			UVHUDRaceCurrentPos = my_array['Position']
			UVHUDRaceCurrentLap = my_array['Lap']
		else
			UVHUDRaceCurrentCheckpoint = nil
		end

		if not UVHUDRace then
			UVHUDRace = true
			UVHUDRaceCheckpoints = GetGlobalInt( "uvrace_checkpoints" )

			local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
			local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/start/*", "GAME" )
			if #soundfiles > 0 then
				table.Shuffle(soundfiles)
				surface.PlaySound( "uvracesfx/".. theme .."/start/".. soundfiles[1] )
			end
		end
	end)

	net.Receive( "uvresetfailed", function()
		UVHUD_CloseTimedBar("reset")

		UV_UI.general.events.CenterNotification({
            text = UVString( net.ReadString() ),
		})
	end)

	net.Receive("uvresetcountdown", function()
		local time_left = net.ReadInt(16)

		UVHUD_AddTimedBar( "reset", time_left, "uv.resetting", 10, string.format( UVString("uv.chase.select.spawning.cooldown2"), UVReplaceKeybinds( "[key:unitvehicle_keybind_resetposition]", "Big" ) ) )
	end)

	net.Receive("uvresetpenalty", function()
		local time_left = net.ReadInt(16)

		UVHUD_AddTimedBar( "reset_penalty", time_left, "uv.resetting.penalty2", 50, "uv.resetting.penalty", nil, true )
	end)

	net.Receive( "uvrace_invite", function()
		UVMenu.OpenMenu(UVMenu.RaceInvite, true)
	end)

	UVRaceStarting = false

	net.Receive( "uvrace_end", function()
		UVRaceCountdown = nil
		UVRaceCinematicOverlay = nil

		UVHUDRaceFinishCountdownStarted = false
		UVHUDRaceFinishEndTime = nil
		UVRaceStarting = false

		if not UVHUDRace then return end

		UVHUDRace = false

		for vehicle, array in pairs( UVHUDRaceInfo.Participants ) do
			if IsValid( vehicle ) and vehicle:GetDriver() == LocalPlayer() then array.LocalPlayer = true end
		end
		
		UVHUD_CloseTimedBar( "race_end" )

		UVWorldCountdown = nil
		hook.Remove("HUDPaint", "UV_Countdown_World")

		net.Start("UVRace_StopEndCountdown")
		net.SendToServer()

		if UVPlayingRace then
			UVPlayingRace = false
		end

		if RacingMusic:GetBool() then 
			local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
			local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/end/*", "GAME" )
			if #soundfiles > 0 then
				table.Shuffle(soundfiles)
				surface.PlaySound( "uvracesfx/".. theme .."/end/".. soundfiles[1] )
			end
		end

		hook.Run( 'UIEventHook', 'racing', 'onRaceEnd', UVFormLeaderboard( UVHUDRaceInfo.Participants ) )

		UVHUDRaceInfo = nil
	end)

	net.Receive( "uvrace_checkpointcomplete", function()
		local participant = net.ReadEntity()
		local checkpoint = net.ReadInt(11)
		local time = net.ReadFloat()

		if UVHUDRaceInfo then
			if UVHUDRaceInfo['Participants'] and UVHUDRaceInfo['Participants'][participant] then
				UVHUDRaceInfo['Participants'][participant]['Checkpoints'][checkpoint] = time
			end
		end

		if IsValid(participant) then
			local driver = participant:GetDriver()

			if driver == LocalPlayer() then
				local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
				local mutesfx = GetConVar("unitvehicle_mutecheckpointsfx"):GetBool()
				local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/checkpointpass/*", "GAME" )
				if not mutesfx and #soundfiles > 0 then
					table.Shuffle(soundfiles)
					surface.PlaySound( "uvracesfx/".. theme .."/checkpointpass/".. soundfiles[1] )
				end
			end
		end
	end)

	net.Receive( "uvrace_checkpointsplit", function()
		local participant = net.ReadEntity()
		local checkpoint = net.ReadInt(11)
		local numParticipants = net.ReadUInt(8)

		if not IsValid(participant) then return end

		local driver = participant:GetDriver()
		local is_local_player = (driver == LocalPlayer())

		hook.Run( "UIEventHook", "racing", "onLapSplit", participant, checkpoint, is_local_player, numParticipants )
	end)

	net.Receive( "uvrace_racecomplete", function()
		local participant = net.ReadEntity()
		local place = net.ReadInt(32)
		local time = net.ReadFloat()

		if UVHUDRaceInfo then
			if UVHUDRaceInfo['Participants'] and UVHUDRaceInfo['Participants'][participant] then
				local participantInfo = UVHUDRaceInfo['Participants'][participant]

				UVHUDRaceInfo['Participants'][participant].Finished = true
				UVHUDRaceInfo['Participants'][participant].TotalTime = time

				if not UVHUDRaceFinishCountdownStarted and (GetConVar("unitvehicle_racednftimer"):GetInt() > 0) then -- DNF Timer
					net.Start("UVRace_BeginEndCountdown")
					net.SendToServer()
					
					UVHUDRaceFinishCountdownStarted = true
					UVHUDRaceFinishEndTime = CurTime() + GetConVar("unitvehicle_racednftimer"):GetInt()

					UVHUD_AddTimedBar( "race_end", GetConVar("unitvehicle_racednftimer"):GetInt(), "uv.race.endsin", 5 )
				end

				if IsValid(participant) and participant:GetDriver() == LocalPlayer() and RacingMusic:GetBool() then
					UVHUDRaceInfo['Participants'][participant].LocalPlayer = true

					local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
					local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/"..((place == 1 and "win") or "loss").."/*", "GAME" )
					if soundfiles and #soundfiles > 0 then
						table.Shuffle(soundfiles)
						local audio_path = "uvracesfx/".. theme .."/"..((place == 1 and "win") or "loss").."/".. soundfiles[1]
						surface.PlaySound(audio_path)
					end
				end

				local lang = UVString
				local PlaceStrings = {
					[1] = { Color(240,203,122) },
					[2] = { Color(183,201,210) },
					[3] = { Color(179,128,41) },
					[4] = { Color(27,147,0) },
				}

				local place_array = PlaceStrings[place] or PlaceStrings[4]
				-- chat.AddText(Color(255,255,255), UVHUDRaceInfo['Participants'][participant].Name, lang("uv.race.finishtext.1"), place_array[1], lang("uv.race.pos.num." .. place), Color(255,255,255), lang("uv.race.finishtext.2"), Color(0,255,0), UVDisplayTimeRace(time))

				local driver = participant:GetDriver()
				local is_local_player = IsValid(driver) and driver == LocalPlayer()

				hook.Run( 'UIEventHook', 'racing', 'onParticipantFinished', {
					['Participant'] = participant,
					['is_local_player'] = is_local_player,
					['Place'] = place,
					['TotalTime'] = time,
					['BestTime'] = participantInfo.BestLapTime
				} )
			end
		end
	end)

	net.Receive( "uvrace_disqualify", function()
		local participant = net.ReadEntity()
		local reason = net.ReadString()			
		local driver = IsValid(participant) and participant:GetDriver()
		local is_local_player = IsValid(driver) and driver == LocalPlayer()

		if UVHUDRaceInfo then
			if UVHUDRaceInfo['Participants'] and UVHUDRaceInfo['Participants'][participant] then
				if reason == 'Busted' or reason == 'Disqualified' then

					if IsValid(participant) and participant:GetDriver() == LocalPlayer() and RacingMusic:GetBool() then
						local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
						local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/loss/*", "GAME" )
						if soundfiles and #soundfiles > 0 then
							table.Shuffle(soundfiles)
							local audio_path = "uvracesfx/".. theme .."/loss/".. soundfiles[1]
							surface.PlaySound(audio_path)
						end
					end

					UVHUDRaceInfo['Participants'][participant][reason] = true
				end
			end
			if reason == 'Disqualified' and #UVHUDWantedSuspects < 1 then
				hook.Run( 'UIEventHook', 'racing', 'onParticipantDisqualified', {
					['Participant'] = participant,
					['is_local_player'] = is_local_player,
				} )
			end
		end
	end)

	net.Receive( "uvrace_replace", function() 
		local old_entity = net.ReadEntity()
		local new_entity = net.ReadEntity()

		if UVHUDRaceInfo and UVHUDRaceInfo ['Participants'] then
			if UVHUDRaceInfo ['Participants'][old_entity] then
				UVHUDRaceInfo ['Participants'][new_entity] = UVHUDRaceInfo ['Participants'][old_entity]
				UVHUDRaceInfo ['Participants'][old_entity] = nil
			end
		end
	end)

	net.Receive( "uvrace_begin", function()
		local time = net.ReadFloat()

		UVRacePlayIntro = true
		UVRacePlayMusic = true 
		UVRacePlayTransition = false

		UVPlayingRace = false

		if UVHUDRaceInfo and UVHUDRaceInfo['Info'] then
			UVHUDRaceInfo['Info'].Started = true
			UVHUDRaceInfo['Info'].Time = time
		end

		-- Reset best lap times and other lap data on race start
		if CLIENT then
			UVHUDGlobalBestLapTime = nil
			UVHUDGlobalBestLapHolder = nil
		end

		if UVHUDRaceInfo and UVHUDRaceInfo['Participants'] then
			for participant, data in pairs(UVHUDRaceInfo['Participants']) do
				data.BestLapTime = nil
				data.LastLapTime = nil
				data.LastLapCurTime = nil
			end
		end
	end)

	net.Receive( "uvrace_lapcomplete", function()
		local participant = net.ReadEntity()
		local time = net.ReadFloat()
		local timecur = net.ReadFloat()
		local lang = UVString

		if not UVHUDRaceInfo then return end
		if not UVHUDRaceInfo.Participants[participant] then return end

		local old_lap = UVHUDRaceInfo['Participants'][participant].Lap
		local new_lap = old_lap + 1

		local lap_time = nil
		local lap_time_cur = nil

		if UVHUDRaceInfo then
			if UVHUDRaceInfo['Participants'] and UVHUDRaceInfo['Participants'][participant] then
				UVHUDRaceInfo['Participants'][participant].Lap = UVHUDRaceInfo['Participants'][participant].Lap +1

				if not UVHUDRaceInfo['Participants'][participant].BestLapTime or UVHUDRaceInfo['Participants'][participant].LastLapTime > time then
					UVHUDRaceInfo['Participants'][participant].BestLapTime = time
				end

				UVHUDRaceInfo['Participants'][participant].LastLapTime = time
				UVHUDRaceInfo['Participants'][participant].LastLapCurTime = timecur

				lap_time = time
				lap_time_cur = timecur
				table.Empty(UVHUDRaceInfo['Participants'][participant]['Checkpoints'])
			end
		end

		local address = ((IsValid(participant) and participant:GetDriver() == LocalPlayer() and lang("uv.race.you")) or (UVHUDRaceInfo['Participants'] and UVHUDRaceInfo['Participants'][participant] and UVHUDRaceInfo['Participants'][participant].Name))

		local is_global_best = false

		-- Per-player best lap update (no chat)
		if UVHUDLastLapTime == nil then
			UVHUDLastLapTime = time
			UVHUDBestLapTime = time
		else
			if time < UVHUDBestLapTime then
				UVHUDLastLapTime = time
				UVHUDBestLapTime = time
			else
				UVHUDLastLapTime = time
			end
		end

		-- Global best lap update and flag set
		if UVHUDGlobalBestLapTime == nil or time < UVHUDGlobalBestLapTime then
			UVHUDGlobalBestLapTime = time
			UVHUDGlobalBestLapHolder = participant
			is_global_best = true
		end

		local is_local_player = IsValid(participant) and participant:GetDriver() == LocalPlayer()
		local total_laps = UVHUDRaceInfo.Info and UVHUDRaceInfo.Info.Laps or 0
		local num_participants = (UVHUDRaceInfo and UVHUDRaceInfo.Participants) and table.Count(UVHUDRaceInfo.Participants) or 0

		if num_participants <= 1 then
			is_global_best = false
		end

		local local_finished = false
		local user_finished = false

		if total_laps > 0 and old_lap == total_laps then
			user_finished = true             -- anyone crossing final lap
			if is_local_player then
				local_finished = true       -- only local player
			end
		end

		local lap_final = (total_laps > 1 and new_lap == total_laps)

		-- Decide if notification should be suppressed
		local suppress_lap_ui = (total_laps <= 1 or new_lap > total_laps) and not is_global_best

		hook.Run( 'UIEventHook', 'racing', 'onLapComplete', participant, new_lap, old_lap, lap_time, lap_time_cur, is_local_player, is_global_best, lap_final, local_finished, user_finished, suppress_lap_ui )
	end)
	
	net.Receive("UVRace_HideRacersList", function()
		UVRaceStarting = true
	end)

	net.Receive( "uvrace_start", function()
		local time = net.ReadInt( 11 )
		local theme = GetConVar("unitvehicle_sfxtheme"):GetString()

		local startTable = {}
		for i = 0, time do
			startTable[i] = i
		end
	
		-- Pick correct sound
		local sound = nil
		if time == 1 then
			local files = file.Find("sound/uvracesfx/" .. theme .. "/countgo/*", "GAME")
			table.Shuffle(files)
			if #files > 0 then
				sound = "uvracesfx/" .. theme .. "/countgo/" .. files[1]
			end
			UVRaceCinematicOverlay = nil
		elseif time == 2 then
			local files = file.Find("sound/uvracesfx/" .. theme .. "/count1/*", "GAME")
			table.Shuffle(files)
			if #files > 0 then
				sound = "uvracesfx/" .. theme .. "/count1/" .. files[1]
			end
		elseif time == 3 then
			local files = file.Find("sound/uvracesfx/" .. theme .. "/count2/*", "GAME")
			table.Shuffle(files)
			if #files > 0 then
				sound = "uvracesfx/" .. theme .. "/count2/" .. files[1]
			end
		elseif time == 4 then
			local files = file.Find("sound/uvracesfx/" .. theme .. "/count3/*", "GAME")
			table.Shuffle(files)
			if #files > 0 then
				sound = "uvracesfx/" .. theme .. "/count3/" .. files[1]
			end
		end

		local label = startTable[time] - 1 or UVString("uv.race.getready")

		if time == 1 then
			label = UVString("uv.race.go")
		end

		if time > 4 and not UVRaceCinematicOverlay then
			UVRaceCinematicOverlay = {
				startTime = CurTime(),
				slideInDuration = 0.5,
				slideOutDuration = 0.5,
				state = "slidingIn",  -- can be "slidingIn", "holding", or "slidingOut"
				holdStartTime = nil,
			}
		end
		
		-- Play sound
		if sound then
			surface.PlaySound(sound)
		end

		-- Setup countdown display state
		UVRaceCountdown = {
			startTime = CurTime(),        -- When this label appeared
			label = label,               -- The current label ("3", "2", etc.)
			stage = time,                -- Numeric stage to identify what’s next
			alpha = 255,                 -- Current alpha
		}
		
		-- For the UI
		hook.Run("UIEventHook", "racing", "onRaceStartTimer", { starttime = time })
	end)

	net.Receive( "UVRace_RaceList_Set", function()
		local msgSize = net.ReadUInt( 16 )
		local compressedList = net.ReadData( msgSize )

		local list = util.JSONToTable( util.Decompress( compressedList ) )
		UVRaceList = list
	end )

	net.Receive( "UVRace_RaceList_Add", function()
		local msgSize = net.ReadUInt( 16 )
		local compressedList = net.ReadData( msgSize )

		local list = util.JSONToTable( util.Decompress( compressedList ) )

		for i, v in ipairs( UVRaceList ) do
			if v.file == list.file then
				UVRaceList[i] = list
				return
			end
		end

		table.insert( UVRaceList, list )
	end )

	net.Receive( "UVRace_RaceList_Remove", function()
		local fileName = net.ReadString()
		
		for i, race in ipairs(UVRaceList) do
			if race.filename == fileName then
				table.remove( UVRaceList, i )
				break
			end
		end
	end )

	local ALLOWED_SPEEDOMETER_CLASSES = {
		'base_glide_car',
		'base_glide_bike',
		'base_glide_tank',
		'base_glide_motorcycle',
	}

	local speedotype = GetConVar("unitvehicle_speedometer"):GetString()
	
	hook.Add("Glide_CanDrawHUD", "UV_DisableGlideHUD", function(vehicle)
		if UVGlideSpeedometer:GetBool() and (UV_UI.speedometer[speedotype] and UV_UI.speedometer[speedotype].main) then
			if table.HasValue( ALLOWED_SPEEDOMETER_CLASSES, vehicle.BaseClass.ClassName ) then
				return false
			end
		end
	end)

	local smoothedSpeed = 0

	hook.Add("HUDPaint", "UVHUDRace", function()
		local w, h = ScrW(), ScrH()
		local hudyes = GetConVar("cl_drawhud"):GetBool()
		local hudtype = GetConVar("unitvehicle_hudtype_main"):GetString()
		local speedotype = GetConVar("unitvehicle_speedometer"):GetString()

		-- Custom speedometer code
		if Glide and UVGlideSpeedometer:GetBool() and IsValid(Glide.currentVehicle) and (UV_UI.speedometer[speedotype] and UV_UI.speedometer[speedotype].main) and table.HasValue( ALLOWED_SPEEDOMETER_CLASSES, Glide.currentVehicle.BaseClass.ClassName ) then
			local speed = Glide.currentVehicle:GetVelocity():Length()

			-- smooth it (adjust 8–12 for responsiveness)
			smoothedSpeed = Lerp(FrameTime() * 10, smoothedSpeed, speed)

			local kmh = math.floor(smoothedSpeed * 3600 * 0.0000254 * 0.75)
			local mph = math.floor(smoothedSpeed * 3600 / 63360 * 0.75)

			-- local kmh = math.floor(speed * 3600 * 0.0000254 * 0.75)
			-- local mph = math.floor(speed * 3600 / 63360 * 0.75)

			local gear = Glide.currentVehicle:GetGear()
			local rpm = math.floor(Glide.currentVehicle:GetEngineRPM())
			local maxrpm = math.floor(Glide.currentVehicle:GetMaxRPM())
			
			local throttle = math.Round(Glide.currentVehicle:GetEngineThrottle(), 3)

			local gearText = gear
			if gear == -1 then gearText = "R"
			elseif gear == 0 then gearText = "N" end

			local speedval = Glide.Config.useKMH and kmh or mph
			local speedname = Glide.Config.useKMH and "KMH" or "MPH"

			local redlining = false
			local redlinestrength = (Glide.currentVehicle.stream and Glide.currentVehicle.stream.redlineFrequency) or 0
			
			local health = Glide.currentVehicle:GetEngineHealth()
			health = math.max(0, math.min(1, health))
			
			local cfnitrousenabled = Glide.currentVehicle:GetNWBool( 'NitrousEnabled' )
			local cfsbenabled = Glide.currentVehicle:GetNWBool( 'SpeedbreakerEnabled' )
			
			local cfnitrousamount = Glide.currentVehicle:GetNWFloat( 'NitrousAmount' ) or 0
			local cfsbamount = Glide.currentVehicle:GetNWFloat( 'SpeedbreakerAmount' ) or 0
			
			if Glide.currentVehicle.stream and Glide.currentVehicle.stream.isRedlining then
				redlining = true
			end

			local text = "<font=UVFont5UI>" ..
			"RPM: " .. rpm .. " / " .. maxrpm .. "\n" .. 
			"Speed: " .. speedval .. " " .. speedname .. "\n" ..
			"Gear: " .. gearText .. "\n" .. 
			"Throttle: " .. throttle .. "\n" .. 
			"Redlining: " .. (redlining and "+ " .. redlinestrength or "-") .. "\n" .. 
			"Durability: " .. math.Round(health * 100, 2) .. "%" .. "\n" .. 
			"CF Nitrous: " .. math.Round(cfnitrousamount * 100, 2) .. "%" .. "\n" .. 
			"CF Speedbreaker: " .. math.Round(cfsbamount * 100, 2) .. "%" .. "\n" .. 
			"</font>"

			-- markup.Parse(text, w):Draw(w - (w * 0.25), h - 70, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM) -- DEBUGGING
			
			if hudyes then
				UV_UI.speedometer[speedotype].main( speedval, speedname, gear, rpm, maxrpm, throttle, redlining, redlinestrength, health, cfnitrousenabled, cfnitrousamount, cfsbenabled, cfsbamount, kmh, mph )
				
				-- Draw weapon switch notification
				if Glide.currentVehicle.weaponSwitchNotification then
					local notif = Glide.currentVehicle.weaponSwitchNotification

					Glide.DrawWeaponSelection( notif.name, notif.icon )

					if RealTime() > notif.time then
						Glide.currentVehicle.weaponSwitchNotification = nil
					end
				end

				local localPly = LocalPlayer()

				-- Let the weapon class draw it's own HUD
				if Glide.currentVehicle:GetDriver() == localPly then
					local weapon = Glide.currentVehicle.weapons[Glide.currentVehicle.weaponSlotIndex]

					if weapon then
						weapon:DrawHUD( w, h )
					end
				end

				-- If we have a custom crosshair, draw it now
				local crosshair = Glide.currentVehicle.crosshair

				if crosshair then
					Glide.currentVehicle:UpdateCrosshairPosition()

					local pos = crosshair.origin:ToScreen()

					if pos.visible then
						Glide.DrawWeaponCrosshair( pos.x, pos.y, crosshair.icon, crosshair.size, crosshair.color )
					end
				end
			end
		end

		-- Timed bars
		for _, bar in pairs(UVHUDTimedBars) do
			if bar.hidden and CurTime() >= bar.endTime then
				bar.closeTime = CurTime()
			end
		end

		local best = UVHUD_GetTopBar()

		if best and best ~= UVHUDActiveBar then
			if UVHUDActiveBar and best.priority > UVHUDActiveBar.priority then
				UVHUDActiveBar.hidden = true
			end

			best.hidden = false
			if best ~= UVHUDActiveBar then
				best.startTime = CurTime()
			end

			UVHUDActiveBar = best
		end

		if UVHUDActiveBar then
			UVHUD_TimedBar(UVHUDActiveBar)
			
			if UVHUDActiveBar.closeTime then
				if CurTime() - UVHUDActiveBar.closeTime > 0.25 then

					UVHUDTimedBars[UVHUDActiveBar.id] = nil
					UVHUDActiveBar = nil

				end
			end
		end

		-- if UVHUDRaceFinishCountdownStarted and not UVHUDCopMode then
			-- DrawTimedBar(UVHUDRaceFinishStartTime, UVHUDRaceFinishEndTime, "uv.race.endsin")
		-- end
		
		-- if timer.Exists("uvrace_startpursuit") and not UVHUDCopMode then
			-- DrawTimedBar(UVHUDRacePursuitStartTime, UVHUDRacePursuitEndTime, "uv.race.endsin")
		-- end

		-- Advanced Countdown & GET READY
		if UVRaceCountdown and hudyes then
			local elapsed = CurTime() - UVRaceCountdown.startTime

			-- Case 1: Pre-race "GET READY" for countdown > 4
			if UVRaceCountdown.stage > 4 and GetConVar("unitvehicle_preraceinfo"):GetInt() == 0 and not UV_UI.racing[hudtype].noready then
				local alpha = 255
				draw.SimpleTextOutlined(UVString("uv.race.getready"), "UVFont5ShadowBig", w*0.5, h*0.35, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,alpha))
				-- draw.SimpleTextOutlined(string.format("%.1f", elapsed), "UVFont5ShadowBig", w*0.5, h*0.45, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,alpha))
				return
			end

			-- Case 2: Race countdown 4 -> 1 and GO
			if UV_UI.racing[hudtype] and not UV_UI.racing[hudtype].events.onRaceStartTimer and UVRaceCountdown.stage >= 1 and UVRaceCountdown.stage <= 4 then
				local value = tostring(UVRaceCountdown.label)
				local scale = (UVRaceCountdown.stage == 1) and 3.4 or 2.4
				local alpha = UVRaceCountdown.alpha
				local color = (UVRaceCountdown.stage == 1) and Color(255,255,255) or Color(255,255,255)

				-- Animations
				local t = elapsed
				if UVRaceCountdown.stage ~= 1 then
					if t < 0.06 then
						scale = 1.45
						alpha = 255
					elseif t < 0.16 then
						local p = (t-0.06)/0.10
						scale = Lerp(p,1.45,1.75)
					elseif t < 0.28 then
						local p = (t-0.16)/0.12
						scale = Lerp(p,1.75,1.35)
					elseif t < 0.62 then
						scale = 1.35
					elseif t < 0.78 then
						local p = (t-0.62)/0.16
						scale = Lerp(p,1.35,7.5)
						alpha = Lerp(p,255,0)
					else
						UVRaceCountdown = nil
						return
					end
				else
					-- GO text animation
					if t < 0.01 then
						scale = 3.6
						alpha = 0
					elseif t < 0.08 then
						local p = (t-0.01)/0.07
						scale = Lerp(p,7.5,1.55)
						alpha = Lerp(p,0,255)
					elseif t < 0.38 then
						local p = (t-0.08)/0.30
						scale = Lerp(p,1.55,1.45)
					elseif t < 0.95 then
						scale = 1.45
					elseif t < 1.15 then
						local p = (t-0.95)/0.20
						scale = Lerp(p,1.45,7.5)
						alpha = Lerp(p,255,0)
					else
						UVRaceCountdown = nil
						return
					end
				end

				-- Draw text
				local cx, cy = w*0.5, h*0.35
				local m = Matrix()
				m:Translate(Vector(cx, cy, 0))
				m:Scale(Vector(scale, scale, 1))
				m:Translate(Vector(-cx, -cy, 0))

				cam.PushModelMatrix(m)
				draw.SimpleTextOutlined(value, "UVFont5", cx, cy, Color(color.r, color.g, color.b, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,alpha))
				cam.PopModelMatrix()
			end
		end
		
		if not UVHUDRace then UVHUDDisplayRacing = false; return end
		if not UVHUDRaceInfo then UVHUDDisplayRacing = false; return end
		if not (UVHUDRaceInfo.Info and UVHUDRaceInfo.Info.Started) then UVHUDDisplayRacing = false; return end

		if UVHUDRaceFinishCountdownStarted and not UVHUDRaceAnimTriggered then
			UVHUDRaceAnimTriggered = true
			UVHUDRaceFinishStartTime = CurTime()
		end

		if not UVHUDRaceFinishCountdownStarted then
			UVHUDRaceAnimTriggered = false
		end

		local my_vehicle, my_array = nil, nil

		for vehicle, array in pairs(UVHUDRaceInfo['Participants']) do
			if IsValid(vehicle) and vehicle:GetDriver() == LocalPlayer() then
				my_vehicle, my_array = vehicle, array
				break
			end
		end

		if not my_vehicle then UVStopRacing() return end
		if my_array.Finished or (my_array.Disqualified or my_array.Busted) then
			-- clean up
			UVStopRacing()
			return
		end

		UVHUDDisplayRacing = true
		if not UVHUDDisplayPursuit or (UVHUDDisplayPursuit and not RacingMusicPriority:GetBool()) and RacingMusic:GetBool() then
			UVSoundRacing( my_vehicle )
		end

		local var = UVKeybindResetPosition:GetInt()

		if input.IsKeyDown(var) and not gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
			LocalPlayer():ConCommand('uvrace_resetposition')
		end

		--UVHUDRace = true;
		local sorted_table, string_array = UVFormLeaderboard(UVHUDRaceInfo['Participants'])

		UVHUDRaceCurrentParticipants = 0

		for i, v in ipairs(sorted_table) do
			UVHUDRaceCurrentParticipants = UVHUDRaceCurrentParticipants +1
			if v.vehicle == my_vehicle then
				UVHUDRaceCurrentPos = i
			end
		end

		local checkpoint_count = #my_array['Checkpoints']
		local lap_count = my_array['Lap']
		
		UVHUDRaceCurrentLap = lap_count

		-- used by checkpoint entities
		UVHUDRaceCurrentCheckpoint = checkpoint_count

		for _, v in pairs( ents.FindByClass("uvrace_checkpoint") ) do
			if not UVHUDRaceInfo.Info.VisibleCheckpoints then
				if GMinimap then
					v.blip.alpha = 0
				end
				continue
			end
			if v:GetID() == checkpoint_count +1 then
				_UVCurrentCheckpoint = v
				if GMinimap then
					v.blip.alpha = 255
					v.blip.color = Color(0,255,0)
				end
			elseif v:GetID() == checkpoint_count +2 then
				_UVNextCheckpoint = v
				if GMinimap then
					v.blip.alpha = 255
					v.blip.color = Color(255,204,0)
				end
			else
				if GMinimap then
					v.blip.alpha = 0
				end
			end
		end

		-- check for wrong way
		UVLastWrongWayCheckTime = UVLastWrongWayCheckTime or CurTime()
		UVWrongWayStart = UVWrongWayStart or nil
		UVIsWrongWay = UVIsWrongWay or false

		if _UVCurrentCheckpoint and IsValid(_UVCurrentCheckpoint) then
			local vehicle_center = my_vehicle:WorldSpaceCenter()
			local vehicle_velocity = my_vehicle:GetVelocity()
			local check_center_pos = (_UVCurrentCheckpoint:GetPos() + _UVCurrentCheckpoint:GetMaxPos()) / 2

			local speed = vehicle_velocity:Length()
			local min_speed = 100

			if speed >= min_speed then
				local to_checkpoint = (check_center_pos - vehicle_center):GetNormalized()
				local normalized_velo = vehicle_velocity:GetNormalized()
				local dot_product = normalized_velo:Dot(to_checkpoint)

				if dot_product < -0.25 then
					if not UVWrongWayStart then
						UVWrongWayStart = CurTime()
					end
					if CurTime() - UVWrongWayStart > 1.5 then
						if not UVIsWrongWay then
							UVIsWrongWay = true
							hook.Run("UIEventHook", "racing", "onWrongWay", CurTime(), true)
						end
					end
				else
					UVWrongWayStart = nil
					if UVIsWrongWay then
						UVIsWrongWay = false
						hook.Run("UIEventHook", "racing", "onWrongWay", CurTime(), false)
					end
				end
			else
				UVWrongWayStart = nil
				if UVIsWrongWay then
					UVIsWrongWay = false
					hook.Run("UIEventHook", "racing", "onWrongWay", CurTime(), false)
				end
			end
		end

		-- Racer nametags
		if RacerTags:GetBool() and IsValid( my_vehicle ) then
			local localPlayer = LocalPlayer()
			local myVehicle = localPlayer:GetVehicle()

			local renderQueue = {}

			for vehicle, info in pairs(UVHUDRaceInfo.Participants or {}) do
				if not IsValid(vehicle) or UVGetDriver(vehicle) == LocalPlayer() then continue end
				if info.Status == "Disqualified" or info.Status == "Busted" then continue end

				local dist = localPlayer:GetPos():DistToSqr(vehicle:GetPos())
				table.insert(renderQueue, { vehicle = vehicle, dist = dist })
			end

			-- Sort so farther ones draw first, closer ones last (on top)
			table.sort(renderQueue, function(a, b)
				return a.dist < b.dist
			end)

			local maxSquares = RacerTagsMaxNr:GetInt() or 3
			local count = math.min(#renderQueue, maxSquares)

			for i = count, 1, -1 do
				local data = renderQueue[i]
				if data then
					UVRenderEnemySquare(data.vehicle)
				end
			end
		end
		
		-- Racer Map Icons
		for vehicle, info in pairs(UVHUDRaceInfo.Participants or {}) do
			if not IsValid(vehicle) or UVGetDriver(vehicle) == LocalPlayer() then continue end

			if not GMinimap then continue end
			if not vehicle.displayedonhud then
				vehicle.displayedonhud = true
				local blip, id = GMinimap:AddBlip({
					id = "UVBlip" .. vehicle:EntIndex(),
					parent = vehicle,
					icon = "unitvehicles/icons/MINIMAP_ICON_CAR.png",
					scale = 1.4,
					color = Color(255, 191, 0),
				})
				if vehicle:GetClass() == "prop_vehicle_jeep" then
					blip.icon = "unitvehicles/icons/MINIMAP_ICON_CAR_JEEP.png" -- Icon points the other way
				end
			end

			if vehicle.displayedonhud then
				local curblip = GMinimap:FindBlipByID("UVBlip" .. vehicle:EntIndex())
				if not curblip then continue end

				if UVHUDCopMode and ((UVHUDCopMode and UVHUDDisplayCooldown) or (tonumber(UVUnitsChasing) <= 0 or not vehicle.inunitview)) then
					curblip.alpha = 0
				else
					curblip.alpha = 255
				end
			end
		end
		local racer_count = #string_array

		local lang = UVString

		if hudyes and UV_UI.racing.general then
			UV_UI.racing.general.main( my_vehicle, my_array, string_array, sorted_table )
		end
		
		if hudyes and UV_UI.racing[hudtype] then
			UV_UI.racing[hudtype].main( my_vehicle, my_array, string_array, sorted_table )
		end
	end)
	
	UVRace_RacerList = {}

	net.Receive("UVRace_RacersList", function()
		local list = net.ReadTable() or {}
		UVRace_RacerList = list

		local seen, dedup = {}, {}
		for _, r in ipairs(UVRace_RacerList) do
			if r.id and not seen[r.id] then
				seen[r.id] = true
				dedup[#dedup+1] = r
			end
		end
		UVRace_RacerList = dedup
	end)

	net.Receive("UVRace_TrackReady", function()
		local name = net.ReadString()
		local author = net.ReadString()
		local plr = net.ReadPlayer()

		if name == "?" and author == "?" then
			UVRace_CurrentTrackName = nil
			UVRace_CurrentTrackAuthor = nil
			UVRace_CurrentTrackHost = nil
		else
			UVRace_CurrentTrackName = name
			UVRace_CurrentTrackAuthor = author
			UVRace_CurrentTrackHost = plr
		end
	end)

	hook.Add("HUDPaint", "UVRace_DisplayTrackInfo", function()
		if not IsValid(LocalPlayer()) then return end -- Am I invalid? Tough shit
		if not UVRace_CurrentTrackName then return end -- No track
		if not UVRace_RacerList then return false end -- No invite, no accepted invite, not host
		if UVRaceStarting then return end -- Race is starting; hide it

		local function ShouldShowRacerHUD()
			if UVHUDDisplayPursuit then return false end
			if not UVRace_RacerList or not istable(UVRace_RacerList) then return false end

			local ply = LocalPlayer()
			if not IsValid(ply) then return false end

			-- Host always sees it
			if UVRace_CurrentTrackHost and ply == UVRace_CurrentTrackHost then
				return true
			end

			-- Try to resolve the player's "main" vehicle on the client
			local car
			do
				local veh = ply:GetVehicle()
				if IsValid(veh) then
					-- If they're in a seat, prefer the parent as the main vehicle
					local parent = veh:GetParent()
					car = IsValid(parent) and parent or veh
				end
			end

			-- Primary check: compare vehicle EntIndex against the list's id (which is a vehicle EntIndex)
			if IsValid(car) then
				local carId = car:EntIndex()
				for _, r in ipairs(UVRace_RacerList) do
					-- if r.id == carId and (r.status == "Invited" or r.status == "Accepted") then
					if r.id == carId and r.status == "Accepted" then
						return true
					end
				end
			end

			-- Fallback: compare by player name if not currently in vehicle
			for _, r in ipairs(UVRace_RacerList) do
				-- if r.name == ply:Nick() and (r.status == "Invited" or r.status == "Accepted") then
				if r.name == ply:Nick() and r.status == "Accepted" then
					return true
				end
			end

			return false
		end

		if not ShouldShowRacerHUD() then return end

		local h, w = ScrH(), ScrW()

		local alpha = 255
		
		local slots = ents.FindByClass("uvrace_spawn")

		surface.SetDrawColor(0, 0, 0, alpha)
		surface.SetMaterial( UVMaterials["BACKGROUND_CARBON_FILLED"] )
		surface.DrawTexturedRect(w - w * 0.3, h * 0.05, w * 0.3, h * (0.03 * 3))

		draw.SimpleTextOutlined( UVString("uv.prerace.details"), "UVFont5UI", w * 0.99, h * 0.065, Color(255, 255, 0, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )

		draw.SimpleTextOutlined( string.format( UVString("uv.prerace.name"), UVRace_CurrentTrackName ), "UVFont5Shadow", w * 0.99, h * 0.095, Color(255, 255, 255, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )
		
		-- draw.SimpleTextOutlined( string.format( UVString("uv.race.invite.host"), UVRace_CurrentTrackHost ), "UVFont5Shadow", w * 0.99, h * 0.1225, Color(255, 255, 255, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )
		
		draw.SimpleTextOutlined( string.format( UVString("uv.prerace.slotsavailable"), #slots - #UVRace_RacerList, #slots ), "UVFont5Shadow", w * 0.99, h * 0.1225, Color(255, 255, 255, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )

		local cardW, cardH = w * 0.15, h * 0.0325
		local cardsPerColumn = 10
		local spacing = 2
		local blink = 255 * math.abs(math.sin(RealTime() * 3))

		if #UVRace_RacerList > #ents.FindByClass("uvrace_spawn") then
			draw.SimpleTextOutlined( string.format(UVString("uv.race.invite.toomany"), #UVRace_RacerList, #slots ), "UVFont5Shadow", w * 0.99, h * 0.5, Color(255, blink, blink, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )
		end

		if UVRace_RacerList and #UVRace_RacerList > 0 then
			for i, racer in ipairs(UVRace_RacerList) do
				if racer.status == "Disqualified" then return end
				local statusstr = "uv.race.invite.status.invited"
				local clr = Color(200,200,200, alpha)
				local racername = racer.name
				local vehname = racer.vehiclename or "NIL"

				vehname = vehname and string.Trim(UVString(vehname), "#") or nil

				if racer.status == "Host" then
					clr = Color(255,255,0, alpha)
					statusstr = "uv.race.invite.status.host"
				elseif racer.status == "Accepted" then
					clr = Color(100,255,100, alpha)
					statusstr = "uv.race.invite.status.accepted"
				elseif IsValid(racer.ent) and racer.status == "Declined" then
					clr = Color(255,100,100, alpha)
					statusstr = "uv.race.invite.status.declined"
				end

				-- Update vehicle name dynamically for the host
				if racer.status == "Host" and IsValid(racer.ent) then
					local veh = racer.ent:GetVehicle()
					if IsValid(veh) then
						racer.vehiclename = veh:GetNWString("VehicleName", "")
					else
						racer.vehiclename = ""
					end
				end

				local col = math.floor((i - 1) / cardsPerColumn)
				local row = (i - 1) % cardsPerColumn

				local x = w - (cardW + spacing) * (col + 1)
				local y = h * 0.145 + (cardH + spacing) * row

				surface.SetDrawColor(0, 0, 0, 200)
				surface.DrawRect(x, y, cardW, cardH)
				
				surface.SetFont("UVMostWantedLeaderboardFont2")

				-- Racer name
				local maxW = cardW - 10
				local textW = surface.GetTextSize(racername)
				if textW > maxW then
					while surface.GetTextSize(racername .. "...") > maxW do
						racername = string.sub(racername, 1, -2)
					end
					racername = racername .. "..."
				end

				-- Vehicle name
				vehname = vehname or "..."
				textW = surface.GetTextSize(vehname)
				if textW > maxW then
					while surface.GetTextSize(vehname .. "...") > maxW do
						vehname = string.sub(vehname, 1, -2)
					end
					vehname = vehname .. "..."
				end

				if racer.isAI then -- AI gets a tag regardless
					racername = racername .. " (AI)"
				end

				draw.SimpleText(UVString(statusstr), "UVMostWantedLeaderboardFont2", x + (w * 0.145), y, clr, TEXT_ALIGN_RIGHT)
				draw.SimpleText(racername, "UVMostWantedLeaderboardFont2", x + (w * 0.001), y, Color(255,255,255), TEXT_ALIGN_LEFT)
				draw.SimpleText(vehname or "...", "UVMostWantedLeaderboardFont2", x + (w * 0.001), y + 15, Color(200,200,200), TEXT_ALIGN_LEFT)
			end
		end
	end)

	hook.Add("PostRenderVGUI", "UVRaceCinematicOverlayTop", function()
		if not UVRaceCinematicOverlay then return end -- If the overlay isn't active
		if gui.IsGameUIVisible() then return end -- If game ESC menu is opened
		--if not GetConVar("cl_drawhud"):GetBool() then return end
		if not GetConVar("unitvehicle_preraceinfo"):GetBool() then return end
		
		local now = CurTime()
		local w, h = ScrW(), ScrH()
		local totalHeight = h * 0.125
		local totalWidth = w * 0.5
		local barHeight, barWidth, alpha = 0, 0, 0

		local state = UVRaceCinematicOverlay.state
		local elapsed = now - UVRaceCinematicOverlay.startTime

		local squarePadding = 8
		local squareHeight = 32
		local extendTime = 0.3
		local retractTime = 0.2
		local font = "UVFont5"

		surface.SetFont(font)

		local squareTexts = {}

		-- Static title
		-- table.insert(squareTexts, UVString("uv.prerace.details"))

		-- Track name and author
		if UVRace_CurrentTrackName then
			table.insert(squareTexts, string.format(
				UVString("uv.prerace.name"),
				UVRace_CurrentTrackName
			))
		end

		-- Conditionally add "laps"
		local laps = UVHUDRaceInfo and UVHUDRaceInfo['Info'].Laps
		if laps and tonumber(laps) and laps >= 2 then
			table.insert(squareTexts, string.format(
				UVString("uv.prerace.laps"),
				laps
			))
		end

		-- Checkpoints
		table.insert(squareTexts, string.format(
			UVString("uv.prerace.checks"),
			GetGlobalInt("uvrace_checkpoints") or "???"
		))

		-- Starting position
		table.insert(squareTexts, string.format(
			UVString("uv.prerace.startpos"),
			UVString("uv.race.pos.num." .. (UVHUDRaceCurrentPos or 1))
		))
		
		-- AI Difficulty
		local aidiffc = GetConVar("unitvehicle_racedifficulty"):GetFloat() or 0
		local aidiff = {
			[0]   = "uv.difficulty.1",
			[0.5] = "uv.difficulty.2",
			[1]   = "uv.difficulty.3"
		}
		local aidifficulty = aidiff[aidiffc]
		
		if #ents.FindByClass("npc_racervehicle") > 0 then
			table.insert(squareTexts, string.format(
				UVString("uv.prerace.aidifficulty"),
				UVString(aidifficulty)
			))
		end

		-- Participant List (NOT WORKING)
		-- table.insert(squareTexts, string.format(
			-- UVString("uv.prerace.participants"),
			-- "UNKNOWN"
		-- ))
		
		-- Best Lap (NOT WORKING)
		-- table.insert(squareTexts, string.format(
			-- UVString("uv.prerace.bestlap"),
			-- "--:--.---", -- Time
			-- "---" -- Holder
		-- ))

		if not UVRaceCinematicOverlay.squares then
			UVRaceCinematicOverlay.squares = {}
			for i, text in ipairs(squareTexts) do
				local textW, _ = surface.GetTextSize(text)
				table.insert(UVRaceCinematicOverlay.squares, {
					text = text,
					width = textW + 24, -- padding inside
					startTime = UVRaceCinematicOverlay.startTime + UVRaceCinematicOverlay.slideInDuration + (i - 1) * extendTime,
					progress = 0,
					done = false
				})
			end
		end

		-- Bar Animations
		if state == "slidingIn" then
			local frac = math.Clamp(elapsed / UVRaceCinematicOverlay.slideInDuration, 0, 1)
			barHeight = Lerp(frac, 0, totalHeight)
			barWidth = Lerp(frac, 0, totalWidth)
			alpha = Lerp(frac, 0, 255)

			if frac >= 1 then
				UVRaceCinematicOverlay.state = "holding"
				UVRaceCinematicOverlay.holdStartTime = now
			end

		elseif state == "holding" then
			barHeight = totalHeight
			barWidth = totalWidth
			alpha = 255

			if UVRaceCountdown and UVRaceCountdown.stage == 4 then
				UVRaceCinematicOverlay.state = "slidingOut"
				UVRaceCinematicOverlay.outStartTime = now
				UVRaceCinematicOverlay.retractStart = now
			end

		elseif state == "slidingOut" then
			local frac = math.Clamp((now - UVRaceCinematicOverlay.outStartTime) / UVRaceCinematicOverlay.slideOutDuration, 0, 1)
			barHeight = Lerp(frac, totalHeight, 0)
			barWidth = Lerp(frac, totalWidth, 0)
			alpha = Lerp(frac, 255, 0)

			if frac >= 1 then
				UVRaceCinematicOverlay = nil
				return
			end
		end

		-- Draw black bars
		surface.SetDrawColor(0, 0, 0, alpha)
		
		surface.DrawRect(0, 0, w, barHeight)
		surface.DrawRect(0, h - barHeight, w, barHeight)
		
		surface.SetMaterial( UVMaterials["BACKGROUND_CARBON_FILLED_INVERTED"] )
		surface.DrawTexturedRect(0, h * 0.15, barWidth, h * 0.05 + ((h * 0.04) * #UVRaceCinematicOverlay.squares))

		if UVHUDRaceInfo and UVHUDRaceInfo.Participants and table.Count(UVHUDRaceInfo.Participants) > 1 then
			local participants = UVHUDRaceInfo.Participants
			local sorted = UVFormLeaderboard(participants)
			local localName = IsValid(LocalPlayer()) and LocalPlayer():Nick() or ""
			
			local cardsPerRow = 3
			local maxCards = 30

			local cardW = w * 0.15
			local cardH = h * 0.0325
			local spacing = 2

			local partX = w * 0.455
			local startX = w - barWidth + partX - (cardW * cardsPerRow + spacing * 3)

			local startY = h * 0.2
			
			local font = "UVMostWantedLeaderboardFont2"

			surface.SetFont(font)
			
			local numParticipants = math.min(#sorted, maxCards)
			local rows = math.ceil(numParticipants / cardsPerRow)

			local bgX = w - barWidth
			local bgY = h * 0.15
			local bgW = barWidth
			local bgH = h * 0.05 + (rows * (cardH + spacing)) + (h * 0.01)

			surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_FILLED"])
			surface.SetDrawColor(0, 0, 0, alpha)
			surface.DrawTexturedRect(bgX, bgY, bgW, bgH)
			
			draw.SimpleTextOutlined( string.format(UVString("uv.prerace.participants"), table.Count(UVHUDRaceInfo.Participants)), "UVFont5", w - barWidth + partX, h * 0.175, Color(255, 255, 0, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )

			for i, v in ipairs(sorted) do
				if i > maxCards then break end

				local index = i - 1
				local row = math.floor(index / cardsPerRow)
				local col = index % cardsPerRow

				local x = startX + col * (cardW + spacing)
				local y = startY + row * (cardH + spacing)

				local name = v.array.Name or "UNKNOWN"
				local isLocal = (name == localName)

				local veh = UVString(v.array.VehicleName) or "UNKNOWN"

				if v.array.IsAI then
					name = name .. " (AI)"
				end

				-- Card background
				surface.SetDrawColor(0, 0, 0, 200)
				surface.DrawRect(x, y, cardW, cardH)

				-- Trim name if too wide
				local maxW = cardW - 8
				
				surface.SetFont(font)
			
				if surface.GetTextSize(name) > maxW then
					while surface.GetTextSize(name .. "...") > maxW do
						name = string.sub(name, 1, -2)
					end
					name = name .. "..."
				end
					
				if surface.GetTextSize(veh) > maxW then
					while surface.GetTextSize(veh .. "...") > maxW do
						veh = string.sub(veh, 1, -2)
					end
					veh = veh .. "..."
				end

				local textc1, textc2 = Color(255, 255, 255, alpha), Color(200, 200, 200, alpha)
				
				if isLocal then
					textc1, textc2 = Color(255, 255, 0, alpha), Color(200, 200, 0, alpha)
				end

				-- Name and vehicle
				draw.SimpleText( name, font, x + 4, y + 2, textc1, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText( veh, font, x + 4, y + 18, textc2, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
		end

		-- Draw Detail Text
		if state ~= "slidingOut" and UVRaceCinematicOverlay.squares then
			draw.SimpleTextOutlined( game.GetMap(), font, w * 0.95, barHeight - (h * 0.05), Color(255, 255, 255, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1.25, Color(0, 0, 0, alpha) )
		end

		-- Draw "Starts in" Text + Timer
		if state ~= "slidingOut" and UVRaceCinematicOverlay.squares then
			draw.SimpleTextOutlined( UVString("uv.race.startsin"), font, w * 0.5, h - barHeight + (h * 0.025), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.25, Color(0, 0, 0, alpha) )
			if UVRaceCountdown then
				draw.SimpleTextOutlined(UVRaceCountdown.label, font, w * 0.5, h - barHeight + (h * 0.065), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.25, Color( 0, 0, 0, alpha ) )
			end
		end

		-- Draw Square Info, simplified version
		if UVRaceCinematicOverlay.squares then
			local baseX = w * 0.485
			local baseY = h * 0.215
			local lineSpacing = h * 0.04
			
			draw.SimpleTextOutlined( UVString("uv.prerace.details"), font, barWidth - baseX, h * 0.175, Color(255, 255, 0, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )

			for i, square in ipairs(UVRaceCinematicOverlay.squares) do
				draw.SimpleTextOutlined( square.text, font, barWidth - baseX, baseY, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )
				baseY = baseY + lineSpacing
			end
		end
		
		-- Draw Square Info
		-- if UVRaceCinematicOverlay.squares then
			-- local baseX = w * 0.05
			-- local baseY = h - barHeight - (h * 0.035)
			
			-- local totalHeight = (#UVRaceCinematicOverlay.squares * (squareHeight + squarePadding)) - squarePadding
			-- local adjustedBaseY = baseY - (h*0.03 * #UVRaceCinematicOverlay.squares)

			-- for i, square in ipairs(UVRaceCinematicOverlay.squares) do
				-- draw.SimpleTextOutlined( square.text, font, baseX, adjustedBaseY + squareHeight / 2, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )
				-- adjustedBaseY = adjustedBaseY + squareHeight + squarePadding
			-- end

			-- local adjustedBaseY = baseY - (h*0.03 * #UVRaceCinematicOverlay.squares)
			
			-- for i, square in ipairs(UVRaceCinematicOverlay.squares) do
				-- local sqAlpha = alpha
				-- local sqProgress

				-- if state == "holding" then
					-- local timeSinceStart = now - square.startTime
					-- sqProgress = math.Clamp(timeSinceStart / extendTime, 0, 1)

					-- if sqProgress >= 1 then
						-- square.done = true
					-- end

				-- elseif state == "slidingOut" then
					-- local retractElapsed = now - (UVRaceCinematicOverlay.retractStart or now)
					-- sqProgress = 1 - math.Clamp(retractElapsed / retractTime, 0, 1)
				-- else
					-- sqProgress = square.done and 1 or 0
				-- end

				-- local drawWidth = square.width * sqProgress

				-- surface.SetDrawColor(0, 0, 0, sqAlpha)
				-- surface.DrawRect(baseX, adjustedBaseY, drawWidth, squareHeight + (h * 0.0075))

				-- local clippedText = string.sub(square.text, 1, math.floor(#square.text * sqProgress)) -- Draw text with clipping based on progress
				-- draw.SimpleTextOutlined( clippedText, font, baseX, adjustedBaseY + squareHeight / 2, Color(255, 255, 255, sqAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, sqAlpha) )

				-- adjustedBaseY = adjustedBaseY + squareHeight + squarePadding
			-- end
		-- end
	end)
end