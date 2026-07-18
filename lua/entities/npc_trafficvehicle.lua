list.Set("NPC", "npc_trafficvehicle", {
	Name = "#uv.npc.0trafficvehicle",
	Class = "npc_trafficvehicle",
	Category = "#uv.unitvehicles"
})

AddCSLuaFile("npc_trafficvehicle.lua")

ENT.Base = "base_entity"
ENT.Type = "ai"

include("entities/uvapi.lua")

ENT.PrintName = "TrafficVehicle"
ENT.Author = "Ranjeet"
ENT.Contact = "Tango"
ENT.Purpose = "*honking sound*"
ENT.Instruction = "Spawn on/under the vehicle until it shows a spawn effect."
ENT.Spawnable = false
ENT.Modelname = "models/props_lab/huladoll.mdl"

local ENT = ENT

local dvd = DecentVehicleDestination

if SERVER then	
	--Setting ConVars.
	local DetectionRange = GetConVar("unitvehicle_detectionrange")
	local CanWreck = GetConVar("unitvehicle_canwreck")
	local OptimizeRespawn = GetConVar("unitvehicle_optimizerespawn")
	local TrafficStreaming = GetConVar("unitvehicle_trafficstreaming") 
	local SpeedLimit = GetConVar("unitvehicle_speedlimit")
	local DVWaypointsPriority = GetConVar("unitvehicle_dvwaypointspriority")
	
	function ENT:OnRemove()
		--By undoing, driving, diving in water, or getting stuck, and the vehicle is remaining.
		if IsValid(self.v) then
			self.v.TrafficVehicle = nil
			local steerinput = (math.random(-100, 100)) / 100
			if self.v.IsScar then --If the vehicle is SCAR.
				self.v.HasDriver = self.v.BaseClass.HasDriver --Restore some functions.
				self.v.SpecialThink = self.v.BaseClass.SpecialThink
				if not self.v:HasDriver() then --If there's no driver, stop the engine.
					self.v:TurnOffCar()
					self.v:HandBrakeOn()
					self.v:GoNeutral()
					self.v:NotTurning()
				end
			elseif self.v.IsSimfphyscar then --The vehicle is Simfphys Vehicle.
				self.v.GetDriver = self.v.OldGetDriver or self.v.GetDriver
				if not IsValid(self.v:GetDriver()) then --If there's no driver, stop the engine.
					self.v:StopEngine()
				end
				self.v.PressedKeys = self.v.PressedKeys or {} --Reset key states.
				self.v.PressedKeys["Shift"] = false
				if self.v.wrecked then
					local randomno = math.random(1, 3)
					if randomno == 1 then
						self.v.PressedKeys["Space"] = false
					elseif randomno == 2 then
						self.v.PressedKeys["Space"] = true
					elseif randomno == 3 then
						self.v:SetActive(false)
					end
					self.v:PlayerSteerVehicle(self, steerinput < 0 and -steerinput or 0, steerinput > 0 and steerinput or 0)
				end
			elseif not IsValid(self.v:GetDriver()) and --The vehicle is normal vehicle.
			(isfunction(self.v.StartEngine) and isfunction(self.v.SetHandbrake) and 
			isfunction(self.v.SetThrottle) and isfunction(self.v.SetSteering) and not self.v.IsGlideVehicle) or self.v.LVS then
				self.v.GetDriver = self.v.OldGetDriver or self.v.GetDriver
				self.v:SetThrottle(0)
				if self.v.wrecked then
					if self.v.LVS then
						self.v:SetSteer(steerinput * self.v:GetMaxSteerAngle())
					else
						self.v:SetSteering(steerinput, 0)
					end
				end
			elseif self.v.IsGlideVehicle then
				self.v:TurnOff()
				self.v:TriggerInput("Throttle", 0)
				if self.v.wrecked then
					local randomno = math.random(1, 4)
					if randomno == 1 then
						self.v:TriggerInput("Handbrake", 0)
						self.v:TriggerInput("Brake", 0)
					elseif randomno == 2 then
						self.v:TriggerInput("Handbrake", 1)
						self.v:TriggerInput("Brake", 0)
					elseif randomno == 3 then
						self.v:TriggerInput("Handbrake", 0)
						self.v:TriggerInput("Brake", 1)
					elseif randomno == 4 then
						self.v:TriggerInput("Handbrake", 1)
						self.v:TriggerInput("Brake", 1)
					end
					self.v:TriggerInput("Steer", steerinput)
				else
					self.v:TriggerInput("Handbrake", 1)
					self.v:TriggerInput("Brake", 0)
				end
			end

			self:SetHorn(false)
			
			local e = EffectData()
			e:SetEntity(self.v)
			util.Effect("entity_remove", e) --Perform an effect.

			if (self.uvscripted and not self.wrecked) then
				SafeRemoveEntity(self.v)
			end

			if not self.wrecked and self.v.DriverModel and IsValid(self.v.DriverModel) then 
				self.v.DriverModel:Remove() 
			end
			
		end
		
	end

	function ENT:IsWrecked()
		if not self.v then return end
		if self.v:IsFlagSet(FL_DISSOLVING) then return true end
		if self.v.IsScar then
			return self.v:IsDestroyed()
		elseif self.v.IsSimfphyscar then
			return self.v:GetCurHealth() <= 0 or self.v:OnFire() or self.v.destroyed
		elseif self.v.IsGlideVehicle then
			return self.v:GetEngineHealth() <= 0 or self.v:GetIsEngineOnFire()
		elseif self.v.LVS then
			local vehEngine = self.v:GetEngine()
			return (self.v:GetHP() <= 0 or self.v.ExplodedAlready) or (vehEngine and (vehEngine:GetHP() <= 0 or vehEngine:GetDestroyed()))
		elseif isfunction(self.v.VC_GetHealth) then
			local health = self.v:VC_GetHealth(false)
			return isnumber(health) and health <= 0
		end
	end

	function ENT:Stop()
		self.moving = CurTime()
		self.PatrolWaypoint = nil
		self:SetELS(false)
		self:SetELSSound(false)
		self:SetHorn(false)

		if self.v.rammed then
			self:SetHorn(true)
		else
			self:SetHorn(false)
		end

		if self.v.IsScar then
			self.v:GoNeutral()
			self.v:NotTurning()
			self.v:HandBrakeOn()
		elseif self.v.IsSimfphyscar then
			self.v:SetActive(true)
			self.v:StartEngine()
			self.v.PressedKeys = self.v.PressedKeys or {}
			self.v.PressedKeys["W"] = false
			self.v.PressedKeys["A"] = false
			self.v.PressedKeys["S"] = false
			self.v.PressedKeys["D"] = false
			self.v.PressedKeys["Shift"] = false
			self.v.PressedKeys["Space"] = true
			self.v.PressedKeys["joystick_throttle"] = 0
			self.v.PressedKeys["joystick_brake"] = 0
		elseif isfunction(self.v.SetThrottle) and isfunction(self.v.SetSteering) and isfunction(self.v.SetHandbrake) and not self.v.IsGlideVehicle then
			self.v:SetThrottle(0)
			self.v:SetSteering(0, 0)
			self.v:SetHandbrake(true)
		elseif self.v.IsGlideVehicle then
			self.v:TriggerInput("Handbrake", 1)
			self.v:TriggerInput("Throttle", 0)
			self.v:TriggerInput("Brake", 0)
			self.v:TriggerInput("Steer", 0)
		end
	end
	
	function ENT:ObstaclesNearby()
		if not self.v or not self.v.rideheight then
			return
		end

		local class = self.v:GetClass()
		local pos = self.v:WorldSpaceCenter()
		pos.z = pos.z + self.v.rideheight

		local tr = util.TraceLine({start = pos, endpos = (pos+(self.v:GetVelocity()*2)), mask = MASK_ALL, filter = {self, self.v, 'glide_wheel'}})
		local Fraction = tr.Fraction ~= 1
		local HitNormal = tr.HitNormal.z < 0.45 --Ignore small inclines

		if debugoverlay then
			debugoverlay.Line(pos, pos+(self.v:GetVelocity()*2), 0.1, Color(0, 255, 0), true)
		end

		return tobool(Fraction and HitNormal)
	end

	function ENT:ObstaclesNearbySide()
		if not self.v or not self.v.width then
			return
		end

		local width = self.v.width/2
		local turnleft = -1
		local turnright = 1

		local speed = self.v:GetVelocity():LengthSqr()
		speed = math.sqrt(speed)

		local left = Vector(-width,math.Clamp(speed, width, math.huge),0)
		local right = Vector(width,math.Clamp(speed, width, math.huge),0)
		local leftstart = Vector(-width,0,0)
		local rightstart = Vector(width,0,0)

		if self.v.IsSimfphyscar then
			left:Rotate(Angle(0, (self.v.VehicleData.LocalAngForward.y-90), 0))
			right:Rotate(Angle(0, (self.v.VehicleData.LocalAngForward.y-90), 0))
			leftstart:Rotate(Angle(0, (self.v.VehicleData.LocalAngForward.y-90), 0))
			rightstart:Rotate(Angle(0, (self.v.VehicleData.LocalAngForward.y-90), 0))
		elseif self.v.IsGlideVehicle or self.v.LVS then
			left:Rotate(Angle(0, -90, 0))
			right:Rotate(Angle(0, -90, 0))
			leftstart:Rotate(Angle(0, -90, 0))
			rightstart:Rotate(Angle(0, -90, 0))
		end
		
		local trleft = util.TraceLine({start = self.v:LocalToWorld(leftstart), endpos = (self.v:LocalToWorld(left)+(vector_up * 50)), mask = MASK_ALL, filter = {self, self.v, 'glide_wheel'}})
		local trright = util.TraceLine({start = self.v:LocalToWorld(rightstart), endpos = (self.v:LocalToWorld(right)+(vector_up * 50)), mask = MASK_ALL, filter = {self, self.v, 'glide_wheel'}})

		if debugoverlay then
			debugoverlay.Line(self.v:LocalToWorld(leftstart), self.v:LocalToWorld(left)+(vector_up * 50), 0.1, Color(0, 255, 0), true)
			debugoverlay.Line(self.v:LocalToWorld(rightstart), self.v:LocalToWorld(right)+(vector_up * 50), 0.1, Color(255, 0, 0), true)
		end

		local Fraction = trleft.Fraction ~= 1 or trright.Fraction ~= 1
		local HitNormal = trleft.HitNormal.z < 0.45 or trright.HitNormal.z < 0.45 --Ignore small inclines

		if not tobool(Fraction and HitNormal) then return false end

		local vehicleleft = trleft.Entity
		local vehicleright = trright.Entity

		if trleft.Fraction > trright.Fraction then
			UVAddInfraction(vehicleleft, 'endanger')
			return turnleft
		end
		if trleft.Fraction < trright.Fraction then
			UVAddInfraction(vehicleright, 'endanger')
			return turnright
		end

		return false

	end

	function ENT:FindPatrol()

		if next(dvd.Waypoints) == nil then
			return
		end

		local Waypoint = dvd.GetNearestWaypoint(self.v:WorldSpaceCenter())
		if Waypoint.Neighbors then
			local WaypointTable = {}
			for k, v in pairs(Waypoint.Neighbors) do
				if dvd.Waypoints[v].Group == 0 and (not self.PreviousPatrolWaypoint or self.PreviousPatrolWaypoint["Target"] ~= dvd.Waypoints[v]["Target"]) then
					table.insert(WaypointTable, v)
				end
			end --Don't turn around
			self.PatrolWaypoint = dvd.Waypoints[WaypointTable[math.random(#WaypointTable)]]
		else
			self.PatrolWaypoint = Waypoint
		end

	end

	function ENT:Patrol()

		if next(dvd.Waypoints) == nil then
			return
		end

		if self.PatrolWaypoint then

			if not self.patrolling then
				self.patrolling = true
			end

			--Set handbrake
			if self.v.IsScar then
				self.v:HandBrakeOff()
			elseif self.v.IsSimfphyscar then
				self.v:SetActive(true)
				self.v:StartEngine()
				self.v.PressedKeys = self.v.PressedKeys or {}
				self.v.PressedKeys["Space"] = false
			elseif isfunction(self.v.SetHandbrake) and not self.v.IsGlideVehicle then
				self.v:SetHandbrake(false)
			elseif self.v.IsGlideVehicle then
				self.v:TriggerInput("Handbrake", 0)
			end

			self.waypointPos = self.PatrolWaypoint["Target"]+(vector_up * 50)

			local selfvelocity = self.v:GetVelocity():LengthSqr()
			
			--Patrolling techniques
			local forward = self.v.IsSimfphyscar and self.v:LocalToWorldAngles(self.v.VehicleData.LocalAngForward):Forward() or self.v:GetForward()
			local dist = self.waypointPos - self.v:WorldSpaceCenter()
			local vect = dist:GetNormalized()
			local vectdot = vect:Dot(self.v:GetVelocity())
			local throttle = dist:Dot(forward) > 0 and 1 or -1
			local right = vect:Cross(forward)
			local steer_amount = right:Length()
			local steer = right.z > 0 and steer_amount or -steer_amount
			local speedlimitmph = self.PatrolWaypoint["SpeedLimit"]
			self.Speeding = speedlimitmph^2

			--Unique patrolling techniques
			if self.stuck then
				if right.z > 0 then 
					steer = -1 
				else 
					steer = 1 
				end
				throttle = throttle * -1
			end --Getting unstuck
			if not self.respondingtocall and (selfvelocity > self.Speeding or selfvelocity > 1115136) then
				throttle = -1
			end
			if GetConVar("unitvehicle_tractioncontrol"):GetBool() and selfvelocity > 10000 and not self.stuck then
				if self.v.IsSimfphyscar then
					if istable(self.v.Wheels) then
						for i = 1, table.Count( self.v.Wheels ) do
							local Wheel = self.v.Wheels[ i ]
							if not Wheel then return end
							if isfunction(Wheel.GetGripLoss) and Wheel:GetGripLoss() > 0 then
								throttle = throttle * Wheel:GetGripLoss() --Simfphys traction control
							end
						end
					end
				elseif self.v.IsGlideVehicle then
					local EntityMeta = FindMetaTable( "Entity" )
					local getTable = EntityMeta.GetTable
					local selfvTbl = getTable( self.v )
					local wheelslip = selfvTbl.avgForwardSlip > 0 and selfvTbl.avgForwardSlip or selfvTbl.avgForwardSlip < 0 and selfvTbl.avgForwardSlip * -1
					if wheelslip ~= false then
						throttle = throttle - (wheelslip/10) --Glide traction control
					end
				else
					local maththrottle = throttle - math.abs(steer)
					if maththrottle >= 0 then
						throttle = maththrottle
					end --Cornering
				end
			end
			if dist:Dot(forward) < 0 and not self.stuck then
				if vectdot > 0 then
					if right.z > 0 then 
						steer = -1 
					else 
						steer = 1 
					end
				else
					if right.z < 0 then 
						steer = -1 
					else 
						steer = 1 
					end
				end
			end --K turn

			local turn = self:ObstaclesNearbySide()
			if turn then
				if turn == -1 then
					if vectdot > 0 then
						steer = -1
					else
						steer = 1
					end
				end
				if turn == 1 then
					if vectdot > 0 then
						steer = 1
					else
						steer = -1
					end
				end
			end

			if self.v.rammed then
				self:SetHorn(true)
			else
				self:SetHorn(false)
			end

			local speedInUnits = self.v:GetVelocity():Length()
			local arrivalThreshold = math.Clamp(150 + (speedInUnits * 0.5), 150, 600)

			if dist:Length() < arrivalThreshold and UVStraightToWaypoint(self.v:WorldSpaceCenter(), self.waypointPos) then
			    if self.PatrolWaypoint.Neighbors then
			        local WaypointTable = {}
			        for k, v in pairs(self.PatrolWaypoint.Neighbors) do
			            -- Ensure we aren't picking the waypoint we literally just came from
			            if dvd.Waypoints[v].Group == 0 and (not self.PreviousPatrolWaypoint or self.PreviousPatrolWaypoint["Target"] ~= dvd.Waypoints[v]["Target"]) then
			                table.insert(WaypointTable, v)
			            end
			        end
				
			        if #WaypointTable > 0 then
			            self.PreviousPatrolWaypoint = self.PatrolWaypoint
			            self.PatrolWaypoint = dvd.Waypoints[WaypointTable[math.random(#WaypointTable)]]
			            -- Small delay before allowing the next waypoint switch to prevent "bouncing"
			            self.NextWaypointTime = CurTime() + 0.5 
			        else
			            self.PatrolWaypoint = nil
			        end
			    else
			        self.PatrolWaypoint = nil
			    end
			end

			-- === START OF NEW OBSTACLE DETECTION STOP LOGIC ===
			local currentSpeed = self.v:GetVelocity():Length()
			local lookDist = math.max(250, currentSpeed * 0.8) 
			
			local traceStart = self.v:WorldSpaceCenter()
			local carLength = self.v.length or 120
			-- Project trace slightly ahead of the vehicle to prevent clipping own bumper
			traceStart = traceStart + (forward * (carLength * 0.5 + 10))

			-- Gather all parts of the vehicle to prevent self-collision in trace
			local filterTable = {self, self.v}
			if self.v.UVConstrainedEntities then
				for _, ent in pairs(self.v.UVConstrainedEntities) do
					if IsValid(ent) then table.insert(filterTable, ent) end
				end
			else
				local constraints = constraint.GetAllConstrainedEntities(self.v)
				if constraints then
					for _, ent in pairs(constraints) do
						if IsValid(ent) then table.insert(filterTable, ent) end
					end
				end
			end

			local trBlock = util.TraceHull({
				start = traceStart,
				endpos = traceStart + (forward * lookDist),
				mins = Vector(-30, -30, -10),
				maxs = Vector(30, 30, 50),
				filter = filterTable
			})

			local forceStop = false

			if trBlock.Hit and IsValid(trBlock.Entity) then
				local hitEnt = trBlock.Entity
				local class = string.lower(hitEnt:GetClass() or "")
				
				-- Ignore wheels entirely to prevent phantom stops
				if not string.find(class, "wheel") then
					local isPerson = hitEnt:IsPlayer() or hitEnt:IsNPC() or hitEnt:IsNextBot()
					local isVehicle = hitEnt:IsVehicle() or string.find(class, "simfphys") or string.find(class, "lvs") or string.find(class, "scar") or string.find(class, "vehicle")
					local isProp = string.find(class, "prop_")
					
					if isPerson or isVehicle or isProp then
						forceStop = true
						throttle = 0
						steer = 0
					end
				end
			end
			-- === END OF NEW OBSTACLE DETECTION STOP LOGIC ===

			--Emergency Stop
			if self.emergencystop then
				if not self.emergencystopcooldown then
					self.emergencystopcooldown = true
					timer.Simple(10, function()
						if IsValid(self) then
							self.emergencystop = nil
							self.emergencystopcooldown = nil
						end
					end)
				end

				throttle = 0
				steer = 0
				
				forceStop = true
			end

			--Set throttle/steering based on forced stop values
			if self.v.IsScar then
				if forceStop then
					self.v:GoForward(0)
					self.v:GoBack(0)
					self.v:HandBrakeOn()
					self.v:NotTurning()
				else
					if throttle > 0 then
						self.v:GoForward(throttle)
					else
						self.v:GoBack(-throttle)
					end
					if steer > 0 then
						self.v:TurnRight(steer)
					elseif steer < 0 then
						self.v:TurnLeft(-steer)
					else
						self.v:NotTurning()
					end
				end
			elseif self.v.IsSimfphyscar then
				self.v:SetActive(true)
				self.v:StartEngine()
				self.v.PressedKeys = self.v.PressedKeys or {}
				self.v.PressedKeys["Shift"] = false
				self.v.PressedKeys["joystick_throttle"] = throttle
				
				if forceStop then
					self.v.PressedKeys["joystick_brake"] = 1
					self.v.PressedKeys["Space"] = true
				else
					self.v.PressedKeys["joystick_brake"] = throttle * -1
				end
				
				self.v:PlayerSteerVehicle(self, steer < 0 and -steer or 0, steer > 0 and steer or 0)
			elseif self.v.IsGlideVehicle then
				self.v:TriggerInput("Throttle", throttle)
				
				if forceStop then
					self.v:TriggerInput("Brake", 1)
					self.v:TriggerInput("Handbrake", 1)
				else
					self.v:TriggerInput("Brake", throttle * -1)
				end
				
				steer = steer * 2 
				self.v:TriggerInput("Steer", steer)
			elseif isfunction(self.v.SetThrottle) and not self.v.IsGlideVehicle then
				local lvsReverse = false
				if throttle < 0 and self.v.LVS then
					local velo = self.v:GetVelocity()
					local norm = velo:GetNormalized()
					local dot = forward:Dot(norm)

					lvsReverse = dot < 0 or selfvelocity < 10000
					throttle = math.abs(throttle)
				end

				if self.v.LVS then self.v:SetReverse( lvsReverse ) end
				self.v:SetThrottle(throttle)
				
				if forceStop then
					if isfunction(self.v.SetHandbrake) then
						self.v:SetHandbrake(true)
					end
				end
				
				if self.v.LVS then
					self.v:SetSteer(steer * self.v:GetMaxSteerAngle())
				else
					self.v:SetSteering(steer, 0)
				end
			end

			--Resetting
			if not (selfvelocity < 10000 and (throttle > 0 or throttle < 0)) then 
				self.moving = CurTime()
			end
			if self.stuck then 
				self.moving = CurTime()
				if selfvelocity > 100000 and vectdot > 0 and not UVEnemyEscaping then
					self.stuck = nil
				end
			end

			local timeout = 3
			if timeout and timeout > 0 then
				if CurTime() > self.moving + timeout and not UVTargeting then --If it has got stuck for enough time.
					self.invincible = true
					self.stuck = true
					self.moving = CurTime()
					timer.Simple(1, function() 
						if IsValid(self.v) then 
							self.stuck = nil 
						end 
					end)
					if not self.respondingtocall then
						self.returningtopatrol = true
					end
				end
			end
			
		else
			if self.patrolling then
				self.patrolling = nil
				self.Speeding = (SpeedLimit:GetFloat()*17.6)^2
			end
			self:Stop()
			self:FindPatrol()
		end
		
	end

	function ENT:UVHandbrakeOff()
		if self.v.IsScar then
			self.v:HandBrakeOff()
		elseif self.v.IsSimfphyscar then
			self.v:SetActive(true)
			self.v:StartEngine()
			self.v.PressedKeys = self.v.PressedKeys or {}
			self.v.PressedKeys["Space"] = false
		elseif isfunction(self.v.SetHandbrake) and not self.v.IsGlideVehicle then
			self.v:SetHandbrake(false)
		end
	end

	function ENT:UVHandbrakeOn()
		if self.v.IsScar then
			self.v:HandBrakeOn()
		elseif self.v.IsSimfphyscar then
			self.v.PressedKeys = self.v.PressedKeys or {}
			self.v.PressedKeys["Space"] = true
		elseif isfunction(self.v.SetHandbrake) and not self.v.IsGlideVehicle then
			self.v:SetHandbrake(true)
		elseif self.v.IsGlideVehicle then
			self.v:TriggerInput("Handbrake", 1)
		end
	end
	
	function ENT:Think()
		if not IsValid(self.v) then self:Remove() return end

		self:SetPos(self.v:GetPos() + (vector_up * 50))
		self:SetAngles(self.v:GetPhysicsObject():GetAngles()+Angle(0,180,0))

		--Flipping/crash
		if UVUnitIsWrecked(self.v) then
			UVPlayerWreck(self.v)
		end

		if TrafficStreaming:GetBool() then
			local suspects = UVPotentialSuspects
			if next(UVPotentialSuspects) ~= nil then
				local closestsuspect
				local closestdistancetosuspect
				local closestscope
				local r = math.huge
				local closestdistancetosuspect, closestsuspect = r^2
				local unitpos = self.v:WorldSpaceCenter()
				for i, w in pairs(suspects) do
					local distance = unitpos:DistToSqr(w:WorldSpaceCenter())
					if distance < closestdistancetosuspect then
						closestdistancetosuspect, closestsuspect = distance, w
						closestscope = scope
					end
				end
				if closestdistancetosuspect > 100000000 and self.uvmarkedfordeletion then
					SafeRemoveEntity(self)
				end
			end
		end
		
		if not GetConVar("ai_disabled"):GetBool() then
			self:Patrol()
		else
			self:Stop()
		end
	end
	
	function ENT:Initialize()
		if next(dvd.Waypoints) == nil then
			net.Start("UV_OpenDVWarning")
			net.Broadcast() 
			SafeRemoveEntity(self)
			return
		end

		self:SetNoDraw(true)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
		self:SetModel(self.Modelname)
		self:SetHealth(-1)
		self.spawned = true
		
		self.Speeding = (SpeedLimit:GetFloat()*17.6)^2 
		timer.Simple(1, function() 
			if IsValid(self.v) then 
				timer.Simple(2, function()
					if IsValid(self.v) then
						if vcmod_main and self.v:GetClass() == "prop_vehicle_jeep" and GetConVar("unitvehicle_enableheadlights"):GetInt() == 2 then 
							self.v:VC_setRunningLights(true)
						end
					end
				end)
				self.spawned = nil
			end 
		end)

		--Pick up a vehicle in the given sphere.
		if self.vehicle then
			local v = self.vehicle
			if v.TrafficVehicle and v.TrafficVehicle:IsNPC() then return end
			if v.IsScar then 
				if not v:HasDriver() then 
					self.v = v
					v.uvclasstospawnon = self:GetClass()
					v.TrafficVehicle = self
					v.HasDriver = function() return true end 
					v.SpecialThink = function() end 
					v:StartCar()
				end
			elseif v.IsSimfphyscar and v:IsInitialized() then 
				if not IsValid(v:GetDriver()) then 
					self.v = v
					v.uvclasstospawnon = self:GetClass()
					v.TrafficVehicle = self
					v:SetActive(true)
					v:StartEngine()
					if GetConVar("unitvehicle_enableheadlights"):GetInt() == 2 then
						v:SetLightsEnabled(true)
					end
				end
			elseif isfunction(v.EnableEngine) and isfunction(v.StartEngine) and not v.IsGlideVehicle then 
				if isfunction(v.GetWheelCount) and v:GetWheelCount() and not IsValid(v:GetDriver()) then
					self.v = v
					v.uvclasstospawnon = self:GetClass()
					v.TrafficVehicle = self
					v:EnableEngine(true)
					v:StartEngine(true)
					UVApplyVehiclePrerequisites(v)
				end
			elseif v.IsGlideVehicle and v.GetIsHonking then 
				if not IsValid(v:GetDriver()) then
					self.v = v
					v.uvclasstospawnon = self:GetClass()
					v.TrafficVehicle = self
					v:SetEngineState(2)
					v.inputThrottleModifierMode = 2
					v.AirControlForce = vector_origin
					if GetConVar("unitvehicle_enableheadlights"):GetInt() == 2 and v.CanSwitchHeadlights then
						v:SetHeadlightState(1)
					end

					v.UVConstrainedEntities = {}

					for _, entity in pairs(constraint.GetAllConstrainedEntities(v)) do
						table.insert(v.UVConstrainedEntities, entity)

						entity:CallOnRemove("UVConstrainedEntitiesRemoved", function()
							if v.UVConstrainedEntities and table.HasValue(v.UVConstrainedEntities, entity) then
								table.RemoveByValue(v.UVConstrainedEntities, entity)
							end
						end)
					end

					v.OnSocketDisconnect = function( car, socket )
						for _, entity in pairs(v.UVConstrainedEntities) do
							UVPlayerWreck(entity)
						end

						UVPlayerWreck(car)
					end
				end
			elseif v.LVS then
				if not v:IsInitialized() then return end
				if IsValid(v:GetDriver()) then return end
				self.v = v
				v.uvclasstospawnon = self:GetClass()
				v.TrafficVehicle = self
				v:DisableManualTransmission()
				v:StartEngine()
			end
		else
			local distance = DetectionRange:GetFloat()
			for k, v in pairs(ents.FindInSphere(self:GetPos(), distance)) do
				if v:GetClass() == 'prop_vehicle_prisoner_pod' then continue end
				if v.TrafficVehicle and v.TrafficVehicle:IsNPC() then continue end
				if v.LVS then
					if not v:IsInitialized() then continue end
					if IsValid(v:GetDriver()) then continue end
					self.v = v
					v.uvclasstospawnon = self:GetClass()
					v.TrafficVehicle = self
					v:DisableManualTransmission()
					v:StartEngine()
					break
				end
				if v:IsVehicle() then
					if v.IsScar then
						if not v:HasDriver() then
							self.v = v
							v.uvclasstospawnon = self:GetClass()
							v.TrafficVehicle = self
							v.HasDriver = function() return true end
							v.SpecialThink = function() end
							v:StartCar()
						end
					elseif v.IsSimfphyscar and v:IsInitialized() then 
						if not IsValid(v:GetDriver()) then 
							self.v = v
							v.uvclasstospawnon = self:GetClass()
							v.TrafficVehicle = self
							v:SetActive(true)
							v:StartEngine()
							if GetConVar("unitvehicle_enableheadlights"):GetInt() == 2 then
								v:SetLightsEnabled(true)
							end
						end
					elseif isfunction(v.EnableEngine) and isfunction(v.StartEngine) and not v.IsGlideVehicle then 
						if isfunction(v.GetWheelCount) and v:GetWheelCount() and not IsValid(v:GetDriver()) then
							self.v = v
							v.uvclasstospawnon = self:GetClass()
							v.TrafficVehicle = self
							v:EnableEngine(true)
							v:StartEngine(true)
							UVApplyVehiclePrerequisites(v)
						end
					elseif v.IsGlideVehicle then 
						if not IsValid(v:GetDriver()) then
							self.v = v
							v.uvclasstospawnon = self:GetClass()
							v.TrafficVehicle = self
							v:TurnOn()
							v.inputThrottleModifierMode = 2
							v.AirControlForce = vector_origin
							if GetConVar("unitvehicle_enableheadlights"):GetInt() == 2 and v.CanSwitchHeadlights then
								v:SetHeadlightState(1)
							end
							
							v.UVConstrainedEntities = {}

							for _, entity in pairs(constraint.GetAllConstrainedEntities(v)) do
								table.insert(v.UVConstrainedEntities, entity)
							
								entity:CallOnRemove("UVConstrainedEntitiesRemoved", function()
									if table.HasValue(v.UVConstrainedEntities, entity) then
										table.RemoveByValue(v.UVConstrainedEntities, entity)
									end
								end)
							end
						
							v.OnSocketDisconnect = function( car, socket )
								for _, entity in pairs(v.UVConstrainedEntities) do
									UVPlayerWreck(entity)
								end
							
								UVPlayerWreck(car)
							end
						end
					end
				end
			end
		end
	
		if not IsValid(self.v) or not IsValid(self.v:GetPhysicsObject()) then SafeRemoveEntity(self) return end 

		self.v.racer = "Traffic"

		if DriverModel:GetBool() then
			local selectedDriverModel = GetConVar("unitvehicle_traffic_drivermodel"):GetString()
			local splittedText = string.Explode( " ", selectedDriverModel )
			
			local ya = {}
			
			for k, v in pairs( splittedText ) do
				table.insert( ya, string.Trim( v ) )
			end
		
			self._cooldownString = "NavigateCooldown_Entity"..self:EntIndex()
			self.drivermodel = ya[math.random(1, #ya)]
		
			self:AttachDriverModel(self.drivermodel)
		else
			if isfunction(self.v.UVVehicleInitialize) then
				self.v:UVVehicleInitialize() 
			end
		end

		local deletiontime = 1

		if self.uvscripted then
			timer.Simple(deletiontime, function()
				if IsValid(self) then
					self.uvmarkedfordeletion = true
				end
			end)
		else
			local e = EffectData()
			e:SetEntity(self.v)
			util.Effect("propspawn", e) 
		end

		if not UVTargeting then self.v:EmitSound( "vo/npc/male01/hi02.wav" ) end
		self.mass = math.Round(self.v:GetPhysicsObject():GetMass())

		local collisionmin, collisionmax = self.v:GetCollisionBounds()
		if isvector(collisionmin) and isvector(collisionmax) then
			if self.v.IsSimfphyscar or self.v.IsGlideVehicle then
				self.v.width = ((collisionmax.y)-(collisionmin.y))
				self.v.length = ((collisionmax.x)-(collisionmin.x))
			else
				self.v.width = ((collisionmax.x)-(collisionmin.x))
				self.v.length = ((collisionmax.y)-(collisionmin.y))
			end
		end

		self.v.rideheight = collisionmin.z
		
		local min, max = self.v:GetHitBoxBounds(0, 0) 
		if not isvector(max) then min, max = self.v:GetModelBounds() end 
		if not isvector(max) then max = vector_up * math.random(80, 200) end 
		
		local tr = util.TraceHull({start = self.v:GetPos() + vector_up * max.z, 
			endpos = self.v:GetPos(), ignoreworld = true,
			mins = Vector(-16, -16, -1), maxs = Vector(16, 16, 1)})
		self.CollisionHeight = tr.HitPos.z - self.v:GetPos().z
		if self.CollisionHeight < 10 then self.CollisionHeight = max.z end
		self.v:DeleteOnRemove(self)
		
	end
else --if CLIENT
	function ENT:Initialize()
		self:SetNoDraw(true)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
		self:SetModel(self.Modelname)
	end
end 

function ENT:GetNoTarget()
	return false
end

function ENT:GetInfoNum(key, default)
	if key == "cl_simfphys_ctenable" then return 1 
	elseif key == "cl_simfphys_ctmul" then return 0.7 
	elseif key == "cl_simfphys_ctang" then return 15 
	elseif isnumber(default) then return default end
	return 0
end