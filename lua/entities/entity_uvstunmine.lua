AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Stun Mine"
ENT.Author = "Razor"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
    local AutoHealth = GetConVar("unitvehicle_autohealth")
	local UpVector = Vector(0,0,100)
	
	function ENT:Initialize()
		self:SetModel("models/unitvehiclesprops/stunmineprojectile/stunmineprojectile.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:EmitSound( "gadgets/stunmine/deploy.wav" )
		self:EmitSound( "gadgets/stunmine/active.wav" )
		local e = EffectData()
		e:SetEntity(self)
		util.Effect("entity_remove", e)
		if self.racerdeployed then
			constraint.NoCollide(self.racerdeployed,self,0,0)
			if self.racerdeployed.IsSimfphyscar then
				if istable(self.racerdeployed.Wheels) then
					for i = 1, table.Count( self.racerdeployed.Wheels ) do
						local Wheel = self.racerdeployed.Wheels[ i ]
						if IsValid(Wheel) then
							constraint.NoCollide(Wheel,self,0,0)
						end
					end
				end
			elseif self.racerdeployed.LVS then
				for _, wheel in ipairs(self.racerdeployed:GetWheels()) do
					constraint.NoCollide(wheel,self,0,0)
				end
			end
		end
	end
	
	function ENT:Think()
		
		local objects = ents.FindInSphere(self:WorldSpaceCenter(), 100)
		for k, object in pairs(objects) do
			if object ~= self.racerdeployed and (object:GetClass() == "prop_vehicle_jeep" or object.IsSimfphyscar or object.IsGlideVehicle or object.LVS) then
				if not (self.racerdeployed and not object.UnitVehicle and not RacerFriendlyFire:GetBool()) then
					if object.esfon then
						self:Remove()
						UVDeactivateESF(object)
						ReportPTEvent( self.racerdeployed, object, "StunMine", "Counter" )
						return
					end
					ReportPTEvent( self.racerdeployed, object, "StunMine", "Hit" )
					self:UVStunmineHit()
				end
			end
		end

		if UVJammerDeployed then
			self:Remove()
		end
		
	end
	
	function ENT:StartTouch( ent )
		if ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" then
			local car = ent:GetBaseEnt()
			if self.racerdeployed and not car.UnitVehicle then
				if not RacerFriendlyFire:GetBool() then return end
			end
			if car.esfon then
				self:Remove()
				UVDeactivateESF(car)
				ReportPTEvent( self.racerdeployed, car, "StunMine", "Counter" )
				return
			end
			ReportPTEvent( self.racerdeployed, car, "StunMine", "Hit" )
			self:UVStunmineHit()
			return
		end
		if ent:IsVehicle() or ent.LVS then
			if self.racerdeployed and not ent.UnitVehicle then
				if not RacerFriendlyFire:GetBool() then return end
			end
			if ent.esfon then
				self:Remove()
				UVDeactivateESF(ent)
				ReportPTEvent( self.racerdeployed, ent, "StunMine", "Counter" )
				return
			end
			ReportPTEvent( self.racerdeployed, ent, "StunMine", "Hit" )
			self:UVStunmineHit()
		end
	end
	
	function ENT:UVStunmineHit()
		
		local car = self.racerdeployed or self
		local carchildren = {}
		local carconstraints = {}
		if IsValid(car) then
			carchildren = car:GetChildren()
			carconstraints = constraint.GetAllConstrainedEntities(car)
		end
		local entpos = self:WorldSpaceCenter()
		local objects = ents.FindInSphere(entpos, 1000)
		for k, object in pairs(objects) do
			if object ~= car and (not table.HasValue(carchildren, object) and not table.HasValue(carconstraints, object) and IsValid(object:GetPhysicsObject()) or object.UnitVehicle or object.UVWanted or object:GetClass() == "entity_uv*" or object.uvdeployed) then
				if not object.UnitVehicle and car and not RacerFriendlyFire:GetBool() then
				else
					local objectphys = object:GetPhysicsObject()
					local vectorDifference = object:WorldSpaceCenter() - entpos
					local angle = vectorDifference:Angle()
					local power = UVPTStunMinePower:GetInt()
					local damage = UVPTStunMineDamage:GetFloat()
					local force = power * (1 - (vectorDifference:Length()/1000))

					if self.upgraded then
						damage = damage * 2
						force = force * 2
					end

					objectphys:ApplyForceCenter(angle:Forward()*force)
					UVRamVehicle(object)
					damage = (table.HasValue(UVCommanders, object) and UVPTStunMineCommanderDamage:GetFloat()) or damage
					UVDamage( object, damage )
					
						-- if self.racerdeployed then
						-- 	if not UVGetDriver(self.racerdeployed) then continue end
						-- 	if UVGetDriver(self.racerdeployed):IsPlayer() then
						-- 		ReportPTEvent( self.racerdeployed, car, "StunMine", "Hit" )
						-- 	end
						-- end
					local e = EffectData()
					e:SetEntity(object)
					util.Effect("phys_unfreeze", e)
				end
			end
		end
	
		local e2 = EffectData()
		e2:SetEntity(self)
		util.Effect("entity_remove", e2)
		self:EmitSound( "gadgets/stunmine/hit.wav" )
		self:Remove()
	end
	
	function ENT:OnRemove()
		self:StopSound( "gadgets/stunmine/active.wav" )
	end

else
    function ENT:Draw()   
		local mat = Material("sprites/light_ignorez")
		local model = self:GetModel()
		local skins = self:GetSkin()
		local color = self.upgraded and Color(125,249,255) or color_white
	
		self:DrawModel() 
		self.LightPos1 = Vector(0,0,0)
		local lightpos1 = LocalToWorld(self.LightPos1,Angle(),self:GetPos(),self:GetAngles())
		local dist = EyePos():Distance(lightpos1)
		
		if dist<10000 and math.floor(CurTime()*4)==math.Round(CurTime()*4) and util.TraceLine({start = EyePos(),endpos = lightpos1,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
			mat:SetInt("$ignorez",0)
				render.SetMaterial(mat)
				render.DrawSprite(lightpos1,128,128,Color(color.r,color.g,color.b,255-dist/10000*255))
			mat:SetInt("$ignorez",1)
		end
	
	end

end