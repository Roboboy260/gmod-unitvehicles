AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Spike Strip"
ENT.Author = "UVChief"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
    local AutoHealth = GetConVar("unitvehicle_autohealth")

	local models = {
		['models/unitvehiclesprops/policespikes/police_spike.mdl'] = 'Y',
		['models/unitvehiclesprops/prop_metalspikes_01/metalspikes.mdl'] = 'X'
	}

	function ENT:Initialize()
		if self.uvdeployed then
			self:SetModel("models/unitvehiclesprops/policespikes/police_spike.mdl")
			self:SetAngles(self:GetAngles()+Angle(0,90,0))
		else
			self:SetModel("models/unitvehiclesprops/prop_metalspikes_01/metalspikes.mdl")
		end
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		if IsValid(self:GetPhysicsObject()) then
			self:GetPhysicsObject():Wake()
		end
		local MathSound = math.random(1,4)
		self:EmitSound( "gadgets/spikestrip/deploy"..MathSound..".wav" )
		local e = EffectData()
		e:SetEntity(self)
		util.Effect("entity_remove", e)
		if self.racerdeployed then
			self:SetSkin(1)
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
		else
			for _, ent in ents.Iterator() do
				if ent.UnitVehicle then
					constraint.NoCollide(ent,self,0,0)
					if ent.IsSimfphyscar then
						if istable(ent.Wheels) then
							for i = 1, table.Count( ent.Wheels ) do
								local Wheel = ent.Wheels[ i ]
								if IsValid(Wheel) then
									constraint.NoCollide(Wheel,self,0,0)
								end
							end
						end
					elseif ent.LVS and ent.GetWheels then
						for _, wheel in ipairs(ent:GetWheels()) do
							constraint.NoCollide(wheel,self,0,0)
						end
					end
				end
			end
		end
	end

	function ENT:StartTouch( ent )
		local car = (isfunction(ent.GetBaseEnt) and ent:GetBaseEnt()) or ent:GetParent() or ent

		if car.UnitVehicle then
			if self.UVRoadblock then
				if not UVUnitPTSpikeStripRoadblockFriendlyFire:GetBool() then return end
			else
				if not self.racerdeployed then return end
			end
		else
			if (self.racerdeployed and (not RacerFriendlyFire:GetBool() or car == self.racerdeployed)) or (car.aicontrolled) then return end
		end

		local damage = 0 -- Divide by the number of wheels the vehicle has, so that the total damage is consistent across all vehicles regardless of wheel count

		if ent:GetClass() == "glide_wheel" then
			if ent.bursted then return end
			ent.bursted = true
			ent:Blow()
			UVRamVehicle(car)

			if car.UnitVehicle then
				damage = UVPTSpikestripDamage:GetFloat()
				if table.HasValue(UVCommanders, car) then
					damage = UVPTSpikestripCommanderDamage:GetFloat()
				end
			else
				damage = UVUnitPTSpikeStripDamage:GetFloat()
			end

			if istable(car.wheels) then
				damage = damage / table.Count(car.wheels)
			end

			timer.Simple(1, function()
				if IsValid(self) then
					self:UVSpikeStripHit(car)
				end
			end)

			timer.Create("uvspiked"..ent:EntIndex(), GetConVar("unitvehicle_spikestripduration"):GetFloat(), 1, function() 
				if ent.bursted and IsValid(ent) and IsValid(car) and GetConVar("unitvehicle_spikestripduration"):GetFloat() > 0 then
					if car.wrecked or car.uvbusted then return end
					ent:EmitSound("gadgets/spikestrip/tirereinflatesound.wav")
					ent.bursted = false
					ent:Repair()
					timer.Remove("uvspiked"..ent:EntIndex())
				end
			end)
		elseif ent:GetClass() == "lvs_wheeldrive_wheel" then
			car = ent:GetBase()
			self:GetPhysicsObject():Sleep()
			if ent:IsTireDestroyed() then return end
			UVRamVehicle(car)

			if car.UnitVehicle then
				damage = UVPTSpikestripDamage:GetFloat()
				if table.HasValue(UVCommanders, car) then
					damage = UVPTSpikestripCommanderDamage:GetFloat()
				end
			else
				damage = UVUnitPTSpikeStripDamage:GetFloat()
			end

			local wheels = car:GetWheels()

			if istable(wheels) then
				damage = damage / table.Count(wheels)
			end

			ent:DestroyTire()
			constraint.NoCollide(ent,self,0,0)

			timer.Simple(1, function()
				if IsValid(self) then
					self:UVSpikeStripHit(car)
				end
			end)

			timer.Create("uvspiked"..ent:EntIndex(), GetConVar("unitvehicle_spikestripduration"):GetFloat(), 1, function() 
				if IsValid(ent) and IsValid(car) and ent:IsTireDestroyed() and GetConVar("unitvehicle_spikestripduration"):GetFloat() > 0 then
					if car.wrecked or car.uvbusted then return end
					ent:EmitSound("gadgets/spikestrip/tirereinflatesound.wav")
					ent:RepairTire()
					timer.Remove("uvspiked"..ent:EntIndex())
				end
			end)
		elseif ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" then
			if ent:GetDamaged() then return end
			UVRamVehicle(car)

			if car.UnitVehicle then
				damage = UVPTSpikestripDamage:GetFloat()
				if table.HasValue(UVCommanders, car) then
					damage = UVPTSpikestripCommanderDamage:GetFloat()
				end
			else
				damage = UVUnitPTSpikeStripDamage:GetFloat()
			end

			if istable(car.Wheels) then
				damage = damage / table.Count(car.Wheels)
			end

			local ogwheelpos
			if ent.GhostEnt then
				ogwheelpos = ent.GhostEnt:GetLocalPos()
			end

			ent:SetDamaged(true)
			constraint.NoCollide(ent,self,0,0)

			timer.Simple(1, function()
				if IsValid(self) then
					self:UVSpikeStripHit(car)
				end
			end)

			timer.Simple(GetConVar("unitvehicle_spikestripduration"):GetFloat(), function() 
				if IsValid(car) and IsValid(ent) and GetConVar("unitvehicle_spikestripduration"):GetFloat() > 0 then
					if car.wrecked or car.uvbusted then return end
					ent:SetDamaged(false)
					ent:EmitSound("gadgets/spikestrip/tirereinflatesound.wav")
					if ent.GhostEnt then
						ent.GhostEnt:SetParent( nil )
						ent.GhostEnt:GetPhysicsObject():EnableMotion( false )
						ent.GhostEnt:SetPos( ent:LocalToWorld(ogwheelpos) )
						ent.GhostEnt:SetParent( ent )
					end
				end
			end)
		elseif ent:GetClass() == "prop_vehicle_jeep" then
			if car.UnitVehicle then
				damage = UVPTSpikestripDamage:GetFloat()
				if table.HasValue(UVCommanders, car) then
					damage = UVPTSpikestripCommanderDamage:GetFloat()
				end
			else
				damage = UVUnitPTSpikeStripDamage:GetFloat()
			end

			local ogmaterial0 = ent:GetWheel(0):GetMaterial()
			local ogmaterial1 = ent:GetWheel(1):GetMaterial()
			local ogmaterial2 = ent:GetWheel(2):GetMaterial()
			local ogmaterial3 = ent:GetWheel(3):GetMaterial()

			if GetConVar("unitvehicle_spikestripduration"):GetFloat() > 0 then
				timer.Create( "uvspiked"..ent:EntIndex(), 0.1, (GetConVar("unitvehicle_spikestripduration"):GetFloat()*10-1), function() 
					if IsValid(ent) then
						ent:GetWheel(0):SetMaterial("slidingrubbertire")
						ent:GetWheel(1):SetMaterial("slidingrubbertire")
						ent:GetWheel(2):SetMaterial("slidingrubbertire")
						ent:GetWheel(3):SetMaterial("slidingrubbertire")
					end
				end)
			else
				timer.Create( "uvspiked"..ent:EntIndex(), 0.1, 0, function() 
					if IsValid(ent) then
						ent:GetWheel(0):SetMaterial("slidingrubbertire")
						ent:GetWheel(1):SetMaterial("slidingrubbertire")
						ent:GetWheel(2):SetMaterial("slidingrubbertire")
						ent:GetWheel(3):SetMaterial("slidingrubbertire")
					end
				end)
			end

			timer.Simple(GetConVar("unitvehicle_spikestripduration"):GetFloat(), function() 
				if IsValid(ent) and GetConVar("unitvehicle_spikestripduration"):GetFloat() > 0 then 
					ent:EmitSound("gadgets/spikestrip/tirereinflatesound.wav")
					ent:GetWheel(0):SetMaterial(ogmaterial0)
					ent:GetWheel(1):SetMaterial(ogmaterial1)
					ent:GetWheel(2):SetMaterial(ogmaterial2)
					ent:GetWheel(3):SetMaterial(ogmaterial3)
					ent.cnWheelHealth = nil
				else
					return
				end 
			end)

			ent.cnWheelHealth = true
			ent:EmitSound("spikestrip/tiredeflatesound.wav")
			ent:EmitSound("weapons/357_fire2.wav")
			self:UVSpikeStripHit(ent)
		end

		UVDamage(car, damage)
	end

	function ENT:UVSpikeStripHit(victim)

		ReportPTEvent( self.unitdeployed or self.racerdeployed, victim, 'Spikestrip', 'Hit' )

		local e = EffectData()
		e:SetEntity(self)
		util.Effect("entity_remove", e)
		self:Remove() --Remove spike strip

		if not victim.UVWanted then return end
		if #ents.FindByClass("uvair") > 0 then
			local unitss = table.Add(units, ents.FindByClass("uvair"))
			local random_entry = math.random(#unitss)	
			local unit = unitss[random_entry]
			if GetConVar("unitvehicle_chatter"):GetBool() and UVTargeting then
				UVChatterSpikeStripHit(unit)
			end
		elseif #ents.FindByClass("npc_uv*") > 0 then
			local units = ents.FindByClass("npc_uv*")
			local random_entry = math.random(#units)	
			local unit = units[random_entry]
			if GetConVar("unitvehicle_chatter"):GetBool() and UVTargeting then
				UVChatterSpikeStripHit(unit)
			end
		end

	end

	function ENT:Think()
		if UVJammerDeployed then
			self:Remove()
		end
	end

else
	local models = {
		['models/unitvehiclesprops/policespikes/police_spike.mdl'] = 'Y',
		['models/unitvehiclesprops/prop_metalspikes_01/metalspikes.mdl'] = 'X'
	}
	
	function ENT:Draw()   
		local mat = Material("sprites/light_ignorez")
		local model = self:GetModel()
		local skins = self:GetSkin()

		self:DrawModel()

		if model ~= "models/unitvehiclesprops/policespikes/police_spike.mdl" then
			self.YellowLightPos1 = Vector(87,0,1)
			self.YellowLightPos2 = Vector(-87,0,1)
			local yellowpos1 = LocalToWorld(self.YellowLightPos1,Angle(),self:GetPos(),self:GetAngles())
			local yellowpos2 = LocalToWorld(self.YellowLightPos2,Angle(),self:GetPos(),self:GetAngles())
			local dist = EyePos():Distance(yellowpos1)
			local dist2 = EyePos():Distance(yellowpos2)

			if dist<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos1,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
				mat:SetInt("$ignorez",0)
					render.SetMaterial(mat)
					render.DrawSprite(yellowpos1,128,128,Color(255,255,0,255-dist/10000*255))
				mat:SetInt("$ignorez",1)
			end

			if dist2<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos2,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
				mat:SetInt("$ignorez",0)
					render.SetMaterial(mat)
					render.DrawSprite(yellowpos2,128,128,Color(255,255,0,255-dist2/10000*255))
				mat:SetInt("$ignorez",1)
			end
		else
			self.YellowLightPos1 = Vector(0,141.5,1)
			self.YellowLightPos2 = Vector(0,-7,1)
			self.YellowLightPos3 = Vector(0,7,1)
			self.YellowLightPos4= Vector(0,-141.5,1)
			local yellowpos1 = LocalToWorld(self.YellowLightPos1,Angle(),self:GetPos(),self:GetAngles())
			local yellowpos2 = LocalToWorld(self.YellowLightPos2,Angle(),self:GetPos(),self:GetAngles())
			local dist = EyePos():Distance(yellowpos1)
			local dist2 = EyePos():Distance(yellowpos2)
			local yellowpos3 = LocalToWorld(self.YellowLightPos3,Angle(),self:GetPos(),self:GetAngles())
			local yellowpos4 = LocalToWorld(self.YellowLightPos4,Angle(),self:GetPos(),self:GetAngles())
			local dist3 = EyePos():Distance(yellowpos1)
			local dist4 = EyePos():Distance(yellowpos2)

			local color1 = Color(0,161,255,255-dist/10000*255)
			local color2 = Color(0,161,255,255-dist2/10000*255)
			local color3 = Color(0,161,255,255-dist3/10000*255)
			local color4 = Color(0,161,255,255-dist4/10000*255)

			if skins == 1 then
				color1 = Color(255,0,0,255-dist/10000*255)
				color2 = Color(255,0,0,255-dist2/10000*255)
				color3 = Color(255,0,0,255-dist3/10000*255)
				color4 = Color(255,0,0,255-dist4/10000*255)
			end

			if dist<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos1,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
				mat:SetInt("$ignorez",0)
					render.SetMaterial(mat)
					render.DrawSprite(yellowpos1,128,128,color1)
				mat:SetInt("$ignorez",1)
			end

			if dist2<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos2,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
				mat:SetInt("$ignorez",0)
					render.SetMaterial(mat)
					render.DrawSprite(yellowpos2,128,128,color2)
				mat:SetInt("$ignorez",1)
			end

			if dist3<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos3,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
				mat:SetInt("$ignorez",0)
					render.SetMaterial(mat)
					render.DrawSprite(yellowpos3,128,128,color3)
				mat:SetInt("$ignorez",1)
			end

			if dist4<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos4,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
				mat:SetInt("$ignorez",0)
					render.SetMaterial(mat)
					render.DrawSprite(yellowpos4,128,128,color4)
				mat:SetInt("$ignorez",1)
			end
		end

	end  

end