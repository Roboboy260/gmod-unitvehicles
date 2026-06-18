AddCSLuaFile()

local ENT = ENT
local dvd = DecentVehicleDestination
local TurnOnLights = dvd and dvd.CVars.TurnOnLights or nil
local LIGHTLEVEL = {
	NONE = 0,
	RUNNING = 1,
	HEADLIGHTS = 2,
	ALL = 3,
}

local function GetPhoton2Siren(vehicle)
	local pc = vehicle:GetPhotonControllerFromAncestor()
    if IsValid(pc) and pc.CurrentProfile.Siren then
		local sirenname = pc.CurrentProfile.Siren[1]
		local siren = Photon2.GetSiren( sirenname )
		return siren
    end
end

function ENT:GetMaxSteeringAngle()
	if self.v.IsScar then
		return self.v.MaxSteerForce * 3 -- Obviously this is not actually steering angle
	elseif self.v.IsSimfphyscar then
		return self.v.VehicleData.steerangle
	else
		local mph = self.v:GetSpeed()
		if mph < self.SteeringSpeedFast then
			return Lerp((mph - self.SteeringSpeedSlow)
			/ (self.SteeringSpeedFast - self.SteeringSpeedSlow),
			self.SteeringAngleSlow, self.SteeringAngleFast)
		else
			return Lerp((mph - self.SteeringSpeedFast)
			/ (self.BoostSpeed - self.SteeringSpeedFast),
			self.SteeringAngleFast, self.SteeringAngleBoost)
		end
	end
end

function ENT:GetTraceFilter()
	local filter = table.Add({self, self.v}, constraint.GetAllConstrainedEntities(self.v))
	if self.v.IsScar then
		table.Add(filter, self.v.Seats or {})
		table.Add(filter, self.v.Wheels)
		table.Add(filter, self.v.StabilizerProp)
	elseif self.v.IsSimfphyscar then
		table.Add(filter, self.v.VehicleData.filter)
	else
		table.Add(filter, self.v:GetChildren())
	end
	
	return filter
end

function ENT:GetRunningLights()
	if self.v.IsScar then
		return self.v:GetNWBool "HeadlightsOn"
	elseif self.v.IsSimfphyscar then
		return self.SimfphysRunningLights
	elseif self.v.LVS or self.v.LVS_GUNNER then
        local lh = isfunction(self.v.GetLightsHandler) and self.v:GetLightsHandler()
        return isfunction(self.v.HasFogLights) and self.v:HasFogLights()
           and IsValid(lh) and lh:GetFogActive()
	elseif vcmod_main
	and isfunction(self.v.VC_getStates) then
		local states = self.v:VC_getStates()
		return istable(states) and states.RunningLights
	elseif Photon2
    and isfunction(vehicle.GetPhotonControllerFromAncestor) then
        local pc = self.v:GetPhotonControllerFromAncestor()
        if IsValid(pc) and on then
            pc:SetChannelMode("Vehicle.Lights", "AUTO")
        end
	end
end

function ENT:GetFogLights()
	if self.v.IsScar then
		return self.v:GetNWBool "HeadlightsOn"
	elseif self.v.IsSimfphyscar then
		return self.SimfphysFogLights
	elseif vcmod_main
	and isfunction(self.v.VC_getStates) then
		local states = self.v:VC_getStates()
		return istable(states) and states.FogLights
	end
end

function ENT:GetLights(highbeams)
	if self.v.IsScar then
		return self.v:GetNWBool "HeadlightsOn"
	elseif self.v.IsSimfphyscar then
		return Either(highbeams, self.v.LampsActivated, self.v.LightsActivated)
	elseif self.v.LVS or self.v.LVS_GUNNER then
        local lh = isfunction(self.v.GetLightsHandler) and self.v:GetLightsHandler()
        if not (IsValid(lh) and lh:GetActive()) then return false end
        if highbeams then
            return isfunction(self.v.HasHighBeams) and self.v:HasHighBeams() and lh:GetHighActive()
        else
            return lh:GetActive()
        end
	elseif vcmod_main
	and isfunction(self.v.VC_getStates) then
		local states = self.v:VC_getStates()
		return istable(states) and Either(highbeams, states.HighBeams, states.LowBeams)
	elseif Photon2
    and isfunction(vehicle.GetPhotonControllerFromAncestor) then
        local pc = self.v:GetPhotonControllerFromAncestor()
        if IsValid(pc) then
            return pc:GetChannelMode("Vehicle.Lights") ~= "HEADLIGHTS"
        end
	elseif Photon
	and isfunction(self.v.ELS_Illuminate) then
		return self.v:ELS_Illuminate()
	end
