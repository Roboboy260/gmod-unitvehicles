local dvd = DecentVehicleDestination

local POLICE_SPAWN_DIST_FAR_SQ   = 25000000
local POLICE_SPAWN_DIST_MAX_SQ   = 100000000
local POLICE_SPAWN_MAX_CANDIDATES = 64

--SIMFPHYS ONLY--

local function ValidateModel( model )
	local v_list = list.Get( "simfphys_vehicles" )
	for listname, _ in pairs( v_list ) do
		if v_list[listname].Members.CustomWheels then
			local FrontWheel = v_list[listname].Members.CustomWheelModel
			local RearWheel = v_list[listname].Members.CustomWheelModel_R
			
			if FrontWheel then 
				FrontWheel = string.lower( FrontWheel )
			end
			
			if RearWheel then 
				RearWheel = string.lower( RearWheel )
			end
			
			if model == FrontWheel or model == RearWheel then
				return true
			end
		end
	end
	
	local list = list.Get( "simfphys_Wheels" )[model]
	
	if list then 
		return true
	end
	
	return false
end

local function GetRight( ent, index, WheelPos )
	local Steer = ent:GetTransformedDirection()
	
	local Right = ent.Right
	
	if WheelPos.IsFrontWheel then
		Right = (IsValid( ent.SteerMaster ) and Steer.Right or ent.Right) * (WheelPos.IsRightWheel and 1 or -1)
	else
		Right = (IsValid( ent.SteerMaster ) and Steer.Right2 or ent.Right) * (WheelPos.IsRightWheel and 1 or -1)
	end
	
	return Right
end

local function SetWheelOffset( ent, offset_front, offset_rear )
	if not IsValid( ent ) then return end
	
	ent.WheelTool_Foffset = offset_front
	ent.WheelTool_Roffset = offset_rear
	
	if not istable( ent.Wheels ) or not istable( ent.GhostWheels ) then return end
	
	for i = 1, table.Count( ent.GhostWheels ) do
		local Wheel = ent.Wheels[ i ]
		local WheelModel = ent.GhostWheels[i]
		local WheelPos = ent:LogicWheelPos( i )
		
		if IsValid( Wheel ) and IsValid( WheelModel ) then
			local Pos = Wheel:GetPos()
			local Right = GetRight( ent, i, WheelPos )
			local offset = WheelPos.IsFrontWheel and offset_front or offset_rear
			
			WheelModel:SetParent( nil )
			
			local physObj = WheelModel:GetPhysicsObject()
			if IsValid( physObj ) then
				physObj:EnableMotion( false )
			end
			
			WheelModel:SetPos( Pos + Right * offset )
			WheelModel:SetParent( Wheel )
		end
	end
end

local function ApplyWheel(ent, data)
	ent.CustomWheelAngleOffset = data[2]
	ent.CustomWheelAngleOffset_R = data[4]
	
	timer.Simple( 0.05, function()
		if not IsValid( ent ) then return end
		for i = 1, table.Count( ent.GhostWheels ) do
			local Wheel = ent.GhostWheels[i]
			
			if IsValid( Wheel ) then
				local isfrontwheel = (i == 1 or i == 2)
				local swap_y = (i == 2 or i == 4 or i == 6)
				
				local angleoffset = isfrontwheel and ent.CustomWheelAngleOffset or ent.CustomWheelAngleOffset_R
				
				local model = isfrontwheel and data[1] or data[3]
				
				local fAng = ent:LocalToWorldAngles( ent.VehicleData.LocalAngForward )
				local rAng = ent:LocalToWorldAngles( ent.VehicleData.LocalAngRight )
				
				local Forward = fAng:Forward() 
				local Right = swap_y and -rAng:Forward() or rAng:Forward()
				local Up = ent:GetUp()
				
				local Camber = data[5] or 0
				
				local ghostAng = Right:Angle()
				local mirAng = swap_y and 1 or -1
				ghostAng:RotateAroundAxis(Forward,angleoffset.p * mirAng)
				ghostAng:RotateAroundAxis(Right,angleoffset.r * mirAng)
				ghostAng:RotateAroundAxis(Up,-angleoffset.y)
				
				ghostAng:RotateAroundAxis(Forward, Camber * mirAng)
				
				Wheel:SetModelScale( 1 )
				Wheel:SetModel( model )
				Wheel:SetAngles( ghostAng )
				
				timer.Simple( 0.05, function()
					if not IsValid(Wheel) or not IsValid( ent ) then return end
					local wheelsize = Wheel:OBBMaxs() - Wheel:OBBMins()
					local radius = isfrontwheel and ent.FrontWheelRadius or ent.RearWheelRadius
					local size = (radius * 2) / math.max(wheelsize.x,wheelsize.y,wheelsize.z)
					
					Wheel:SetModelScale( size )
				end)
			end
		end
	end)
end

local function GetAngleFromSpawnlist( model )
	if not model then PrintMessage( HUD_PRINTTALK, "invalid model") return Angle(0,0,0) end
	
	model = string.lower( model )
	
	local v_list = list.Get( "simfphys_vehicles" )
	for listname, _ in pairs( v_list ) do
		if v_list[listname].Members.CustomWheels then
			local FrontWheel = v_list[listname].Members.CustomWheelModel
			local RearWheel = v_list[listname].Members.CustomWheelModel_R
			
			if FrontWheel then 
				FrontWheel = string.lower( FrontWheel )
			end
			
			if RearWheel then 
				RearWheel = string.lower( RearWheel )
			end
			
			if model == FrontWheel or model == RearWheel then
				local Angleoffset = v_list[listname].Members.CustomWheelAngleOffset
				if (Angleoffset) then
					return Angleoffset
				end
			end
		end
	end
	
	local list = list.Get( "simfphys_Wheels" )[model]
	local output = list and list.Angle or Angle(0,0,0)
	
	return output
end

function UVGetRandom( pool )
	local totalWeight = 0

	for _, selection in pairs( pool ) do
		totalWeight = totalWeight + selection.weight
	end

	local random = math.random( 1, totalWeight )
	local counter = 0

	for _, selection in pairs( pool ) do
		counter = counter + selection.weight
		if random <= counter then
			return selection
		end
	end

	return nil
end

function UVCountActiveUnits( class )
	local count = 0
	for _, ent in pairs( ents.FindByClass( class ) ) do
		if IsValid( ent ) and ent.v and not ent.v.roadblocking and not ent.v.rhino then
			count = count + 1
		end
	end
	return count
end

function UVCountActiveRhinos() -- Rhino Unit is npc_uvspecial with self.v.rhino tag
	local count = 0
	for _, ent in pairs( ents.FindByClass( "npc_uvspecial" ) ) do
		if IsValid( ent ) and ent.v and ent.v.rhino then
			count = count + 1
		end
	end
	return count
end

function UVGetRandomUnit( heat, modifiers )
	heat = heat or UVHeatLevel

	if heat <= 1 then
		heat = 1
	elseif heat > MAX_HEAT_LEVEL then
		heat = MAX_HEAT_LEVEL
	end

	local appliedunits, uvnextclasstospawn

	--FIND UNITS
	-- local givenunitstable
	-- local givenclasses = {
	-- 	"npc_uvpatrol",
	-- 	"npc_uvsupport",
	-- 	"npc_uvpursuit",
	-- 	"npc_uvinterceptor",
	-- 	"npc_uvspecial",
	-- 	"npc_uvcommander",
	-- }

	-- local availableunitstable = {}
	-- local availableclasses = {}
	-- local availablechances = {}

	-- local UnitsPatrol = string.Trim( GetConVar( 'unitvehicle_unit_unitspatrol' .. heat ):GetString() )
	-- local UnitsSupport = string.Trim( GetConVar( 'unitvehicle_unit_unitssupport' .. heat ):GetString() )
	-- local UnitsPursuit = string.Trim( GetConVar( 'unitvehicle_unit_unitspursuit' .. heat ):GetString() )
	-- local UnitsInterceptor = string.Trim( GetConVar( 'unitvehicle_unit_unitsinterceptor' .. heat ):GetString() )
	-- local UnitsSpecial = string.Trim( GetConVar( 'unitvehicle_unit_unitsspecial' .. heat ):GetString() )
	-- local UnitsCommander = string.Trim( GetConVar( 'unitvehicle_unit_unitscommander' .. heat ):GetString() )
	-- local UnitsRhino = string.Trim( GetConVar( 'unitvehicle_unit_unitsrhino' .. heat ):GetString() )

	-- local UnitsPatrolChance = GetConVar( 'unitvehicle_unit_unitspatrol' .. heat .. '_chance' ):GetInt()
	-- local UnitsSupportChance = GetConVar( 'unitvehicle_unit_unitssupport' .. heat .. '_chance' ):GetInt()
	-- local UnitsPursuitChance = GetConVar( 'unitvehicle_unit_unitspursuit' .. heat .. '_chance' ):GetInt()
	-- local UnitsInterceptorChance = GetConVar( 'unitvehicle_unit_unitsinterceptor' .. heat .. '_chance' ):GetInt()
	-- local UnitsSpecialChance = GetConVar( 'unitvehicle_unit_unitsspecial' .. heat .. '_chance' ):GetInt()
	-- local UnitsCommanderChance = GetConVar( 'unitvehicle_unit_unitscommander' .. heat .. '_chance' ):GetInt()
	-- local UnitsRhinoChance = GetConVar( 'unitvehicle_unit_unitsrhino' .. heat .. '_chance' ):GetInt()

	local selectionPool = {}

	-- if UVOneCommanderActive or UVOneCommanderDeployed or posspecified or (UVUnitsHavePlayers and not playercontrolled) then
	-- 	UnitsCommander = ""
	-- 	UnitsCommanderChance = nil
	-- end

	-- if UVEnemyEscaping then
	-- 	UnitsRhino = nil
	-- 	UnitsCommanderChance = nil
	-- end

	modifiers = type(modifiers) == 'table' and modifiers or {}

	local rhinoConVarKey = string.format( 'unitvehicle_unit_unitsrhino%s', heat )
	local rhinoCollection = GetConVar( rhinoConVarKey ):GetString()
	local isRhinoEnabled = not string.match( rhinoCollection, "^%s*$" )

	modifiers.rhinoattack = modifiers.rhinoattack and isRhinoEnabled

	for _, v in pairs( {'Patrol', 'Support', 'Pursuit', 'Interceptor', 'Special', 'Commander', 'Rhino'} ) do
		local unitConVarKey = string.format( 'unitvehicle_unit_units%s%s', string.lower(v), heat )
		local chanceConVarKey = unitConVarKey .. '_chance'
		local limitConvarKey = unitConVarKey .. '_limit'
		local rhinolimitConvarKey = rhinoConVarKey .. '_limit'
		local npcClassName = 'npc_uv' .. string.lower(v)

		local limit = GetConVar( limitConvarKey ):GetInt()
		local rhinolimit = GetConVar( rhinolimitConvarKey ):GetInt()

		if modifiers then
			if v == 'Rhino' then
				if modifiers.posspecified and not modifiers.rhinoattack then continue end
				if not modifiers.posspecified and rhinolimit ~= 0 and rhinolimit <= UVCountActiveRhinos() then continue end
				if UVEnemyEscaping then continue end
			end

			if v == 'Commander' then
				if UVOneCommanderActive or UVOneCommanderDeployed or modifiers.posspecified or (UVUnitsHavePlayers and not modifiers.playercontrolled) then continue end
			end

			if modifiers.rhinoattack then
				if v ~= 'Rhino' then continue end
 			end
		end

		local unitCollection = GetConVar( unitConVarKey ):GetString()
		if string.match( unitCollection, "^%s*$" ) then continue end

		if limit ~= 0 and limit <= UVCountActiveUnits( npcClassName ) and not modifiers.posspecified then continue end
		
		table.insert(selectionPool, {
			name = string.lower(v),
			weight = GetConVar( chanceConVarKey ):GetInt(),
			limit = GetConVar( limitConvarKey ):GetInt(),
			units = string.Trim( GetConVar( unitConVarKey ):GetString() ),
			npc = npcClassName
		})
	end

	return { UVGetRandom( selectionPool ), modifiers }
end

function UVCreateEntitiesFromTable( EntityTable, localpos, localang )
	local Entities = {}

	for entityId, entityArray in pairs( EntityTable ) do
		local Ent = ents.Create( entityArray.Class )
		duplicator.DoGeneric( Ent, entityArray )

		Ent:Spawn()
		Ent:Activate()

		duplicator.DoGenericPhysics( Ent, nil, entityArray )

		table.Merge( Ent:GetTable(), entityArray )
		
		if ( Ent.RestoreNetworkVars ) then
			Ent:RestoreNetworkVars( entityArray.DT )
		end
		
		if ( Ent.OnDuplicated ) then
			Ent:OnDuplicated( entityArray )
		end
		
		Entities[entityId] = Ent
		
		if Entities[entityId] then
			Entities[entityId].BoneMods = table.Copy( entityArray.BoneMods )
			Entities[entityId].EntityMods = table.Copy( entityArray.EntityMods )
			Entities[entityId].PhysicsObjects = table.Copy( entityArray.PhysicsObjects )
		end
	end

	for entityId, Ent in pairs( Entities ) do
		duplicator.ApplyEntityModifiers( nil, Ent )
		duplicator.ApplyBoneModifiers( nil, Ent )
	end

	return Entities
end

function UVCreateConstraintsFromTable( Constraint, EntityList )

	local Factory = duplicator.ConstraintType[ Constraint.Type ]
	if not Factory then return end

	local args = {}
	for k, key in pairs( Factory.Args ) do

		local val = Constraint[ key ]

		for i = 1, 6 do

			if ( Constraint.Entity[ i ] ) then

				if ( key == "Ent" .. i ) then
					val = EntityList[ Constraint.Entity[ i ].Index ]
					if ( Constraint.Entity[ i ].World ) then
						val = game.GetWorld()
					end
				end

				if ( key == "Bone" .. i ) then val = Constraint.Entity[ i ].Bone or 0 end
				if ( key == "LPos" .. i ) then val = Constraint.Entity[ i ].LPos end
				if ( key == "WPos" .. i ) then val = Constraint.Entity[ i ].WPos end
				if ( key == "Length" .. i ) then val = Constraint.Entity[ i ].Length or 0 end

			end
		end

		-- -- A little hack to give the duped constraints the correct player object
		-- if ( key:lower() == "pl" or key:lower() == "ply" or key:lower() == "player" ) then val = ply end

		-- If there's a missing argument then unpack will stop sending at that argument
		if ( val == nil ) then val = false end

		table.insert( args, val )

	end

	-- Pulley, Hydraulic can return up to 4 ents
	local const1, const2, const3, const4 = Factory.Func( unpack( args ) )

	-- Hacky way to determine if the constraint is a rope one, since we have no better way
	local function IsRopeConstraint( ent ) return ent and ent:GetClass() == "keyframe_rope" end
	local isRope = IsRopeConstraint( const1 ) || IsRopeConstraint( const2 ) || IsRopeConstraint( const3 ) || IsRopeConstraint( const4 )
	local constraintType = isRope and "ropeconstraints" or "constraints"

	return const1, const2, const3, const4

end

