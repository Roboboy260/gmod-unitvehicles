AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "Unit Vehicles Police Department"

-- ENT.PrintName = "Chevrolet Corvette Grand Sport (C7) Police Cruiser"
ENT.PrintName = "#uv.veh.corvette"

ENT.VehicleName = "uv_corvettec7" -- Change this to the class name of your vehicle
ENT.EntityModelName = "uv_corvettec7" -- Change this to the model name of your vehicle
ENT.GlideCategory = "unitvehiclesglide"
ENT.ChassisModel = string.format( "models/unitvehiclescars/%s/%s.mdl", ENT.VehicleName, ENT.EntityModelName )
ENT.CanSwitchSiren = true
ENT.UVVehicleModel = "policecar"

ENT.StartSound = "uvcars/shared/startup_race.mp3"
ENT.StartedSound = "uvcars/6.2lv8/started.mp3"

ENT.NitrousPower = 2.5
ENT.NitrousDepletionRate = 0.55
ENT.NitrousRegenRate = 0.2
ENT.NitrousRegenDelay = 0.6

DEFINE_BASECLASS( "base_glide_car" )

ENT.SirenTable = {
    ")uvcars/federal sig tm/emv_wail.wav",
    ")uvcars/federal sig tm/emv_yelp.wav",
    ")uvcars/federal sig tm/emv_jingle.wav",
    ")uvcars/federal sig tm/emv_scan.wav"
}

