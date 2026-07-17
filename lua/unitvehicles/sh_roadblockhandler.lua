AddCSLuaFile()

if SERVER then

	local PRELOADED_ROADBLOCKS = {}
	
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
	
	local function RemoveRoadblock(ent)
		
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
	
	function UVSpawnRoadblock(id, manual)
		local rbdata = PRELOADED_ROADBLOCKS[id]
		if not rbdata then return end
		
		local location = rbdata.Location or rbdata.Maxs
		local angles = rbdata.Angle or angle_zero
		local disperse = rbdata.DisperseAfterPassing
		local rhino = math.random(1,2) == 1 and true or false
		
		if UVRBOverride:GetInt() == 1 then
			disperse = true
		elseif UVRBOverride:GetInt() >= 2 then
			disperse = false
		end
		
		if not manual then
			if UVHeatLevel < MaxHeatLevel:GetInt() and UVHeatLevel < rbdata.HeatLevel then return end
		end
		
		local gib
		if not manual then
			gib = ents.Create("prop_physics") --Cooldown
			gib:SetModel("models/props_phx/misc/gibs/egg_piece1.mdl")
			gib:SetPos(location)
			gib:SetAngles(angles)
			gib:Spawn()
			gib.PhysgunDisabled = false
			gib:GetPhysicsObject():EnableMotion(false)
			gib:SetCollisionGroup(10)
			gib:SetColor(Color(255,255,255,0))

			net.Start("UVHUDAddUV")
			net.WriteInt(gib:EntIndex(), 32)
			net.WriteInt(gib:GetCreationID(), 32)
			net.WriteString("roadblock")
			net.Broadcast()
			
			timer.Simple(10, function()
				local Index = gib:EntIndex()
				timer.Create("uvroadblockmarkedfordeletion"..Index, 1, 0, function()
					if IsValid(gib) then
						local closestsuspect
						local closestdistancetosuspect
						local suspects = UVWantedTableVehicle
						local r = math.huge
						local closestdistancetosuspect, closestsuspect = r^2
						for i, w in pairs(suspects) do
							local gibpos = gib:WorldSpaceCenter()
							local distance = gibpos:DistToSqr(w:WorldSpaceCenter())
							if distance < closestdistancetosuspect then
								closestdistancetosuspect, closestsuspect = distance, w
							end
						end
						if closestdistancetosuspect > 100000000 and IsValid(gib) or not UVTargeting then
							gib:Remove()
							timer.Remove("uvroadblockmarkedfordeletion"..Index)
							UVRoadblocksDodged = UVRoadblocksDodged + 1
							UVLoadedRoadblocks[id] = nil
							UVLoadedRoadblocksLoc[id] = nil
						end
					end
				end) 
			end)

			UVLoadedRoadblocks[id] = true
			UVLoadedRoadblocksLoc[id] = location
		end
		
		--local entities, constraints = duplicator.Paste( nil, rbdata.Entities, rbdata.Constraints )

		local entities, constraints = {}, {}

        for k, ent in pairs( rbdata.Entities ) do
            local entClass = ent.Class
            local entPos = ent.Pos or ent.Maxs
            local entAng = ent.Angle or Angle( 0, 0, 0 )
            local entModel = ent.Model

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

            entities[k] = gib

            timer.Simple(0, function()
                if not IsValid( gib ) then return end
                
                local phys = gib:GetPhysicsObject()

                if IsValid( phys ) and gib.PhysicsObjects then
                    phys:EnableMotion( true )
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
        end

        for _, constraint in pairs( rbdata.Constraints ) do
            local Ent = duplicator.CreateConstraintFromTable( constraint, entities, nil )
            if IsValid( Ent ) then
                table.insert( constraints, Ent )
            end
        end
		
		for k, ent in pairs( entities ) do
			ent.UVRoadblock = ent
			ent.RoadblockLoc = location
			ent.Disperse = disperse
			ent.Rhino = rhino
			UVRemoveConstraints( ent, "Weld" )
			if ent:GetClass() ~= "entity_uvroadblockcar" then
				ent:GetPhysicsObject():EnableMotion( true )
			end
			if not manual then
				timer.Simple(10, function()
					local Index = ent:EntIndex()
					timer.Create("uvroadblockmarkedfordeletion"..Index, 1, 0, function() 
						if not IsValid(gib) or not UVTargeting then
							if IsValid(ent) then
								ent:Remove()
								if ent:GetClass() == "entity_uvspikestrip" then
									UVSpikestripsDodged = UVSpikestripsDodged + 1
								end
							end
							timer.Remove("uvroadblockmarkedfordeletion"..Index)
						end
					end)
				end)
			end
		end
		
		return jsonfile
		
	end
	
	function UVAutoLoadRoadblock()
		if next(UVWantedTableVehicle) == nil then return end
		if next(PRELOADED_ROADBLOCKS) == nil then return end

		local randomSuspect = math.random( #UVWantedTableVehicle )
		local suspect = UVGetRaceLeader() or UVWantedTableVehicle[randomSuspect]
		local suspectVelocity = suspect:GetVelocity()
		local suspectPos = suspect:GetPos()
		local suspectLocation = suspectPos + ( vector_up * 50 )

		local availablerbs = {}

		for id, rbdata in pairs( PRELOADED_ROADBLOCKS ) do
			local location = rbdata.Location or rbdata.Maxs
			local enemylocation = suspectLocation
			local distance = enemylocation - location
			local vect = distance:GetNormalized()
			local evectdot = vect:Dot(suspectVelocity)
			local distSqr = distance:LengthSqr()
			if not (distSqr < 25000000 or distSqr > 100000000 or evectdot > 0) and not UVLoadedRoadblocks[id] then
				table.insert(availablerbs, id)
			end
		end

		if not next(availablerbs) ~= nil then
			return UVSpawnRoadblock( availablerbs[math.random(1, #availablerbs)] )
		end
		
	end

	function UVPreloadRoadblocks()
		PRELOADED_ROADBLOCKS = {}

		local mapName = game.GetMap()
		local roadblocks = UV_GetFiles( "roadblocks>>"..mapName )

		for _, jsonfile in ipairs(roadblocks) do
			local json  = UV_LoadFile( "roadblocks>>"..mapName, jsonfile )
			local rbdata = util.JSONToTable( json or "", true )
			if rbdata then table.insert( PRELOADED_ROADBLOCKS, rbdata ) end
		end
	end

	UVPreloadRoadblocks()
	
else
	
end