--(Player, boolean)
function UVAutoSpawn(ply, rhinoattack, helicopter, playercontrolled, commanderrespawn, posspecified, angles, disperse)
	
	if playercontrolled then
		if not ply then
			ply = Entity(1)
		end
	end
	
	local uvnextclasstospawn
	local enemylocation
	local suspect
	local suspectvelocity = Vector(0,0,0)
	-- local suspect = ply
	-- if next(UVPotentialSuspects) ~= nil then
	-- 	local suspects = UVPotentialSuspects
	-- 	local random_entry = math.random(#suspects)	
	-- 	suspect = UVGetRaceLeader() or suspects[random_entry]
	-- 	enemylocation = (suspect:GetPos()+ (vector_up * 50))
	-- else
	-- 	enemylocation = (suspect:GetPos()+ (vector_up * 50))
	-- end

	if next(dvd.Waypoints) == nil then
		if not UVNoDVWaypointsNotify then
			net.Start("UV_OpenDVWarning")
			net.Broadcast()
		end
		return
	end
	UVNoDVWaypointsNotify = nil

	if next(dvd.Waypoints) == nil then
		net.Start("UV_OpenDVWarning")
		net.Broadcast() -- or target a specific player
		return
	end

	local waypointLookup = true

	if next(UVPotentialSuspects) ~= nil then
		local suspects = UVPotentialSuspects
		local random_entry = math.random(#suspects)
		suspect = UVGetRaceLeader() or suspects[random_entry]
		
		enemylocation = (suspect:GetPos() + Vector(0, 0, 50))
		suspectvelocity = suspect:GetVelocity()
	elseif not playercontrolled then
		waypointLookup = false
		uvspawnpointwaypoint = dvd.Waypoints[math.random(#dvd.Waypoints)]
		uvspawnpoint = uvspawnpointwaypoint["Target"]
	else
		enemylocation = ply:GetPos() + Vector(0, 0, 50)
	end

	if waypointLookup then
		local enemywaypoint = dvd.GetNearestWaypoint(enemylocation)
		local enemywaypointgroup = UVTargeting and enemywaypoint["Group"] or 0

		local waypointtable = {}
		local prioritywaypointtable = {}
		local prioritywaypointtable2 = {}
		local prioritywaypointtable3 = {}
	
		local candidates = {}
		
		for k, v in ipairs( dvd.Waypoints ) do
			local Waypoint = v.Target
			local delta = enemylocation - Waypoint
			local distSq = delta:LengthSqr()
			if distSq <= POLICE_SPAWN_DIST_FAR_SQ or distSq >= POLICE_SPAWN_DIST_MAX_SQ then
				continue
			end
			
			if v.Group ~= enemywaypointgroup then
				table.insert( waypointtable, v )
				continue
			end
			
			local vect = delta:GetNormalized()
			local evectdot = vect:Dot( suspectvelocity )
			
			if evectdot < 0 then
				table.insert( candidates, { wp = v, distSq = distSq, score = -evectdot * distSq } )
			else
				table.insert( candidates, { wp = v, distSq = distSq, score = distSq } )
			end
		end
	
		table.sort( candidates, function(a, b) return a.score < b.score end )
		
		for i = 1, math.min( #candidates, POLICE_SPAWN_MAX_CANDIDATES ) do
			local v = candidates[i].wp
			local Waypoint = v.Target
			if UVStraightToWaypoint( enemylocation, Waypoint ) then
				local delta = enemylocation - Waypoint
				local vect = delta:GetNormalized()
				local evectdot = vect:Dot( suspectvelocity )
				
				if evectdot < 0 then
					table.insert( prioritywaypointtable, v )
				else
					table.insert( prioritywaypointtable2, v )
				end
			else
				table.insert( prioritywaypointtable3, v )
			end
		end
	
		if next(prioritywaypointtable) ~= nil then
			uvspawnpointwaypoint = prioritywaypointtable[math.random(#prioritywaypointtable)]
			uvspawnpoint = uvspawnpointwaypoint["Target"]
		elseif next(prioritywaypointtable3) ~= nil then
			uvspawnpointwaypoint = prioritywaypointtable3[math.random(#prioritywaypointtable3)]
			uvspawnpoint = uvspawnpointwaypoint["Target"]
		elseif next(waypointtable) ~= nil then
			uvspawnpointwaypoint = waypointtable[math.random(#waypointtable)]
			uvspawnpoint = uvspawnpointwaypoint["Target"]
		else
			uvspawnpointwaypoint = dvd.Waypoints[math.random(#dvd.Waypoints)]
			uvspawnpoint = uvspawnpointwaypoint["Target"]
		end	
	end

	local neighbor = dvd.Waypoints[uvspawnpointwaypoint.Neighbors[math.random(#uvspawnpointwaypoint.Neighbors)]]

	if neighbor then
		local neighborpoint = neighbor["Target"]
		local neighbordistance = neighborpoint - uvspawnpoint
		uvspawnpointangles = neighbordistance:Angle()+Angle(0,180,0)
	else
		uvspawnpointangles = Angle(0,math.random(0,360),0)
	end

	if helicopter then
		local heli = ents.Create("uvair")
		heli:SetPos(uvspawnpoint + (vector_up * 1000))
		heli:SetAngles(Angle(0, math.random(-180, 180), 0))
		heli:Spawn()
		heli:Activate()
		return
	end
	
	local vehiclebase = UVUVehicleBase:GetInt()
	local appliedUnits

	local result = ((ply and not RandomPlayerUnits:GetBool()) and playercontrolled) or UVGetRandomUnit( nil, {
		playercontrolled = playercontrolled,
		posspecified = posspecified,
		rhinoattack = rhinoattack,
		commanderrespawn = commanderrespawn
	} )

	local returnedUnitList = (playercontrolled and not RandomPlayerUnits:GetBool() and playercontrolled) or result[1]
	local modifiers = result[2]

	if modifiers then
		if modifiers.rhinoattack ~= nil then rhinoattack = modifiers.rhinoattack end
		if modifiers.commanderrespawn ~= nil then commanderrespawn = modifiers.commanderrespawn end
		if modifiers.posspecified ~= nil then posspecified = modifiers.posspecified end
		if modifiers.playercontrolled ~= nil then playercontrolled = modifiers.playercontrolled end
		if modifiers.angles ~= nil then angles = modifiers.angles end
		if modifiers.disperse ~= nil then disperse = modifiers.disperse end
	end

	if returnedUnitList then
		if returnedUnitList.name == 'rhino' then
			rhinoattack = true
		end

		if playercontrolled and not RandomPlayerUnits:GetBool() then
			appliedunits = playercontrolled.unit
			uvnextclasstospawn = playercontrolled.unitnpc
		else
			appliedunits = returnedUnitList.units
			uvnextclasstospawn = returnedUnitList.npc
		end
	else
		return
	end

	if commanderrespawn then
		rhinoattack = nil
		appliedunits = commanderrespawn
		uvnextclasstospawn = "npc_uvcommander"
	end

	if UVTargeting then
		if not rhinoattack then
			local mathangle = math.random(1,2)
			if mathangle == 2 then
				uvspawnpointangles = uvspawnpointangles+Angle(0,180,0)
			end
		elseif suspectvelocity then
			uvspawnpointangles = suspectvelocity:Angle() + Angle(0,180,0)
		end
	end
	
	if posspecified then
		uvspawnpoint = posspecified
	end
	if angles then
		uvspawnpointangles = angles
	end
	
	--if not playercontrolled then
		-- --FIND UNITS
		-- local givenunitstable
		-- local givenclasses = {
		-- 	"npc_uvpatrol",
		-- 	"npc_uvsupport",
		-- 	"npc_uvpursuit",
		-- 	"npc_uvinterceptor",
		-- 	"npc_uvspecial",
		-- 	"npc_uvcommander",
		-- }

		-- local availableunitstable = {}
		-- local availableclasses = {}

		-- if UVHeatLevel <= 1 then
		-- 	UVHeatLevel = 1
		-- elseif UVHeatLevel > MAX_HEAT_LEVEL then
		-- 	UVHeatLevel = MAX_HEAT_LEVEL
		-- end

		-- local UnitsPatrol = string.Trim( GetConVar( 'unitvehicle_unit_unitspatrol' .. UVHeatLevel ):GetString() )
		-- local UnitsSupport = string.Trim( GetConVar( 'unitvehicle_unit_unitssupport' .. UVHeatLevel ):GetString() )
		-- local UnitsPursuit = string.Trim( GetConVar( 'unitvehicle_unit_unitspursuit' .. UVHeatLevel ):GetString() )
		-- local UnitsInterceptor = string.Trim( GetConVar( 'unitvehicle_unit_unitsinterceptor' .. UVHeatLevel ):GetString() )
		-- local UnitsSpecial = string.Trim( GetConVar( 'unitvehicle_unit_unitsspecial' .. UVHeatLevel ):GetString() )
		-- local UnitsCommander = string.Trim( GetConVar( 'unitvehicle_unit_unitscommander' .. UVHeatLevel ):GetString() )
		-- local UnitsRhino = string.Trim( GetConVar( 'unitvehicle_unit_unitsrhino' .. UVHeatLevel ):GetString() )

		-- if UVOneCommanderActive or UVOneCommanderDeployed or posspecified or (UVUnitsHavePlayers and not playercontrolled) then
		-- 	UnitsCommander = ""
		-- end

		-- givenunitstable = {
		-- 	UnitsPatrol,
		-- 	UnitsSupport,
		-- 	UnitsPursuit,
		-- 	UnitsInterceptor,
		-- 	UnitsSpecial,
		-- 	UnitsCommander,
		-- }

		-- for k, v in pairs(givenunitstable) do
		-- 	if not string.match(v, "^%s*$") then --not an empty string
		-- 		table.insert(availableunitstable, givenunitstable[k])
		-- 		table.insert(availableclasses, givenclasses[k])
		-- 	end
		-- end

		-- local randomclassunit = math.random(1, #availableclasses)

		-- if rhinoattack and not string.match(UnitsRhino, "^%s*$") then
		-- 	appliedunits = UnitsRhino
		-- else
		-- 	rhinoattack = nil
		-- 	appliedunits = availableunitstable[randomclassunit]
		-- end

		-- uvnextclasstospawn = availableclasses[randomclassunit]
	-- else
	-- 	appliedunits = playercontrolled.unit
	-- 	uvnextclasstospawn = playercontrolled.unitnpc
	-- end
	
	if not isstring(appliedunits) then
		PrintMessage( HUD_PRINTTALK, "There's currently no assigned Units to spawn. Use the Unit Manager tool to assign Units at that particular Heat Level! Ensure that you have selected the correct vehicle base inside Heat Level Manager settings!")
		return
	end
	
	local availableunits = {}
	local availableunit
	local MEMORY = {}

	local appliedUnitsStrings = string.Explode( " ", appliedunits )
	
	if vehiclebase == 4 then --LVS
		local createdEntities = {}

		local saved_vehicles = UV_GetFiles( "lvs>>units" )
		
		for i, v in ipairs(saved_vehicles) do
			local match
			-- if (playercontrolled and playercontrolled.unit) then
			-- 	match = playercontrolled.unit == v
			-- else
				for _, string in pairs(appliedUnitsStrings) do
					if string == v then
						match = true
						break
					end
				end
			if match then
				table.insert(availableunits, v)
			end
		end
		
		if next(availableunits) == nil then
			if not string.match(appliedunits, "^%s*$") then
				PrintMessage( HUD_PRINTTALK, "Unit Manager attempted to spawn a Unit that is NOT in the database. Unit name(s) to cross-check: "..appliedunits..". Ensure that you have selected the correct vehicle base inside Heat Level Manager settings!")
			end
			return
		end
		
		availableunit = availableunits[math.random(1, #availableunits)]
		
		if commanderrespawn then
			availableunit = commanderrespawn
			uvnextclasstospawn = "npc_uvcommander"
		end
		
		local JSONData = UV_LoadFile( "lvs>>units", availableunit )
		
		MEMORY = util.JSONToTable(JSONData, true)

		local pos = uvspawnpoint+Vector( 0, 0, 50 )
		local ang = uvspawnpointangles
		ang.yaw = UVTargeting and rhinoattack and not posspecified and ang.yaw or ang.yaw + 180 --Points the other way when spawning based on player
		
		--duplicator.SetLocalPos( pos )
		--duplicator.SetLocalAng( ang )
		
		-- local Ents = duplicator.Paste( nil, MEMORY.Entities, MEMORY.Constraints )
		-- --print(type(Ents), "a", PrintTable(Ents))
		-- local Ent = Ents[next(Ents)]

		local entCount = 0

		for _, _ in pairs(MEMORY.Entities) do
			entCount = entCount + 1
		end

		for k, v in pairs(MEMORY.Entities) do
			local e = ents.Create( v.Class )
			if not IsValid( e ) then continue end

			duplicator.DoGeneric( e, v )

			e:SetPos( pos )
			e:SetAngles( ang )

			table.Merge( e:GetTable(), v )

			e:Spawn()
			e:Activate()

			if ( e.RestoreNetworkVars ) then
				e:RestoreNetworkVars( v.DT )
			end

			if ( e.OnDuplicated ) then
				e:OnDuplicated( v )
			end

			createdEntities[k] = e

			if createdEntities[k] then
				createdEntities[k].BoneMods = table.Copy( v.BoneMods )
				createdEntities[k].EntityMods = table.Copy( v.EntityMods )
				createdEntities[k].PhysicsObjects = table.Copy( v.PhysicsObjects )
			end
		end

		for k, v in pairs( createdEntities ) do
			duplicator.ApplyEntityModifiers( NULL, v )
			duplicator.ApplyBoneModifiers( NULL, v )

			-- if ( v.PostEntityPaste ) then
			-- 	v:PostEntityPaste( NULL, nil, Ent, createdEntities )
			-- end
		end

		local createdConstraints = {}

		for k, v in pairs( MEMORY.Constraints ) do
			local Ent = UVCreateConstraintsFromTable( v, createdEntities )
			
			if IsValid( Ent ) then
				table.insert( createdConstraints, Ent )
			end
		end

		--table.Merge( Ent:GetTable(), MEMORY.Entities[next(MEMORY.Entities)] )
		
		-- duplicator.SetLocalPos( vector_origin )
		-- duplicator.SetLocalAng( angle_zero )

		-- local Ent = duplicator.CreateEntityFromTable( nil, MEMORY.Entities )
		-- print(Ent, "b")
		local Ent = nil
		if next(createdEntities) ~= nil then
			for _, v in pairs(createdEntities) do
				if v.LVS then
					Ent = v
					break
				end
			end
		end

		if not IsValid(Ent) then PrintMessage( HUD_PRINTTALK, "The vehicle '"..availableunit.."' is missing! Ensure that you have selected the correct vehicle base inside Heat Level Manager settings!") return end

		if MEMORY.SubMaterials then
			if istable( MEMORY.SubMaterials ) then
				for i = 0, table.Count( MEMORY.SubMaterials ) do
					Ent:SetSubMaterial( i, MEMORY.SubMaterials[i] )
				end
			end
			
			local groups = string.Explode( ",", MEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( MEMORY.Skin )
			
			local c = string.Explode( ",", MEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
		end
		
		Ent.uvclasstospawnon = uvnextclasstospawn
		Ent.unitscript = availableunit
		
		if rhinoattack then
			Ent.uvclasstospawnon = "npc_uvspecial"
			Ent.rhino = true
		elseif Ent.uvclasstospawnon ~= "npc_uvpatrol" and Ent.uvclasstospawnon ~= "npc_uvsupport" then
			
			if UVUPursuitTech:GetBool() then
				Ent.PursuitTech = {}
				
				local pool = {}
				
				if UVUPursuitTech_ESF:GetBool() then
					table.insert(pool, "ESF")
				end
				if UVUPursuitTech_EMP:GetBool() then
					table.insert(pool, "EMP")
				end
				if UVUPursuitTech_Spikestrip:GetBool() then
					table.insert(pool, "Spikestrip")
				end
				if UVUPursuitTech_Killswitch:GetBool() then
					table.insert(pool, "Killswitch")
				end
				if UVUPursuitTech_RepairKit:GetBool() and Ent.uvclasstospawnon ~= "npc_uvcommander" then
					table.insert(pool, "Repair Kit")
				end
				if UVUPursuitTech_ShockRam:GetBool() then
					table.insert(pool, "Shock Ram")
				end
				if UVUPursuitTech_GPSDart:GetBool() then
					table.insert(pool, "GPS Dart")
				end
				if UVUPursuitTech_Grappler:GetBool() then
					table.insert(pool, "Grappler")
				end
				
				for i=1,2,1 do
					if #pool > 0 then
						local selected_pt = pool[math.random(1, #pool)]
						local sanitized_pt = string.lower(string.gsub(selected_pt, " ", ""))
						
						local ammo_count = GetConVar("uvpursuittech_" .. sanitized_pt .. "_maxammo_unit"):GetInt()
						ammo_count = ammo_count > 0 and ammo_count or math.huge
						
						Ent.PursuitTech[i] = {
							Tech = selected_pt,
							Ammo = ammo_count,
							Cooldown = GetConVar("uvpursuittech_" .. sanitized_pt .. "_cooldown_unit"):GetInt(),
							LastUsed = -math.huge,
						}
						
						for i, v in pairs(pool) do
							if v == selected_pt then
								table.remove(pool, i)
							end
						end
						--UVReplicatePT( Ent, i )
					end
				end
			end
		end
		
		if Ent.uvclasstospawnon == "npc_uvcommander" then
			UVOneCommanderDeployed = true
			table.insert(UVCommanders, Ent)
			Ent.uvlasthealth = UVCommanderLastHealth
			Ent.uvlastenginehealth = UVCommanderLastEngineHealth
		end
		
		Ent:CallOnRemove( "UVGlideVehicleRemoved", function(car)
			if table.HasValue(UVCommanders, car) then
				table.RemoveByValue(UVCommanders, car)
			end
		end)
		
		if posspecified then
			Ent.roadblocking = true
		end
		if disperse then
			Ent.disperse = true
		end
		
		if playercontrolled then
			timer.Simple(0.5, function()
				UVAddUnit(Ent, ply)
				table.insert(UVVehicleInitializing, Ent)
				Ent:StartEngine()
			end)
		else
			table.insert(UVVehicleInitializing, Ent)
		end
		
		if Ent.PursuitTech then
			timer.Simple(1, function()
				for i=1,2 do
					UVReplicatePT( Ent, i )
				end
			end)
		end
		
	elseif vehiclebase == 3 then --Glide
		local createdEntities = {}

		local saved_vehicles = UV_GetFiles( "glide>>units" )
		
		for i, v in ipairs(saved_vehicles) do
			local match
			-- if (playercontrolled and playercontrolled.unit) then
			-- 	match = playercontrolled.unit == v
			-- else
				for _, string in pairs(appliedUnitsStrings) do
					if string == v then
						match = true
						break
					end
				end
			if match then
				table.insert(availableunits, v)
			end
		end
		
		if next(availableunits) == nil then
			if not string.match(appliedunits, "^%s*$") then
				PrintMessage( HUD_PRINTTALK, "Unit Manager attempted to spawn a Unit that is NOT in the database. Unit name(s) to cross-check: "..appliedunits..". Ensure that you have selected the correct vehicle base inside Heat Level Manager settings!")
			end
			return
		end
		
		availableunit = availableunits[math.random(1, #availableunits)]
		
		if commanderrespawn then
			availableunit = commanderrespawn
			uvnextclasstospawn = "npc_uvcommander"
		end
		
		local JSONData = UV_LoadFile( "glide>>units", availableunit )
		
		MEMORY = util.JSONToTable(JSONData, true)

		local pos = uvspawnpoint+Vector( 0, 0, 50 )
		local ang = uvspawnpointangles
		ang.yaw = UVTargeting and rhinoattack and not posspecified and ang.yaw or ang.yaw + 180 --Points the other way when spawning based on player
		
		--duplicator.SetLocalPos( pos )
		--duplicator.SetLocalAng( ang )
		
		-- local Ents = duplicator.Paste( nil, MEMORY.Entities, MEMORY.Constraints )
		-- --print(type(Ents), "a", PrintTable(Ents))
		-- local Ent = Ents[next(Ents)]

		local entCount = 0

		for _, _ in pairs(MEMORY.Entities) do
			entCount = entCount + 1
		end

		for k, v in pairs(MEMORY.Entities) do
			local e = ents.Create( v.Class )
			if not IsValid( e ) then continue end

			duplicator.DoGeneric( e, v )

			e:SetPos( pos )
			e:SetAngles( ang )

			table.Merge( e:GetTable(), v )

			e:Spawn()
			e:Activate()

			if cffunctions then
				if v.NitrousColor then
					local r = v.NitrousColor.r
					local g = v.NitrousColor.g
					local b = v.NitrousColor.b

					timer.Simple(1, function()
						net.Start( "cfnitrouscolor" )
							net.WriteEntity(e)
							net.WriteInt(r, 9)
							net.WriteInt(g, 9)
							net.WriteInt(b, 9)
							net.WriteBool(v.NitrousBurst)
							net.WriteBool(v.NitrousEnabled)
						net.Broadcast()
					end)
				end
			end

			if ( e.RestoreNetworkVars ) then
				e:RestoreNetworkVars( v.DT )
			end

			if ( e.OnDuplicated ) then
				e:OnDuplicated( v )
			end

			createdEntities[k] = e

			if createdEntities[k] then
				createdEntities[k].BoneMods = table.Copy( v.BoneMods )
				createdEntities[k].EntityMods = table.Copy( v.EntityMods )
				createdEntities[k].PhysicsObjects = table.Copy( v.PhysicsObjects )
			end
		end

		for k, v in pairs( createdEntities ) do
			duplicator.ApplyEntityModifiers( NULL, v )
			duplicator.ApplyBoneModifiers( NULL, v )

			-- if ( v.PostEntityPaste ) then
			-- 	v:PostEntityPaste( NULL, nil, Ent, createdEntities )
			-- end
		end

		local createdConstraints = {}

		for k, v in pairs( MEMORY.Constraints ) do
			local Ent = UVCreateConstraintsFromTable( v, createdEntities )
			
			if IsValid( Ent ) then
				table.insert( createdConstraints, Ent )
			end
		end

		--table.Merge( Ent:GetTable(), MEMORY.Entities[next(MEMORY.Entities)] )
		
		-- duplicator.SetLocalPos( vector_origin )
		-- duplicator.SetLocalAng( angle_zero )

		-- local Ent = duplicator.CreateEntityFromTable( nil, MEMORY.Entities )
		-- print(Ent, "b")
		local Ent = nil
		if next(createdEntities) ~= nil then
			for _, v in pairs(createdEntities) do
				if v.IsGlideVehicle and v.GetIsHonking then
					Ent = v
					break
				end
			end
		end

		if not IsValid(Ent) then PrintMessage( HUD_PRINTTALK, "The vehicle '"..availableunit.."' is missing! Ensure that you have selected the correct vehicle base inside Heat Level Manager settings!") return end

		if MEMORY.SubMaterials then
			if istable( MEMORY.SubMaterials ) then
				for i = 0, table.Count( MEMORY.SubMaterials ) do
					Ent:SetSubMaterial( i, MEMORY.SubMaterials[i] )
				end
			end
			
			local groups = string.Explode( ",", MEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( MEMORY.Skin )
			
			local c = string.Explode( ",", MEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
		end

		for k, v in pairs(Ent.wheels) do
			if v.params then
				v.params.isBulletProof = true
			end
		end
		
		Ent.uvclasstospawnon = uvnextclasstospawn
		Ent.unitscript = availableunit
		
		if rhinoattack then
			Ent.uvclasstospawnon = "npc_uvspecial"
			Ent.rhino = true
		elseif Ent.uvclasstospawnon ~= "npc_uvpatrol" and Ent.uvclasstospawnon ~= "npc_uvsupport" then
			
			if UVUPursuitTech:GetBool() then
				Ent.PursuitTech = {}
				
				local pool = {}
				
				if UVUPursuitTech_ESF:GetBool() then
					table.insert(pool, "ESF")
				end
				if UVUPursuitTech_EMP:GetBool() then
					table.insert(pool, "EMP")
				end
				if UVUPursuitTech_Spikestrip:GetBool() then
					table.insert(pool, "Spikestrip")
				end
				if UVUPursuitTech_Killswitch:GetBool() then
					table.insert(pool, "Killswitch")
				end
				if UVUPursuitTech_RepairKit:GetBool() and Ent.uvclasstospawnon ~= "npc_uvcommander" then
					table.insert(pool, "Repair Kit")
				end
				if UVUPursuitTech_ShockRam:GetBool() then
					table.insert(pool, "Shock Ram")
				end
				if UVUPursuitTech_GPSDart:GetBool() then
					table.insert(pool, "GPS Dart")
				end
				if UVUPursuitTech_Grappler:GetBool() then
					table.insert(pool, "Grappler")
				end
				
				for i=1,2,1 do
					if #pool > 0 then
						local selected_pt = pool[math.random(1, #pool)]
						local sanitized_pt = string.lower(string.gsub(selected_pt, " ", ""))
						
						local ammo_count = GetConVar("uvpursuittech_" .. sanitized_pt .. "_maxammo_unit"):GetInt()
						ammo_count = ammo_count > 0 and ammo_count or math.huge
						
						Ent.PursuitTech[i] = {
							Tech = selected_pt,
							Ammo = ammo_count,
							Cooldown = GetConVar("uvpursuittech_" .. sanitized_pt .. "_cooldown_unit"):GetInt(),
							LastUsed = -math.huge,
						}
						
						for i, v in pairs(pool) do
							if v == selected_pt then
								table.remove(pool, i)
							end
						end
						--UVReplicatePT( Ent, i )
					end
				end
			end
		end
		
		if Ent.uvclasstospawnon == "npc_uvcommander" then
			UVOneCommanderDeployed = true
			table.insert(UVCommanders, Ent)
			Ent.uvlasthealth = UVCommanderLastHealth
			Ent.uvlastenginehealth = UVCommanderLastEngineHealth
		end
		
		Ent:CallOnRemove( "UVGlideVehicleRemoved", function(car)
			if table.HasValue(UVCommanders, car) then
				table.RemoveByValue(UVCommanders, car)
			end
		end)
		
		if posspecified then
			Ent.roadblocking = true
		end
		if disperse then
			Ent.disperse = true
		end
		
		if playercontrolled then
			timer.Simple(0.5, function()
				UVAddUnit(Ent, ply)
				table.insert(UVVehicleInitializing, Ent)
			end)
		else
			table.insert(UVVehicleInitializing, Ent)
		end
		
		if Ent.PursuitTech then
			timer.Simple(1, function()
				for i=1,2 do
					UVReplicatePT( Ent, i )
				end
			end)
		end
		
	elseif vehiclebase == 2 then --simfphys
		
		local saved_vehicles = UV_GetFiles( "simfphys>>units" )
		
		for i, v in ipairs(saved_vehicles) do
			local match
			-- if (playercontrolled and playercontrolled.unit) then
			-- 	match = playercontrolled.unit == v
			-- else
				for _, string in pairs(appliedUnitsStrings) do
					if string == v then
						match = true
						break
					end
				end
			if match then
				table.insert(availableunits, v)
			end
		end
		
		if next(availableunits) == nil then
			if not string.match(appliedunits, "^%s*$") then
				PrintMessage( HUD_PRINTTALK, "Unit Manager attempted to spawn a Unit that is NOT in the database. Unit name(s) to cross-check: "..appliedunits..". Ensure that you have selected the correct vehicle base inside Heat Level Manager settings!")
			end
			return
		end
		
		availableunit = availableunits[math.random(1, #availableunits)]
		
		if commanderrespawn then
			availableunit = commanderrespawn
			uvnextclasstospawn = "npc_uvcommander"
		end
		
		local DataString = UV_LoadFile( "simfphys>>units", availableunit )
		
		local words = string.Explode( "", DataString )
		local shit = {}
		
		for k, v in pairs( words ) do
			shit[k] =  string.char( string.byte( v ) - 20 )
		end
		
		local Data = string.Explode( "#", string.Implode("",shit) )
		
		for _,v in pairs(Data) do
			local Var = string.Explode( "=", v )
			local name = Var[1]
			local variable = Var[2]
			
			if name and variable then
				if name == "SubMaterials" then
					MEMORY[name] = {}
					
					local submats = string.Explode( ",", variable )
					for i = 0, (table.Count( submats ) - 1) do
						MEMORY[name][i] = submats[i+1]
					end
				else
					MEMORY[name] = variable
				end
			end
		end
		
		if not istable(MEMORY) then return end
		
		local Ent
		
		local vname = MEMORY.SpawnName
		local VehicleList = list.Get( "simfphys_vehicles" )
		local vehicle = VehicleList[ vname ]
		
		if not vehicle then 
			PrintMessage( HUD_PRINTTALK, "The vehicle class '"..vname.."' dosen't seem to be installed! Ensure that you have selected the correct vehicle base inside Heat Level Manager settings!")
			return false 
		end
		
		local SpawnPos = uvspawnpoint + (vector_up * 50) + (vehicle.SpawnOffset or vector_origin)
		
		local SpawnAng = uvspawnpointangles
		SpawnAng.pitch = 0
		SpawnAng.yaw = UVTargeting and rhinoattack and not posspecified and SpawnAng.yaw or SpawnAng.yaw + 180
		SpawnAng.yaw = SpawnAng.yaw + (vehicle.SpawnAngleOffset and vehicle.SpawnAngleOffset or 0)
		SpawnAng.roll = 0
		
		Ent = simfphys.SpawnVehicle( ply, SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, vname, vehicle, true )
		
		if not IsValid( Ent ) then return end
		
		timer.Simple( 0.5, function()
			if not IsValid(Ent) then return end
			
			local tsc = string.Explode( ",", MEMORY.TireSmokeColor )
			Ent:SetTireSmokeColor( Vector( tonumber(tsc[1]), tonumber(tsc[2]), tonumber(tsc[3]) ) )
			
			Ent.Turbocharged = tobool( MEMORY.HasTurbo )
			Ent.Supercharged = tobool( MEMORY.HasBlower )
			
			Ent:SetEngineSoundPreset( math.Clamp( tonumber( MEMORY.SoundPreset ), -1, 23) )
			Ent:SetMaxTorque( math.Clamp( tonumber( MEMORY.PeakTorque ), 20, 1000) )
			Ent:SetDifferentialGear( math.Clamp( tonumber( MEMORY.FinalGear ),0.2, 6 ) )
			
			Ent:SetSteerSpeed( math.Clamp( tonumber( MEMORY.SteerSpeed ), 1, 16 ) )
			Ent:SetFastSteerAngle( math.Clamp( tonumber( MEMORY.SteerAngFast ), 0, 1) )
			Ent:SetFastSteerConeFadeSpeed( math.Clamp( tonumber( MEMORY.SteerFadeSpeed ), 1, 5000 ) )
			
			Ent:SetEfficiency( math.Clamp( tonumber( MEMORY.Efficiency ) ,0.2,4) )
			Ent:SetMaxTraction( math.Clamp( tonumber( MEMORY.MaxTraction ) , 5,1000) )
			Ent:SetTractionBias( math.Clamp( tonumber( MEMORY.GripOffset ),-0.99,0.99) )
			Ent:SetPowerDistribution( math.Clamp( tonumber( MEMORY.PowerDistribution ) ,-1,1) )
			
			Ent:SetBackFire( tobool( MEMORY.HasBackfire ) )
			Ent:SetDoNotStall( tobool( MEMORY.DoesntStall ) )
			
			Ent:SetIdleRPM( math.Clamp( tonumber( MEMORY.IdleRPM ),1,25000) )
			Ent:SetLimitRPM( math.Clamp( tonumber( MEMORY.MaxRPM ),4,25000) )
			Ent:SetRevlimiter( tobool( MEMORY.HasRevLimiter ) )
			Ent:SetPowerBandEnd( math.Clamp( tonumber( MEMORY.PowerEnd ), 3, 25000) )
			Ent:SetPowerBandStart( math.Clamp( tonumber( MEMORY.PowerStart ) ,2 ,25000) )
			
			Ent:SetTurboCharged( Ent.Turbocharged )
			Ent:SetSuperCharged( Ent.Supercharged )
			Ent:SetBrakePower( math.Clamp( tonumber( MEMORY.BrakePower ), 0.1, 500) )
			
			Ent:SetSoundoverride( MEMORY.SoundOverride or "" )
			
			Ent:SetLights_List( Ent.LightsTable or "no_lights" )
			
			Ent:SetBulletProofTires(true)
			
			Ent.snd_horn = MEMORY.HornSound
			
			Ent.snd_blowoff = MEMORY.snd_blowoff
			Ent.snd_spool = MEMORY.snd_spool
			Ent.snd_bloweron = MEMORY.snd_bloweron
			Ent.snd_bloweroff = MEMORY.snd_bloweroff
			
			Ent:SetBackfireSound( MEMORY.backfiresound or "" )
			
			local Gears = {}
			local Data = string.Explode( ",", MEMORY.Gears  )
			for i = 1, table.Count( Data ) do 
				local gRatio = tonumber( Data[i] )
				
				if isnumber( gRatio ) then
					if i == 1 then
						Gears[i] = math.Clamp( gRatio, -5, -0.001)
						
					elseif i == 2 then
						Gears[i] = 0
						
					else
						Gears[i] = math.Clamp( gRatio, 0.001, 5)
					end
				end
			end
			Ent.Gears = Gears
			
			if istable( MEMORY.SubMaterials ) then
				for i = 0, table.Count( MEMORY.SubMaterials ) do
					Ent:SetSubMaterial( i, MEMORY.SubMaterials[i] )
				end
			end
			
			if MEMORY.FrontDampingOverride and MEMORY.FrontConstantOverride and MEMORY.RearDampingOverride and MEMORY.RearConstantOverride then
				Ent.FrontDampingOverride = tonumber( MEMORY.FrontDampingOverride )
				Ent.FrontConstantOverride = tonumber( MEMORY.FrontConstantOverride )
				Ent.RearDampingOverride = tonumber( MEMORY.RearDampingOverride )
				Ent.RearConstantOverride = tonumber( MEMORY.RearConstantOverride )
				
				local data = {
					[1] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[2] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[3] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[4] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[5] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[6] = {Ent.RearConstantOverride,Ent.RearDampingOverride}
				}
				
				local elastics = Ent.Elastics
				if elastics then
					for i = 1, table.Count( elastics ) do
						local elastic = elastics[i]
						if Ent.StrengthenSuspension == true then
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
							local elastic2 = elastics[i * 10]
							if IsValid( elastic2 ) then
								elastic2:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic2:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
						else
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1], 0 )
								elastic:Fire( "SetSpringDamping", data[i][2], 0 )
							end
						end
					end
				end
			end
			
			Ent:SetFrontSuspensionHeight( tonumber( MEMORY.FrontHeight ) )
			Ent:SetRearSuspensionHeight( tonumber( MEMORY.RearHeight ) )
			
			local groups = string.Explode( ",", MEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( MEMORY.Skin )
			
			local c = string.Explode( ",", MEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
			
			if Ent.CustomWheels then
				if Ent.GhostWheels then
					if not IsValid( Ent ) then return end
					if MEMORY.WheelTool_Foffset and MEMORY.WheelTool_Roffset then
						SetWheelOffset( Ent, MEMORY.WheelTool_Foffset, MEMORY.WheelTool_Roffset )
					end
					
					if not MEMORY.FrontWheelOverride and not MEMORY.RearWheelOverride then return end
					
					local front_model = MEMORY.FrontWheelOverride or vehicle.Members.CustomWheelModel
					local front_angle = GetAngleFromSpawnlist(front_model)
					
					local camber = MEMORY.Camber or 0
					local rear_model = MEMORY.RearWheelOverride or (vehicle.Members.CustomWheelModel_R and vehicle.Members.CustomWheelModel_R or front_model)
					local rear_angle = GetAngleFromSpawnlist(rear_model)
					
					if not front_model or not rear_model or not front_angle or not rear_angle then return end
					
					if ValidateModel( front_model ) and ValidateModel( rear_model ) then 
						Ent.Camber = camber
						ApplyWheel(Ent, {front_model,front_angle,rear_model,rear_angle,camber})
					else
						ply:PrintMessage( HUD_PRINTTALK, "selected wheel does not exist on the server")
					end
				end
			end
		end)
		
		
		Ent.uvclasstospawnon = uvnextclasstospawn
		Ent.unitscript = availableunit
		
		if rhinoattack then
			Ent.uvclasstospawnon = "npc_uvspecial"
			Ent.rhino = true
		elseif Ent.uvclasstospawnon ~= "npc_uvpatrol" and Ent.uvclasstospawnon ~= "npc_uvsupport" then
			
			if UVUPursuitTech:GetBool() then
				Ent.PursuitTech = {}
				
				local pool = {}
				
				if UVUPursuitTech_ESF:GetBool() then
					table.insert(pool, "ESF")
				end
				if UVUPursuitTech_EMP:GetBool() then
					table.insert(pool, "EMP")
				end
				if UVUPursuitTech_Spikestrip:GetBool() then
					table.insert(pool, "Spikestrip")
				end
				if UVUPursuitTech_Killswitch:GetBool() then
					table.insert(pool, "Killswitch")
				end
				if UVUPursuitTech_RepairKit:GetBool() and (Ent.uvclasstospawnon ~= "npc_uvcommander" and not commanderrespawn) then
					table.insert(pool, "Repair Kit")
				end
				if UVUPursuitTech_ShockRam:GetBool() then
					table.insert(pool, "Shock Ram")
				end
				if UVUPursuitTech_GPSDart:GetBool() then
					table.insert(pool, "GPS Dart")
				end
				if UVUPursuitTech_Grappler:GetBool() then
					table.insert(pool, "Grappler")
				end
				
				for i=1,2,1 do
					if #pool > 0 then
						local selected_pt = pool[math.random(1, #pool)]
						local sanitized_pt = string.lower(string.gsub(selected_pt, " ", ""))
						
						local ammo_count = GetConVar("uvpursuittech_" .. sanitized_pt .. "_maxammo_unit"):GetInt()
						ammo_count = ammo_count > 0 and ammo_count or math.huge
						
						Ent.PursuitTech[i] = {
							Tech = selected_pt,
							Ammo = ammo_count,
							Cooldown = GetConVar("uvpursuittech_" .. sanitized_pt .. "_cooldown_unit"):GetInt(),
							LastUsed = -math.huge,
						}
						
						for i, v in pairs(pool) do
							if v == selected_pt then
								table.remove(pool, i)
							end
						end
						
						--UVReplicatePT( Ent, i )
					end
				end
			end
		end
		
		if Ent.uvclasstospawnon == "npc_uvcommander" then
			UVOneCommanderDeployed = true
			table.insert(UVCommanders, Ent)
			Ent.uvlasthealth = UVCommanderLastHealth
		end
		
		if playercontrolled then
			timer.Simple(0.5, function()
				UVAddUnit(Ent, ply)
				table.insert(UVVehicleInitializing, Ent)
			end)
		else
			table.insert(UVVehicleInitializing, Ent)
		end
		
		Ent:CallOnRemove( "UVSimfphysVehicleRemoved", function(car)
			if table.HasValue(UVVehicleInitializing, car) then
				table.RemoveByValue(UVVehicleInitializing, car)
			end
			if table.HasValue(UVCommanders, car) then
				table.RemoveByValue(UVCommanders, car)
			end
		end)
		
		timer.Simple(2, function() 
			if IsValid(Ent) and not Ent.UnitVehicle then
				Ent:Remove()
			end
		end)
		
		if posspecified then
			Ent.roadblocking = true
		end
		if disperse then
			Ent.disperse = true
		end
		
		if Ent.PursuitTech then
			timer.Simple(1, function()
				for i=1,2 do
					UVReplicatePT( Ent, i )
				end
			end)
		end	
		
	elseif vehiclebase == 1 then --Default Vehicle Base
		local saved_vehicles = UV_GetFiles( "prop_vehicle_jeep>>units" )
		
		for i, v in ipairs(saved_vehicles) do
			local match
			-- if (playercontrolled and playercontrolled.unit) then
			-- 	match = playercontrolled.unit == v
			-- else
				for _, string in pairs(appliedUnitsStrings) do
					if string == v then
						match = true
						break
					end
				end
			if match then
				table.insert(availableunits, v)
			end
		end
		
		if next(availableunits) == nil then
			if not string.match(appliedunits, "^%s*$") then
				PrintMessage( HUD_PRINTTALK, "Unit Manager attempted to spawn a Unit that is NOT in the database. Unit name(s) to cross-check: "..appliedunits..". Ensure that you have selected the correct vehicle base inside Heat Level Manager settings!")
			end
			return
		end
		
		availableunit = availableunits[math.random(1, #availableunits)]
		
		if commanderrespawn then
			availableunit = commanderrespawn
			uvnextclasstospawn = "npc_uvcommander"
		end
		
		local DataString = UV_LoadFile( "prop_vehicle_jeep>>units", availableunit )
		
		local words = string.Explode( "", DataString )
		local shit = {}
		
		for k, v in pairs( words ) do
			shit[k] =  string.char( string.byte( v ) - 20 )
		end
		
		local Data = string.Explode( "#", string.Implode("",shit) )
		
		for _,v in pairs(Data) do
			local Var = string.Explode( "=", v )
			local name = Var[1]
			local variable = Var[2]
			
			if name and variable then
				if name == "SubMaterials" then
					MEMORY[name] = {}
					
					local submats = string.Explode( ",", variable )
					for i = 0, (table.Count( submats ) - 1) do
						MEMORY[name][i] = submats[i+1]
					end
				else
					MEMORY[name] = variable
				end
			end
		end
		
		if not istable(MEMORY) then return end
		
		local class = MEMORY.SpawnName
		
		local vehicles = list.Get("Vehicles")
		local lst = vehicles[class]
		if not lst then
			PrintMessage( HUD_PRINTTALK, "The vehicle '"..class.."' is missing! Ensure that you have selected the correct vehicle base inside Heat Level Manager settings!")
			return
		end
		
		uvspawnpointangles.yaw = uvspawnpointangles.yaw - 90
		uvspawnpointangles.yaw = rhinoattack and not posspecified and uvspawnpointangles.yaw or uvspawnpointangles.yaw + 180
		
		local Ent = ents.Create("prop_vehicle_jeep")
		Ent.VehicleTable = lst
		Ent.VehicleName = MEMORY.VehicleName
		Ent:SetModel(lst.Model) 
		Ent:SetPos(uvspawnpoint+ (vector_up * 50))
		Ent:SetAngles(uvspawnpointangles)
		Ent:SetKeyValue("vehiclescript", lst.KeyValues.vehiclescript)
		Ent:SetVehicleClass( class )
		Ent:Spawn()
		Ent:Activate()
		
		local vehicle = Ent
		if IsValid(Entity(1)) then
			gamemode.Call( "PlayerSpawnedVehicle", Entity(1), vehicle ) --Some vehicles has different models implanted together, so do that.
		end
		
		if istable( MEMORY.SubMaterials ) then
			for i = 0, table.Count( MEMORY.SubMaterials ) do
				Ent:SetSubMaterial( i, MEMORY.SubMaterials[i] )
			end
		end
		
		timer.Simple(0.5, function()
			if not IsValid(Ent) then return end
			local groups = string.Explode( ",", MEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( MEMORY.Skin )
			
			local c = string.Explode( ",", MEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
		end)
		
		Ent.uvclasstospawnon = uvnextclasstospawn
		Ent.unitscript = availableunit
		
		if rhinoattack then
			Ent.uvclasstospawnon = "npc_uvspecial"
			Ent.rhino = true
		elseif Ent.uvclasstospawnon ~= "npc_uvpatrol" and Ent.uvclasstospawnon ~= "npc_uvsupport" then
			
			if UVUPursuitTech:GetBool() then
				Ent.PursuitTech = {}
				
				local pool = {}
				
				if UVUPursuitTech_ESF:GetBool() then
					table.insert(pool, "ESF")
				end
				if UVUPursuitTech_EMP:GetBool() then
					table.insert(pool, "EMP")
				end
				if UVUPursuitTech_Spikestrip:GetBool() then
					table.insert(pool, "Spikestrip")
				end
				if UVUPursuitTech_Killswitch:GetBool() then
					table.insert(pool, "Killswitch")
				end
				if UVUPursuitTech_RepairKit:GetBool() and Ent.uvclasstospawnon ~= "npc_uvcommander" then
					table.insert(pool, "Repair Kit")
				end
				if UVUPursuitTech_ShockRam:GetBool() then
					table.insert(pool, "Shock Ram")
				end
				if UVUPursuitTech_GPSDart:GetBool() then
					table.insert(pool, "GPS Dart")
				end
				if UVUPursuitTech_Grappler:GetBool() then
					table.insert(pool, "Grappler")
				end
				
				for i=1,2,1 do
					if #pool > 0 then
						local selected_pt = pool[math.random(1, #pool)]
						local sanitized_pt = string.lower(string.gsub(selected_pt, " ", ""))
						
						local ammo_count = GetConVar("uvpursuittech_" .. sanitized_pt .. "_maxammo_unit"):GetInt()
						ammo_count = ammo_count > 0 and ammo_count or math.huge
						
						Ent.PursuitTech[i] = {
							Tech = selected_pt,
							Ammo = ammo_count,
							Cooldown = GetConVar("uvpursuittech_" .. sanitized_pt .. "_cooldown_unit"):GetInt(),
							LastUsed = -math.huge,
						}
						
						for i, v in pairs(pool) do
							if v == selected_pt then
								table.remove(pool, i)
							end
						end
						
						--UVReplicatePT( Ent, i )
					end
				end
			end
		end
		
		if Ent.uvclasstospawnon == "npc_uvcommander" then
			UVOneCommanderDeployed = true
			table.insert(UVCommanders, Ent)
			Ent.uvlasthealth = UVCommanderLastHealth
		end
		
		Ent:CallOnRemove( "UVGlideVehicleRemoved", function(car)
			if table.HasValue(UVCommanders, car) then
				table.RemoveByValue(UVCommanders, car)
			end
		end)
		
		if posspecified then
			Ent.roadblocking = true
		end
		if disperse then
			Ent.disperse = true
		end
		
		if playercontrolled then
			timer.Simple(0.5, function()
				UVAddUnit(Ent, ply)
				table.insert(UVVehicleInitializing, Ent)
			end)
		else
			table.insert(UVVehicleInitializing, Ent)
		end
		
		if Ent.PursuitTech then
			timer.Simple(1, function()
				for i=1,2 do
					UVReplicatePT( Ent, i )
				end
			end)
		end
		
	else
		PrintMessage( HUD_PRINTTALK, "Invalid Vehicle Base! Reverting to Default Vehicle Base! Please set the Vehicle Base in the Unit Manager Tool settings!")
		RunConsoleCommand("unitvehicle_unit_vehiclebase", 1)
	end
	
end

function UVAutoSpawnTraffic()
	
	local ply = Entity(1)
	
	local uvnextclasstospawn = "npc_trafficvehicle"
	local enemylocation
	local suspect
	local suspectvelocity = Vector(0,0,0)

	if next(dvd.Waypoints) == nil then
		if not UVNoDVWaypointsNotify then
			net.Start("UV_OpenDVWarning")
			net.Broadcast()
		end
		return
	end
	UVNoDVWaypointsNotify = nil

	if next(dvd.Waypoints) == nil then
		net.Start("UV_OpenDVWarning")
		net.Broadcast() -- or target a specific player
		return
	end

	local waypointLookup = true

	if next(UVPotentialSuspects) ~= nil then
		local suspects = UVPotentialSuspects
		local random_entry = math.random(#suspects)
		suspect = UVGetRaceLeader() or suspects[random_entry]
		
		enemylocation = (suspect:GetPos() + Vector(0, 0, 50))
		suspectvelocity = suspect:GetVelocity()
	elseif not playercontrolled then
		waypointLookup = false
		uvspawnpointwaypoint = dvd.Waypoints[math.random(#dvd.Waypoints)]
		uvspawnpoint = uvspawnpointwaypoint["Target"]
	else
		enemylocation = ply:GetPos() + Vector(0, 0, 50)
	end

	if waypointLookup then
		local enemywaypointgroup = 0

		local waypointtable = {}
		local prioritywaypointtable = {}
		local prioritywaypointtable2 = {}
		local prioritywaypointtable3 = {}
	
		local candidates = {}
		
		for k, v in ipairs( dvd.Waypoints ) do
			local Waypoint = v.Target
			local delta = enemylocation - Waypoint
			local distSq = delta:LengthSqr()
			if distSq <= POLICE_SPAWN_DIST_FAR_SQ or distSq >= POLICE_SPAWN_DIST_MAX_SQ then
				continue
			end
			
			if v.Group ~= enemywaypointgroup then
				table.insert( waypointtable, v )
				continue
			end
			
			local vect = delta:GetNormalized()
			local evectdot = vect:Dot( suspectvelocity )
			
			if evectdot < 0 then
				table.insert( candidates, { wp = v, distSq = distSq, score = -evectdot * distSq } )
			else
				table.insert( candidates, { wp = v, distSq = distSq, score = distSq } )
			end
		end
	
		table.sort( candidates, function(a, b) return a.score < b.score end )
		
		for i = 1, math.min( #candidates, POLICE_SPAWN_MAX_CANDIDATES ) do
			local v = candidates[i].wp
			local Waypoint = v.Target
			if UVStraightToWaypoint( enemylocation, Waypoint ) then
				local delta = enemylocation - Waypoint
				local vect = delta:GetNormalized()
				local evectdot = vect:Dot( suspectvelocity )
				
				if evectdot < 0 then
					table.insert( prioritywaypointtable, v )
				else
					table.insert( prioritywaypointtable2, v )
				end
			else
				table.insert( prioritywaypointtable3, v )
			end
		end
	
		if next(prioritywaypointtable) ~= nil then
			uvspawnpointwaypoint = prioritywaypointtable[math.random(#prioritywaypointtable)]
			uvspawnpoint = uvspawnpointwaypoint["Target"]
		elseif next(prioritywaypointtable3) ~= nil then
			uvspawnpointwaypoint = prioritywaypointtable3[math.random(#prioritywaypointtable3)]
			uvspawnpoint = uvspawnpointwaypoint["Target"]
		elseif next(waypointtable) ~= nil then
			uvspawnpointwaypoint = waypointtable[math.random(#waypointtable)]
			uvspawnpoint = uvspawnpointwaypoint["Target"]
		else
			uvspawnpointwaypoint = dvd.Waypoints[math.random(#dvd.Waypoints)]
			uvspawnpoint = uvspawnpointwaypoint["Target"]
		end	
	end

	local neighbor = dvd.Waypoints[uvspawnpointwaypoint.Neighbors[math.random(#uvspawnpointwaypoint.Neighbors)]]

	if neighbor then
		local neighborpoint = neighbor["Target"]
		local neighbordistance = neighborpoint - uvspawnpoint
		uvspawnpointangles = GetConVar("unitvehicle_traffic_assigntraffic"):GetBool() and neighbordistance:Angle() or neighbordistance:Angle()+Angle(0,180,0)
	else
		uvspawnpointangles = Angle(0,math.random(0,360),0)
	end
	
	local vehiclebase = UVTVehicleBase:GetInt()
	local availabletraffic = {}
	local MEMORY = {}

	-- Override mode
	local OverrideEnabled = GetConVar("unitvehicle_traffic_assigntraffic"):GetBool()
	local OverrideList = string.Trim(GetConVar("unitvehicle_traffic_vehicles"):GetString())
	local OverrideVehicles = string.Explode(" ", OverrideList)

	if OverrideEnabled and #OverrideVehicles > 0 then
		local uvnextclasstospawn = "npc_trafficvehicle"

		-- Pick a random vehicle from the override list
		local class_name = OverrideVehicles[math.random(1, #OverrideVehicles)]

		if vehiclebase == 3 or vehiclebase == 4 then
			-- Glide
			local Ent = ents.Create(class_name)
			if IsValid(Ent) then
				Ent:SetPos(uvspawnpoint + Vector(0,0,50))
				Ent:SetAngles(uvspawnpointangles)
				Ent:Spawn()
				Ent:Activate()

				-- Tag for AI
				Ent.uvclasstospawnon = uvnextclasstospawn
				table.insert(UVVehicleInitializing, Ent)
			end

		elseif vehiclebase == 2 then
			-- Simfphys
			local VehicleList = list.Get("simfphys_vehicles")
			local vehicle = VehicleList[class_name]

			if vehicle then
				local SpawnPos = uvspawnpoint + (vector_up * 50) + (vehicle.SpawnOffset or vector_origin)
				local SpawnAng = uvspawnpointangles
				SpawnAng.pitch = 0
				SpawnAng.yaw = SpawnAng.yaw + 0
				SpawnAng.roll = 0

				local Ent = simfphys.SpawnVehicle(Entity(1), SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, class_name, vehicle)
				if IsValid(Ent) then
					Ent.uvclasstospawnon = uvnextclasstospawn
					table.insert(UVVehicleInitializing, Ent)
				end
			else
				PrintMessage(HUD_PRINTTALK, "Simfphys vehicle '"..class_name.."' not found! Ensure that you have selected the correct vehicle base inside Traffic Manager settings!")
			end

		elseif vehiclebase == 1 then
			-- HL2 Jeep
			local Vehicles = list.Get("Vehicles")
			local vehData = Vehicles[class_name]

			if vehData then
				local Ent = ents.Create("prop_vehicle_jeep")
				Ent.VehicleTable = vehData
				Ent.VehicleName = vehData.PrintName or class_name
				Ent:SetModel(vehData.Model)
				Ent:SetPos(uvspawnpoint + Vector(0,0,50))
				Ent:SetAngles(uvspawnpointangles)
				Ent:SetKeyValue("vehiclescript", vehData.KeyValues.vehiclescript)
				Ent:SetVehicleClass(class_name)
				Ent:Spawn()
				Ent:Activate()

				Ent.uvclasstospawnon = uvnextclasstospawn
				table.insert(UVVehicleInitializing, Ent)
			else
				PrintMessage(HUD_PRINTTALK, "HL2 Jeep vehicle '"..class_name.."' not found! Ensure that you have selected the correct vehicle base inside Traffic Manager settings!")
			end
		end

		return -- skip the rest of the function
	end
	
	if vehiclebase == 4 then --LVS
		local saved_vehicles = UV_GetFiles( "lvs>>traffic" )
		
		for i, v in ipairs(saved_vehicles) do
			table.insert(availabletraffic, v)
		end
		
		if saved_vehicles == nil or next(saved_vehicles) == nil then
			if not UVNoTrafficNotify then
				UVNoTrafficNotify = true
				PrintMessage( HUD_PRINTTALK, "There's currently no Traffic to spawn. Use the Traffic Manager tool to add Traffic!")
			end
			return
		end

		UVNoTrafficNotify = nil
		
		availabletraffic = saved_vehicles[math.random(1, #saved_vehicles)]
		
		local JSONData = UV_LoadFile( "lvs>>traffic", availabletraffic )
		
		MEMORY = util.JSONToTable(JSONData, true)
		
		-- local pos = uvspawnpoint+Vector( 0, 0, 50 )
		-- local ang = uvspawnpointangles

		--local pos, ang = LocalToWorld( MEMORY.Pos, MEMORY.Angle, uvspawnpoint+Vector( 0, 0, 50 ), uvspawnpointangles )
		
		--ang.yaw = ang.yaw + 180 --Points the other way when spawning based on player
	
		--local entArray = MEMORY.Entities[next(MEMORY.Entities)]

		local createdEntities = {}

		local entCount = 0

		for _, _ in pairs(MEMORY.Entities) do
			entCount = entCount + 1
		end

		for id, v in pairs(MEMORY.Entities) do
			local Ent = ents.Create( v.Class )
			if not IsValid( Ent ) then continue end

			local pos, ang = LocalToWorld( v.Pos, ( (entCount > 1 and v.Angle) or Angle(0,0,0) ), uvspawnpoint + Vector( 0, 0, 50 ), uvspawnpointangles + Angle(0,180,0) ) -- rotate entities 180 degrees to face the right way of dv

			duplicator.DoGeneric( Ent, v )

			Ent:SetPos( pos )
			Ent:SetAngles( ang )

			table.Merge( Ent:GetTable(), v )

			Ent:Spawn()
			Ent:Activate()

			if ( Ent.RestoreNetworkVars ) then
				Ent:RestoreNetworkVars( v.DT )
			end

			if ( Ent.OnDuplicated ) then
				Ent:OnDuplicated( v )
			end

			createdEntities[id] = Ent

			if createdEntities[id] then
				createdEntities[id].BoneMods = table.Copy( v.BoneMods )
				createdEntities[id].EntityMods = table.Copy( v.EntityMods )
				createdEntities[id].PhysicsObjects = table.Copy( v.PhysicsObjects )
			end

			if MEMORY.SubMaterials then
				if istable( MEMORY.SubMaterials ) then
					for i = 0, table.Count( MEMORY.SubMaterials ) do
						createdEntities[id]:SetSubMaterial( i, MEMORY.SubMaterials[i] )
					end
				end
				
				local groups = string.Explode( ",", MEMORY.BodyGroups)
				for i = 1, table.Count( groups ) do
					createdEntities[id]:SetBodygroup(i, tonumber(groups[i]) )
				end
				
				createdEntities[id]:SetSkin( MEMORY.Skin )
				
				local c = string.Explode( ",", MEMORY.Color )
				local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
				
				local dot = Color.r * Color.g * Color.b * Color.a
				Ent.OldColor = dot
	
				if MEMORY.SaveColor then
					createdEntities[id]:SetColor( Color )
				else
					if isfunction(Ent.GetSpawnColor) then
						Color = createdEntities[id]:GetSpawnColor()
						createdEntities[id]:SetColor( Color )
					else
						Color.r = math.random(0, 255)
						Color.g = math.random(0, 255)
						Color.b = math.random(0, 255)
						createdEntities[id]:SetColor( Color )
					end
				end
				
				local data = {
					Color = Color,
					RenderMode = 0,
					RenderFX = 0
				}
				duplicator.StoreEntityModifier( createdEntities[id], "colour", data )
			end

			createdEntities[id].uvclasstospawnon = uvnextclasstospawn

			table.insert(UVVehicleInitializing, createdEntities[id])
		end

		for _, v in pairs(MEMORY.Constraints) do
			local constraintEntity = UVCreateConstraintsFromTable( v, createdEntities )
		end

		for k, v in pairs( createdEntities ) do
			duplicator.ApplyEntityModifiers( NULL, v )
			duplicator.ApplyBoneModifiers( NULL, v )
		end
	elseif vehiclebase == 3 then --Glide
		local saved_vehicles = UV_GetFiles( "glide>>traffic" )
		
		for i, v in ipairs(saved_vehicles) do
			table.insert(availabletraffic, v)
		end
		
		if saved_vehicles == nil or next(saved_vehicles) == nil then
			if not UVNoTrafficNotify then
				UVNoTrafficNotify = true
				PrintMessage( HUD_PRINTTALK, "There's currently no Traffic to spawn. Use the Traffic Manager tool to add Traffic!")
			end
			return
		end

		UVNoTrafficNotify = nil
		
		availabletraffic = saved_vehicles[math.random(1, #saved_vehicles)]
		
		local JSONData = UV_LoadFile( "glide>>traffic", availabletraffic )
		
		MEMORY = util.JSONToTable(JSONData, true)
		
		-- local pos = uvspawnpoint+Vector( 0, 0, 50 )
		-- local ang = uvspawnpointangles

		--local pos, ang = LocalToWorld( MEMORY.Pos, MEMORY.Angle, uvspawnpoint+Vector( 0, 0, 50 ), uvspawnpointangles )
		
		--ang.yaw = ang.yaw + 180 --Points the other way when spawning based on player
	
		--local entArray = MEMORY.Entities[next(MEMORY.Entities)]

		local createdEntities = {}

		local entCount = 0

		for _, _ in pairs(MEMORY.Entities) do
			entCount = entCount + 1
		end

		for id, v in pairs(MEMORY.Entities) do
			local Ent = ents.Create( v.Class )
			if not IsValid( Ent ) then continue end

			local pos, ang = LocalToWorld( v.Pos, ( (entCount > 1 and v.Angle) or Angle(0,0,0) ), uvspawnpoint + Vector( 0, 0, 50 ), uvspawnpointangles + Angle(0,180,0) ) -- rotate entities 180 degrees to face the right way of dv

			duplicator.DoGeneric( Ent, v )

			Ent:SetPos( pos )
			Ent:SetAngles( ang )

			table.Merge( Ent:GetTable(), v )

			Ent:Spawn()
			Ent:Activate()

			if ( Ent.RestoreNetworkVars ) then
				Ent:RestoreNetworkVars( v.DT )
			end

			if ( Ent.OnDuplicated ) then
				Ent:OnDuplicated( v )
			end

			createdEntities[id] = Ent

			if createdEntities[id] then
				createdEntities[id].BoneMods = table.Copy( v.BoneMods )
				createdEntities[id].EntityMods = table.Copy( v.EntityMods )
				createdEntities[id].PhysicsObjects = table.Copy( v.PhysicsObjects )
			end

			if MEMORY.SubMaterials then
				if istable( MEMORY.SubMaterials ) then
					for i = 0, table.Count( MEMORY.SubMaterials ) do
						createdEntities[id]:SetSubMaterial( i, MEMORY.SubMaterials[i] )
					end
				end
				
				local groups = string.Explode( ",", MEMORY.BodyGroups)
				for i = 1, table.Count( groups ) do
					createdEntities[id]:SetBodygroup(i, tonumber(groups[i]) )
				end
				
				createdEntities[id]:SetSkin( MEMORY.Skin )
				
				local c = string.Explode( ",", MEMORY.Color )
				local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
				
				local dot = Color.r * Color.g * Color.b * Color.a
				Ent.OldColor = dot
	
				if MEMORY.SaveColor then
					createdEntities[id]:SetColor( Color )
				else
					if isfunction(Ent.GetSpawnColor) then
						Color = createdEntities[id]:GetSpawnColor()
						createdEntities[id]:SetColor( Color )
					else
						Color.r = math.random(0, 255)
						Color.g = math.random(0, 255)
						Color.b = math.random(0, 255)
						createdEntities[id]:SetColor( Color )
					end
				end
				
				local data = {
					Color = Color,
					RenderMode = 0,
					RenderFX = 0
				}
				duplicator.StoreEntityModifier( createdEntities[id], "colour", data )
			end

			createdEntities[id].uvclasstospawnon = uvnextclasstospawn

			table.insert(UVVehicleInitializing, createdEntities[id])
		end

		for _, v in pairs(MEMORY.Constraints) do
			local constraintEntity = UVCreateConstraintsFromTable( v, createdEntities )
		end

		for k, v in pairs( createdEntities ) do
			duplicator.ApplyEntityModifiers( NULL, v )
			duplicator.ApplyBoneModifiers( NULL, v )
		end
	elseif vehiclebase == 2 then --simfphys
		
		local saved_vehicles = UV_GetFiles( "simfphys>>traffic" )
		
		for i, v in ipairs(saved_vehicles) do
			table.insert(availabletraffic, v)
		end
		
		if saved_vehicles == nil or next(saved_vehicles) == nil then
			if not UVNoTrafficNotify then
				UVNoTrafficNotify = true
				PrintMessage( HUD_PRINTTALK, "There's currently no Traffic to spawn. Use the Traffic Manager tool to add Traffic!")
			end
			return
		end

		UVNoTrafficNotify = nil
		
		availabletraffic = saved_vehicles[math.random(1, #saved_vehicles)]
		
		if commanderrespawn then
			availabletraffic = commanderrespawn
			uvnextclasstospawn = "npc_uvcommander"
		end
		
		local DataString = UV_LoadFile( "simfphys>>traffic", availabletraffic )
		
		local words = string.Explode( "", DataString )
		local shit = {}
		
		for k, v in pairs( words ) do
			shit[k] =  string.char( string.byte( v ) - 20 )
		end
		
		local Data = string.Explode( "#", string.Implode("",shit) )
		
		for _,v in pairs(Data) do
			local Var = string.Explode( "=", v )
			local name = Var[1]
			local variable = Var[2]
			
			if name and variable then
				if name == "SubMaterials" then
					MEMORY[name] = {}
					
					local submats = string.Explode( ",", variable )
					for i = 0, (table.Count( submats ) - 1) do
						MEMORY[name][i] = submats[i+1]
					end
				else
					MEMORY[name] = variable
				end
			end
		end
		
		if not istable(MEMORY) then return end
		
		local Ent
		
		local vname = MEMORY.SpawnName
		local VehicleList = list.Get( "simfphys_vehicles" )
		local vehicle = VehicleList[ vname ]
		
		if not vehicle then 
			PrintMessage( HUD_PRINTTALK, "The vehicle class '"..vname.."' dosen't seem to be installed! Ensure that you have selected the correct vehicle base inside Traffic Manager settings!")
			return false 
		end
		
		local SpawnPos = uvspawnpoint + (vector_up * 50) + (vehicle.SpawnOffset or vector_origin)
		
		local SpawnAng = uvspawnpointangles
		SpawnAng.pitch = 0
		SpawnAng.yaw = SpawnAng.yaw + 180
		SpawnAng.yaw = SpawnAng.yaw + (vehicle.SpawnAngleOffset and vehicle.SpawnAngleOffset or 0)
		SpawnAng.roll = 0
		
		Ent = simfphys.SpawnVehicle( ply, SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, vname, vehicle, true )
		
		if not IsValid( Ent ) then return end
		
		timer.Simple( 0.5, function()
			if not IsValid(Ent) then return end
			
			local tsc = string.Explode( ",", MEMORY.TireSmokeColor )
			Ent:SetTireSmokeColor( Vector( tonumber(tsc[1]), tonumber(tsc[2]), tonumber(tsc[3]) ) )
			
			Ent.Turbocharged = tobool( MEMORY.HasTurbo )
			Ent.Supercharged = tobool( MEMORY.HasBlower )
			
			Ent:SetEngineSoundPreset( math.Clamp( tonumber( MEMORY.SoundPreset ), -1, 23) )
			Ent:SetMaxTorque( math.Clamp( tonumber( MEMORY.PeakTorque ), 20, 1000) )
			Ent:SetDifferentialGear( math.Clamp( tonumber( MEMORY.FinalGear ),0.2, 6 ) )
			
			Ent:SetSteerSpeed( math.Clamp( tonumber( MEMORY.SteerSpeed ), 1, 16 ) )
			Ent:SetFastSteerAngle( math.Clamp( tonumber( MEMORY.SteerAngFast ), 0, 1) )
			Ent:SetFastSteerConeFadeSpeed( math.Clamp( tonumber( MEMORY.SteerFadeSpeed ), 1, 5000 ) )
			
			Ent:SetEfficiency( math.Clamp( tonumber( MEMORY.Efficiency ) ,0.2,4) )
			Ent:SetMaxTraction( math.Clamp( tonumber( MEMORY.MaxTraction ) , 5,1000) )
			Ent:SetTractionBias( math.Clamp( tonumber( MEMORY.GripOffset ),-0.99,0.99) )
			Ent:SetPowerDistribution( math.Clamp( tonumber( MEMORY.PowerDistribution ) ,-1,1) )
			
			Ent:SetBackFire( tobool( MEMORY.HasBackfire ) )
			Ent:SetDoNotStall( tobool( MEMORY.DoesntStall ) )
			
			Ent:SetIdleRPM( math.Clamp( tonumber( MEMORY.IdleRPM ),1,25000) )
			Ent:SetLimitRPM( math.Clamp( tonumber( MEMORY.MaxRPM ),4,25000) )
			Ent:SetRevlimiter( tobool( MEMORY.HasRevLimiter ) )
			Ent:SetPowerBandEnd( math.Clamp( tonumber( MEMORY.PowerEnd ), 3, 25000) )
			Ent:SetPowerBandStart( math.Clamp( tonumber( MEMORY.PowerStart ) ,2 ,25000) )
			
			Ent:SetTurboCharged( Ent.Turbocharged )
			Ent:SetSuperCharged( Ent.Supercharged )
			Ent:SetBrakePower( math.Clamp( tonumber( MEMORY.BrakePower ), 0.1, 500) )
			
			Ent:SetSoundoverride( MEMORY.SoundOverride or "" )
			
			Ent:SetLights_List( Ent.LightsTable or "no_lights" )
						
			Ent.snd_horn = MEMORY.HornSound
			
			Ent.snd_blowoff = MEMORY.snd_blowoff
			Ent.snd_spool = MEMORY.snd_spool
			Ent.snd_bloweron = MEMORY.snd_bloweron
			Ent.snd_bloweroff = MEMORY.snd_bloweroff
			
			Ent:SetBackfireSound( MEMORY.backfiresound or "" )
			
			local Gears = {}
			local Data = string.Explode( ",", MEMORY.Gears  )
			for i = 1, table.Count( Data ) do 
				local gRatio = tonumber( Data[i] )
				
				if isnumber( gRatio ) then
					if i == 1 then
						Gears[i] = math.Clamp( gRatio, -5, -0.001)
						
					elseif i == 2 then
						Gears[i] = 0
						
					else
						Gears[i] = math.Clamp( gRatio, 0.001, 5)
					end
				end
			end
			Ent.Gears = Gears
			
			if istable( MEMORY.SubMaterials ) then
				for i = 0, table.Count( MEMORY.SubMaterials ) do
					Ent:SetSubMaterial( i, MEMORY.SubMaterials[i] )
				end
			end
			
			if MEMORY.FrontDampingOverride and MEMORY.FrontConstantOverride and MEMORY.RearDampingOverride and MEMORY.RearConstantOverride then
				Ent.FrontDampingOverride = tonumber( MEMORY.FrontDampingOverride )
				Ent.FrontConstantOverride = tonumber( MEMORY.FrontConstantOverride )
				Ent.RearDampingOverride = tonumber( MEMORY.RearDampingOverride )
				Ent.RearConstantOverride = tonumber( MEMORY.RearConstantOverride )
				
				local data = {
					[1] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[2] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[3] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[4] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[5] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[6] = {Ent.RearConstantOverride,Ent.RearDampingOverride}
				}
				
				local elastics = Ent.Elastics
				if elastics then
					for i = 1, table.Count( elastics ) do
						local elastic = elastics[i]
						if Ent.StrengthenSuspension == true then
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
							local elastic2 = elastics[i * 10]
							if IsValid( elastic2 ) then
								elastic2:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic2:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
						else
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1], 0 )
								elastic:Fire( "SetSpringDamping", data[i][2], 0 )
							end
						end
					end
				end
			end
			
			Ent:SetFrontSuspensionHeight( tonumber( MEMORY.FrontHeight ) )
			Ent:SetRearSuspensionHeight( tonumber( MEMORY.RearHeight ) )
			
			local groups = string.Explode( ",", MEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( MEMORY.Skin )
			
			local c = string.Explode( ",", MEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
			
			if Ent.CustomWheels then
				if Ent.GhostWheels then
					if not IsValid( Ent ) then return end
					if MEMORY.WheelTool_Foffset and MEMORY.WheelTool_Roffset then
						SetWheelOffset( Ent, MEMORY.WheelTool_Foffset, MEMORY.WheelTool_Roffset )
					end
					
					if not MEMORY.FrontWheelOverride and not MEMORY.RearWheelOverride then return end
					
					local front_model = MEMORY.FrontWheelOverride or vehicle.Members.CustomWheelModel
					local front_angle = GetAngleFromSpawnlist(front_model)
					
					local camber = MEMORY.Camber or 0
					local rear_model = MEMORY.RearWheelOverride or (vehicle.Members.CustomWheelModel_R and vehicle.Members.CustomWheelModel_R or front_model)
					local rear_angle = GetAngleFromSpawnlist(rear_model)
					
					if not front_model or not rear_model or not front_angle or not rear_angle then return end
					
					if ValidateModel( front_model ) and ValidateModel( rear_model ) then 
						Ent.Camber = camber
						ApplyWheel(Ent, {front_model,front_angle,rear_model,rear_angle,camber})
					else
						ply:PrintMessage( HUD_PRINTTALK, "selected wheel does not exist on the server")
					end
				end
			end
		end)
		
		
		Ent.uvclasstospawnon = uvnextclasstospawn

		table.insert(UVVehicleInitializing, Ent)
		
	elseif vehiclebase == 1 then --Default Vehicle Base
		local saved_vehicles = UV_GetFiles( "prop_vehicle_jeep>>traffic" )
		
		for i, v in ipairs(saved_vehicles) do
			table.insert(availabletraffic, v)
		end
		
		if saved_vehicles == nil or next(saved_vehicles) == nil then
			if not UVNoTrafficNotify then
				UVNoTrafficNotify = true
				PrintMessage( HUD_PRINTTALK, "There's currently no Traffic to spawn. Use the Traffic Manager tool to add Traffic!")
			end
			return
		end

		UVNoTrafficNotify = nil
		
		availabletraffic = saved_vehicles[math.random(1, #saved_vehicles)]
		
		if commanderrespawn then
			availabletraffic = commanderrespawn
			uvnextclasstospawn = "npc_uvcommander"
		end
		
		local DataString = UV_LoadFile( "prop_vehicle_jeep>>traffic", availabletraffic )
		
		local words = string.Explode( "", DataString )
		local shit = {}
		
		for k, v in pairs( words ) do
			shit[k] =  string.char( string.byte( v ) - 20 )
		end
		
		local Data = string.Explode( "#", string.Implode("",shit) )
		
		for _,v in pairs(Data) do
			local Var = string.Explode( "=", v )
			local name = Var[1]
			local variable = Var[2]
			
			if name and variable then
				if name == "SubMaterials" then
					MEMORY[name] = {}
					
					local submats = string.Explode( ",", variable )
					for i = 0, (table.Count( submats ) - 1) do
						MEMORY[name][i] = submats[i+1]
					end
				else
					MEMORY[name] = variable
				end
			end
		end
		
		if not istable(MEMORY) then return end
		
		local class = MEMORY.SpawnName
		
		local vehicles = list.Get("Vehicles")
		local lst = vehicles[class]
		if not lst then
			PrintMessage( HUD_PRINTTALK, "The vehicle '"..class.."' is missing! Ensure that you have selected the correct vehicle base inside Traffic Manager settings!")
			return
		end
		
		uvspawnpointangles.yaw = uvspawnpointangles.yaw - 90
		uvspawnpointangles.yaw = rhinoattack and not posspecified and uvspawnpointangles.yaw or uvspawnpointangles.yaw + 180
		
		local Ent = ents.Create("prop_vehicle_jeep")
		Ent.VehicleTable = lst
		Ent.VehicleName = MEMORY.VehicleName
		Ent:SetModel(lst.Model) 
		Ent:SetPos(uvspawnpoint+ (vector_up * 50))
		Ent:SetAngles(uvspawnpointangles)
		Ent:SetKeyValue("vehiclescript", lst.KeyValues.vehiclescript)
		Ent:SetVehicleClass( class )
		Ent:Spawn()
		Ent:Activate()
		
		local vehicle = Ent
		if IsValid(Entity(1)) then
			gamemode.Call( "PlayerSpawnedVehicle", Entity(1), vehicle ) --Some vehicles has different models implanted together, so do that.
		end
		
		if istable( MEMORY.SubMaterials ) then
			for i = 0, table.Count( MEMORY.SubMaterials ) do
				Ent:SetSubMaterial( i, MEMORY.SubMaterials[i] )
			end
		end
		
		timer.Simple(0.5, function()
			if not IsValid(Ent) then return end
			local groups = string.Explode( ",", MEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( MEMORY.Skin )
			
			local c = string.Explode( ",", MEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
		end)
		
		Ent.uvclasstospawnon = uvnextclasstospawn

		table.insert(UVVehicleInitializing, Ent)
		
	else
		PrintMessage( HUD_PRINTTALK, "Invalid Vehicle Base! Reverting to Default Vehicle Base! Please set the Vehicle Base in the Unit Manager Tool settings!")
		RunConsoleCommand("unitvehicle_traffic_vehiclebase", 1)
	end
	
end

function UVAutoSpawnRacer()
	
	local ply = Entity(1)
	
	local uvnextclasstospawn = "npc_racervehicle"
	local enemylocation
	local suspect
	local suspectvelocity = Vector(0,0,0)

	if next(dvd.Waypoints) == nil then
		if not UVNoDVWaypointsNotify then
			net.Start("UV_OpenDVWarning")
			net.Broadcast()
		end
		return
	end

	UVNoDVWaypointsNotify = nil
	
	if next(UVPotentialSuspects) ~= nil then
		local suspects = UVPotentialSuspects
		local random_entry = math.random(#suspects)
		suspect = UVGetRaceLeader() or suspects[random_entry]
		
		enemylocation = (suspect:GetPos() + Vector(0, 0, 50))
		suspectvelocity = suspect:GetVelocity()
	elseif not playercontrolled then
		enemylocation = dvd.Waypoints[math.random(#dvd.Waypoints)]["Target"] + Vector(0, 0, 50)
	else
		enemylocation = ply:GetPos() + Vector(0, 0, 50)
	end
	
	local enemywaypoint = dvd.GetNearestWaypoint(enemylocation)
	local waypointtable = {}
	for k, v in ipairs(dvd.Waypoints) do
		local Waypoint = v["Target"]
		local distance = enemylocation - Waypoint
		local vect = distance:GetNormalized()
		local evectdot = vect:Dot(suspectvelocity)
		if distance:LengthSqr() > 25000000 and v["Group"] == 0 then
			table.insert(waypointtable, v)
		end
	end
	
	if next(waypointtable) ~= nil then
		uvspawnpointwaypoint = waypointtable[math.random(#waypointtable)]
		uvspawnpoint = uvspawnpointwaypoint["Target"]
	else
		uvspawnpointwaypoint = dvd.Waypoints[math.random(#dvd.Waypoints)]
		uvspawnpoint = uvspawnpointwaypoint["Target"]
	end

	local neighbor = dvd.Waypoints[uvspawnpointwaypoint.Neighbors[math.random(#uvspawnpointwaypoint.Neighbors)]]

	if neighbor then
		local neighborpoint = neighbor["Target"]
		local neighbordistance = neighborpoint - uvspawnpoint
		uvspawnpointangles = neighbordistance:Angle()+Angle(0,180,0)
	else
		uvspawnpointangles = Angle(0,math.random(0,360),0)
	end
	
	if posspecified then
		uvspawnpoint = posspecified
	end
	if angles then
		uvspawnpointangles = angles
	end
	
	local vehiclebase = UVRVehicleBase:GetInt()
	local availableracers = {}
	local availableracer
	local MEMORY = {}
	
	-- Override mode
	local OverrideEnabled = GetConVar("unitvehicle_racer_assignracers"):GetBool()
	local OverrideList = string.Trim(GetConVar("unitvehicle_racer_racers"):GetString())
	local OverrideVehicles = string.Explode(" ", OverrideList)

	if OverrideEnabled and #OverrideVehicles > 0 then
		local uvnextclasstospawn = "npc_racervehicle"

		-- Pick a random vehicle from the override list
		local class_name = OverrideVehicles[math.random(1, #OverrideVehicles)]

		if vehiclebase == 3 or vehiclebase == 4 then
			-- Glide
			local Ent = ents.Create(class_name)
			if IsValid(Ent) then
				Ent:SetPos(uvspawnpoint + Vector(0,0,50))
				Ent:SetAngles(uvspawnpointangles)
				Ent:Spawn()
				Ent:Activate()

				-- Tag for AI
				Ent.uvclasstospawnon = uvnextclasstospawn
				table.insert(UVVehicleInitializing, Ent)
			end

		elseif vehiclebase == 2 then
			-- Simfphys
			local VehicleList = list.Get("simfphys_vehicles")
			local vehicle = VehicleList[class_name]

			if vehicle then
				local SpawnPos = uvspawnpoint + (vector_up * 50) + (vehicle.SpawnOffset or vector_origin)
				local SpawnAng = uvspawnpointangles
				SpawnAng.pitch = 0
				SpawnAng.yaw = SpawnAng.yaw + 180
				SpawnAng.roll = 0

				local Ent = simfphys.SpawnVehicle(Entity(1), SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, class_name, vehicle)
				if IsValid(Ent) then
					Ent.uvclasstospawnon = uvnextclasstospawn
					table.insert(UVVehicleInitializing, Ent)
				end
			else
				PrintMessage(HUD_PRINTTALK, "Simfphys vehicle '"..class_name.."' not found! Ensure that you have selected the correct vehicle base inside AI Racer Manager settings!")
			end

		elseif vehiclebase == 1 then
			-- HL2 Jeep
			local Vehicles = list.Get("Vehicles")
			local vehData = Vehicles[class_name]

			if vehData then
				local Ent = ents.Create("prop_vehicle_jeep")
				Ent.VehicleTable = vehData
				Ent.VehicleName = vehData.PrintName or class_name
				Ent:SetModel(vehData.Model)
				Ent:SetPos(uvspawnpoint + Vector(0,0,50))
				Ent:SetAngles(uvspawnpointangles)
				Ent:SetKeyValue("vehiclescript", vehData.KeyValues.vehiclescript)
				Ent:SetVehicleClass(class_name)
				Ent:Spawn()
				Ent:Activate()

				Ent.uvclasstospawnon = uvnextclasstospawn
				table.insert(UVVehicleInitializing, Ent)
			else
				PrintMessage(HUD_PRINTTALK, "HL2 Jeep vehicle '"..class_name.."' not found! Ensure that you have selected the correct vehicle base inside AI Racer Manager settings!")
			end
		end

		return -- skip the rest of the function
	end

	local AssignedRacers = string.Trim( GetConVar( 'unitvehicle_racer_racers' ):GetString() )
	local AssignedRacersStrings = string.Explode( " ", AssignedRacers )
	
	if vehiclebase == 4 then --LVS
		local saved_vehicles = UV_GetFiles( "lvs>>racers" )

		if saved_vehicles == nil or next(saved_vehicles) == nil then
			if not UVNoRacerNotify then
				UVNoRacerNotify = true
				PrintMessage( HUD_PRINTTALK, "There are no Racers to spawn. Use the Racer Manager tool to add Racers!")
			end
			return
		end
		UVNoRacerNotify = nil
		
		if UVRAssignRacers:GetBool() then
			for k, v in pairs(saved_vehicles) do
				local match
				for _, string in pairs(AssignedRacersStrings) do
					if string == v then
						match = true
						break
					end
				end
				if match then
					table.insert(availableracers, v)
				end
			end

			if next(availableracers) == nil then
				PrintMessage( HUD_PRINTTALK, "Unit Manager attempted to spawn a Racer that is NOT in the database. Ensure that you have selected the correct vehicle base inside AI Racer Manager settings!")
				return
			end

			availableracer = availableracers[math.random(1, #availableracers)]
		else
			availableracer = saved_vehicles[math.random(1, #saved_vehicles)]
		end
		
		local JSONData = UV_LoadFile( "lvs>>racers", availableracer )
		
		MEMORY = util.JSONToTable(JSONData, true)

		local createdEntities = {}

		local entCount = 0

		for _, _ in pairs(MEMORY.Entities) do
			entCount = entCount + 1
		end

		for id, v in pairs(MEMORY.Entities) do
			local Ent = ents.Create( v.Class )
			if not IsValid( Ent ) then continue end

			local pos, ang = LocalToWorld( v.Pos, ( (entCount > 1 and v.Angle) or Angle(0,0,0) ), uvspawnpoint + Vector( 0, 0, 50 ), uvspawnpointangles + Angle(0,180,0) ) -- rotate entities 180 degrees to face the right way of dv

			duplicator.DoGeneric( Ent, v )

			Ent:SetPos( pos )
			Ent:SetAngles( ang )

			table.Merge( Ent:GetTable(), v )

			Ent:Spawn()
			Ent:Activate()

			if ( Ent.RestoreNetworkVars ) then
				Ent:RestoreNetworkVars( v.DT )
			end

			if ( Ent.OnDuplicated ) then
				Ent:OnDuplicated( v )
			end

			createdEntities[id] = Ent

			if createdEntities[id] then
				createdEntities[id].BoneMods = table.Copy( v.BoneMods )
				createdEntities[id].EntityMods = table.Copy( v.EntityMods )
				createdEntities[id].PhysicsObjects = table.Copy( v.PhysicsObjects )
			end

			if MEMORY.SubMaterials then
				if istable( MEMORY.SubMaterials ) then
					for i = 0, table.Count( MEMORY.SubMaterials ) do
						createdEntities[id]:SetSubMaterial( i, MEMORY.SubMaterials[i] )
					end
				end
				
				local groups = string.Explode( ",", MEMORY.BodyGroups)
				for i = 1, table.Count( groups ) do
					createdEntities[id]:SetBodygroup(i, tonumber(groups[i]) )
				end
				
				createdEntities[id]:SetSkin( MEMORY.Skin )
				
				local c = string.Explode( ",", MEMORY.Color )
				local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
				
				local dot = Color.r * Color.g * Color.b * Color.a
				Ent.OldColor = dot
	
				if MEMORY.SaveColor then
					createdEntities[id]:SetColor( Color )
				else
					if isfunction(Ent.GetSpawnColor) then
						Color = createdEntities[id]:GetSpawnColor()
						createdEntities[id]:SetColor( Color )
					else
						Color.r = math.random(0, 255)
						Color.g = math.random(0, 255)
						Color.b = math.random(0, 255)
						createdEntities[id]:SetColor( Color )
					end
				end
				
				local data = {
					Color = Color,
					RenderMode = 0,
					RenderFX = 0
				}
				duplicator.StoreEntityModifier( createdEntities[id], "colour", data )
			end

			createdEntities[id].uvclasstospawnon = uvnextclasstospawn

			table.insert(UVVehicleInitializing, createdEntities[id])
		end

		for _, v in pairs(MEMORY.Constraints) do
			local constraintEntity = UVCreateConstraintsFromTable( v, createdEntities )
		end

		for k, v in pairs( createdEntities ) do
			duplicator.ApplyEntityModifiers( NULL, v )
			duplicator.ApplyBoneModifiers( NULL, v )
		end
	elseif vehiclebase == 3 then --Glide
		local saved_vehicles = UV_GetFiles( "glide>>racers" )

		if saved_vehicles == nil or next(saved_vehicles) == nil then
			if not UVNoRacerNotify then
				UVNoRacerNotify = true
				PrintMessage( HUD_PRINTTALK, "There are no Racers to spawn. Use the Racer Manager tool to add Racers!")
			end
			return
		end
		UVNoRacerNotify = nil
		
		if UVRAssignRacers:GetBool() then
			for k, v in pairs(saved_vehicles) do
				local match
				for _, string in pairs(AssignedRacersStrings) do
					if string == v then
						match = true
						break
					end
				end
				if match then
					table.insert(availableracers, v)
				end
			end

			if next(availableracers) == nil then
				PrintMessage( HUD_PRINTTALK, "Unit Manager attempted to spawn a Racer that is NOT in the database. Ensure that you have selected the correct vehicle base inside AI Racer Manager settings!")
				return
			end

			availableracer = availableracers[math.random(1, #availableracers)]
		else
			availableracer = saved_vehicles[math.random(1, #saved_vehicles)]
		end
		
		local JSONData = UV_LoadFile( "glide>>racers", availableracer )
		
		MEMORY = util.JSONToTable(JSONData, true)

		local createdEntities = {}

		local entCount = 0

		for _, _ in pairs(MEMORY.Entities) do
			entCount = entCount + 1
		end

		for id, v in pairs(MEMORY.Entities) do
			local Ent = ents.Create( v.Class )
			if not IsValid( Ent ) then continue end

			local pos, ang = LocalToWorld( v.Pos, ( (entCount > 1 and v.Angle) or Angle(0,0,0) ), uvspawnpoint + Vector( 0, 0, 50 ), uvspawnpointangles + Angle(0,180,0) ) -- rotate entities 180 degrees to face the right way of dv

			duplicator.DoGeneric( Ent, v )

			Ent:SetPos( pos )
			Ent:SetAngles( ang )

			table.Merge( Ent:GetTable(), v )

			Ent:Spawn()
			Ent:Activate()

			if ( Ent.RestoreNetworkVars ) then
				Ent:RestoreNetworkVars( v.DT )
			end

			if ( Ent.OnDuplicated ) then
				Ent:OnDuplicated( v )
			end

			createdEntities[id] = Ent

			if createdEntities[id] then
				createdEntities[id].BoneMods = table.Copy( v.BoneMods )
				createdEntities[id].EntityMods = table.Copy( v.EntityMods )
				createdEntities[id].PhysicsObjects = table.Copy( v.PhysicsObjects )
			end

			if MEMORY.SubMaterials then
				if istable( MEMORY.SubMaterials ) then
					for i = 0, table.Count( MEMORY.SubMaterials ) do
						createdEntities[id]:SetSubMaterial( i, MEMORY.SubMaterials[i] )
					end
				end
				
				local groups = string.Explode( ",", MEMORY.BodyGroups)
				for i = 1, table.Count( groups ) do
					createdEntities[id]:SetBodygroup(i, tonumber(groups[i]) )
				end
				
				createdEntities[id]:SetSkin( MEMORY.Skin )
				
				local c = string.Explode( ",", MEMORY.Color )
				local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
				
				local dot = Color.r * Color.g * Color.b * Color.a
				Ent.OldColor = dot
	
				if MEMORY.SaveColor then
					createdEntities[id]:SetColor( Color )
				else
					if isfunction(Ent.GetSpawnColor) then
						Color = createdEntities[id]:GetSpawnColor()
						createdEntities[id]:SetColor( Color )
					else
						Color.r = math.random(0, 255)
						Color.g = math.random(0, 255)
						Color.b = math.random(0, 255)
						createdEntities[id]:SetColor( Color )
					end
				end
				
				local data = {
					Color = Color,
					RenderMode = 0,
					RenderFX = 0
				}
				duplicator.StoreEntityModifier( createdEntities[id], "colour", data )
			end

			createdEntities[id].uvclasstospawnon = uvnextclasstospawn

			table.insert(UVVehicleInitializing, createdEntities[id])
		end

		for _, v in pairs(MEMORY.Constraints) do
			local constraintEntity = UVCreateConstraintsFromTable( v, createdEntities )
		end

		for k, v in pairs( createdEntities ) do
			duplicator.ApplyEntityModifiers( NULL, v )
			duplicator.ApplyBoneModifiers( NULL, v )
		end

	elseif vehiclebase == 2 then --simfphys
		
		local saved_vehicles = UV_GetFiles( "simfphys>>racers" )
		
		if saved_vehicles == nil or next(saved_vehicles) == nil then
			if not UVNoRacerNotify then
				UVNoRacerNotify = true
				PrintMessage( HUD_PRINTTALK, "There are no Racers to spawn. Use the Racer Manager tool to add Racers!")
			end
			return
		end
		UVNoRacerNotify = nil
		
		if UVRAssignRacers:GetBool() then
			for k, v in pairs(saved_vehicles) do
				local match
				for _, string in pairs(AssignedRacersStrings) do
					if string == v then
						match = true
						break
					end
				end
				if match then
					table.insert(availableracers, v)
				end
			end

			if next(availableracers) == nil then
				PrintMessage( HUD_PRINTTALK, "Unit Manager attempted to spawn a Racer that is NOT in the database. Ensure that you have selected the correct vehicle base inside AI Racer Manager settings!")
				return
			end

			availableracer = availableracers[math.random(1, #availableracers)]
		else
			availableracer = saved_vehicles[math.random(1, #saved_vehicles)]
		end
		
		local DataString = UV_LoadFile( "simfphys>>racers", availableracer )
		
		local words = string.Explode( "", DataString )
		local shit = {}
		
		for k, v in pairs( words ) do
			shit[k] =  string.char( string.byte( v ) - 20 )
		end
		
		local Data = string.Explode( "#", string.Implode("",shit) )
		
		for _,v in pairs(Data) do
			local Var = string.Explode( "=", v )
			local name = Var[1]
			local variable = Var[2]
			
			if name and variable then
				if name == "SubMaterials" then
					MEMORY[name] = {}
					
					local submats = string.Explode( ",", variable )
					for i = 0, (table.Count( submats ) - 1) do
						MEMORY[name][i] = submats[i+1]
					end
				else
					MEMORY[name] = variable
				end
			end
		end
		
		if not istable(MEMORY) then return end
		
		local Ent
		
		local vname = MEMORY.SpawnName
		local VehicleList = list.Get( "simfphys_vehicles" )
		local vehicle = VehicleList[ vname ]
		
		if not vehicle then 
			PrintMessage( HUD_PRINTTALK, "The vehicle class '"..vname.."' dosen't seem to be installed! Ensure that you have selected the correct vehicle base inside AI Racer Manager settings!")
			return false 
		end
		
		local SpawnPos = uvspawnpoint + (vector_up * 50) + (vehicle.SpawnOffset or vector_origin)
		
		local SpawnAng = uvspawnpointangles
		SpawnAng.pitch = 0
		SpawnAng.yaw = SpawnAng.yaw + 180
		SpawnAng.yaw = SpawnAng.yaw + (vehicle.SpawnAngleOffset and vehicle.SpawnAngleOffset or 0)
		SpawnAng.roll = 0
		
		Ent = simfphys.SpawnVehicle( ply, SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, vname, vehicle, true )
		
		if not IsValid( Ent ) then return end
		
		timer.Simple( 0.5, function()
			if not IsValid(Ent) then return end
			
			local tsc = string.Explode( ",", MEMORY.TireSmokeColor )
			Ent:SetTireSmokeColor( Vector( tonumber(tsc[1]), tonumber(tsc[2]), tonumber(tsc[3]) ) )
			
			Ent.Turbocharged = tobool( MEMORY.HasTurbo )
			Ent.Supercharged = tobool( MEMORY.HasBlower )
			
			Ent:SetEngineSoundPreset( math.Clamp( tonumber( MEMORY.SoundPreset ), -1, 23) )
			Ent:SetMaxTorque( math.Clamp( tonumber( MEMORY.PeakTorque ), 20, 1000) )
			Ent:SetDifferentialGear( math.Clamp( tonumber( MEMORY.FinalGear ),0.2, 6 ) )
			
			Ent:SetSteerSpeed( math.Clamp( tonumber( MEMORY.SteerSpeed ), 1, 16 ) )
			Ent:SetFastSteerAngle( math.Clamp( tonumber( MEMORY.SteerAngFast ), 0, 1) )
			Ent:SetFastSteerConeFadeSpeed( math.Clamp( tonumber( MEMORY.SteerFadeSpeed ), 1, 5000 ) )
			
			Ent:SetEfficiency( math.Clamp( tonumber( MEMORY.Efficiency ) ,0.2,4) )
			Ent:SetMaxTraction( math.Clamp( tonumber( MEMORY.MaxTraction ) , 5,1000) )
			Ent:SetTractionBias( math.Clamp( tonumber( MEMORY.GripOffset ),-0.99,0.99) )
			Ent:SetPowerDistribution( math.Clamp( tonumber( MEMORY.PowerDistribution ) ,-1,1) )
			
			Ent:SetBackFire( tobool( MEMORY.HasBackfire ) )
			Ent:SetDoNotStall( tobool( MEMORY.DoesntStall ) )
			
			Ent:SetIdleRPM( math.Clamp( tonumber( MEMORY.IdleRPM ),1,25000) )
			Ent:SetLimitRPM( math.Clamp( tonumber( MEMORY.MaxRPM ),4,25000) )
			Ent:SetRevlimiter( tobool( MEMORY.HasRevLimiter ) )
			Ent:SetPowerBandEnd( math.Clamp( tonumber( MEMORY.PowerEnd ), 3, 25000) )
			Ent:SetPowerBandStart( math.Clamp( tonumber( MEMORY.PowerStart ) ,2 ,25000) )
			
			Ent:SetTurboCharged( Ent.Turbocharged )
			Ent:SetSuperCharged( Ent.Supercharged )
			Ent:SetBrakePower( math.Clamp( tonumber( MEMORY.BrakePower ), 0.1, 500) )
			
			Ent:SetSoundoverride( MEMORY.SoundOverride or "" )
			
			Ent:SetLights_List( Ent.LightsTable or "no_lights" )
						
			Ent.snd_horn = MEMORY.HornSound
			
			Ent.snd_blowoff = MEMORY.snd_blowoff
			Ent.snd_spool = MEMORY.snd_spool
			Ent.snd_bloweron = MEMORY.snd_bloweron
			Ent.snd_bloweroff = MEMORY.snd_bloweroff
			
			Ent:SetBackfireSound( MEMORY.backfiresound or "" )
			
			local Gears = {}
			local Data = string.Explode( ",", MEMORY.Gears  )
			for i = 1, table.Count( Data ) do 
				local gRatio = tonumber( Data[i] )
				
				if isnumber( gRatio ) then
					if i == 1 then
						Gears[i] = math.Clamp( gRatio, -5, -0.001)
						
					elseif i == 2 then
						Gears[i] = 0
						
					else
						Gears[i] = math.Clamp( gRatio, 0.001, 5)
					end
				end
			end
			Ent.Gears = Gears
			
			if istable( MEMORY.SubMaterials ) then
				for i = 0, table.Count( MEMORY.SubMaterials ) do
					Ent:SetSubMaterial( i, MEMORY.SubMaterials[i] )
				end
			end
			
			if MEMORY.FrontDampingOverride and MEMORY.FrontConstantOverride and MEMORY.RearDampingOverride and MEMORY.RearConstantOverride then
				Ent.FrontDampingOverride = tonumber( MEMORY.FrontDampingOverride )
				Ent.FrontConstantOverride = tonumber( MEMORY.FrontConstantOverride )
				Ent.RearDampingOverride = tonumber( MEMORY.RearDampingOverride )
				Ent.RearConstantOverride = tonumber( MEMORY.RearConstantOverride )
				
				local data = {
					[1] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[2] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[3] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[4] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[5] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[6] = {Ent.RearConstantOverride,Ent.RearDampingOverride}
				}
				
				local elastics = Ent.Elastics
				if elastics then
					for i = 1, table.Count( elastics ) do
						local elastic = elastics[i]
						if Ent.StrengthenSuspension == true then
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
							local elastic2 = elastics[i * 10]
							if IsValid( elastic2 ) then
								elastic2:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic2:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
						else
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1], 0 )
								elastic:Fire( "SetSpringDamping", data[i][2], 0 )
							end
						end
					end
				end
			end
			
			Ent:SetFrontSuspensionHeight( tonumber( MEMORY.FrontHeight ) )
			Ent:SetRearSuspensionHeight( tonumber( MEMORY.RearHeight ) )
			
			local groups = string.Explode( ",", MEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( MEMORY.Skin )
			
			local c = string.Explode( ",", MEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
			
			if Ent.CustomWheels then
				if Ent.GhostWheels then
					if not IsValid( Ent ) then return end
					if MEMORY.WheelTool_Foffset and MEMORY.WheelTool_Roffset then
						SetWheelOffset( Ent, MEMORY.WheelTool_Foffset, MEMORY.WheelTool_Roffset )
					end
					
					if not MEMORY.FrontWheelOverride and not MEMORY.RearWheelOverride then return end
					
					local front_model = MEMORY.FrontWheelOverride or vehicle.Members.CustomWheelModel
					local front_angle = GetAngleFromSpawnlist(front_model)
					
					local camber = MEMORY.Camber or 0
					local rear_model = MEMORY.RearWheelOverride or (vehicle.Members.CustomWheelModel_R and vehicle.Members.CustomWheelModel_R or front_model)
					local rear_angle = GetAngleFromSpawnlist(rear_model)
					
					if not front_model or not rear_model or not front_angle or not rear_angle then return end
					
					if ValidateModel( front_model ) and ValidateModel( rear_model ) then 
						Ent.Camber = camber
						ApplyWheel(Ent, {front_model,front_angle,rear_model,rear_angle,camber})
					else
						ply:PrintMessage( HUD_PRINTTALK, "selected wheel does not exist on the server")
					end
				end
			end
		end)
		
		
		Ent.uvclasstospawnon = uvnextclasstospawn

		table.insert(UVVehicleInitializing, Ent)
		
	elseif vehiclebase == 1 then --Default Vehicle Base
		local saved_vehicles = UV_GetFiles( "prop_vehicle_jeep>>racers" )
		
		if saved_vehicles == nil or next(saved_vehicles) == nil then
			if not UVNoRacerNotify then
				UVNoRacerNotify = true
				PrintMessage( HUD_PRINTTALK, "There are no Racers to spawn. Use the Racer Manager tool to add Racers!")
			end
			return
		end
		UVNoRacerNotify = nil
		
		if UVRAssignRacers:GetBool() then
			for k, v in pairs(saved_vehicles) do
				local match
				for _, string in pairs(AssignedRacersStrings) do
					if string == v then
						match = true
						break
					end
				end
				if match then
					table.insert(availableracers, v)
				end
			end

			if next(availableracers) == nil then
				PrintMessage( HUD_PRINTTALK, "Unit Manager attempted to spawn a Racer that is NOT in the database. Ensure that you have selected the correct vehicle base inside AI Racer Manager settings!")
				return
			end

			availableracer = availableracers[math.random(1, #availableracers)]
		else
			availableracer = saved_vehicles[math.random(1, #saved_vehicles)]
		end
		
		local DataString = UV_LoadFile( "prop_vehicle_jeep>>racers", availableracer )
		
		local words = string.Explode( "", DataString )
		local shit = {}
		
		for k, v in pairs( words ) do
			shit[k] =  string.char( string.byte( v ) - 20 )
		end
		
		local Data = string.Explode( "#", string.Implode("",shit) )
		
		for _,v in pairs(Data) do
			local Var = string.Explode( "=", v )
			local name = Var[1]
			local variable = Var[2]
			
			if name and variable then
				if name == "SubMaterials" then
					MEMORY[name] = {}
					
					local submats = string.Explode( ",", variable )
					for i = 0, (table.Count( submats ) - 1) do
						MEMORY[name][i] = submats[i+1]
					end
				else
					MEMORY[name] = variable
				end
			end
		end
		
		if not istable(MEMORY) then return end
		
		local class = MEMORY.SpawnName
		
		local vehicles = list.Get("Vehicles")
		local lst = vehicles[class]
		if not lst then
			PrintMessage( HUD_PRINTTALK, "The vehicle '"..class.."' is missing! Ensure that you have selected the correct vehicle base inside AI Racer Manager settings!")
			return
		end
		
		uvspawnpointangles.yaw = uvspawnpointangles.yaw - 90
		uvspawnpointangles.yaw = rhinoattack and not posspecified and uvspawnpointangles.yaw or uvspawnpointangles.yaw + 180
		
		local Ent = ents.Create("prop_vehicle_jeep")
		Ent.VehicleTable = lst
		Ent.VehicleName = MEMORY.VehicleName
		Ent:SetModel(lst.Model) 
		Ent:SetPos(uvspawnpoint+ (vector_up * 50))
		Ent:SetAngles(uvspawnpointangles)
		Ent:SetKeyValue("vehiclescript", lst.KeyValues.vehiclescript)
		Ent:SetVehicleClass( class )
		Ent:Spawn()
		Ent:Activate()
		if ( Ent.OnDuplicated ) then
			Ent:OnDuplicated( MEMORY )
		end
		
		local vehicle = Ent
		if IsValid(Entity(1)) then
			gamemode.Call( "PlayerSpawnedVehicle", Entity(1), vehicle ) --Some vehicles has different models implanted together, so do that.
		end
		
		if istable( MEMORY.SubMaterials ) then
			for i = 0, table.Count( MEMORY.SubMaterials ) do
				Ent:SetSubMaterial( i, MEMORY.SubMaterials[i] )
			end
		end
		
		timer.Simple(0.5, function()
			if not IsValid(Ent) then return end
			local groups = string.Explode( ",", MEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( MEMORY.Skin )
			
			local c = string.Explode( ",", MEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
		end)
		
		Ent.uvclasstospawnon = uvnextclasstospawn

		table.insert(UVVehicleInitializing, Ent)
		
	else
		PrintMessage( HUD_PRINTTALK, "Invalid Vehicle Base! Reverting to Default Vehicle Base! Please set the Vehicle Base in the Unit Manager Tool settings!")
		RunConsoleCommand("unitvehicle_racer_vehiclebase", 1)
	end
	
end

--RACE FUNCTIONS

local function GetVehicleData( ent )
	if not ent:IsValid() then return end
	local Memory = {}
	
	if ent.IsSimfphyscar then
		Memory.VehicleBase = ent:GetClass()
		Memory.SpawnName = ent:GetSpawn_List()
		Memory.SteerSpeed = ent:GetSteerSpeed()
		Memory.SteerFadeSpeed = ent:GetFastSteerConeFadeSpeed()
		Memory.SteerAngFast = ent:GetFastSteerAngle()
		Memory.SoundPreset = ent:GetEngineSoundPreset()
		Memory.IdleRPM = ent:GetIdleRPM()
		Memory.MaxRPM = ent:GetLimitRPM()
		Memory.PowerStart = ent:GetPowerBandStart()
		Memory.PowerEnd = ent:GetPowerBandEnd()
		Memory.PeakTorque = ent:GetMaxTorque()
		Memory.HasTurbo = ent:GetTurboCharged()
		Memory.HasBlower = ent:GetSuperCharged()
		Memory.HasRevLimiter = ent:GetRevlimiter()
		Memory.HasBulletProofTires = ent:GetBulletProofTires()
		Memory.MaxTraction = ent:GetMaxTraction()
		Memory.GripOffset = ent:GetTractionBias()
		Memory.BrakePower = ent:GetBrakePower()
		Memory.PowerDistribution = ent:GetPowerDistribution()
		Memory.Efficiency = ent:GetEfficiency()
		Memory.HornSound = ent.snd_horn
		Memory.HasBackfire = ent:GetBackFire()
		Memory.DoesntStall = ent:GetDoNotStall()
		Memory.SoundOverride = ent:GetSoundoverride()
		Memory.AddedYaw = UVCheckIfRedlineSimfphys(ent) and 180 or 90
		
		Memory.FrontHeight = ent:GetFrontSuspensionHeight()
		Memory.RearHeight = ent:GetRearSuspensionHeight()
		
		Memory.Camber = ent.Camber or 0
		
		if ent.FrontDampingOverride and ent.FrontConstantOverride and ent.RearDampingOverride and ent.RearConstantOverride then
			Memory.FrontDampingOverride = ent.FrontDampingOverride
			Memory.FrontConstantOverride = ent.FrontConstantOverride
			Memory.RearDampingOverride = ent.RearDampingOverride
			Memory.RearConstantOverride = ent.RearConstantOverride
		end
		
		if ent.CustomWheels then
			if ent.GhostWheels then
				if IsValid(ent.GhostWheels[1]) then
					Memory.FrontWheelOverride = ent.GhostWheels[1]:GetModel()
				elseif IsValid(ent.GhostWheels[2]) then
					Memory.FrontWheelOverride = ent.GhostWheels[2]:GetModel()
				end
				
				if IsValid(ent.GhostWheels[3]) then
					Memory.RearWheelOverride = ent.GhostWheels[3]:GetModel()
				elseif IsValid(ent.GhostWheels[4]) then
					Memory.RearWheelOverride = ent.GhostWheels[4]:GetModel()
				end
			end
		end
		
		local tsc = ent:GetTireSmokeColor()
		Memory.TireSmokeColor = tsc.r..","..tsc.g..","..tsc.b
		
		local Gears = ""
		for _,v in pairs(ent.Gears) do
			Gears = Gears..v..","
		end
		
		local c = ent:GetColor()
		Memory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		local bodygroups = {}
		for k,v in pairs(ent:GetBodyGroups()) do
			bodygroups[k] = ent:GetBodygroup( k ) 
		end
		
		Memory.BodyGroups = string.Implode( ",", bodygroups)
		
		Memory.Skin = ent:GetSkin()
		
		Memory.Gears = Gears
		Memory.FinalGear = ent:GetDifferentialGear()
		
		if ent.WheelTool_Foffset then
			Memory.WheelTool_Foffset = ent.WheelTool_Foffset
		end
		
		if ent.WheelTool_Roffset then
			Memory.WheelTool_Roffset = ent.WheelTool_Roffset
		end
		
		if ent.snd_blowoff then
			Memory.snd_blowoff = ent.snd_blowoff
		end
		
		if ent.snd_spool then
			Memory.snd_spool = ent.snd_spool
		end
		
		if ent.snd_bloweron then
			Memory.snd_bloweron = ent.snd_bloweron
		end
		
		if ent.snd_bloweroff then
			Memory.snd_bloweroff = ent.snd_bloweroff
		end
		
		Memory.backfiresound = ent:GetBackfireSound()
		
		Memory.SubMaterials = {}
		for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
			Memory.SubMaterials[i] = ent:GetSubMaterial( i )
		end
	elseif ent.IsGlideVehicle or ent.LVS then
		local pos = ent:GetPos()
		duplicator.SetLocalPos( pos )

		Memory = duplicator.Copy( ent )

		duplicator.SetLocalPos( vector_origin )
		duplicator.SetLocalAng( angle_zero )

		if not Memory then return false end

		local Key = "VehicleBase"
		Memory[Key] = ent.Base
		local Key2 = "SpawnName"
		Memory[Key2] = ent:GetClass()
		Memory.Mins = Vector(Memory.Mins.x,Memory.Mins.y,0)

		for k, v in pairs( Memory.Entities ) do
			local color = ent:GetColor()
			v.Color = color.r..","..color.g..","..color.b..","..color.a

			if ent.LVS then
				v.MaxHealth = ent:GetMaxHP()
				v.CurHealth = v.MaxHealth

				v.DT = nil
			end

			v.NitrousPower = ent.NitrousPower or 2
			v.NitrousDepletionRate = ent.NitrousDepletionRate or 0.5
			v.NitrousRegenRate = ent.NitrousRegenRate or 0.1
			v.NitrousRegenDelay = ent.NitrousRegenDelay or 2
			v.NitrousPitchChangeFrequency = ent.NitrousPitchChangeFrequency or 1 
			v.NitrousPitchMultiplier = ent.NitrousPitchMultiplier or 0.2
			v.NitrousBurst = ent.NitrousBurst or false
			v.NitrousColor = ent.NitrousColor or Color(35, 204, 255)
			v.NitrousStartSound = ent.NitrousStartSound or "glide_nitrous/nitrous_burst.wav"
			v.NitrousLoopingSound = ent.NitrousLoopingSound or "glide_nitrous/nitrous_burst.wav"
			v.NitrousEndSound = ent.NitrousEndSound or "glide_nitrous/nitrous_activation_whine.wav"
			v.NitrousEmptySound = ent.NitrousEmptySound or "glide_nitrous/nitrous_empty.wav"
			v.NitrousReadyBurstSound = ent.NitrousReadyBurstSound or "glide_nitrous/nitrous_burst/ready/ready.wav"
			v.NitrousStartBurstSound = ent.NitrousStartBurstSound or file.Find("sound/glide_nitrous/nitrous_burst/*", "GAME")
			v.NitrousStartBurstAnnotationSound = ent.NitrousStartBurstAnnotationSound or file.Find("sound/glide_nitrous/nitrous_burst/annotation/*", "GAME")
			v.CriticalDamageSound = ent.CriticalDamageSound or "glide_healthbar/criticaldamage.wav"
			v.NitrousEnabled = ent:GetNWBool( 'NitrousEnabled' )
		end

		-- if cffunctions then
		-- 	for k, v in pairs( Memory.Entities ) do
		-- 		local color = ent:GetColor()
		-- 		v.Color = color.r..","..color.g..","..color.b..","..color.a

		-- 		v.NitrousPower = ent.NitrousPower or 2
		-- 		v.NitrousDepletionRate = ent.NitrousDepletionRate or 0.5
		-- 		v.NitrousRegenRate = ent.NitrousRegenRate or 0.1
		-- 		v.NitrousRegenDelay = ent.NitrousRegenDelay or 2
		-- 		v.NitrousPitchChangeFrequency = ent.NitrousPitchChangeFrequency or 1 
		-- 		v.NitrousPitchMultiplier = ent.NitrousPitchMultiplier or 0.2
		-- 		v.NitrousBurst = ent.NitrousBurst or false
		-- 		v.NitrousColor = ent.NitrousColor or Color(35, 204, 255)
		-- 		v.NitrousStartSound = ent.NitrousStartSound or "glide_nitrous/nitrous_burst.wav"
		-- 		v.NitrousLoopingSound = ent.NitrousLoopingSound or "glide_nitrous/nitrous_burst.wav"
		-- 		v.NitrousEndSound = ent.NitrousEndSound or "glide_nitrous/nitrous_activation_whine.wav"
		-- 		v.NitrousEmptySound = ent.NitrousEmptySound or "glide_nitrous/nitrous_empty.wav"
		-- 		v.NitrousReadyBurstSound = ent.NitrousReadyBurstSound or "glide_nitrous/nitrous_burst/ready/ready.wav"
		-- 		v.NitrousStartBurstSound = ent.NitrousStartBurstSound or file.Find("sound/glide_nitrous/nitrous_burst/*", "GAME")
		-- 		v.NitrousStartBurstAnnotationSound = ent.NitrousStartBurstAnnotationSound or file.Find("sound/glide_nitrous/nitrous_burst/annotation/*", "GAME")
		-- 		v.CriticalDamageSound = ent.CriticalDamageSound or "glide_healthbar/criticaldamage.wav"
		-- 		v.NitrousEnabled = ent:GetNWBool( 'NitrousEnabled' )
		-- 	end
		-- end
		-- local pos = ent:GetPos()
		-- duplicator.SetLocalPos( pos )
		
		-- Memory = duplicator.Copy( ent )
		
		-- duplicator.SetLocalPos( vector_origin )
		-- duplicator.SetLocalAng( angle_zero )
		
		-- if ( not Memory ) then return false end
		
		-- local Key = "VehicleBase"
		-- Memory[Key] = ent.Base
		-- local Key2 = "SpawnName"
		-- Memory[Key2] = ent:GetClass()
		-- Memory.Mins = Vector(Memory.Mins.x,Memory.Mins.y,0)

		-- -- TODO: 
		-- -- Vehicles with spoilers attached via Bonemerge are currently not supported and will result in an error due to the code below.
		
		-- Memory.Entities[next(Memory.Entities)].Angle = Angle(0,180,0)
		-- Memory.Entities[next(Memory.Entities)].PhysicsObjects[0].Angle = Angle(0,180,0)
		
		-- local c = ent:GetColor()
		-- Memory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		-- local bodygroups = {}
		-- for k,v in pairs(ent:GetBodyGroups()) do
		-- 	bodygroups[k] = ent:GetBodygroup( k ) 
		-- end
		
		-- Memory.BodyGroups = string.Implode( ",", bodygroups)
		
		-- Memory.Skin = ent:GetSkin()
		
		-- Memory.SubMaterials = {}
		-- for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
		-- 	Memory.SubMaterials[i] = ent:GetSubMaterial( i )
		-- end

		-- if cffunctions then
		-- 	Memory.NitrousPower = ent.NitrousPower or 2
		-- 	Memory.NitrousDepletionRate = ent.NitrousDepletionRate or 0.5
		-- 	Memory.NitrousRegenRate = ent.NitrousRegenRate or 0.1
		-- 	Memory.NitrousRegenDelay = ent.NitrousRegenDelay or 2
		-- 	Memory.NitrousPitchChangeFrequency = ent.NitrousPitchChangeFrequency or 1 
		-- 	Memory.NitrousPitchMultiplier = ent.NitrousPitchMultiplier or 0.2
		-- 	Memory.NitrousBurst = ent.NitrousBurst or false
		-- 	Memory.NitrousColor = ent.NitrousColor or Color(35, 204, 255)
		-- 	Memory.NitrousStartSound = ent.NitrousStartSound or "glide_nitrous/nitrous_burst.wav"
		-- 	Memory.NitrousLoopingSound = ent.NitrousLoopingSound or "glide_nitrous/nitrous_burst.wav"
		-- 	Memory.NitrousEndSound = ent.NitrousEndSound or "glide_nitrous/nitrous_activation_whine.wav"
		-- 	Memory.NitrousEmptySound = ent.NitrousEmptySound or "glide_nitrous/nitrous_empty.wav"
		-- 	Memory.NitrousReadyBurstSound = ent.NitrousReadyBurstSound or "glide_nitrous/nitrous_burst/ready/ready.wav"
		-- 	Memory.NitrousStartBurstSound = ent.NitrousStartBurstSound or file.Find("sound/glide_nitrous/nitrous_burst/*", "GAME")
		-- 	Memory.NitrousStartBurstAnnotationSound = ent.NitrousStartBurstAnnotationSound or file.Find("sound/glide_nitrous/nitrous_burst/annotation/*", "GAME")
		-- 	Memory.CriticalDamageSound = ent.CriticalDamageSound or "glide_healthbar/criticaldamage.wav"
		-- 	Memory.NitrousEnabled = ent:GetNWBool( 'NitrousEnabled' )
		-- end
		
	elseif ent:GetClass() == "prop_vehicle_jeep" then
		Memory.VehicleBase = ent:GetClass()
		Memory.SpawnName = ent:GetVehicleClass()
		
		if not Memory.SpawnName then 
			print("This vehicle dosen't have a vehicle class set" )
			return 
		end
		
		local c = ent:GetColor()
		Memory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		local bodygroups = {}
		for k,v in pairs(ent:GetBodyGroups()) do
			bodygroups[k] = ent:GetBodygroup( k ) 
		end
		
		Memory.BodyGroups = string.Implode( ",", bodygroups)
		
		Memory.Skin = ent:GetSkin()
		
		Memory.SubMaterials = {}
		for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
			Memory.SubMaterials[i] = ent:GetSubMaterial( i )
		end
	end
	
	return Memory
	
end

function UVTeleportSimfphysVehicle( vehicle, pos, ang )
	local entrantvehicle = vehicle
	local PT = (vehicle.PursuitTech and table.Copy(vehicle.PursuitTech))
	
	local Memory = GetVehicleData( vehicle )
	
	local driver = vehicle:GetDriver()
	local ply = (IsValid(driver) and driver)
	
	local aienabled = not (driver and driver:IsPlayer())
	
	local racer_name = (ply and ply:GetName()) or (vehicle.racer or "Racer "..vehicle:EntIndex())
	
	ply = ply or Entity(1)
	
	local vname = Memory.SpawnName
	local Update = false
	local VehicleList = list.Get( "simfphys_vehicles" )
	local vehicle = VehicleList[ vname ]
	
	if not vehicle then return false end
	
	local SpawnPos = pos + (vector_up * 25) + (vehicle.SpawnOffset or vector_origin)
	
	local SpawnAng = ang
	SpawnAng.pitch = 0
	SpawnAng.yaw = SpawnAng.yaw  + 270 + (vehicle.SpawnAngleOffset and vehicle.SpawnAngleOffset or 0)
	SpawnAng.roll = 0
	
	Ent = simfphys.SpawnVehicle( ply, SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, vname, vehicle, true )
	
	if not IsValid( Ent ) then return end
	
	if not UVGame then
		undo.Create( "Vehicle" )
		undo.SetPlayer( ply )
		undo.AddEntity( Ent )
		undo.SetCustomUndoText( "Undone " .. vehicle.Name )
		undo.Finish( "Vehicle (" .. tostring( vehicle.Name ) .. ")" )
	end
	
	if not UVGame then
		ply:AddCleanup( "vehicles", Ent )
	end
	
	timer.Simple( 0.5, function()
		if not IsValid(Ent) then return end
		
		local tsc = string.Explode( ",", Memory.TireSmokeColor )
		Ent:SetTireSmokeColor( Vector( tonumber(tsc[1]), tonumber(tsc[2]), tonumber(tsc[3]) ) )
		
		Ent.Turbocharged = tobool( Memory.HasTurbo )
		Ent.Supercharged = tobool( Memory.HasBlower )
		
		Ent:SetEngineSoundPreset( math.Clamp( tonumber( Memory.SoundPreset ), -1, 23) )
		Ent:SetMaxTorque( math.Clamp( tonumber( Memory.PeakTorque ), 20, 1000) )
		Ent:SetDifferentialGear( math.Clamp( tonumber( Memory.FinalGear ),0.2, 6 ) )
		
		Ent:SetSteerSpeed( math.Clamp( tonumber( Memory.SteerSpeed ), 1, 16 ) )
		Ent:SetFastSteerAngle( math.Clamp( tonumber( Memory.SteerAngFast ), 0, 1) )
		Ent:SetFastSteerConeFadeSpeed( math.Clamp( tonumber( Memory.SteerFadeSpeed ), 1, 5000 ) )
		
		Ent:SetEfficiency( math.Clamp( tonumber( Memory.Efficiency ) ,0.2,4) )
		Ent:SetMaxTraction( math.Clamp( tonumber( Memory.MaxTraction ) , 5,1000) )
		Ent:SetTractionBias( math.Clamp( tonumber( Memory.GripOffset ),-0.99,0.99) )
		Ent:SetPowerDistribution( math.Clamp( tonumber( Memory.PowerDistribution ) ,-1,1) )
		
		Ent:SetBackFire( tobool( Memory.HasBackfire ) )
		Ent:SetDoNotStall( tobool( Memory.DoesntStall ) )
		
		Ent:SetIdleRPM( math.Clamp( tonumber( Memory.IdleRPM ),1,25000) )
		Ent:SetLimitRPM( math.Clamp( tonumber( Memory.MaxRPM ),4,25000) )
		Ent:SetRevlimiter( tobool( Memory.HasRevLimiter ) )
		Ent:SetPowerBandEnd( math.Clamp( tonumber( Memory.PowerEnd ), 3, 25000) )
		Ent:SetPowerBandStart( math.Clamp( tonumber( Memory.PowerStart ) ,2 ,25000) )
		
		Ent:SetTurboCharged( Ent.Turbocharged )
		Ent:SetSuperCharged( Ent.Supercharged )
		Ent:SetBrakePower( math.Clamp( tonumber( Memory.BrakePower ), 0.1, 500) )
		
		Ent:SetSoundoverride( Memory.SoundOverride or "" )
		
		Ent:SetLights_List( Ent.LightsTable or "no_lights" )
		
		Ent:SetBulletProofTires(true)
		
		Ent.snd_horn = Memory.HornSound
		
		Ent.snd_blowoff = Memory.snd_blowoff
		Ent.snd_spool = Memory.snd_spool
		Ent.snd_bloweron = Memory.snd_bloweron
		Ent.snd_bloweroff = Memory.snd_bloweroff
		
		Ent:SetBackfireSound( Memory.backfiresound or "" )
		
		local Gears = {}
		local Data = string.Explode( ",", Memory.Gears  )
		for i = 1, table.Count( Data ) do 
			local gRatio = tonumber( Data[i] )
			
			if isnumber( gRatio ) then
				if i == 1 then
					Gears[i] = math.Clamp( gRatio, -5, -0.001)
					
				elseif i == 2 then
					Gears[i] = 0
					
				else
					Gears[i] = math.Clamp( gRatio, 0.001, 5)
				end
			end
		end
		Ent.Gears = Gears
		
		if istable( Memory.SubMaterials ) then
			for i = 0, table.Count( Memory.SubMaterials ) do
				Ent:SetSubMaterial( i, Memory.SubMaterials[i] )
			end
		end
		
		if Memory.FrontDampingOverride and Memory.FrontConstantOverride and Memory.RearDampingOverride and Memory.RearConstantOverride then
			Ent.FrontDampingOverride = tonumber( Memory.FrontDampingOverride )
			Ent.FrontConstantOverride = tonumber( Memory.FrontConstantOverride )
			Ent.RearDampingOverride = tonumber( Memory.RearDampingOverride )
			Ent.RearConstantOverride = tonumber( Memory.RearConstantOverride )
			
			local data = {
				[1] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
				[2] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
				[3] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
				[4] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
				[5] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
				[6] = {Ent.RearConstantOverride,Ent.RearDampingOverride}
			}
			
			local elastics = Ent.Elastics
			if elastics then
				for i = 1, table.Count( elastics ) do
					local elastic = elastics[i]
					if Ent.StrengthenSuspension == true then
						if IsValid( elastic ) then
							elastic:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
							elastic:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
						end
						local elastic2 = elastics[i * 10]
						if IsValid( elastic2 ) then
							elastic2:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
							elastic2:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
						end
					else
						if IsValid( elastic ) then
							elastic:Fire( "SetSpringConstant", data[i][1], 0 )
							elastic:Fire( "SetSpringDamping", data[i][2], 0 )
						end
					end
				end
			end
		end
		
		Ent:SetFrontSuspensionHeight( tonumber( Memory.FrontHeight ) )
		Ent:SetRearSuspensionHeight( tonumber( Memory.RearHeight ) )
		
		local groups = string.Explode( ",", Memory.BodyGroups)
		for i = 1, table.Count( groups ) do
			Ent:SetBodygroup(i, tonumber(groups[i]) )
		end
		
		Ent:SetSkin( Memory.Skin )
		
		local c = string.Explode( ",", Memory.Color )
		local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
		
		local dot = Color.r * Color.g * Color.b * Color.a
		Ent.OldColor = dot
		Ent:SetColor( Color )
		
		local data = {
			Color = Color,
			RenderMode = 0,
			RenderFX = 0
		}
		duplicator.StoreEntityModifier( Ent, "colour", data )
		
		if Update then
			local PhysObj = Ent:GetPhysicsObject()
			if not IsValid( PhysObj ) then return end
			
			local freezeWhenDone = PhysObj:IsMotionEnabled()
			local freezeWheels = {}
			PhysObj:EnableMotion( false )
			Ent:SetNotSolid( true )
			
			local ResetPos = Ent:GetPos()
			local ResetAng = Ent:GetAngles()
			
			Ent:SetPos( ResetPos + Vector(0,0,30) )
			Ent:SetAngles( Angle(0,ResetAng.y,0) )
			
			for i = 1, table.Count( Ent.Wheels ) do
				local Wheel = Ent.Wheels[ i ]
				if IsValid( Wheel ) then
					local wPObj = Wheel:GetPhysicsObject()
					
					if IsValid( wPObj ) then
						freezeWheels[ i ] = {}
						freezeWheels[ i ].dofreeze = wPObj:IsMotionEnabled()
						freezeWheels[ i ].pos = Wheel:GetPos()
						freezeWheels[ i ].ang = Wheel:GetAngles()
						Wheel:SetNotSolid( true )
						wPObj:EnableMotion( true ) 
						wPObj:Wake() 
					end
				end
			end
			
			timer.Simple( 0.5, function()
				if not IsValid( Ent ) then return end
				if not IsValid( PhysObj ) then return end
				
				PhysObj:EnableMotion( freezeWhenDone )
				Ent:SetNotSolid( false )
				Ent:SetPos( ResetPos )
				Ent:SetAngles( ResetAng )
				
				for i = 1, table.Count( freezeWheels ) do
					local Wheel = Ent.Wheels[ i ]
					if IsValid( Wheel ) then
						local wPObj = Wheel:GetPhysicsObject()
						
						Wheel:SetNotSolid( false )
						
						if IsValid( wPObj ) then
							wPObj:EnableMotion( freezeWheels[i].dofreeze ) 
						end
						
						Wheel:SetPos( freezeWheels[ i ].pos )
						Wheel:SetAngles( freezeWheels[ i ].ang )
					end
				end
			end)
		end
		
		if Ent.CustomWheels then
			if Ent.GhostWheels then
				timer.Simple( Update and 0.25 or 0, function()
					if not IsValid( Ent ) then return end
					if Memory.WheelTool_Foffset and Memory.WheelTool_Roffset then
						SetWheelOffset( Ent, Memory.WheelTool_Foffset, Memory.WheelTool_Roffset )
					end
					
					if not Memory.FrontWheelOverride and not Memory.RearWheelOverride then return end
					
					local front_model = Memory.FrontWheelOverride or vehicle.Members.CustomWheelModel
					local front_angle = GetAngleFromSpawnlist(front_model)
					
					local camber = Memory.Camber or 0
					local rear_model = Memory.RearWheelOverride or (vehicle.Members.CustomWheelModel_R and vehicle.Members.CustomWheelModel_R or front_model)
					local rear_angle = GetAngleFromSpawnlist(rear_model)
					
					if not front_model or not rear_model or not front_angle or not rear_angle then return end
					
					if ValidateModel( front_model ) and ValidateModel( rear_model ) then 
						Ent.Camber = camber
						ApplyWheel(Ent, {front_model,front_angle,rear_model,rear_angle,camber})
					else
						ply:PrintMessage( HUD_PRINTTALK, "selected wheel does not exist on the server")
					end
				end)
			end
		end
	end)
	
	UVRaceReplaceParticipant( entrantvehicle, Ent )
	
	timer.Simple(1, function()
		entrantvehicle:Remove()
	end)
	
	Ent.racer = racer_name
	
	if aienabled then 
		Ent.uvclasstospawnon = "npc_racervehicle"
	end
	
	if PT then
		Ent.PursuitTech = PT
	end
	
	if Ent.PursuitTech then
		table.insert(UVRVWithPursuitTech, Ent)
		
		for i=1,2 do
			UVReplicatePT( Ent, i )
		end
	end
	
	Ent:CallOnRemove( "UVRVWithPursuitTechRemoved", function(Ent)
		if table.HasValue(UVRVWithPursuitTech, Ent) then
			table.RemoveByValue(UVRVWithPursuitTech, Ent)
		end
	end)
	
	timer.Simple( .5, function()
		if IsValid(Ent) then
			if aienabled then 
				
				local uv = ents.Create(Ent.uvclasstospawnon)
				uv:SetPos(Ent:GetPos())
				uv.uvscripted = true
				uv.vehicle = Ent
				uv:Spawn()
				uv:Activate()
				ply = uv
				
			else
				if Ent.IsSimfphyscar then
					ply:EnterVehicle( Ent.DriverSeat )
				elseif Ent.IsGlideVehicle then
					local seat = Ent.seats[1]
					if IsValid(seat) then
						ply:EnterVehicle(seat)
					end
				elseif Ent:GetClass() == "prop_vehicle_jeep" then
					ply:EnterVehicle(Ent)
				end
			end
		end
	end)
	
	return Ent
end

function UVMoveToGridSlot( vehicle )
	local vehicle_class = vehicle:GetClass()
	
	local checkpoint = nil
	local next_checkpoint = nil
	local pos = nil
	local dir = nil
	local ang = angle_zero
	
	local spawns = ents.FindByClass("uvrace_spawn")
	local spawn

	if next(spawns) == nil then
		PrintMessage( HUD_PRINTTALK, "No race spawn points found!")
		return nil
	else
		--Look for a spawn point that has the lowest GridSlot value and claim it
		local lowestGridSlot = math.huge
		for k, v in pairs(spawns) do
			if v:GetGridSlot() < lowestGridSlot and not v.claimed then
				lowestGridSlot = v:GetGridSlot()
				spawn = v
			end
		end
	end
	
	if not spawn then
		PrintMessage( HUD_PRINTTALK, "No positions left for "..racer_name)
		return nil
	end

	local pos = spawn:GetPos()
	local ang = spawn:GetAngles()
	ang.yaw = ang.yaw + 180

	UVSetVehiclePos( vehicle, pos, ang )
	UVSetVehicleActive( vehicle, false )

	timer.Simple( 1, function()
		--UVSetVehicleActive( vehicle, true )
		vehicle:GetPhysicsObject():EnableMotion( false )
	end )

	spawn.claimed = true
	return vehicle
end

function UVMoveToGridSlotLegacy( vehicle, aienabled )
	local entrantvehicle = vehicle
	local PT = (vehicle.PursuitTech and table.Copy(vehicle.PursuitTech))
	
	local vehIndex = vehicle:EntIndex()
	local Memory = GetVehicleData( vehicle )
	
	local driver = vehicle:GetDriver()
	local ply = (IsValid(driver) and driver)
	
	local racer_name = (ply and ply:GetName()) or (vehicle.racer or "Racer "..vehicle:EntIndex())
	
	ply = ply or Entity(1)
	
	local spawns = ents.FindByClass("uvrace_spawn")
	local spawn
	if next(spawns) == nil then
		PrintMessage( HUD_PRINTTALK, "No race spawn points found!")
		return nil
	else
		--Look for a spawn point that has the lowest GridSlot value and claim it
		local lowestGridSlot = math.huge
		for k, v in pairs(spawns) do
			if v:GetGridSlot() < lowestGridSlot and not v.claimed then
				lowestGridSlot = v:GetGridSlot()
				spawn = v
			end
		end
	end
	
	if not spawn then
		PrintMessage( HUD_PRINTTALK, "No positions left for "..racer_name)
		return nil
	end
	
	local pos = spawn:GetPos()
	local ang = spawn:GetAngles()
	
	local scope = UVGetScope( vehicle ) or {}
	
	local Ent
	
	if Memory.VehicleBase == "gmod_sent_vehicle_fphysics_base" then
		local vname = Memory.SpawnName
		local Update = false
		local VehicleList = list.Get( "simfphys_vehicles" )
		local vehicle = VehicleList[ vname ]
		
		if not vehicle then return false end
		
		local SpawnPos = pos + (vector_up * (InfMap and 2 or 25)) + (vehicle.SpawnOffset or vector_origin)
		
		local SpawnAng = ang
		SpawnAng.pitch = 0
		SpawnAng.yaw = SpawnAng.yaw + Memory.AddedYaw + (vehicle.SpawnAngleOffset and vehicle.SpawnAngleOffset or 0)
		SpawnAng.roll = 0
		
		Ent = simfphys.SpawnVehicle( nil, SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, vname, vehicle )
		
		if not IsValid( Ent ) then return end
		
		if not UVGame then
			undo.Create( "Vehicle" )
			undo.SetPlayer( ply )
			undo.AddEntity( Ent )
			undo.SetCustomUndoText( "Undone " .. vehicle.Name )
			undo.Finish( "Vehicle (" .. tostring( vehicle.Name ) .. ")" )
		end
		
		if not UVGame then
			ply:AddCleanup( "vehicles", Ent )
		end
		
		timer.Simple( 0.5, function()
			if not IsValid(Ent) then return end
			
			local tsc = string.Explode( ",", Memory.TireSmokeColor )
			Ent:SetTireSmokeColor( Vector( tonumber(tsc[1]), tonumber(tsc[2]), tonumber(tsc[3]) ) )
			
			Ent.Turbocharged = tobool( Memory.HasTurbo )
			Ent.Supercharged = tobool( Memory.HasBlower )
			
			Ent:SetEngineSoundPreset( math.Clamp( tonumber( Memory.SoundPreset ), -1, 23) )
			Ent:SetMaxTorque( math.Clamp( tonumber( Memory.PeakTorque ), 20, 1000) )
			Ent:SetDifferentialGear( math.Clamp( tonumber( Memory.FinalGear ),0.2, 6 ) )
			
			Ent:SetSteerSpeed( math.Clamp( tonumber( Memory.SteerSpeed ), 1, 16 ) )
			Ent:SetFastSteerAngle( math.Clamp( tonumber( Memory.SteerAngFast ), 0, 1) )
			Ent:SetFastSteerConeFadeSpeed( math.Clamp( tonumber( Memory.SteerFadeSpeed ), 1, 5000 ) )
			
			Ent:SetEfficiency( math.Clamp( tonumber( Memory.Efficiency ) ,0.2,4) )
			Ent:SetMaxTraction( math.Clamp( tonumber( Memory.MaxTraction ) , 5,1000) )
			Ent:SetTractionBias( math.Clamp( tonumber( Memory.GripOffset ),-0.99,0.99) )
			Ent:SetPowerDistribution( math.Clamp( tonumber( Memory.PowerDistribution ) ,-1,1) )
			
			Ent:SetBackFire( tobool( Memory.HasBackfire ) )
			Ent:SetDoNotStall( tobool( Memory.DoesntStall ) )
			
			Ent:SetIdleRPM( math.Clamp( tonumber( Memory.IdleRPM ),1,25000) )
			Ent:SetLimitRPM( math.Clamp( tonumber( Memory.MaxRPM ),4,25000) )
			Ent:SetRevlimiter( tobool( Memory.HasRevLimiter ) )
			Ent:SetPowerBandEnd( math.Clamp( tonumber( Memory.PowerEnd ), 3, 25000) )
			Ent:SetPowerBandStart( math.Clamp( tonumber( Memory.PowerStart ) ,2 ,25000) )
			
			Ent:SetTurboCharged( Ent.Turbocharged )
			Ent:SetSuperCharged( Ent.Supercharged )
			Ent:SetBrakePower( math.Clamp( tonumber( Memory.BrakePower ), 0.1, 500) )
			
			Ent:SetSoundoverride( Memory.SoundOverride or "" )
			
			Ent:SetLights_List( Ent.LightsTable or "no_lights" )
			
			Ent:SetBulletProofTires(true)
			
			Ent.snd_horn = Memory.HornSound
			
			Ent.snd_blowoff = Memory.snd_blowoff
			Ent.snd_spool = Memory.snd_spool
			Ent.snd_bloweron = Memory.snd_bloweron
			Ent.snd_bloweroff = Memory.snd_bloweroff
			
			Ent:SetBackfireSound( Memory.backfiresound or "" )
			
			local Gears = {}
			local Data = string.Explode( ",", Memory.Gears  )
			for i = 1, table.Count( Data ) do 
				local gRatio = tonumber( Data[i] )
				
				if isnumber( gRatio ) then
					if i == 1 then
						Gears[i] = math.Clamp( gRatio, -5, -0.001)
						
					elseif i == 2 then
						Gears[i] = 0
						
					else
						Gears[i] = math.Clamp( gRatio, 0.001, 5)
					end
				end
			end
			Ent.Gears = Gears
			
			if istable( Memory.SubMaterials ) then
				for i = 0, table.Count( Memory.SubMaterials ) do
					Ent:SetSubMaterial( i, Memory.SubMaterials[i] )
				end
			end
			
			if Memory.FrontDampingOverride and Memory.FrontConstantOverride and Memory.RearDampingOverride and Memory.RearConstantOverride then
				Ent.FrontDampingOverride = tonumber( Memory.FrontDampingOverride )
				Ent.FrontConstantOverride = tonumber( Memory.FrontConstantOverride )
				Ent.RearDampingOverride = tonumber( Memory.RearDampingOverride )
				Ent.RearConstantOverride = tonumber( Memory.RearConstantOverride )
				
				local data = {
					[1] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[2] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[3] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[4] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[5] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[6] = {Ent.RearConstantOverride,Ent.RearDampingOverride}
				}
				
				local elastics = Ent.Elastics
				if elastics then
					for i = 1, table.Count( elastics ) do
						local elastic = elastics[i]
						if Ent.StrengthenSuspension == true then
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
							local elastic2 = elastics[i * 10]
							if IsValid( elastic2 ) then
								elastic2:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic2:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
						else
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1], 0 )
								elastic:Fire( "SetSpringDamping", data[i][2], 0 )
							end
						end
					end
				end
			end
			
			Ent:SetFrontSuspensionHeight( tonumber( Memory.FrontHeight ) )
			Ent:SetRearSuspensionHeight( tonumber( Memory.RearHeight ) )
			
			local groups = string.Explode( ",", Memory.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( Memory.Skin )
			
			local c = string.Explode( ",", Memory.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
			
			if Update then
				local PhysObj = Ent:GetPhysicsObject()
				if not IsValid( PhysObj ) then return end
				
				local freezeWhenDone = PhysObj:IsMotionEnabled()
				local freezeWheels = {}
				PhysObj:EnableMotion( false )
				Ent:SetNotSolid( true )
				
				local ResetPos = Ent:GetPos()
				local ResetAng = Ent:GetAngles()
				
				Ent:SetPos( ResetPos + Vector(0,0,30) )
				Ent:SetAngles( Angle(0,ResetAng.y,0) )
				
				for i = 1, table.Count( Ent.Wheels ) do
					local Wheel = Ent.Wheels[ i ]
					if IsValid( Wheel ) then
						local wPObj = Wheel:GetPhysicsObject()
						
						if IsValid( wPObj ) then
							freezeWheels[ i ] = {}
							freezeWheels[ i ].dofreeze = wPObj:IsMotionEnabled()
							freezeWheels[ i ].pos = Wheel:GetPos()
							freezeWheels[ i ].ang = Wheel:GetAngles()
							Wheel:SetNotSolid( true )
							wPObj:EnableMotion( true ) 
							wPObj:Wake() 
						end
					end
				end
				
				timer.Simple( 0.5, function()
					if not IsValid( Ent ) then return end
					if not IsValid( PhysObj ) then return end
					
					PhysObj:EnableMotion( freezeWhenDone )
					Ent:SetNotSolid( false )
					Ent:SetPos( ResetPos )
					Ent:SetAngles( ResetAng )
					
					for i = 1, table.Count( freezeWheels ) do
						local Wheel = Ent.Wheels[ i ]
						if IsValid( Wheel ) then
							local wPObj = Wheel:GetPhysicsObject()
							
							Wheel:SetNotSolid( false )
							
							if IsValid( wPObj ) then
								wPObj:EnableMotion( freezeWheels[i].dofreeze ) 
							end
							
							Wheel:SetPos( freezeWheels[ i ].pos )
							Wheel:SetAngles( freezeWheels[ i ].ang )
						end
					end
				end)
			end
			
			if Ent.CustomWheels then
				if Ent.GhostWheels then
					timer.Simple( Update and 0.25 or 0, function()
						if not IsValid( Ent ) then return end
						if Memory.WheelTool_Foffset and Memory.WheelTool_Roffset then
							SetWheelOffset( Ent, Memory.WheelTool_Foffset, Memory.WheelTool_Roffset )
						end
						
						if not Memory.FrontWheelOverride and not Memory.RearWheelOverride then return end
						
						local front_model = Memory.FrontWheelOverride or vehicle.Members.CustomWheelModel
						local front_angle = GetAngleFromSpawnlist(front_model)
						
						local camber = Memory.Camber or 0
						local rear_model = Memory.RearWheelOverride or (vehicle.Members.CustomWheelModel_R and vehicle.Members.CustomWheelModel_R or front_model)
						local rear_angle = GetAngleFromSpawnlist(rear_model)
						
						if not front_model or not rear_model or not front_angle or not rear_angle then return end
						
						if ValidateModel( front_model ) and ValidateModel( rear_model ) then 
							Ent.Camber = camber
							ApplyWheel(Ent, {front_model,front_angle,rear_model,rear_angle,camber})
						else
							ply:PrintMessage( HUD_PRINTTALK, "selected wheel does not exist on the server")
						end
					end)
				end
			end
		end)
		
	elseif Memory.VehicleBase == "base_glide_car" or Memory.VehicleBase == "base_glide_motorcycle" or Memory.VehicleBase == "base_glide_boat" or Memory.VehicleBase == "base_glide_aircraft" or Memory.VehicleBase == "base_glide_heli" or Memory.VehicleBase == "base_glide_plane" or Memory.VehicleBase == "lvs_base_wheeldrive" then
		local SpawnCenter = pos + (vector_up * (InfMap and 2 or 25))
		SpawnCenter.z = SpawnCenter.z - Memory.Mins.z
		
		-- duplicator.SetLocalPos( SpawnCenter )
		-- duplicator.SetLocalAng( Angle( 0, ang.yaw, 0 ) )

		local _Entities = table.Copy( Memory.Entities )
		local _Constraints = table.Copy( Memory.Constraints )

		local Ents = UVCreateEntitiesFromTable( _Entities )
		local entCount = 0

		for _, ent in pairs( Ents ) do
			entCount = entCount + 1
		end

		if entCount > 1 then
			local mainEnt = Ents[vehIndex]

			if IsValid( mainEnt ) and mainEnt.Pos then
				local rel = {}
				local mainOldPos = mainEnt:GetPos()
				local mainOldAng = mainEnt:GetAngles()

				for id, e in pairs( Ents ) do
					if IsValid( e ) then
						local lp, la = WorldToLocal( e:GetPos(), e:GetAngles(), mainOldPos, mainOldAng )
						rel[id] = { pos = lp, ang = la }
					end
				end

				local targetMainPos, targetMainAng = LocalToWorld(
					mainEnt.Pos,
					Angle( 0, 180, 0 ),
					SpawnCenter,
					Angle( 0, ang.yaw, 0 )
				)

				for id, e in pairs( Ents ) do
					local data = rel[id]
					if data then
						local wp, wa = LocalToWorld( data.pos, data.ang, targetMainPos, targetMainAng )
						e:SetPos( wp )
						e:SetAngles( wa )
					end
				end
			end
		else
			for _, ent in pairs( Ents ) do
				if ent.Pos then
					local pos, ang = LocalToWorld( ent.Pos, Angle(0,180,0), SpawnCenter, Angle(0, ang.yaw, 0) )
					ent:SetPos( pos )
					ent:SetAngles( ang )
				end
			end
		end
		
		for _k, Constraint in pairs( _Constraints ) do
			local constraintEnt = nil

			ProtectedCall(function()
				constraintEnt = UVCreateConstraintsFromTable( Constraint, Ents )
			end)
			
			-- if IsValid( constraintEnt ) then
			-- 	table.insert( UVRace_LoadedConstraints, constraintEnt )
			-- end
		end

		for key, ent in pairs( Ents ) do
			if _Entities[key] then
				local c = string.Explode( ",", _Entities[key].Color )
				local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
				local dot = Color.r * Color.g * Color.b * Color.a
				ent.OldColor = dot
				ent:SetColor( Color )

				if cffunctions then
					ent.NitrousPower = _Entities[key].NitrousPower
					ent.NitrousDepletionRate = _Entities[key].NitrousDepletionRate
					ent.NitrousRegenRate = _Entities[key].NitrousRegenRate
					ent.NitrousRegenDelay = _Entities[key].NitrousRegenDelay
					ent.NitrousPitchChangeFrequency = _Entities[key].NitrousPitchChangeFrequency
					ent.NitrousPitchMultiplier = _Entities[key].NitrousPitchMultiplier
					ent.NitrousBurst = _Entities[key].NitrousBurst
					ent.NitrousColor = _Entities[key].NitrousColor
					ent.NitrousStartSound = _Entities[key].NitrousStartSound
					ent.NitrousLoopingSound = _Entities[key].NitrousLoopingSound
					ent.NitrousEndSound = _Entities[key].NitrousEndSound
					ent.NitrousEmptySound = _Entities[key].NitrousEmptySound
					ent.NitrousReadyBurstSound = _Entities[key].NitrousReadyBurstSound
					ent.NitrousStartBurstSound = _Entities[key].NitrousStartBurstSound
					ent.NitrousStartBurstAnnotationSound = _Entities[key].NitrousStartBurstAnnotationSound
					ent.CriticalDamageSound = _Entities[key].CriticalDamageSound
					ent.NitrousEnabled = _Entities[key].NitrousEnabled
					ent:SetNWBool( 'NitrousEnabled', _Entities[key].NitrousEnabled == nil and true or _Entities[key].NitrousEnabled )
					
					if ent.NitrousColor then
						local r = ent.NitrousColor.r
						local g = ent.NitrousColor.g
						local b = ent.NitrousColor.b
						
						net.Start( "cfnitrouscolor" )
						net.WriteEntity(ent)
						net.WriteInt(r, 9)
						net.WriteInt(g, 9)
						net.WriteInt(b, 9)
						net.WriteBool(ent.NitrousBurst)
						net.WriteBool(ent.NitrousEnabled)
						net.Broadcast()
					end
				end
			end
		end

		-- if cffunctions then
		-- 	for key, ent in pairs( Ents ) do
		-- 		if _Entities[key] then
		-- 			ent.NitrousPower = _Entities[key].NitrousPower
		-- 			ent.NitrousDepletionRate = _Entities[key].NitrousDepletionRate
		-- 			ent.NitrousRegenRate = _Entities[key].NitrousRegenRate
		-- 			ent.NitrousRegenDelay = _Entities[key].NitrousRegenDelay
		-- 			ent.NitrousPitchChangeFrequency = _Entities[key].NitrousPitchChangeFrequency
		-- 			ent.NitrousPitchMultiplier = _Entities[key].NitrousPitchMultiplier
		-- 			ent.NitrousBurst = _Entities[key].NitrousBurst
		-- 			ent.NitrousColor = _Entities[key].NitrousColor
		-- 			ent.NitrousStartSound = _Entities[key].NitrousStartSound
		-- 			ent.NitrousLoopingSound = _Entities[key].NitrousLoopingSound
		-- 			ent.NitrousEndSound = _Entities[key].NitrousEndSound
		-- 			ent.NitrousEmptySound = _Entities[key].NitrousEmptySound
		-- 			ent.NitrousReadyBurstSound = _Entities[key].NitrousReadyBurstSound
		-- 			ent.NitrousStartBurstSound = _Entities[key].NitrousStartBurstSound
		-- 			ent.NitrousStartBurstAnnotationSound = _Entities[key].NitrousStartBurstAnnotationSound
		-- 			ent.CriticalDamageSound = _Entities[key].CriticalDamageSound
		-- 			ent.NitrousEnabled = _Entities[key].NitrousEnabled
		-- 			ent:SetNWBool( 'NitrousEnabled', _Entities[key].NitrousEnabled == nil and true or _Entities[key].NitrousEnabled )
					
		-- 			if ent.NitrousColor then
		-- 				local r = ent.NitrousColor.r
		-- 				local g = ent.NitrousColor.g
		-- 				local b = ent.NitrousColor.b
						
		-- 				net.Start( "cfnitrouscolor" )
		-- 				net.WriteEntity(ent)
		-- 				net.WriteInt(r, 9)
		-- 				net.WriteInt(g, 9)
		-- 				net.WriteInt(b, 9)
		-- 				net.WriteBool(ent.NitrousBurst)
		-- 				net.WriteBool(ent.NitrousEnabled)
		-- 				net.Broadcast()
		-- 			end
		-- 		end
		-- 	end
		-- end

		Ent = Ents[vehIndex]
		
		-- local Ents = duplicator.Paste( ply, Memory.Entities, Memory.Constraints )
		-- Ent = Ents[next(Ents)]
		
		-- if not IsValid( Ent ) then 
		-- 	PrintMessage( HUD_PRINTTALK, "The vehicle ".. Memory.SpawnName .." dosen't seem to be installed!" )
		-- 	return 
		-- end
		
		-- duplicator.SetLocalPos( vector_origin )
		-- duplicator.SetLocalAng( angle_zero )
		
		-- undo.Create( "Duplicator" )
		
		-- if Memory.SubMaterials then
		-- 	if istable( Memory.SubMaterials ) then
		-- 		for i = 0, table.Count( Memory.SubMaterials ) do
		-- 			Ent:SetSubMaterial( i, Memory.SubMaterials[i] )
		-- 		end
		-- 	end
			
		-- 	local groups = string.Explode( ",", Memory.BodyGroups)
		-- 	for i = 1, table.Count( groups ) do
		-- 		Ent:SetBodygroup(i, tonumber(groups[i]) )
		-- 	end
			
		-- 	Ent:SetSkin( Memory.Skin )
			
		-- 	local data = {
		-- 		Color = Color,
		-- 		RenderMode = 0,
		-- 		RenderFX = 0
		-- 	}
		-- 	duplicator.StoreEntityModifier( Ent, "colour", data )
			
		-- 	if isfunction(Ent.Repair) then
		-- 		Ent:Repair()
		-- 	end
		-- end
		
		-- for k, ent in pairs( Ents ) do
		-- 	undo.AddEntity( ent )
		-- end
		
		-- for k, ent in pairs( Ents )	do
		-- 	ply:AddCleanup( "duplicates", ent )
		-- end
		
		-- undo.SetPlayer( ply )
		-- undo.SetCustomUndoText( "Undone Glide" )
		
		-- undo.Finish( "Undo (" .. tostring( table.Count( Ents ) ) ..  ")" )

		-- if cffunctions then
		-- 	Ent.NitrousPower = Memory.NitrousPower
		-- 	Ent.NitrousDepletionRate = Memory.NitrousDepletionRate
		-- 	Ent.NitrousRegenRate = Memory.NitrousRegenRate
		-- 	Ent.NitrousRegenDelay = Memory.NitrousRegenDelay
		-- 	Ent.NitrousPitchChangeFrequency = Memory.NitrousPitchChangeFrequency
		-- 	Ent.NitrousPitchMultiplier = Memory.NitrousPitchMultiplier
		-- 	Ent.NitrousBurst = Memory.NitrousBurst
		-- 	Ent.NitrousColor = Memory.NitrousColor
		-- 	Ent.NitrousStartSound = Memory.NitrousStartSound
		-- 	Ent.NitrousLoopingSound = Memory.NitrousLoopingSound
		-- 	Ent.NitrousEndSound = Memory.NitrousEndSound
		-- 	Ent.NitrousEmptySound = Memory.NitrousEmptySound
		-- 	Ent.NitrousReadyBurstSound = Memory.NitrousReadyBurstSound
		-- 	Ent.NitrousStartBurstSound = Memory.NitrousStartBurstSound
		-- 	Ent.NitrousStartBurstAnnotationSound = Memory.NitrousStartBurstAnnotationSound
		-- 	Ent.CriticalDamageSound = Memory.CriticalDamageSound
		-- 	Ent.NitrousEnabled = Memory.NitrousEnabled
		-- 	Ent:SetNWBool( 'NitrousEnabled', Memory.NitrousEnabled == nil and true or Memory.NitrousEnabled )
			
		-- 	if Ent.NitrousColor then
		-- 		local r = Ent.NitrousColor.r
    	-- 		local g = Ent.NitrousColor.g
    	-- 		local b = Ent.NitrousColor.b
			
    	-- 		net.Start( "cfnitrouscolor" )
    	-- 		    net.WriteEntity(Ent)
    	-- 		    net.WriteInt(r, 9)
    	-- 		    net.WriteInt(g, 9)
    	-- 		    net.WriteInt(b, 9)
		-- 			net.WriteBool(Ent.NitrousBurst)
		-- 			net.WriteBool(Ent.NitrousEnabled)
    	-- 		net.Broadcast()
		-- 	end
		-- end

		-- function Ent:UpdateTransmitState()
		-- 	return TRANSMIT_ALWAYS
		-- end
		
		
	elseif Memory.VehicleBase == "prop_vehicle_jeep" then
		local class = Memory.SpawnName
		local vehicles = list.Get("Vehicles")
		local lst = vehicles[class]
		if not lst then
			PrintMessage( HUD_PRINTTALK, "The vehicle '"..class.."' is missing!")
			return
		end
		
		Ent = ents.Create("prop_vehicle_jeep")
		Ent.VehicleTable = lst
		Ent:SetModel(lst.Model) 
		Ent:SetPos(pos + (vector_up * 25))
		
		local SpawnAng = ang
		SpawnAng.pitch = 0
		SpawnAng.yaw = SpawnAng.yaw + 90
		SpawnAng.roll = 0
		Ent:SetAngles(SpawnAng)
		
		Ent:SetKeyValue("vehiclescript", lst.KeyValues.vehiclescript)
		Ent:SetVehicleClass( class )
		Ent:Spawn()
		Ent:Activate()
		
		local vehicle = Ent
		if IsValid(Entity(1)) then
			gamemode.Call( "PlayerSpawnedVehicle", Entity(1), vehicle ) --Some vehicles has different models implanted together, so do that.
		end
		
		if istable( Memory.SubMaterials ) then
			for i = 0, table.Count( Memory.SubMaterials ) do
				Ent:SetSubMaterial( i, Memory.SubMaterials[i] )
			end
		end
		
		local groups = string.Explode( ",", Memory.BodyGroups)
		for i = 1, table.Count( groups ) do
			Ent:SetBodygroup(i, tonumber(groups[i]) )
		end
		
		Ent:SetSkin( Memory.Skin )
		
		local c = string.Explode( ",", Memory.Color )
		local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
		
		local dot = Color.r * Color.g * Color.b * Color.a
		Ent.OldColor = dot
		Ent:SetColor( Color )
		
		local data = {
			Color = Color,
			RenderMode = 0,
			RenderFX = 0
		}
		duplicator.StoreEntityModifier( Ent, "colour", data )
		
		if not UVGame then
			undo.Create( "Vehicle" )
			undo.SetPlayer( ply )
			undo.AddEntity( Ent )
			undo.SetCustomUndoText( "Undone " .. class )
			undo.Finish( "Vehicle (" .. tostring( class ) .. ")" )
		end
		
	end
	
	spawn.claimed = true

	hook.Run( 'UV_Event', 'onVehicleReplaced', Ent, entrantvehicle )

	local constrainedEnts = constraint.GetAllConstrainedEntities(entrantvehicle)
	if constrainedEnts then
		for ent, _ in pairs(constrainedEnts) do
				if IsValid(ent) and ent ~= entrantvehicle then
				ent:Remove()
			end
		end
	end
	entrantvehicle:Remove()

	-- Re-create the scope from the first vehicle
	UVCreateScope( Ent, scope )
	
	Ent.racer = racer_name
	
	if aienabled then 
		Ent.uvclasstospawnon = "npc_racervehicle"
		-- else
		-- ply:PrintMessage( HUD_PRINTTALK, "Moving your vehicle to the grid slot..." ) 
	end
	
	if PT then
		Ent.PursuitTech = PT
	end
	
	if Ent.PursuitTech then
		table.insert(UVRVWithPursuitTech, Ent)
		
		for i=1,2 do
			UVReplicatePT( Ent, i )
		end
	end
	
	Ent:CallOnRemove( "UVRVWithPursuitTechRemoved", function(Ent)
		if table.HasValue(UVRVWithPursuitTech, Ent) then
			table.RemoveByValue(UVRVWithPursuitTech, Ent)
		end
	end)
	
	UVRaceAddParticipant( Ent )

	if InfMap then
		timer.Simple(0, function()
			Ent:GetPhysicsObject():EnableMotion( false )
		end)
	end
	
	timer.Simple( 1, function()
		if IsValid(Ent) then
			Ent:GetPhysicsObject():EnableMotion( false )
			if aienabled then
				local uv = ents.Create(Ent.uvclasstospawnon)
				uv.restrictedCustomization = true
				uv:SetPos(Ent:GetPos())
				uv.uvscripted = true
				uv.vehicle = Ent
				Ent.RacerVehicle = nil
				uv:Spawn()
				uv:Activate()
				ply = uv
			else
				if Ent.IsSimfphyscar then
					ply:EnterVehicle( Ent.DriverSeat )
				elseif Ent.IsGlideVehicle then
					local seat = Ent.seats[1]
					if IsValid(seat) then
						ply:EnterVehicle(seat)
					end
				elseif Ent:GetClass() == "prop_vehicle_jeep" then
					ply:EnterVehicle(Ent)
				elseif Ent.LVS then
					ply:EnterVehicle(Ent:GetDriverSeat())
				end
			end
		end
	end)
	
	return Ent
	
end