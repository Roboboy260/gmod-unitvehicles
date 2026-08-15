AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "Unit Vehicles Police Department"

ENT.PrintName = "#uv.veh.chrbee"

ENT.VehicleName = "uv_chargerbee" -- Change this to the class name of your vehicle
ENT.EntityModelName = "uv_chargerbee" -- Change this to the model name of your vehicle
ENT.GlideCategory = "unitvehiclesglide"
ENT.ChassisModel = string.format( "models/unitvehiclescars/%s/%s.mdl", ENT.VehicleName, ENT.EntityModelName )
ENT.CanSwitchSiren = true

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
            pos = Vector(-110.73,23.95,6.41),ifBodygroupId = 13,
		ang = Angle(180,-180,0),
	},
        {
            pos = Vector(-110.73,-23.95,6.41),ifBodygroupId = 14,
		ang = Angle(180,-180,0),
    },
        {
            pos = Vector(-103.12,23.95,6.41),ifBodygroupId = 13, ifSubModelId = 1,
		ang = Angle(180,-180,0),
	},
        {
            pos = Vector(-103.12,-23.95,6.41),ifBodygroupId = 14, ifSubModelId = 1,
		ang = Angle(180,-180,0),
	},
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector(103.46,0,25.12), angle = Angle(), width = 28 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector(73.97,0,34.79), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector(98.33,33.81,25.32),
            color = Color(255,255,255)
        },
        {
            offset = Vector(98.33,-33.81,25.32),
            color = Color(255,255,255)
        },
    }

    ENT.LightSprites = {
        { type = "headlight", offset = Vector(98.33,33.81,25.32),color = Color(255,255,255), dir = Vector( 1, 0, 0 ),size = 40 },
        { type = "headlight", offset = Vector(98.33,-33.81,25.32),color = Color(255,255,255), dir = Vector( 1, 0, 0 ),size = 40 },

        { type = "headlight", offset = Vector(101.99,27.79,24.44),color = Color(255,255,255), dir = Vector( 1, 0, 0 ),beamType = "high",size = 40 },
        { type = "headlight", offset = Vector(101.99,-27.79,24.44),color = Color(255,255,255), dir = Vector( 1, 0, 0 ),beamType = "high",size = 40 },

        { type = "taillight", offset = Vector(-103.7,26.83,35.59),color = Color(255,0,0,55), dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "taillight", offset = Vector(-103.7,-26.83,35.59),color = Color(255,0,0,55), dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "taillight", offset = Vector(-101.1,32.64,35.34),color = Color(255,0,0,55), dir = Vector( -1, 0, 0 ),size = 25 },
        { type = "taillight", offset = Vector(-101.1,-32.64,35.34),color = Color(255,0,0,55), dir = Vector( -1, 0, 0 ),size = 25 },

        { type = "brake", offset = Vector(-103.7,26.83,35.59),color = Color(255,0,0,150), dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "brake", offset = Vector(-103.7,-26.83,35.59),color = Color(255,0,0,150), dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "brake", offset = Vector(-101.1,32.64,35.34),color = Color(255,0,0,150), dir = Vector( -1, 0, 0 ),size = 25 },
        { type = "brake", offset = Vector(-101.1,-32.64,35.34),color = Color(255,0,0,150), dir = Vector( -1, 0, 0 ),size = 25 },

        { type = "reverse", offset = Vector(-104.09,33.01,30.42), dir = Vector( -1, 0, 0 ),size = 25},
        { type = "reverse", offset = Vector(-104.09,-33.01,30.42), dir = Vector( -1, 0, 0 ),size = 25},

        { type = "signal_left", offset = Vector(103.22,25.1,21.76), dir = Vector( 1, 0, 0 ), color = Color(255, 192, 0), size = 30 },
        { type = "signal_right", offset = Vector(103.22,-25.1,21.76), dir = Vector( 1, 0, 0 ), color = Color(255, 192, 0), size = 30 },

        { type = "signal_left", offset = Vector(-103.7,26.83,35.59),color = Color(255,0,0), dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "signal_right", offset = Vector(-103.7,-26.83,35.59),color = Color(255,0,0), dir = Vector( -1, 0, 0 ),size = 30 },
        { type = "signal_left", offset = Vector(-101.1,32.64,35.34),color = Color(255,0,0), dir = Vector( -1, 0, 0 ),size = 25 },
        { type = "signal_right", offset = Vector(-101.1,-32.64,35.34),color = Color(255,0,0), dir = Vector( -1, 0, 0 ),size = 25 },

    }

    ENT.SirenCycle = 0.3

    ENT.SirenLights = {

        { bodygroup = 18, time = 0, duration = 0.5 },
        { bodygroup = 19, time = 0.5, duration = 0.5 },

    -- WIG-WAG

        { offset = Vector(98.33,33.81,25.32), time = 0, duration = 0.5,  size = 50, color = Color(255,255,255) },
        { offset = Vector(98.33,-33.81,25.32), time = 0.5, duration = 0.5, size = 50, color = Color(255,255,255) },

	-- RED
    
        { offset = Vector(108.35,-10.71,24.35), ifBodygroupId = 1, ifSubModelId = 0, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(109.39,-10.12,23.19), ifBodygroupId = 1, ifSubModelId = 1, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(111.19,-9.39,21.94), ifBodygroupId = 1, ifSubModelId = 2, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },

        { offset = Vector(-113.81,14.67,18.83), ifBodygroupId = 2, ifSubModelId = 0, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-114.9,14.11,17.93), ifBodygroupId = 2, ifSubModelId = 1, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-117.12,12.68,15.63), ifBodygroupId = 2, ifSubModelId = 2, time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },

        { offset = Vector(-16.2,22.25,62.36), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-16.2,15.92,62.36), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-16.2,-22.25,62.36), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-16.2,-15.92,62.36), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-8.54,22.25,62.36), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-8.54,15.92,62.36), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-8.54,-22.25,62.36), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-8.54,-15.92,62.36), time = 0, duration = 0.5, size = 50, color = Color(255,30,0) },
        { offset = Vector(-16.2,22.25,62.36),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { offset = Vector(-16.2,-22.25,62.36),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { offset = Vector(-8.54,22.25,62.36),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },
        { offset = Vector(-8.54,-22.25,62.36),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0, duration = 0.5, size = 180, color = Color(255,30,0) },

	-- BLUE

        { offset = Vector(108.35,10.71,24.35), ifBodygroupId = 1, ifSubModelId = 0, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(108.99,11.08,23.66), ifBodygroupId = 1, ifSubModelId = 1, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(109.95,11.74,22.96), ifBodygroupId = 1, ifSubModelId = 2, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },

        { offset = Vector(-113.81,-14.67,18.83), ifBodygroupId = 2, ifSubModelId = 0, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-113.81,-14.67,18.83), ifBodygroupId = 2, ifSubModelId = 1, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-115.15,-16.06,17.8), ifBodygroupId = 2, ifSubModelId = 2, time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        
        { offset = Vector(-16.2,9.53,62.36), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-16.2,3.24,62.36), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-8.54,9.53,62.36), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-8.54,3.24,62.36), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-16.2,-9.53,62.36), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-16.2,-3.24,62.36), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-8.54,-9.53,62.36), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-8.54,-3.24,62.36), time = 0.5, duration = 0.5, size = 50, color = Color(0,115,255) },
        { offset = Vector(-16.2,0,62.36),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },
        { offset = Vector(-8.54,0,62.36),spriteMaterial = Material( "models/unitvehiclescars/shared/policesprite" ), time = 0.5, duration = 0.5, size = 180, color = Color(0,115,255) },

    }

    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "uvdodgechargerbee" )
    end

    function ENT:OnUpdateMisc()
		local path = "models/unitvehiclescars/uv_chargerbee/"
		local eo, hl, br = self:IsEngineOn(), self:GetHeadlightState(), self:IsBraking()
		BaseClass.OnUpdateMisc( self )

		self:SetSubMaterial(23, "")
		if eo and br then -- Rear Centre Lights
			self:SetSubMaterial(23, path .. "brakelightlit")
		end
	end