end

function ENT:GetTurnLight(left)
	if self.v.IsScar then -- Does SCAR have turn lights?
	elseif self.v.IsSimfphyscar then
		return Either(left, self.TurnLightLeft, self.TurnLightRight)
	elseif vcmod_main
	and isfunction(self.v.VC_getStates) then
		local states = self.v:VC_getStates()
		return istable(states) and Either(left, states.TurnLightLeft, states.TurnLightRight)
	elseif Photon
	and isfunction(self.v.CAR_TurnLeft)
	and isfunction(self.v.CAR_TurnRight) then
		return Either(left, self.v:CAR_TurnLeft(), self.v:CAR_TurnRight())
	end
end

function ENT:GetHazardLights()
	if self.v.IsScar then
	elseif self.v.IsSimfphyscar then
		return self.HazardLights
	elseif vcmod_main
	and isfunction(self.v.VC_getStates) then
		local states = self.v:VC_getStates()
		return istable(states) and states.HazardLights
	elseif Photon
	and isfunction(self.v.CAR_Hazards) then
		return self.v:CAR_Hazards()
	end
end

function ENT:GetELS(v)
	local vehicle = v or self.v
	if not (IsValid(vehicle) and vehicle:IsVehicle()) then return end
	if vehicle.IsScar then
		return vehicle.SirenIsOn
	elseif vehicle.IsSimfphyscar then
		return vehicle:GetEMSEnabled()
	elseif vehicle.LVS or vehicle.LVS_GUNNER then
        return isfunction(vehicle.GetSirenMode) and vehicle:GetSirenMode() >= 0
    elseif vehicle.IsGlideVehicle then
        return vehicle:GetSirenState() >= 1
	elseif Photon2
    and isfunction(vehicle.GetPhotonControllerFromAncestor) then
        local pc = self.v:GetPhotonControllerFromAncestor()
        if IsValid(pc) then
            return pc:GetChannelMode("Emergency.Warning") ~= "OFF"
        end
	elseif Photon and not GetConVar("unitvehicle_vcmodelspriority"):GetBool()
	and isfunction(self.v.ELS_Siren)
	and isfunction(self.v.ELS_Lights) then
		return self.v:ELS_Siren() and self.v:ELS_Lights()
	elseif vcmod_main and vcmod_els
	and isfunction(vehicle.VC_getELSLightsOn) then
		return vehicle:VC_getELSLightsOn()
	end
end

function ENT:GetELSSound(v)
	local vehicle = v or self.v
	if not (IsValid(vehicle) and vehicle:IsVehicle()) then return end
	if vehicle.IsScar then
		return vehicle.SirenIsOn
	elseif vehicle.IsSimfphyscar then
		return vehicle.ems and vehicle.ems:IsPlaying()
	elseif vehicle.LVS or vehicle.LVS_GUNNER then
        return isfunction(vehicle.GetSirenMode) and vehicle:GetSirenMode() >= 0
    elseif vehicle.IsGlideVehicle then
        return vehicle:GetSirenState() == 2
	elseif Photon2
    and isfunction(vehicle.GetPhotonControllerFromAncestor) then
        local pc = self.v:GetPhotonControllerFromAncestor()
        if IsValid(pc) then
            return pc:GetChannelMode("Emergency.Siren") ~= "OFF"
        end
	elseif Photon and not GetConVar("unitvehicle_vcmodelspriority"):GetBool()
	and isfunction(self.v.ELS_Siren) then
		return self.v:ELS_Siren()
	elseif vcmod_main and vcmod_els
	and isfunction(vehicle.VC_getELSSoundOn)
	and isfunction(vehicle.VC_getStates) then
		local states = vehicle:VC_getStates()
		return vehicle:VC_getELSSoundOn() or istable(states) and states.ELS_ManualOn
	end
