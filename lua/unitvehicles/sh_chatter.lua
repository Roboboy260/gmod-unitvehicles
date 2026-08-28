AddCSLuaFile()

--[[References

TEN-CODE
10-1: Receiving poorly
10-2: Receiving well
10-3: Stop transmitting
10-4: Message received and understood
10-5: Relay message
10-6: Responding from a distance
10-7: Detailed, out of service
10-8: In service
10-9: Repeat message
10-10: Negative, standing by
10-11: Talking too rapidly
10-12: Visitors present
10-13: Advise weather/road conditions
10-16: Urgent pickup at location
10-17: Urgent business
10-18: Anything for us?
10-19: Nothing for you, return to base
10-20: Current location
10-21: Call by landline
10-22: Report in person to
10-23: On scene
10-24: Completed last assignment
10-25: Out of service
10-26: Going for fuel
10-27: Moving to different radio channel
10-28: Identify your station
10-29: Run for wants and warrants
10-32: Wanted suspect
10-33: Officer needs help
10-34: Requesting Pursuit/Interceptor unit
10-35: Confidential information
10-36: Police unit traffic collision
10-37: Requesting tow truck
10-38: Requesting ambulance
10-39: PIT maneuver
10-41: Self PIT
10-42: Traffic accident
10-43: Traffic jam
10-44: Requesting Special/Commander unit
10-45: Ramming suspect
10-50: Hit & Run
10-59: Herding
10-60: What is next message number?
10-62: Unable to copy, use landline
10-63: Offset
10-65: Vehicle box
10-67: Spike strip
10-70: Requesting fire department
10-71: Requesting Air unit
10-73: Roadblock
10-75: Rolling roadblock
10-77: Negative contact
10-81: Speed Trap location
10-82: Rolling chicane
10-83: Set up quadrant
10-85: Backup
10-87: Vehicle/suspect pursuit
10-90: Smoke screen
10-93: Check my frequency on this channel
10-96: Traffic stop
10-100: 5-minute break

UNIT REQUEST CODES
Air Support: Police Helicopter (Air Unit)

PURSUIT STAGE CODES
Code 1: Situation under control
Code 2: ASAP, no lights or sirens(on)
Code 3: Emergency, lights and sirens(on)
Code 4: Suspect under arrest
Code 5: More units needed
Code 6: High-risk racer
Code 7: Change in Condition
Code 8: Suspect found
Code 10: Confidential information

PURSUIT CONDITIONS
Condition 1: Heat level 1
Condition 2: Heat level 2
Condition 3: Heat level 3
Condition 4: Heat level 4
Condition 5: Heat level 5
Condition 6: Heat level 6
Condition 7: Heat level 7
Condition 8: Heat level 8
Condition 9: Heat level 9
Condition 10: Heat level 10

OTHER CODES
28/29: Run suspect for wants/warrants
51-50: Possible mental disorder
"Positive hit": Ran suspect has a criminal record
APB: All-points bulletin
ACCI: Accident investigator
ASAP: As soon as possible
Assault PO: Assault on a police officer
DUI: Driving under the influence
EMS: Emergency medical services
ETA: Estimated time of arrival
GD: General duty
HAZMAT: Hazardous materials unit
HVT: High value target
KS: Kill switch
MHA: Mental Health Act
MVA: Motor vehicle accident
NCIC: National Criminal Information Center
PC: Police car/cruiser
PDT: Portable data transmitter/terminal
PID: Positive identification
Primary: Unit behind suspect
RTB: Return to base
Secondary: Unit behind primary
TAC: Tactical radio channel
TC: Traffic collision
VCB: Visual contact broken
Wrecker: Tow truck

]]

