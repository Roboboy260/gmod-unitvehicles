AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "Unit Vehicles Police Department"

-- ENT.PrintName = "Ford Police Interceptor Utility 2011 Police Cruiser"
ENT.PrintName = "#uv.veh.explorer"

ENT.GlideCategory = "unitvehiclesglide"
ENT.ChassisModel = "models/unitvehiclescars/uv_fordexplorer/uv_fordexplorer.mdl"
ENT.CanSwitchSiren = true
ENT.UVVehicleModel = "policecar"

ENT.StartSound = "uvcars/shared/startup_suv.mp3"

ENT.NitrousPower = 2.5
ENT.NitrousDepletionRate = 0.55
ENT.NitrousRegenRate = 0.2
ENT.NitrousRegenDelay = 0.6

DEFINE_BASECLASS( "base_glide_car" )

ENT.SirenTable = {
    ")uvcars/federal sig ss/emv_wail.wav",
    ")uvcars/federal sig ss/emv_yelp.wav",
    ")uvcars/federal sig ss/emv_priority.wav",
    ")uvcars/federal sig ss/emv_hilo.wav"
}

if CLIENT then

    ENT.CameraOffset = Vector( -250, 0, 75 )
	ENT.CameraCenterOffset = Vector( 0, 0, 0 )

    ENT.SirenVolume = 1

    ENT.SirenLoopSound = ")uvcars/federal sig ss/emv_wail.wav"
    ENT.SirenLoopAltSound = ")uvcars/federal sig ss/emv_horn.wav"
    ENT.HornSound = ")uvcars/federal sig ss/emv_horn.wav"

    ENT.ExhaustOffsets = {
        {
            pos = Vector(-104.82,24.22,6.18)
        },
        {
            pos = Vector(-104.82,-24.22,6.18)
        },
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector(109.91,0,9.79), angle = Angle(0,0,0), width = 40 },
    }

    ENT.EngineFireOffsets = {
        { offset = Vector(84.69,0,35.64), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector(104,30.14,29.56),
            color = Color(255,255,255)
        },
        {
            offset = Vector(104,-30.14,29.56),
            color = Color(255,255,255)
        },
    }


    ENT.LightSprites = {

        { type = "brake", offset = Vector(-96.72,0,62.43), ifBodygroupId = 7, ifSubModelId = 0, size = 50, color = Color(255,0,0,255), dir = Vector( -1, 0, 0 ) },
        { type = "brake", offset = Vector(-96.43,0.01,63.71), ifBodygroupId = 7, ifSubModelId = 1, size = 50, color = Color(255,0,0,255), dir = Vector( -1, 0, 0 ) },
        { type = "brake", offset = Vector(-96.43,0.01,69.62), ifBodygroupId = 7, ifSubModelId = 2, size = 50, color = Color(255,0,0,255), dir = Vector( -1, 0, 0 ) },

        { type = "brake", offset = Vector(-101.48,34.27,34.81), size = 50, color = Color(255,0,0,50), dir = Vector( -1, 0.5, 0 ) },
        { type = "brake", offset = Vector(-101.48,-34.27,34.81), size = 50, color = Color(255,0,0,50), dir = Vector( -1, -0.5, 0 ) },
        { type = "taillight", offset = Vector(-101.48,34.27,34.81), size = 50, color = Color(255,0,0,50), dir = Vector( -1, 0.5, 0 ) },
        { type = "taillight", offset = Vector(-101.48,-34.27,34.81), size = 50, color = Color(255,0,0,50), dir = Vector( -1, -0.5, 0 ) },
        { type = "headlight", offset = Vector(99.21,30.14,29.56), size = 40, color = Color(255,255,255), dir = Vector( 1, 0, 0 ) },
        { type = "headlight", offset = Vector(99.21,-30.14,29.56), size = 40, color = Color(255,255,255), dir = Vector( 1, 0, 0 ) },
        { type = "headlight", offset = Vector(45.51,38.38,58.18),color = Color(255,255,255), dir = Vector( 1, 0, 0 ),beamType = "high",size = 50 },
        { type = "headlight", offset = Vector(45.51,-38.38,58.18),color = Color(255,255,255), dir = Vector( 1, 0, 0 ),beamType = "high",size = 50 },
        { type = "reverse", offset = Vector(-99.94,35.2,40.17), dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "reverse", offset = Vector(-99.94,-35.2,40.17), dir = Vector( -1, 0, 0 ),size = 30 },

		{ type = "signal_left", offset = Vector( 95.88,33.1,34.92 ), dir = Vector( 1, 0.5, 0 ), color = Color(255, 192, 0),size = 25 },
        { type = "signal_right", offset = Vector( 95.88,-33.1,34.92 ), dir = Vector( 1, -0.5, 0 ), color = Color(255, 192, 0),size = 25 },

        { type = "signal_left", offset = Vector(-101.48,34.27,34.81), size = 30, color = Color(255, 192, 0), dir = Vector( -1, 0, 0 ) },
        { type = "signal_right", offset = Vector(-101.48,-34.27,34.81), size = 30, color = Color(255, 192, 0), dir = Vector( -1, 0, 0 ) },

        { type = "signal_left", offset = Vector(36.27,49.84,44.45), size = 30, color = Color(255, 192, 0), dir = Vector( 1, 1, 0 ) },
        { type = "signal_right", offset = Vector(36.27,-49.84,44.45), size = 30, color = Color(255, 192, 0), dir = Vector( 1, -1, 0 ) },

    }

    ENT.SirenCycle = 0.3

    ENT.SirenLights = {

        { bodygroup = 9, time = 0, duration = 0.5 },
        { bodygroup = 10, time = 0.5, duration = 0.5 },

        -- WIG-WAG

        { offset = Vector(99.21,30.14,29.56), time = 0, duration = 0.5, size = 50, color = Color(255,255,255) },
        { offset = Vector(99.21,-30.14,29.56), time = 0.5, duration = 0.5, size = 50, color = Color(255,255,255) },

        -- RED

        { offset = Vector(-16.2,22.25,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { offset = Vector(-16.2,-22.25,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },

        { offset = Vector(-8.54,22.25,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { offset = Vector(-8.54,-22.25,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },

        { offset = Vector(-76.81,36.15,49.83), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },

        { offset = Vector(-16.2,22.25,71.78), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-16.2,15.92,71.78), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },

        { offset = Vector(-16.2,-22.25,71.78), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-16.2,-15.92,71.78), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },

        { offset = Vector(-8.54,22.25,71.78), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-8.54,15.92,71.78), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },

        { offset = Vector(-8.54,-22.25,71.78), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-8.54,-15.92,71.78), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },

        { offset = Vector(117.61,-9.75,24.04), ifBodygroupId = 1, ifSubModelId = 0, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(117.61,-9.75,24.04), ifBodygroupId = 1, ifSubModelId = 1, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(118.9,-8.91,24.17), ifBodygroupId = 1, ifSubModelId = 2, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },

        { offset = Vector(115.44,-19.27,25.81), ifBodygroupId = 1, ifSubModelId = 0, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(115.44,-19.27,25.81), ifBodygroupId = 1, ifSubModelId = 1, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(116.98,-18.39,26.1), ifBodygroupId = 1, ifSubModelId = 2, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },

        -- BLUE

        { offset = Vector(-16.2,0,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },
        { offset = Vector(-8.54,0,71.78),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },

        { offset = Vector(-76.81,-36.15,49.83), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },

        { offset = Vector(-16.2,9.53,71.78), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-16.2,3.24,71.78), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },

        { offset = Vector(-8.54,9.53,71.78), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-8.54,3.24,71.78), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },

        { offset = Vector(-16.2,-9.53,71.78), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-16.2,-3.24,71.78), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },

        { offset = Vector(-8.54,-9.53,71.78), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-8.54,-3.24,71.78), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },

        { offset = Vector(117.61,9.75,24.04), ifBodygroupId = 1, ifSubModelId = 0, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(118.96,9.06,24.02), ifBodygroupId = 1, ifSubModelId = 1, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(119.83,8.27,24.07), ifBodygroupId = 1, ifSubModelId = 2, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },

        { offset = Vector(115.44,19.27,25.81), ifBodygroupId = 1, ifSubModelId = 0, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(116.89,18.16,26), ifBodygroupId = 1, ifSubModelId = 1, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(118.57,17.53,25.99), ifBodygroupId = 1, ifSubModelId = 2, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
}
     
    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "uvsupport" )
    end


    local path = string.format("models/unitvehiclescars/uv_fordexplorer/", ENT.VehicleName)
    local lightsPath = path .. "lights/"
    
    local Lights = {
        ['Off'] = {
            [20] = "",
        },
        ['On'] = {},
        ['Brake'] = {
            [20] = lightsPath .. "beam",
        },
        ['Beams'] = {
            ['Off'] = {
                [20] = "",
                [19] = "",
            },
            [1] = {
                [20] = lightsPath .. "beam",
                [19] = lightsPath .. "litfull",
            },
            [2] = {
                [20] = lightsPath .. "beam",
                [19] = lightsPath .. "litfull",
            }
        }
    }

    function ENT:OnUpdateMisc()
        local eo, hl, br = self:IsEngineOn(), self:GetHeadlightState(), self:IsBraking()
        BaseClass.OnUpdateMisc(self)
        
        local submaterials = {}
        
        for bodyId, subMaterial in pairs(Lights['On']) do
            submaterials[bodyId] = subMaterial
        end
        
        if hl >= 1 and Lights['Beams'][hl] then
            for bodyId, subMaterial in pairs(Lights['Beams'][hl]) do
                submaterials[bodyId] = subMaterial
            end
        else
            for bodyId in pairs(Lights['Beams']['Off']) do
                submaterials[bodyId] = ""
            end
        end
        
        for bodyId, subMaterial in pairs(Lights['Brake']) do
            submaterials[bodyId] = ((eo and br) and subMaterial) or submaterials[bodyId]
        end

        for bodyId, subMaterial in pairs(Lights['Off']) do
            submaterials[bodyId] = ((not eo) and subMaterial) or submaterials[bodyId]
        end
        
        for bodyId, subMaterial in pairs(submaterials) do
            self:SetSubMaterial(bodyId, subMaterial)
        end
    end