end

function ENT:GetHorn(v)
	local vehicle = v or self.v
	if not (IsValid(vehicle) and vehicle:IsVehicle()) then return end
	if self.v.IsGlideVehicle then
		return vehicle:GetIsHonking()
	elseif vehicle.IsScar then
		return vehicle.Horn:IsPlaying()
	elseif vehicle.IsSimfphyscar then
		return vehicle.HornKeyIsDown
	elseif vehicle.LVS or vehicle.LVS_GUNNER then
        return IsValid(vehicle.HornSound) and vehicle.HornSound:IsPlaying()
	elseif Photon2
    and isfunction(vehicle.GetPhotonControllerFromAncestor) then
        local pc = self.v:GetPhotonControllerFromAncestor()
        if IsValid(pc) then
            return pc:GetChannelMode("Emergency.SirenOverride") == "AIR"
        end
	elseif Photon and not GetConVar("unitvehicle_vcmodelspriority"):GetBool()
	and isnumber(EMV_HORN)
	and isfunction(vehicle.ELS_Horn) then
		return vehicle:GetDTBool(EMV_HORN)
	elseif vcmod_main
	and isfunction(vehicle.VC_getStates) then
		local states = vehicle:VC_getStates()
		return istable(states) and states.HornOn
	end
end

function ENT:GetLocked(v)
	local vehicle = v or self.v
	if not (IsValid(vehicle) and vehicle:IsVehicle()) then return end
	if vehicle.IsScar then
		return vehicle:IsLocked()
	elseif vehicle.IsSimfphyscar then
		return vehicle.VehicleLocked
	elseif vcmod_main
	and isfunction(vehicle.VC_isLocked) then
		return vehicle:VC_isLocked()
	else
		return tonumber(vehicle:GetKeyValues().VehicleLocked) ~= 0
	end
end

function ENT:GetEngineStarted(v)
	local vehicle = v or self.v
	if not (IsValid(vehicle) and vehicle:IsVehicle()) then return end
	if vehicle.IsScar then
		return vehicle.IsOn
	elseif vehicle.IsSimfphyscar then
		return vehicle:EngineActive()
	else
		return vehicle:IsEngineStarted()
	end
end

function ENT:SetRunningLights(on)
	local lightlevel = TurnOnLights:GetInt()
	on = on and lightlevel ~= LIGHTLEVEL.NONE
	if on == self:GetRunningLights() then return end
	if self.v.IsScar then
	elseif self.v.IsSimfphyscar then
		self.SimfphysRunningLights = on
		self.v:SetFogLightsEnabled(not on)
		numpad.Activate(self, KEY_V, false)
		self.keystate = nil
	elseif self.v.LVS or self.v.LVS_GUNNER then
        local lh = isfunction(self.v.GetLightsHandler) and self.v:GetLightsHandler()
        if IsValid(lh) and isfunction(self.v.HasFogLights) and self.v:HasFogLights() then
            lh:SetFogActive(on)
        end
	elseif vcmod_main
	and isfunction(self.v.VC_setRunningLights) then
		self.v:VC_setRunningLights(on)
	elseif Photon2
    and isfunction(self.v.GetPhotonControllerFromAncestor) then
        local pc = self.v:GetPhotonControllerFromAncestor()
        if IsValid(pc) and on then
            pc:SetChannelMode("Vehicle.Lights", "AUTO")
        end
	end
end

function ENT:SetFogLights(on)
	local lightlevel = TurnOnLights:GetInt()
	on = on and lightlevel == LIGHTLEVEL.ALL
	if on == self:GetFogLights() then return end
	if self.v.IsScar then
	elseif self.v.IsSimfphyscar then
		self.SimfphysFogLights = on
		self.v:SetFogLightsEnabled(not on)
		numpad.Activate(self, KEY_V, false)
		self.keystate = nil
	elseif vcmod_main
	and isfunction(self.v.VC_setFogLights) then
		self.v:VC_setFogLights(on)
	end
