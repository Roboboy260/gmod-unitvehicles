AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Editable = true

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 0, "MaxPos")
	self:NetworkVar("Int", 0, "ID", {KeyName = "UVRace_CheckpointID", Edit = {type = "Generic", order = 1}})
	self:NetworkVar("Int", 1, "SpeedLimit", {KeyName = "UVRace_SpeedLimit", Edit = {type = "Generic", order = 2}})
	self:NetworkVar("Vector", 0, "LocalPos")
	self:NetworkVar("Vector", 1, "LocalMaxPos")
	self:NetworkVar("Vector", 2, "Chunk")
	self:NetworkVar("Vector", 3, "ChunkMax")
	self:NetworkVar("Bool", 0, "FinishLine")
end

local vec0 = Vector(0, 0, 0)

function ENT:Initialize()
	self:EnableCustomCollisions(true)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionBounds(vec0, self:GetMaxPos() - self:GetPos())

	self:DrawShadow(false)

	if CLIENT then
		self:SetRenderBoundsWS(self:GetPos(), self:GetMaxPos())
		if GMinimap then
			self.blip, self.blip_id = GMinimap:AddBlip( {
                id = "Checkpoint"..self:GetID(),
                position = (self:GetPos() + self:GetMaxPos())/2,
                icon = "unitvehicles/icons/MINIMAP_ICON_CIRCUIT.png",
                scale = 1.5,
                color = Color( 255, 255, 255),
				alpha = 0,
                lockIconAng = true
            } )
		end
		local index = self:EntIndex()
		hook.Add("PostDrawOpaqueRenderables", "DrawCheckpoint_" .. index, function()
			if not IsValid(self) then hook.Remove("PostDrawOpaqueRenderables", "DrawCheckpoint_" .. index) return end
			self:Draw()
		end)
	end

	if SERVER then
		hook.Add("SetupPlayerVisibility", "UVRace_Checkpoint" .. self:EntIndex(), function()
			AddOriginToPVS(self:GetLocalPos())
		end)
		UVRaceCheckFinishLine()
	end

end

local allowedMasks = {
	[1107312651] = true, -- tool trace
	[1174421519] = true -- remover trace
}
function ENT:TestCollision( startpos, delta, isbox, extents, mask )
	if allowedMasks[mask] then return true end -- only traces allowed
end

