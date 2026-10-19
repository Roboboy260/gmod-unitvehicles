AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "Unit Vehicles Police Department"

ENT.PrintName = "#uv.veh.r35"

ENT.VehicleName = "uv_r35nismo" -- Change this to the class name of your vehicle
ENT.EntityModelName = "uv_r35nismo" -- Change this to the model name of your vehicle
ENT.GlideCategory = "unitvehiclesglide"
ENT.ChassisModel = string.format( "models/unitvehiclescars/%s/%s.mdl", ENT.VehicleName, ENT.EntityModelName )
ENT.CanSwitchSiren = true
ENT.UVVehicleModel = "policecar"

ENT.StartSound = "uvcars/shared/startup_race.mp3"
ENT.StartedSound = "uvcars/3.8lttv6/started.mp3"

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

    ENT.CameraOffset = Vector( -230, 0, 65 )
    
    ENT.ExhaustOffsets = {
        {
            pos = Vector(-94.88,31.98,9.55), ifBodygroupId = 3,
	    	ang = Angle(180,-180,0),
	    },
        {
            pos = Vector(-94.88,-31.98,9.55), ifBodygroupId = 3,
	    	ang = Angle(180,-180,0),
        },
        {
            pos = Vector(-96.37,25.54,9.09), ifBodygroupId = 3,
	    	ang = Angle(180,-180,0),
	    },
        {
            pos = Vector(-96.37,-25.54,9.09), ifBodygroupId = 3,
	    	ang = Angle(180,-180,0),
	    },
        
        {
            pos = Vector(-94.88,31.98,9.55), ifBodygroupId = 3, ifSubModelId = 1,
	    	ang = Angle(180,-180,0),
	    },
        {
            pos = Vector(-97.42,-32.88,9.47), ifBodygroupId = 3, ifSubModelId = 1,
	    	ang = Angle(180,-180,0),
	    },
        {
            pos = Vector(-96.37,25.54,9.09), ifBodygroupId = 3, ifSubModelId = 1,
	    	ang = Angle(180,-180,0),
	    },
        {
            pos = Vector(-98.9,-26.33,9.09), ifBodygroupId = 3, ifSubModelId = 1,
	    	ang = Angle(180,-180,0),
	    },

        {
            pos = Vector(-97.42,32.88,9.47), ifBodygroupId = 3, ifSubModelId = 2,
	    	ang = Angle(180,-180,0),
	    },
        {
            pos = Vector(-97.04,-32.35,6.66), ifBodygroupId = 3, ifSubModelId = 2,
	    	ang = Angle(180,-180,0),
	    },
        {
            pos = Vector(-98.9,26.33,9.09), ifBodygroupId = 3, ifSubModelId = 2,
	    	ang = Angle(180,-180,0),
	    },
        {
            pos = Vector(-98.67,-25.72,6.84), ifBodygroupId = 3, ifSubModelId = 2,
	    	ang = Angle(180,-180,0),
	    },
    }
    
    ENT.EngineSmokeStrips = {
        { offset = Vector(95.34,0,22.19), angle = Angle(), width = 45 }
    }
    
    ENT.EngineFireOffsets = {
        { offset = Vector(70.75,0,29.14), angle = Angle() }
    }
    
    ENT.Headlights = {
        {
            offset = Vector(87.28,32.09,25.6),
            color = Color(160,205,255)
        },
        {
            offset = Vector(87.28,-32.09,25.6),
            color = Color(160,205,255)
        },
    }
    
    ENT.LightSprites = {
        { type = "headlight", offset = Vector(87.28,32.09,25.6), size = 30, color = Color(215,240,255), dir = Vector( 1, 0, 0 ) },
        { type = "headlight", offset = Vector(85.47,34.63,25.93), size = 30, color = Color(215,240,255), dir = Vector( 1, 0, 0 ) },
        
        { type = "headlight", offset = Vector(87.28,-32.09,25.6), size = 30, color = Color(215,240,255), dir = Vector( 1, 0, 0 ) },
        { type = "headlight", offset = Vector(85.47,-34.63,25.93), size = 30, color = Color(215,240,255), dir = Vector( 1, 0, 0 ) },

        { type = "headlight", offset = Vector(89.71,28.88,24.39),color = Color(215,240,255), dir = Vector( 1, 0, 0 ),beamType = "high",size = 50 },
        { type = "headlight", offset = Vector(89.71,-28.88,24.39),color = Color(215,240,255), dir = Vector( 1, 0, 0 ),beamType = "high",size = 50 },

        { type = "taillight", ifBodygroupId = 3, ifSubModelId = 0, offset = Vector(-93.68,30.69,33.16),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 35 },
        { type = "taillight", ifBodygroupId = 3, ifSubModelId = 0, offset = Vector(-93.68,-30.69,33.16),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 35 },
        
        { type = "taillight", ifBodygroupId = 3, ifSubModelId = 1, offset = Vector(-93.68,30.69,33.16),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 35 },
        { type = "taillight", ifBodygroupId = 3, ifSubModelId = 1, offset = Vector(-96.57,-31.76,33.18),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 35 },

        { type = "taillight", ifBodygroupId = 3, ifSubModelId = 2, offset = Vector(-96.5,31.64,33.14),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 35 },
        { type = "taillight", ifBodygroupId = 3, ifSubModelId = 2, offset = Vector(-96.57,-33.3,30.29),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 35 },

        { type = "taillight", ifBodygroupId = 3, ifSubModelId = 0, offset = Vector(-97.71,21.47,32.21),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "taillight", ifBodygroupId = 3, ifSubModelId = 0, offset = Vector(-97.71,-21.47,32.21),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },

        { type = "taillight", ifBodygroupId = 3, ifSubModelId = 1, offset = Vector(-97.71,21.47,32.21),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "taillight", ifBodygroupId = 3, ifSubModelId = 1, offset = Vector(-99.54,-22.18,32.2),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },

        { type = "taillight", ifBodygroupId = 3, ifSubModelId = 2, offset = Vector(-99.54,22.18,32.2),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "taillight", ifBodygroupId = 3, ifSubModelId = 2, offset = Vector(-99.6,-23.75,30.12),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },

        { type = "brake", ifBodygroupId = 3, ifSubModelId = 0, offset = Vector(-93.68,30.69,33.16),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 35 },
        { type = "brake", ifBodygroupId = 3, ifSubModelId = 0, offset = Vector(-93.68,-30.69,33.16),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 35 },

        { type = "brake", ifBodygroupId = 3, ifSubModelId = 1, offset = Vector(-93.68,30.69,33.16),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 35 },
        { type = "brake", ifBodygroupId = 3, ifSubModelId = 1, offset = Vector(-96.57,-31.76,33.18),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 35 },

        { type = "brake", ifBodygroupId = 3, ifSubModelId = 2, offset = Vector(-96.5,31.64,33.14),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 35 },
        { type = "brake", ifBodygroupId = 3, ifSubModelId = 2, offset = Vector(-96.57,-33.3,30.29),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 35 },

        { type = "brake", ifBodygroupId = 3, ifSubModelId = 0, offset = Vector(-97.71,21.47,32.21),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "brake", ifBodygroupId = 3, ifSubModelId = 0, offset = Vector(-97.71,-21.47,32.21),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },

        { type = "brake", ifBodygroupId = 3, ifSubModelId = 1, offset = Vector(-97.71,21.47,32.21),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "brake", ifBodygroupId = 3, ifSubModelId = 1, offset = Vector(-99.54,-22.18,32.2),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },

        { type = "brake", ifBodygroupId = 3, ifSubModelId = 2, offset = Vector(-99.54,22.18,32.2),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "brake", ifBodygroupId = 3, ifSubModelId = 2, offset = Vector(-99.6,-23.75,30.12),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 30 },

        { type = "reverse", ifBodygroupId = 3, ifSubModelId = 0, offset = Vector(-97.71,21.47,32.21), dir = Vector( -1, 0, 0 ),size = 25 },
        { type = "reverse", ifBodygroupId = 3, ifSubModelId = 0, offset = Vector(-97.71,-21.47,32.21), dir = Vector( -1, 0, 0 ),size = 25 },

        { type = "reverse", ifBodygroupId = 3, ifSubModelId = 1, offset = Vector(-97.71,21.47,32.21), dir = Vector( -1, 0, 0 ),size = 25 },
        { type = "reverse", ifBodygroupId = 3, ifSubModelId = 1, offset = Vector(-99.54,-22.18,32.2), dir = Vector( -1, 0, 0 ),size = 25 },

        { type = "reverse", ifBodygroupId = 3, ifSubModelId = 2, offset = Vector(-99.54,22.18,32.2), dir = Vector( -1, 0, 0 ),size = 25 },
        { type = "reverse", ifBodygroupId = 3, ifSubModelId = 2, offset = Vector(-99.6,-23.75,30.12), dir = Vector( -1, 0, 0 ),size = 25 },

		{ type = "signal_left", ifBodygroupId = 3, ifSubModelId = 0, offset = Vector(-93.68,30.69,33.16), dir = Vector( -1, 0, 0 ), color = Color(255, 192, 0),size = 35 },
        { type = "signal_right", ifBodygroupId = 3, ifSubModelId = 0, offset = Vector(-93.68,-30.69,33.16), dir = Vector( -1, 0, 0 ), color = Color(255, 192, 0),size = 35 },

        { type = "signal_left", ifBodygroupId = 3, ifSubModelId = 1, offset = Vector(-93.68,30.69,33.16), dir = Vector( -1, 0, 0 ), color = Color(255, 192, 0),size = 35 },
        { type = "signal_right", ifBodygroupId = 3, ifSubModelId = 1, offset = Vector(-96.57,-31.76,33.18), dir = Vector( -1, 0, 0 ), color = Color(255, 192, 0),size = 35 },

        { type = "signal_left", ifBodygroupId = 3, ifSubModelId = 2, offset = Vector(-96.5,31.64,33.14), dir = Vector( -1, 0, 0 ), color = Color(255, 192, 0),size = 35 },
        { type = "signal_right", ifBodygroupId = 3, ifSubModelId = 2, offset = Vector(-96.57,-33.3,30.29), dir = Vector( -1, 0, 0 ), color = Color(255, 192, 0),size = 35 },

        { type = "signal_left", offset = Vector(77.19,34.32,29.36), dir = Vector( 1, 0, 0 ), color = Color(255, 192, 0),size = 30 },
        { type = "signal_right", offset = Vector(77.19,-34.32,29.36), dir = Vector( 1, 0, 0 ), color = Color(255, 192, 0),size = 30 },
    }

    ENT.SirenCycle = 0.3

    ENT.SirenLights = {

        { ifBodygroupId = 12, ifSubModelId = 0, bodygroup = 7, time = 0, duration = 0.5 },
        { ifBodygroupId = 12, ifSubModelId = 0, bodygroup = 8, time = 0.5, duration = 0.5 },

    -- WIG-WAG

        { offset = Vector(87.28,32.09,25.6), time = 0, duration = 0.5,  size = 50, color = Color(215,240,255) },
        { offset = Vector(87.28,-32.09,25.6), time = 0.5, duration = 0.5, size = 50, color = Color(215,240,255) },

        { offset = Vector(-97.71,-21.47,32.21), ifBodygroupId = 3, ifSubModelId = 0, time = 0, duration = 0.5,  size = 50, color = Color(215,240,255) },
        { offset = Vector(-97.71,21.47,32.21), ifBodygroupId = 3, ifSubModelId = 0, time = 0.5, duration = 0.5, size = 50, color = Color(215,240,255) },

        { offset = Vector(-97.71,-21.47,32.21), ifBodygroupId = 3, ifSubModelId = 1, time = 0, duration = 0.5,  size = 50, color = Color(215,240,255) },
        { offset = Vector(-99.54,22.18,32.2), ifBodygroupId = 3, ifSubModelId = 1, time = 0.5, duration = 0.5, size = 50, color = Color(215,240,255) },

        { offset = Vector(-99.54,-22.18,32.2), ifBodygroupId = 3, ifSubModelId = 2, time = 0, duration = 0.5,  size = 50, color = Color(215,240,255) },
        { offset = Vector(-99.6,23.75,30.12), ifBodygroupId = 3, ifSubModelId = 2, time = 0.5, duration = 0.5, size = 50, color = Color(215,240,255) },

	-- RED

        { offset = Vector(105.47,-10.65,14.85), ifBodygroupId = 1, ifSubModelId = 0, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(105.47,-10.65,14.85), ifBodygroupId = 1, ifSubModelId = 1, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(105.99,-10.57,14.79), ifBodygroupId = 1, ifSubModelId = 2, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },

        { offset = Vector(-104.36,10.57,21.88), ifBodygroupId = 3, ifSubModelId = 0, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-104.36,10.57,21.88), ifBodygroupId = 3, ifSubModelId = 1, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-105.27,10.7,21.81), ifBodygroupId = 3, ifSubModelId = 2, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
    
        { offset = Vector(10.53,22.57,49.17), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(11.56,17.85,49.17), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(10.53,-22.57,49.17), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(11.56,-17.85,49.17), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-44.63,17.62,49.17), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-45.5,12.89,49.17), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-44.63,-17.62,49.17), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-45.5,-12.89,49.17), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(10.53,22.57,49.17), dir = Vector( 1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { offset = Vector(10.53,-22.57,49.17), dir = Vector( 1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { offset = Vector(-44.63,17.62,49.17), dir = Vector( -1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { offset = Vector(-44.63,-17.62,49.17), dir = Vector( -1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },

	-- BLUE

        { offset = Vector(105.47,10.65,14.85), ifBodygroupId = 1, ifSubModelId = 0, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(105.99,10.57,14.79), ifBodygroupId = 1, ifSubModelId = 1, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(105.89,10.22,14.33), ifBodygroupId = 1, ifSubModelId = 2, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },

        { offset = Vector(-104.36,-10.57,21.88), ifBodygroupId = 3, ifSubModelId = 0, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-105.27,-10.7,21.81), ifBodygroupId = 3, ifSubModelId = 1, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-105.26,-11.38,20.88), ifBodygroupId = 3, ifSubModelId = 2, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },

        { offset = Vector(12.42,13.08,49.17), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(13.13,8.29,49.17), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(12.42,-13.08,49.17), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(13.13,-8.29,49.17), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-46.41,8.06,49.17), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-47.01,3.31,49.17), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-46.41,-8.06,49.17), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-47.01,-3.31,49.17), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(13.13,8.29,49.17), dir = Vector( 1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },
        { offset = Vector(13.13,-8.29,49.17), dir = Vector( 1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },
        { offset = Vector(-47.01,3.31,49.17), dir = Vector( -1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },
        { offset = Vector(-47.01,-3.31,49.17), dir = Vector( -1, 0, 0 ), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },

    }
    
    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "uvcommanderb" )
    end
    
    local path = string.format("models/unitvehiclescars/uv_r35nismo/", ENT.VehicleName)
    local lightsPath = path .. ""
    
    local Lights = {
        ['Off'] = {
            [15] = "",
            [20] = "",
            [22] = "",
        },
        ['On'] = {
            [15] = "lights/white002",
            [22] = "",
        },
        ['Brake'] = {
            [20] = lightsPath .. "brakelightlit",
            [22] = lightsPath .. "brakelightlit",
        },
        ['Beams'] = {
            ['Off'] = {
                [16] = "",
                [17] = "",
                [20] = "",
            },
            [1] = {
                [16] = "lights/white002",
                [17] = "",
                [20] = lightsPath .. "brakelightlit",
            },
            [2] = {
                [16] = "lights/white002",
                [17] = "lights/white002",
                [20] = lightsPath .. "brakelightlit",
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

    ENT.ExplosionBodygroupGibs = {
        {
            bodygroup = 2,
            detachedAt = 3,
            model = "models/unitvehiclescars/uv_r35nismo/hood.mdl",
        },
        {
            bodygroup = 1,
            detachedAt = 3,
            model = "models/unitvehiclescars/uv_r35nismo/frbumper.mdl",
        },
        {
            bodygroup = 3,
            detachedAt = 3,
            model = "models/unitvehiclescars/uv_r35nismo/rebumper.mdl",
        },
        {
            bodygroup = 3,
            detachedAt = 4,
            model = "models/unitvehiclescars/uv_r35nismo/trunk.mdl",
        },
        {
            bodygroup = 4,
            detachedAt = 2,
            model = "models/unitvehiclescars/uv_r35nismo/mirrorleft.mdl",
        },
        {
            bodygroup = 4,
            detachedAt = 3,
            model = "models/unitvehiclescars/uv_r35nismo/doorleft.mdl",
        },
        {
            bodygroup = 5,
            detachedAt = 2,
            model = "models/unitvehiclescars/uv_r35nismo/mirrorright.mdl",
        },
        {
            bodygroup = 5,
            detachedAt = 3,
            model = "models/unitvehiclescars/uv_r35nismo/doorright.mdl",
        },
    }

    ENT.ExplosionDamageBodygroups = {
        [1] = 3,
        [2] = 3,
        [3] = 4,
        [4] = 3,
        [5] = 3
    }

    ENT.ExplosionDamagedSubMaterials = {
        [8] = "models/unitvehiclescars/shared/windowdamage1",
        [9] = "models/unitvehiclescars/shared/windowdamage1",
        [10] = "models/unitvehiclescars/shared/windowdamage1",
        [11] = "models/unitvehiclescars/shared/windowdamage1",
    }

    ENT.ExplosionDamagedSkin = 1
    
    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 3, 0, -8 ) )
    end
    
    ENT.SpawnPositionOffset = Vector( 0, 0, 20 )
    ENT.ChassisMass = 800
    ENT.IsHeavyVehicle = false
    
    ENT.BurnoutForce = 40
    ENT.UnflipForce = 20
    
    ENT.AirControlForce = Vector( 0.8, 0.6, 0.8 )
    
    ENT.AirMaxAngularVelocity = Vector( 290, 280, 290 )
    
    function ENT:GetGears()
        return {
            [-1] = 3.5,
            [0] = 0,
            [1] = 4.00,
            [2] = 2.3,
            [3] = 1.59,
            [4] = 1.24,
            [5] = 1.0,
            [6] = 0.79,
        }
    end
    

    function ENT:CreateFeatures()

        self.WheelPos = {
            [1] = Vector(63,35,16),
            [2] = Vector(63,-35,16),
            [3] = Vector(-62.12,36,16),
            [4] = Vector(-62.12,-36,16)
        }
        
        local WheelToUse = string.format( "models/unitvehiclescars/%s/%s_wheel.mdl", self.VehicleName, self.EntityModelName )
        
        self:CreateSeat( Vector(-20,17,5.5), Angle( 0.000000, -90.000000, 2.000000 ), Vector( 0.000000,  80.000000, 10.000000 ), true )
        self:CreateSeat( Vector(-7,-17,8.5), Angle( 0.000000, -90.000000, 15.000000 ), Vector( 0.000000, -80.000000, 10.000000 ), true )

        self:SetSuspensionLength( 8 )
        self:SetSpringStrength( 800 )
        self:SetSpringDamper( 3000 )

        self:SetDifferentialRatio( 1 )
        self:SetTransmissionEfficiency( 1 )
        self:SetPowerDistribution( -0.25 )
        self:SetBrakePower( 4800 )

        self:SetMinRPM( 2000 ) 
        self:SetMaxRPM( 25000 ) 
        self:SetMinRPMTorque( 10800 )
        self:SetMaxRPMTorque( 9300 )

        self:SetMaxSteerAngle( 45 )
        self:SetSteerConeChangeRate( 8 )
        self:SetSteerConeMaxSpeed( 1500 )
        self:SetSteerConeMaxAngle( 0.25 )
		self:SetCounterSteer ( 0.8 )

        self:SetForwardTractionMax( 10000 )
        self:SetForwardTractionBias( 0.45 )
        self:SetSideTractionMultiplier( 77 )
        self:SetSideTractionMaxAng( 67 )
        self:SetSideTractionMax( 6000 ) 
        self:SetSideTractionMin( 3250 )

		self:SetTurboCharged( true )
		self:SetFastTransmission( true ) 
        
        self:CreateWheel( self.WheelPos[1], {
            model = WheelToUse,
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 0.42, 1, 1 ),
            radius = 16.3
        } )
        self:CreateWheel( self.WheelPos[2], {
            model = WheelToUse,
            modelAngle = Angle( 0.000000, -90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 0.42, 1, 1 ),
            radius = 16.3
        } )
        self:CreateWheel( self.WheelPos[3], {
            model = WheelToUse,
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            modelScale = Vector( 0.43, 1, 1 ),
            radius = 16.3
        } )
        self:CreateWheel( self.WheelPos[4], {
            model = WheelToUse,
            modelAngle = Angle( 0.000000, -90.000000, 0.000000 ),
            modelScale = Vector( 0.43, 1, 1 ),
            radius = 16.3
        } )
        
    end
    
    function ENT:OnPostThink( dt, selfTbl ) --Changing submaterials/bodygroups for the entire vehicle
        BaseClass.OnPostThink( self, dt, selfTbl )

        --Hood detachment when driving at high speeds
        if self:GetVelocity():LengthSqr() > 4000000 and self:GetBodygroup( 2 ) == 2 then
            local gibmodels = {
                "models/unitvehiclescars/uv_r35nismo/hood.mdl",
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
        self:SetBodygroup( 6, 1 )
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
            self:SetSkin(1)
        end

        if fronthit then --FRONT
            if self.frontdamaged < 1 then
                self:SetBodygroup( 1, 1 )
                self:SetBodygroup( 2, 1 )
                self.frontdamaged = 1
            elseif self.frontdamaged < 2 then
                self:SetBodygroup( 1, 2 )
                self:SetBodygroup( 2, 2 )
                self:SetSubMaterial(8, "models/unitvehiclescars/shared/windowdamage")
                self.frontdamaged = 2
            elseif self.frontdamaged < 3 then
                self:SetBodygroup( 1, 3 )
                self:SetSubMaterial(8, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_r35nismo/frbumper.mdl",
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
                self:SetSubMaterial(9, "models/unitvehiclescars/shared/windowdamage")
                self.reardamaged = 1
            elseif self.reardamaged < 2 then
                self:SetBodygroup( 3, 2 )
                self:SetSubMaterial(9, "models/unitvehiclescars/shared/windowdamage1")
                self.reardamaged = 2
            elseif self.reardamaged < 3 then
                self:SetBodygroup( 3, 3 )
                self:SetSubMaterial(9, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_r35nismo/rebumper.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.reardamaged = 3
            elseif self.reardamaged < 4 then
                self:SetBodygroup( 3, 4 )
                self:SetSubMaterial(9, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_r35nismo/trunk.mdl",
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
                self:SetSubMaterial(10, "models/unitvehiclescars/shared/windowdamage")
                self.leftdamaged = 1
            elseif self.leftdamaged < 2 then
                self:SetBodygroup( 4, 2 )
                self:SetSubMaterial(10, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_r35nismo/mirrorleft.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.leftdamaged = 2
            elseif self.leftdamaged < 3 then
                self:SetBodygroup( 4, 3 )
                self:SetSubMaterial(10, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_r35nismo/doorleft.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.leftdamaged = 3
            end
        end

        if righthit then --RIGHT
            if self.rightdamaged < 1 then
                self:SetBodygroup( 5, 1 )
                self:SetSubMaterial(11, "models/unitvehiclescars/shared/windowdamage")
                self.rightdamaged = 1
            elseif self.rightdamaged < 2 then
                self:SetBodygroup( 5, 2 )
                self:SetSubMaterial(11, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_r35nismo/mirrorright.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.rightdamaged = 2
            elseif self.rightdamaged < 3 then
                self:SetBodygroup( 5, 3 )
                self:SetSubMaterial(11, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_r35nismo/doorright.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.rightdamaged = 3
            end
        end

    end
end

function ENT:GetSpawnColor()
    return color_white
end