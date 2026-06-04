ENT.Base = "base_brush"
ENT.Type = "brush"

AccessorFunc( ENT, "pos1", "Pos1")
AccessorFunc( ENT, "pos2", "Pos2")
AccessorFunc( ENT, "speedlimit", "SpeedLimit")
AccessorFunc( ENT, "chunk", "Chunk")
AccessorFunc( ENT, "chunkmax", "ChunkMax")

if SERVER then
	function ENT:SetupDataTables()
		self:NetworkVar("Int", 0, "ID")
		self:NetworkVar("Bool", 0, "FinishLine")
	end

	function ENT:Initialize()
		self:SetSolid(SOLID_BBOX)
		self:SetCollisionBoundsWS(self:GetPos1(), self:GetPos2())
		
		local pos1 = (InfMap and InfMap.unlocalize_vector(self:GetPos1(), self:GetChunk())) or self:GetPos1()
		local pos2 = (InfMap and InfMap.unlocalize_vector(self:GetPos2(), self:GetChunkMax())) or self:GetPos2()

		local lowest_y = math.min(pos1.y, pos2.y)

		local target = (pos2 + pos1) / 2

		self.target_point = target

		self:DrawShadow(false)
	end

	function ENT:SetupGlobals( activator, caller )
		ACTIVATOR = activator
		CALLER = caller

		if ( IsValid( activator ) and activator:IsPlayer() ) then
			TRIGGER_PLAYER = activator
		end
	end

	function ENT:KillGlobals()
		ACTIVATOR = nil
		CALLER = nil
		TRIGGER_PLAYER = nil
	end

	function ENT:StartTouch(vehicle)
		if not vehicle.uvraceparticipant then return end
		if vehicle.uvbusted then return end
		if InfMap then
			if vehicle.CHUNK_OFFSET ~= self:GetChunk() and vehicle.CHUNK_OFFSET ~= self:GetChunkMax() then return end
		end

		local driver = vehicle:GetDriver()//vehicle.racedriver
	
		self:SetupGlobals(vehicle, vehicle)

		if not UVRaceTable or not UVRaceTable['Participants'] then return end
		if not UVRaceTable['Participants'][vehicle] then return end

		local vehicle_array = UVRaceTable['Participants'][vehicle]

		if vehicle_array.Disqualified or vehicle_array.Busted then return end

		local last_checkpoint = #vehicle_array['Checkpoints']
		local next_checkpoint = last_checkpoint + 1
		local total_checkpoints = GetGlobalInt("uvrace_checkpoints", 0)
		local splits = 3

		local checkp_id = self:GetID()

		if next_checkpoint == checkp_id then --Checkpoint passed
			vehicle_array['Checkpoints'][checkp_id] = CurTime()

			net.Start("uvrace_checkpointcomplete")
			net.WriteEntity(vehicle)
			net.WriteInt(checkp_id, 11)
			net.WriteFloat(vehicle_array['Checkpoints'][checkp_id])
			net.Broadcast()

			if #vehicle_array['Checkpoints'] >= GetGlobalInt("uvrace_checkpoints") then -- Lap completed

				local laptime = CurTime() - (vehicle_array['LastLapCurTime'] or UVRaceTable.Info.Time)
				vehicle_array['LastLapTime'] = laptime
				vehicle_array['LastLapCurTime'] = CurTime()

				table.Empty(vehicle_array['Checkpoints'])

				for veh, data in pairs(UVRaceTable['Participants']) do
					if not IsValid(veh) then continue end
					local ply = veh:GetDriver()
					if IsValid(ply) and ply:IsPlayer() then
						net.Start("uvrace_lapcomplete")
						net.WriteEntity(vehicle)
						net.WriteFloat(laptime)
						net.WriteFloat(vehicle_array['LastLapCurTime'])
						net.Send(ply)
					end
				end
				UVCheckLapTime( vehicle, vehicle_array.Name, laptime )
				
				if vehicle_array['Lap'] == UVRaceTable.Info.Laps then --Completed race
					vehicle_array['Lap'] = 1
					vehicle_array['Finished'] = true

					vehicle.racefinished = true
					vehicle.uvraceparticipant = false

					local place = 1

					for veh, array in pairs(UVRaceTable['Participants']) do
						if array.Finished and vehicle ~= veh then
							place = place +1
						end
					end

					net.Start("uvrace_racecomplete")
					net.WriteEntity(vehicle)
					net.WriteInt(place, 32)
					net.WriteFloat(CurTime() - UVRaceTable.Info.Time)
					net.Broadcast()

					local driver = UVGetDriver( vehicle )
					if driver then
						UVActionCam(driver, "RaceFinish")
					end
					
					UVRaceRemoveParticipant( vehicle, 'Finished' )
				else
					vehicle_array['Lap'] = vehicle_array['Lap'] +1
				end

			end

		end

		vehicle_array.SplitCheckpoints = {}

		if total_checkpoints <= 1 then -- If just one checkpoint, don't trigger at all
			vehicle_array.SplitCheckpoints = {}
		elseif total_checkpoints <= splits then -- If less than or up to 3 checkpoints, trigger on every single one
			for i = 1, total_checkpoints do
				vehicle_array.SplitCheckpoints[i] = true
			end
		else -- Otherwise, trigger at 25, 50 and 75% completion
			for i = 1, splits do
				local split_cp = math.floor((total_checkpoints / (splits + 1)) * i)
				if split_cp > 0 then
					vehicle_array.SplitCheckpoints[split_cp] = true
				end
			end
		end

		if vehicle_array.SplitCheckpoints[checkp_id] and checkp_id == next_checkpoint then
			local driver = vehicle:GetDriver()
			local numParticipants = table.Count(UVRaceTable.Participants or {})
			
			if IsValid(driver) and driver:IsPlayer() then
				net.Start("uvrace_checkpointsplit")
				net.WriteEntity(vehicle)
				net.WriteInt(checkp_id, 11)
				net.WriteUInt(numParticipants, 8)
				net.Send(driver)
			end
		end

		self:KillGlobals()
	end
end