end


if SERVER then

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 7, 0, -5 ) )
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
		
		
            [-1] = 3,
            [0] = 0,
            [1] = 3.70,
            [2] = 2.4,
            [3] = 1.6,
            [4] = 1.25,
            [5] = 0.95,
			
        }
		
		
    end

    ENT.LightBodygroups = {
        { type = "brake_or_taillight", bodyGroupId = 15, subModelId = 1 },
        { type = "headlight", bodyGroupId = 16, subModelId = 1 },
        { type = "headlight", bodyGroupId = 17, subModelId = 1,beamType = "high" },
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector(-8.5,18.5,5), Angle( 0.000000, -90.000000, 5.000000 ), Vector( 0.000000,  80.000000, 10.000000 ), true )
        self:CreateSeat( Vector(4,-18.5,9), Angle( 0.000000, -90.000000, 18.000000 ), Vector( 0.000000, -80.000000, 15.000000 ), true )
        self:CreateSeat( Vector(-32,-16,12), Angle( 0.000000, -90.000000, 18.000000 ), Vector( 0.000000, -80.000000, 15.000000 ), true )
        self:CreateSeat( Vector(-32,16,12), Angle( 0.000000, -90.000000, 18.000000 ), Vector( 0.000000, -80.000000, 15.000000 ), true )

        self:SetSuspensionLength( 7 )
        self:SetSpringStrength( 1000 )
        self:SetSpringDamper( 3000 )

        self:SetDifferentialRatio( 1.00 )
        self:SetTransmissionEfficiency( 0.80 )
        self:SetPowerDistribution( -0.90 )
        self:SetBrakePower( 3000 )
        
        self:SetMinRPM( 800 ) 
        self:SetMaxRPM( 19000 ) 
        self:SetMinRPMTorque( 5200 )
        self:SetMaxRPMTorque( 4900 )
        
        self:SetMaxSteerAngle( 45 )
        self:SetSteerConeChangeRate( 8 )
        self:SetSteerConeMaxSpeed( 1800 )
        self:SetSteerConeMaxAngle( 0.25 )
		self:SetCounterSteer ( 0.8 )
        
        self:SetForwardTractionMax( 7000 )
        self:SetForwardTractionBias( 0 )
        self:SetSideTractionMultiplier( 30 )
        self:SetSideTractionMaxAng( 30 )
        self:SetSideTractionMax( 5000 ) 
        self:SetSideTractionMin( 2250 )

		self:SetTurboCharged( false )
		self:SetFastTransmission( true ) 

        self:CreateWheel( Vector(72.5,34.8,13.3), {
            model = "models/unitvehiclescars/uv_chargerbee/uv_chargerbee_wheel.mdl",
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 1, 1, 1 ),
			radius = 16.6
        } )
        self:CreateWheel( Vector(72.5,-34.8,13.3), {
            model = "models/unitvehiclescars/uv_chargerbee/uv_chargerbee_wheel.mdl",
            modelAngle = Angle( 0.000000, -90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 1, 1, 1 ),
			radius = 16.6
        } )
        self:CreateWheel( Vector(-65,35,13.3), {
            model = "models/unitvehiclescars/uv_chargerbee/uv_chargerbee_wheel.mdl",
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            modelScale = Vector( 1, 1, 1 ),
			radius = 16.6
        } )
        self:CreateWheel( Vector(-65,-35,13.3), {
            model = "models/unitvehiclescars/uv_chargerbee/uv_chargerbee_wheel.mdl",
            modelAngle = Angle( 0.000000, -90.000000, 0.000000 ),
            modelScale = Vector( 1, 1, 1 ),
			radius = 16.6
        } )

    end
    
    function ENT:OnPostThink( dt, selfTbl ) --Changing submaterials/bodygroups for the entire vehicle
        BaseClass.OnPostThink( self, dt, selfTbl )

        --Hood detachment when driving at high speeds
        if self:GetVelocity():LengthSqr() > 4000000 and self:GetBodygroup( 5 ) == 2 then
            local gibmodels = {
                "models/unitvehiclescars/uv_chargerbee/hood.mdl",
            }
            timer.Simple(0, function()
                self:DetachGibs(gibmodels, true)
            end)
            self:SetBodygroup( 5, 3 )
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
        self:SetBodygroup( 9, 0 )
        self:SetBodygroup( 10, 0 )
        self:SetBodygroup( 11, 0 )
        self:SetBodygroup( 12, 0 )
        self:SetBodygroup( 13, 0 )
        self:SetBodygroup( 14, 0 ) 

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
        self:SetBodygroup( 20, 1 )
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
            self:SetSubMaterial(12, "models/unitvehiclescars/uv_chargerbee/skin_0dam")
        end

        if fronthit then --FRONT
            if speed < 3000 and self.frontdamaged < 1 then
                self:SetBodygroup( 1, 1 )
                self:SetBodygroup( 3, 1 )
                self:SetBodygroup( 4, 1 )
                self:SetBodygroup( 5, 1 )
                self.frontdamaged = 1
            elseif self.frontdamaged < 2 then
                self:SetBodygroup( 1, 2 )
                self:SetBodygroup( 3, 2 )
                self:SetBodygroup( 4, 2 )
                self:SetBodygroup( 5, 2 )
                self.frontdamaged = 2
            elseif self.frontdamaged < 3 then
                self:SetBodygroup( 1, 3 )
                self:SetBodygroup( 3, 2 )
                self:SetBodygroup( 4, 2 )
                self:SetSubMaterial(7, "models/unitvehiclescars/shared/windowdamage")
                local gibmodels = {
                    "models/unitvehiclescars/uv_chargerbee/frbumper.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.frontdamaged = 3
            elseif self.frontdamaged < 4 then
                self:SetSubMaterial(7, "models/unitvehiclescars/shared/windowdamage1")
                self.frontdamaged = 4
            end
        end

        if rearhit then --REAR
            if self.reardamaged < 1 then
                self:SetBodygroup( 2, 1 )
                self:SetBodygroup( 12, 1 )
                self:SetBodygroup( 13, 1 )
                local gibmodels = {
                    "models/unitvehiclescars/uv_chargerbee/exhaust.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.reardamaged = 1
            elseif self.reardamaged < 2 then
                self:SetBodygroup( 2, 2 )
                self:SetBodygroup( 12, 2 )
                self:SetBodygroup( 13, 1 )
                self:SetBodygroup( 14, 1 )
                local gibmodels = {
                    "models/unitvehiclescars/uv_chargerbee/spoiler.mdl",
                    "models/unitvehiclescars/uv_chargerbee/exhaust_1.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.reardamaged = 2
            elseif self.reardamaged < 3 then
                self:SetBodygroup( 2, 3 )
                self:SetBodygroup( 12, 2 )
                self:SetBodygroup( 13, 1 )
                self:SetBodygroup( 14, 1 )
                self:SetSubMaterial(8, "models/unitvehiclescars/shared/windowdamage")
                local gibmodels = {
                    "models/unitvehiclescars/uv_chargerbee/rebumper.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.reardamaged = 3
            elseif self.reardamaged < 4 then
                self:SetBodygroup( 2, 3 )
                self:SetBodygroup( 12, 2 )
                self:SetBodygroup( 13, 1 )
                self:SetBodygroup( 14, 1 )
                self:SetSubMaterial(8, "models/unitvehiclescars/shared/windowdamage1")
                self:SetSubMaterial(9, "models/unitvehiclescars/shared/windowdamage1")
                self.reardamaged = 4
            end
        end

        if lefthit then --LEFT
            if self.leftdamaged < 1 then
                self:SetBodygroup( 6, 1 )
                self:SetBodygroup( 8, 1 )
                self:SetBodygroup( 10, 0 )
                self.leftdamaged = 1
            elseif self.leftdamaged < 2 then
                self:SetBodygroup( 6, 2 )
                self:SetBodygroup( 8, 2 )
                self:SetBodygroup( 10, 1 )
                self:SetSubMaterial(18, "models/unitvehiclescars/shared/windowdamage")
                self:SetSubMaterial(20, "models/unitvehiclescars/shared/windowdamage")
                local gibmodels = {
                    "models/unitvehiclescars/uv_chargerbee/mirrorleft.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.leftdamaged = 2
                            elseif self.leftdamaged < 3 then
                self:SetBodygroup( 6, 2 )
                self:SetBodygroup( 8, 2 )
                self:SetBodygroup( 10, 1 )
                self:SetSubMaterial(18, "models/unitvehiclescars/shared/windowdamage", "models/unitvehiclescars/shared/windowdamage1")
                self:SetSubMaterial(20, "models/unitvehiclescars/shared/windowdamage1")
                self.leftdamaged = 3
            end
        end

        if righthit then --RIGHT
            if self.rightdamaged < 1 then
                self:SetBodygroup( 7, 1 )
                self:SetBodygroup( 9, 1 )
                self:SetBodygroup( 11, 0 )
                self.rightdamaged = 1
            elseif self.rightdamaged < 2 then
                self:SetBodygroup( 7, 2 )
                self:SetBodygroup( 9, 2 )
                self:SetBodygroup( 11, 1 )
                self:SetSubMaterial(19, "models/unitvehiclescars/shared/windowdamage")
                self:SetSubMaterial(21, "models/unitvehiclescars/shared/windowdamage")
                local gibmodels = {
                    "models/unitvehiclescars/uv_chargerbee/mirrorright.mdl",
                }
                timer.Simple(0, function()
                    self:DetachGibs(gibmodels)
                end)
                self.rightdamaged = 2
                            elseif self.rightdamaged < 3 then
                self:SetBodygroup( 7, 2 )
                self:SetBodygroup( 9, 2 )
                self:SetBodygroup( 11, 1 )
                self:SetSubMaterial(19, "models/unitvehiclescars/shared/windowdamage1")
                self:SetSubMaterial(21, "models/unitvehiclescars/shared/windowdamage1")
                self.rightdamaged = 3
            end
        end


    end
end

function ENT:GetSpawnColor()
    return Color(255, 255, 255)
end

function ENT:GetFirstPersonOffset( _, localEyePos )
    if self:GetDriver() == LocalPlayer() then
        return Vector(-2,18.5,45)
    else return localEyePos
    end
end