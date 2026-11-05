AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Roadblock Car"
ENT.Author = "UVChief"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
    local SpawnMainUnits = GetConVar("unitvehicle_spawnmainunits")
	
	function ENT:Initialize()
		self:SetModel("models/unitvehiclesprops/uvarrow/uvarrow.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
	end
	
	function ENT:Think()
		
		if UVTargeting and not self.deployed then
			self:DeployRoadBlock()
		end

		if UVJammerDeployed then
			self:Remove()
		end
		
	end
	
	function ENT:DeployRoadBlock()
		self.deployed = true
	
		local pos = self:GetPos()
		local Angles = self:GetAngles()
	
		if SpawnMainUnits:GetBool() then
			if self.Disperse == true then
				if self.Rhino == true then
					UVAutoSpawn(nil, true, nil, nil, pos, Angles, true)
				else
					UVAutoSpawn(nil, nil, nil, nil, pos, Angles, true)
				end
			else
				if self.Rhino == true then
					UVAutoSpawn(nil, true, nil, nil, pos, Angles)
				else
					UVAutoSpawn(nil, nil, nil, nil, pos, Angles)
				end
			end
		end
	
		self:Remove()
	end

else
    function ENT:Draw()   
		if not UVTargeting then
			self:DrawModel() 
		end
	end
    
end