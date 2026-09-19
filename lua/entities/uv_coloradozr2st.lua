AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "Unit Vehicles Police Department"

-- ENT.PrintName = "Chevrolet Colorado ZR2 2017 Police Cruiser"
ENT.PrintName = "#uv.veh.zr2.st"

ENT.GlideCategory = "unitvehiclesglide"
ENT.ChassisModel = "models/unitvehiclescars/uv_coloradozr2/uv_coloradozr2.mdl"
ENT.CanSwitchSiren = true
ENT.UVVehicleModel = "policecar"

ENT.StartSound = "uvcars/shared/startup_offroad.mp3"

ENT.NitrousPower = 2.5
ENT.NitrousDepletionRate = 0.55
ENT.NitrousRegenRate = 0.2
ENT.NitrousRegenDelay = 0.6

DEFINE_BASECLASS( "base_glide_car" )

ENT.SirenTable = {
    ")uvcars/federal sig rumbler/emv_wail.wav",
    ")uvcars/federal sig rumbler/emv_yelp.wav",
    ")uvcars/federal sig rumbler/emv_priority.wav",
    ")uvcars/federal sig rumbler/emv_hilo.wav",
}

if CLIENT then

    ENT.SirenVolume = 1

    ENT.SirenLoopSound = ")uvcars/federal sig rumbler/emv_wail.wav"
    ENT.SirenLoopAltSound = ")uvcars/federal sig rumbler/emv_horn.wav"
    ENT.HornSound = ")uvcars/federal sig rumbler/emv_horn.wav"

    ENT.CameraOffset = Vector( -260, 0, 70 )

    ENT.ExhaustPopSound = ""

    ENT.ExhaustOffsets = {
        {
            pos = Vector(-115.87,-34.27,3.04),ifBodygroupId = 3, ifSubModelId = 0,
	    	ang = Angle(180,-140,0),
	    },
        {
            pos = Vector(-84.51,-16.55,4.47),ifBodygroupId = 3, ifSubModelId = 1,
	    	ang = Angle(180,-160,0),
	    },
        {
            pos = Vector(-84.51,-16.55,4.47),ifBodygroupId = 3, ifSubModelId = 2,
	    	ang = Angle(180,-160,0),
	    },
        {
            pos = Vector(-84.51,-16.55,4.47),ifBodygroupId = 3, ifSubModelId = 3,
	    	ang = Angle(180,-160,0),
	    },
        {
            pos = Vector(-84.51,-16.55,4.47),ifBodygroupId = 3, ifSubModelId = 4,
	    	ang = Angle(180,-160,0),
	    },
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector(103.29,0,23.68), angle = Angle(), width = 30 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector(75.98,0,37.7), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector(104.45,33.79,29.08),
            color = Color(255,255,255)
        },
        {
            offset = Vector(104.45,-33.79,29.08),
             color = Color(255,255,255)
        },
    }

    ENT.LightSprites = {

        { type = "headlight", offset = Vector( 100.45,33.79,29.08 ),color = Color(255,255,255), dir = Vector( 1, 0, 0 ),size = 40 },
        { type = "headlight", offset = Vector( 100.45,-33.79,29.08 ),color = Color(255,255,255), dir = Vector( 1, 0, 0 ),size = 40 },
        { type = "headlight", offset = Vector(53.65,35.92,53.8),color = Color(255,255,255), dir = Vector( 1, 0, 0 ),beamType = "high",size = 50 },

        { type = "taillight", offset = Vector(-118.22,34.98,29.74),color = Color(255,0,0,55),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "taillight", offset = Vector(-118.22,-34.98,29.74),color = Color(255,0,0,55),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "taillight", offset = Vector(-118.22,34.78,39.41),color = Color(255,0,0,55),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "taillight", offset = Vector(-118.22,-34.78,39.41),color = Color(255,0,0,55),dir = Vector( -1, 0, 0 ),size = 30 },

        { type = "brake", offset = Vector(-30.51,0,63.28),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 40 },
        { type = "brake", offset = Vector(-118.22,34.98,29.74),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "brake", offset = Vector(-118.22,-34.98,29.74),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "brake", offset = Vector(-118.22,34.78,39.41),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "brake", offset = Vector(-118.22,-34.78,39.41),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },

        { type = "reverse", offset = Vector(-120.49,35.11,34.48), dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "reverse", offset = Vector(-120.49,-35.11,34.48), dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "reverse", offset = Vector(-29.76,4.91,63.51), dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "reverse", offset = Vector(-29.76,-4.91,63.51), dir = Vector( -1, 0, 0 ),size = 30 },

        { type = "signal_left", offset = Vector(-118.22,34.98,29.74),color = Color(255,0,0),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "signal_right", offset = Vector(-118.22,-34.98,29.74),color = Color(255,0,0),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "signal_left", offset = Vector(-118.22,34.78,39.41),color = Color(255,0,0),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "signal_right", offset = Vector(-118.22,-34.78,39.41),color = Color(255,0,0),dir = Vector( -1, 0, 0 ),size = 30 },
        
        { type = "signal_left", offset = Vector(103.89,27.33,24.48),color = Color(255, 192, 0),dir = Vector( 1, 0, 0 ),size = 30 },
        { type = "signal_right", offset = Vector(103.89,-27.33,24.48),color = Color(255, 192, 0),dir = Vector( 1, 0, 0 ),size = 30 },

    }

    ENT.SirenCycle = 0.3

    ENT.SirenLights = {

        { ifBodygroupId = 12, ifSubModelId = 0, bodygroup = 10, time = 0.5, duration = 0.5 },
        { ifBodygroupId = 12, ifSubModelId = 0, bodygroup = 11, time = 0, duration = 0.5 },

    -- WIG-WAG

        { offset = Vector( 100.45,33.79,29.08 ), color = Color(255,255,255), time = 0, duration = 0.5, size = 50 },
        { offset = Vector( 100.45,-33.79,29.08 ), color = Color(255,255,255), time = 0.5, duration = 0.5, size = 50 },

	-- RED

        { offset = Vector(113.85,-14.53,27), ifBodygroupId = 1, ifSubModelId = 0, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(116.15,-14.46,24.89), ifBodygroupId = 1, ifSubModelId = 1, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(118.52,-14.13,22.5), ifBodygroupId = 1, ifSubModelId = 2, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },

        { offset = Vector(-123.77,17.56,35.8), ifBodygroupId = 3, ifSubModelId = 0, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-124.91,17.56,35.31), ifBodygroupId = 3, ifSubModelId = 1, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-126.1,17.56,34.69), ifBodygroupId = 3, ifSubModelId = 2, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-126.1,17.56,34.69), ifBodygroupId = 3, ifSubModelId = 3, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
    
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(30.76,22.77,57.14), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(31.78,18.36,57.14), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(30.76,-22.77,57.14), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(31.78,-18.36,57.14), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-26.81,20.79,58.19), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-27.74,16.38,58.19), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-26.81,-20.79,58.19), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-27.74,-16.38,58.19), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(31.78,18.36,57.14), dir = Vector( 1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(31.78,-18.36,57.14), dir = Vector( 1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-26.81,20.79,58.19), dir = Vector( -1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-26.81,-20.79,58.19), dir = Vector( -1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },

	-- BLUE

        { offset = Vector(113.85,14.53,27), ifBodygroupId = 1, ifSubModelId = 0, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(114.88,14.82,26.23), ifBodygroupId = 1, ifSubModelId = 1, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(116.15,14.98,25.12), ifBodygroupId = 1, ifSubModelId = 2, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },

        { offset = Vector(-123.77,-17.56,35.8), ifBodygroupId = 3, ifSubModelId = 0, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-124.91,-17.56,35.31), ifBodygroupId = 3, ifSubModelId = 1, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-126.1,-17.56,34.69), ifBodygroupId = 3, ifSubModelId = 2, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-126.1,-17.56,34.69), ifBodygroupId = 3, ifSubModelId = 3, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },

        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(32.43,13.93,57.14), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(33.15,9.45,57.14), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(32.43,-13.93,57.14), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(33.15,-9.45,57.14), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-28.42,11.97,58.19), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-29.04,7.54,58.19), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-28.42,-11.97,58.19), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-29.04,-7.54,58.19), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(33.15,9.45,57.14), dir = Vector( 1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(33.15,-9.45,57.14), dir = Vector( 1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-29.04,7.54,58.19), dir = Vector( -1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },
        { ifBodygroupId = 12, ifSubModelId = 0, offset = Vector(-29.04,-7.54,58.19), dir = Vector( -1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },

    }

    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "uvspecial" )
    end

    local path = string.format("models/unitvehiclescars/uv_coloradozr2/", ENT.VehicleName)
    local lightsPath = path .. ""
    
    local Lights = {
        ['Off'] = {
            [1] = "",
            [10] = lightsPath .. "blackscreen",
        },
        ['On'] = {
            [1] = "",
            [10] = "",
        },
        ['Brake'] = {
            [1] = lightsPath .. "brakelightlit",
        },
        ['Beams'] = {
            ['Off'] = {
                [17] = "",
                [1] = "",
            },
            [1] = {
                [17] = lightsPath .. "lit",
                [1] = lightsPath .. "brakelightlit",
            },
            [2] = {
                [17] = lightsPath .. "lit",
                [1] = lightsPath .. "brakelightlit",
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

        local lightbarIsEmpty = self:GetBodygroup( 9 ) == 1

        if lightbarIsEmpty then
            self:SetBodygroup( 6, 2 )
            self:SetBodygroup( 7, 2 )
        end

        local visorIsEmpty = self:GetBodygroup( 12 ) == 1

        if visorIsEmpty then
            self:SetBodygroup( 10, 2 )
            self:SetBodygroup( 11, 2 )
        end
    end
end

if SERVER then

    ENT.ExplosionBodygroupGibs = {
        {
            bodygroup = 2,
            detachedAt = 3,
            model = "models/unitvehiclescars/uv_coloradozr2/hood.mdl",
        },
        {
            bodygroup = 9,
            detachedAt = 1,
            model = "models/unitvehiclescars/uv_coloradozr2/lightbar.mdl",
        },
        {
            bodygroup = 1,
            detachedAt = 3,
            model = "models/unitvehiclescars/uv_coloradozr2/frbumper.mdl",
        },
        {
            bodygroup = 3,
            detachedAt = 1,
            model = "models/unitvehiclescars/uv_coloradozr2/exhaust.mdl",
        },
        {
            bodygroup = 3,
            detachedAt = 3,
            model = "models/unitvehiclescars/uv_coloradozr2/rebumper.mdl",
        },
        {
            bodygroup = 3,
            detachedAt = 4,
            model = "models/unitvehiclescars/uv_coloradozr2/trunk.mdl",
        },
        {
            bodygroup = 4,
            detachedAt = 2,
            model = "models/unitvehiclescars/uv_coloradozr2/mirrorleft.mdl",
        },
        {
            bodygroup = 4,
            detachedAt = 3,
            model = "models/unitvehiclescars/uv_coloradozr2/doorleft.mdl",
        },
        {
            bodygroup = 4,
            detachedAt = 4,
            model = "models/unitvehiclescars/uv_coloradozr2/skirtleft.mdl",
        },
        {
            bodygroup = 5,
            detachedAt = 2,
            model = "models/unitvehiclescars/uv_coloradozr2/mirrorright.mdl",
        },
        {
            bodygroup = 5,
            detachedAt = 3,
            model = "models/unitvehiclescars/uv_coloradozr2/doorright.mdl",
        },
        {
            bodygroup = 5,
            detachedAt = 4,
            model = "models/unitvehiclescars/uv_coloradozr2/skirtright.mdl",
        },
    }

    ENT.ExplosionDamageBodygroups = {
        [1] = 3,
        [2] = 3,
        [3] = 4,
        [4] = 4,
        [5] = 4,
        [6] = 2,
        [7] = 2,
        [9] = 1,
        [10] = 0,
        [11] = 0,
        [12] = 0,
    }

    ENT.ExplosionDamagedSubMaterials = {
        [5] = "models/unitvehiclescars/uv_coloradozr2/skin_0dam",
        [14] = "models/unitvehiclescars/shared/windowdamage1",
        [15] = "models/unitvehiclescars/shared/windowdamage1",
        [11] = "models/unitvehiclescars/shared/windowdamage1",
        [12] = "models/unitvehiclescars/shared/windowdamage1",
    }

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 11, 0, -10 ) )
    end

    ENT.SpawnPositionOffset = Vector( 0, 0, 20 )
    ENT.ChassisMass = 1395
    ENT.IsHeavyVehicle = true

    ENT.BurnoutForce = 50
    ENT.UnflipForce = 20

    ENT.AirControlForce = Vector( 0.4, 0.2, 0.4 )

    ENT.AirMaxAngularVelocity = Vector( 290, 280, 290 )

    function ENT:GetGears()
        return {
		
		
            [-1] = 3.5,
            [0] = 0,
            [1] = 3.6,
            [2] = 3.0,
            [3] = 2.5,
            [4] = 2.0,
            [5] = 1.5,
            [6] = 1.1,

			
        }
		
		
    end

    function ENT:CreateFeatures()

        self:CreateSeat( Vector(0,17,11.5), Angle( 0.000000, -90.000000, 2.000000 ), Vector( 0.000000,  80.000000, 10.000000 ), true )
        self:CreateSeat( Vector(13,-17,13), Angle( 0.000000, -90.000000, 15.000000 ), Vector( 0.000000, -80.000000, 10.000000 ), true )

        self:SetSuspensionLength( 11 )
        self:SetSpringStrength( 1300 )
        self:SetSpringDamper( 3000 )

        self:SetDifferentialRatio( 1.0 )
        self:SetTransmissionEfficiency( 1 )
        self:SetPowerDistribution( -0.25 )
        self:SetBrakePower( 5000 )

        self:SetMinRPM( 800 ) 
        self:SetMaxRPM( 22500 ) 
        self:SetMinRPMTorque( 7200 )
        self:SetMaxRPMTorque( 7600 )

        self:SetMaxSteerAngle( 50 )
        self:SetSteerConeChangeRate( 8 )
        self:SetSteerConeMaxSpeed( 1500 )
        self:SetSteerConeMaxAngle( 0.25 )
		self:SetCounterSteer ( 0.6 )

        self:SetForwardTractionMax( 10000 )
        self:SetForwardTractionBias( 0 )
        self:SetSideTractionMultiplier( 40 )
        self:SetSideTractionMaxAng( 30 )
        self:SetSideTractionMax( 7000 ) 
        self:SetSideTractionMin( 3500 )

		self:SetTurboCharged( true )
		self:SetFastTransmission( true ) 

        self:CreateWheel( Vector(74,38,7.85), {
            model = "models/unitvehiclescars/uv_coloradozr2/uv_coloradozr2_wheel.mdl",
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 0.8, 1, 1 ),
			radius = 17.5
        } )
        self:CreateWheel( Vector(74,-38,7.85), {
            model = "models/unitvehiclescars/uv_coloradozr2/uv_coloradozr2_wheel.mdl",
            modelAngle = Angle( 0.000000, -90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 0.8, 1, 1 ),
			radius = 17.5
        } )
        self:CreateWheel( Vector(-74,38,9.85), {
            model = "models/unitvehiclescars/uv_coloradozr2/uv_coloradozr2_wheel.mdl",
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            modelScale = Vector( 0.8, 1, 1 ),
			radius = 17.5
        } )
        self:CreateWheel( Vector(-74,-38,9.85), {
            model = "models/unitvehiclescars/uv_coloradozr2/uv_coloradozr2_wheel.mdl",
            modelAngle = Angle( 0.000000, -90.000000, 0.000000 ),
            modelScale = Vector( 0.8, 1, 1 ),
			radius = 17.5
        } )

    end

    function ENT:OnPostThink( dt, selfTbl ) --Changing submaterials/bodygroups for the entire vehicle
        BaseClass.OnPostThink( self, dt, selfTbl )

        --Hood detachment when driving at high speeds
        if self:GetVelocity():LengthSqr() > 4000000 and self:GetBodygroup( 2 ) == 2 then
            local gibmodels = {
                "models/unitvehiclescars/uv_coloradozr2/hood.mdl",
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
        self:SetBodygroup( 0, 0 )
        self:SetBodygroup( 1, 0 )
        self:SetBodygroup( 2, 0 )
        self:SetBodygroup( 3, 0 )
        self:SetBodygroup( 4, 0 )
        self:SetBodygroup( 5, 0 )
        self:SetBodygroup( 9, 1 )
        self:SetBodygroup( 12, 0 )
        self:SetSkin(0)

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
            gib:SetSkin(self:GetSkin())
            gib:SetCollisionGroup(COLLISION_GROUP_WORLD)
            gib:Spawn()
            local gibPhys = gib:GetPhysicsObject()
            if IsValid(gibPhys) then
                gibPhys:SetDragCoefficient(0)
                if ishood then
                    gibPhys:SetVelocity((self:GetVelocity()*0.75) + self:GetUp() * 500)
                    gibPhys:SetAngleVelocity(VectorRand() * 500)
                else
                    gibPhys:SetVelocity(self:GetVelocity())
                    gibPhys:AddAngleVelocity(VectorRand() * 100)
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
        self:SetBodygroup( 8, 1 )
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
            self:SetSubMaterial(5, "models/unitvehiclescars/uv_coloradozr2/skin_0dam")
        end

        if self:GetBodygroup( 9 ) != 1 then --LIGHT BAR
            local gibchance = math.random(1, 5)
            if gibchance == 1 and (lefthit or righthit) then
                self:SetBodygroup( 9, 1 )
                local gibmodels = {
                    "models/unitvehiclescars/uv_coloradozr2/lightbar.mdl",
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
                self.frontdamaged = 1
            elseif self.frontdamaged < 2 then
                self:SetBodygroup( 1, 2 )
                self:SetBodygroup( 2, 2 )
                self:SetSubMaterial(14, "models/unitvehiclescars/shared/windowdamage")
                self.frontdamaged = 2
            elseif self.frontdamaged < 3 then
                self:SetBodygroup( 1, 3 )
                self:SetSubMaterial(14, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_coloradozr2/frbumper.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.frontdamaged = 3
            end
        end

        if rearhit then --REAR
            if self.reardamaged < 1 then
                self:SetBodygroup( 3, 1 )
                self:SetSubMaterial(15, "models/unitvehiclescars/shared/windowdamage")
                local gibmodels = {
                    "models/unitvehiclescars/uv_coloradozr2/exhaust.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.reardamaged = 1
            elseif self.reardamaged < 2 then
                self:SetBodygroup( 3, 2 )
                self:SetSubMaterial(15, "models/unitvehiclescars/shared/windowdamage1")
                self.reardamaged = 2
            elseif self.reardamaged < 3 then
                self:SetBodygroup( 3, 3 )
                self:SetSubMaterial(15, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_coloradozr2/rebumper.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.reardamaged = 3
            elseif self.reardamaged < 4 then
                self:SetBodygroup( 3, 4 )
                self:SetSubMaterial(15, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_coloradozr2/trunk.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.reardamaged = 4
            end
        end

        if lefthit then --LEFT
            if self.leftdamaged < 1 then
                self:SetBodygroup( 4, 1 )
                self:SetSubMaterial(11, "models/unitvehiclescars/shared/windowdamage")
                self.leftdamaged = 1
            elseif self.leftdamaged < 2 then
                self:SetBodygroup( 4, 2 )
                self:SetSubMaterial(11, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_coloradozr2/mirrorleft.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.leftdamaged = 2
            elseif self.leftdamaged < 3 then
                self:SetBodygroup( 4, 3 )
                self:SetSubMaterial(11, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_coloradozr2/doorleft.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.leftdamaged = 3
            elseif self.leftdamaged < 4 then
                self:SetBodygroup( 4, 4 )
                self:SetSubMaterial(11, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_coloradozr2/skirtleft.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.leftdamaged = 4
            end
        end

        if righthit then --RIGHT
            if self.rightdamaged < 1 then
                self:SetBodygroup( 5, 1 )
                self:SetSubMaterial(12, "models/unitvehiclescars/shared/windowdamage")
                self.rightdamaged = 1
            elseif self.rightdamaged < 2 then
                self:SetBodygroup( 5, 2 )
                self:SetSubMaterial(12, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_coloradozr2/mirrorright.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.rightdamaged = 2
            elseif self.rightdamaged < 3 then
                self:SetBodygroup( 5, 3 )
                self:SetSubMaterial(12, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_coloradozr2/doorright.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.rightdamaged = 3
            elseif self.rightdamaged < 4 then
                self:SetBodygroup( 5, 4 )
                self:SetSubMaterial(12, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_coloradozr2/skirtright.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.rightdamaged = 4
            end
        end

    end
end

function ENT:GetSpawnColor()
    return color_white
end