if SERVER then
	UVClassName = {"POLICE"}
	
	file.AsyncRead('data_static/chatter.json', 'GAME', function( _, _, status, data )
		_uvchatterarray = util.JSONToTable(data)
	end, true)
	
	--Spam check--
	
	function UVRelayToClients( init_time, sound_name, param, can_skip, players, callsign )
		if not players and UVTargeting then
			players = UVGetPursuitRecipients()
		end

		if players and type(players) == "table" then
			if #players == 0 then return end
		end

		net.Start('UV_Chatter')
		net.WriteFloat(init_time)
		net.WriteString(sound_name)
		net.WriteBool(can_skip)
		net.WriteUInt(param or 0, 4)
		net.WriteBool(callsign ~= nil)

		if callsign ~= nil then
			net.WriteString(callsign)
		end

		if players and type(players) == "table" then
			net.Send( players )
		else
			net.Broadcast()
		end
	end
	
	function UVRelaySoundToClients( sound_name, can_skip, players )
		if not players then
			players = UVGetPursuitRecipients()
		end

		local array = {
			['FileName'] = sound_name,
			['CanSkip'] = can_skip
		}
		net.Start('UV_Sound')
		net.WriteTable(array)

		if players and type(players) == "table" then
			net.Send(players)
		else
			net.Broadcast()
		end
	end
	
	function UVDelayChatter(seconds)
		--if UVChatterDelayed then return 5 end
		UVChatterDelayed = true
		
		if not seconds then
			seconds = 2
		end
		
		timer.Remove('UVDelayChatter')
		timer.Create('UVDelayChatter', seconds, 1, function()
			UVChatterDelayed = false
		end)

		return seconds
	end
	
	UVChatterQueue = UVChatterQueue or {}
	UVFileFindCache = UVFileFindCache or {}
	UVChatterQueueActive = UVChatterQueueActive or false
	UVChatterQueueFinishTime = UVChatterQueueFinishTime or 0
	
	function UVResetChatterQueue()
		UVChatterQueue = {}
		UVChatterQueueActive = false
		UVChatterQueueFinishTime = 0
	end
	
	local function ProcessChatterQueue()
		if #UVChatterQueue == 0 then return end
		if UVChatterQueueActive then return end
		if UVChatterQueueFinishTime > 0 and CurTime() < UVChatterQueueFinishTime then return end
		
		local queueItem = table.remove(UVChatterQueue, 1)
		if not queueItem then return end
		
		UVChatterQueueActive = true
		UVChatterQueueFinishTime = 0
		
		local duration = queueItem.func()
		
		if duration and duration ~= 5 and duration > 0 then
			UVChatterQueueFinishTime = CurTime() + duration
		else
			UVChatterQueueFinishTime = CurTime()
		end
		
		UVChatterQueueActive = false
	end
	
	if not UVChatterQueueThinkActive then
		UVChatterQueueThinkActive = true
		hook.Add("Think", "UVChatterQueueProcessor", function()
			ProcessChatterQueue()
		end)
	end
	
	--return 5 = no sound chatter
	-- function UVSoundChatter(self, voice, chattertype, parameters, ...)
	-- 	--[[ Voice Type
	-- 	1 = Undercover Dispatch
	-- 	2 = Undercover Helicopter (Air)
	-- 	3-8 = Undercover Local (Patrol, Support)
	-- 	9-10 = Undercover Federal (Special, Commander(one commander disabled))
	-- 	11 = Payback/Heat Rhino
	-- 	12 = Most Wanted Cross (Commander(one commander enabled))
	-- 	13-18 = Most Wanted Local (Pursuit, Interceptor)
	-- 	19 = Most Wanted Helicopter (Air)
	-- 	*Others are non-engaging support units. If both are included in the same folder(chattertype), it'd be a 50/50 chance.
	-- 	]]

	local function GetUnitVoiceProfile(unit, isDispatch, isMisc)
		local voiceProfile = ""
		
		if isDispatch then
			voiceProfile = GetConVar("unitvehicle_unit_dispatch_voiceprofile"):GetString()
		elseif isMisc then
			voiceProfile = GetConVar("unitvehicle_unit_misc_voiceprofile"):GetString()
		else
			local unitType = unit and unit.type
			if not unitType then return GetConVar("unitvehicle_unit_dispatch_voiceprofile"):GetString() end
			
			voiceProfile = GetConVar("unitvehicle_unit_" .. unitType .. "_voiceprofile"):GetString()
		end
		
		return voiceProfile
	end

	local function CachedFileFind(path, searchPath)
		searchPath = searchPath or "GAME"
		local key = path
		if UVFileFindCache[key] == nil then
			local files, directories = file.Find(path, searchPath)
			UVFileFindCache[key] = { files, directories }
		end
		local cached = UVFileFindCache[key]
		return cached[1], cached[2]
	end
	
	local function _PlayUVSoundChatter(self, voice, chattertype, parameters, ...)
		
		if not IsValid(self) or not (GetConVar("unitvehicle_chatter"):GetBool()) then 
			return 0
		end

		voice = voice or "nil"

		-- if not UVLastPlay then
		-- 	UVLastPlay = CurTime()
		-- elseif CurTime() - UVLastPlay < 0.5  then
		-- 	return 5
		-- end

		local initTime = CurTime()
		
		local isDispatch = (select(1, ...) == "DISPATCH")
		
		local unitVoiceProfile = GetUnitVoiceProfile(self, isDispatch, false)
		local miscVoiceProfile = GetUnitVoiceProfile(self, isDispatch, true)
		
		if UVJammerDeployed then
			local staticFiles = CachedFileFind("sound/chatter2/" .. miscVoiceProfile .. "/misc/static/*", "GAME")
			if next(staticFiles) == nil then return 5 end
			
			local soundFile = "chatter2/"..miscVoiceProfile.."/misc/static/"..staticFiles[1]
			UVRelayToClients(initTime, soundFile, parameters, true)
			return 5
		end

		local function HandleCallSounds(is_dispatch, is_priority)
			local callsign = self and self.callsign
			if is_dispatch or isDispatch then
				voice = "dispatch"
				unitVoiceProfile = GetConVar("unitvehicle_unit_dispatch_voiceprofile"):GetString()
			end

			local soundFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile..'/'..voice.."/"..chattertype.."/*", "GAME")
			if next(soundFiles) == nil then return 5 end
			table.Shuffle(soundFiles)
			local soundFile = "chatter2/"..unitVoiceProfile..'/'..voice.."/"..chattertype.."/"..soundFiles[1]
			
			local radioOnFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radioon/*", "GAME")
			table.Shuffle(radioOnFiles)
			local radioOnFile
			if next(radioOnFiles) ~= nil then
				radioOnFile = "chatter2/"..miscVoiceProfile.."/misc/radioon/"..radioOnFiles[1]
			end
			
			local radioOffFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radiooff/*", "GAME")
			table.Shuffle(radioOffFiles)
			local radioOffFile
			if next(radioOffFiles) ~= nil then
				radioOffFile = "chatter2/"..miscVoiceProfile.."/misc/radiooff/"..radioOffFiles[1]
			end

			ChatterLastPlay = initTime

			local function _init()
				UVRelayToClients(initTime, soundFile, parameters, not (is_priority or voice == "dispatch"), nil, (voice == "dispatch" and "uv.unit.dispatch") or (callsign))
				timer.Simple(SoundDuration(soundFile or ""), function()
					if ChatterLastPlay ~= initTime then return 5 end
					if radioOffFile then
						UVRelayToClients(initTime, radioOffFile, parameters, true)
					end
				end)
			end

			local chirpGenericFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/*", "GAME")
			local chirpGenericFile
			
			if radioOnFile then
				UVRelayToClients(initTime, radioOnFile, parameters, true)
				timer.Simple(SoundDuration(radioOnFile or ""), function()
					if ChatterLastPlay ~= initTime then return 5 end
					_init()
				end)
			else
				if next(chirpGenericFiles) ~= nil then
					chirpGenericFile = "chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/"..chirpGenericFiles[1]
				end

				if chirpGenericFile then
					if ChatterLastPlay ~= initTime then return 5 end
					UVRelayToClients(initTime, chirpGenericFile, parameters, true)
				end
				
				timer.Simple(0.1, function()
					if ChatterLastPlay ~= initTime then return 5 end
					_init()
				end)
			end
			return UVDelayChatter((SoundDuration(soundFile or "") + SoundDuration(radioOnFile or "") + (chirpGenericFile and 0.1 or 0) + SoundDuration(radioOffFile or "") + math.random(0.5, 2) + math.random()))
		end

		-- 	--[[Parameters
		-- 	1 = No voice restriction
		-- 	2 = Bullhorn
		-- 	3 = Static
		-- 	4 = Emergency
		-- 	5 = Identify
		-- 	6 = Call
		-- 	7 = Losing
		-- 	8 = Emergency (No voice restriction)
		--  9 = In person
		--  10 = Vehicle Description
		-- 	]]
		
		if parameters == 1 then
			return HandleCallSounds(isDispatch, true)
			
		elseif parameters == 2 then
			local soundFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile..'/'..voice.."/bullhorn/"..chattertype.."/*", "GAME")
			if next(soundFiles) == nil then return 0 end
			table.Shuffle(soundFiles)
			local soundFile = "chatter2/"..unitVoiceProfile..'/'..voice.."/bullhorn/"..chattertype.."/"..soundFiles[1]
			
			--self:EmitSound(soundFile, 10000, 100, 1, CHAN_STREAM)
			if not IsValid( self ) then return 0 end
			if UVBullhornLastDuration and CurTime() < UVBullhornLastDuration then return 0 end
			
			ChatterLastPlay = initTime
			
			UVBullhornLastDuration = CurTime() + SoundDuration( soundFile )
			self:EmitSound( soundFile, 120, 100, 1, CHAN_AUTO )
			UVRelayToClients(initTime, soundFile, parameters, true, nil, self and self.callsign)

			return 4
			
		elseif parameters == 3 then
			local callsign = self and self.callsign

			local soundFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile..'/'..voice.."/"..chattertype.."/*", "GAME")
			if next(soundFiles) == nil then return 5 end
			table.Shuffle(soundFiles)
			local soundFile = "chatter2/"..unitVoiceProfile..'/'..voice.."/"..chattertype.."/"..soundFiles[1]
			
			if not soundFile then return 5 end
			
			local staticFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/static/*", "GAME")
			if next(staticFiles) == nil then return 5 end
			table.Shuffle(staticFiles)
			local staticFile = "chatter2/"..miscVoiceProfile.."/misc/static/"..staticFiles[1]

			ChatterLastPlay = initTime

			local radioOnFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radioon/*", "GAME")
			table.Shuffle(radioOnFiles)
			local radioOnFile
			if next(radioOnFiles) ~= nil then
				radioOnFile = "chatter2/"..miscVoiceProfile.."/misc/radioon/"..radioOnFiles[1]
			end
			
			local radioOffFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radiooff/*", "GAME")
			table.Shuffle(radioOffFiles)
			local radioOffFile
			if next(radioOffFiles) ~= nil then
				radioOffFile = "chatter2/"..miscVoiceProfile.."/misc/radiooff/"..radioOffFiles[1]
			end

			local chirpGenericFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/*", "GAME")
			table.Shuffle(chirpGenericFiles)
			local chirpGenericFile
			
			if radioOnFile then
				if ChatterLastPlay ~= initTime then return 5 end
				UVRelayToClients(initTime, radioOnFile, parameters, true)
			else
				if next(chirpGenericFiles) ~= nil then
					chirpGenericFile = "chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/"..chirpGenericFiles[1]
				end

				if chirpGenericFile then
					if ChatterLastPlay ~= initTime then return 5 end
					UVRelayToClients(initTime, chirpGenericFile, parameters, true)
				end
			end

			timer.Simple(radioOnFile and SoundDuration(radioOnFile) or (chirpGenericFile and 0.1 or 0), function()
				if ChatterLastPlay ~= initTime then return 5 end
				UVRelayToClients(initTime, staticFile, parameters, true)
				timer.Simple(SoundDuration(staticFile or ""), function()
					if ChatterLastPlay ~= initTime then return 5 end
					UVRelayToClients(initTime, soundFile, parameters, true, nil, (voice == "dispatch" and "uv.unit.dispatch") or (callsign))
					timer.Simple(SoundDuration(soundFile or ""), function()
						if radioOffFile then
							if ChatterLastPlay ~= initTime then return 5 end
							UVRelayToClients(initTime, radioOffFile, parameters, true)
						end
					end)
				end)
			end)
			
			
			return UVDelayChatter(SoundDuration(soundFile or "") + SoundDuration(staticFile or "") + SoundDuration(radioOnFile or "") + (chirpGenericFile and 0.1 or 0) + SoundDuration(radioOffFile or "") + math.random(0.5, 2) + math.random())
			
		elseif parameters == 4 then
			local soundFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile..'/'..voice.."/"..chattertype.."/*", "GAME")
			if next(soundFiles) == nil then return 5 end
			table.Shuffle(soundFiles)
			local soundFile = "chatter2/"..unitVoiceProfile..'/'..voice.."/"..chattertype.."/"..soundFiles[1]
			
			if not soundFile then return 5 end
			
			ChatterLastPlay = initTime

			local emergencyFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/emergency/*", "GAME")
			table.Shuffle(emergencyFiles)
			local emergencyFile
			if next(emergencyFiles) ~= nil then
				emergencyFile = "chatter2/"..miscVoiceProfile.."/misc/emergency/"..emergencyFiles[1]
			end

			local radioOnFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radioon/*", "GAME")
			table.Shuffle(radioOnFiles)
			local radioOnFile
			if next(radioOnFiles) ~= nil then
				radioOnFile = "chatter2/"..miscVoiceProfile.."/misc/radioon/"..radioOnFiles[1]
			end
			
			local radioOffFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radiooff/*", "GAME")
			table.Shuffle(radioOffFiles)
			local radioOffFile
			if next(radioOffFiles) ~= nil then
				radioOffFile = "chatter2/"..miscVoiceProfile.."/misc/radiooff/"..radioOffFiles[1]
			end
			
			local chirpGenericFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/*", "GAME")
			table.Shuffle(chirpGenericFiles)
			local chirpGenericFile
			
			if radioOnFile then
				if ChatterLastPlay ~= initTime then return 5 end
				UVRelayToClients(initTime, radioOnFile, parameters, false)
			else
				if next(chirpGenericFiles) ~= nil then
					chirpGenericFile = "chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/"..chirpGenericFiles[1]
				end
		
				if chirpGenericFile then
					if ChatterLastPlay ~= initTime then return 5 end
					UVRelayToClients(initTime, chirpGenericFile, parameters, false)
				end
			end
			timer.Simple(radioOnFile and SoundDuration(radioOnFile) or (chirpGenericFile and 0.1 or 0), function()
				if ChatterLastPlay ~= initTime then return 5 end
				if emergencyFile then
					UVRelayToClients(initTime, emergencyFile, parameters, false)
				end
				timer.Simple(SoundDuration(emergencyFile or ""), function()
					if ChatterLastPlay ~= initTime then return 5 end
					UVRelayToClients(initTime, soundFile, parameters, false, nil, (voice == "dispatch" and "uv.unit.dispatch") or (self and self.callsign))
					timer.Simple(SoundDuration(soundFile or ""), function()
						if radioOffFile then
							if ChatterLastPlay ~= initTime then return 5 end
							UVRelayToClients(initTime, radioOffFile, parameters, false)
						end
					end)
				end)
			end)
			
			return UVDelayChatter((SoundDuration(soundFile or "") + SoundDuration(emergencyFile or "") + SoundDuration(radioOnFile or "") + (chirpGenericFile and 0.1 or 0) + SoundDuration(radioOffFile or "") + math.random(0.5, 2) + math.random()))
			
		elseif parameters == 5 then
			local soundFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile..'/'..voice.."/"..chattertype.."/*", "GAME")
			if next(soundFiles) == nil then return 5 end
			table.Shuffle(soundFiles)
			local soundFile = "chatter2/"..unitVoiceProfile..'/'..voice.."/"..chattertype.."/"..soundFiles[1]
			
			if not soundFile then return 5 end

			ChatterLastPlay = initTime

			local comparedType = select( 2, ... ) or self.type
			
			local identifyFile = nil
			local identifyFiles, identifyDirs = CachedFileFind("sound/chatter2/"..unitVoiceProfile.."/"..voice.."/identify/*", "GAME")
			if next(identifyDirs) ~= nil then
				for _, dir in pairs( identifyDirs ) do
					if comparedType == dir then
						local files = CachedFileFind("sound/chatter2/"..unitVoiceProfile.."/"..voice.."/identify/"..dir.."/*", "GAME")
						if next(files) ~= nil then
							table.Shuffle(files)
							identifyFile = "chatter2/"..unitVoiceProfile..'/'..voice.."/identify/"..dir.."/"..files[1]
							break
						end	
					end
				end
			end
			if not identifyFile then
				if next(identifyFiles) ~= nil then
					table.Shuffle(identifyFiles)
					identifyFile = "chatter2/"..unitVoiceProfile..'/'..voice.."/identify/"..identifyFiles[1]
				end
			end
			
			local radioOnFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radioon/*", "GAME")
			table.Shuffle(radioOnFiles)
			local radioOnFile
			if next(radioOnFiles) ~= nil then
				radioOnFile = "chatter2/"..miscVoiceProfile.."/misc/radioon/"..radioOnFiles[1]
			end
			
			local radioOffFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radiooff/*", "GAME")
			table.Shuffle(radioOffFiles)
			local radioOffFile
			if next(radioOffFiles) ~= nil then
				radioOffFile = "chatter2/"..miscVoiceProfile.."/misc/radiooff/"..radioOffFiles[1]
			end

			local chirpGenericFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/*", "GAME")
			table.Shuffle(chirpGenericFiles)
			local chirpGenericFile
			
			if radioOnFile then
				if ChatterLastPlay ~= initTime then return 5 end
				UVRelayToClients(initTime, radioOnFile, parameters, true)
			else
				if next(chirpGenericFiles) ~= nil then
					chirpGenericFile = "chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/"..chirpGenericFiles[1]
				end

				if chirpGenericFile then
					if ChatterLastPlay ~= initTime then return 5 end
					UVRelayToClients(initTime, chirpGenericFile, parameters, true)
				end
			end
			timer.Simple(radioOnFile and SoundDuration(radioOnFile) or (chirpGenericFile and 0.1 or 0), function()
				if ChatterLastPlay ~= initTime then return 5 end
				if identifyFile then
					UVRelayToClients(initTime, identifyFile, parameters, true, nil, (voice == "dispatch" and "uv.unit.dispatch") or (self and self.callsign))
				end
				timer.Simple(SoundDuration(identifyFile or ""), function()
					if ChatterLastPlay ~= initTime then return 5 end
					UVRelayToClients(initTime, soundFile, parameters, true, nil, (voice == "dispatch" and "uv.unit.dispatch") or (self and self.callsign))
					timer.Simple(SoundDuration(soundFile or ""), function()
						if radioOffFile then
							if ChatterLastPlay ~= initTime then return 5 end
							UVRelayToClients(initTime, radioOffFile, parameters, true)
						end
					end)
				end)
			end)
			
			return UVDelayChatter(SoundDuration(soundFile or "") + SoundDuration(identifyFile or "") + SoundDuration(radioOnFile or "") + (chirpGenericFile and 0.1 or 0) + SoundDuration(radioOffFile or "") + math.random(0.5, 2) + math.random())
			
		elseif parameters == 6 then

			voice = "dispatch"
			unitVoiceProfile = GetConVar("unitvehicle_unit_dispatch_voiceprofile"):GetString()
			
			local soundFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile.."/dispatch/"..chattertype.."/*", "GAME")
			if next(soundFiles) == nil then return 5 end
			table.Shuffle(soundFiles)
			local soundFile = "chatter2/"..unitVoiceProfile.."/dispatch/"..chattertype.."/"..soundFiles[1]

			ChatterLastPlay = initTime
			
			local emergencyFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/emergency/*", "GAME")
			table.Shuffle(emergencyFiles)
			local emergencyFile
			if next(emergencyFiles) ~= nil then
				emergencyFile = "chatter2/"..miscVoiceProfile.."/misc/emergency/"..emergencyFiles[1]
			end
						
			local addressFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile.."/dispatch/addressgroup_map/"..game.GetMap().."/*", "GAME")
			table.Shuffle(addressFiles)
			local chosenPath = "chatter2/"..unitVoiceProfile.."/dispatch/addressgroup_map/"..game.GetMap().."/"

			if not addressFiles or #addressFiles == 0 then
				local mapName = game.GetMap()
				if mapName:find("_") then
					mapName = mapName:gsub("^[^_]+_", ""):gsub("(_.+)$", "")
					-- print("Found no " .. game.GetMap() .. " files - switching to " .. mapName)
					addressFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile.."/dispatch/addressgroup_map/"..mapName.."/*", "GAME")
					table.Shuffle(addressFiles)
					chosenPath = "chatter2/"..unitVoiceProfile.."/dispatch/addressgroup_map/"..mapName.."/"
				end
			end

			if not addressFiles or #addressFiles == 0 then
				-- print("Found no alternative files - switching to default")
				addressFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile.."/dispatch/addressgroup/*", "GAME")
				table.Shuffle(addressFiles)
				chosenPath = "chatter2/"..unitVoiceProfile.."/dispatch/addressgroup/"
			end

			local addressFile
			if addressFiles and #addressFiles > 0 then
				addressFile = chosenPath..addressFiles[1]
			end

			local locationFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile.."/dispatch/d_location/*", "GAME")
			table.Shuffle(locationFiles)
			local locationFile
			if locationFiles and next(locationFiles) ~= nil then
				locationFile = "chatter2/"..unitVoiceProfile.."/dispatch/d_location/"..locationFiles[1]
			end
			
			local requestFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile.."/dispatch/unitrequest/*", "GAME")
			table.Shuffle(requestFiles)
			local requestFile
			if requestFiles and next(requestFiles) ~= nil then
				requestFile = "chatter2/"..unitVoiceProfile.."/dispatch/unitrequest/"..requestFiles[1]
			end

			local radioOnFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radioon/*", "GAME")
			table.Shuffle(radioOnFiles)
			local radioOnFile
			if next(radioOnFiles) ~= nil then
				radioOnFile = "chatter2/"..miscVoiceProfile.."/misc/radioon/"..radioOnFiles[1]
			end
			
			local radioOffFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radiooff/*", "GAME")
			table.Shuffle(radioOffFiles)
			local radioOffFile
			if next(radioOffFiles) ~= nil then
				radioOffFile = "chatter2/"..miscVoiceProfile.."/misc/radiooff/"..radioOffFiles[1]
			end

			local chirpGenericFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/*", "GAME")
			table.Shuffle(chirpGenericFiles)
			local chirpGenericFile
						
			local soundDuration_soundFile = SoundDuration(soundFile or "")
			local soundDuration_emergencyFile = SoundDuration(emergencyFile or "")
			local soundDuration_addressFile = SoundDuration(addressFile or "")
			local soundDuration_locationFile = SoundDuration(locationFile or "")
			local soundDuration_requestFile = SoundDuration(requestFile or "")
			local soundDuration_radioOffFile = SoundDuration(radioOffFile or "")
			local soundDuration_radioOnFile = SoundDuration(radioOnFile or "")
			local soundDuration_chirpGenericFile

			if radioOnFile then
				UVRelayToClients(initTime, radioOnFile, parameters, false)
			else
				if next(chirpGenericFiles) ~= nil then
					chirpGenericFile = "chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/"..chirpGenericFiles[1]
					soundDuration_chirpGenericFile = 0.1
				end

				if chirpGenericFile then
					if ChatterLastPlay ~= initTime then return 5 end
					UVRelayToClients(initTime, chirpGenericFile, parameters, true)
				end
			end
			timer.Simple(soundDuration_radioOnFile or soundDuration_chirpGenericFile or 0, function()
				if ChatterLastPlay ~= initTime then return 5 end
				if emergencyFile then
					UVRelayToClients(initTime, emergencyFile, parameters, false)
				end
				timer.Simple(soundDuration_emergencyFile, function()
					if ChatterLastPlay ~= initTime then return 5 end
					UVRelayToClients(initTime, addressFile or "", parameters, false, nil, (voice == "dispatch" and "uv.unit.dispatch") or (self and self.callsign))
					timer.Simple(soundDuration_addressFile, function()
						if ChatterLastPlay ~= initTime then return 5 end
						UVRelayToClients(initTime, soundFile or "", parameters, false, nil, (voice == "dispatch" and "uv.unit.dispatch") or (self and self.callsign))
						timer.Simple(soundDuration_soundFile, function()
							if ChatterLastPlay ~= initTime then return 5 end
							UVRelayToClients(initTime, locationFile or "", parameters, false, nil, (voice == "dispatch" and "uv.unit.dispatch") or (self and self.callsign))
							timer.Simple(soundDuration_locationFile, function()
								if ChatterLastPlay ~= initTime then return 5 end
								UVRelayToClients(initTime, requestFile or "", parameters, false, nil, (voice == "dispatch" and "uv.unit.dispatch") or (self and self.callsign))
								timer.Simple(soundDuration_requestFile, function()
									if radioOffFile then
										if ChatterLastPlay ~= initTime then return 5 end
										UVRelayToClients(initTime, radioOffFile or "", parameters, false)
									end
								end)
							end)
						end)
					end)
				end)
			end)
			return UVDelayChatter((soundDuration_soundFile + soundDuration_emergencyFile + soundDuration_addressFile + soundDuration_locationFile + soundDuration_requestFile + soundDuration_radioOffFile + soundDuration_radioOnFile + (soundDuration_chirpGenericFile or 0) + math.random(0.5, 2) + math.random()))
			
		elseif parameters == 7 then
			if not UVEnemyEscaping then return 5 end
			
			voice = "dispatch"
			unitVoiceProfile = GetConVar("unitvehicle_unit_dispatch_voiceprofile"):GetString()
			
			local emergencyFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/emergency/*", "GAME")
			table.Shuffle(emergencyFiles)
			local emergencyFile
			if next(emergencyFiles) ~= nil then
				emergencyFile = "chatter2/"..miscVoiceProfile.."/misc/emergency/"..emergencyFiles[1]
			end
			
			local breakawayFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile.."/dispatch/dispbreakaway/*", "GAME")
			table.Shuffle(breakawayFiles)
			local breakawayFile
			if next(breakawayFiles) ~= nil then
				breakawayFile = "chatter2/"..unitVoiceProfile.."/dispatch/dispbreakaway/"..breakawayFiles[1]
			end
			
			local locationFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile.."/dispatch/d_location/*", "GAME")
			table.Shuffle(locationFiles)
			local locationFile
			if next(locationFiles) ~= nil then
				locationFile = "chatter2/"..unitVoiceProfile.."/dispatch/d_location/"..locationFiles[1]
			end
			
			local quadrantFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile.."/dispatch/quadrant/*", "GAME")
			table.Shuffle(quadrantFiles)
			local quadrantFile
			if next(quadrantFiles) ~= nil then
				quadrantFile = "chatter2/"..unitVoiceProfile.."/dispatch/quadrant/"..quadrantFiles[1]
			end

			local radioOnFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radioon/*", "GAME")
			table.Shuffle(radioOnFiles)
			local radioOnFile
			if next(radioOnFiles) ~= nil then
				radioOnFile = "chatter2/"..miscVoiceProfile.."/misc/radioon/"..radioOnFiles[1]
			end
			
			local radioOffFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radiooff/*", "GAME")
			table.Shuffle(radioOffFiles)
			local radioOffFile
			if next(radioOffFiles) ~= nil then
				radioOffFile = "chatter2/"..miscVoiceProfile.."/misc/radiooff/"..radioOffFiles[1]
			end
			
			local chirpGenericFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/*", "GAME")
			table.Shuffle(chirpGenericFiles)
			local chirpGenericFile

			ChatterLastPlay = initTime

			if radioOnFile then
				if ChatterLastPlay ~= initTime then return 5 end
				UVRelayToClients(initTime, radioOnFile, parameters, true)
			else
				if next(chirpGenericFiles) ~= nil then
					chirpGenericFile = "chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/"..chirpGenericFiles[1]
				end

				if chirpGenericFile then
					if ChatterLastPlay ~= initTime then return 5 end
					UVRelayToClients(initTime, chirpGenericFile, parameters, true)
				end
			end
			timer.Simple(radioOnFile and SoundDuration(radioOnFile) or (chirpGenericFile and 0.1 or 0), function()
				if ChatterLastPlay ~= initTime then return 5 end
				if emergencyFile then
					UVRelayToClients(initTime, emergencyFile, parameters, true)
				end
				timer.Simple(SoundDuration(emergencyFile or ""), function()
					if ChatterLastPlay ~= initTime then return 5 end
					if breakawayFile then
						UVRelayToClients(initTime, breakawayFile, parameters, true, nil, (voice == "dispatch" and "uv.unit.dispatch") or (self and self.callsign))
					end
					timer.Simple(SoundDuration(breakawayFile or ""), function()
						if ChatterLastPlay ~= initTime then return 5 end
						if locationFile then
							UVRelayToClients(initTime, locationFile, parameters, true, nil, (voice == "dispatch" and "uv.unit.dispatch") or (self and self.callsign))
						end
						timer.Simple(SoundDuration(locationFile or ""), function()
							if ChatterLastPlay ~= initTime then return 5 end
							if quadrantFile then
								UVRelayToClients(initTime, quadrantFile, parameters, true, nil, (voice == "dispatch" and "uv.unit.dispatch") or (self and self.callsign))
							end
							timer.Simple(SoundDuration(quadrantFile or ""), function()
								if radioOffFile then
									if ChatterLastPlay ~= initTime then return 5 end
									UVRelayToClients(initTime, radioOffFile, parameters, true)
								end
							end)
						end)
					end)
				end)
			end)
			
			return UVDelayChatter((SoundDuration(emergencyFile or "") + SoundDuration(breakawayFile or "") + SoundDuration(locationFile or "") + SoundDuration(quadrantFile or "") + SoundDuration(radioOnFile or "") + SoundDuration(radioOffFile or "") + math.random(0.5, 2) + math.random()))
			
		elseif parameters == 8 then
			local soundFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile..'/'..voice.."/"..chattertype.."/*", "GAME")
			if next(soundFiles) == nil then return 5 end
			table.Shuffle(soundFiles)
			local soundFile = "chatter2/"..unitVoiceProfile..'/'..voice.."/"..chattertype.."/"..soundFiles[1]
			
			local emergencyFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/emergency/*", "GAME")
			table.Shuffle(emergencyFiles)
			local emergencyFile
			if next(emergencyFiles) ~= nil then
				emergencyFile = "chatter2/"..miscVoiceProfile.."/misc/emergency/"..emergencyFiles[1]
			end

			ChatterLastPlay = initTime

			local radioOnFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radioon/*", "GAME")
			table.Shuffle(radioOnFiles)
			local radioOnFile
			if next(radioOnFiles) ~= nil then
				radioOnFile = "chatter2/"..miscVoiceProfile.."/misc/radioon/"..radioOnFiles[1]
			end
			
			local radioOffFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radiooff/*", "GAME")
			table.Shuffle(radioOffFiles)
			local radioOffFile
			if next(radioOffFiles) ~= nil then
				radioOffFile = "chatter2/"..miscVoiceProfile.."/misc/radiooff/"..radioOffFiles[1]
			end

			local chirpGenericFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/*", "GAME")
			table.Shuffle(chirpGenericFiles)
			local chirpGenericFile
			
			if radioOnFile then
				if ChatterLastPlay ~= initTime then return 5 end
				UVRelayToClients(initTime, radioOnFile, parameters, true)
			else
				if next(chirpGenericFiles) ~= nil then
					chirpGenericFile = "chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/"..chirpGenericFiles[1]
				end

				if chirpGenericFile then
					if ChatterLastPlay ~= initTime then return 5 end
					UVRelayToClients(initTime, chirpGenericFile, parameters, true)
				end
			end
			timer.Simple(radioOnFile and SoundDuration(radioOnFile) or (chirpGenericFile and 0.1 or 0), function()
				if ChatterLastPlay ~= initTime then return 5 end
				if emergencyFile then
					UVRelayToClients(initTime, emergencyFile, parameters, true)
				end
				timer.Simple(SoundDuration(emergencyFile or ""), function()
					if ChatterLastPlay ~= initTime then return 5 end
					UVRelayToClients(initTime, soundFile, parameters, true, nil, (voice == "dispatch" and "uv.unit.dispatch") or (self and self.callsign))
					timer.Simple(SoundDuration(soundFile or ""), function()
						if ChatterLastPlay ~= initTime then return 5 end
						if radioOffFile then
							UVRelayToClients(initTime, radioOffFile, parameters, true)
						end
					end)
				end)
			end)
			
			return UVDelayChatter((SoundDuration(soundFile) + SoundDuration(emergencyFile or "") + SoundDuration(radioOnFile or "") + (chirpGenericFile and 0.1 or 0) + SoundDuration(radioOffFile or "") + math.random(0.5, 2) + math.random()))
		elseif parameters == 9 then -- in person chatter
			local players = select(1, ...)

			local soundFiles = CachedFileFind("sound/chatter2/"..unitVoiceProfile..'/'..voice.."/inperson/" ..chattertype.."/*", "GAME")
			if next(soundFiles) == nil then return 5 end
			table.Shuffle(soundFiles)
			local soundFile = "chatter2/"..unitVoiceProfile..'/'..voice.."/inperson/"..chattertype.."/"..soundFiles[1]
			
			UVRelayToClients(initTime, soundFile, parameters, true, players, (voice == "dispatch" and "uv.unit.dispatch") or (self and self.callsign))

			return 0
		elseif parameters == 10 then
			if is_dispatch or isDispatch then
				voice = "dispatch"
				unitVoiceProfile = GetConVar("unitvehicle_unit_dispatch_voiceprofile"):GetString()
			end

			local vehicle = select(2, ...)
			if not IsValid(vehicle) then return 5 end

			local vehicleModel = vehicle.UVVehicleModel or string.Explode( "[ -.]", UVGetVehicleMakeAndModel(vehicle), true )
			local vehicleColor = ( vehicle.UVVehicleColor and {name = vehicle.UVVehicleColor} ) or UVColor(vehicle)

			local _, vehicleBrands = CachedFileFind("sound/chatter2/"..unitVoiceProfile..'/'..voice.."/vehicledescription/*", "GAME")
			if next(vehicleBrands) == nil then return 5 end
			table.Shuffle(vehicleBrands)

			local brand = nil

			for _, vehicleBrand in pairs( vehicleBrands ) do
				local found = false

				if type( vehicleModel ) == "table" then
					for i = 1, #vehicleModel do
						if string.lower( vehicleBrand ) == string.lower( vehicleModel[i] ) then
							brand = vehicleBrand
							found = true
							break
						end
					end
				else
					if string.lower( vehicleBrand ) == string.lower( vehicleModel ) then
						brand = vehicleBrand
						found = true
						break
					end
				end
				

				if found then break end
			end

			if not brand then brand = 'genericsportscar' end

			local soundFiles = CachedFileFind( "sound/chatter2/"..unitVoiceProfile..'/'..voice.."/vehicledescription/"..brand.."/"..vehicleColor.name.."/*", "GAME" )
			if next(soundFiles) == nil then soundFiles = CachedFileFind( "sound/chatter2/"..unitVoiceProfile..'/'..voice.."/vehicledescription/"..brand.."/default/*", "GAME" ) end
			if next(soundFiles) == nil then return UVChatterDispatchCallUnknownDescription(self, vehicle, vehicleModel) end
			table.Shuffle(soundFiles)

			local color = vehicleColor.name
			if not file.Exists( "sound/chatter2/"..unitVoiceProfile..'/'..voice.."/vehicledescription/"..brand.."/"..color, "GAME" ) then color = "default" end
			local soundFile = "chatter2/"..unitVoiceProfile..'/'..voice.."/vehicledescription/"..brand.."/"..color.."/"..soundFiles[1]

			local radioOnFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radioon/*", "GAME")
			table.Shuffle(radioOnFiles)
			local radioOnFile
			if next(radioOnFiles) ~= nil then
				radioOnFile = "chatter2/"..miscVoiceProfile.."/misc/radioon/"..radioOnFiles[1]
			end
			
			local radioOffFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/radiooff/*", "GAME")
			table.Shuffle(radioOffFiles)
			local radioOffFile
			if next(radioOffFiles) ~= nil then
				radioOffFile = "chatter2/"..miscVoiceProfile.."/misc/radiooff/"..radioOffFiles[1]
			end

			local chirpGenericFiles = CachedFileFind("sound/chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/*", "GAME")
			table.Shuffle(chirpGenericFiles)
			local chirpGenericFile

			ChatterLastPlay = initTime
			
			if radioOnFile then
				UVRelayToClients(initTime, radioOnFile, parameters, true)
			else
				if next(chirpGenericFiles) ~= nil then
					chirpGenericFile = "chatter2/"..miscVoiceProfile.."/misc/chirpgeneric/"..chirpGenericFiles[1]
					UVRelayToClients(initTime, chirpGenericFile, parameters, true)
				end
			end
			timer.Simple(radioOnFile and SoundDuration(radioOnFile) or (chirpGenericFile and 0.1 or 0), function()
				if ChatterLastPlay ~= initTime then return 5 end
				UVRelayToClients(initTime, soundFile, parameters, true, nil, (voice == "dispatch" and "uv.unit.dispatch") or (self and self.callsign))
				timer.Simple(SoundDuration(soundFile or ""), function()
					if ChatterLastPlay ~= initTime then return 5 end
					if radioOffFile then
						UVRelayToClients(initTime, radioOffFile, parameters, true)
					end
				end)
			end)

			return UVDelayChatter(SoundDuration(soundFile or "") + SoundDuration(radioOnFile or "") + (chirpGenericFile and 0.1 or 0) + SoundDuration(radioOffFile or "") + math.random(0.5, 2) + math.random())
		end
		
		return HandleCallSounds()
	end
	
	function UVSoundChatter(self, voice, chattertype, parameters, ...)
		if not self or not (GetConVar("unitvehicle_chatter"):GetBool()) then 
			return 5 
		end
		
		local args = {...}
		
		table.insert(UVChatterQueue, {
			func = function()
				return _PlayUVSoundChatter(self, voice, chattertype, parameters, unpack(args))
			end
		})
		
		return 5
	end
	
	--UV old chatter goes here--
	
	function UVChatterOnRemove(self)
		return UVSoundChatter(self, self.voice, "onremove")
	end
	
	function UVChatterArrest(self, enemy)
		UVChatterQueue = {}
		if next(UVCommanders) ~= nil and mathrandomno == 1 then
			local random_entry = math.random(#UVCommanders)
			local unit = UVCommanders[random_entry]
			self = unit
		end
		local time = UVSoundChatter(self, self.voice, "arrest", nil)
		return time == 0 and 5 or time
	end
	
	function UVChatterArrestAcknowledge(self)
		if UV_GetInPursuitCount() > 0 then return end
		return UVSoundChatter(self, self.voice, "arrestacknowledge", 1, "DISPATCH")
	end

	function UVChatterFineArrest(self)
		local driver = UVGetDriver(self.e)
		if driver and driver:IsPlayer() then
			return UVSoundChatter(self, self.voice, "finearrest", 9, {driver})
		end
	end
	
	function UVChatterFinePaid(self)
		local driver = UVGetDriver(self.e)
		if driver and driver:IsPlayer() then
			return UVSoundChatter(self, self.voice, "finepaid", 9, {driver})
		end
	end
	
	function UVChatterWreck(self)
		if (self:GetClass() ~= "uvair" and UVChatterDelayed) or not UVTargeting then return end --Air Unit gets priority
		if self:GetClass() == "uvair" or self:GetClass() == "npc_uvcommander" then UVResetChatterQueue() end
		return UVSoundChatter(self, self.voice, "wreck", 3)
	end
	
	function UVChatterRoadblockMissed(self)
		if UVChatterDelayed then return end
		local randomno = math.random(1,2)
		local a = {"DISPATCH", nil}; local selected = a[math.random(1, #a)]
		if randomno == 1 then
			return UVSoundChatter(self, self.voice, "roadblockmissed")
		else
			return UVSoundChatter(self, self.voice, "roadblockmissed", 1, selected)
		end
	end
	
	function UVChatterRoadblockHit(self)
		if UVChatterDelayed then return end
		local randomno = math.random(1,2)
		local a = {"DISPATCH", nil}; local selected = a[math.random(1, #a)]
		if randomno == 1 then
			if next(ents.FindByClass("npc_uv*")) ~= nil then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				return UVSoundChatter(unit, unit.voice, "roadblockhit")
			end
		else
			return UVSoundChatter(self, self.voice, "roadblockhit", 1, selected)
		end
	end
	
	function UVChatterRoadblockDeployed(self)
		if UVChatterDelayed then return end
		local airrandomno = math.random(1,2)
		local airUnits = ents.FindByClass("uvair")
		if next(airUnits) ~= nil then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
				return UVSoundChatter(unit, unit.voice, "roadblockdeployed")
			end
		end
		local randomno = math.random(1,2)
		local a = {"DISPATCH", nil}; local selected = a[math.random(1, #a)]
		if randomno == 1 then
			return UVSoundChatter(self, self.voice, "roadblockdeployed")
		else
			return UVSoundChatter(self, self.voice, "roadblockdeployed", selected == 'DISPATCH' and 1 or nil, selected)
		end
	end
	
	function UVChatterReportHeat(self, heat)
		local mathrandomno = math.random(1,2)
		if next(UVCommanders) ~= nil and mathrandomno == 1 then
			local random_entry = math.random(#UVCommanders)
			local unit = UVCommanders[random_entry]
			self = unit
		end
		local timeCheck = 5
		local randomChance = math.random(1,3)
		
		if randomChance == 1 then
			local airRandomChance = math.random(1,2)
			local airUnits = ents.FindByClass("uvair")
			if next(airUnits) ~= nil then
				local randomEntry = math.random(#airUnits)
				local unit = airUnits[randomEntry]
				if not (unit.crashing or unit.disengaging) and airRandomChance == 1 then
					timeCheck = UVSoundChatter(unit, unit.voice, "heat" .. heat, 4)
				else
					timeCheck = UVSoundChatter(self, self.voice, "heat" .. heat, 4)
				end
			else
				timeCheck = UVSoundChatter(self, self.voice, "heat" .. heat, 4)
			end
		elseif randomChance == 3 then
			timeCheck = UVSoundChatter(self, self.voice, "heat" .. heat, nil, "DISPATCH")
		else
			timeCheck = UVSoundChatter(self, self.voice, "heat" .. heat, 8)
		end
		
			if next(ents.FindByClass("npc_uv*")) ~= nil and not UVEnemyBusted then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				local timeCheck = 5
				local randomno = math.random(1,2)
				if randomno == 1 then
					timeCheck = UVSoundChatter(self, self.voice, "heat" .. heat .. "acknowledge", 1)
				elseif next(ents.FindByClass("npc_uvspecial")) ~= nil then
					timeCheck = UVSoundChatter(self, self.voice, "heat" .. heat .. "argue", 1)
						if next(ents.FindByClass("npc_uv*")) ~= nil and not UVEnemyBusted then
							local units = ents.FindByClass("npc_uv*")
							local random_entry = math.random(#units)	
							local unit = units[random_entry]
							UVSoundChatter(self, self.voice, "heat" .. heat .. "reassure", nil, "DISPATCH")
						end
				end
			end
		
		return
	end
	
	function UVChatterPursuitStartRanAway(self, target)
		local timecheck = 0.1
		if randomno == 1 then
			timecheck = UVSoundChatter(self, self.voice, "finearrest", 2)
		else
			timecheck = UVSoundChatter(self, self.voice, "pursuitstartranaway", 4)
		end
		target = target or self.e
		timer.Simple(timecheck, function()
			if IsValid(self) and IsValid(target) then
				UVChatterVehicleDescription(self, target)
			end
		end)
		return
	end
	
	function UVChatterPursuitStartAcknowledge(self)
		UVResetChatterQueue()
		if #UVWantedTableVehicle > 1 then
			return UVSoundChatter(Entity(1), "nil", "pursuitstartacknowledgemultipleenemies", nil, "DISPATCH")
		else
			if UVHeatLevel < 2 then
				return UVSoundChatter(Entity(1), "nil", "pursuitstartacknowledge", nil, "DISPATCH")
			elseif UVHeatLevel < 5 then
				return UVSoundChatter(Entity(1), "nil", "pursuitstartacknowledgemed", nil, "DISPATCH")
			else
				return UVSoundChatter(Entity(1), "nil", "pursuitstartacknowledgehigh", nil, "DISPATCH")
			end
		end
	end
	
	function UVChatterTrafficStopSpeeding(self)
		local timecheck = UVSoundChatter(self, self.voice, "trafficstopspeeding")
		timer.Simple(timecheck, function()
			if IsValid(self) and not UVEnemyBusted then
				UVChatterDispatchAcknowledgeRequest(self)
			end
		end)
		return
	end
	
	function UVChatterTrafficStopRammed(self)
		local timecheck = UVSoundChatter(self, self.voice, "trafficstoprammed", 3)
		timer.Simple(timecheck, function()
			if IsValid(self) and not UVEnemyBusted then
				UVChatterDispatchAcknowledgeRequest(self)
			end
		end)
		return
	end
	
	function UVChatterLeftPursuit(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "leftpursuit")
	end
	
	function UVChatterResponding(self)
		if UVChatterDelayed then return end
		local randomno = math.random(1,10)
		local a = {"DISPATCH", nil}; local selected = a[math.random(1, #a)]
		if randomno == 1 then
			return UVSoundChatter(self, self.voice, "responding")
		elseif randomno == 2 then
			if self.v.rhino then
				return UVSoundChatter(self, self.voice, "rhinoresponding", 1, selected)
			end
			return UVSoundChatter(self, self.voice, "responding", 1, selected)
		else
			return
		end
	end
	
	function UVChatterKillswitchStart( self )
		return UVSoundChatter(self, self.voice, "ptkillswitchstart")
	end
	
	function UVChatterKillswitchMissed( self )
		return UVSoundChatter(self, self.voice, "ptkillswitchmissed")
	end

	function UVChatterESFDeployed( self )
		return UVSoundChatter(self, self.voice, "ptesfdeployed")
	end

	function UVChatterESFHit( self )
		return UVSoundChatter(self, self.voice, "ptesfhit")
	end

	function UVChatterESFMissed( self )
		return UVSoundChatter(self, self.voice, "ptesfmissed")
	end

	function UVChatterEMPDeployed( self )
		return UVSoundChatter(self, self.voice, "ptempdeployed")
	end

	function UVChatterEMPHit( self )
		return UVSoundChatter(self, self.voice, "ptemphit")
	end

	function UVChatterEMPMissed( self )
		return UVSoundChatter(self, self.voice, "ptempmissed")
	end

	function UVChatterShockRamDeployed( self )
		return UVSoundChatter(self, self.voice, "ptshockramdeployed")
	end

	function UVChatterShockRamHit( self )
		return UVSoundChatter(self, self.voice, "ptshockramhit")
	end

	function UVChatterShockRamMissed( self )
		return UVSoundChatter(self, self.voice, "ptshockrammissed")
	end

	function UVChatterGPSDartDeployed( self )
		return UVSoundChatter(self, self.voice, "ptgpsdartdeployed")
	end

	function UVChatterGPSDartHit( self )
		return UVSoundChatter(self, self.voice, "ptgpsdarthit")
	end

	function UVChatterGPSDartMissed( self )
		return UVSoundChatter(self, self.voice, "ptgpsdartmissed")
	end

	function UVChatterGrapplerDeployed( self )
		return UVSoundChatter(self, self.voice, "ptgrapplerdeployed")
	end

	function UVChatterGrapplerHit( self )
		return UVSoundChatter(self, self.voice, "ptgrapplerhit")
	end

	function UVChatterGrapplerMissed( self )
		return UVSoundChatter(self, self.voice, "ptgrapplermissed")
	end

	function UVChatterRepairKitDeployed( self )
		return UVSoundChatter(self, self.voice, "ptrepairkitdeployed")
	end
	
	function UVChatterKillswitchHit( self )
		return UVSoundChatter(self, self.voice, "ptkillswitchhit")
	end
	
	function UVChatterSpikeStripDeployed( self )
		return UVSoundChatter(self, self.voice, "ptspikestripdeployed")
	end

	function UVChatterSkyhammerStart( self )
		return UVSoundChatter(self, self.voice, "ptskyhammerstart")
	end

	function UVChatterSkyhammerHit( self )
		return UVSoundChatter(self, self.voice, "ptskyhammerhit")
	end

	function UVChatterSkyhammerMissed( self )
		return UVSoundChatter(self, self.voice, "ptskyhammermissed")
	end
	
	function UVChatterBusting(self)
		if UVChatterDelayed then return end
		local randomno = math.random(1,2)
		if randomno == 1 then
			return UVSoundChatter(self, self.voice, "busting")
		else
			return UVSoundChatter(self, self.voice, "busting", 2)
		end
	end
	
	function UVChatterBustEvaded(self)
		if UVChatterDelayed or not IsValid(self.v) then return end
		if next(UVCommanders) ~= nil and mathrandomno == 1 then
			local random_entry = math.random(#UVCommanders)
			local unit = UVCommanders[random_entry]
			self = unit
		end
		return UVSoundChatter(self, self.voice, "bustevaded")
	end
	
	function UVChatterEnemyInfront(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "enemyinfront")
	end
	
	function UVChatterAggressive(self)
		if UVChatterDelayed then return end
		local timecheck = 5
		local mathrandomno = math.random(1,2)
		if next(UVCommanders) ~= nil and mathrandomno == 1 then
			local random_entry = math.random(#UVCommanders)
			local unit = UVCommanders[random_entry]
			self = unit
		end
		timecheck = UVSoundChatter(self, self.voice, "aggressive")
		timer.Simple(timecheck, function()
			if next(ents.FindByClass("npc_uv*")) ~= nil and not UVEnemyBusted then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if unit == self then return end
				UVChatterAcknowledgeRequest(unit)
			end
		end)
		return
	end
	
	function UVChatterPassive(self)
		if UVChatterDelayed then return end
		local mathrandomno = math.random(1,2)
		if next(UVCommanders) ~= nil and mathrandomno == 1 then
			local random_entry = math.random(#UVCommanders)
			local unit = UVCommanders[random_entry]
			self = unit
		end
		local timecheck = 5
		timecheck = UVSoundChatter(self, self.voice, "passive")
		timer.Simple(timecheck, function()
			if next(ents.FindByClass("npc_uv*")) ~= nil and not UVEnemyBusted then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if unit == self then return end
				UVChatterAcknowledgeGeneral(unit)
			end
		end)
		return
	end
	
	function UVChatterCloseToEnemy(self, target)
		if UVChatterDelayed then return end
		local mathrandomno = math.random(1,2)
		if next(UVCommanders) ~= nil and mathrandomno == 1 then
			local random_entry = math.random(#UVCommanders)
			local unit = UVCommanders[random_entry]
			self = unit
		end
		local randomno = math.random(1,5)
		if randomno == 1 then
			return UVSoundChatter(self, self.voice, "closetoenemy", 2)
		else
			return UVSoundChatter(self, self.voice, "closetoenemy")
		end
		return 0
	end

	function UVChatterCloseToArrest(self)
		return UVSoundChatter(self, self.voice, "arrest", 2)
	end
	
	function UVChatterFoundEnemy(self)
		UVResetChatterQueue()
		return UVSoundChatter(self, self.voice, "foundenemy", 4)
	end
	
	function UVChatterFoundMultipleEnemies(self)
		if UVChatterDelayed then return end
		local airrandomno = math.random(1,2)
		local airUnits = ents.FindByClass("uvair")
		if next(airUnits) ~= nil then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
				return UVSoundChatter(unit, unit.voice, "foundmultipleenemies")
			end
		end
		return UVSoundChatter(self, self.voice, "foundmultipleenemies")
	end
	
	function UVChatterLosing(self)
		local timecheck = 5
		local airrandomno = math.random(1,2)
		local airUnits = ents.FindByClass("uvair")
		UVResetChatterQueue()
		
		if next(airUnits) ~= nil then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
				timecheck = UVSoundChatter(unit, unit.voice, "losing")
			else
				timecheck = UVSoundChatter(self, self.voice, "losing")
			end
		else
			timecheck = UVSoundChatter(self, self.voice, "losing")
		end
		
		timer.Simple(timecheck, function()
			if next(ents.FindByClass("npc_uv*")) ~= nil and UVEnemyEscaping then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				UVChatterLosingAcknowledge(unit)
			end
		end)
		return
	end
	
	function UVChatterLosingAcknowledge(self)
		return UVSoundChatter(self, self.voice, "losingacknowledge", 7)
	end
	
	function UVChatterLosingUpdate(self)
		local randomno = math.random(1,2)
		local airUnits = ents.FindByClass("uvair")
		if next(airUnits) ~= nil and randomno == 1 then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) then
				UVSoundChatter(unit, unit.voice, "losingupdate", 1, "DISPATCH") -- !! MIGHT BE BETTER TO PUT THIS INSIDE THE UNITS FOLDER TOO !!
			else
				UVSoundChatter(self, self.voice, "losingupdate", 1, "DISPATCH") -- !! MIGHT BE BETTER TO PUT THIS INSIDE THE UNITS FOLDER TOO !!
			end
		else
			UVSoundChatter(self, self.voice, "losingupdate", 1, "DISPATCH") -- !! MIGHT BE BETTER TO PUT THIS INSIDE THE UNITS FOLDER TOO !!
		end
		return
	end
	
	function UVChatterLost(self)
		local timecheck = 5
		local a = {"DISPATCH", nil}; local selected = a[math.random(1, #a)]
		timecheck = UVSoundChatter(self, self.voice, "lost", 1, selected)
		timer.Simple(timecheck, function()
			UVSoundChatter(Entity(1), 1, "lostacknowledge", 1, "DISPATCH")
		end)
		return
	end
	
	function UVChatterLostAcknowledge(self)
		return UVSoundChatter(self, self.voice, "lostacknowledge", 1, "DISPATCH")
	end
	
	function UVChatterInitialize(self)
		return UVSoundChatter(self, self.voice, "initialize")
	end
	
	function UVChatterDisengaging(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "disengaging")
	end
	
	function UVChatterExplosiveBarrelDeployed(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "ptexplosivebarreldeployed")
	end
	
	function UVChatterSpikeStripMiss(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "ptspikestripmissed")
	end
	
	function UVChatterSpottedEnemy(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "spottedenemy")
	end
	
	function UVChatterLowOnFuel(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "lowonfuel")
	end
	
	
	function UVChatterSpikeStripHit(unit)
		local airrandomno = math.random(1,2)
		local airUnits = ents.FindByClass("uvair")
		if next(airUnits) ~= nil then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
				return UVSoundChatter(unit, unit.voice, "ptspikestriphit", 1)
			end
		end
		local randomno = math.random(1,2)
		local a = {"DISPATCH", nil}; local selected = a[math.random(1, #a)]
		if randomno == 1 then
			return UVSoundChatter(unit, unit.voice, "ptspikestriphit")
		else
			return UVSoundChatter(unit, unit.voice, selected == "DISPATCH" and "spikestriphit" or "ptspikestriphit", 1, selected)
		end
	end
	
	function UVChatterExplosiveBarrelHit(unit)
		if UVChatterDelayed then return end
		return UVSoundChatter(unit, unit.voice, "ptexplosivebarrelhit")
	end
	
	function UVChatterEnemyCrashed(unit)
		if UVChatterDelayed then return end
		local mathrandomno = math.random(1,2)
		if next(UVCommanders) ~= nil and mathrandomno == 1 then
			local random_entry = math.random(#UVCommanders)
			local unit2 = UVCommanders[random_entry]
			unit = unit2
		end
		local airrandomno = math.random(1, 2)
		local airUnits = ents.FindByClass("uvair")
		if next(airUnits) ~= nil then
			local random_entry = math.random(#airUnits)
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
				return UVSoundChatter(unit, unit.voice, "enemycrashed")
			end
		end
		return UVSoundChatter(unit, unit.voice, "enemycrashed")
	end
	
	--UV new chatter goes here--
	
	function UVChatterDispatchAcknowledgeRequest(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "dispatchacknowledgerequest", 1)
	end
	
	function UVChatterDispatchDenyRequest(self)
		if UVChatterDelayed then return end
		local airrandomno = math.random(1,2)
		local airUnits = ents.FindByClass("uvair")
		if next(airUnits) ~= nil then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
				return UVSoundChatter(unit, unit.voice, "denyrequest")
			end
		end
		return UVSoundChatter(self, self.voice, "denyrequest")
	end
	
	function UVChatterDispatchIdleTalk(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "dispatchidletalk", 1)
	end
	
	function UVChatterAcknowledgeGeneral(self)
		if UVChatterDelayed then return end
		local airrandomno = math.random(1,2)
		local airUnits = ents.FindByClass("uvair")
		if next(airUnits) ~= nil then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
				return UVSoundChatter(unit, unit.voice, "acknowledgegeneral")
			end
		end
		return UVSoundChatter(self, self.voice, "acknowledgegeneral")
	end
	
	function UVChatterAcknowledgeRequest(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "acknowledgerequest")
	end
	
	function UVChatterDenyRequest(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "denyrequest")
	end
	
	function UVChatterIdleTalk(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "idletalk", 1, "DISPATCH")
	end
	
	function UVChatterDamaged(self)
		if UVChatterDelayed or not UVTargeting then return end
		local function ChatterChopperUnavailable()
			if next(ents.FindByClass("npc_uv*")) ~= nil then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if unit == self then return end
				timecheck = UVSoundChatter(unit, unit.voice, "damagedcheckin")
				timer.Simple(timecheck, function()
					if IsValid(self) then
						UVSoundChatter(self, self.voice, "damaged") 
					end
				end)
			end
		end
		local randomno = math.random(1,2)
		local timecheck = 5
		local airUnits = ents.FindByClass("uvair")
		if next(airUnits) ~= nil and randomno == 1 then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) then
				timecheck = UVSoundChatter(unit, unit.voice, "damagedcheckin")
				timer.Simple(timecheck, function()
					if IsValid(self) then
						UVSoundChatter(self, self.voice, "damaged") 
					end
				end)
			else
				ChatterChopperUnavailable()
			end
		else
			ChatterChopperUnavailable()
		end
		return
	end
	
	function UVChatterRammed(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "rammed")
	end
	
	function UVChatterRammedEnemy(self)
		if UVChatterDelayed then return end
		local airrandomno = math.random(1,2)
		local airUnits = ents.FindByClass("uvair")
		if next(airUnits) ~= nil then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
				return UVSoundChatter(unit, unit.voice, "rammedenemy")
			end
		end
		return UVSoundChatter(self, self.voice, "rammedenemy")
	end
	
	function UVChatterRequestBackup(self)
		local timecheck = 5
		local airrandomno = math.random(1,2)
		local gotbackup = not UVBackupUnderway
		local airUnits = ents.FindByClass("uvair")
		local reportingUnit = nil
		local mathrandomno = math.random(1,2)
		if next(UVCommanders) ~= nil and mathrandomno == 1 then
			local random_entry = math.random(#UVCommanders)
			local unit = UVCommanders[random_entry]
			self = unit
		end
		if next(airUnits) ~= nil then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
				timecheck = UVSoundChatter(unit, unit.voice, "requestbackup", 1)
				reportingUnit = unit
			else
				timecheck = UVSoundChatter(self, self.voice, "requestbackup", 1)
				reportingUnit = self
			end
		else
			timecheck = UVSoundChatter(self, self.voice, "requestbackup", 1)
			reportingUnit = self
		end
		if gotbackup then
			UVChatterBackupOnScene(reportingUnit)
		elseif UVGlobalPursuit and UVGlobalPursuit.ResourcePoints > 1 then
			UVChatterBackupOnTheWay(reportingUnit)
		else
			UVChatterDenyBackup(reportingUnit)
		end
		return
	end

	function UVChatterDenyBackup(self)
		local randomno = math.random(1,2)
		UVSoundChatter(self, self.voice, "denybackup", 1, "DISPATCH")
		if randomno == 1 then
			return UVChatterDenyBackupAcknowledge(self)
		end
	end

	function UVChatterDenyBackupAcknowledge(self)
		local mathrandomno = math.random(1,2)
		if next(UVCommanders) ~= nil and mathrandomno == 1 then
			local random_entry = math.random(#UVCommanders)
			local unit = UVCommanders[random_entry]
			self = unit
		end
		return UVSoundChatter(self, self.voice, "denybackupacknowledge", 1)
	end
	
	function UVChatterOnScene(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "onscene", 5)
	end
	
	function UVChatterBackupOnTheWay(self)
		local timecheck = 5
		local randomno = math.random(1,2)
		timecheck = UVSoundChatter(Entity(1), "nil", "backupontheway", 1, "DISPATCH")
		timer.Simple(timecheck, function()
			if next(ents.FindByClass("npc_uv*")) ~= nil and not UVEnemyBusted then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if unit == self then return end
				UVChatterAcknowledgeGeneral(unit)
			end
		end)
		return
	end
	
	function UVChatterBackupOnScene(self)
		if UVChatterDelayed then return end
		local timecheck = 5
		local randomno = math.random(1,2)
		if randomno == 1 then
			local airrandomno = math.random(1,2)
			local airUnits = ents.FindByClass("uvair")
			if next(airUnits) ~= nil then
				local random_entry = math.random(#airUnits)	
				local unit = airUnits[random_entry]
				if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
					timecheck = UVSoundChatter(unit, unit.voice, "backuponscene")
				else
					timecheck = UVSoundChatter(self, self.voice, "backuponscene")
				end
			else
				timecheck = UVSoundChatter(self, self.voice, "backuponscene")
			end
		else
			timecheck = UVSoundChatter(self, self.voice, "backuponscene", 1, "DISPATCH")
		end
		timer.Simple(timecheck, function()
			if next(ents.FindByClass("npc_uv*")) ~= nil and not UVEnemyBusted then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if unit == self then return end
				UVChatterAcknowledgeGeneral(unit)
			end
		end)
		return
	end
	
	function UVChatterHitTraffic(self)
		if UVChatterDelayed then return end
		local airrandomno = math.random(1,2)
		local airUnits = ents.FindByClass("uvair")
		if next(airUnits) ~= nil then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
				return UVSoundChatter(unit, unit.voice, "hittraffic")
			end
		end
		return UVSoundChatter(self, self.voice, "hittraffic")
	end
	
	function UVChatterMultipleUnitsDown(self)
		if UVChatterDelayed or not UVTargeting then return end
		local randomno = math.random(1,2)
		local timecheck = 5
		local airUnits = ents.FindByClass("uvair")
		if next(airUnits) ~= nil and randomno == 1 then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) then
				timecheck = UVSoundChatter(unit, unit.voice, "multipleunitsdown", 4)
			else
				timecheck = UVSoundChatter(self, self.voice, "multipleunitsdown", 4)
			end
		else
			timecheck = UVSoundChatter(self, self.voice, "multipleunitsdown", 4)
		end
		timer.Simple(timecheck, function()
			if IsValid(self) then
				return UVSoundChatter(self, self.voice, "dispatchmultipleunitsdownacknowledge", 1, "DISPATCH")
			end
		end)
		return
	end
	
	function UVChatterAirDown(self)
		return UVSoundChatter(self, self.voice, "airdown", 4)
	end
	
	function UVChatterRequestSitrep(self)
		if UVChatterDelayed then return end
		local MathAsk = math.random(1,2)
		local mathrandomno = math.random(1,2)
		if next(UVCommanders) ~= nil and mathrandomno == 1 then
			local random_entry = math.random(#UVCommanders)
			local unit = UVCommanders[random_entry]
			self = unit
		end
		if MathAsk == 2 then
			if UVEnemyEscaping then --During cooldown
				UVChatterLosingUpdate(self)
			else
				local MathReply = math.random(1,2)
				if MathReply == 1 then
					UVChatterSitrep(self)
				else
					UVChatterUpdateHeading(self)
				end
			end
			return
		end
		local timecheck = 5
		timecheck = UVSoundChatter(self, self.voice, "requestsitrep", 1, "DISPATCH")
		timer.Simple(timecheck, function()
			if IsValid(self) then
				if UVEnemyEscaping then --During cooldown
					UVChatterLosingUpdate(self)
				else
					local MathReply = math.random(1,2)
					if MathReply == 1 then
						UVChatterSitrep(self)
					else
						UVChatterUpdateHeading(self)
					end
				end
			end
		end)
		return
	end
	
	function UVChatterSitrep(self)
		local airrandomno = math.random(1,2)
		local airUnits = ents.FindByClass("uvair")
		if next(airUnits) ~= nil then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
				return UVSoundChatter(unit, unit.voice, "sitrep")
			end
		end
		return UVSoundChatter(self, self.voice, "sitrep")
	end
	
	function UVChatterUpdateHeading(self)
		if not IsValid(self.e) then return end
		local Heading = self.e:GetVelocity():Angle().y
		local args = {}
		
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.e:GetVelocity():Length2DSqr() < 50000 then --Stopped
			return UVSoundChatter(self, self.voice, "headingstopped")
		elseif Heading > 45 and Heading < 135 then --North
			local airrandomno = math.random(1,2)
			local airUnits = ents.FindByClass("uvair")
			if next(airUnits) ~= nil then
				local random_entry = math.random(#airUnits)	
				local unit = airUnits[random_entry]
				if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
					return UVSoundChatter(unit, unit.voice, "headingnorth")
				end
			end
			return UVSoundChatter(self, self.voice, "headingnorth")
		elseif Heading > 315 and Heading < 45 then --East
			local airrandomno = math.random(1,2)
			local airUnits = ents.FindByClass("uvair")
			if next(airUnits) ~= nil then
				local random_entry = math.random(#airUnits)	
				local unit = airUnits[random_entry]
				if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
					return UVSoundChatter(unit, unit.voice, "headingeast")
				end
			end
			return UVSoundChatter(self, self.voice, "headingeast")
		elseif Heading > 225 and Heading < 315 then --South
			local airrandomno = math.random(1,2)
			local airUnits = ents.FindByClass("uvair")
			if next(airUnits) ~= nil then
				local random_entry = math.random(#airUnits)	
				local unit = airUnits[random_entry]
				if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
					return UVSoundChatter(unit, unit.voice, "headingsouth")
				end
			end
			return UVSoundChatter(self, self.voice, "headingsouth")
		elseif Heading > 135 and Heading < 225 then --West
			local airrandomno = math.random(1,2)
			local airUnits = ents.FindByClass("uvair")
			if next(airUnits) ~= nil then
				local random_entry = math.random(#airUnits)	
				local unit = airUnits[random_entry]
				if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
					return UVSoundChatter(unit, unit.voice, "headingwest")
				end
			end
			return UVSoundChatter(self, self.voice, "headingwest")
		end
	end
	
	function UVChatterRequestDisengage(self)
		if UVChatterDelayed then return end
		local timecheck = 5
		local airrandomno = math.random(1,2)
		local airUnits = ents.FindByClass("uvair")
		if next(airUnits) ~= nil then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
				timecheck = UVSoundChatter(unit, unit.voice, "requestdisengage")
			else
				timecheck = UVSoundChatter(self, self.voice, "requestdisengage")
			end
		else
			timecheck = UVSoundChatter(self, self.voice, "requestdisengage")
		end
		--timer.Simple(timecheck, function()
			if next(ents.FindByClass("npc_uv*")) ~= nil and not UVEnemyBusted then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)
				local unit = units[random_entry]
				if unit == self then return end
				UVChatterDoNotDisengage(unit, self)
			end
		--end)
		return
	end
	
	function UVChatterDoNotDisengage(self, unit)
		local mathrandomno = math.random(1,2)
		if next(UVCommanders) ~= nil and mathrandomno == 1 then
			local random_entry = math.random(#UVCommanders)
			local unit = UVCommanders[random_entry]
			self = unit
		end
		return UVSoundChatter(self, self.voice, "donotdisengage")
	end
	
	function UVChatterDispatchCallDamageToProperty(heatlevel)
		return UVSoundChatter(Entity(1), 1, "dispatchcalldamagetoproperty", 6)
	end
	
	function UVChatterDispatchCallHitAndRun(heatlevel)
		return UVSoundChatter(Entity(1), 1, "dispatchcallhitandrun", 6)
	end
	
	function UVChatterDispatchCallSpeeding(heatlevel)
		return UVSoundChatter(Entity(1), 1, "dispatchcallspeeding", 6)
	end
	
	function UVChatterDispatchCallStreetRacing(heatlevel)
		return UVSoundChatter(Entity(1), 1, "dispatchcallstreetracing", 6)
	end
	
	function UVChatterDispatchCallVehicleDescription(self, vehicle, model)
		return UVSoundChatter(self, self.voice, nil, 10, "DISPATCH", vehicle)
	end
	
	function UVChatterDispatchCallUnknownDescription(self)
		return UVSoundChatter(self, self.voice, "dispatchcallunknowndescription", 1, "DISPATCH")
	end
	
	function UVChatterCallRequestDescription(self)
		return UVSoundChatter(self, self.voice, "callrequestdescription", 1)
	end
	
	function UVChatterCallResponding(self)
		return UVSoundChatter(self, self.voice, "callresponding", 5)
	end
	
	function UVChatterCallResponded(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "callresponded")
	end
	
	function UVChatterPursuitStartWanted(self, vehicle)
		local timecheck = 5
		timecheck = UVSoundChatter(self, self.voice, "pursuitstartwanted", 4)
		local e = UVGetVehicleMakeAndModel(self.e or vehicle)
		UVChatterVehicleDescription(self, self.e or vehicle, e)
		return
	end
	
	function UVChatterStuntJump(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "stuntjump")
	end
	
	function UVChatterStuntRoll(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "stuntroll")
	end
	
	function UVChatterStuntSpin(self)
		if UVChatterDelayed then return end
		return UVSoundChatter(self, self.voice, "stuntspin")
	end

	function UVChatterVehicleDescription(self, vehicle)
		local timecheck = UVSoundChatter(self, self.voice, nil, 10, "", vehicle)
		UVChatterPursuitStartAcknowledge(self)
		return
	end

	function UVChatterHitTrafficSemi(self)
		if UVChatterDelayed then return end
		local airrandomno = math.random(1,2)
		local airUnits = ents.FindByClass("uvair")
		if next(airUnits) ~= nil then
			local random_entry = math.random(#airUnits)	
			local unit = airUnits[random_entry]
			if not (unit.crashing or unit.disengaging) and airrandomno == 1 then
				return UVSoundChatter(unit, unit.voice, "hittrafficsemi")
			end
		end
		return UVSoundChatter(self, self.voice, "hittrafficsemi")
	end
	
end