if CLIENT then
	local ang0 = Angle(0, 0, 0)
	function ENT:Draw()
		local id = self:GetID()
		local speedlimit = self:GetSpeedLimit() or math.huge
		if not id then return end
		local pos = self:GetPos()
		
		local lp = LocalPlayer()
		local dist = lp:GetPos():Distance(self:GetPos())
        local distInMeters = dist * 0.01905
		local distInFeet  = distInMeters * 3.28084
		local distInYards = distInMeters * 1.09361

		local fadeStart = 9000
		local fadeEnd = 300

		local fade = 1 - math.Clamp((dist - fadeEnd) / (fadeStart - fadeEnd), 0, 1)
		
		if not UVHUDRace and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" then

			cam.Start3D()

			render.SetColorMaterial()
			if InfMap then render.OverrideDepthEnable(true, true) end

			local pos = (InfMap and self:GetLocalPos()) or self:GetPos()
			local max = (InfMap and self:GetLocalMaxPos()) or self:GetMaxPos()

			local chunk = (InfMap and self:GetChunk()) or nil
			local maxChunk = (InfMap and self:GetChunkMax()) or nil

			local max = max - pos

			if InfMap then
				local lpChunk = LocalPlayer().CHUNK_OFFSET
				if lpChunk ~= chunk and lpChunk ~= maxChunk then
					if InfMap then render.OverrideDepthEnable(false, false) end
					cam.End3D()
					return
				end
			end
			if id == 0 then
				render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 255, 100 * fade))
				if not InfMap then
					render.DrawBox(pos, ang0, vec0, max, Color(255, 255, 255, 100 * fade))
				end
			elseif id == 1 then
				if self:GetFinishLine() then
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 0, 0, 100 * fade))
					if not InfMap then
						render.DrawBox(pos, ang0, vec0, max, Color(255, 0, 0, 100 * fade))
					end
				else
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(0, 255, 0, 100 * fade))
					if not InfMap then
						render.DrawBox(pos, ang0, vec0, max, Color(0, 255, 0, 100 * fade))
					end
				end
			else
				if self:GetFinishLine() then
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 0, 0, 100 * fade))
					if not InfMap then
						render.DrawBox(pos, ang0, vec0, max, Color(255, 0, 0, 100 * fade))
					end
				else
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 0, 100 * fade))
					if not InfMap then
						render.DrawBox(pos, ang0, vec0, max, Color(255, 255, 0, 100 * fade))
					end
				end
			end

			if InfMap then render.OverrideDepthEnable(false, false) end
			cam.End3D()

			local textScale = Lerp(fade, 0.01, 1)
			cam.Start2D()
			
			if InfMap then render.OverrideDepthEnable(true, true) end
				local point = (InfMap and ((self:GetLocalPos() + self:GetLocalMaxPos()) / 2)) or (pos + self:OBBCenter())
				local data2D = point:ToScreen()
				local cx, cy = data2D.x, data2D.y
				
				local m = Matrix()
				m:Translate(Vector(cx, cy, 0))
				m:Scale(Vector(textScale, textScale, 1))
				m:Translate(Vector(-cx, -cy, 0))

				cam.PushModelMatrix(m)
					if id == 0 then
						local blink = 255 * math.abs(math.sin(RealTime() * 4))
						draw.SimpleText( UVString("uv.racemanager.invalid"), "UVFont4", data2D.x, data2D.y - 10, Color( 255, blink, blink, 255 * fade ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						draw.SimpleText( string.format( UVString("uv.racemanager.speedlimit"), tostring(speedlimit) ), "UVFont4", data2D.x, data2D.y + 10, Color( 255, 255, 255, 255 * fade ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					elseif id == 1 then
						if self:GetFinishLine() then
							draw.SimpleText( UVString("uv.racemanager.finishline"), "UVFont4", data2D.x, data2D.y - 10, Color( 255, 50, 50, 255 * fade ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
							draw.SimpleText( string.format( UVString("uv.racemanager.speedlimit"), tostring(speedlimit) ), "UVFont4", data2D.x, data2D.y + 10, Color( 255, 255, 255, 255 * fade ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						else
							draw.SimpleText( UVString("uv.racemanager.startline"), "UVFont4", data2D.x, data2D.y - 10, Color( 50, 255, 50, 255 * fade ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
							draw.SimpleText( string.format( UVString("uv.racemanager.speedlimit"), tostring(speedlimit) ), "UVFont4", data2D.x, data2D.y + 10, Color( 255, 255, 255, 255 * fade ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						end
					else
						if self:GetFinishLine() then
							draw.SimpleText( UVString("uv.racemanager.finishline") .. ": " .. id, "UVFont4", data2D.x, data2D.y - 10, Color( 255, 50, 50, 255 * fade ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
							draw.SimpleText( string.format( UVString("uv.racemanager.speedlimit"), tostring(speedlimit) ), "UVFont4", data2D.x, data2D.y + 10, Color( 255, 255, 255, 255 * fade ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						else
							draw.SimpleText( string.format( UVString("uv.racemanager.checkpoint"), id ), "UVFont4", data2D.x, data2D.y - 10, Color( 255, 255, 0, 255 * fade ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
							draw.SimpleText( string.format( UVString("uv.racemanager.speedlimit"), tostring(speedlimit) ), "UVFont4", data2D.x, data2D.y + 10, Color( 255, 255, 255, 255 * fade ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						end
					end
				cam.PopModelMatrix()

			if InfMap then render.OverrideDepthEnable(false, false) end
			cam.End2D()

		elseif UVHUDRace then
			
			if not UVHUDDisplayRacing then return end
			if not UVHUDRaceCurrentCheckpoint then return end
			if UVHUDRaceInfo and not UVHUDRaceInfo.Info.VisibleCheckpoints then return end
			--Show current checkpoint and the checkpoint after that
			local currentcheckpoint = UVHUDRaceCurrentCheckpoint + 1
			local nextcheckpoint = currentcheckpoint + 1 

			if nextcheckpoint > GetGlobalInt("uvrace_checkpoints") then
				nextcheckpoint = 1
			end

			if (id ~= currentcheckpoint and id ~= nextcheckpoint) or id == 0 then return end//or id == 0 then return end

			local pos = (InfMap and self:GetLocalPos()) or self:GetPos()
			local max = (InfMap and self:GetLocalMaxPos()) or self:GetMaxPos()

			local chunk = (InfMap and self:GetChunk()) or nil
			local maxChunk = (InfMap and self:GetChunkMax()) or nil

			if InfMap then
				local lpChunk = LocalPlayer().CHUNK_OFFSET
				if lpChunk ~= chunk then return end
			end
			
			cam.Start3D()
			if InfMap then render.OverrideDepthEnable(true, true) end
			render.SetColorMaterial()

			local max = max - pos
			local arrowMat = Material("unitvehicles/icons/minimap_icon_car.png")

			if id == currentcheckpoint then
				if id == GetGlobalInt("uvrace_checkpoints") then --Finish line
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 255, 255 * fade))
				else
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(0, 255, 0, 255 * fade))
				end
			else
				if id == GetGlobalInt("uvrace_checkpoints") then --Finish line
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 255, 255 * fade))
				elseif UVHUDRaceCurrentLap ~= UVHUDRaceLaps or id ~= 1 then --Last lap
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 0, 255 * fade))
				end
			end

			if InfMap then render.OverrideDepthEnable(false, false) end
			cam.End3D()
			
			local textScale = Lerp(fade, 0.25, 1)
			
			local unitType = GetConVar("unitvehicle_unitstype"):GetInt()

			local displayDist, displayString
			if unitType == 1 then
				displayDist = distInFeet
				displayString = UVString("uv.dist.feet")
			elseif unitType == 2 then
				displayDist = distInYards
				displayString = UVString("uv.dist.yards")
			else
				displayDist = distInMeters
				displayString = UVString("uv.dist.meter")
			end
		
			cam.Start2D()
			
			if InfMap then render.OverrideDepthEnable(true, true) end
				local point = (InfMap and ((self:GetLocalPos() + self:GetLocalMaxPos()) / 2)) or (pos + self:OBBCenter())
				local data2D = point:ToScreen()
				local cx, cy = data2D.x, data2D.y
				
				local m = Matrix()
				m:Translate(Vector(cx, cy, 0))
				m:Scale(Vector(textScale, textScale, 1))
				m:Translate(Vector(-cx, -cy, 0))

				local cptext = UVString("uv.race.hud.check")
				local hidearrow = nil
				
				if id == GetGlobalInt("uvrace_checkpoints") then --Finish line
					if UVHUDRaceCurrentLap == UVHUDRaceLaps then --Last lap
						cptext = UVString("uv.race.finish")
						hidearrow = true
					else
						cptext = UVString("uv.race.hud.lap") .. " " .. (UVHUDRaceCurrentLap + 1)
					end
				end

				cam.PushModelMatrix(m)
					if id == currentcheckpoint then
						draw.SimpleTextOutlined( string.format( displayString, math.Round(displayDist) ), "UVFont5ShadowLarge", data2D.x, data2D.y - 125, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2.25, Color( 0, 0, 0, 50 ) )
						draw.SimpleTextOutlined( cptext, "UVFont5UI", data2D.x, data2D.y - 70, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2.25, Color( 0, 0, 0, 50 ) )

						local lp = LocalPlayer()
						local playerForward = lp:GetForward()
						playerForward.z = 0
						playerForward:Normalize()

						local center = pos + self:OBBCenter()
						local nextEnt
						for _, ent in ipairs(ents.FindByClass(self:GetClass())) do
							if ent:GetID() == nextcheckpoint then
								nextEnt = ent
								break
							end
						end
						if IsValid(nextEnt) then
							local nextCenter = nextEnt:GetPos() + nextEnt:OBBCenter()
							local toNext = nextCenter - center
							toNext.z = 0
							toNext:Normalize()

							-- Signed angle between player forward and checkpoint direction
							local dot = playerForward:Dot(toNext)
							local cross = playerForward:Cross(toNext).z
							local angleDiff = math.deg(math.atan2(cross, dot))

							-- Clamp to -90..90 so arrow only rotates left/right
							angleDiff = math.Clamp(angleDiff * 2, -90, 90)

							-- Draw arrow in 2D HUD
							local screenPos = center:ToScreen()
							local size = 40

							surface.SetMaterial(arrowMat)
							surface.SetDrawColor(255, 255, 255, 255 * fade)
							if not hidearrow then
								surface.DrawTexturedRectRotated(data2D.x, data2D.y, size, size, angleDiff)
							end
						end
					end
				cam.PopModelMatrix()

			if InfMap then render.OverrideDepthEnable(false, false) end
			cam.End2D()
		end
	end

	function ENT:TestCollision(startpos, delta, isbox, extents, mask)
    	return false  -- Will never be hit by traces
	end

	function ENT:OnRemove()
		if GMinimap then
			GMinimap:RemoveBlipById( self.blip_id )
		end
	end
end

if SERVER then
	function ENT:OnRemove()
		hook.Remove("SetupPlayerVisibility", "UVRace_Checkpoint" .. self:EntIndex())
		UVRaceCheckFinishLine()
	end
end