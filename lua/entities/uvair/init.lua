AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
local CanWreck = GetConVar("unitvehicle_canwreck")
local Chatter = GetConVar("unitvehicle_chatter")
local PursuitTech = GetConVar("unitvehicle_unit_pursuittech")
local Barrels = GetConVar("unitvehicle_unit_helicopterbarrels")
local SpikeStrips = GetConVar("unitvehicle_unit_helicopterspikestrip")

local dvd = DecentVehicleDestination

local isenemyt = {
	["npc_combine_s"] = true,
	["npc_cscanner"] = true,
	["npc_manhack"] = true,
	["npc_hunter"] = true,
	["npc_antlion"] = true,
	["npc_antlionguard"] = true,
	["npc_antlion_worker"] = true,
	["npc_fastzombie_torso"] = true,
	["npc_fastzombie"] = true,
	["npc_headcrab"] = true,
	["npc_headcrab_fast"] = true,
	["npc_poisonzombie"] = true,
	["npc_headcrab_poison"] = true,
	["npc_zombie"] = true,
	["npc_zombie_torso"] = true,
	["npc_zombine"] = true,
	["npc_gman"] = true,
	["npc_breen"] = true,
}
local function isenemy(ent)
	return isenemyt[ent:GetClass()]
end

function ENT:SpawnFunction(ply, tr, cl)
	ent = ents.Create(cl)
	ent:SetPos(tr.HitPos)
	ent:SetAngles(Angle(0,ply:GetAngles().y+180,0))
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:Initialize()

	self:GetModelData()

	self:SetModel(self.Model or "models/uvair_default.mdl")
	self:SetSkin(self.Skin or math.random(0,self:SkinCount()-1))

	if self.Bodygroups then
		for k,v in pairs(self.Bodygroups) do
			self:SetBodygroup(k, v)
		end
	end

	self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
	
	self.phys = self:GetPhysicsObject()
	self.phys:EnableGravity(false)
	self.phys:SetMass(self.Mass or 5000)
	self.phys:Wake()
	
	self.bountytimer = CurTime()
	self.callsign = "#uv.unit.helicopter"
	self.type = "air"

	local selectedVoice = GetConVar("unitvehicle_unit_air_voice"):GetString()
	local splittedText = string.Explode( ",", selectedVoice )

	local ya = {}

	for k, v in pairs( splittedText ) do
		table.insert( ya, string.Trim( v ) )
	end

	self.voice = ya[math.random(1, #ya)]

	self.deployingspikes = CurTime()
	self.LastUpdate = CurTime()
	self.ReplicTime = CurTime()
	self.Downed = false
	self:SetHealth(500)
	self:SetCustomCollisionCheck(true)
	
	self.isBusting = nil
	self.disengaging = nil
	self.crashing = nil
	self.spotted = nil
	self.cooldown = true
	UVEnemyBusted = nil
	UVEnemyEscaped = nil
	
	self.RotateVelocity = 0
	
	self.UVAir = self
	self.UnitVehicle = self

	self:ChangeAltitude()

	local weaponchoices = {}

	if Barrels:GetBool() then
		table.insert(weaponchoices, "barrels")
	end
	if SpikeStrips:GetBool() then
		table.insert(weaponchoices, "spikestrips")
	end

	self.WeaponChoice = (#weaponchoices > 0 and weaponchoices[math.random(1, #weaponchoices)]) or nil

	local MathAggressive = math.random(0,1)
	if MathAggressive == 1 then
		self.aggressive = true
	end
		
	timer.Simple((math.random(60,300)), function() 
		if IsValid(self) and not self.Downed then --Fuel is randomized 
			if Chatter:GetBool() and not (self.crashing or self.disengaging) then
				if IsValid(self:GetTarget()) then
					UVChatterLowOnFuel(self)
				else
					UVChatterDisengaging(self)
				end
			end
			self.disengaging = true
		end
	end)
	
	if UVTargeting and Chatter:GetBool() and not (self.crashing or self.disengaging) and IsValid(self) then
		UVChatterInitialize(self) 
	end

	UVDeploys = UVDeploys + 1

	for _, v in pairs(UVPursuitScopes) do
		if v.InPursuit then
			v.Deploys = v.Deploys + 1
		end
	end

	net.Start("UVHUDAddUV")
	net.WriteInt(self:EntIndex(), 32)
	net.WriteInt(self:GetCreationID(), 32)
	net.WriteString("air")
	net.Broadcast()
	
end

function ENT:OnRemove()
	if self.displaybusting then
		UVHUDBusting = nil
		net.Start( "UVHUDStopBusting" )
		net.Broadcast()
		for k, v in pairs(ents.FindByClass("npc_uv*")) do
			v.busting = CurTime()
			v.displaybusting = nil
		end
		for k, v in pairs(ents.FindByClass("uvair")) do
			v.busting = CurTime()
			v.displaybusting = nil
		end
	end
	if table.HasValue(UVUnitsChasing, self) then
		table.RemoveByValue(UVUnitsChasing, self)
	end
end

function ENT:FindPatrol()
	if next(dvd.Waypoints) == nil then
		return
	end
	
	local Waypoint = dvd.GetNearestWaypoint(self:WorldSpaceCenter())
	if Waypoint.Neighbors then
		local WaypointTable = {}
		for k, v in pairs(Waypoint.Neighbors) do
			if not self.PreviousPatrolWaypoint or self.PreviousPatrolWaypoint["Target"] ~= dvd.Waypoints[v]["Target"] then
				table.insert(WaypointTable, v)
			end
		end --Don't turn around
		self.PatrolWaypoint = dvd.Waypoints[WaypointTable[math.random(#WaypointTable)]]
	else
		self.PatrolWaypoint = Waypoint
	end
end

function ENT:Think()

	local target = self:GetTarget()
	local isValidTarget = IsValid(target)

	if isValidTarget and self:IsSeeTarget() and not self.Downed and not self.disengaging then
		if not table.HasValue(UVUnitsChasing, self) then
			table.insert(UVUnitsChasing, self)
		end
	else
		if table.HasValue(UVUnitsChasing, self) then
			table.RemoveByValue(UVUnitsChasing, self)
		end
	end

	local eScope = isValidTarget and UVGetScope(target) or nil

	if isValidTarget then
		
		if self.CloseToTarget and self:IsSeeTarget() and not self.spotted then
			self.spotted = true
			timer.Simple(20, function() self.cooldown = nil end)

			if not UVTargeting then
				UVTargeting = true
			end

			if Chatter:GetBool() and not (self.crashing or self.disengaging) then
				UVChatterSpottedEnemy(self) 
			end
		end

		--Busting
		local btimeout = GetConVar("unitvehicle_bustedtimer"):GetFloat()
		
		if self:IsSeeTarget() and not self.Downed then
			if not self.cooldown and self.aggressive and PursuitTech:GetBool() then
				self.cooldown = true
				self.deployingspikes = CurTime()

				if self.WeaponChoice == 'spikestrips' then
					local spikes = ents.Create("entity_uvspikestrip")

					spikes.uvdeployed = true
					spikes:SetPos(self:GetPos())
					spikes:SetAngles(self.phys:GetAngles() +Angle(0,90,0))
					spikes:Spawn()

					spikes.PhysgunDisabled = false
					spikes:GetPhysicsObject():EnableMotion(true)
					constraint.NoCollide(self,spikes,0,0)

					local phspikes = spikes:GetPhysicsObject()
					phspikes:SetVelocity(target:GetPhysicsObject():GetVelocity()*2)
					phspikes:SetMass(100)

					timer.Simple((math.random(5,10)), function() self.cooldown = nil end)
					timer.Simple(10, function() 
						if IsValid(spikes) then 
							spikes:Remove() 
							if Chatter:GetBool() and not (self.crashing or self.disengaging) then
								UVChatterSpikeStripMiss(self) 
							end
						end 
					end)

					if Chatter:GetBool() and not (self.crashing or self.disengaging) then
						UVChatterSpikeStripDeployed(self) 
					end
				elseif self.WeaponChoice == 'barrels' then
					local bomb = ents.Create("entity_uvbombstrip")

					constraint.NoCollide(self,bomb,0,0)
					bomb:SetPos(self:GetPos())
					bomb:SetAngles(self.phys:GetAngles() +Angle(0,90,0))
					bomb:Spawn()
					bomb:Ignite(10)
					bomb.PhysgunDisabled = false
					bomb:GetPhysicsObject():EnableMotion(true)

					local phbomb = bomb:GetPhysicsObject()
					phbomb:SetVelocity(target:GetPhysicsObject():GetVelocity()*2)
					phbomb:SetMass(100)

					self:EmitSound( "npc/attack_helicopter/aheli_mine_drop1.wav" )
					timer.Simple((math.random(1,5)), function() self.cooldown = nil end)

					timer.Simple(10, function() 
						if IsValid(bomb) then 
							bomb:BombExplode()
						end 
					end)

					if Chatter:GetBool() and not (self.crashing or self.disengaging) then
						UVChatterExplosiveBarrelDeployed(self) 
					end
				end
			end
		end
	end

	UVHeliCooldown = CurTime()
	
	if self.Downed then
		if table.HasValue(UVUnitsChasing, self) then
			table.RemoveByValue(UVUnitsChasing, self)
		end
		if not self.DownState and CurTime()-self.DownTime>2.5 then
			self.DownState = true
			self.DownTime = CurTime()
			
			--self:SetColor(Color(25,25,25))
			self:PhysicsInit(SOLID_VPHYSICS)
			self.phys = self:GetPhysicsObject()
			self:Ignite(30)
			
			self.phys:EnableGravity(true)
			self.phys:AddVelocity(Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(0,1))*500)
			
			local eff = EffectData()
			eff:SetOrigin(self:GetPos())
			util.Effect("Explosion",eff)
			util.BlastDamage(self,self,self:GetPos(),1000,10)
		elseif self.DownState and CurTime()-self.DownTime>5 then
			self:Explode()
		end
		
		self.disengaging = nil
		self.CloseToTarget = false
		if self.displaybusting then
			UVHUDBusting = nil
			net.Start( "UVHUDStopBusting" )
			net.Broadcast()
			for k, v in pairs(ents.FindByClass("npc_uv*")) do
				v.busting = CurTime()
				v.displaybusting = nil
			end
			for k, v in pairs(ents.FindByClass("uvair")) do
				v.busting = CurTime()
				v.displaybusting = nil
			end
		end
	end
	
	self:NextThink(CurTime()+0.25)
	return true
end

function ENT:SelfRotate()
	if self:GetVelocity() == vector_origin then
		self:StopRotating()
	else
		self:RotateToTarget(self:GetPos()+self:GetVelocity())
	end
end

function ENT:PhysicsUpdate()

	local target = self:GetTarget()
	local isValidTarget = IsValid(target)

	local p = self:GetPos()
	if not InfMap and (math.abs(p.x)>16000 or math.abs(p.y)>16000 or math.abs(p.z)>16000) then
		if self.disengaging then
			self:Remove()
		end

		self:SetPos(Vector(math.Clamp(p.x,-16000,16000),math.Clamp(p.y,-16000,16000),math.Clamp(p.z,-16000,16000))) -- out of bounds
	end

	if self.disengaging then
		if table.HasValue(UVUnitsChasing, self) then
			table.RemoveByValue(UVUnitsChasing, self)
		end
		self:ApplyAngles()
		self:ApplyHeight("up")
		self:SelfRotate()
		
		if not self.disengagingtimer then
			self.disengagingtimer = CurTime()
			timer.Simple(30, function() 
				if IsValid(self) and not self.Downed then 
					self:Remove() 
				end 
			end)
		end
		
		self.LastUpdate = CurTime()
		self.CloseToTarget = false
		if self.displaybusting and not UVEnemyBusted then
			UVHUDBusting = nil
			net.Start( "UVHUDStopBusting" )
			net.Broadcast()
			for k, v in pairs(ents.FindByClass("npc_uv*")) do
				v.busting = CurTime()
				v.displaybusting = nil
			end
			for k, v in pairs(ents.FindByClass("uvair")) do
				v.busting = CurTime()
				v.displaybusting = nil
			end
		end
		
		if isValidTarget then
			self:SetTarget(nil)
		end

		return
	end
	if not self.Downed and not self.disengaging then

		if self:Health()<=0 then
			self:StartCrush()
		end
				
		--Bounty
		local botimeout = 10
		if CurTime() > self.bountytimer + botimeout and isValidTarget and self:IsSeeTarget() and UVTargeting then
			--if eScope then eScope.Bounty = eScope.Bounty + (eScope.BountyTime or 0) end
			self.bountytimer = CurTime()
			local MathAggressive = math.random(1,10) 
			if MathAggressive == 1 then
				if not self.aggressive and UVTargeting then
					self.aggressive = true

					local engagingchance = math.random(1,2)
					if engagingchance == 1 then
						self.engaging = true
					end

					if Chatter:GetBool() and not (self.crashing or self.disengaging) and self:IsSeeTarget() and not UVCalm then
						UVChatterAggressive(self) 
					end
				else
					self.engaging = nil
					self.aggressive = nil
					if Chatter:GetBool() and not (self.crashing or self.disengaging) and self:IsSeeTarget() and not UVCalm then
						UVChatterPassive(self) 
					end
				end
				
				self:ChangeAltitude()
			end
			if isValidTarget and Chatter:GetBool() and not (self.crashing or self.disengaging) and target:GetVelocity():LengthSqr() > 100000 and self:IsSeeTarget() and MathAggressive ~= 1 then
				UVChatterCloseToEnemy(self, target)
			end
		end
				
		local closetotar = self.CloseToTarget
		self.CloseToTarget = false
		
		self:ApplyAngles()
		self:ApplyHeight()
		
		if GetConVar("ai_disabled"):GetBool() then
			self:SlowDown()
			self:StopRotating()
			
			self.LastUpdate = CurTime()
			return
		end

		local targetpos = vector_origin
		if isValidTarget then
			if self.aggressive and not self.engaging then
				targetpos = (self:GetTargetPos()+self:GetTarget():GetVelocity())
			else
				targetpos = self:GetTargetPos()
			end
		else
			if IsValid(self.potentialtarget) then
				targetpos = self.potentialtarget:GetPos()
			else
				if next(UVPotentialSuspects) ~= nil then
					self.potentialtarget = UVPotentialSuspects[math.random(1, #UVPotentialSuspects)]
				end
				
				if self.spotted then
					self.spotted = nil
				end
			end
		end
		
		if UVTargeting then
			if not isValidTarget or target.uvbusted then
				if next(UVWantedTableVehicle) ~= nil then -- Look for remaining suspects
					local suspecttable = {}
					for k, v in pairs(UVWantedTableVehicle) do
						local scope = UVGetScope(v)
						if scope.InPursuit then
							table.insert(suspecttable, v)
						end
					end
					local randomsuspect = suspecttable[math.random(1, #suspecttable)]
					self:SetTarget(randomsuspect)
				end
			else
				self:RotateToTarget(targetpos)
			end
		else
			if isValidTarget and target.uvbusted then
				self:SetTarget(nil) -- Forget busted suspect
			end
		end

		local eScope = UVGetScope(target)
		if isValidTarget and not (eScope and eScope.EnemyEscaping) and not UVJammerDeployed then
			if self:GetVelocity():LengthSqr() <= (self:DistIgnoreZ((targetpos+target:GetVelocity()))^2) and not (self:DistIgnoreZ(targetpos) <= 500 and self:IsSeeTarget()) then
				self:FlyTo(targetpos)
			else
				if self.engaging then
					self:FlyTo(targetpos)
				else
					self:SlowDown()
				end
				self.CloseToTarget = true
			end
		else
			if self.PatrolWaypoint then
				self.waypointPos = self.PatrolWaypoint["Target"]+(vector_up * 50)

				self:FlyTo(self.waypointPos, true)
				self:RotateToTarget(self.waypointPos)

				--When there
				if self:DistIgnoreZ(self.waypointPos) <= 1000 then
					if self.PatrolWaypoint.Neighbors then
						local WaypointTable = {}
						for k, v in pairs(self.PatrolWaypoint.Neighbors) do
							if not self.PreviousPatrolWaypoint or self.PreviousPatrolWaypoint["Target"] ~= dvd.Waypoints[v]["Target"] then
								table.insert(WaypointTable, v)
							end
						end --Don't turn around
						self.PreviousPatrolWaypoint = self.PatrolWaypoint
						self.PatrolWaypoint = dvd.Waypoints[WaypointTable[math.random(#WaypointTable)]]
					else
						self.PatrolWaypoint = nil
					end
				end

				if self.potentialtarget and 
				self.potentialtarget.UVWanted and
				UVStraightToWaypoint(self:GetPos(), self.potentialtarget:GetPos()) and 
				not UVTargeting then
					UVTargeting = true
				end
			else
				self:RotateAround(targetpos)
				self:SelfRotate()
				self:FindPatrol()
			end
			self.LastUpdate = CurTime()
		end
	else
		local time = CurTime()-self.LastUpdate
		
		local vel = self.phys:GetVelocity()
		self.DownedRotate = self.DownedRotate+(not self.DownState and 90*time or (CurTime()-self.DownTime)*2/2)
		self.phys:SetAngles(select(2,LocalToWorld(Vector(),Angle(0,self.DownedRotate,0),Vector(),self.DownedAng)))
		self.phys:AddAngleVelocity(-self.phys:GetAngleVelocity())
		self.phys:SetVelocity(vel)
		if self.DownState and vel.z<-200 then self.phys:AddVelocity(Vector(0,0,9.8)) end
	end
	
	self.LastUpdate = CurTime()
end

function ENT:ApplyAngles()
	local time = CurTime()-self.LastUpdate
	local ang = self:GetAngles()
	local absvel = self.phys:GetVelocity()
	local vel = WorldToLocal(absvel,Angle(),Vector(),Angle(0,ang.y,0))
	local speed = vel:Length2D()
	
	ang.p = math.Clamp(vel.x/2000*30,-15,15)*(speed==0 and 1 or math.abs(vel.x)/speed)
	ang.y = ang.y+self.RotateVelocity*time
	ang.r = math.Clamp(-vel.y/2000*30,-15,15)*(speed==0 and 1 or math.abs(vel.y)/speed)
	
	self.phys:SetAngles(ang)
	self.phys:AddAngleVelocity(-self.phys:GetAngleVelocity())
	self.phys:SetVelocity(absvel)
end

function ENT:ChangeAltitude()
	self.Altitude = math.random(300, 2000)
end

function ENT:ApplyHeight(height)
	local target = self:GetTarget()
	local isValidTarget = IsValid(target)

	if not self.Altitude then
		self:ChangeAltitude()
	end
	
	height = height or self:CheckWorldHeight()

	local altmin = self.Altitude - 10
	local altmax = self.Altitude + 10
	
	if (not height or height=="stop") and isValidTarget then
		local d = self:GetPos().z-self:GetTargetPos().z
		
		height = d<(altmin) and "up" or d>(altmax) and height~="stop" and "down" or false
	end
	
	local vel = self.phys:GetVelocity()
	local time = CurTime()-self.LastUpdate
	local max = 400
	
	if height and height~="stop" then
		self.StayInAir = false
	
		if height=="up" then
			if vel.z<max then
				vel.z = math.min(vel.z+200*time,max)
			end
		else
			if vel.z>-max then
				vel.z = math.max(vel.z-200*time,-max)
			end
		end
	elseif math.Round(vel.z)~=0 and not self.StayInAir then
		if vel.z>0 then
			vel.z = math.max(vel.z-200*vel.z/30*time,0)
		else
			vel.z = math.min(vel.z+200*-vel.z/30*time,0)
		end
	elseif math.Round(vel.x)==0 and math.Round(vel.y)==0 and (math.Round(vel.z)==0 or self.StayInAir) then
		self.StayInAir = true
		
		local dir = math.floor(CurTime()/2)==math.Round(CurTime()/2) and 1 or -1
		vel.z = 25*dir
	else
		self.StayInAir = false
	end
	
	self.phys:SetVelocity(vel)
end

function ENT:StopRotating()
	local time = CurTime()-self.LastUpdate
	local vel = self.RotateVelocity
	self.RotateVelocity = math.Clamp(vel>0 and math.max(vel-90*time,0) or math.min(vel+90*time,0),-60,60)
end

function ENT:RotateToTarget(pos)
	if not pos then
		self:StopRotating()
		return 
	end
	local time = CurTime()-self.LastUpdate
	local vel = self.RotateVelocity
	local _,ang = WorldToLocal(Vector(),(pos-Vector(self:GetPos().x,self:GetPos().y,pos.z)):Angle(),Vector(),Angle(0,self:GetAngles().y,0))
	local side = ang.y>0 and 1 or -1
	
	local mv = WorldToLocal(self.phys:GetVelocity(),Angle(),Vector(),(pos-Vector(self:GetPos().x,self:GetPos().y,pos.z)):Angle())
	local spd = mv:Length2D()
	
	if math.abs(ang.y)>(spd>2000 and (spd==0 and 1 or math.abs(mv.x/mv.y)>3) and 10 or 10) then
		if math.abs(vel)<60 then
			self.RotateVelocity = math.Clamp(self.RotateVelocity+90*side*time,-60,60)
		end
	elseif math.abs(vel)>0 then
		self:StopRotating()
	end
end

function ENT:RotateAround(pos)
	if not pos then return end
	local time = CurTime()-self.LastUpdate
	local ang = (Vector(pos.x,pos.y,self:GetPos().z)-self:GetPos()):Angle()
	local vel1 = WorldToLocal(self.phys:GetVelocity(),Angle(),Vector(),ang)
	self:SlowDown(pos)
	local vel2 = WorldToLocal(self.phys:GetVelocity(),Angle(),Vector(),ang)
	
	local dist = self:DistIgnoreZ(pos) or 0
	local spd = math.min(100/750*dist,1000)
	
	if vel1.y>spd then return end
	
	local vel = Vector(math.max(math.abs(vel2.x),dist>50 and 20 or 0)*(vel2.x~=0 and vel2.x/math.abs(vel2.x) or 1),vel1.y>spd and vel1.y or spd,vel2.z)
	vel = LocalToWorld(vel,Angle(),Vector(),ang)
	self.phys:SetVelocity(vel)

	if UVJammerDeployed then
		self.RotateVelocity = -45
	end
end

function ENT:FlyTo(pos, slowdown)
	local time = CurTime()-self.LastUpdate
	local dist = self:DistIgnoreZ(pos)
	local vel = WorldToLocal(self.phys:GetVelocity(),Angle(),Vector(),(Vector(pos.x,pos.y,self:GetPos().z)-self:GetPos()):Angle())
	local speed = slowdown and 1000 or 5000
	
	vel.x = math.min(speed,vel.x+(dist-100)/1*time)
	vel.y = math.min(speed,vel.y-vel.y/1*time)
	
	vel = LocalToWorld(vel,Angle(),Vector(),(Vector(pos.x,pos.y,self:GetPos().z)-self:GetPos()):Angle())
	self.phys:SetVelocity(vel)
end

function ENT:SlowDown(pos)
	pos = pos or self:GetPos()+self.phys:GetVelocity():GetNormalized()
	
	local time = CurTime()-self.LastUpdate
	local vel = WorldToLocal(self.phys:GetVelocity(),Angle(),Vector(),(Vector(pos.x,pos.y,self:GetPos().z)-self:GetPos()):Angle())
	
	vel.x = vel.x>0 and math.max(vel.x-1000*time,0) or math.min(vel.x+1000*time,0)
	vel.y = vel.y>0 and math.max(vel.y-1000*time,0) or math.min(vel.y+1000*time,0)
	
	vel = LocalToWorld(vel,Angle(),Vector(),(Vector(pos.x,pos.y,self:GetPos().z)-self:GetPos()):Angle())
	self.phys:SetVelocity(vel)
end

function ENT:DistIgnoreZ(pos)
	return self:GetPos():Distance(Vector(pos.x,pos.y,self:GetPos().z))
end

function ENT:CheckWorldHeight()

	local altmin = self.Altitude - 10
	local altmax = self.Altitude + 10

	if self.engaging and IsValid(self:GetTarget()) then
		local d = self:GetPos().z-(self:GetTargetPos()).z
		local velocityz = (self.phys:GetVelocity().z * -1)
		if velocityz<d then
			return "down"
		elseif d>0 then
			return "stop"
		else
			self.engaging = nil
			return "up"
		end
	end

	local floor = util.TraceLine({start = self:GetPos(),endpos = self:GetPos()-Vector(0,0,altmax),filter = self,mask = MASK_ALL})
	if floor.Hit then
		if self:GetPos().z-floor.HitPos.z>(altmin) then
			return "stop"
		else
			return "up"
		end
	end
	
	if util.TraceLine({start = self:GetPos(),endpos = self:GetPos(),mask = MASK_NPCWORLDSTATIC}).StartSolid then
		if util.TraceLine({start = self:GetPos(),endpos = self:GetPos()+Vector(0,0,48000),mask = MASK_NPCWORLDSTATIC}).Hit then
			return "up"
		elseif util.TraceLine({start = self:GetPos(),endpos = self:GetPos()-Vector(0,0,48000),mask = MASK_NPCWORLDSTATIC}).Hit then
			return "down"
		end
	else
		local tr = util.TraceLine({start = self:GetPos(),endpos = self:GetPos()+Vector(0,0,48000),mask = MASK_NPCWORLDSTATIC})
		if tr.Hit then
			local tr = util.TraceLine({start = tr.HitPos,endpos = self:GetPos(),mask = MASK_NPCWORLDSTATIC})
			if tr.HitTexture=="**displacement**" then
				return "up"
			end
		end
	end
	
	return false
end

function ENT:IsSeeTarget()
	if not util.IsInWorld(self:WorldSpaceCenter()) then return end

	local suspect = self:GetTarget() or self.potentialtarget
	local isValidSuspect = IsValid(suspect)

	if isValidSuspect then
		local tr = util.TraceLine({start = self:WorldSpaceCenter(), endpos = suspect:WorldSpaceCenter(), mask = MASK_OPAQUE, filter = {self, suspect}}).Fraction==1
		local tScope = UVGetScope(suspect)
		if tScope and tScope.Hiding then
			return tobool(tr) and self:DistIgnoreZ(self:GetTargetPos()) <= 2000
		else
			return tobool(tr) and self:DistIgnoreZ(self:GetTargetPos()) <= 10000
		end
	end

	return false
end

function ENT:OnTakeDamage(dmg)
	if GetConVar("unitvehicle_canwreck"):GetBool() and not self.Downed then
		self:SetHealth(self:Health()-dmg:GetDamage())
	end
end

function ENT:StartCrush()
	self.disengaging = nil
	self.Downed = true
	
	local r = self:GetAngles().r
	r = r>0 and math.max(r,30) or math.min(r,-30)
	
	self.DownedAng = Angle(self:GetAngles().p,self:GetAngles().y,r)
	self.DownedRotate = 0
	
	self.phys:SetAngles(self.DownedAng)
	self.phys:AddVelocity(LocalToWorld(Vector(0,-r*5,0),Angle(),Vector(),Angle(0,self:GetAngles().y,0)))
	
	self.DownTime = CurTime()
	self.DownState = false
	
	if not self.crashing then
		if not timer.Exists("uvcombotime") then
			timer.Create("uvcombotime", 5, 1, function() 
				UVComboBounty = 1 
				timer.Remove("uvcombotime")
			end)
		else
			timer.Remove("uvcombotime")
			timer.Create("uvcombotime", 5, 1, function() 
				if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() and not (self.crashing or self.disengaging) and UVComboBounty >= 3 then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					UVChatterMultipleUnitsDown(unit)
				end
				UVComboBounty = 1
				timer.Remove("uvcombotime")
			end)
		end
		local eff = EffectData()
		eff:SetOrigin(self:GetPos())
		util.Effect("Explosion",eff)
		util.BlastDamage(self,self,self:GetPos(),1000,10)
		if Chatter:GetBool() and IsValid(self) then
			UVChatterWreck(self)
		end
		local bountyplus = (UVUBountyAir:GetInt())*(UVComboBounty)
		local bounty = string.Comma(bountyplus)
		if self:GetTarget():IsVehicle() then 
			if UVGetDriver(self:GetTarget()) and UVGetDriver(self:GetTarget()):IsPlayer() then 
				UVNotifyCenter({UVGetDriver(self:GetTarget())}, "uv.hud.combo", "UNITS_DISABLED", "uv.unit.helicopter", 'Helicopter', bountyplus, UVComboBounty, UVGetDriver(self:GetTarget()):IsPlayer())
			end 
		end
		UVWrecks = UVWrecks + 1
		local scope = UVGetScope(self:GetTarget())
		if scope then
			scope.Wrecks = scope.Wrecks + 1
			scope.Bounty = scope.Bounty + bountyplus
		end
		hook.Run( "UV_Event", "onUnitWrecked", self:GetTarget(), self )
		self.crashing = true
		self:EmitSound( "npc/attack_helicopter/aheli_damaged_alarm1.wav" )
		self:EmitSound( "npc/combine_gunship/gunship_crashing1.wav" )
		UVBounty = (UVBounty+bountyplus)
		UVComboBounty = UVComboBounty + 1
		
		if IsValid(self:GetTarget()) then
			self:SetTarget(nil)
		end
	end
	
end

function ENT:Explode()
	local effect = EffectData()
	effect:SetOrigin(self:GetPos())
	effect:SetScale(2)
	util.Effect("Explosion",effect)
	util.BlastDamage(self,self,self:GetPos(),1000,50)
	self:Remove()
	local wreck = ents.Create("prop_physics")
	wreck:SetModel(self:GetModel())
	wreck:SetPos(self:GetPos())
	wreck:SetAngles(self.phys:GetAngles())
	for k,v in pairs(wreck:GetBodyGroups()) do
		wreck:SetBodygroup(k, self:GetBodygroup(k))
	end
	wreck:SetSkin(self:GetSkin())
	for k, v in pairs(self:GetMaterials()) do
		wreck:SetSubMaterial( k, self:GetSubMaterial(k))
	end
	if isfunction(self.OnWreck) then
		self.OnWreck(wreck)
	end
	wreck:Spawn()
	wreck:GetPhysicsObject():EnableMotion(true)
	ParticleEffectAttach("smoke_burning_engine_01", PATTACH_ABSORIGIN_FOLLOW, wreck, 0)
	wreck:Ignite(30)
	local phwreck = wreck:GetPhysicsObject()
	phwreck:SetVelocity(self.phys:GetVelocity())
	phwreck:SetMass(self.phys:GetMass())
	phwreck:AddAngleVelocity(self.phys:GetAngleVelocity())
	local e = EffectData()
	e:SetEntity(wreck)
	util.Effect("entity_remove", e)
	timer.Simple(60, function() if IsValid(wreck) then wreck:Remove() end end)
	timer.Simple(math.random(1,3), function()
		if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() and not (self.crashing or self.disengaging) then
			local units = ents.FindByClass("npc_uv*")
			local random_entry = math.random(#units)	
			local unit = units[random_entry]
			if unit == self then return end
			UVChatterAirDown(unit)
		end
	end)
	if not self.crashing then
		if not timer.Exists("uvcombotime") then
			timer.Create("uvcombotime", 5, 1, function() 
				UVComboBounty = 1 
				timer.Remove("uvcombotime")
			end)
		else
			timer.Remove("uvcombotime")
			timer.Create("uvcombotime", 5, 1, function() 
				if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() and not (self.crashing or self.disengaging) and UVComboBounty >= 3 then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					UVChatterMultipleUnitsDown(unit)
				end
				UVComboBounty = 1
				timer.Remove("uvcombotime")
			end)
		end
		if Chatter:GetBool() and not (self.crashing or self.disengaging) and IsValid(self) then
			UVChatterOnRemove(self)
		end
		local bountyplus = (UVUBountyAir:GetInt())*(UVComboBounty)
		local bounty = string.Comma(bountyplus)
		if self:GetTarget():IsVehicle() then 
			if UVGetDriver(self:GetTarget()) and UVGetDriver(self:GetTarget()):IsPlayer() then 
				UVNotifyCenter({UVGetDriver(self:GetTarget())}, "uv.hud.combo", "UNITS_DISABLED", "uv.unit.helicopter", 'Helicopter', bountyplus, UVComboBounty, UVGetDriver(self:GetTarget()):IsPlayer())
			end 
		end
		UVWrecks = UVWrecks + 1
		local scope = UVGetScope(self:GetTarget())
		if scope then
			scope.Wrecks = scope.Wrecks + 1
			scope.Bounty = scope.Bounty + bountyplus

			UVAddInfraction( self:GetTarget(), 'homicide' )
		end
		hook.Run( "UV_Event", "onUnitWrecked", self:GetTarget(), self )
		self.crashing = true
		UVBounty = (UVBounty+bountyplus)
		UVComboBounty = UVComboBounty + 1
	end
end

function ENT:StartTouch(prop)
	if self.damagecooldown or self.engaging or self.crashing then return end

	self.damagecooldown = true

	timer.Simple(1, function() self.damagecooldown = nil end)

	if prop:GetClass() == "prop_physics" or prop:IsVehicle() then
		if not self.damaged then
			self.damaged = true
			self:SetHealth(self:Health()/2)
			ParticleEffectAttach("smoke_burning_engine_01", PATTACH_ABSORIGIN_FOLLOW, self, 0)
			if Chatter:GetBool() then
				UVSoundChatter(self, self.voice, "hit")
			end
		else
			MathCrash = math.random(1,2)
			if MathCrash == 1 then
				self:StartCrush()
			else
				self:Explode()
			end
		end
	end

	if prop == self.potentialtarget and not UVTargeting then
		UVTargeting = true
	end

end

local function check(ent1,ent2)
	if (ent1:GetClass()=="uvair" or ent1.Base=="uvair") and not ent1.Downed and (ent2==game.GetWorld() or (ent2:GetClass() ~= "prop_physics" and not ent2:IsVehicle())) then
		return false
	end
end

hook.Add("ShouldCollide","uvair",function(ent1,ent2)
	local ret = check(ent1,ent2)==false or check(ent2,ent1)==false
	if ret then return false end
end)