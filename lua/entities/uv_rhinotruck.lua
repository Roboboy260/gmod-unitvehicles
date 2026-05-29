AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "Unit Vehicles Police Department"

-- ENT.PrintName = "Rhino Truck"
ENT.PrintName = "#uv.veh.rhino"

ENT.GlideCategory = "unitvehiclesglide"
ENT.ChassisModel = "models/unitvehiclescars/uv_rhinotruck/uv_rhinotruck.mdl"
ENT.CanSwitchSiren = true
ENT.UVVehicleModel = "policecar"

DEFINE_BASECLASS( "base_glide_car" )

ENT.SirenTable = {
    ")uvcars/federal sig rumbler/emv_wail.wav",
    ")uvcars/federal sig rumbler/emv_yelp.wav",
    ")uvcars/federal sig rumbler/emv_priority.wav",
    ")uvcars/federal sig rumbler/emv_hilo.wav",
}

if CLIENT then
    ENT.CameraOffset = Vector( -350, 0, 125 )
	ENT.CameraCenterOffset = Vector( 0, 0, 0 )

    ENT.SirenVolume = 1

    ENT.SirenLoopSound = ")uvcars/federal sig rumbler/emv_wail.wav"
    ENT.SirenLoopAltSound = ")uvcars/federal sig rumbler/emv_horn.wav"
    ENT.HornSound = ")uvcars/federal sig rumbler/emv_horn.wav"

    ENT.ExhaustOffsets = {
        {
            pos = Vector(-39.7,55.14,5.15), angle = Angle(180,90,0),
        },
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector( 116,0,37.19 ), angle = Angle(), width = 45 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 97.35,-0.05,56.16 ), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector(110.5,35.38,37.53),
            color = Color(160,205,255)
        },
        {
            offset = Vector(110.5,-35.38,37.53),
            color = Color(160,205,255)
        },
    }


    ENT.LightSprites = {

        { type = "headlight", offset = Vector(106.5,35.38,37.53), size = 50, color = Color(215,240,255,255), dir = Vector( 1, 0, 0 ), },
        { type = "headlight", offset = Vector(106.5,-35.38,37.53), size = 50, color = Color(215,240,255,255), dir = Vector( 1, 0, 0 ), },

        { type = "headlight", offset = Vector(102.48,44.13,38.4), size = 40, color = Color(215,240,255,255), dir = Vector( 1, 0, 0 ), },
        { type = "headlight", offset = Vector(102.48,-44.13,38.4), size = 40, color = Color(215,240,255,255), dir = Vector( 1, 0, 0 ), },

        { type = "taillight", offset = Vector(-125.27,41.15,32.27), size = 40, color = Color(255,0,0,200), dir = Vector( -1, 0, 0 ), },
        { type = "taillight", offset = Vector(-125.27,-41.15,32.27), size = 40, color = Color(255,0,0,200), dir = Vector( -1, 0, 0 ), },

        { type = "brake", offset = Vector(-125.27,41.15,32.27), size = 40, color = Color(255,0,0,200), dir = Vector( -1, 0, 0 ), },
        { type = "brake", offset = Vector(-125.27,-41.15,32.27), size = 40, color = Color(255,0,0,200), dir = Vector( -1, 0, 0 ), },

        { type = "reverse", offset = Vector(-126.74,43.74,51.35), size = 30, color = Color(255,255,255), dir = Vector( -1, 0, 0 ), },
        { type = "reverse", offset = Vector(-126.74,-43.74,51.35), size = 30, color = Color(255,255,255), dir = Vector( -1, 0, 0 ), }, 

        { type = "signal_left", offset = Vector(98.12,49.27,39), dir = Vector( 1, 0, 0 ), color = Color(255, 192, 0), size = 30 },
        { type = "signal_right", offset = Vector(98.12,-49.27,39), dir = Vector( 1, 0, 0 ), color = Color(255, 192, 0), size = 30 },

        { type = "signal_left", offset = Vector(-125.27,46.57,31.94), color = Color(255, 192, 0), dir = Vector( -1, 0, 0 ), size = 30 },
        { type = "signal_right", offset = Vector(-125.27,-46.57,31.94), color = Color(255, 192, 0), dir = Vector( -1, 0, 0 ), size = 30 },
    }

    ENT.SirenCycle = 0.3

    ENT.SirenLights = {

        { bodygroup = 2, time = 0.5, duration = 0.5 },
        { bodygroup = 3, time = 0, duration = 0.5 },

        -- WIG-WAG
        { offset = Vector(106.5,35.38,37.53), time = 0, duration = 0.5, size = 50, color = Color(215,240,255,255), dir = Vector( 1, 0, 0 ), },
        { offset = Vector(106.5,-35.38,37.53), time = 0.5, duration = 0.5, size = 50, color = Color(215,240,255,255), dir = Vector( 1, 0, 0 ), },

        { offset = Vector(102.48,44.13,38.4), time = 0, duration = 0.5, size = 50, color = Color(215,240,255,255), dir = Vector( 1, 0, 0 ),},
        { offset = Vector(102.48,-44.13,38.4), time = 0.5, duration = 0.5, size = 50, color = Color(215,240,255,255), dir = Vector( 1, 0, 0 ), },

        -- RED

        { offset = Vector(-128.34,37.15,95.42), time = 0, duration = 0.5, size = 40, color = Color(255,30,0), dir = Vector( -1, 0, 0 ), },
        { offset = Vector(71.77,-55.07,45.74), time = 0, duration = 0.5, size = 40, color = Color(255,30,0), dir = Vector( 0, -1, 0 ), },
        { offset = Vector(116.58,-25.56,37.53), time = 0, duration = 0.5, size = 40, color = Color(255,30,0), dir = Vector( 1, 0, 0 ), },

        { offset = Vector(-3.71,-36.36,104.23), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 220, color = Color(255,30,0), },
        { offset = Vector(-3.71,-25.96,104.23), time = 0, duration = 0.5, size = 80, color = Color(255,30,0), },

        { offset = Vector(-3.71,36.36,104.23), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 220, color = Color(255,30,0), },
        { offset = Vector(-3.71,25.96,104.23), time = 0, duration = 0.5, size = 80, color = Color(255,30,0), },

        { offset = Vector(13.77,-36.36,104.23), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 220, color = Color(255,30,0), },
        { offset = Vector(13.77,-25.96,104.23), time = 0, duration = 0.5, size = 80, color = Color(255,30,0), },

        { offset = Vector(13.77,36.36,104.23), spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 220, color = Color(255,30,0), },
        { offset = Vector(13.77,25.96,104.23), time = 0, duration = 0.5, size = 80, color = Color(255,30,0), },

        -- BLUE

        { offset = Vector(-128.34,-37.15,95.42), time = 0.5, duration = 0.5, size = 40, color = Color(0,115,255), dir = Vector( -1, 0, 0 ), },
        { offset = Vector(71.77,55.07,45.74), time = 0.5, duration = 0.5, size = 40, color = Color(0,115,255), dir = Vector( 0, 1, 0 ), },
        { offset = Vector(116.58,25.56,37.53), time = 0.5, duration = 0.5, size = 40, color = Color(0,115,255), dir = Vector( 1, 0, 0 ), },

        { offset = Vector(-3.71,15.6,104.23), time = 0.5, duration = 0.5, size = 80, color = Color(0,115,255), },
        { offset = Vector(-3.71,-15.6,104.23), time = 0.5, duration = 0.5, size = 80, color = Color(0,115,255), },

        { offset = Vector(-3.71,5.17,104.23), time = 0.5, duration = 0.5, size = 80, color = Color(0,115,255), },
        { offset = Vector(-3.71,-5.17,104.23), time = 0.5, duration = 0.5, size = 80, color = Color(0,115,255), },

        { offset = Vector(13.77,15.6,104.23), time = 0.5, duration = 0.5, size = 80, color = Color(0,115,255), },
        { offset = Vector(13.77,-15.6,104.23), time = 0.5, duration = 0.5, size = 80, color = Color(0,115,255), },

        { offset = Vector(13.77,5.17,104.23), time = 0.5, duration = 0.5, size = 80, color = Color(0,115,255), },
        { offset = Vector(13.77,-5.17,104.23), time = 0.5, duration = 0.5, size = 80, color = Color(0,115,255), },

        { offset = Vector(-3.71,0,104.23),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 220, color = Color(0,115,255), },

        { offset = Vector(13.77,0,104.23),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 220, color = Color(0,115,255), },

    }

     
   
    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "airbus" )
    end
