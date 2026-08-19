list.Set("NPC", "npc_racervehicle", {
	Name = "#uv.npc.0racer",
	Class = "npc_racervehicle",
	Category = "#uv.unitvehicles"
})

AddCSLuaFile("npc_racervehicle.lua")

ENT.Base = "base_entity"
ENT.Type = "ai"

include("entities/uvapi.lua")

ENT.PrintName = "RacerVehicle"
ENT.Author = "Razor"
ENT.Contact = "Romeo"
ENT.Purpose = "It ain't over until I say it's over."
ENT.Instruction = "Spawn on/under the vehicle until it shows a spawn effect."
ENT.Spawnable = false
ENT.Modelname = "models/props_lab/huladoll.mdl"

local ENT = ENT

local dvd = DecentVehicleDestination

if SERVER then
	--Setting ConVars.
	local DetectionRange = GetConVar("unitvehicle_detectionrange")

	function ENT:FindBestStartNode()
		if not self.v or not UVRace_CompiledPaths then return nil end

		local pos = self.v:WorldSpaceCenter()
		local forward = self.v.IsSimfphyscar
			and self.v:LocalToWorldAngles(self.v.VehicleData.LocalAngForward):Forward()
			or self.v:GetForward()

		-- degrees → dot thresholds
		local cones = {
			math.cos(math.rad(10)),
			math.cos(math.rad(15)),
			math.cos(math.rad(20)),
			math.cos(math.rad(30)),
		}

		local bestNode, bestDist

		for _, dotThreshold in ipairs(cones) do
			bestNode, bestDist = nil, math.huge

			for _, node in ipairs(UVRace_CompiledPaths) do
				local p = node.Points and node.Points[1]
				if not isvector(p) then continue end

				local dir = p - pos
				local dist = dir:LengthSqr()
				local ndir = dir:GetNormalized()

				if ndir:Dot(forward) < dotThreshold then continue end

				-- LOS check (prevents wall issues)
				if util.TraceLine({
					start = pos,
					endpos = p,
					mask = MASK_NPCWORLDSTATIC,
					filter = { self, self.v }
				}).Fraction < 1 then
					continue
				end

				if dist < bestDist then
					bestDist = dist
					bestNode = node
				end
			end

			if bestNode then
				return bestNode
			end
		end

		return nil
	end

	local function GetNextNode(current, forward)
		local bestNode = nil
		local closestDot = -math.huge
		for _, node in ipairs(current.Paths) do
			local dir = (node.Points[1] - current.Points[#current.Points]):GetNormalized()
			local dot = dir:Dot(forward)
			if dot > closestDot then
				closestDot = dot
				bestNode = node
			end
		end
		return bestNode or current.Paths[1]
	end

	function ENT:BuildNodePath(start)
		local path = {}
		local visited = {}
		local current = start

		while current and not visited[current] do
			visited[current] = true
			table.insert(path, current)

			if not current.Out or #current.Out == 0 then
				break
			end

			-- simple heuristic: choose most forward
			local best, bestDot = nil, -1
			local curDir = (current.Points[#current.Points] - current.Points[1]):GetNormalized()

			for _, nextNode in ipairs(current.Out) do
				local dir = (nextNode.Points[#nextNode.Points] - nextNode.Points[1]):GetNormalized()
				local dot = curDir:Dot(dir)
				if dot > bestDot then
					bestDot = dot
					best = nextNode
				end
			end

			current = best
		end

		return path
	end

	function ENT:StartNodeRace()
		if not self.v then return end

		local startNode = self:FindBestStartNode()
		if startNode then
			self.NodePath = self:BuildNodePath(startNode)
			self.CurrentNodeIndex = 1
			self.CurrentNode = self.NodePath[self.CurrentNodeIndex]
			self.NextNode = self.NodePath[self.CurrentNodeIndex + 1]
		else
			self.NodePath = nil
			self.CurrentNodeIndex = nil
			self.CurrentNode = nil
			self.NextNode = nil
		end
	end

	function GetClosestPoint(ent, pos, margin, safeDistance)
		if not IsValid(ent) then return nil end
		
		margin = margin or 1
		safeDistance = safeDistance or 100
		
		local mins, maxs = ent:OBBMins(), ent:OBBMaxs()
		local localPos = ent:WorldToLocal(pos)
		
		local paddedMins = Vector(mins.x + margin, mins.y + margin, mins.z + margin)
		local paddedMaxs = Vector(maxs.x - margin, maxs.y - margin, maxs.z - margin)
		
		local clamped = Vector(
		math.Clamp(localPos.x, paddedMins.x, paddedMaxs.x),
		math.Clamp(localPos.y, paddedMins.y, paddedMaxs.y),
		math.Clamp(localPos.z, paddedMins.z, paddedMaxs.z))
		
		local worldPoint = ent:LocalToWorld(clamped)
		
		if pos:DistToSqr(worldPoint) < (safeDistance * safeDistance) then
			local forwardOffset = ent:GetForward() * 50
			return ent:GetPos() + forwardOffset
		end
		
		return worldPoint
	end
	
	local function ClosestPointOnLineSegment(p, a, b, padding)
		local ab = b - a
		local length = ab:Length()
		
		if length <= padding * 2 then
			return a + ab * 0.5
		end
		
		local dir = ab:GetNormalized()
		local a_padded = a + dir * padding
		local b_padded = b - dir * padding
		
		local ab_padded = b_padded - a_padded
		local t = (( p - a_padded ):Dot( ab_padded )) / ab_padded:LengthSqr()
		t = math.Clamp(t, 0, 1)
		
		return a_padded + ab_padded * t
	end

	local function ClosestPointOnPolyline(pos, points)
		if not points or #points == 0 then return nil, 1, 0, 0 end
		if #points == 1 then return points[1], 1, 0, 0 end

		local bestPoint = points[1]
		local bestSeg, bestT = 1, 0
		local bestDistSq = ( pos - bestPoint ):LengthSqr()
		local pathDist = 0
		local totalDistToBest = 0

		for i = 1, #points - 1 do
			local a, b = points[i], points[i + 1]
			local ab = b - a
			local len = ab:Length()
			local segLen = len

			if segLen <= 0 then
				pathDist = pathDist + 0
			else
				local t = math.Clamp( (( pos - a ):Dot( ab )) / (ab:LengthSqr()), 0, 1)
				local pt = a + ab * t
				local dSq = ( pos - pt ):LengthSqr()

				if dSq < bestDistSq then
					bestDistSq = dSq
					bestPoint = pt
					bestSeg = i
					bestT = t
					totalDistToBest = pathDist + t * segLen
				end

				pathDist = pathDist + segLen
			end
		end

		return bestPoint, bestSeg, bestT, totalDistToBest
	end

	local function PointAtPathDistance(points, pathDist)
		if not points or #points == 0 then return nil end
		if #points == 1 or pathDist <= 0 then return points[1] end

		local remaining = pathDist

		for i = 1, #points - 1 do
			local a, b = points[i], points[i + 1]
			local segLen = a:Distance(b)

			if segLen > 0 then
				if remaining <= segLen then
					local t = remaining / segLen
					return Lerp( t, a, b )
				end

				remaining = remaining - segLen
			end
		end

		return points[#points]
	end

	function ENT:RecalculateNodeFromPosition()
		if not self.v or not UVRace_CompiledPaths then return end

		local pos = self.v:WorldSpaceCenter()

		local bestNode = nil
		local bestDistSq = math.huge
		local bestPathDist = 0

		for _, seg in ipairs(UVRace_CompiledPaths) do
			if seg.Points and #seg.Points > 1 then
				local closestPoint, _, _, pathDist =
					ClosestPointOnPolyline(pos, seg.Points)

				local distSq = (pos - closestPoint):LengthSqr()

				if distSq < bestDistSq then
					bestDistSq = distSq
					bestNode = seg
					bestPathDist = pathDist
				end
			end
		end

		if not bestNode then return end

		local totalLen = 0
		local pts = bestNode.Points

		for i = 1, #pts - 1 do
			totalLen = totalLen + pts[i]:Distance(pts[i + 1])
		end

		local endThreshold = 1000 -- tweak if needed

		if (totalLen - bestPathDist) < endThreshold then
			if bestNode.To then
				for _, seg in ipairs(UVRace_CompiledPaths) do
					if seg.From == bestNode.To and seg.Points and #seg.Points > 1 then
						bestNode = seg
						bestPathDist = 0
						break
					end
				end
			end
		end

		self.NodePath = true
		self.CurrentNode = bestNode
		self.NodeReentryOffset = bestPathDist
		self.NextNode = nil

		if bestNode.To then
			for _, seg in ipairs(UVRace_CompiledPaths) do
				if seg.From == bestNode.To then
					self.NextNode = seg
					break
				end
			end
		end
	end
	
	function ENT:OnRemove()
		--By undoing, driving, diving in water, or getting stuck, and the vehicle is remaining.
		if IsValid(self.v) then
			self.v.RacerVehicle = nil
			if not self.temporary then
				UVSetVehiclePerformanceMultiplier(self.v, 1, false)
			end
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
				self.v.PressedKeys = self.v.PressedKeys or {} --Reset key states.
				self.v.PressedKeys["Shift"] = false
				self.v.PressedKeys["joystick_throttle"] = 0
				self.v.PressedKeys["joystick_brake"] = 0
				if not self.temporary then
					self.v:StopEngine()
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
				end
			elseif not IsValid(self.v:GetDriver()) and --The vehicle is normal vehicle.
			(isfunction(self.v.StartEngine) and isfunction(self.v.SetHandbrake) and 
			isfunction(self.v.SetThrottle) and isfunction(self.v.SetSteering) and not self.v.IsGlideVehicle) or self.v.LVS then
				self.v.GetDriver = self.v.OldGetDriver or self.v.GetDriver
				--self.v:StartEngine(false) --Reset states.
				--self:UVHandbrakeOn()
				self.v:SetThrottle(0)
				if self.v.wrecked then
					if self.v.LVS then
						self.v:SetSteer(steerinput * self.v:GetMaxSteerAngle())
					else
						self.v:SetSteering(steerinput, 0)
					end
				end
			elseif self.v.IsGlideVehicle then
				self.v:ResetInputs(1)
				if not self.temporary then
					self.v:TurnOff()
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
					end
				end
			end

			self:SetHorn(false)
			
			if not self.temporary then
				local e = EffectData()
				e:SetEntity(self.v)
				util.Effect("entity_remove", e) --Perform an effect.4
			end

			if not self.wrecked and self.v.DriverModel and IsValid(self.v.DriverModel) then 
				self.v.DriverModel:Remove() 
			end
			
		end
		
	end
	
	function ENT:StraightToRace(point)
		if not self.v or not self.e then
			return
		end
		local tr = util.TraceLine({start = self.v:WorldSpaceCenter(), endpos = point, mask = MASK_NPCWORLDSTATIC, filter = {self, self.v, self.e}}).Fraction==1
		return tobool(tr)
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
		if self.v.IsScar then
			self.v:GoNeutral()
			self.v:NotTurning()
			self.v:HandBrakeOn()
		elseif self.v.IsSimfphyscar then
			self.v.PressedKeys = self.v.PressedKeys or {}
			self.v.PressedKeys["W"] = false
			self.v.PressedKeys["A"] = false
			self.v.PressedKeys["S"] = false
			self.v.PressedKeys["D"] = false
			self.v.PressedKeys["Shift"] = false
			self.v.PressedKeys["Space"] = true
		elseif isfunction(self.v.SetThrottle) and not self.v.IsGlideVehicle then
			self.v:SetThrottle(0)
			if self.v.LVS then
				self.v:SetReverse(false)
				self.v:SetSteer(0, self.v:GetMaxSteerAngle())
			else
				self.v:SetSteering(0, 0)
			end
			if self.v:GetVelocity():LengthSqr() < 10000 then 
				self.v:SetHandbrake(true)
			else 
				self.v:SetHandbrake(false)
			end
		elseif self.v.IsGlideVehicle then
			self.v:TriggerInput("Handbrake", 1)
			self.v:TriggerInput("Throttle", 0)
			self.v:TriggerInput("Brake", 0)
			self.v:TriggerInput("Steer", 0)
		end
		self.moving = CurTime()
	end
	
	function ENT:CanSeeGoal(target)
		if not self.v or not target then
			return
		end
		local tr = util.TraceLine({start = self.v:WorldSpaceCenter(), endpos = target, mask = MASK_NPCWORLDSTATIC, filter = {self, self.v}}).Fraction==1
		return tobool(tr)
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
		
		local trleft = util.TraceLine({start = self.v:LocalToWorld(leftstart), endpos = (self.v:LocalToWorld(left)+(vector_up * 50)), filter = {self.v, 'glide_wheel'},  mask = MASK_SOLID}).Fraction
		local trright = util.TraceLine({start = self.v:LocalToWorld(rightstart), endpos = (self.v:LocalToWorld(right)+(vector_up * 50)), filter = {self.v, 'glide_wheel'}, mask = MASK_SOLID}).Fraction
		
		if trleft > trright then
			return turnleft
		end
		if trleft < trright then
			return turnright
		end
		
		return false
		
	end
	
	function ENT:ObstaclesNearby()
		if not self.v then
			return
		end
		local tr = util.TraceLine({start = self.v:WorldSpaceCenter(), endpos = (self.v:WorldSpaceCenter()+(self.v:GetVelocity()*2)), filter = {self.v, 'glide_wheel'},  mask = MASK_SOLID}).Fraction ~= 1
		return tobool(tr)
	end

	function ENT:GetNearbyRacers()
		if not IsValid(self.v) then return {} end
		
		local pos = self.v:WorldSpaceCenter()
		local velocity = self.v:GetVelocity()
		local speed = velocity:Length()
		local forward = self.v.IsSimfphyscar 
			and self.v:LocalToWorldAngles(self.v.VehicleData.LocalAngForward):Forward() 
			or self.v:GetForward()

		local right = forward:Cross(Vector(0,0,1))

		-- Dynamic detection size
		local forwardDist = math.Clamp(speed * 1.2, 500, 2500)
		local sideDist = math.Clamp(self.v.width or 100, 100, 300)

		local nearby = {}

		for _, ent in ipairs(ents.FindInSphere(pos, forwardDist)) do
			if ent == self.v then continue end
			if not ent:IsVehicle() then continue end
			if not ent.RacerVehicle and not ent.uvraceparticipant then continue end
			
			local otherPos = ent:WorldSpaceCenter()
			local offset = otherPos - pos

			local forwardDot = offset:GetNormalized():Dot(forward)
			local sideDot = offset:GetNormalized():Dot(right)

			table.insert(nearby, {
				ent = ent,
				dist = offset:Length(),
				forwardDot = forwardDot,
				sideDot = sideDot,
				offset = offset
			})
		end

		return nearby
	end

	local DEBUG_AVOIDANCE = false
	
	function ENT:ComputeAvoidance()
		if not UVRaceCautious:GetBool() then return 0, nil end
		if UVRaceCautiousRandom:GetBool() then
			if self.__cautiousOverride == nil then self.__cautiousOverride = math.random( 0, 1 ) == 1 end
			if not self.__cautiousOverride then return 0, nil end
		end

		local nearby = self:GetNearbyRacers()
		if not nearby or #nearby == 0 then return 0, nil end

		local steerOffset = 0
		local targetSpeed = nil

		local myVel = self.v:GetVelocity()
		local mySpeed = myVel:Length()

		-- === SPEED FACTOR ===
		local speedFactor = math.Clamp(mySpeed / 2000, 0, 1)

		-- === DYNAMIC DISTANCES ===
		local forwardDist = Lerp(speedFactor, 300, 2000)
		local brakeDist = Lerp(speedFactor, 150, 800)
		local sideDist = Lerp(speedFactor, 100, 300)

		-- === DYNAMIC FORWARD CONE ===
		local forwardDotThreshold = Lerp(speedFactor, 0.98, 0.85)

		if DEBUG_AVOIDANCE then
			local pos = self.v:WorldSpaceCenter()

			local forward = self.v.IsSimfphyscar 
				and self.v:LocalToWorldAngles(self.v.VehicleData.LocalAngForward):Forward() 
				or self.v:GetForward()

			local right = forward:Cross(Vector(0,0,1))

			-- Forward detection box (GREEN)
			debugoverlay.BoxAngles(
				pos + forward * (forwardDist * 0.5),
				Vector(-sideDist, -sideDist, -50),
				Vector(sideDist, sideDist, 50),
				Angle(0, forward:Angle().y, 0),
				0.1,
				Color(0,255,0,20)
			)

			-- Brake zone (RED)
			debugoverlay.BoxAngles(
				pos + forward * (brakeDist * 0.5),
				Vector(-sideDist * 0.5, -sideDist * 0.5, -50),
				Vector(sideDist * 0.5, sideDist * 0.5, 50),
				Angle(0, forward:Angle().y, 0),
				0.1,
				Color(255,0,0,20)
			)

			-- Side zone (BLUE)
			debugoverlay.Box(
				pos,
				Vector(-sideDist, -sideDist, -50),
				Vector(sideDist, sideDist, 50),
				0.1,
				Color(0,100,255,20)
			)

			-- Forward direction line (YELLOW)
			debugoverlay.Line(
				pos,
				pos + forward * forwardDist,
				0.1,
				Color(255,255,0),
				true
			)
		end

		-- === START GRACE (fix gridlock) ===
		self.StartTime = self.StartTime or CurTime()
		local inStartPhase = (CurTime() - self.StartTime) < 2.5

		for _, data in ipairs(nearby) do
			local ent = data.ent
			local dist = data.dist

			if DEBUG_AVOIDANCE then
				local pos = self.v:WorldSpaceCenter()
				local otherPos = data.ent:WorldSpaceCenter()

				local isAhead = data.forwardDot > forwardDotThreshold

				debugoverlay.Line(
					pos,
					otherPos,
					0.05,
					isAhead and Color(0,255,0) or Color(255,0,0),
					true
				)

				debugoverlay.Sphere(
					otherPos,
					10,
					0.05,
					isAhead and Color(0,255,0) or Color(255,0,0),
					true
				)
			end

			if data.forwardDot > forwardDotThreshold and dist < forwardDist then
				local otherVel = ent:GetVelocity()
				local otherSpeed = otherVel:Length()

				-- === RELATIVE SPEED (CRITICAL FIX) ===
				local closingSpeed = (myVel - otherVel):Length()

				-- === IGNORE SAME-SPEED TRAFFIC ===
				if closingSpeed < 150 then continue end

				-- === SPEED MATCHING (SOFT) ===
				targetSpeed = math.min(targetSpeed or math.huge, otherSpeed)

				-- === SMART BRAKING ===
				local brakeStrength = math.Clamp(closingSpeed / 1000, 0, 1)

				if dist < brakeDist then
					targetSpeed = otherSpeed * (1 - brakeStrength)
				end

				-- === OVERTAKE LOGIC ===
				if otherSpeed < mySpeed * 0.7 and dist < forwardDist * 0.8 then
					local overtakeDir = data.sideDot >= 0 and 1 or -1
					steerOffset = steerOffset + overtakeDir * (1 - dist / forwardDist)
				end
			end

			-- === SIDE AVOIDANCE ===
			if math.abs(data.sideDot) > 0.3 and dist < sideDist then
				local dir = data.sideDot > 0 and -1 or 1
				local strength = 1 - (dist / sideDist)

				steerOffset = steerOffset + dir * strength
			end
		end

		-- === DISABLE AVOIDANCE DURING RACE START ===
		if inStartPhase then
			return 0, nil
		end

		return steerOffset, targetSpeed
	end

	function ENT:AddEnemy(car)
		if self.enemies and IsValid(car) then
			if not self.enemies[car:EntIndex()] then
				self.enemies[car:EntIndex()] = car

				local selfname = self.v.racer or tostring(self)
				local carname = car.racer or (car.UnitVehicle and car.UnitVehicle:GetClass()) or (UVGetDriver(car) and UVGetDriver(car):IsPlayer() and UVGetDriver(car):Nick()) or tostring(car)
				print(selfname .. " hates " .. carname )
			end
		end
	end

	function ENT:RemoveEnemy(index)
		if self.enemies then
			self.enemies[index] = nil
		end
	end

	function ENT:DeployWeapon(car, slot)
		if not IsValid(car) or self.deploying then return end
		self.deploying = true

		local reactionTime = math.Rand( 0, 1 )

		timer.Simple(reactionTime, function()
			if IsValid(self) and IsValid(car) then
				UVDeployWeapon(car, slot)
				self.deploying = nil
			end
		end)
	end

	function ENT:FindRace()
		if (self.v.uvraceparticipant and UVRaceInEffect) and (UVRaceTable['Participants'] and UVRaceTable['Participants'][self.v]) then
			if not UVRaceInProgress then self.PatrolWaypoint = nil; return end
			
			local array = UVRaceTable['Participants'][self.v]
			
			local current_checkp = #array.Checkpoints + 1
			local next_checkp = #array.Checkpoints + 2
			local selected_point = nil
			local next_points

			if next_checkp >= GetGlobalInt("uvrace_checkpoints") then --Finish line
				next_checkp = 1
			end

			if UVRaceCatchup:GetBool() then
				local sorted_table, string_array = UVFormLeaderboard(UVRaceTable['Participants'], self.v)

				local targetEntry = nil

				for i = 1, #string_array do -- Find closest player
					local entry = string_array[i]
					local racerName = entry[1]
					local isLocalPlayer = entry[2]

					for veh, data in pairs(UVRaceTable['Participants']) do
						if data.Name == racerName and not data.IsAI then -- If the target is a player, then ignore the rest
							targetEntry = entry
							break
						end
					end

					if targetEntry then break end
				end

				if targetEntry then
					local diff_mode = targetEntry[3]
					local diff = targetEntry[4]

					local comparison_value = (diff_mode == "Time") and (UVRaceCatchupGap:GetInt() or 2) or 0

					if diff and diff > comparison_value then
						self.__catchup_active = true
					else
						self.__catchup_active = false
					end
				else
					self.__catchup_active = false
				end
			end
			
			-- Reverse catchup (slow down if too far ahead of players)
			self.__reverse_catchup_mult = 1

			if UVRaceReverseCatchup:GetBool() and not self.__catchup_active then
				local sorted_table, string_array = UVFormLeaderboard(UVRaceTable['Participants'], self.v)

				local targetEntry = nil

				-- Find closest PLAYER (same logic as before)
				for i = 1, #string_array do
					local entry = string_array[i]
					local racerName = entry[1]

					for veh, data in pairs(UVRaceTable['Participants']) do
						if data.Name == racerName and not data.IsAI then
							targetEntry = entry
							break
						end
					end

					if targetEntry then break end
				end

				if targetEntry then
					local diff_mode = targetEntry[3]
					local diff = targetEntry[4]
					
					local diffval = (UVRaceReverseCatchupGap:GetInt() or 2)

					-- Only apply for time gaps (ignore lap/finished/etc)
					if diff_mode == "Time" and diff and diff < -diffval then
						local gap = math.abs(diff)

						local t = math.Clamp((gap - diffval) / 5, 0, 1)
						self.__reverse_catchup_mult = Lerp(t, 0.99, 0.25)
					end
				end
			end

			-- print(self.v.racer,
			-- (self.__reverse_catchup_mult and "Speed Limit Mult: " .. self.__reverse_catchup_mult or ""),
			-- (self.__catchup_active and "Catch-up" or ""))

			for _, v in ipairs(ents.FindByClass('uvrace_brush*')) do
				if v:GetID() == current_checkp then
					selected_point = v
				end
				if v:GetID() == next_checkp then
					next_point = v
				end
			end
			
			if selected_point then
				local target = selected_point
				local pos1, pos2 = nil, nil

				pos1 = (InfMap and InfMap.unlocalize_vector( target:GetPos1(), target:GetChunk() )) or target:GetPos1()
				pos2 = (InfMap and InfMap.unlocalize_vector( target:GetPos2(), target:GetChunkMax() )) or target:GetPos2()

				local target_pos = ClosestPointOnLineSegment(
					self.v:WorldSpaceCenter(), 
					pos1, 
					pos2, 
					200
				)
				
				local velocity = self.v:GetVelocity()
				local normalized_velocity = velocity:GetNormalized()
				
				local tolerance = 750
				
				if next_point then
					local toCheckpoint = (target_pos - self.v:WorldSpaceCenter()):GetNormalized()
					local forward = self.v.IsSimfphyscar and self.v:LocalToWorldAngles(self.v.VehicleData.LocalAngForward):Forward() or self.v:GetForward()
					
					local dot = forward:Dot(toCheckpoint)
					local dist = self.v:WorldSpaceCenter():Distance(target_pos)
					
					if dist < tolerance and velocity:LengthSqr() > 100000 then
						target = next_point

						pos1 = (InfMap and InfMap.unlocalize_vector( target:GetPos1(), target:GetChunk() )) or target:GetPos1()
						pos2 = (InfMap and InfMap.unlocalize_vector( target:GetPos2(), target:GetChunkMax() )) or target:GetPos2()

						target_pos = ClosestPointOnLineSegment(
							self.v:WorldSpaceCenter(), 
							pos1, 
							pos2, 
							200
						)
						--end
					end
				end

				pos1 = (InfMap and InfMap.unlocalize_vector( target:GetPos1(), target:GetChunk() )) or target:GetPos1()
				pos2 = (InfMap and InfMap.unlocalize_vector( target:GetPos2(), target:GetChunkMax() )) or target:GetPos2()
				
				local size = (pos2 - pos1):LengthSqr()
				
				--print('Vehicle velocity', velocity:LengthSqr())
				
				if velocity:LengthSqr() < 150000 then
					target_pos = target.target_point
				end
				
				if size < 200000 then
					target_pos = target.target_point
				end

				self.PatrolWaypoint = {
					['Target'] = target_pos,
					['SpeedLimit'] = ((target:GetSpeedLimit() == 0 and math.huge) or target:GetSpeedLimit())
				}
			end
			
			
		else
			self.__catchup_active = false

			if next(dvd.Waypoints) == nil then
				self.PatrolWaypoint = nil
				return
			end
			
			-- Only pick a starting waypoint if we don't already have one
			if not self.DVCurrentWaypoint then
				self.DVCurrentWaypoint = UVGetNearestVisibleWaypoint(self.v:WorldSpaceCenter())
			end

			if self.DVCurrentWaypoint then
				self.PatrolWaypoint = {
					Target = self.DVCurrentWaypoint.Target,
					SpeedLimit = self.DVCurrentWaypoint.SpeedLimit or math.huge
				}
			end
		end
	end

	function ENT:ApplyRaceDifficulty(multiplier, catchup)
		if not IsValid(self.v) then return end

		local mult = multiplier or 1 + (GetConVar("unitvehicle_racedifficulty"):GetFloat() or 0)

		mult = math.Clamp(mult, 1, 2)

		if catchup and not UVTargeting then
			-- mult = mult * 1.5
		else catchup = false end
		
		if not self.temporary then
			UVSetVehiclePerformanceMultiplier(self.v, mult, catchup)
		end
		self.DifficultyMult = mult
	end

	function ENT:Race()
		self:FindRace()
		
		local selfvelocity = self.v:GetVelocity():LengthSqr()
		
		-- Node-based navigation override
		if (self.v.uvraceparticipant and UVRaceInEffect) and not self.NodePath then
			self:StartNodeRace()
		end
		
		if self.PatrolWaypoint and self.NodePath and self.CurrentNode then
			if not self.racing or UVRaceCatchup:GetBool() and (self.v.uvraceparticipant and UVRaceInEffect) then
				self.racing = true
				self:ApplyRaceDifficulty( nil, ( self.v.uvraceparticipant and UVRaceInEffect ) and self.__catchup_active ) -- Apply Racing difficulty
			end

			-- Reset AI if they've missed a checkpoint
			if self.v.uvraceparticipant and self.PatrolWaypoint then
				local waypointPos = self.PatrolWaypoint["Target"]
				local vehicleCenter = self.v:WorldSpaceCenter()
				local velocity = self.v:GetVelocity()

				local speed = velocity:Length()
				local minSpeed = 200

				if speed > minSpeed then
					local toCheckpoint = (waypointPos - vehicleCenter):GetNormalized()
					local velNorm = velocity:GetNormalized()
					local dot = velNorm:Dot(toCheckpoint)

					if dot < -0.2 then
						self.AIWrongWayStart = self.AIWrongWayStart or CurTime()

						if CurTime() - self.AIWrongWayStart > 4 then
							UVResetPosition(self.v)
							self:RecalculateNodeFromPosition()
							self.AIWrongWayStart = nil
							return
						end
					else
						self.AIWrongWayStart = nil
					end
				else
					self.AIWrongWayStart = nil
				end
			end

			if self.NodePath and (not self.CurrentNode or not self.CurrentNode.Points) then
				self.NodePath = nil
				self.CurrentNode = nil
				self.CurrentPointIndex = nil
				self.NodeDebugTarget = nil
				self:RecalculateNodeFromPosition()
				return
			end

			--Set handbrake
			if self.v.IsScar then
				self.v:HandBrakeOff()
			elseif self.v.IsSimfphyscar then
				self.v.PressedKeys = self.v.PressedKeys or {}
				self.v.PressedKeys["Space"] = false
			elseif isfunction(self.v.SetHandbrake) and not self.v.IsGlideVehicle then
				self.v:SetHandbrake(false)
			end
			
			local points = self.CurrentNode.Points or {}
			if #points == 0 then return end

			local pos = self.v:WorldSpaceCenter()

			local closestPoint, bestSeg, _, pathDistFromStart = ClosestPointOnPolyline(pos, points)

			if self.NodeReentryOffset then
				pathDistFromStart = self.NodeReentryOffset
				self.NodeReentryOffset = nil
			end
			
			local totalPathLen = 0

			for i = 1, #points - 1 do totalPathLen = totalPathLen + points[i]:Distance( points[i + 1] ) end


			local velocity = self.v:GetVelocity():Length()
			local speedFactor = math.Clamp(velocity / 2500, 0, 1)
			local lookAheadDist = Lerp(speedFactor, 150, 1200)
			
			-- local lookAheadDist = 1000
			local targetPathDist = pathDistFromStart + lookAheadDist
			local targetPos

			if targetPathDist <= totalPathLen then targetPos = PointAtPathDistance( points, targetPathDist )
			else
				local overflow = targetPathDist - totalPathLen
				local nextNodes = {}

				if UVRace_CompiledPaths and self.CurrentNode.To then
					for _, seg in ipairs( UVRace_CompiledPaths ) do
						if seg.From == self.CurrentNode.To and seg.Points and #seg.Points > 0 then
							table.insert( nextNodes, seg )
						end
					end
				end

				if #nextNodes > 0 then
					local forward = self.v.IsSimfphyscar and self.v:LocalToWorldAngles(self.v.VehicleData.LocalAngForward):Forward() or self.v:GetForward()
					local forwardFlat = Vector( forward.x, forward.y, 0 )

					local endPt = points[#points]
					local bestDot, bestSeg = -math.huge, nextNodes[1]

					for _, seg in ipairs( nextNodes ) do
						local segStart = seg.Points[1]

						local toSeg = segStart - endPt
						local len = toSeg:Length()

						if len < 1 then continue end

						local dir = toSeg / len
						local flatLen = forwardFlat:Length()

						local dot = flatLen > 0.01 and ( dir:Dot( forwardFlat / flatLen ) ) or 0
						if dot > bestDot then
							bestDot = dot
							bestSeg = seg
						end
					end

					targetPos = PointAtPathDistance( bestSeg.Points, overflow )
				end

				if not targetPos then targetPos = PointAtPathDistance( points, totalPathLen ) end
			end

			if not targetPos and points[#points] then targetPos = points[#points]
			elseif not targetPos then
				self.NodePath = nil	
				self.CurrentNode = nil
				self.CurrentPointIndex = nil
				self.NodeDebugTarget = nil
				self:RecalculateNodeFromPosition()
				return
			end

			local dist = ( targetPos - pos ):Length()
			self.NodeDebugTarget = targetPos

			local forward = self.v.IsSimfphyscar and self.v:LocalToWorldAngles( self.v.VehicleData.LocalAngForward ):Forward() or self.v:GetForward()
			local toTarget = targetPos - pos
			local forwardFlat = Vector(	forward.x, forward.y, 0	)
			local toTargetFlat = Vector( toTarget.x, toTarget.y, 0	)
			local lenFlat = toTargetFlat:Length()

			if lenFlat < 1 then
				toTargetFlat = forwardFlat
				lenFlat = toTargetFlat:Length()
			end

			if lenFlat > 0 then toTargetFlat = toTargetFlat / lenFlat end

			local forwardLen = forwardFlat:Length()
			if forwardLen > 0 then forwardFlat = forwardFlat / forwardLen end

			local right = toTargetFlat:Cross(forwardFlat)
			local steer_amount = math.abs(right.z)
			local steer = right.z > 0 and steer_amount or -steer_amount
			local speed = self.v:GetVelocity():LengthSqr()
			
			-- speed blending
			local currentSpeedLimit = self.CurrentNode.StartSpeed or math.huge
			local nextSpeedLimit = currentSpeedLimit

			if self.NextNode and self.NextNode.StartSpeed then
				nextSpeedLimit = self.NextNode.StartSpeed
			end

			-- distance remaining in node
			local finalPoint = points[#points]
			local distToEnd = pos:Distance(finalPoint)
			local nodeLength = points[1]:Distance(finalPoint)

			local blendFactor = math.Clamp(1 - (distToEnd / nodeLength), 0, 1)

			-- Smoothly interpolate speed
			local blendedSpeedLimit = Lerp(blendFactor, currentSpeedLimit, nextSpeedLimit)

			local speedLimit = blendedSpeedLimit ^ 2
			
			-- Apply adjusted speed limit depending on difficulty and catchup status
			local difficultyScale = math.Clamp(self.DifficultyMult, 1, self.__catchup_active and 2 or 1.5)

			speedLimit = speedLimit * difficultyScale

			local throttle = 1
			local cornerDist = 400

			if dist < cornerDist then
				throttle = math.Clamp(dist / cornerDist, -1, 1) 
			end

			if speed > speedLimit * 350 then
				throttle = -1
			elseif speed > speedLimit * 300 then
				throttle = math.min(throttle, 0.5)
			end

			local avoidSteer, targetSpeed = self:ComputeAvoidance()

			local mySpeed = self.v:GetVelocity():Length()

			local MIN_SPEED = 300
			local START_DISABLE_SPEED = 400
			local OVERTAKE_BOOST = 1.15

			local speedFactor = math.Clamp(mySpeed / 2000, 0, 1)
			local allowAvoidance = mySpeed > START_DISABLE_SPEED

			if allowAvoidance and avoidSteer ~= 0 then
				local avoidStrength = Lerp(speedFactor, 0.6, 0.2) -- Stronger at low speed, weaker at high speed
				steer = steer + avoidSteer * avoidStrength
			end

			if targetSpeed and allowAvoidance then
				local desiredSpeed = math.max(targetSpeed * OVERTAKE_BOOST, MIN_SPEED)

				if mySpeed > desiredSpeed then -- If we're too fast, slow down
					throttle = math.min(throttle, 0.1)

					if mySpeed > desiredSpeed * 1.25 then
						throttle = -0.6
					end
				else -- If target is VERY slow, try overtaking instead of matching forever
					if targetSpeed < MIN_SPEED * 0.75 then
						throttle = math.max(throttle, 0.1)
					end
				end
			end

			if mySpeed < MIN_SPEED and throttle >= 0 then -- Minimum throttle
				throttle = math.max(throttle, 0.6)
			end

			-- Apply reverse catchup penalty
			if self.__reverse_catchup_mult and self.__reverse_catchup_mult < 0.9 then
				throttle = throttle * self.__reverse_catchup_mult
			end

			-- Traction control
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
					local maxSlip = 0
					for _, wheel in ipairs(self.v.wheels) do
						maxSlip = math.max(maxSlip, math.abs(wheel:GetForwardSlip() or 0))
					end
					local minThrottle = 0.5
					local recoverRate = FrameTime()
					self.AI_ThrottleMul = self.AI_ThrottleMul or 1
					if maxSlip > 8 then
						self.AI_ThrottleMul = math.max(self.AI_ThrottleMul - FrameTime()*2, minThrottle)
					else
						self.AI_ThrottleMul = math.min(self.AI_ThrottleMul + recoverRate, 1)
					end
					throttle = throttle * self.AI_ThrottleMul --Glide traction control
					throttleInput = throttleInput and (throttleInput * self.AI_ThrottleMul) --Glide traction control
				end
			end

			if self.stuck then
				-- steer = 0
				throttle = throttle * -1
			end --Getting unstuck

			-- Speed-based steering multiplier
			local velocity = self.v:GetVelocity():Length() -- real speed (not squared)
			local maxSpeedForScaling = 2400  -- speed where steering becomes fully relaxed
			local speedFactor = math.Clamp(velocity / maxSpeedForScaling, 0, 1)
			local steerMultiplier = Lerp(speedFactor, 5, 3)
			steer = steer * (steerMultiplier / self.DifficultyMult)

			-- Apply throttle/steer (same as your existing code block)
			if self.v.IsScar then
				if throttle > 0 then self.v:GoForward(throttle) else self.v:GoBack(-throttle) end
				if steer > 0 then self.v:TurnRight(steer) elseif steer < 0 then self.v:TurnLeft(-steer) else self.v:NotTurning() end
			elseif self.v.IsSimfphyscar then
				self.v.PressedKeys = self.v.PressedKeys or {}
				self.v.PressedKeys["joystick_throttle"] = throttle
				self.v.PressedKeys["joystick_brake"] = throttle * -1
				self.v:PlayerSteerVehicle(self, steer < 0 and -steer or 0, steer > 0 and steer or 0)
			elseif self.v.IsGlideVehicle then
				self.v:TriggerInput("Handbrake", 0)
				self.v:TriggerInput("Throttle", throttleInput or throttle)
				self.v:TriggerInput("Brake", throttle * -1)
				self.v:TriggerInput("Steer", steer * 1)
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
				if self.v.LVS then
					self.v:SetSteer(steer * self.v:GetMaxSteerAngle())
				else
					self.v:SetSteering(steer, 0)
				end
			end

			if totalPathLen > 0 and pathDistFromStart >= totalPathLen - 80 then
				local nextNodes = {}
				local currentPosNode = self.CurrentNode.To
				if UVRace_CompiledPaths and currentPosNode then
					for _, seg in ipairs( UVRace_CompiledPaths ) do if seg.From == currentPosNode then table.insert( nextNodes, seg ) end end
				end
				-- print('BRANCH COUNT: ', #nextNodes)
				if #nextNodes > 0 then
					local chosen = nextNodes[math.random(#nextNodes)]
					-- PrintTable(chosen)
					self.CurrentNode = chosen
					self.NextNode = nil
					self.CurrentPointIndex = 1
				else
					self.NodePath = nil
					self.CurrentNode = nil
					self.NextNode = nil
					self.NodeDebugTarget = nil
				end
			end

			--Resetting
			if not (selfvelocity < 10000 and (throttle > 0 or throttle < 0)) then 
				self.moving = CurTime()
			end
			if self.stuck then 
				self.moving = CurTime()
			end
			
			local timeout = 1
			if timeout and timeout > 0 then
				if CurTime() > self.moving + timeout then --If it has got stuck for enough time.
					self.stuck = true
					self.moving = CurTime()
					timer.Simple(2, function() 
						if IsValid(self.v) then 
							self.stuck = nil 
							self.PatrolWaypoint = nil
							self.DVCurrentWaypoint = nil
							
							if self.v.uvraceparticipant and ((not self.v.UVBustingProgress) or self.v.UVBustingProgress <= 0) then
								UVResetPosition( self.v )
								self:RecalculateNodeFromPosition()
							end
						end 
					end)
				end
			end

			-- Skip old PatrolWaypoint code
			return
		elseif self.PatrolWaypoint then
			if not self.racing or UVRaceCatchup:GetBool() and (self.v.uvraceparticipant and UVRaceInEffect) then
				self.racing = true
				self:ApplyRaceDifficulty( nil, ( self.v.uvraceparticipant and UVRaceInEffect ) and self.__catchup_active ) -- Apply Racing difficulty
			end

			--Set handbrake
			if self.v.IsScar then
				self.v:HandBrakeOff()
			elseif self.v.IsSimfphyscar then
				--self.v:SetActive(true)
				--self.v:StartEngine()
				self.v.PressedKeys = self.v.PressedKeys or {}
				self.v.PressedKeys["Space"] = false
			elseif isfunction(self.v.SetHandbrake) and not self.v.IsGlideVehicle then
				self.v:SetHandbrake(false)
			end
			
			--Racing techniques
			local WaypointPos = self.PatrolWaypoint["Target"]
			local forward = self.v.IsSimfphyscar and self.v:LocalToWorldAngles(self.v.VehicleData.LocalAngForward):Forward() or self.v:GetForward()
			local dist = WaypointPos - self.v:WorldSpaceCenter()
			local vect = dist:GetNormalized()
			local vectdot = vect:Dot(self.v:GetVelocity())
			local throttle = dist:Dot(forward) > 0 and 1 or -1
			local right = vect:Cross(forward)
			local steer_amount = right:Length()
			local steer = right.z > 0 and steer_amount or -steer_amount
			local speedlimitmph = self.PatrolWaypoint["SpeedLimit"]
			self.Speeding = speedlimitmph^2

			-- Apply adjusted speed limit depending on difficulty and catchup status
			local difficultyScale = math.Clamp(self.DifficultyMult, 1, self.__catchup_active and 2 or 1.5)

			self.Speeding = self.Speeding * difficultyScale

			local throttleInput = nil
			local brakeInput = nil
			self.maxTurn = 0

			if selfvelocity > self.Speeding*350 then -- Above it - slam on brakes!
				throttle = -1
			elseif selfvelocity > self.Speeding*300 then -- Near or on the speed limit - half throttle
				throttle = 0.5
			end

			if self.stuck then
				steer = 0
				throttle = throttle * -1
				throttleInput = nil
			end --Getting unstuck

			local avoidSteer, targetSpeed = self:ComputeAvoidance()

			local mySpeed = self.v:GetVelocity():Length()

			local MIN_SPEED = 300
			local START_DISABLE_SPEED = 400
			local OVERTAKE_BOOST = 1.15

			local speedFactor = math.Clamp(mySpeed / 2000, 0, 1)
			local allowAvoidance = mySpeed > START_DISABLE_SPEED

			if allowAvoidance and avoidSteer ~= 0 then
				local avoidStrength = Lerp(speedFactor, 0.6, 0.2) -- Stronger at low speed, weaker at high speed
				steer = steer + avoidSteer * avoidStrength
			end

			if targetSpeed and allowAvoidance then
				local desiredSpeed = math.max(targetSpeed * OVERTAKE_BOOST, MIN_SPEED)

				if mySpeed > desiredSpeed then -- If we're too fast, slow down
					throttle = math.min(throttle, 0.1)

					if mySpeed > desiredSpeed * 1.25 then
						throttle = -0.6
					end
				else -- If target is VERY slow, try overtaking instead of matching forever
					if targetSpeed < MIN_SPEED * 0.75 then
						throttle = math.max(throttle, 0.1)
					end
				end
			end

			if mySpeed < MIN_SPEED and throttle >= 0 then -- Minimum throttle
				throttle = math.max(throttle, 0.6)
			end

			if self:ObstaclesNearby() and not self.v.uvraceparticipant and not (self.v.UVWanted and UVTargeting) then
				throttle = throttle * -1
			end --Slow down when free roaming

			-- Apply reverse catchup penalty
			if self.__reverse_catchup_mult and self.__reverse_catchup_mult < 0.9 then
				throttle = throttle * self.__reverse_catchup_mult
			end

			-- Traction control
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
					local maxSlip = 0
					for _, wheel in ipairs(self.v.wheels) do
						maxSlip = math.max(maxSlip, math.abs(wheel:GetForwardSlip() or 0))
					end
					local minThrottle = 0.5
					local recoverRate = FrameTime()
					self.AI_ThrottleMul = self.AI_ThrottleMul or 1
					if maxSlip > 8 then
						self.AI_ThrottleMul = math.max(self.AI_ThrottleMul - FrameTime()*2, minThrottle)
					else
						self.AI_ThrottleMul = math.min(self.AI_ThrottleMul + recoverRate, 1)
					end
					throttle = throttle * self.AI_ThrottleMul --Glide traction control
				end
			end
			
			if dist:Dot(forward) < 0 and not self.stuck then
				if vectdot > 0 then
					if right.z > 0 then 
						steer = -1 
					else 
						steer = 1 
					end
				end
			end --K turn
			
			--Set throttle/steering
			if self.v.IsScar then
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
			elseif self.v.IsSimfphyscar then
				self.v.PressedKeys = self.v.PressedKeys or {}
				self.v.PressedKeys["Shift"] = false
				self.v.PressedKeys["joystick_throttle"] = throttle
				self.v.PressedKeys["joystick_brake"] = throttle * -1
				self.v:PlayerSteerVehicle(self, steer < 0 and -steer or 0, steer > 0 and steer or 0)
			elseif self.v.IsGlideVehicle then
				self.v:TriggerInput("Handbrake", 0)
				self.v:TriggerInput("Throttle", throttle)
				self.v:TriggerInput("Brake", throttle * -1)

				if self.v.uvraceparticipant then
					steer = steer * 2
				else
					steer = steer * 1.5
				end

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
				if self.v.LVS then
					self.v:SetSteer(steer * self.v:GetMaxSteerAngle())
				else
					self.v:SetSteering(steer, 0)
				end
			end
			
			-- DV Waypoint advancement (like node transition)
			if self.DVCurrentWaypoint then
				local pos = self.v:WorldSpaceCenter()
				local target = self.DVCurrentWaypoint.Target

				self:ApplyRaceDifficulty( 1 ) -- Apply Racing difficulty
				
				-- DV Node timeout check
				if self.DVWaypointStartTime then
					local elapsed = CurTime() - self.DVWaypointStartTime
					local distSqr = pos:DistToSqr(target)

					if elapsed > 5 and distSqr > (600*600) then
						self.DVCurrentWaypoint = nil
						self.PatrolWaypoint = nil
						self.DVWaypointStartTime = nil
						self.DVWaypointStartPos = nil
						self:FindRace()
						return
					end
				end

				-- Node advancement
				if pos:DistToSqr(target) < (600*600) then
					if self.DVCurrentWaypoint.Neighbors and #self.DVCurrentWaypoint.Neighbors > 0 then
						local nextID = self.DVCurrentWaypoint.Neighbors[math.random(#self.DVCurrentWaypoint.Neighbors)]
						self.DVCurrentWaypoint = dvd.Waypoints[nextID]

						-- Track waypoint start for timeout
						self.DVWaypointStartTime = CurTime()
						self.DVWaypointStartPos = pos
					end
				end
			end
			
			--Resetting
			if not (selfvelocity < 10000 and (throttle > 0 or throttle < 0)) then 
				self.moving = CurTime()
			end
			if self.stuck then 
				self.moving = CurTime()
			end
			
			local timeout = 1
			if timeout and timeout > 0 then
				if CurTime() > self.moving + timeout then --If it has got stuck for enough time.
					self.stuck = true
					self.moving = CurTime()
					timer.Simple(2, function() 
						if IsValid(self.v) then 
							self.stuck = nil 
							self.PatrolWaypoint = nil
							self.DVCurrentWaypoint = nil
							
							if self.v.uvraceparticipant and ((not self.v.UVBustingProgress) or self.v.UVBustingProgress <= 0) then
								UVResetPosition( self.v )
							end
						end 
					end)
				end
			end
			
		else
			self:Stop()
		end
		
		--Pursuit Tech
		if self.v.PursuitTech and RacerPursuitTech:GetBool() then
			for k, v in pairs(self.v.PursuitTech) do
				if v.Tech == "Repair Kit" then
					if self.v.IsGlideVehicle then
						if self.v:GetChassisHealth() <= (self.v.MaxChassisHealth / 3) then
							self:DeployWeapon(self.v, k)
						else
							for _, v in pairs(self.v.wheels) do
								if IsValid(v) and v.bursted and not self.repairtimer then
									local id = "tire_repair"..self.v:EntIndex()
									self.repairtimer = true

									timer.Create(id, 1, 1, function()
										self:DeployWeapon(self.v, k)
										timer.Simple(5, function() self.repairtimer = false; end)
									end)
									break
								end
							end
						end
					elseif self.v.IsSimfphyscar then
						if self.v:GetCurHealth() <= (self.v:GetMaxHealth() / 3) then
							self:DeployWeapon(self.v, k)
						else
							for _, wheel in pairs(self.v.Wheels) do
								if IsValid(wheel) and wheel:GetDamaged() and not self.repairtimer then
									local id = "tire_repair"..self.v:EntIndex()
									self.repairtimer = true

									timer.Create(id, 1, 1, function()
										self:DeployWeapon(self.v, k)
										timer.Simple(5, function() self.repairtimer = false; end)
									end)
									break
								end
							end
						end
					elseif vcmod_main and self.v:GetClass() == "prop_vehicle_jeep" then
						if self.v:VC_getHealth() <= (self.v:VC_getHealthMax() / 3) then
							self:DeployWeapon(self.v, k)
						end
					end
				else
					if self:IsEnemyCloseBy() then
						self:DeployWeapon(self.v, k)
					end
				end
			end
		end	
	end

	function ENT:IsEnemyCloseBy()
		for _, ent in pairs(ents.FindInSphere(self.v:GetPos(), 300)) do
			if (UVTargeting and ent.UnitVehicle) or self.enemies and next(self.enemies) ~= nil and self.enemies[ent:EntIndex()] then
				return true
			end
		end
		return false
	end

	function ENT:Think()
		if not IsValid(self.v) then self:Remove() return end
		--if UVTargeting then return end
		self:SetPos(self.v:GetPos() + (vector_up * 50))
		self:SetAngles(self.v:GetPhysicsObject():GetAngles()+Angle(0,180,0))

		--Flipping/crash
		if UVUnitIsWrecked(self.v) then
			UVPlayerWreck(self.v)
		end
		
		if self.v then
			if self.v.raceinvited then
				if not table.HasValue(UVRaceCurrentParticipants, self.v) then
					UVRaceAddParticipant( self.v, nil, true )
					return
				end
				self.v.raceinvited = false
				timer.Remove('RaceInviteExpire'..v:EntIndex())
			end
		end
		
		if not GetConVar("ai_disabled"):GetBool() and not self.v.uvenginedisabled then
			self:Race()
		else
			self:Stop()
		end
		
		-- Make their computing rate higher ONLY if they are in a race
		-- if self.v.uvraceparticipant then
		-- 	self:NextThink( CurTime() )
		-- 	return true
		-- end
		
		
		-- DEBUG: Draw line to navigation target
		local targetPos = nil
		local colorLine = Color(255,0,0)
		local colorSphere = Color(0,255,0)

		-- RACE NODE DEBUG
		if self.NodePath and self.CurrentNode and self.NodeDebugTarget then
			targetPos = self.NodeDebugTarget
			colorLine = Color(255,0,0)      -- red line for race
			colorSphere = Color(0,255,0)    -- green sphere

		-- DV WAYPOINT DEBUG
		elseif self.DVCurrentWaypoint then
			targetPos = self.DVCurrentWaypoint.Target
			colorLine = Color(0,150,255)    -- blue line for DV
			colorSphere = Color(0,255,255)  -- cyan sphere
		end

		if targetPos then
			debugoverlay.Line(self.v:WorldSpaceCenter(), targetPos, 1, colorLine, true)
			debugoverlay.Sphere(targetPos, 20, 1, colorSphere, true)
		end
		
		if self.enemies then
			for index, enemy in pairs(self.enemies) do
				if not IsValid(Entity(index)) then
					self:RemoveEnemy(index)
				end
			end
		end
	end

	function ENT:Initialize()
		if next(dvd.Waypoints) == nil then
			net.Start("UV_OpenDVWarning")
			net.Broadcast() -- or target a specific player
			SafeRemoveEntity(self)
			return
		end

		self:SetNoDraw(true)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
		self:SetModel(self.Modelname)
		self:SetHealth(-1)
		
		self.moving = CurTime()

		self.enemies = {}
		
		timer.Simple(3, function()
			if IsValid(self.v) then
				if vcmod_main and self.v:GetClass() == "prop_vehicle_jeep" and GetConVar("unitvehicle_enableheadlights"):GetInt() == 2 then 
					self.v:VC_setRunningLights(true)
				end
			end
		end)
		
		--Pick up a vehicle in the given sphere.
		if self.vehicle then
			local v = self.vehicle
			if v.RacerVehicle and v.RacerVehicle:IsNPC() then return end
			if v.IsScar then --If it's a SCAR.
				if not v:HasDriver() or self.temporary then --If driver's seat is empty.
					self.v = v
					v.RacerVehicle = self
					if not self.temporary then
						v.uvclasstospawnon = self:GetClass()
						v.HasDriver = function() return true end --SCAR script assumes there's a driver.
						v.SpecialThink = function() end --Tanks or something sometimes make errors so disable thinking.
						v:StartCar()
					end
				end
			elseif v.IsSimfphyscar and v:IsInitialized() then --If it's a Simfphys Vehicle.
				if not IsValid(v:GetDriver()) or self.temporary then --Fortunately, Simfphys Vehicles can use GetDriver()
					self.v = v
					v.RacerVehicle = self
					self.v.PressedKeys = self.v.PressedKeys or {} --Reset key states.
					self.v.PressedKeys["Shift"] = false
					if not self.temporary then
						v.uvclasstospawnon = self:GetClass()
						v:SetActive(true)
						v:StartEngine()
						if GetConVar("unitvehicle_enableheadlights"):GetInt() == 2 then
							v:SetLightsEnabled(true)
						end
						if GetConVar("unitvehicle_autohealth"):GetBool() or AutoHealthRacer:GetBool() then
							v:SetMaxHealth(math.huge)
							v:SetCurHealth(math.huge)
						end
					end
				end
			elseif isfunction(v.EnableEngine) and isfunction(v.StartEngine) and not v.IsGlideVehicle then --Normal vehicles should use these functions. (SCAR and Simfphys cannot.)
				if isfunction(v.GetWheelCount) and v:GetWheelCount() and not IsValid(v:GetDriver()) or self.temporary then
					self.v = v
					v.RacerVehicle = self
					if not self.temporary then
						v.uvclasstospawnon = self:GetClass()
						v:EnableEngine(true)
						v:StartEngine(true)
						UVApplyVehiclePrerequisites(v)
						if GetConVar("unitvehicle_autohealth"):GetBool() or AutoHealthRacer:GetBool() then
							if vcmod_main and v:GetClass() == "prop_vehicle_jeep" then
								v:VC_repairFull_Admin()
								if not v:VC_hasGodMode() then
									v:VC_setGodMode(true)
								end
							end
						end
					end
				end
			elseif v.IsGlideVehicle then --Glide
				if not IsValid(v:GetDriver()) or self.temporary then
					self.v = v
					v.RacerVehicle = self
					self.v:ResetInputs(1)
					if not self.temporary then
						v.uvclasstospawnon = self:GetClass()
						v:SetEngineState(2)
						v.inputThrottleModifierMode = 2
						v.AirControlForce = vector_origin
						if GetConVar("unitvehicle_enableheadlights"):GetInt() == 2 and v.CanSwitchHeadlights then
							v:SetHeadlightState(1)
						end
						if AutoHealthRacer:GetBool() then
							v:SetChassisHealth(math.huge)
							v:SetEngineHealth(math.huge)
							v:UpdateHealthOutputs()
							v.FallOnCollision = nil
						end
					end
				end
			elseif v.LVS then
				if not v:IsInitialized() then return end
				if IsValid(v:GetDriver()) and not self.temporary then return end
				self.v = v
				v.RacerVehicle = self
				if not self.temporary then
					v.uvclasstospawnon = self:GetClass()
					v:DisableManualTransmission()
					v:StartEngine()
				end
			end
		else
			local distance = DetectionRange:GetFloat()
			for k, v in pairs(ents.FindInSphere(self:GetPos(), distance)) do
				if v:GetClass() == 'prop_vehicle_prisoner_pod' then continue end
				if v.RacerVehicle and v.RacerVehicle:IsNPC() then continue end
				if v.LVS then
					if not v:IsInitialized() then continue end
					if IsValid(v:GetDriver()) and not self.temporary then continue end
					self.v = v
					v.RacerVehicle = self
					if not self.temporary then
						v.uvclasstospawnon = self:GetClass()
						v:DisableManualTransmission()
						v:StartEngine()
					end
					break
				end
				if v:IsVehicle() then
					if v.IsScar then --If it's a SCAR.
						if not v:HasDriver() or self.temporary then --If driver's seat is empty.
							self.v = v
							v.RacerVehicle = self
							if not self.temporary then
								v.uvclasstospawnon = self:GetClass()
								v.HasDriver = function() return true end --SCAR script assumes there's a driver.
								v.SpecialThink = function() end --Tanks or something sometimes make errors so disable thinking.
								v:StartCar()
							end
							break
						end
					elseif v.IsSimfphyscar and v:IsInitialized() then --If it's a Simfphys Vehicle.
						if not IsValid(v:GetDriver()) or self.temporary then --Fortunately, Simfphys Vehicles can use GetDriver()
							self.v = v
							v.RacerVehicle = self
							self.v.PressedKeys = self.v.PressedKeys or {} --Reset key states.
							self.v.PressedKeys["Shift"] = false
							if not self.temporary then
								v.uvclasstospawnon = self:GetClass()
								v:SetActive(true)
								v:StartEngine()
								if GetConVar("unitvehicle_enableheadlights"):GetInt() == 2 then
									v:SetLightsEnabled(true)
								end
								if GetConVar("unitvehicle_autohealth"):GetBool() or AutoHealthRacer:GetBool() then
									v:SetMaxHealth(math.huge)
									v:SetCurHealth(math.huge)
								end
							end
							break
						end
					elseif isfunction(v.EnableEngine) and isfunction(v.StartEngine) and not v.IsGlideVehicle then --Normal vehicles should use these functions. (SCAR and Simfphys cannot.)
						if isfunction(v.GetWheelCount) and v:GetWheelCount() and not IsValid(v:GetDriver()) or self.temporary then
							self.v = v
							v.RacerVehicle = self
							if not self.temporary then
								v.uvclasstospawnon = self:GetClass()
								v:EnableEngine(true)
								v:StartEngine(true)
								UVApplyVehiclePrerequisites(v)
								if GetConVar("unitvehicle_autohealth"):GetBool() or AutoHealthRacer:GetBool() then
									if vcmod_main and v:GetClass() == "prop_vehicle_jeep" then
										v:VC_repairFull_Admin()
										if not v:VC_hasGodMode() then
											v:VC_setGodMode(true)
										end
									end
								end
							end
							break
						end
					elseif v.IsGlideVehicle then --Glide
						if not IsValid(v:GetDriver()) or self.temporary then
							self.v = v
							v.RacerVehicle = self
							self.v:ResetInputs(1)
							if not self.temporary then
								v.uvclasstospawnon = self:GetClass()
								v:TurnOn()
								v.inputThrottleModifierMode = 2
								v.AirControlForce = vector_origin
								if GetConVar("unitvehicle_enableheadlights"):GetInt() == 2 and v.CanSwitchHeadlights then
									v:SetHeadlightState(1)
								end
								if AutoHealthRacer:GetBool() then
									v:SetChassisHealth(math.huge)
									v:SetEngineHealth(math.huge)
									v:UpdateHealthOutputs()
									v.FallOnCollision = nil
								end
							end
							break
						end
					end
				end
			end
		end
		
		if not IsValid(self.v) then SafeRemoveEntity(self) return end --When there's no vehicle, remove Racer Vehicle.

		if not self.temporary then
			local e = EffectData()
			e:SetEntity(self.v)
			util.Effect("propspawn", e) --Perform a spawn effect.
			self.v:EmitSound( "beams/beamstart5.wav" )
		
			if not self.v.racer and UVNames then
				self.v.racer = UVNames.Racers[math.random(1, #UVNames.Racers)] or "Racer " .. self:EntIndex()
				local joinmessage = "Racer AI (" .. self.v.racer .. ") has joined the game"

				net.Start( "UVRacerJoin" )
				net.WriteString(joinmessage)
				net.Broadcast()
			end

			if DriverModel:GetBool() then
				local selectedDriverModel = GetConVar("unitvehicle_racer_drivermodel"):GetString()
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
					self.v:UVVehicleInitialize() --For vehicles that has a driver bodygroup
				end
			end

			if cffunctions then
				UVCFInitialize(self)
			end

			local function BodygroupDamageScript()
				return self.v.frontdamaged or self.v.reardamaged or self.v.leftdamaged or self.v.rightdamaged
			end

			if CustomizeRacer:GetBool() and not self.restrictedCustomization then
				local color = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255))

				self.v:SetColor(color)
				self.v:SetSkin( math.random( 0, self.v:SkinCount() - 1 ) )

				if not BodygroupDamageScript() then
					for i = 0, self.v:GetNumBodyGroups() - 1 do
    				    local bodygroupCount = self.v:GetBodygroupCount( i )
    				    if bodygroupCount > 0 then
    				        self.v:SetBodygroup( i, math.random( 0, bodygroupCount - 1 ) )
    				    end
    				end
				end
			end
		end
		
		local min, max = self.v:GetHitBoxBounds(0, 0) --NPCs aim at the top of the vehicle referred by hit box.
		if not isvector(max) then min, max = self.v:GetModelBounds() end --If getting hit box bounds is failed, get model bounds instead.
		if not isvector(max) then max = vector_up * math.random(80, 200) end --If even getting model bounds is failed, set a random value.
		
		local tr = util.TraceHull({start = self.v:GetPos() + vector_up * max.z, 
		endpos = self.v:GetPos(), ignoreworld = true,
		mins = Vector(-16, -16, -1), maxs = Vector(16, 16, 1)})
		self.CollisionHeight = tr.HitPos.z - self.v:GetPos().z
		if self.CollisionHeight < 10 then self.CollisionHeight = max.z end
		self.v:DeleteOnRemove(self)
		
	end
else
	function ENT:Initialize()
		self:SetNoDraw(true)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
		self:SetModel(self.Modelname)
	end
end

--For Half Life Renaissance Reconstructed
function ENT:GetNoTarget()
	return false
end

--For Simfphys Vehicles
function ENT:GetInfoNum(key, default)
	if key == "cl_simfphys_ctenable" then return 1 --returns the default value
	elseif key == "cl_simfphys_ctmul" then return 0.7 --because there's a little weird code in
	elseif key == "cl_simfphys_ctang" then return 15 --Simfphys:PlayerSteerVehicle()
	elseif isnumber(default) then return default end
	return 0
end