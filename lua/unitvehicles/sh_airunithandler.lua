AddCSLuaFile()

if SERVER then
    UVAirModelsData = UVAirModelsData or {}

    function UVAddAirModel(name, data)
        UVAirModelsData[name] = data

        local senddata = {}
        for k, v in pairs(data) do
            if type(v) ~= "function" then
                senddata[k] = v
            end
        end

        net.Start("UVUnitManagerAddAirModel")
            net.WriteString(name)
            net.WriteTable(senddata)
        net.Broadcast()
    end

    hook.Add("PlayerInitialSpawn", "UVSyncAirModels", function(ply)
        for name, data in pairs(UVAirModelsData) do
            local senddata = {}
            for k, v in pairs(data) do
                if type(v) ~= "function" then
                    senddata[k] = v
                end
            end

            net.Start("UVUnitManagerAddAirModel")
                net.WriteString(name)
                net.WriteTable(senddata)
            net.Send(ply)
        end
    end)

    local airtable = {
		["Default"] = {
			["Model"] = "models/uvair_default.mdl",
			["Mass"] = 32764,
			["SpotlightPos"] = Vector(159.89,0,11.88),
			["StrobePos"] = Vector(-391.33,0,141.96),
			["StrobePos2"] = Vector(34.67,0,23.31),
			["PortPos"] = Vector(-256.3,57.13,62.06),
			["StarboardPos"] = Vector(-256.3,-57.13,62.06),
			["SternPos"] = Vector(-380.99,0,67.72),
			["RotorSounds"] = {
				"<chopper/mwheli.wav",
				"<chopper/mwheli2.wav",
				"<chopper/mwheli3.wav",
				"<chopper/mwheli4.wav",
			},
			["OnWreck"] = function(wreck)
				for k,v in pairs(wreck:GetBodyGroups()) do
					wreck:SetBodygroup(k, wreck:GetBodygroup(k)+1)
				end
			end,
		},
		["NFS Hot Pursuit 2"] = {
			["Model"] = "models/hp2heliai/hp2heliai.mdl",
			["Mass"] = 30830,
			["SpotlightPos"] = Vector(77.65,0,-60.62),
			["StrobePos"] = Vector(-71.47,0,25.84),
			["StrobePos2"] = Vector(-7.27,0,-68.58),
			["PortPos"] = Vector(-247.8,39.53,60.79),
			["StarboardPos"] = Vector(-247.8,-49.77,60.79),
			["SternPos"] = Vector(-234.44,-5.02,-5.88),
			["RotorSounds"] = {
				"<chopper/mwheli.wav",
				"<chopper/mwheli2.wav",
				"<chopper/mwheli3.wav",
				"<chopper/mwheli4.wav",
			},
			["OnWreck"] = function(wreck)
				for k,v in pairs(wreck:GetBodyGroups()) do
					wreck:SetBodygroup(k, wreck:GetBodygroup(k)+1)
				end
			end,
		},
		["NFS Most Wanted"] = {
			["Model"] = "models/nfs_mwpolhel/nfs_mwpolhel.mdl",
			["Mass"] = 5026,
			["SpotlightPos"] = Vector(85,0,25),
			["StrobePos"] = Vector(-295,0,140),
			["StrobePos2"] = Vector(-28.07,0,17.35),
			["PortPos"] = Vector(-6.28,77.58,32.67),
			["StarboardPos"] = Vector(-6.28,-77.58,32.67),
			["SternPos"] = Vector(-298.67,-0.15,109.86),
			["RotorSounds"] = {
				"<chopper/mwheli.wav",
				"<chopper/mwheli2.wav",
				"<chopper/mwheli3.wav",
				"<chopper/mwheli4.wav",
			},
			["OnWreck"] = function(wreck)
				for k,v in pairs(wreck:GetBodyGroups()) do
					wreck:SetBodygroup(k, wreck:GetBodygroup(k)+1)
				end
			end,
		},
		["NFS Undercover"] = {
			["Model"] = "models/nfs_ucpolhel/nfs_ucpolhel.mdl",
			["Mass"] = 45556,
			["SpotlightPos"] = Vector(-110,0,35),
			["StrobePos"] = Vector(-390,0,165),
			["StrobePos2"] = Vector(21.35,0,31.85),
			["PortPos"] = Vector(-390.39,59.07,160.17),
			["StarboardPos"] = Vector(-390.39,-59.07,160.17),
			["SternPos"] = Vector(-390.09,0,129.25),
			["RotorSounds"] = {
				"<chopper/mwheli.wav",
				"<chopper/mwheli2.wav",
				"<chopper/mwheli3.wav",
				"<chopper/mwheli4.wav",
			},
			["OnWreck"] = function(wreck)
				for k,v in pairs(wreck:GetBodyGroups()) do
					wreck:SetBodygroup(k, wreck:GetBodygroup(k)+1)
				end
			end,
		},
		["NFS Undercover PS2"] = {
			["Model"] = "models/nfsu_copheli/nfsu_copheli.mdl",
			["Mass"] = 24242,
			["SpotlightPos"] = Vector(91.49,0,21.35),
			["StrobePos"] = Vector(-298.54,0,139.51),
			["StrobePos2"] = Vector(-27.36,0,17.58),
			["PortPos"] = Vector(-7.28,79.5,33.28),
			["StarboardPos"] = Vector(-7.28,-79.5,33.28),
			["SternPos"] = Vector(-293.06,0,73.26),
			["RotorSounds"] = {
				"<chopper/mwheli.wav",
				"<chopper/mwheli2.wav",
				"<chopper/mwheli3.wav",
				"<chopper/mwheli4.wav",
			},
			["OnWreck"] = function(wreck)
				for k,v in pairs(wreck:GetBodyGroups()) do
					wreck:SetBodygroup(k, wreck:GetBodygroup(k)+1)
				end
			end,
		},
		["NFS Hot Pursuit 2010"] = {
			["Model"] = "models/nfs_hppolhel/nfs_hppolhel.mdl",
			["Mass"] = 45154,
			["SpotlightPos"] = Vector(124,0,21.9),
			["StrobePos"] = Vector(-357.5,0,182.5),
			["StrobePos2"] = Vector(22.04,0,31.47),
			["PortPos"] = Vector(-299.36,69.42,85.83),
			["StarboardPos"] = Vector(-299.36,-69.42,85.83),
			["SternPos"] = Vector(-386.26,0,104.55),
			["RotorSounds"] = {
				"<chopper/mwheli.wav",
				"<chopper/mwheli2.wav",
				"<chopper/mwheli3.wav",
				"<chopper/mwheli4.wav",
			},
			["OnWreck"] = function(wreck)
				for k,v in pairs(wreck:GetBodyGroups()) do
					wreck:SetBodygroup(k, wreck:GetBodygroup(k)+1)
				end
			end,
		},
		["NFS No Limits"] = {
			["Model"] = "models/nfs_nlpolhel/nfs_nlpolhel.mdl",
			["Mass"] = 42382,
			["SpotlightPos"] = Vector(96,0,13),
			["StrobePos"] = Vector(-352,0,189),
			["StrobePos2"] = Vector(-207.08,0,66.06),
			["PortPos"] = Vector(-260.58,60.42,97.85),
			["StarboardPos"] = Vector(-260.58,-60.42,97.85),
			["SternPos"] = Vector(-394.18,0,180.08),
			["RotorSounds"] = {
				"<chopper/mwheli.wav",
				"<chopper/mwheli2.wav",
				"<chopper/mwheli3.wav",
				"<chopper/mwheli4.wav",
			},
			["OnWreck"] = function(wreck)
				for k,v in pairs(wreck:GetBodyGroups()) do
					wreck:SetBodygroup(k, wreck:GetBodygroup(k)+1)
				end
			end,
		},
		["NFS Payback & Heat"] = {
			["Model"] = "models/nfs_paybackpolhel/nfs_paybackpolhel.mdl",
			["Skin"] = 0,
			["Mass"] = 85322,
			["SpotlightPos"] = Vector(26,0,10),
			["StrobePos"] = Vector(-457,0,220),
			["StrobePos2"] = Vector(-126.1,-0.61,42.66),
			["PortPos"] = Vector(-95.66,77.16,71.55),
			["StarboardPos"] = Vector(-95.66,-77.16,71.55),
			["SternPos"] = Vector(-462.08,-0.74,72.05),
			["RotorSounds"] = {
				"<chopper/mwheli.wav",
				"<chopper/mwheli2.wav",
				"<chopper/mwheli3.wav",
				"<chopper/mwheli4.wav",
			},
			["OnWreck"] = function(wreck)
				for k,v in pairs(wreck:GetBodyGroups()) do
					wreck:SetBodygroup(k, wreck:GetBodygroup(k)+1)
				end
			end,
		},
		["NFS Rivals"] = {
			["Model"] = "models/nfs_paybackpolhel/nfs_paybackpolhel.mdl",
			["Skin"] = 1,
			["Mass"] = 85322,
			["SpotlightPos"] = Vector(26,0,10),
			["StrobePos"] = Vector(-457,0,220),
			["StrobePos2"] = Vector(-126.1,-0.61,42.66),
			["PortPos"] = Vector(-95.66,77.16,71.55),
			["StarboardPos"] = Vector(-95.66,-77.16,71.55),
			["SternPos"] = Vector(-462.08,-0.74,72.05),
			["RotorSounds"] = {
				"<chopper/mwheli.wav",
				"<chopper/mwheli2.wav",
				"<chopper/mwheli3.wav",
				"<chopper/mwheli4.wav",
			},
			["OnWreck"] = function(wreck)
				for k,v in pairs(wreck:GetBodyGroups()) do
					wreck:SetBodygroup(k, wreck:GetBodygroup(k)+1)
				end
			end,
		},
		["NFS Unbound"] = {
			["Model"] = "models/unboundheli/unboundheli.mdl",
			["Mass"] = 123078,
			["SpotlightPos"] = Vector(28.63,0,-0.05),
			["StrobePos"] = Vector(-465.71,0,200.94),
			["StrobePos2"] = Vector(-128.14,0,20.19),
			["PortPos"] = Vector(-102.39,76.75,50.76),
			["StarboardPos"] = Vector(-102.39,-76.75,50.76),
			["SternPos"] = Vector(-472.19,0,50.45),
			["RotorSounds"] = {
				"<chopper/mwheli.wav",
				"<chopper/mwheli2.wav",
				"<chopper/mwheli3.wav",
				"<chopper/mwheli4.wav",
			},
			["OnWreck"] = function(wreck)
				for k,v in pairs(wreck:GetBodyGroups()) do
					wreck:SetBodygroup(k, wreck:GetBodygroup(k)+1)
				end
			end,
		},
		["NFS High Stakes"] = {
			["Model"] = "models/nfs_hs_CHOP/nfs_hs_CHOP.mdl",
			["Mass"] = 12382,
			["SpotlightPos"] = Vector(107.89,-0.2,1.26),
			["StrobePos"] = Vector(11.08,-0.9,16.22),
			["StrobePos2"] = Vector(-270.31,-0.05,125.71),
			["PortPos"] = Vector(-210.84,-7.32,91.73),
			["StarboardPos"] = Vector(-210.84,7.32,91.73),
			["SternPos"] = Vector(-265.13,-0.3,92.41),
			["RotorSounds"] = {
				"<chopper/mwheli.wav",
				"<chopper/mwheli2.wav",
				"<chopper/mwheli3.wav",
				"<chopper/mwheli4.wav",
			},
			["OnWreck"] = function(wreck)
				for k,v in pairs(wreck:GetBodyGroups()) do
					wreck:SetBodygroup(k, wreck:GetBodygroup(k)+1)
				end
			end,
		},
		["The Crew"] = {
			["Model"] = "models/thecrewheli/thecrewheli.mdl",
			["Mass"] = 5026,
			["SpotlightPos"] = Vector(126.11,0,16.96),
			["StrobePos"] = Vector(-404.87,0,170.23),
			["StrobePos2"] = Vector(-53.16,0,22.9),
			["PortPos"] = Vector(-284.61,62.39,99.24),
			["StarboardPos"] = Vector(-284.61,-62.39,99.24),
			["SternPos"] = Vector(-402.28,0,106.04),
			["RotorSounds"] = {
				"<chopper/mwheli.wav",
				"<chopper/mwheli2.wav",
				"<chopper/mwheli3.wav",
				"<chopper/mwheli4.wav",
			},
			["OnWreck"] = function(wreck)
				for k,v in pairs(wreck:GetBodyGroups()) do
					wreck:SetBodygroup(k, wreck:GetBodygroup(k)+1)
				end
			end,
		},
	}

    timer.Simple(5, function()
        for name, data in pairs(airtable) do
            UVAddAirModel(name, data)
        end
    end)

else

    net.Receive("UVUnitManagerAddAirModel", function()
        local name = net.ReadString()

        UVAirModelsList = UVAirModelsList or {}

        local exists = false
        for _, entry in ipairs(UVAirModelsList) do
            if entry[1] == name then
                exists = true
                break
            end
        end

        if not exists then
            table.insert(UVAirModelsList, { name, name })
        end

        local data = net.ReadTable()
        UVAirModelsData = UVAirModelsData or {}
        UVAirModelsData[name] = data
    end)

end