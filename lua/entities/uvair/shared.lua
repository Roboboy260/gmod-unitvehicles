ENT.Type = "anim"
ENT.PrintName = "#uv.unit.helicopter"
ENT.Author = "Cross"
ENT.Purpose = "To ensure that dirtbags gets fucked by the long arm of the law."
ENT.Category = "#uv.unitvehicles"
ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:GetModelData()
	
	local config = UVUHelicopterModel:GetString()
	local configtable = UVAirModelsData[config] or UVAirModelsData["Default"]

	if not configtable then self:Remove() return end

	if configtable then
		for k,v in pairs(configtable) do
			self[k] = v
		end
	end

	if self.StrobePos and self.StrobePos2 and self.PortPos and self.StarboardPos and self.SternPos and self.SpotlightPos then
		self.GotAllLights = true
	end

end

function ENT:SetupDataTables()
	self:NetworkVar("Entity",0,"Target")
	self:NetworkVar("Vector",0,"TarPos")
	self:NetworkVar("Bool",0,"TarMode")
end

function ENT:GetTargetPos()
	local suspect = self:GetTarget() or self.potentialtarget
	if IsValid(suspect) then 
		return suspect:GetPos() 
	else
		return self:GetPos()
	end
end