AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "#uv.repairshop"
ENT.Author = "Mechanic"
ENT.Purpose = "Repair your vehicles here."
ENT.Category = "#uv.unitvehicles"
ENT.Spawnable = true
ENT.AdminOnly = false

if SERVER then
    local AutoHealth = GetConVar("unitvehicle_autohealth")
    local RepairCooldown = GetConVar("unitvehicle_repaircooldown")
    local RepairRange = GetConVar("unitvehicle_repairrange")
    
    function ENT:Initialize()
        self:SetModel("models/unitvehiclesprops/uvrepairstation/uvrepairstation.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetTrigger(true)
        self:UseTriggerBounds( true, RepairRange:GetInt() )
        
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(false)
        end
        
        net.Start("UVHUDAddUV")
        net.WriteInt(self:EntIndex(), 32)
        net.WriteInt(self:GetCreationID(), 32)
        net.WriteString("repairshop")
        net.Broadcast()
	end

    function ENT:Touch(v)
        if IsValid(v) and not v.uvrepairdelayed and not v.wrecked then
            if v:GetClass() == "prop_vehicle_jeep" or v.IsSimfphyscar or v.IsGlideVehicle or (v.LVS and v.BaseClass and v.BaseClass.ClassName == "lvs_base_wheeldrive") then
                UVRepair(v)
            end
        end
    end

else
    function ENT:Draw()   
		self:DrawModel()
		local pos = self:GetPos()
	
		local localPlayer = LocalPlayer()
		local box_color = Color(0, 255, 0)
	
		if IsValid(localPlayer) then
			local pos = pos
		
			local MaxX, MinX, MaxY, MinY
			local isVisible = false
		
			local p = pos
			local screenPos = p:ToScreen()
			isVisible = screenPos.visible
			
			if MaxX ~= nil then
				MaxX, MaxY = math.max(MaxX, screenPos.x), math.max(MaxY, screenPos.y)
				MinX, MinY = math.min(MinX, screenPos.x), math.min(MinY, screenPos.y)
			else
				MaxX, MaxY = screenPos.x, screenPos.y
				MinX, MinY = screenPos.x, screenPos.y
			end
		
			local textX = (MinX + MaxX) / 2
			local textY = MinY - 20
			cam.Start2D()
				draw.DrawText("+", "UVFont4", textX, textY - 30, box_color, TEXT_ALIGN_CENTER)
			cam.End2D()
		end
	end
    
end