end

local function SCAREmulateKey(self, key, state, func, ...)
	local dummy = player.GetByID(1)
	local dummyinput = dummy.ScarSpecialKeyInput
	local controller = self.v.AIController
	self.v.AIController = dummy
	dummy.ScarSpecialKeyInput = {[key] = state}
	if isfunction(func) then func(self.v, ...) end
	self.v.AIController = controller
	dummy.ScarSpecialKeyInput = dummyinput
end

function ENT:SetLights(on, highbeams)
	local lightlevel = TurnOnLights:GetInt()
	on = on and lightlevel >= LIGHTLEVEL.HEADLIGHTS
	if self.v.IsScar then
		if on == self:GetLights() then return end
		self.v.IncreaseFrontLightCol = not on
		SCAREmulateKey(self, "ToggleHeadlights", 3, self.v.UpdateLights)
	elseif self.v.IsSimfphyscar then
		local LightsActivated = self:GetLights()
		if on ~= LightsActivated then
			self.v.LightsActivated = not on
			self.v.KeyPressedTime = CurTime() - .23
			numpad.Deactivate(self, KEY_F, false)
		end
		
		if on and highbeams ~= self:GetLights(true) then
			self.v.LampsActivated = not highbeams
			self.v.KeyPressedTime = CurTime()
			if LightsActivated then
				numpad.Deactivate(self, KEY_F, false)
			else
				timer.Simple(.05, function()
					if not (IsValid(self) and IsValid(self.v)) then return end
					numpad.Deactivate(self, KEY_F, false)
				end)
			end
		end
		
		self.keystate = nil
	elseif self.v.LVS or self.v.LVS_GUNNER then
        local lh = isfunction(self.v.GetLightsHandler) and self.v:GetLightsHandler()
        if not IsValid(lh) then return end
        lh:SetActive(on)
        if highbeams and isfunction(self.v.HasHighBeams) and self.v:HasHighBeams() then
            lh:SetHighActive(on)
        end
	elseif vcmod_main
	and isfunction(self.v.VC_setHighBeams)
	and isfunction(self.v.VC_setLowBeams) then
		if on == self:GetLights(highbeams) then return end
		if highbeams then
			self.v:VC_setHighBeams(on)
		else
			self.v:VC_setLowBeams(on)
		end
	elseif Photon
	and isfunction(self.v.ELS_IllumOn)
	and isfunction(self.v.ELS_IllumOff)
	and isfunction(self.v.ELS_Illuminate) then
		if on == self:GetLights(highbeams) then return end
		if on then
			self.v:ELS_IllumOn()
		else
			self.v:ELS_IllumOff()
		end
	end
end

local SIMFPHYS = {OFF = 0, HAZARD = 1, LEFT = 2, RIGHT = 3}
function ENT:SetTurnLight(on, left)
	if on == self:GetTurnLight(left) then return end
	if self.v.IsScar then
	elseif self.v.IsSimfphyscar then
		if player.GetCount() > 0 then
			net.Start "simfphys_turnsignal"
			net.WriteEntity(self.v)
			net.WriteInt(on and (left and SIMFPHYS.LEFT or SIMFPHYS.RIGHT) or SIMFPHYS.OFF, 32)
			net.Broadcast()
		end
		
		self.TurnLightLeft = on and left
		self.TurnLightRight = on and not left
		self.HazardLights = false
	elseif vcmod_main
	and isfunction(self.v.VC_setTurnLightLeft)
	and isfunction(self.v.VC_setTurnLightRight) then
		self.v:VC_setTurnLightLeft(on and left)
		self.v:VC_setTurnLightRight(on and not left)
	elseif Photon
	and isfunction(self.v.CAR_TurnLeft)
	and isfunction(self.v.CAR_TurnRight)
	and isfunction(self.v.CAR_StopSignals) then
		if on then
			if left then
				self.v:CAR_TurnLeft(true)
			else
				self.v:CAR_TurnRight(true)
			end
		else
			self.v:CAR_StopSignals()
		end
	end
end

