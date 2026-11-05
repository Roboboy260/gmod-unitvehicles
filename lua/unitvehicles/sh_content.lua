UVContent = {}
UVContentReady = false
UVWorkshopPriority = CreateConVar("unitvehicle_workshoppriority", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Workshop content will be prioritized over Local content")

local WS_CONTENT_ROOT = "data_static/uv_import/"
local LOCAL_CONTENT_ROOT = "unitvehicles/"

local REPLICATION_BATCH_SIZE = 50
local REPLICATION_DELAY = 0.1
local REPLICATED_FILES = {
    ['drivermodels'] = true,
    ['glide>>units'] = true,
    ['glide>>traffic'] = true,
    ['glide>>racers'] = true,
    ['lvs>>units'] = true,
    ['lvs>>traffic'] = true,
    ['lvs>>racers'] = true,
    ['prop_vehicle_jeep>>units'] = true,
    ['prop_vehicle_jeep>>traffic'] = true,
    ['prop_vehicle_jeep>>racers'] = true,
    ['simfphys>>units'] = true,
    ['simfphys>>traffic'] = true,
    ['simfphys>>racers'] = true,
    ['pursuitbreakers>>' .. game.GetMap()] = true,
    ['roadblocks>>' .. game.GetMap()] = true,
    ['repairshops>>' .. game.GetMap()] = true,
    -- ['races>>' .. game.GetMap()] = true, Race replication is handled by race handler since client doesn't really have a use for the file list ...
}

local ReplicationQueue = {}

local load_queue = {}

local function scanFolder( folder, ptrTable, searchType )
    local files, subfolders = file.Find( folder .. "*", searchType )
    local prioSearchType = UVWorkshopPriority:GetBool() and "GAME" or "DATA"

    if next( subfolders ) == nil then
        for _, file in ipairs( files ) do
            -- Remove same-named lower-priority entries so the stack has one winner per filename
            if searchType == prioSearchType then
                for i, v in ipairs( ptrTable ) do
                    if v.file == file then
                        table.remove( ptrTable, i )
                        break
                    end
                end
            end

            table.insert( ptrTable, {
                file = file,
                path = folder .. file,
                searchType = searchType
            } )
        end
    else
        for _, subfolder in ipairs( subfolders ) do
            -- print(subfolder)
            if not ptrTable[subfolder] then
                ptrTable[subfolder] = {}
            end
            scanFolder( folder .. subfolder .. "/", ptrTable[subfolder], searchType )
        end
    end

    -- for _, file in ipairs( files ) do
    --     -- local path = folder .. file
    --     -- local data = file.Read( path, "GAME" )

    --     -- if data then
    --     --     table.insert( ptrTable, data )
    --     -- end
    -- end

    -- for _, subfolder in ipairs( subfolders ) do
    --     ptrTable[subfolder] = {}
    --     scanFolder( folder .. subfolder .. "/", ptrTable[subfolder] )
    -- end
end

if SERVER then
    local _, wsContentFolders = file.Find( WS_CONTENT_ROOT .. "*", "GAME" )
    local _, localContentFolders = file.Find( LOCAL_CONTENT_ROOT .. "*", "DATA" )

    local function mountWorkshop()
        MsgC(Color(0,255,0), "\n[Unit Vehicles] Mounting workshop content...\n")

        for _, folder in ipairs( wsContentFolders ) do
            scanFolder( WS_CONTENT_ROOT .. folder .. "/uvdata/", UVContent, "GAME" )
            MsgC(Color(0,255,0), "\tMounted workshop content: " .. folder .. "\n")
        end
    end

    local function mountLocal()
        MsgC(Color(0,255,0), "\n[Unit Vehicles] Mounting local content...\n")

        scanFolder( LOCAL_CONTENT_ROOT, UVContent, "DATA" )
    end

    if UVWorkshopPriority:GetBool() then
        mountLocal()
        mountWorkshop()
    else
        mountWorkshop()
        mountLocal()
    end

    UVContentReady = true

    -- We must let hook listeners register first
    timer.Simple( 0, function()
        hook.Run( "UVContentEvent", "Initialize" )
    end )
    
elseif CLIENT then
    net.Receive( "UVContent_Add", function( len, ply )
        local bytes = net.ReadUInt( 16 )
        local data = net.ReadData( bytes )
    
        local uncompData = util.Decompress( data )
        local dataTable = util.JSONToTable( uncompData )    

        local i = 0

        for _, v in pairs( dataTable[2] ) do
            i = i + 1
            UV_AddFile( dataTable[1], v )
        end

        if i > 1 then
            hook.Run( "UVContentEvent", "BatchAdd", dataTable[1], dataTable[2] )
        else
            hook.Run( "UVContentEvent", "Add", dataTable[1], dataTable[2][1] )
        end
    end )

    net.Receive( "UVContent_Remove", function( len, ply )
        local path = net.ReadString()
        local filename = net.ReadString()

        UV_RemoveFile( path, filename )
        hook.Run( "UVContentEvent", "Remove", path, filename )
    end )
end

local function getStack( path )
    local stack = UVContent
    local hay = string.Explode( ">>", path )
    local needle = hay[#hay]

    for i, v in ipairs( hay ) do
        if stack[v] == nil then stack[v] = {} end
        stack = stack[v]
    end

    return stack
end

local function getFile( path, fileName )
    local stack = getStack( path )

    for i, v in ipairs( stack ) do
        if v.file == fileName then return v end
    end
end

local function network_RemoveContent( path, fileName, _ply )
    net.Start( "UVContent_Remove" )
    net.WriteString( path )
    net.WriteString( fileName )
    if _ply then
        net.Send( _ply )
    else
        net.Broadcast()
    end
end

local function network_AddContent( contentTable, _ply )
    local compData = util.Compress( util.TableToJSON(contentTable) )
    local dataSize = #compData

    net.Start( "UVContent_Add" )
    net.WriteUInt( dataSize, 16 )
    net.WriteData( compData, dataSize )

    if _ply then
        net.Send( _ply )
    else
        net.Broadcast()
    end
end

local function sendContentInBatch(ply, data, path)
    local sent = 0

    local function SendBatch(sent)
        if sent > #data then return end

        local startNeedle = sent
        local endNeedle = math.min( startNeedle + REPLICATION_BATCH_SIZE, #data )

        local batch = {
            [1] = path,
            [2] = {},
        }

        for i = startNeedle, endNeedle do
            batch[2][i] = data[i]
        end

        network_AddContent( batch, ply )
        timer.Simple( REPLICATION_DELAY, function() SendBatch(endNeedle + 1) end )
    end

    SendBatch(1)
end

function UV_SendContent( ply, path )
    sendContentInBatch( ply, UV_GetFiles( path ), path )
end

function UV_GetFiles( path )
    local files = {}
    local stack = getStack( path )

    for i, v in ipairs( stack ) do
        table.insert( files, v.file )
    end

    return files
end

function UV_GetFile( path, fileName )
    return getFile( path, fileName )
end

-- Useless on client at the moment since the server doesn't send path info to clients
-- Although I was thinking of sending some "isWorkshop" boolean flag to client, should we need to use something like this on client
function UV_IsWorkshop( path, filename )
    local file = getFile( path, filename )
    if not file then return end

    return string.sub( file.path, 1, #WS_CONTENT_ROOT ) == WS_CONTENT_ROOT
end

function UV_LoadFile( path, fileName )
    local fileEntry = getFile( path, fileName )
    if not fileEntry then return end

    return file.Read( fileEntry.path, fileEntry.searchType )
end

function UV_AddFile( path, fileName, directory, searchType )
    local stack = type( path ) == "string" and getStack( path ) or path
    if CLIENT then
        --print("Adding file to client", path, fileName, directory, searchType)
    end

    -- We don't want to network the file if it's already in the stack (since we only send list of files to clients)
    -- We also don't need to change the stack if the file in stack already wins for the current priority mode
    local shouldNetwork = true
    local prioritySearchType = UVWorkshopPriority:GetBool()

    for i, v in ipairs( stack ) do
        if v.file == fileName then
            if wsPrio then
                if v.searchType == 'GAME' or ( v.searchType == 'DATA' and searchType == 'DATA' ) then
                    hook.Run( "UVContentEvent", "Refresh", path, fileName )
                    return
                elseif searchType == 'GAME' then
                    table.remove( stack, i )
                    shouldNetwork = false
                end
            else
                if v.searchType == 'DATA' or ( v.searchType == 'GAME' and searchType == 'GAME' ) then
                    hook.Run( "UVContentEvent", "Refresh", path, fileName )
                    return
                elseif searchType == 'DATA' then
                    table.remove( stack, i )
                    shouldNetwork = false
                end
            end

            break
        end
    end

    table.insert( stack, {
        file = fileName,
        path = directory and directory .. fileName or fileName,
        searchType = searchType
    } )

    hook.Run( "UVContentEvent", "Add", path, fileName )

    if SERVER and REPLICATED_FILES[path] and shouldNetwork then
        network_AddContent( {
            [1] = path,
            [2] = { fileName } 
        }, nil )
    end
end

function UV_RemoveFile( path, fileName )
    local stack = type( path ) == "string" and getStack( path ) or path

    local fileInfo = getFile( path, fileName )
    if not fileInfo then return end

    for i, v in ipairs( stack ) do
        if v.file == fileName then
            table.remove( stack, i )
            break
        end
    end

    -- We check if it's a file within the local data folder
    -- If it is we of course want to remove it there also
    -- Make sure to check if it's the SERVER too; we don't want connected clients to lose their files
    if SERVER and not UV_IsWorkshop( path, fileName ) then
        file.Delete( fileInfo.path, fileInfo.searchType )
    end

    hook.Run( "UVContentEvent", "Remove", path, fileName )

    if SERVER and REPLICATED_FILES[path] then
        network_RemoveContent( path, fileName, nil )
    end
end

-- The rule I am following right now is to only send mandatory files
-- Rest can probably be sent on demand in separate functions across the codebase if needed
hook.Add( "player_activate", "UV_PlayerContentReplicator", function( data )
    local id = data.userid
    local ply = Player(id)
    
    for path, _ in pairs( REPLICATED_FILES ) do
        print('Replicating', path, 'for', ply:Nick())
        UV_SendContent( ply, path )
    end

    UV_SendRaceList( ply )
    UV_SendPresets( ply )
end )