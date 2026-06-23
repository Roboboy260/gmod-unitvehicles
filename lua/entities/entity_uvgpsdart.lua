AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "GPS Dart"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true
ENT.CanTool = false
ENT.CanProperty = false
ENT.PhysgunPickup = false

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/unitvehiclesprops/gpsdart/gpsdart.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
    	self:SetMoveType(MOVETYPE_VPHYSICS)
    	self:SetSolid(SOLID_VPHYSICS)
		self:SetTrigger(true) -- Required for StartTouch
		self.batterylife = CurTime() + UVUnitPTGPSDartDuration:GetFloat() --Battery life

		if self.uvdeployed then
			constraint.NoCollide(self.uvdeployed,self,0,0)
			if self.uvdeployed.IsSimfphyscar then
				if istable(self.uvdeployed.Wheels) then
					for i = 1, table.Count( self.uvdeployed.Wheels ) do
						local Wheel = self.uvdeployed.Wheels[ i ]
						if IsValid(Wheel) then
							constraint.NoCollide(Wheel,self,0,0)
						end
					end
				end
			end
			
			if self.uvdeployed.UnitVehicle then
				UVChatterGPSDartDeployed(self.uvdeployed.UnitVehicle)
			end
		end

		local MathSound = math.random(1,3)
		self:EmitSound( "gadgets/trackingdart/fire"..MathSound..".wav" )

	end

	function ENT:UntagDart(target)
		if not target.gpsdarttagged then return end

		if table.HasValue(target.gpsdarttagged, self) then
			table.RemoveByValue(target.gpsdarttagged, self)
		end

		if next(target.gpsdarttagged) == nil then
			target.gpsdarttagged = nil
		end
	end

	function ENT:DestroyDart()
		local e = EffectData()
		e:SetEntity(self)
		util.Effect("entity_remove", e)

		self:EmitSound("gadgets/trackingdart/attachfail.wav")

		if self.taggedobject then
			self:UntagDart(self.taggedobject)
		end

		self:Remove()
	end

	function ENT:Think()
		if not IsValid(self.taggedobject) and self.tagged or self.batterylife < CurTime() or UVJammerDeployed then
			self:DestroyDart()
		end

		if self.tagged and IsValid(self.taggedobject) and self.taggedobject.UVWanted then
			UVLosing = CurTime()
		end
	end

	function ENT:PhysicsCollide(coldata)
		local object = coldata.HitEntity

		if self.tagged and object ~= self.taggedobject then --Destroy tagged dart if collided with something else
			self:DestroyDart()
			return 
		end

		self.tagged = true
		self.taggedobject = object

		timer.Simple(0, function()
			constraint.Weld(object,self,0,0,0,true) -- Stick to target
		end)

		self:EmitSound( "gadgets/trackingdart/attachsuccess.wav" )
		self:EmitSound( "gadgets/trackingdart/activation.wav" )

		if not object.gpsdarttagged then
			object.gpsdarttagged = {}
		end

		table.insert(object.gpsdarttagged, self)

		self:CallOnRemove( "UVGPSDartRemoved", function(dart)
			if IsValid(dart.taggedobject) then
				dart:UntagDart(dart.taggedobject)
			end
		end)

		if self.uvdeployed.UnitVehicle and self.taggedobject.UVWanted then
			UVChatterGPSDartHit(self.uvdeployed.UnitVehicle)
		else
			UVChatterGPSDartMissed(self.uvdeployed.UnitVehicle)
		end
	end

	function ENT:OnTakeDamage(obj_DamageInfo) -- Remove when damaged
		self.batterylife = 0
	end

end


if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end