function ENT:SetHazardLights(on)
	if on == self:GetHazardLights() then return end
	if self.v.IsScar then
	elseif self.v.IsSimfphyscar then
		if player.GetCount() > 0 then
			net.Start "simfphys_turnsignal"
			net.WriteEntity(self.v)
			net.WriteInt(on and SIMFPHYS.HAZARD or SIMFPHYS.OFF, 32)
			net.Broadcast()
		end
		
		self.TurnLightLeft = false
		self.TurnLightRight = false
		self.HazardLights = true
	elseif vcmod_main
	and isfunction(self.v.VC_setHazardLights) then
		self.v:VC_setHazardLights(on)
	elseif Photon
	and isfunction(self.v.CAR_Hazards)
	and isfunction(self.v.CAR_StopSignals) then
		if on then
			self.v:CAR_Hazards(true)
		else
			self.v:CAR_StopSignals()
		end
	end
end

function ENT:SetELS(on)
	if on == self:GetELS() or self.v.DontHaveEMS then return end
	if self.v.IsGlideVehicle and self.v.CanSwitchSiren then
		if on then
			self.v:SetSirenState(2)
		else
			self.v:SetSirenState(0)
		end
	elseif self.v.IsScar then
		if self.v.SirenIsOn == nil then return end
		if not self.v.SirenSound then return end
		if on then self:SetHorn(false) end
		self.v.SirenIsOn = on
		self.v:SetNWBool("SirenIsOn", on)
		if on then
			self.v.SirenSound:Play()
		else
			self.v.SirenSound:Stop()	
		end
	elseif self.v.IsSimfphyscar then
		local v_list = list.Get( "simfphys_lights" )[self.v.LightsTable]
		if not v_list then self.v.DontHaveEMS = true return end
		local sounds = v_list.ems_sounds or false
		if sounds == false then self.v.DontHaveEMS = true return end

		table.remove(sounds)
		
		local numsounds = table.Count( sounds )
		local sirenNum
		
		if on then
			self.v.emson = true
			self.v:SetEMSEnabled( self.v.emson )
		else
			self.v.emson = false
			self.v:SetEMSEnabled( false )
			if self.v.ems then
				if on and not self.v.ems:IsPlaying() and not self.v.honking then
					self.v.ems:Play()
				elseif not on and self.v.ems:IsPlaying() or self.v.honking then
					self.v.ems:Stop()
				end
			end
		end
		sirenNum = math.random( 1, numsounds )
		
		if sirenNum ~= 0 and not self.v.honking then
			self.v.ems = CreateSound(self.v, sounds[sirenNum])
			self.v.ems:Play()
		end
	elseif self.v.LVS or self.v.LVS_GUNNER then
        if on then
            if isfunction(self.v.StartSiren) then
                self.v:StartSiren(false, true)
            end
        elseif isfunction(self.v.SetSirenMode) and isfunction(self.v.StopSiren) then
            self.v:SetSirenMode(-1)
            self.v:StopSiren()
        end
	elseif Photon2
    and isfunction(self.v.GetPhotonControllerFromAncestor) then
        local pc = self.v:GetPhotonControllerFromAncestor()
        if IsValid(pc) then
			local sirendata = GetPhoton2Siren(self.v)
			self.selectedsiren = self.selectedsiren or "T"..math.random(1, #sirendata.OrderedTones)
            pc:SetChannelMode("Emergency.Warning", on and "MODE3" or "OFF")
            pc:SetChannelMode("Emergency.Siren", on and self.selectedsiren or "OFF")
        end
	elseif Photon and not GetConVar("unitvehicle_vcmodelspriority"):GetBool()
	and isfunction(self.v.ELS_SirenOn)
	and isfunction(self.v.ELS_SirenOff)
	and isfunction(self.v.ELS_LightsOff) then
		if on then
			self.v:ELS_SirenOn()
		else
			self.v:ELS_SirenOff()
			self.v:ELS_LightsOff()
		end
	elseif vcmod_main and vcmod_els
	and isfunction(self.v.VC_setELSLights)
	and isfunction(self.v.VC_setELSSound) then
		self.v:VC_setELSLights(on)
		self.v:VC_setELSSound(on)
	end
end

function ENT:SetELSSound(on)
	if on == self:GetELSSound() or self.v.DontHaveEMS then return end
	if self.v.IsGlideVehicle and self.v.CanSwitchSiren then
		if on then
			self.v:SetSirenState(2)
		else
			self.v:SetSirenState(0)
		end
	elseif self.v.IsScar then
		if not self.v.SirenSound then return end
		if on then
			self.v.SirenSound:Play()
		else
			self.v.SirenSound:Stop()
		end
	elseif self.v.IsSimfphyscar then
		if self.v.ems then
			if on and not self.v.ems:IsPlaying() and not self.v.honking then
				self.v.ems:Play()
			elseif not on and self.v.ems:IsPlaying() or self.v.honking then
				self.v.ems:Stop()
			end
		end
	elseif self.v.LVS or self.v.LVS_GUNNER then
        if on then
            if isfunction(self.v.StartSiren) then
                self.v:StartSiren(false, true)
            end
        elseif isfunction(self.v.SetSirenMode) and isfunction(self.v.StopSiren) then
            self.v:SetSirenMode(-1)
            self.v:StopSiren()
        end
	elseif Photon2
    and isfunction(self.v.GetPhotonControllerFromAncestor) then
        local pc = self.v:GetPhotonControllerFromAncestor()
        if IsValid(pc) then
			local sirendata = GetPhoton2Siren(self.v)
			self.selectedsiren = self.selectedsiren or "T"..math.random(1, #sirendata.OrderedTones)
            pc:SetChannelMode("Emergency.Siren", on and self.selectedsiren or "OFF")
        end
	elseif Photon and not GetConVar("unitvehicle_vcmodelspriority"):GetBool()
	and isfunction(self.v.ELS_SirenOn)
	and isfunction(self.v.ELS_SirenOff)
	and isfunction(self.v.ELS_LightsOff) 
	and isfunction(self.v.ELS_SirenToggle) then --test
		if on then
			self.v:ELS_SirenOn()
			self.v:ELS_SirenToggle()
		else
			self.v:ELS_SirenOff()
		end

		self.v:ELS_LightsOff()
	elseif vcmod_main and vcmod_els
	and isfunction(self.v.VC_setELSSound) then
		self.v:VC_setELSSound(on)
	end
end

function ENT:ChangeELSSiren()
	if self.v.IsGlideVehicle and isfunction(CFswitchSiren) and self.v.CanSwitchSiren then
		CFswitchSiren( self.v, true )
	elseif self.v.IsSimfphyscar then
		if self.v.ems then self.v.ems:Stop() end

		local v_list = list.Get( "simfphys_lights" )[self.v.LightsTable]
		if not v_list then return end
		local sounds = v_list.ems_sounds or false
		if sounds == false then return end

		table.remove(sounds)
		
		local numsounds = table.Count( sounds )
		local sirenNum
		
		sirenNum = math.random( 1, numsounds )
		
		if sirenNum ~= 0 and not self.v.honking then
			self.v.ems = CreateSound(self.v, sounds[sirenNum])
			self.v.ems:Play()
		end
	elseif Photon2
    and isfunction(self.v.GetPhotonControllerFromAncestor) then
        local pc = self.v:GetPhotonControllerFromAncestor()
        if IsValid(pc) then
			local sirendata = GetPhoton2Siren(self.v)
			self.selectedsiren = "T"..math.random(1, #sirendata.OrderedTones)
            pc:SetChannelMode("Emergency.Siren", self.selectedsiren)
        end
	elseif Photon
	and isfunction(self.v.ELS_SirenToggle) then
		self.v:ELS_SirenToggle(math.random(1,4))
	end
end

function ENT:SetHorn(on)
	if on == self:GetHorn() then return end
	if self.v.IsGlideVehicle then
		if on then
			self.v:TriggerInput("Horn", 1)
		else
			self.v:TriggerInput("Horn", 0)
		end
	elseif self.v.IsScar then
		if on then
			self.v:HornOn()
		else
			self.v:HornOff()
		end
	elseif self.v.IsSimfphyscar and self.v.snd_horn then
		if on and not self.wrecked then
			self.v:EmitSound(self.v.snd_horn)
			self.v.honking = true
			if self.v.ems then self.v.ems:Stop() end
		else
			self.v:StopSound(self.v.snd_horn)
			self.v.honking = nil
		end
	elseif self.v.LVS or self.v.LVS_GUNNER then
        if IsValid(self.v.HornSound) then
            if on then
                self.v.HornSound:Play()
            else
                self.v.HornSound:Stop()
            end
        end
	elseif vcmod_main
	and isfunction(self.v.VC_getStates)
	and isfunction(self.v.VC_setStates) then
		local states = self.v:VC_getStates()
		if not istable(states) then return end
		states.HornOn = true
		self.v:VC_setStates(states)
	end
end

function ENT:SetLocked(locked)
	if locked == self:GetLocked() then return end
	if self.v.IsScar then
		if locked then
			self.v:Lock()
		else
			self.v:UnLock()
		end
	elseif self.v.IsSimfphyscar then
		if locked then
			self.v:Lock()
		else
			self.v:UnLock()
		end
	else
		for _, seat in pairs(self.v:GetChildren()) do -- For Sligwolf's vehicles
			if not (seat:IsVehicle() and seat.__SW_Vars) then continue end
			seat:Fire(locked and "Lock" or "Unlock")
		end
		
		if vcmod_main
		and isfunction(self.v.VC_lock)
		and isfunction(self.v.VC_unLock) then
			if locked then
				self.v:VC_lock()
			else
				self.v:VC_unLock()
			end
		else
			self.v:Fire(locked and "Lock" or "Unlock")
		end
	end
end

function ENT:SetEngineStarted(on)
	if on == self:GetEngineStarted() then return end
	if self.v.IsScar then -- SCAR automatically starts the engine.
		self:SetLocked(not on)
		self.v.AIController = on and self or nil
		if not on then self.v:TurnOffCar() end
	elseif self.v.IsSimfphyscar then
		self.v:SetActive(on)
		if on then
			self.v:StartEngine()
		else
			self.v:StopEngine()
		end
	elseif isfunction(self.v.StartEngine) then
		self.v:StartEngine(on)
	end
end

function ENT:SetHandbrake(brake)
	self.HandBrake = brake
	if self.v.IsScar then
		if brake then
			self.v:HandBrakeOn()
		else
			self.v:HandBrakeOff()
		end
	elseif self.v.IsSimfphyscar then
		self.v.PressedKeys.Space = brake
	elseif isfunction(self.v.SetHandbrake) then
		self.v:SetHandbrake(brake)
	end
end

function ENT:SetThrottle(throttle)
	self.Throttle = throttle
	if self.v.IsScar then
		if throttle > 0 then
			self.v:GoForward(throttle)
		elseif throttle < 0 then
			self.v:GoBack(-throttle)
		else
			self.v:GoNeutral()
		end
	elseif self.v.IsSimfphyscar then
		self.v.PressedKeys.W = throttle > .01
		self.v.PressedKeys.S = throttle < -.01
	elseif isfunction(self.v.SetThrottle) then
		self.v:SetThrottle(throttle)
	end
end

function ENT:SetSteering(steering)
	steering = math.Clamp(steering, -1, 1)
	self.Steering = steering
	if self.v.IsScar then
		if steering > 0 then
			self.v:TurnRight(steering)
		elseif steering < 0 then
			self.v:TurnLeft(-steering)
		else
			self.v:NotTurning()
		end
	elseif self.v.IsSimfphyscar then
		local s = self.v:GetVehicleSteer()
		self.v:PlayerSteerVehicle(self, -math.min(steering, 0), math.max(steering, 0))
		self.v.PressedKeys.A = steering < -.01 and steering < s and s < 0
		self.v.PressedKeys.D = steering > .01 and 0 < s and s < steering
	elseif isfunction(self.v.SetSteering) then
		self.v:SetSteering(steering, 0)
	end
	
	local pose = self:GetPoseParameter "vehicle_steer" or 0
	self:SetPoseParameter("vehicle_steer", pose + (steering - pose) / 10)
end