end

if SERVER then

    ENT.SpawnPositionOffset = Vector( 0, 0, 20 )
    ENT.ChassisMass = 1000

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 7, 0, -8 ) )
    end
    function ENT:GetGears()
        return {
		
		
            [-1] = 3,
            [0] = 0,
            [1] = 6.9,
            [2] = 4.8,
            [3] = 3.6,
            [4] = 2.8,
            [5] = 2,
            [6] = 1.4,
			
        }
		
		
    end

    function ENT:CreateFeatures()

        self:CreateSeat( Vector(-4,21.5,14), Angle( 0.000000, -90.000000, 2.000000 ), Vector( 0.000000,  80.000000, 10.000000 ), true )
        self:CreateSeat( Vector(15,-19.5,15), Angle( 0.000000, -90.000000, 15.000000 ), Vector( 0.000000, 80.000000, 10.000000 ), true )
        self:CreateSeat( Vector(-30,-19,15), Angle( 0.000000, -90.000000, 15.000000 ), Vector( 0.000000, -80.000000, 10.000000 ), true )
        self:CreateSeat( Vector(-30,19,15), Angle( 0.000000, -90.000000, 15.000000 ), Vector( 0.000000, -80.000000, 10.000000 ), true )

		self:SetSpringStrength( 1200 )
        self:SetSpringDamper( 3000 )
        self:SetSuspensionLength ( 7 )

        self:SetDifferentialRatio( 1.00 )
        self:SetTransmissionEfficiency( 0.80 )
        self:SetPowerDistribution( 0 )
        self:SetBrakePower( 4000 )

        self:SetMinRPM( 700 ) 
        self:SetMaxRPM( 22000 ) 
        self:SetMinRPMTorque( 5200 )
        self:SetMaxRPMTorque( 4800 )

        self:SetMaxSteerAngle( 40 )
        self:SetSteerConeChangeRate( 7 )
        self:SetSteerConeMaxSpeed( 1400 )
        self:SetSteerConeMaxAngle( 0.20 )
		self:SetCounterSteer ( 0.8 )

        self:SetForwardTractionMax( 6000 )
        self:SetForwardTractionBias( 0 )
        self:SetSideTractionMultiplier( 20 )
        self:SetSideTractionMaxAng( 25 )
        self:SetSideTractionMax( 4000 ) 
        self:SetSideTractionMin( 1500 )

		self:SetTurboCharged( true )
		self:SetFastTransmission( true ) 

        self:CreateWheel( Vector( 69.0, 38.5, 11.5 ), {
            model = "models/unitvehiclescars/uv_fordcrownvic/uv_fordcrownvic_wheel.mdl",
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 1, 1, 1 ),
			radius = 17.0
        } )
        self:CreateWheel( Vector( 69.0, -38.5, 11.5 ), {
            model = "models/unitvehiclescars/uv_fordcrownvic/uv_fordcrownvic_wheel.mdl",
            modelAngle = Angle( -0.000000, -90.000000, -0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 1, 1, 1 ),
			radius = 17.0
        } )
        self:CreateWheel( Vector( -60, 38.5, 11.5 ), {
            model = "models/unitvehiclescars/uv_fordcrownvic/uv_fordcrownvic_wheel.mdl",
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            modelScale = Vector( 1, 1, 1 ),
			radius = 17.0
        } )
        self:CreateWheel( Vector( -60, -38.5, 11.5 ), {
            model = "models/unitvehiclescars/uv_fordcrownvic/uv_fordcrownvic_wheel.mdl",
            modelAngle = Angle( -0.000000, -90.000000, -0.000000 ),
            modelScale = Vector( 1, 1, 1 ),
			radius = 17.0
        } )

    end

    function ENT:OnPostThink( dt, selfTbl ) --Changing submaterials/bodygroups for the entire vehicle
        BaseClass.OnPostThink( self, dt, selfTbl )

        --Hood detachment when driving at high speeds
        if self:GetVelocity():LengthSqr() > 4000000 and self:GetBodygroup( 2 ) == 2 then
            local gibmodels = {
                "models/unitvehiclescars/uv_fordexplorer/hood.mdl",
            }
            timer.Simple(0, function()
                self:DetachGibs(gibmodels, true)
            end)
            self:SetBodygroup( 2, 3 )
        end
    end

    function ENT:Repair()
        BaseClass.Repair(self) --Overrides the repair function

        self:SetIsEngineOnFire( false )
        self:SetChassisHealth( self.MaxChassisHealth )
        self:SetEngineHealth( 1.0 )
        self:UpdateHealthOutputs()

        --reset bodygroups/submaterials
        self:SetSubMaterial()
        self:SetBodygroup( 1, 0 )
        self:SetBodygroup( 2, 0 )
        self:SetBodygroup( 3, 0 )
        self:SetBodygroup( 4, 0 )
        self:SetBodygroup( 5, 0 )
        self:SetBodygroup( 6, 0 )
        self:SetBodygroup( 7, 0 )
        self:SetBodygroup( 8, 0 )

        self.frontdamaged = 0
        self.reardamaged = 0
        self.leftdamaged = 0
        self.rightdamaged = 0

    end

    function ENT:DetachGibs(gibtable, ishood)
        for i = 1, #gibtable do
            local gib = ents.Create("prop_physics")
            gib:SetModel(gibtable[i])
            gib:SetPos(self:GetPos())
            gib:SetAngles(self:GetAngles())
            gib:SetColor(self:GetColor())
            gib:SetCollisionGroup(COLLISION_GROUP_WORLD)
            if gib:GetModel() == "models/unitvehiclescars/uv_fordexplorer/trunk.mdl" then
                gib:SetSubMaterial(7, "models/unitvehiclescars/shared/windowdamage1")
            end
            gib:Spawn()
            if IsValid(gib:GetPhysicsObject()) then
                if ishood then
                    gib:GetPhysicsObject():SetVelocity((self:GetVelocity()*0.75) + self:GetUp() * 500)
                    gib:GetPhysicsObject():SetAngleVelocity(VectorRand() * 500)
                else
                    gib:GetPhysicsObject():SetVelocity(self:GetVelocity())
                end
            end
            local giblifetime = GetConVar("glide_bodygroupdamage_giblifetime"):GetInt() or 15
            timer.Simple(giblifetime, function() --Adjust the convar "glide_bodygroupdamage_giblifetime"
                if IsValid(gib) then
                    gib:Remove()
                end
            end)
        end
    end

    function ENT:UVVehicleInitialize()
        self:SetBodygroup( 11, 1 )
    end

    function ENT:UVPhysicsCollide(data)

        local velocityChange = data.OurNewVelocity - data.OurOldVelocity
        local surfaceNormal = data.HitNormal

        local speed = velocityChange:Length()

        if speed < 500 then return end --Minimum speed to trigger, you can adjust the speed here

        local hitpos = data.HitPos
        local forward = self:GetForward()
        local dist = data.HitPos - self:WorldSpaceCenter()
        local vect = dist:GetNormalized()
        local right = (vect:Cross(forward)).z
        local forwarddot = dist:Dot(forward)

        local fronthit = forwarddot > 0 and right > -0.5 and right < 0.5
        local rearhit = forwarddot < 0 and right > -0.5 and right < 0.5
        local lefthit = right < -0.5
        local righthit = right > 0.5
        
        self.frontdamaged = self.frontdamaged or 0
        self.reardamaged = self.reardamaged or 0
        self.leftdamaged = self.leftdamaged or 0
        self.rightdamaged = self.rightdamaged or 0

        local enginehealth = self:GetEngineHealth()

        if enginehealth < .5 then --BASE
            self:SetSubMaterial(12, "models/unitvehiclescars/shared/windowdamage")
            self:SetSubMaterial(7, "models/unitvehiclescars/uv_fordexplorer/skin_0dam")
            if enginehealth < .25 then
                self:SetSubMaterial(12, "models/unitvehiclescars/shared/windowdamage1")
            end
        end

        if fronthit then --FRONT
            if speed < 3000 and self.frontdamaged < 1 then
                self:SetBodygroup( 1, 1 )
                self:SetBodygroup( 2, 1 )
                self.frontdamaged = 1
            elseif self.frontdamaged < 2 then
                self:SetBodygroup( 1, 2 )
                self:SetBodygroup( 2, 2 )
                self.frontdamaged = 2
            elseif self.frontdamaged < 3 then
                self:SetBodygroup( 1, 3 )
                local gibmodels = {
                    "models/unitvehiclescars/uv_fordexplorer/frbumper.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.frontdamaged = 3
            elseif self.frontdamaged < 4 then
                self:SetBodygroup( 1, 3 )
                self.frontdamaged = 4
            end
        end

        if rearhit then --REAR
            if self.reardamaged < 1 then
                self:SetBodygroup( 7, 1 )
                self:SetBodygroup( 8, 1 )
                self.reardamaged = 1
            elseif self.reardamaged < 2 then
                self:SetBodygroup( 7, 2 )
                self:SetBodygroup( 8, 2 )
                self.reardamaged = 2
            elseif self.reardamaged < 3 then
                self:SetBodygroup( 7, 2 )
                self:SetBodygroup( 8, 3 )
                local gibmodels = {
                    "models/unitvehiclescars/uv_fordexplorer/rebumper.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.reardamaged = 3
            elseif self.reardamaged < 4 then
                self:SetBodygroup( 7, 3 )
                self:SetBodygroup( 8, 3 )
                local gibmodels = {
                    "models/unitvehiclescars/uv_fordexplorer/trunk.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.reardamaged = 4
            end
        end

        if lefthit then --LEFT
            if self.leftdamaged < 1 then
                self:SetBodygroup( 3, 1 )
                self:SetBodygroup( 4, 1 )
                self.leftdamaged = 1
            elseif self.leftdamaged < 2 then
                self:SetBodygroup( 3, 1 )
                self:SetBodygroup( 4, 1 )
                self.leftdamaged = 2
            end
        end

        if righthit then --RIGHT
            if self.rightdamaged < 1 then
                self:SetBodygroup( 5, 1 )
                self:SetBodygroup( 6, 1 )
                self.rightdamaged = 1
            elseif self.rightdamaged < 2 then
                self:SetBodygroup( 5, 1 )
                self:SetBodygroup( 6, 1 )
                self.rightdamaged = 2
            end
        end


    end
end

function ENT:GetSpawnColor()
    return Color( 255, 255, 255 )
end