end



if SERVER then

    ENT.SpawnPositionOffset = Vector( 0, 0, 30 )
    ENT.ChassisMass = 1600

    ENT.IsHeavyVehicle = true

    ENT.BurnoutForce = 40
    ENT.UnflipForce = 20

    ENT.AirControlForce = Vector( 0.2, 0.2, 0.2 )

    ENT.AirMaxAngularVelocity = Vector( 290, 280, 290 )

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 8, 0, -10 ) )
    end
    function ENT:GetGears()
        return {
		
		
            [-1] = 4,
            [0] = 0,
            [1] = 4.4,
            [2] = 2.9,
            [3] = 2.5,
            [4] = 2.2,
            [5] = 2.0,
            [6] = 1.8,

			
        }
		
		
    end

    ENT.SuspensionHeavySound = "Glide.Suspension.CompressTruck"
    ENT.SuspensionDownSound = "Glide.Suspension.Stress"

    function ENT:CreateFeatures()
		self:SetHeadlightColor( Vector( 1, 1, 1 ) )		
        self:CreateSeat( Vector(-3,25,33.5), Angle( 0.000000, -90.000000, 2.000000 ), Vector( 0.000000,  80.000000, 10.000000 ), true )
        self:CreateSeat( Vector(3,-32,33.5), Angle( 0.000000, -90.000000, 2.000000 ), Vector( 0.000000, 80.000000, 10.000000 ), true )

		self:SetSpringStrength( 1500 )
        self:SetSpringDamper( 4000 )
        self:SetSuspensionLength ( 7 )
        
        self:SetDifferentialRatio( 1.0 )
        self:SetTransmissionEfficiency( 0.90 )
        self:SetPowerDistribution( -0.25 )
        self:SetBrakePower( 5000 )

        self:SetMinRPM( 700 ) 
        self:SetMaxRPM( 24100 ) 
        self:SetMinRPMTorque( 6000 )
        self:SetMaxRPMTorque( 5500 )

        self:SetMaxSteerAngle( 50 )
        self:SetSteerConeChangeRate( 8 )
        self:SetSteerConeMaxSpeed( 1600 )
        self:SetSteerConeMaxAngle( 0.20 )
		self:SetCounterSteer ( 0.8 )

        self:SetForwardTractionMax( 10000 )
        self:SetForwardTractionBias( 0 )
        self:SetSideTractionMultiplier( 40 )
        self:SetSideTractionMaxAng( 30 )
        self:SetSideTractionMax( 8000 ) 
        self:SetSideTractionMin( 3750 )

		self:SetTurboCharged( false )
		self:SetFastTransmission( true ) 

        self:CreateWheel( Vector( 73.0, 49.0, 15.0  ), {
            model = "models/unitvehiclescars/uv_rhinotruck/uv_rhinotruck_wheel.mdl",
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 0.8, 1, 1 ),
			radius = 20
        } )
        self:CreateWheel( Vector( 73.0, -49.0, 15.0  ), {
            model = "models/unitvehiclescars/uv_rhinotruck/uv_rhinotruck_wheel.mdl",
            modelAngle = Angle( -0.000000, -90.000000, -0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 0.8, 1, 1 ),
			radius = 20
        } )
        self:CreateWheel( Vector( -69.5, 50.0, 15.0 ), {
            model = "models/unitvehiclescars/uv_rhinotruck/uv_rhinotruck_wheel.mdl",
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            modelScale = Vector( 0.8, 1, 1 ),
			radius = 20
        } )
        self:CreateWheel( Vector( -69.5, -50.0, 15.0  ), {
            model = "models/unitvehiclescars/uv_rhinotruck/uv_rhinotruck_wheel.mdl",
            modelAngle = Angle( -0.000000, -90.000000, -0.000000 ),
            modelScale = Vector( 0.8, 1, 1 ),
			radius = 20
            } )

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
        self:SetBodygroup( 4, 1 )
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

        if fronthit then --FRONT
            if speed < 3000 and self.frontdamaged < 1 then
                self:SetBodygroup( 1, 1 )
                self.frontdamaged = 1
            elseif self.frontdamaged < 2 then
                self:SetSubMaterial(16, "models/unitvehiclescars/shared/windowdamage")
                self.frontdamaged = 2
            end
        end

        if rearhit then --REAR
            if self.reardamaged < 1 then
                self:SetSubMaterial(13, "models/unitvehiclescars/shared/windowdamage")
                self.reardamaged = 1
            end
        end

        if lefthit then --LEFT
            if self.leftdamaged < 1 then
                self:SetSubMaterial(14, "models/unitvehiclescars/shared/windowdamage")
                self.leftdamaged = 1
            end
        end

        if righthit then --RIGHT
            if self.rightdamaged < 1 then
                self:SetSubMaterial(15, "models/unitvehiclescars/shared/windowdamage")
                self.rightdamaged = 1
            end
        end

    end
end

function ENT:GetSpawnColor()
    return Color( 255, 255, 255 )
end