AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "Unit Vehicles Police Department"

-- ENT.PrintName = "Ford Crown Victoria Police Cruiser"
ENT.PrintName = "#uv.veh.crownvic"

ENT.GlideCategory = "unitvehiclesglide"
ENT.ChassisModel = "models/unitvehiclescars/uv_fordcrownvic/uv_fordcrownvic.mdl"
ENT.CanSwitchSiren = true

ENT.NitrousPower = 2.5
ENT.NitrousDepletionRate = 0.55
ENT.NitrousRegenRate = 0.1
ENT.NitrousRegenDelay = 0.6

DEFINE_BASECLASS( "base_glide_car" )

ENT.SirenTable = {
    ")uvcars/federal sig omega 90/emv_wail.wav",
    ")uvcars/federal sig omega 90/emv_yelp.wav",
    ")uvcars/federal sig omega 90/emv_hilo.wav",
    ")uvcars/federal sig omega 90/emv_sweep.wav"
}

if CLIENT then

    ENT.SirenVolume = 1

    ENT.SirenLoopSound = ")uvcars/federal sig omega 90/emv_wail.wav"
    ENT.SirenLoopAltSound = ")uvcars/federal sig omega 90/emv_horn.wav"
    ENT.HornSound = ")uvcars/federal sig omega 90/emv_horn.wav"

    ENT.CameraOffset = Vector( -250, 0, 65 )

    ENT.ExhaustOffsets = {
        {
            pos = Vector(-118.2,30.09,4.96),
		ang = Angle(210,-180,0),
	},
        {
            pos = Vector(-118.2,-30.09,4.96),
		ang = Angle(210,-180,0),
	},
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector( 107.27,0,19.02 ), angle = Angle(), width = 20 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 84.13,0,35.87 ), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector(115.06,29.17,22.76),
            color = Color(255,255,255)
        },
        {
            offset = Vector(115.06,-29.17,22.76),
            color = Color(255,255,255)
        },
    }

    ENT.LightSprites = {
        { type = "headlight", offset = Vector( 110.06,29.17,22.76 ),color = Color(255,255,255), dir = Vector( 1, 0, 0 ),size = 40 },
        { type = "headlight", offset = Vector( 110.06,-29.17,22.76 ),color = Color(255,255,255), dir = Vector( 1, 0, 0 ),size = 40 },
       
        { type = "taillight", offset = Vector(-113,31.84,29.1),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 40 },
        { type = "taillight", offset = Vector(-113,-31.84,29.1),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 40 },

        { type = "brake", offset = Vector(-113,31.84,29.1),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 40 },
        { type = "brake", offset = Vector(-113,-31.84,29.1),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 40 },
        { type = "brake", offset = Vector(-74.25,0,43.1),color = Color(255,0,0,150),dir = Vector( -1, 0, 0 ),size = 35 },

        { type = "reverse", ifBodygroupId = 9, ifSubModelId = 0, offset = Vector(-115.99,10.86,28.78), dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "reverse", ifBodygroupId = 9, ifSubModelId = 0, offset = Vector(-115.99,-10.86,28.78), dir = Vector( -1, 0, 0 ),size = 30 },

        { type = "reverse", ifBodygroupId = 9, ifSubModelId = 1, offset = Vector(-114.27,10.7,32.86), dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "reverse", ifBodygroupId = 9, ifSubModelId = 1, offset = Vector(-114.15,-11.18,33.98), dir = Vector( -1, 0, 0 ),size = 30 },

        { type = "reverse", ifBodygroupId = 9, ifSubModelId = 2, offset = Vector(-113.71,10.82,47.66), dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "reverse", ifBodygroupId = 9, ifSubModelId = 2, offset = Vector(-113.09,-11.29,48.52), dir = Vector( -1, 0, 0 ),size = 30 },

		{ type = "signal_left", ifBodygroupId = 6, ifSubModelId = 0, offset = Vector(111.79,22.19,22.54), dir = Vector( 1, 0, 0 ), color = Color(255, 192, 0),size = 25 },
        { type = "signal_right", ifBodygroupId = 6, ifSubModelId = 0, offset = Vector(111.79,-22.19,22.54), dir = Vector( 1, 0, 0 ), color = Color(255, 192, 0),size = 25 },

        { type = "signal_left", ifBodygroupId = 6, ifSubModelId = 0, offset = Vector(-113,31.84,29.1), dir = Vector( -1, 0, 0 ), color = Color(255,0,0),size = 40 },
        { type = "signal_right", ifBodygroupId = 6, ifSubModelId = 0, offset = Vector(-113,-31.84,29.1), dir = Vector( -1, 0, 0 ), color = Color(255,0,0),size = 40 },

    }

    ENT.SirenCycle = 0.3

    ENT.SirenLights = {

        { bodygroup = 10, time = 0.5, duration = 0.5 },
        { bodygroup = 11, time = 0, duration = 0.5 },

    -- WIG-WAG

        { offset = Vector( 110.06,29.17,22.76 ), color = Color(255,255,255), time = 0, duration = 0.5, size = 50 },
        { offset = Vector( 110.06,-29.17,22.76 ), color = Color(255,255,255), time = 0.5, duration = 0.5, size = 50 },

	-- RED
    
        { offset = Vector(-16.19,15.03,65.14), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-16.19,-15.03,65.14), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-8.53,15.03,65.14), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-8.53,-15.03,65.14), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-16.19,21.11,65.14), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-16.19,-21.11,65.14), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-8.53,21.11,65.14), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-8.53,-21.11,65.14), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-16.19,21.11,65.14),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { offset = Vector(-16.19,-21.11,65.14),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { offset = Vector(-8.53,21.11,65.14),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { offset = Vector(-8.53,-21.11,65.14),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { offset = Vector(114.04,-12.54,22.64),ifBodygroupId = 2, ifSubModelId = 0, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(114.04,-12.54,22.64),ifBodygroupId = 2, ifSubModelId = 1, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(114.1,-12.32,21.81),ifBodygroupId = 2, ifSubModelId = 2, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },

	-- BLUE

        { offset = Vector(-8.53,3.13,65.14), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-8.53,9.11,65.14), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-8.53,-3.13,65.14), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-8.53,-9.11,65.14), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-16.19,3.13,65.14), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-16.19,9.11,65.14), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-16.19,-3.13,65.14), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-16.19,-9.11,65.14), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-8.53,0,65.14),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },
        { offset = Vector(-16.19,0,65.14),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },
        { offset = Vector(114.04,12.54,22.64),ifBodygroupId = 2, ifSubModelId = 0, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(116,12.46,22.1),ifBodygroupId = 2, ifSubModelId = 1, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(115.98,12.63,21.01),ifBodygroupId = 2, ifSubModelId = 2, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },

    }


    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "uvfordcrownvicengine" )
    end

    local path = string.format("models/unitvehiclescars/uv_fordcrownvic/", ENT.VehicleName)
    local lightsPath = path .. "lights/"
    
    local Lights = {
        ['Off'] = {
            [9] = "",
            [24] = "",
        },
        ['On'] = {},
        ['Brake'] = {
            [9] = lightsPath .. "beam",
            [24] = lightsPath .. "beam",
        },
        ['Beams'] = {
            ['Off'] = {
                [9] = "",
                [24] = "",
                [25] = "",
            },
            [1] = {
                [9] = "",
                [24] = lightsPath .. "beam",
                [25] = lightsPath .. "lit",
            },
            [2] = {
                [11] = "",
                [24] = lightsPath .. "beam",
                [25] = lightsPath .. "lit",
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

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 6, 0, -8 ) )
    end

    ENT.SpawnPositionOffset = Vector( 0, 0, 20 )
    ENT.ChassisMass = 600
    ENT.IsHeavyVehicle = false

    ENT.BurnoutForce = 40
    ENT.UnflipForce = 20

    ENT.AirControlForce = Vector( 0.8, 0.6, 0.8 )

    ENT.AirMaxAngularVelocity = Vector( 290, 280, 290 )

    function ENT:GetGears()
        return {
		
		
            [-1] = 3,
            [0] = 0,
            [1] = 3.2,
            [2] = 2.1,
            [3] = 1.5,
            [4] = 1.2,

			
        }
		
		
    end

    function ENT:CreateFeatures()

        self:CreateSeat( Vector(0,21,5), Angle( 0.000000, -90.000000, 2.000000 ), Vector( 0.000000,  80.000000, 10.000000 ), true )
        self:CreateSeat( Vector(16,-21,7), Angle( 0.000000, -90.000000, 20.000000 ), Vector( 0.000000, -80.000000, 10.000000 ), true )
        self:CreateSeat( Vector(-33,-18,9), Angle( 0.000000, -90.000000, 15.000000 ), Vector( 0.000000, -80.000000, 10.000000 ), true )
        self:CreateSeat( Vector(-33,18,9), Angle( 0.000000, -90.000000, 15.000000 ), Vector( 0.000000, -80.000000, 10.000000 ), true )

        self:SetSuspensionLength( 8.5 )
        self:SetSpringStrength( 600 )
        self:SetSpringDamper( 2000 )

        self:SetDifferentialRatio( 1.0 )
        self:SetTransmissionEfficiency( 0.80 )
        self:SetPowerDistribution( -0.90 )
        self:SetBrakePower( 2500 )

        self:SetMinRPM( 500 ) 
        self:SetMaxRPM( 17250 ) 
        self:SetMinRPMTorque( 2200 )
        self:SetMaxRPMTorque( 2400 )

        self:SetMaxSteerAngle( 45 )
        self:SetSteerConeChangeRate( 6 )
        self:SetSteerConeMaxSpeed( 1300 )
        self:SetSteerConeMaxAngle( 0.20 )
		self:SetCounterSteer ( 0.8 )

        self:SetForwardTractionMax( 5000 )
        self:SetForwardTractionBias( 0 )
        self:SetSideTractionMultiplier( 20 )
        self:SetSideTractionMaxAng( 25 )
        self:SetSideTractionMax( 3000 ) 
        self:SetSideTractionMin( 1250 )

		self:SetTurboCharged( false )
		self:SetFastTransmission( true ) 

        self:CreateWheel( Vector(72.5,36.7,13), {
            model = "models/unitvehiclescars/uv_fordcrownvic/uv_fordcrownvic_wheel.mdl",
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 1, 1, 1 ),
            radius = 16
        } )
        self:CreateWheel( Vector(72.5,-36.7,13), {
            model = "models/unitvehiclescars/uv_fordcrownvic/uv_fordcrownvic_wheel.mdl",
            modelAngle = Angle( 0.000000, -90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 1, 1, 1 ),
            radius = 16
        } )
        self:CreateWheel( Vector(-59.75,38,13), {
            model = "models/unitvehiclescars/uv_fordcrownvic/uv_fordcrownvic_wheel.mdl",
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            modelScale = Vector( 1, 1, 1 ),
            radius = 16
        } )
        self:CreateWheel( Vector(-59.75,-38,13), {
            model = "models/unitvehiclescars/uv_fordcrownvic/uv_fordcrownvic_wheel.mdl",
            modelAngle = Angle( 0.000000, -90.000000, 0.000000 ),
            modelScale = Vector( 1, 1, 1 ),
            radius = 16
        } )

    end

    function ENT:OnPostThink( dt, selfTbl ) --Changing submaterials/bodygroups for the entire vehicle
        BaseClass.OnPostThink( self, dt, selfTbl )

        --Hood detachment when driving at high speeds
        if self:GetVelocity():LengthSqr() > 4000000 and self:GetBodygroup( 3 ) == 2 then
            local gibmodels = {
                "models/unitvehiclescars/uv_fordcrownvic/hood.mdl",
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
        self:SetBodygroup( 2, 0 )
        self:SetBodygroup( 3, 0 )
        self:SetBodygroup( 4, 0 )
        self:SetBodygroup( 5, 0 )
        self:SetBodygroup( 6, 0 )
        self:SetBodygroup( 7, 0 )
        self:SetBodygroup( 8, 0 )
        self:SetBodygroup( 9, 0 )

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
        self:SetBodygroup( 1, 1 )
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
            self:SetSubMaterial(8, "models/unitvehiclescars/uv_fordcrownvic/skin_0dam")
        end

        if fronthit then --FRONT
            if speed < 3000 and self.frontdamaged < 1 then
                self:SetBodygroup( 2, 1 )
                self:SetBodygroup( 3, 1 )
                self.frontdamaged = 1
            elseif self.frontdamaged < 2 then
                self:SetBodygroup( 2, 2 )
                self:SetBodygroup( 3, 2 )
                self.frontdamaged = 2
            elseif self.frontdamaged < 3 then
                self:SetBodygroup( 2, 3 )
                self:SetSubMaterial(12, "models/unitvehiclescars/shared/windowdamage")
                local gibmodels = {
                    "models/unitvehiclescars/uv_fordcrownvic/frbumper.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.frontdamaged = 3
            elseif self.frontdamaged < 4 then
                self:SetBodygroup( 2, 3 )
                self:SetSubMaterial(12, "models/unitvehiclescars/shared/windowdamage1")
                self.frontdamaged = 4
            end
        end

        if rearhit then --REAR
            if self.reardamaged < 1 then
                self:SetBodygroup( 8, 1 )
                self:SetBodygroup( 9, 1 )
                self.reardamaged = 1
            elseif self.reardamaged < 2 then
                self:SetBodygroup( 8, 2 )
                self:SetBodygroup( 9, 2 )
                self.reardamaged = 2
            elseif self.reardamaged < 3 then
                self:SetBodygroup( 8, 3 )
                self:SetBodygroup( 9, 2 )
                self:SetSubMaterial(11, "models/unitvehiclescars/shared/windowdamage")
                local gibmodels = {
                    "models/unitvehiclescars/uv_fordcrownvic/rebumper.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.reardamaged = 3
            elseif self.reardamaged < 4 then
                self:SetBodygroup( 8, 3 )
                self:SetBodygroup( 9, 3 )
                self:SetSubMaterial(11, "models/unitvehiclescars/shared/windowdamage1")
                local gibmodels = {
                    "models/unitvehiclescars/uv_fordcrownvic/trunk.mdl",
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
                self:SetBodygroup( 6, 1 )
                self:SetSubMaterial(17, "models/unitvehiclescars/shared/windowdamage")
                self.leftdamaged = 1
            elseif self.leftdamaged < 2 then
                self:SetBodygroup( 4, 2 )
                self:SetBodygroup( 6, 2 )
                self:SetSubMaterial(17, "models/unitvehiclescars/shared/windowdamage1")
                self.leftdamaged = 2
            end
        end

        if righthit then --RIGHT
            if self.rightdamaged < 1 then
                self:SetBodygroup( 5, 1 )
                self:SetBodygroup( 7, 1 )
                self:SetSubMaterial(18, "models/unitvehiclescars/shared/windowdamage")
                self.rightdamaged = 1
            elseif self.rightdamaged < 2 then
                self:SetBodygroup( 5, 2 )
                self:SetBodygroup( 7, 2 )
                self:SetSubMaterial(18, "models/unitvehiclescars/shared/windowdamage1")
                self.rightdamaged = 2
            end
        end


    end
end

function ENT:GetSpawnColor()
    return Color( 255, 255, 255)
end

function ENT:GetFirstPersonOffset( _, localEyePos )
    if self:GetDriver() == LocalPlayer() then
        return Vector(6,21,46)
    else return localEyePos
    end
end