if CLIENT then

    ENT.SirenVolume = 1

    ENT.SirenLoopSound = ")uvcars/federal sig tm/emv_horn.wav"
    ENT.SirenLoopAltSound = ")uvcars/federal sig tm/emv_horn.wav"
    ENT.HornSound = ")uvcars/federal sig tm/emv_horn.wav"

    ENT.CameraOffset = Vector( -230, 0, 65 )
    
    ENT.ExhaustOffsets = {
        {
			pos = Vector(-96.66,7.86,9.12),
			ang = Angle(0,0,0),
		},
			{
			pos = Vector(-96.66,-7.86,9.12),
			ang = Angle(0,0,0),
		},
        {
			pos = Vector(-96.66,2.61,9.12),
			ang = Angle(0,0,0),
		},
        {
			pos = Vector(-96.66,-2.61,9.12),
			ang = Angle(0,0,0),
		},
    }
    
    ENT.EngineSmokeStrips = {
        { offset = Vector(96.1,0,13.38), angle = Angle(), width = 45 }
    }
    
    ENT.EngineFireOffsets = {
        { offset = Vector(52.1,0,29.64), angle = Angle() }
    }
    
    ENT.Headlights = {
        {
            offset = Vector(86,30.39,23.2),ifBodygroupId = 8, ifSubModelId = 0,
            color = Color(160,205,255)
        },
        {
            offset = Vector(86,-30.39,23.2),ifBodygroupId = 8, ifSubModelId = 0,
            color = Color(160,205,255)
        },
    }
    
    ENT.LightSprites = {
        { type = "headlight", offset = Vector(82.13,30.39,23.2), size = 30, color = Color(215,240,255),ifBodygroupId = 8, ifSubModelId = 0, dir = Vector( 1, 0, 0 ) },
        { type = "headlight", offset = Vector(82.13,-30.39,23.2), size = 30, color = Color(215,240,255),ifBodygroupId = 8, ifSubModelId = 0, dir = Vector( 1, 0, 0 ) },

        { type = "headlight", offset = Vector(20.72,35.38,40.53),color = Color(255,255,255), dir = Vector( 1, 0, 0 ),beamType = "high",size = 50 },
        { type = "headlight", offset = Vector(20.72,-35.38,40.53),color = Color(255,255,255), dir = Vector( 1, 0, 0 ),beamType = "high",size = 50 },

        { type = "taillight", offset = Vector(-93.69,27.14,32.45), size = 35, color = Color(255,0,0,50),ifBodygroupId = 7, ifSubModelId = 0, dir = Vector( -1, 0, 0 ) },
        { type = "taillight", offset = Vector(-93.69,-27.14,32.45), size = 35, color = Color(255,0,0,50),ifBodygroupId = 7, ifSubModelId = 0, dir = Vector( -1, 0, 0 ) },
        { type = "taillight", offset = Vector(-96.23,17.32,31.97), size = 30, color = Color(255,0,0,50),ifBodygroupId = 7, ifSubModelId = 0, dir = Vector( -1, 0, 0 ) },
        { type = "taillight", offset = Vector(-96.23,-17.32,31.97), size = 30, color = Color(255,0,0,50),ifBodygroupId = 7, ifSubModelId = 0, dir = Vector( -1, 0, 0 ) },

        { type = "brake", offset = Vector(-93.69,27.14,32.45), size = 35, color = Color(255,0,0,50),ifBodygroupId = 7, ifSubModelId = 0, dir = Vector( -1, 0, 0 ) },
        { type = "brake", offset = Vector(-93.69,-27.14,32.45), size = 35, color = Color(255,0,0,50),ifBodygroupId = 7, ifSubModelId = 0, dir = Vector( -1, 0, 0 ) },
        { type = "brake", offset = Vector(-96.23,17.32,31.97), size = 30, color = Color(255,0,0,50),ifBodygroupId = 7, ifSubModelId = 0, dir = Vector( -1, 0, 0 ) },
        { type = "brake", offset = Vector(-96.23,-17.32,31.97), size = 30, color = Color(255,0,0,50),ifBodygroupId = 7, ifSubModelId = 0, dir = Vector( -1, 0, 0 ) },

        { type = "reverse", offset = Vector(-95.64,18,33.83), size = 30, color = Color(255,255,255),ifBodygroupId = 7, ifSubModelId = 0, dir = Vector( -1, 0, 0 ) },
        { type = "reverse", offset = Vector(-95.64,-18,33.83), size = 30, color = Color(255,255,255),ifBodygroupId = 7, ifSubModelId = 0, dir = Vector( -1, 0, 0 ) }, 
        
        { type = "signal_left", offset = Vector(74.84,36.21,26.25), ifBodygroupId = 7, ifSubModelId = 0, dir = Vector( 1, 0, 0 ), color = Color(255, 192, 0), size = 30 },
        { type = "signal_right", offset = Vector(74.84,-36.21,26.25), ifBodygroupId = 7, ifSubModelId = 0, dir = Vector( 1, 0, 0 ), color = Color(255, 192, 0), size = 30 },

        { type = "signal_left", offset = Vector(-91.65,27.1,34.1), ifBodygroupId = 7, ifSubModelId = 0, color = Color(255, 192, 0), dir = Vector( -1, 0, 0 ), size = 30 },
        { type = "signal_right", offset = Vector(-91.65,-27.1,34.1), ifBodygroupId = 7, ifSubModelId = 0, color = Color(255, 192, 0), dir = Vector( -1, 0, 0 ), size = 30 },
    }

    ENT.SirenCycle = 0.3

    ENT.SirenLights = {

        { ifBodygroupId = 12, ifSubModelId = 0, bodygroup = 13, time = 0, duration = 0.5 },
        { ifBodygroupId = 12, ifSubModelId = 0, bodygroup = 14, time = 0.5, duration = 0.5 },

    -- WIG-WAG

        { offset = Vector(82.13,30.39,23.2), time = 0, duration = 0.5,  size = 50, color = Color(215,240,255) },
        { offset = Vector(82.13,-30.39,23.2), time = 0.5, duration = 0.5, size = 50, color = Color(215,240,255) },

	-- RED

        { offset = Vector(98.32,-13.73,12.45), ifBodygroupId = 1, ifSubModelId = 0, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(102.98,-11.58,10.64), ifBodygroupId = 1, ifSubModelId = 1, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(107.44,-9.03,8.79), ifBodygroupId = 1, ifSubModelId = 2, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
    
        { offset = Vector(-98.38,10.61,20.18), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },

        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-22.01,19.92,53.04), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-22.01,-19.92,53.04), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-22.01,14.26,53.04), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-22.01,-14.26,53.04), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-14.72,19.92,53.04), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-14.72,-19.92,53.04), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-14.72,14.26,53.04), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-14.72,-14.26,53.04), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-22.01,19.92,53.04),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-22.01,-19.92,53.04),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-14.72,19.92,53.04),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-14.72,-19.92,53.04),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },

	-- BLUE

        { offset = Vector(98.32,13.73,12.45), ifBodygroupId = 1, ifSubModelId = 0, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(100.74,15.69,11.61), ifBodygroupId = 1, ifSubModelId = 1, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(102.57,17.71,10.78), ifBodygroupId = 1, ifSubModelId = 2, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },

        { offset = Vector(-98.38,-10.61,20.18), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },

        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-22.01,8.6,53.04), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-22.01,2.91,53.04), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-22.01,-8.6,53.04), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-22.01,-2.91,53.04), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-14.72,8.6,53.04), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-14.72,2.91,53.04), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-14.72,-8.6,53.04), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-14.72,-2.91,53.04), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-22.01,0,53.04),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-14.72,0,53.04),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },

    }
    
    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "uvinterceptor" )
    end
    
    local path = string.format("models/unitvehiclescars/uv_corvettec7/", ENT.VehicleName)
    local lightsPath = path .. ""
    
    local Lights = {
        ['Off'] = {
            [20] = "",
            [19] = "",
        },
        ['On'] = {},
        ['Brake'] = {
            [20] = lightsPath .. "brakelightlit",
            [19] = lightsPath .. "brakelightlit",
        },
        ['Beams'] = {
            ['Off'] = {
                [20] = "",
                [23] = "",
                [19] = "",
            },
            [1] = {
                [20] = lightsPath .. "brakelightlit",
                [23] = lightsPath .. "lit2",
                [19] = "",
            },
            [2] = {
                [20] = lightsPath .. "brakelightlit",
                [23] = lightsPath .. "lit2",
                [19] = "",
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

        local lightbarIsEmpty = self:GetBodygroup( 12 ) == 1

        if lightbarIsEmpty then
            self:SetBodygroup( 9, 2 )
            self:SetBodygroup( 10, 2 )
        end
    end
end


if SERVER then
    
    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 4, 0, -8 ) )
    end
    
    ENT.SpawnPositionOffset = Vector( 0, 0, 20 )
    ENT.ChassisMass = 700
    ENT.IsHeavyVehicle = false
    
    ENT.BurnoutForce = 40
    ENT.UnflipForce = 20
    
    ENT.AirControlForce = Vector( 0.8, 0.6, 0.8 )
    
    ENT.AirMaxAngularVelocity = Vector( 290, 280, 290 )
    
    function ENT:GetGears()
        return {
            
            
            [-1] = 3.2,
            [0] = 0,
            [1] = 3.50,
            [2] = 2.2,
            [3] = 1.5,
            [4] = 1.15,
            [5] = 0.9,
            [6] = 0.8,
            [7] = 0.75,
            
        }
        
        
    end
    

    function ENT:CreateFeatures()
        
        self.WheelPos = {
            [1] = Vector(61,35.3,16),
            [2] = Vector(61,-35.3,16),
            [3] = Vector(-61.1,34.6,17),
            [4] = Vector(-61.1,-34.6,17)
        }
        
        local WheelToUse = string.format( "models/unitvehiclescars/%s/%s_wheel.mdl", self.VehicleName, self.EntityModelName )
        
        self:CreateSeat( Vector(-26,17,1), Angle( 0.000000, -90.000000, 5.000000 ), Vector( 0.000000,  80.000000, 10.000000 ), true )
        self:CreateSeat( Vector(-12,-17,4), Angle( 0.000000, -90.000000, 20.000000 ), Vector( 0.000000, -80.000000, 20.000000 ), true )
        
        self:SetSuspensionLength( 9 )
        self:SetSpringStrength( 800 )
        self:SetSpringDamper( 2000 )
        
        self:SetDifferentialRatio( 1.10 )
        self:SetTransmissionEfficiency( 0.90 )
        self:SetPowerDistribution( -0.90 )
        self:SetBrakePower( 3000 )
        
        self:SetMinRPM( 800 ) 
        self:SetMaxRPM( 21000 ) 
        self:SetMinRPMTorque( 5300 )
        self:SetMaxRPMTorque( 5000 )
        
        self:SetMaxSteerAngle( 45 )
        self:SetSteerConeChangeRate( 8 )
        self:SetSteerConeMaxSpeed( 1400 )
        self:SetSteerConeMaxAngle( 0.20 )
        self:SetCounterSteer ( 0.6 )
        
        self:SetForwardTractionMax( 8000 )
        self:SetForwardTractionBias( 0 )
        self:SetSideTractionMultiplier( 35 )
        self:SetSideTractionMaxAng( 30 )
        self:SetSideTractionMax( 6000 ) 
        self:SetSideTractionMin( 2500 )
        
        self:SetTurboCharged( false )
        self:SetFastTransmission( true ) 
        
        self:CreateWheel( self.WheelPos[1], {
            model = WheelToUse,
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 1.05, 1, 1.05 ),
            radius = 15
        } )
        self:CreateWheel( self.WheelPos[2], {
            model = WheelToUse,
            modelAngle = Angle( 0.000000, -90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 1.05, 1, 1.05 ),
            radius = 15
        } )
        self:CreateWheel( self.WheelPos[3], {
            model = WheelToUse,
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            modelScale = Vector( 1.15, 1, 1.05 ),
            radius = 15.8
        } )
        self:CreateWheel( self.WheelPos[4], {
            model = WheelToUse,
            modelAngle = Angle( 0.000000, -90.000000, 0.000000 ),
            modelScale = Vector( 1.15, 1, 1.05 ),
            radius = 15.8
        } )
        
    end
    
    function ENT:OnPostThink( dt, selfTbl ) --Changing submaterials/bodygroups for the entire vehicle
        BaseClass.OnPostThink( self, dt, selfTbl )

        --Hood detachment when driving at high speeds
        if self:GetVelocity():LengthSqr() > 4000000 and self:GetBodygroup( 3 ) == 2 then
            local gibmodels = {
                "models/unitvehiclescars/uv_corvettec7/hood.mdl",
            }
            timer.Simple(0, function()
                self:DetachGibs(gibmodels, true)
            end)
            self:SetBodygroup( 3, 3 )
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
        self:SetBodygroup( 12, 0 )

        self.frontdamaged = 0
        self.reardamaged = 0
        self.leftdamaged = 0
        self.rightdamaged = 0

    end

    function ENT:DetachGibs(gibtable, ishood, glasssubmaterial)
        for i = 1, #gibtable do
            local gib = ents.Create("prop_physics")
            gib:SetModel(gibtable[i])
            gib:SetPos(self:GetPos())
            gib:SetAngles(self:GetAngles())
            gib:SetColor(self:GetColor())
            gib:SetCollisionGroup(COLLISION_GROUP_WORLD)
            if glasssubmaterial then
                gib:SetSubMaterial(glasssubmaterial, "models/unitvehiclescars/shared/windowdamage1")
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
            self:SetSubMaterial(5, "models/unitvehiclescars/uv_corvettec7/skin_0dam")
        end

        if self:GetBodygroup( 12 ) != 1 then --LIGHT BAR
            local gibchance = math.random(1, 5)
            if gibchance == 1 and (lefthit or righthit) then
                self:SetBodygroup( 12, 1 )
                local gibmodels = {
                    "models/unitvehiclescars/uv_corvettec7/lightbar.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
            end
        end

        if fronthit then --FRONT
            if self.frontdamaged < 1 then
                self:SetBodygroup( 1, 1 )
                self:SetBodygroup( 2, 1 )
                self:SetBodygroup( 3, 1 )
                self.frontdamaged = 1
            elseif self.frontdamaged < 2 then
                self:SetBodygroup( 1, 2 )
                self:SetBodygroup( 2, 1 )
                self:SetBodygroup( 3, 2 )
                self:SetSubMaterial(2, "models/unitvehiclescars/shared/windowdamage")
                self.frontdamaged = 2
            elseif self.frontdamaged < 3 then
                self:SetBodygroup( 1, 3 )
                self:SetBodygroup( 2, 1 )
                self:SetBodygroup( 8, 1 )
                self:SetSubMaterial(2, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_corvettec7/frbumper.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.frontdamaged = 3
            end
        end

        if rearhit then --REAR
            if self.reardamaged < 1 then
                self:SetBodygroup( 4, 1 )
                self:SetSubMaterial(16, "models/unitvehiclescars/shared/windowdamage")
                local gibmodels = {
                    "models/unitvehiclescars/uv_corvettec7/exhaust.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.reardamaged = 1
            elseif self.reardamaged < 2 then
                self:SetBodygroup( 4, 2 )
                self:SetSubMaterial(16, "models/unitvehiclescars/shared/windowdamage1")
                self.reardamaged = 2
            elseif self.reardamaged < 3 then
                self:SetBodygroup( 4, 2 )
                self:SetBodygroup( 7, 1 )
                self:SetSubMaterial(16, "models/unitvehiclescars/shared/windowdamage1")
                self.reardamaged = 3
            elseif self.reardamaged < 4 then
                self:SetBodygroup( 4, 3 )
                self:SetBodygroup( 7, 1 )
                self:SetSubMaterial(16, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_corvettec7/trunk.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels, nil, 3)
                end)
                self.reardamaged = 4
            end
        end

        if lefthit then --LEFT
            if self.leftdamaged < 1 then
                self:SetBodygroup( 5, 1 )
                self:SetSubMaterial(3, "models/unitvehiclescars/shared/windowdamage")
                self.leftdamaged = 1
            elseif self.leftdamaged < 2 then
                self:SetBodygroup( 5, 2 )
                self:SetSubMaterial(3, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_corvettec7/mirrorleft.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.leftdamaged = 2
            elseif self.leftdamaged < 3 then
                self:SetBodygroup( 5, 3 )
                self:SetSubMaterial(3, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_corvettec7/doorleft.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels, nil, 1)
                end)
                self.leftdamaged = 3
            end
        end

        if righthit then --RIGHT
            if self.rightdamaged < 1 then
                self:SetBodygroup( 6, 1 )
                self:SetSubMaterial(4, "models/unitvehiclescars/shared/windowdamage")
                self.rightdamaged = 1
            elseif self.rightdamaged < 2 then
                self:SetBodygroup( 6, 2 )
                self:SetSubMaterial(4, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_corvettec7/mirrorright.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.rightdamaged = 2
            elseif self.rightdamaged < 3 then
                self:SetBodygroup( 6, 3 )
                self:SetSubMaterial(3, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_corvettec7/doorright.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels, nil, 1)
                end)
                self.rightdamaged = 3
            end
        end

    end
end

local spawnColors = {
    Color(255, 255, 255),
}

function ENT:GetSpawnColor()
    return spawnColors[math.random(#spawnColors)]
end