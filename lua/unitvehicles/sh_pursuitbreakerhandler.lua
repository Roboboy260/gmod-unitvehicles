AddCSLuaFile()

if SERVER then
    
    local PRELOADED_PURSUITBREAKERS = {}
    
    local function RemovePursuitBreaker(ent)
        
        if not IsValid( ent ) then return end
        
        constraint.RemoveAll( ent )
        
        timer.Simple( 1, function() if (IsValid( ent )) then ent:Remove() end end )
        
        ent:SetNotSolid( true )
        ent:SetMoveType( MOVETYPE_NONE )
        ent:SetNoDraw( true )
        
        local ed = EffectData()
        ed:SetOrigin( ent:GetPos() )
        ed:SetEntity( ent )
        util.Effect( "entity_remove", ed, true, true )
        
    end
    
    function UVSpawnPursuitBreaker(id, checkdistance)
        local pbdata = PRELOADED_PURSUITBREAKERS[id]
        if not pbdata then return end
        
        local location = pbdata.Location or pbdata.Maxs
        local activeduration = pbdata.ActiveDuration or 10
        local dontunweldprops = pbdata.DontUnweldProps or nil
        
        if checkdistance then
            local ply = ents.FindByClass('player')[1]
            local enemylocation
            local suspect = ply
            local suspectlocation = suspect and suspect:GetPos() or vector_origin
            if next(UVWantedTableVehicle) ~= nil then
                local suspects = UVWantedTableVehicle
                local random_entry = math.random(#suspects)	
                suspect = suspects[random_entry]
                enemylocation = (suspect:GetPos()+(vector_up * 50))
            else
                enemylocation = (suspectlocation+(vector_up * 50))
            end
            local distance = enemylocation:DistToSqr(location)
            if distance < 25000000 then
                return
            end
        end
        
        net.Start("UVAddPursuitBreaker")
        net.WriteInt(id, 32)
        net.WriteInt(location.x, 32)
        net.WriteInt(location.y, 32)
        net.WriteInt(location.z, 32)
        net.Broadcast()

        --local entities, constraints = duplicator.Paste( Entity(1), pbdata.Entities, pbdata.Constraints )

        local entities, constraints = {}, {}

        UVLoadedPursuitBreakers[id] = { entities = entities, constraints = constraints }
        UVLoadedPursuitBreakersLoc[id] = location

        for k, ent in pairs( pbdata.Entities ) do
            local entClass = ent.Class
            local entPos = ent.Pos or ent.Maxs
            local entAng = ent.Angle or Angle(0, 0, 0)
            local entModel = ent.Model
           -- print(entClass, entPos, entAng, entModel)

            local gib = ents.Create( entClass )
            if not IsValid( gib ) then continue end

            duplicator.DoGeneric( gib, ent )

            gib:SetPos( Vector(entPos.x, entPos.y, entPos.z) )

            gib:SetAngles( entAng )
            gib:SetModel( entModel )

            gib:Spawn()

            gib.BoneMods = table.Copy( ent.BoneMods )
			gib.EntityMods = table.Copy( ent.EntityMods )
			gib.PhysicsObjects = table.Copy( ent.PhysicsObjects )

            duplicator.ApplyEntityModifiers( Entity(1), gib )
	        duplicator.ApplyBoneModifiers( Entity(1), gib )

            entities[k] = gib

            timer.Simple(0, function()
                if not IsValid(gib) then return end
                
                local phys = gib:GetPhysicsObject()

                if IsValid( phys ) and gib.PhysicsObjects then
                    phys:EnableMotion( not gib.PhysicsObjects[0].Frozen )
                    phys:SetAngles( gib.PhysicsObjects[0].Angle )
                    phys:SetPos( gib.PhysicsObjects[0].Pos )

                    if gib.PhysicsObjects[0].Sleep then
                        phys:Sleep()
                    else
                        phys:Wake()
                    end
                end
            end)

            table.Merge( gib:GetTable(), ent )

            --gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        end

        for _, constraint in pairs( pbdata.Constraints ) do
            -- local constraintType = constraint.Type
            -- local ent1 = constraint.Ent1
            -- local ent2 = constraint.Ent2
            -- local constraintData = constraint.Data or {}
            -- local newConstraint = constraint.Create(constraintType, ent1, ent2, constraintData)
            -- if not newConstraint then continue end
            -- table.insert(constraints, newConstraint)

            local Ent = duplicator.CreateConstraintFromTable( constraint, entities, nil )
            if IsValid( Ent ) then
                table.insert( constraints, Ent )
            end
        end
        
        for k, ent in pairs( entities ) do
            ent.PursuitBreaker = pbdata.jsonfile
            ent.PursuitBreakerID = pbdata.id
            ent.PursuitBreakerLoc = location
            ent.PursuitBreakerData = pbdata
            ent.ActiveDuration = activeduration
            ent.DontUnweldProps = dontunweldprops
            ent:AddCallback("PhysicsCollide", function(ent, data)
                local object = data.HitEntity
                
                if data.Speed > 10 and not object:IsWorld() and not object.PursuitBreaker then
                    if ent.PursuitBreaker then
                        UVTriggerPursuitBreaker(ent, object, data.TheirOldVelocity)

                        local driver = UVGetDriver(object)
                        if driver then
                            local tabledata = {}
                            tabledata.Name = pbdata.jsonfile
                            tabledata.Location = pbdata.Location
                            tabledata.Mins = pbdata.Mins
                            tabledata.Maxs = pbdata.Maxs

                            UVActionCam(driver, "PursuitBreaker", nil, tabledata)
                        end
                    elseif not ent.PursuitBreakerActive then
                        return
                    end
                    
                    local car
                    
                    if object:GetClass() == "gmod_sent_vehicle_fphysics_wheel" then
                        car = object:GetBaseEnt()
                    elseif object.IsSimfphyscar then
                        car = object
                    elseif object.IsGlideVehicle then
                        car = object
                    elseif object:GetClass() == "prop_vehicle_jeep" then
                        car = object
                    end
                    
                    --On first hit
                    if not IsValid(car) then return end

                    local driver = car.UnitVehicle or car.TrafficVehicle
                
                    if driver then
                        UVPlayerWreck(car)
                    end
                    
                end
            end)
        end
        
    end
    
    local function UVSetPhysicsCollisions( ent, collisions )
        
        if ( not IsValid( ent ) or not IsValid( ent:GetPhysicsObject() ) ) then return end
        
        ent:GetPhysicsObject():EnableCollisions( collisions )
        
    end
    
    local function UVRemoveConstraints( ent, const_type )
        if ( not ent.Constraints ) then return end
        
        local c = ent.Constraints
        local i = 0
        
        for k, v in pairs( c ) do
            
            if ( not IsValid( v ) ) then
                
                c[ k ] = nil
                
            elseif ( v.Type == const_type ) then
                
                if v.Ent1:GetClass() == "gmod_thruster" or v.Ent2:GetClass() == "gmod_thruster" then --Ignore thrusters
                    c[ k ] = nil
                else
                    
                    UVSetPhysicsCollisions( v.Ent1, true )
                    UVSetPhysicsCollisions( v.Ent2, true )
                    
                    c[ k ] = nil
                    v:Remove()
                    
                    i = i + 1 
                end
            end
            
        end
        
        if ( table.IsEmpty( c ) ) then
            ent:IsConstrained()
        end
        
        local bool = i ~= 0
        return bool, i
        
    end
    
    function UVTriggerPursuitBreaker(hitent, object, objectvelocity)
        if hitent.PursuitBreakerActive or not hitent.PursuitBreaker then return end
        
        local id = hitent.PursuitBreakerID
        local pbdata = hitent.PursuitBreakerData
        local location = hitent.PursuitBreakerLoc
        local activeduration = hitent.ActiveDuration or 10
        local dontunweldprops = hitent.DontUnweldProps or nil
        local entities = UVLoadedPursuitBreakers[id].entities
        local constraints = UVLoadedPursuitBreakers[id].constraints
        
        hitent.PursuitBreaker = nil
        
        timer.Simple(UVPBCooldown:GetInt(), function()
            UVLoadedPursuitBreakers[id] = nil
            UVLoadedPursuitBreakersLoc[id] = nil
        end)
        
        net.Start("UVTriggerPursuitBreaker")
        net.WriteInt(id, 32)
        net.WriteInt(location.x, 32)
        net.WriteInt(location.y, 32)
        net.WriteInt(location.z, 32)
        net.Broadcast()
        
        local r = math.huge
        local closestdistance, closestbreakableent = r^2
        
        for k, ent in pairs(entities) do
            ent.PursuitBreaker = nil
            ent.PursuitBreakerActive = true
            
            timer.Simple(activeduration, function()
                if IsValid(ent) then
                    ent.PursuitBreakerActive = nil
                end
            end)
            
            timer.Simple(UVPBCooldown:GetInt(), function()
                if IsValid(ent) then
                    ent:Remove()
                end
            end)
            
            if not dontunweldprops then
                UVRemoveConstraints(ent, "Weld") --Unweld everything but thrusters
            end
            
            if ent:GetClass() == "gmod_thruster" then
                ent:SetOn(true)
                ent:StartThrustSound()
            end
            
            if IsValid(ent:GetPhysicsObject()) then
                ent:GetPhysicsObject():EnableMotion(true)
            end
            
            if not (ent:Health() < 1) and ent:GetClass() == "prop_physics" then
                local hitentpos = hitent:WorldSpaceCenter()
                local distance = hitentpos:DistToSqr(ent:WorldSpaceCenter())
                if distance < closestdistance then
                    closestdistance, closestbreakableent = distance, ent
                end
            end
            
        end
        
        local hitentphys = hitent:GetPhysicsObject()
        local phys = object:GetPhysicsObject()
        if objectvelocity and IsValid(phys) and IsValid(hitentphys) then
            hitentphys:SetVelocity(objectvelocity)
            phys:SetVelocity(objectvelocity)
        end
        
        if IsValid(closestbreakableent) then 
            closestbreakableent:Fire("Break") 
        end
        
        local Chatter = GetConVar("unitvehicle_chatter")
        
        --Check if it's a gas station
        if UVTargeting then
            if string.find(pbdata.jsonfile:lower(), "gas") then
                UVSoundChatter(hitent, 1, "pursuitbreakergas", 8)
            else
                if Chatter:GetBool() then
                    local units = ents.FindByClass("npc_uv*")
                    local airUnits = ents.FindByClass("uvair")
                    
                    table.Add( units, airUnits )
                    
                    if next(units) ~= nil then 
                        local randomunit = units[math.random(#units)]
                        UVSoundChatter(randomunit, randomunit.voice, "pursuitbreaker", 4) 
                    end
                    
                end
            end
        end

        return hitent
        
    end
    
    function UVAutoLoadPursuitBreaker()
        if next(PRELOADED_PURSUITBREAKERS) == nil then return end

        local id = math.random( #PRELOADED_PURSUITBREAKERS )
        local pbdata = PRELOADED_PURSUITBREAKERS[id]
        if not pbdata or UVLoadedPursuitBreakers[id] then return end

        UVSpawnPursuitBreaker(id, true)
    end

    function UVPreloadPursuitBreakers()
        PRELOADED_PURSUITBREAKERS = {}

        local mapName = game.GetMap()
        local pursuitBreakers = UV_GetFiles( "pursuitbreakers>>"..mapName )

        for id, jsonfile in pairs(pursuitBreakers) do
            local JSONData = UV_LoadFile( "pursuitbreakers>>"..mapName, jsonfile )
            local pbdata = util.JSONToTable( JSONData or "" , true)
            if pbdata then pbdata.jsonfile = jsonfile pbdata.id = id table.insert( PRELOADED_PURSUITBREAKERS, pbdata ) end
        end
    end

    UVPreloadPursuitBreakers()
    
else

    UVHUDPursuitBreakers = {}

    hook.Add("PostCleanupMap", "UVPBCleanup", function()
        UVHUDPursuitBreakers = {}
    end)
    
    net.Receive("UVAddPursuitBreaker", function()
        local id = net.ReadInt(32)
        local location = Vector(net.ReadInt(32), net.ReadInt(32), net.ReadInt(32))

        table.insert(UVHUDPursuitBreakers, location)

        if GMinimap then
            blip, id = GMinimap:AddBlip( {
                id = "PB"..id,
                position = location,
                icon = "unitvehicles/icons/MINIMAP_ICON_PURSUIT_BREAKER.png",
                scale = 1.5,
                color = Color( 255, 127, 127, 255 ),
                lockIconAng = true
            } )
        end
    end)
    
    net.Receive("UVTriggerPursuitBreaker", function()
        local id = net.ReadInt(32)
        local location = Vector(net.ReadInt(32), net.ReadInt(32), net.ReadInt(32))

        table.RemoveByValue(UVHUDPursuitBreakers, location)

        if GMinimap then
            GMinimap:RemoveBlipById( "PB"..id )
        end
    end)
    
end