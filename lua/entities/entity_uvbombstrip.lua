AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Explosive Barrel"
ENT.Author = "UVChief"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
    function ENT:Initialize()
    	self:SetModel("models/props_phx/oildrum001_explosive.mdl")
    	--self:SetMaterial("models/wireframe.vmt")
    	--self:SetColor( Color(255, 191, 0, 255) )
    	self:PhysicsInit(SOLID_VPHYSICS)
    	self:SetMoveType(MOVETYPE_VPHYSICS)
    	self:SetSolid(SOLID_VPHYSICS)
    	local e = EffectData()
    	e:SetEntity(self)
    	util.Effect("entity_remove", e)
    	local selfphy = self:GetPhysicsObject()
    	selfphy:SetMass(selfphy:GetMass()*2)
    end

    function ENT:BombExplode()
    	local effect = EffectData()
    	effect:SetOrigin(self:GetPos())
    	effect:SetScale(2)
    	util.Effect("Explosion",effect)
    	util.BlastDamage(self,self,self:GetPos(),1000,50)
    	local entpos = self:WorldSpaceCenter()
        local objects = ents.FindInSphere(entpos, 1000)
        for k, object in pairs(objects) do
            if IsValid(object:GetPhysicsObject()) then
                local objectphys = object:GetPhysicsObject()
                local vectorDifference = object:WorldSpaceCenter() - entpos
                local angle = vectorDifference:Angle()
    			local power = 1000000
                local force = power * (1 - (vectorDifference:Length()/1000))
                objectphys:ApplyForceCenter(angle:Forward()*force)
                UVRamVehicle(object)
            end
    	end
    	self:Remove()
    end

    function ENT:StartTouch( ent )
    	if IsValid(ent:GetPhysicsObject()) and (ent:GetVelocity():LengthSqr()+self:GetVelocity():LengthSqr()) >= 250000 then
    		self:BombExplode() --Remove explosive barrel
    		if ent.UVWanted and not IsValid(ent.UVPatrol) and not IsValid(ent.UVSupport) and not IsValid(ent.UVPursuit) and not IsValid(ent.UVInterceptor) and not IsValid(ent.UVCommander) and not IsValid(ent.UVSpecial) then
    			if #ents.FindByClass("uvair") > 0 then
    				local unitss = table.Add(units, ents.FindByClass("uvair"))
    				local random_entry = math.random(#unitss)	
    				local unit = unitss[random_entry]
    				if GetConVar("unitvehicle_chatter"):GetBool() and UVTargeting then
    					UVChatterExplosiveBarrelHit(unit)
    				end
    			elseif #ents.FindByClass("npc_uv*") > 0 then
    				local units = ents.FindByClass("npc_uv*")
    				local random_entry = math.random(#units)	
    				local unit = units[random_entry]
    				if GetConVar("unitvehicle_chatter"):GetBool() and UVTargeting then
    					UVChatterExplosiveBarrelHit(unit)
    				end
    			end
    		end
    	end
    end

	function ENT:Think()
		if UVJammerDeployed then
			self:BombExplode()
		end
	end

else
    function ENT:Draw()   
    	self:DrawModel() 
    end

end