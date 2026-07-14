UV = UV or {}

-- ["VERSIONNUMBER"] = { --MAJOR.MINOR.PATCH
-- Date = "RELEASEDATE",
-- Text = [[

-- ]],
-- },

UV.PNotes = {
["1.8.0"] = {
Date = { year = 2026, month = 7, day = 31 },
Type = "Minor",
Text = [[
Unit Vehicles - 1.8.0 is finally here! Took a bit longer than expected but it has been worth the wait. Here are the Patch Notes:

**New Features**
- Added Action Camera, experience cinematic sequences during certain gameplay moments
      |-- When enabled, the camera will show dramatic angles during certain events
      |-- Gameplay may slow down in singleplayer
      |-- Use the speedbreaker to prevent Action Cam from activating
      |-- Adjust its options under the new <color=255,255,100>Camera</color> tab

- Added Driver Models
      |-- Added <color=255,255,0>Creator: Driver Models</color> Tool for you to add new Driver Models
      |-- Assign which models should the Racers, Traffic and Units use in <color=255,255,0>AI Racer Manager, Traffic Manager and Heat Level Manager</color> respectively
            |-- Toggle button is located under <color=255,255,0>AI Settings</color>

- Added improvements for Air Units
      |-- Addon creators can now create their own custom chopper models with custom lighting positions, weight and sounds
            |-- Refer to <color=255,255,0>#uv-updates</color> under our Discord server for more details
      |-- Added new variables to be changed in the preset (min fuel time, max fuel time, spawn chance, spawn limit, you can have X number of choppers now)
      |-- Added Skyhammer PT weapon option
            |-- Takes twice as long to lock on but has double the disable duration
            |-- Dodge it by outmaneuvering the Air Unit, taking cover or using the Jammer

- Added Pursuit Breaker SFX
      |-- Located under <color=255,255,0>sound\pursuitbreakers</color> where sounds are played according to the name of each Pursuit Breaker

- Added Roadblock spawn chance for each Heat Level
- Added the ability to EMP an Air Unit

**Changes**
- Updated Chatter Template (refer to GitHub)
- Air Unit: Gave back the badging for most chopper models
- Default Chatter: Roboboy now works at the desk (swapped roles with Moka)

**Fixes**
- Fixed that Chatter related to Pursuit Tech were not triggering
- Fixed Repair Shops not detecting vehicles travelling at supersonic speeds
- Fixed Units patrolling on waypoints not meant for traffic
- You can now hide from Units when not in pursuit
- Traffic now gets despawned along with Units on race start
- Units can now get taken out when flipped over by Traffic or by other Units rammed by the Racer
- Improved optimization for GMinimap support
- Improved AI Logic
- Many other smaller undocumented fixes/optimizations

/// RACE /// CHASE /// ESCAPE ///
]],
},

["1.7.4"] = {
Date = { year = 2026, month = 6, day = 1 },
Text = [[
**Fixes**
- Fixed Chatter erroring if emergency chip was not found
- Fixed Chatter spamming when multiple suspects are in a pursuit
]],
},
["1.7.3"] = {
Date = { year = 2026, month = 5, day = 31 },
Text = [[
**Fixes**
- Fixed first-time setup presets causing errors
]],
},
["1.7.2"] = {
Date = { year = 2026, month = 5, day = 27 },
Text = [[
**Fixes**
- Fixed minor inconsistencies with the Creator Tools
]],
},
["1.7.1"] = {
Date = { year = 2026, month = 5, day = 27 },
Text = [[
**Additions**
- Added a new toggle: *Workshop Priority*, found inside <color=255,255,0>Settings / UV Settings / Data Import</color>
      |-- If enabled, Workshop content will be prioritized over Local content
      |-- Disable this if you want to use/work on local content instead of Workshop content
      |-- You will need to reload the map for the change to take effect.
]],
},    
["1.7.0"] = {
Date = { year = 2026, month = 5, day = 27 },
Type = "Minor",
Text = [[
**New Features**
- Added a new *Cautious Mode* and *Cautious Mode Randomness* variables for AI Racers
      |-- Makes AI Racers more cautious when racing
      |-- Slows down when approaching other racers, and turns away when side-by-side
      |-- *Randomness* can apply a modifier to some racers and not others

- Added a new *Traffic Streaming* variable
      |-- Spawns traffic and units closer to players
      |-- Despawns them when they are too far away from players

- Added option to *relocate your current Unit*
      |-- Instead of spawning in a completely new Unit, you can relocate your current one.
      |-- Relocating will also repair your vehicle and replenish your Pursuit Tech.
      |-- The same cooldown applies as when respawning normally.

**Changes**
- The UVPD fleet have received a full appearance rework, with fixed UV layouts

- Reworked *data/content loading system*
      |-- UV workshop content is now treated as "mountable" content
      |-- Client now reflects content available on the server in both Workshop and Local content data
      |-- This means that items in your local 'data' folder are separated from Workshop content (local data takes priority over Workshop content)
      |-- You may have to clean up your local 'data' folder to remove any Workshop files that are no longer needed in the 'data' folder; they are now loaded from the addons themselves
      |-- This change has also reworked the way presets are loaded and saved:
            |-- Presets are now saved in & loaded from the <color=255,255,0>data/unitvehicles/preset_import</color> folder
            |-- When you load up a map for the first time after updating, the local presets you had saved will be imported into the new system, after which the old presets will be deleted
            |-- This change also eliminated the use of the 'Export Presets' button in the UV menu, as presets are stored in the new system which is also the same system that allows presets to be imported from external sources

- Improved the appearance of *Name Tags* during pursuits
      |-- The tags will be compact when far away
      |-- Units: Tags of suspects will grow and display more information when you get closer

- Optimized the spawning process for *AI Racers*
      |-- Racers are now teleported instead of re-spawned on grid slots, resulting in way faster loading times as well as more 'versatility'
      |-- If you prefer the legacy spawning method or you are having issues with the new method, you can toggle it in the <color=255,255,100>Race Manager / Race Options</color> tab

- The *Optimize Respawn* setting now supports *all* vehicle bases, not just Glide
- Removed the *Evade with Active Commander* variable due to being redundant
- Added new *cop* voice lines
- Bullhorn is made louder overall
- Nerfed upgraded Grappler Pursuit Tech

**Fixes**
- Fixed that the "Busting" prompt on Name Tags would always appear if the Busting Timer was set to 0.
- Fixed that the *Grappler* Pursuit Tech did not detach when the suspect was wrecked or busted.
- Fixed that Roadblock Units were recycling when *Optimize Respawn* was enabled.
- Fixed Helicopter being able to spot players from afar, as well as while hiding
- Fixed prop_vehicle_jeep vehicles not having their 'virtual' health applied under certain circumstances
- Fixed inconsistencies with UI 'Cop Mode'
- Unit AI tweaks
- Many other smaller undocumented fixes/optimizations!

**What's next?**
We'd like to take this opportunity to disclose what we are currently planning:

For a long while now, we have been considering of expanding the playability of UV by introducing some sort of gameplay with progression. We think that we've reached the point where we essentially have a complete 'base' for it and having majority of the core features implemented.

With that said, we'd like to announce that we are planning out a <color=255,255,0>gamemode</color> for Unit Vehicles! It will be a full-fledged gamemode, with its own set of features, mechanics and progression.

The plan is to allow players to be both a Unit and a Racer, having two different paths to progress through; similar to the "Need For Speed: Rivals" formula *( with our own features and twists to it ;) )*.
Each map will have its own objectives, races, challenges, etc.
We aim to allow players to customize many aspects of their gameplay and easily introduce custom content, making each experience unique and tailored by the player.

The cores are still being established so we don't really have a 'concrete' idea of what it will look like just yet - this is where you guys come in!
We will continue making adjustments and reworking bits of Unit Vehicles to make it more flexible and "expandable" for such a thing.

Having that said however, we'd also like to ask <color=255,255,0>you, the community</color>, to help us along the way!
      |-- We are hoping to gather some of *your* suggestions and feedbacks on what you'd like to see in the gamemode, we are open to any and all ideas!
      |-- You can either submit your suggestions via our Discord server, or by creating a new 'Discussion' post on the addon's Steam page; I assure you that we read both!

We appreciate your support and all the help you've all given us so far! We will continue to do our best to ensure an even better experience. Thank You all! :D

/// RACE /// CHASE /// ESCAPE ///
]],
},

["1.6.1"] = {
Date = { year = 2026, month = 4, day = 24 },
Text = [[
**Fixes**
- Fixed improper bit count when sending the Fined event, resulting in the paid fine having an incorrect value.
]],
},

["1.6.0"] = {
Date = { year = 2026, month = 4, day = 24 },
Type = "Minor",
Text = [[
**New Features**
- UVPD: Added two new vehicles to the fleet:
      |-- Dodge Viper SRT-10 ACR Command Interceptor '11
      |-- Dodge Charger SRT8 Super Bee (LX) '07

- Pursuits: Replaced the global pursuit system with an *individual pursuit system*
      |-- Racers can now hide, evade and join pursuits individually
      |-- Vehicles have their own heat level, bounty, infractions, etc.
      |-- Units will spawn as units from the highest heat level racer's pool

- AI Racers: Added a new *Inverted Rubberband* feature
      |-- AI that are ahead of players will gradually slow down
      |-- Does not apply during Pursuits, or if they are rubberbanding up to another player

- Added a new content importer
      |-- Prompts the user if data from Workshop addons (such as the starter pack) is not present in their data folder
      |-- Also prompts the user if data from Workshop addons already exist, but differ in any way
      |-- Will have the option to accept the import and/or replacement, or skip it
      |-- Checks for: 
            |-- <color=255,255,100>Racer Names</color>
            |-- <color=255,255,100>Pursuit Breakers</color>
            |-- <color=255,255,100>Races</color>
            |-- <color=255,255,100>Repair Shops</color>
            |-- <color=255,255,100>Roadblocks</color>
            |-- <color=255,255,100>DV Waypoints</color>
            |-- <color=255,255,100>Nav Meshes</color>
            |-- <color=255,255,100>Unit Presets</color>
            |-- <color=255,255,100>Glide/Simfphys/LVS/HL2 Jeep Vehicles</color>
      |-- Can be disabled, or triggered manually, in the new *UV Menu / Settings / UV Settings* tab

- Added new Name Tag settings:
      |-- *Outline Thickness*
      |-- *Fade-out Distance*
      |-- *Max Nr. On-Screen*

**Please Note**
The content importer will check all your UV content to see if anything is mismatched. Due to this, you can experience a hickup when going in-game. You can disable the import and/or replacement functions in the new UV Settings submenu inside the Settings menu.

**Changes**
- Improved AI Racer behaviour during races:
      |-- AI will slow down if another racer ahead of them is driving slower
      |-- AI will swerve away from other racers if side-by-side
- Improved AI Racer Rubberband:
      |-- Now checks for actual players ahead of them before rubberbanding
      |-- If there's no players ahead (only AI), then they'll never rubberband
- Player Units can now initiate pullovers and pursuits
      |-- When they see a racer perform an infraction, they can enable their siren to pull them over/start a pursuit
- Altered the appearance of all UVPD vehicles
- Altered the appearance of the Racing and Pursuit Name Tags
- <color=255,255,100>Creator: Units</color> Tool: Removed the Optional Settings when creating a Unit
- <color=255,255,100>Heat Manager</color>: Removed 'Enable Heat Levels' option; Now always enabled
- Racers are no longer added to the 'Wanted List' if Dispatch calls out 'Unknown model'
- The Air Unit now sets their own altitude
- Default voice preset has been changed to provide more variety

**Fixes**
- Fixed a consistent error on the Race Information prompt, where the "Host" status was given to any Admin and/or Superadmin that was in a car
- Fixed that the Speedometer speed values would become jittery when playing for a longer period of time
- Fixed that the Speedometer's health value could go to "inf" if *Unlimited Durability* was enabled
- Fixed that Pursuit Tech notifications were pushed up during police chatter
]],
},

["1.5.3"] = {
Date = { year = 2026, month = 4, day = 4 },
Text = [[
**Fixes**
- Fixed that the busting speed penalties were applying to all racers if one racer reset during pursuits
]],
},

["1.5.2"] = {
Date = { year = 2026, month = 4, day = 1 },
Text = [[
**Fixes**
- Fixed that Glide traffic vehicles were not spawning
]],
},

["1.5.1"] = {
Date = { year = 2026, month = 3, day = 31 },
Text = [[
**Fixes**
- Fixed the *NIGHT-RUNNERS™ PROLOGUE* speedometer displaying incorrectly on non-16:9 resolutions
]],
},

["1.5.0"] = {
Date = { year = 2026, month = 3, day = 30 },
Type = "Minor",
Text = [[
**Quick Information**
Many patches had been added to UV since its launch that were undocumented.
We've taken the liberty on adding smaller patches to the Update History section:
      |-- v1.0.1
      |-- v1.1.1
      |-- v1.2.1
      |-- v1.2.2
      |-- v1.2.3
      |-- v1.2.4
      |-- v1.2.5
      |-- v1.4.1

Lastly, some updates have had their version numbers altered for better consistency:
      |-- v1.0.1  →  v1.0.2
      |-- v1.3.1  →  v1.4.0

**New Features**
- Added full support for the *LVS* vehicle base
- Added a new HUD Type and Speedometer, both based off of *NIGHT-RUNNERS™ PROLOGUE*

**Changes**
- UV Menu: Updated the appearance on almost all elements
- Updated the appearance of the Spawnmenu element on the following tools:
      |-- [string:tool.uvpursuitbreaker.name]
      |-- [string:tool.uvracermanager.name]
      |-- [string:tool.uvrepairshop.name]
      |-- [string:tool.uvroadblock.name]
      |-- [string:tool.uvtrafficmanager.name]
      |-- [string:tool.uvunitmanager.name]
]],
},

["1.4.2"] = {
Date = { year = 2026, month = 3, day = 21 },
Text = [[
**Fixes**
- Fixed an issue where Roadblocks and Pursuit Breakers were not created properly
- Fixed problems related to the traffic
]],
},

["1.4.1"] = {
Date = { year = 2026, month = 3, day = 20 },
Text = [[
**Fixes**
- Fixed an issue where the "Repair Kit" Pursuit Tech caused errors
- Fixed an issue causing Pursuit Breakers to not clean up properly
]],
},

["1.4.0"] = {
Date = { year = 2026, month = 3, day = 20 },
Type = "Minor",
Text = [[
**New Features**
- Added *Infractions* during pursuits
      |-- When performing actions seen by Units, you'll gain Infractions
      |-- Units will respond to calls and target drivers committing Infractions
      |-- These are counted on the *Pursuit Results* screen for Racers only
      |-- Available exclusively on the *Most Wanted* HUD for now
      |-- Added a new FAQ section under *Pursuits* explaining each infraction
- Added a new "Customize HUD" setting
      |-- Currently only allows you to change how many racers are displayed on the leaderboard

**Changes**
- Reworked the Reset system
      |-- Can now be done while moving
      |-- Press [key:unitvehicle_keybind_resetposition] to begin the Reset countdown; press it again to cancel it
- If you reset mid-pursuit, you'll gain these penalties for <color=255,255,100>10</color> seconds:
      |-- <color=255,100,100>+400%</color> Time until Busted & Bust Speed (MPH)
- Reworked the lower notification system
      |-- Affects the <color=255,255,100>Race ends in</color>, <color=255,255,100>Spawn as {Unit}</color> and new <color=255,255,100>Resetting in</color> timers
- UV Menu: Added the ability to press [+attack2] on folders in the *Vehicle Override* to add/remove all vehicles in that category
- Improved optimazion across the board
- Updated localizations
]],
},

["1.3.0"] = {
Date = { year = 2026, month = 3, day = 14 },
Type = "Minor",
Text = [[
**New Features**
- Racing: Added a *Racer Difficulty* setting
      |-- Set it to "Easy", "Medium" or "Hard"
      |-- The higher difficulties grant the AI Racers increased traction and cornering speeds
- Racing: Added a *Catch-up* setting
      |-- When enabled, AI Racers will get increased speed and traction when far behind
- Pursuits: Added a *Unit Difficulty* and *Catch-up* setting, identical to those above, but for AI Units
- AI Racers will now reset when driving via Path Nodes and they've missed a checkpoint
- Added themed "Wrong Way!" notifications on almost all HUD Types
- Added a new tool: [string:tool.uvrepairshop.name]
      |-- Spawn Repair Shops with the tool
      |-- Save them as .json presets for each map
      |-- Allow Repair Shops to spawn on their own automatically
- Added support for themed Speedometers
      |-- Can be customized via a new *<color=255,255,0>Customize Speedometer</color>* button
      |-- Only works in <color=255,255,0>Glide</color> vehicles
      |-- This update provides themed *Most Wanted*, *Carbon* and *Underground 2* speedometers
- Added tips that are displayed on the end-of-pursuit results screens on all HUD types

**Changes**
- Pursuits: Multiple suspects can now initiate the "Hiding" phase during cooldown if all suspects have their engine turned off
- AI Racers: When resetting while driving via Path Nodes, the AI racers will now assign themselves the closest small node rather than large node
- AI Racers: Improved navigation via DV waypoints when freeroaming
- AI Racers: When freeroaming via DV waypoints, if an AI racer gets stuck for a sufficient amount of time, it will reset its navigation target
- Racing: Updated the appearance of checkpoints:
      |-- Now displays the distance to the next checkpoint
      |-- Displays an arrow inside the checkpoint pointing towards the next one
- "Unlimited Durability" now gets applied whenever you enter a vehicle, not when a pursuit begins
- When "Racer Pursuit Tech" is enabled, all players will receive random Pursuit Tech whenever they enter a vehicle
      |-- Only happens if the vehicle does not have Pursuit Tech already
- Tweaked the [string:tool.uvracemanager.name] tool:
      |-- Checkpoints and Grid Slots now fade out the farther away you are from them
      |-- Their texts also shrink the farther away you are from them
      |-- Changed the appearance of the Path Nodes:
            |-- Nodes are larger and have an outline
            |-- Connections are animated with an arrow showing their direction
- Resetting mid-pursuit also resets a Unit nearby to wherever you reset to
- Moved some settings to new locations
      |-- Call Response (AI Settings → Pursuit Settings)
      |-- Speed Limit (AI Settings → Pursuit Settings)
      |-- Radio Chatter (AI Settings → Pursuit Settings)
- The Air Unit can now be taken out when it is in the process of disengaging from the pursuit
- Updated the *Original* HUD Type to be more old-school and replicate how it was during UV's alpha stages
- The Pursuit Tech HUD element now moves with your chosen custom speedometer

**Fixes**
- Fixed some keybinds not having glyphs
- Fixed that Pursuit Tech sometimes did not apply damage correctly

And many more smaller undocumented fixes.
]],
},

["1.2.5"] = {
Date = { year = 2026, month = 2, day = 27 },
Text = [[
**Changes**
- Added a toggle to no longer display the DV Waypoints warning
      |-- Increased the cooldown for it too
]],
},

["1.2.4"] = {
Date = { year = 2026, month = 2, day = 25 },
Text = [[
**Fixes**
- Fixed that Simfphys and HL2 Jeep Units were not saving properly

**Changes**
- Updated localizations
]],
},

["1.2.3"] = {
Date = { year = 2026, month = 2, day = 24 },
Text = [[
**Changes**
- Added a cooldown for the DV Waypoints warning
]],
},

["1.2.2"] = {
Date = { year = 2026, month = 2, day = 24 },
Text = [[
**Fixes**
- Fixed that "Allow Vehicle Exit" was not visible in multiplayer

**Changes**
- Updated localizations
]],
},

["1.2.1"] = {
Date = { year = 2026, month = 2, day = 24 },
Text = [[
**Fixes**
- Fixed that AI Racers weren't following DV Waypoints when freeroaming
]],
},

["1.2.0"] = {
Date = { year = 2026, month = 2, day = 24 },
Type = "Minor",
Text = [[
**New Features**
- Racing: Added support for *AI Path Nodes*
      |-- When included, AI Racers will follow these paths instead of checkpoints
      |-- Path Nodes support multi-path racing, where the AI will now randomly pick a route
      |-- *Curve Strength* allows the user to apply a gradual turn for longer paths
- Added two new Pursuit Techs:
      |-- [string:uv.ptech.ghost] (Racers) - Become non-collidable with props and other vehicles for a short time
      |-- [string:uv.ptech.grappler] (Units) - Grab a fleeing vehicle's wheels and hold them in place
- Added support for themed Police Scanners
      |-- Only *Most Wanted* has its themed scanner for the time being
      |-- Also added the option to have the vehicle's forward axis be used for the scanner rather than the camera 
- Added the ability to limit how many Units can be part of the pursuit
      |-- Applied in [string:uv.hm]
- Added a warning for when you try to spawn any AI without having Decent Vehicle waypoints loaded

**Changes**
- Temporarily disabled subtitles due to mismatching subtitles compared to existing, replaced and added default voice lines
- Improved Unit AI pathing
- Removed the legacy text-based police chatter
- Updated the description for tracks when importing them to signal if they have Path Nodes and/or Props
- Updated default Cop1 vehicle identification lines
- Music Volume now affects currently playing UVTrax and Pursuit Themes

**Fixes**
- Fixed that UVTrax provided the raw folder name in the notification rather than the metadata folder name
      |-- This only applies to UVTrax profiles that utilize JSON files for song titles, authors and folder names
- Fixed that Pursuit Breakers, when wrecking Units, caused a Pursuit to engage, even if there was no racers to pursue
- Fixed that the *Name Tags* variable was a server variable when it should've been a client variable
]],
},

["1.1.1"] = {
Date = { year = 2026, month = 2, day = 7 },
Text = [[
**Fixes**
- UV Menu: Fixed that colour was not defined correctly in the description tab.
]],
},

["1.1.0"] = {
Date = { year = 2026, month = 2, day = 3 },
Type = "Minor",
Text = [[
**New Features**
- UV Menu: Added a new First-Time Setup menu
      |-- Will automatically display for all users, forcing them to go through necessary settings
      |-- Existing users from v1.0.0 can choose to skip the Preset selection
- Added a Police Scanner SFX toggle

**Changes**
- UV Menu: [string:uv.menu.welcome] now has [string:uv.pm.pursuit.start] and [string:uv.pm.pursuit.start] options.
- Creator: Races tool: Tweaked its functionality slightly:
      |-- [+reload] now cycles modes between Checkpoint and Grid Slots
      |-- [+attack] now creates Checkpoints or Grid Slots, depending on whichever is selected
      |-- Updated HUD tooltips to reflect these changes
      |-- If the speed limit is set to 0, editing a checkpoint's ID no longer alters its speed limit value
- Race Invites can now be sent and accepted/declined while a pursuit is active
- Units will no longer spam-use bullhorn voice lines

**Fixes**
- Fixed that the Race Host status could be "stolen" from an Admin by a Super Admin
- Fixed that the Totaled UI did not close when joining a pursuit while "Spawn as Random Unit" was enabled
- Fixed that the "Spike Strip Deployed" cop chatter had a tendency to spam
- Fixed that Voice Profiles could cause a server connection loop if too many are selected
]],
},

["1.0.2"] = {
Date = { year = 2026, month = 1, day = 30 },
Text = [[
This patch brings fixes for bugs reported by the community as well as other improvements/tweaks to the addon.
Keep 'em coming! We appreciate your reports and feedback!

**Fixes**
- Fixed that the "Creator: Units" tool did not allow you to assign Units to a Heat Level due to outdated convars.
- Fixed that the "Creator: AI Racers" tool caused an error when trying to select a vehicle from the vehicle database.
- Fixed Unit AI getting stuck idling after pursuits get concluded.
- Slightly altered chatter behavior for more consistency.
]],
},

["1.0.1"] = {
Date = { year = 2026, month = 1, day = 29 },
Text = [[
**Fixes**
- Fixed an unlocalized Pursuit Tech notification causing errors
]],
},

["1.0.0"] = {
Date = { year = 2026, month = 1, day = 29 },
Type = "Major",
Text = [[
This lists changes that were made after v.0.42.0 and have been applied to v1.0:

**New Features**
- UV Menu: Added button prompts at the bottom of the menu to display which button does what on the highlighted setting; Can be toggled on/off in the UI Settings
- UV Menu: Added the ability for addon creators to have settings added into the UV Menu
- Several UVTrax additions:
      |-- Added a song manager where you can choose which songs play and which don't
      |-- Added the ability to shuffle the UVTrax playlist, or play them in alphabetical order
      |-- Added the ability to go to the previously played track
      |-- Added button prompts on the UVTrax pop-up
- Added new Glyphs that replace "[ SPC ]" and various other keybind notifications across the addon
- UV Menu: Added a "Glyph Override" function, allowing you to define not only your own keyboard and mouse glyphs (cosmetically, of course), but also assign Xbox, PlayStation and Switch glyphs
- Added a "Default" preset for the Heat Level Manager
- Added new elements to the Original HUD style
- Added a "You finished {place}!" notification for whenever you finish a race on most HUD types
- Added the option to disable Pursuit SFX
- UV Menu: Added a new FAQ/Racing entry for racing with AI

**Changes**
- UV Menu: "VCMod ELS" and "Circular Functions" sections in the Settings Addon tab now show/hide themselves if depending on if they are installed or not
      |-- Additionally, third-party addons can now use a custom function to integrate their settings into the UV Menu
- Race participants are now teleported in 12-participant batches
      |-- This now allows races with more than 24 racers
- Lowered the size on the "Respawning as" and "Race ends in" notifications
- "Spawn X AI" and "Fill Grid with AI" pre-race buttons no longer appear if AI cannot spawn in any vehicles
      |-- Either when "Vehicle Override" is enabled but no vehicles are selected, or if it's disabled but no presets exist
- The Race host will now be added as a proper participant rather than a hidden one
- The Race host's car will dynamically change if they enter/exit a vehicle
- Race participants will get auto-removed from the participants list if they decline their invite, or if their vehicle is destroyed before the race starts
- Pre-race player list now uses the same appearance as the Race Info player list

**Fixes**
- Fixed that Glide vehicle categories were not sorted correctly in the Vehicle Override lists
- Fixed that the "READY" banner on the NFS World HUD type remained on-screen if you swapped HUD types after it appeared and when the race countdown started, but before the race began
- Fixed that when you start a one-checkpoint race, the "Nr. of Laps" variable was always set to 1
- Fixed that Units sometimes used the *Shock Ram* Pursuit Tech when busting racers
- Fixed an error that caused Simfphys and default HL2 Jeep vehicles to create Lua errors when the AI turned their headlights on
- Fixed an error that caused Dispatch to not recognize "default" vehicle colors
      |-- Fixes that the NFS World and NFS Undercover Glide packs' police cars always played "no make and model" voicelines
- Fixed that localizations, on the Workshop addon, mysteriously had an extra blank space after them, causing them to shift very slightly to the left
]],
},

["0.42.0"] = {
Date = { year = 2026, month = 1, day = 16 },
Type = "Minor",
Text = [[
**Almost there!**
Unit Vehicles is getting closer and closer to its v1.0 release on *January 29th*!
Mark your calendars, it's almost time to **Race, Chase or Escape**!

**New Features**
- Added the *UVPD Rhino Truck*
- Added the *Heat Level Manager* to the *Pursuit Manager* UV Menu Tab
      |-- This replaces the *Manager: Units* settings.
- Added a Race Countdown to the NFS: ProStreet HUD
- Added a new, updated list appearance to the AI Racers, Pursuit Breaker, Roadblocks, Traffic & Units tools
      |-- AI Racers, Traffic and Units also have new base sorting to only list vehicles from a particular base
- Added Vehicle Override for the Traffic Manager, working identically to the AI Racer one

**Changes**
- UV Menu: All convars in the menu now control their correct server convars
      |-- This means that the "Apply Settings" buttons will be removed across the board
- Moved the "Creator: Pursuit Breaker" and "Creator: Roadblocks" settings to the UV Menu
- Renamed the "Manager: Units" tool to "Creator: Units"
- Removed all settings from all Creator tools
- Removed "Relentless" AI option and replaced it with a dynamic behaviour system
      |-- Patrol and Support Units are never relentless
      |-- Pursuit, Interceptor and Air Units have a random chance to become relentless
      |-- Special, Commander and Rhino Units are always relentless
- Improved AI Unit pursuit tactics
- Removed some default cop chatter and updated others
- Air Unit's wreck callout will now have priority over all others

**Fixes**
- Fixed that Repair Shops repaired less health than it should've when Infinite Durability is enabled
- Fixed that "Evade" and "Busted" meters could fill up at the same time on rare instances
]],
},

["0.41.0"] = {
Date = { year = 2026, month = 1, day = 5 },
Type = "Minor",
Text = [[
**New Features**
- Added the *UVPD Chevrolet Colorado ZR2 2017 Police Cruiser*
- Added a new *Update History* section in the UV Menu - accessed via the *Welcome Page*

**Changes**
- Special and Commander Units' Pursuit Tech now has x2 power (excluding Spike Strips)
- "Enable Headlights" AI Settings option now allows an "Automatic" setting, where AI enable their headlights in dark areas
- When exporting races, you can now choose if you want to export DV Waypoints or not
- Vehicles and hand-spawned entities will no longer be removed when loading a race with props
- Updated translations

**Fixes**
- Fixed that the "Glide" category within the AI Racer Manager's "Vehicle Override" was duplicated, and caused errors if too many Glide vehicles were installed
- Fixed that Keybinds never displayed their "Press any button" prompt
- Fixed that Commander Unit's health reset when "Optimize Respawn" was enabled, and the Commander Unit was moved
- Fixed that Settings were never transmitted to the server when running in a Multiplayer instance
]],
},

["0.40.0"] = {
Date = { year = 2025, month = 12, day = 31 },
Type = "Minor",
Text = [[
**The final stretch!**
We're now preparing Unit Vehicles for its v1.0 release. There's lots to do still, and we hope to keep receiving feedback until then.

**New Features**
- Added the *UVPD Chevrolet Corvette Grand Sport (C7) Police Cruiser*
- Added the ability to reset in freeroam and in pursuits
- AI Racers and Units will no longer rotate while mid-air
       |-- Only applies to Glide vehicles
- The UV Menu and all fonts will now scale properly on all resolutions
- Added the ability for the community to create custom HUDs
      |-- These are automatically added to the UV Menu Settings
- Added Polish translations
  
**UV Menu**
- Added new *AI Racer Manager*, *Traffic Manager* and *Credits* tabs
       |-- Moved all of the "Manager: AI Racers" and "Manager: Traffic" settings to these tabs
- Added new *Keybinds* tab inside the Settings instance
- Added a *Timer* variable in the UV Menu, applied to the *Totaled* and *Race Invite* menus
- Added a custom dropdown menu in the UV Menu, used by the *UVTrax Profile* and *HUD Types*
- Texts on all options will now scale and split properly
- Rewrote the entire *FAQ* section

**Changes**
- Pursuit Breakers will now always trigger a call response
- The *Vehicle Override* feature from the "Manager: AI Racers" tool (now present in the UV Menu) now supports infinite amount of racers
- The Air Unit will now create dust effects depending on what surface it hovers over
- Relentless AI Units will no longer know player hiding spots
- UV Menu: The *FAQ* tab now sends you to a separate menu instance with categorized information
- UV Menu: The *Addons* tab was moved to UV Settings
- UV Menu: The *Freeze Cam* option no longer appears in the UV Menu while in a Multiplayer session
- Updated various default Cop Chatter lines
- Updated localizations

**Fixes**
- Fixed that AI Racers sometimes steered weirdly after entering another lap
- Fixed that the Air Unit's spotlight wasn't always active
- Fixed that Units still respawned when the Backup timer was active
- Fixed that roadblocks sometimes spawned when a call response was triggered
- Fixed that the EMP Pursuit Tech did not have a localized string on the HUD
- Fixed that the Busted debrief did not always trigger if multiple racers were busted in a short time
- Fixed that the Race Options caused errors in Multiplayer
- Fixed that the Race Invite caused an error when clicking outside of its window, causing it to close prematurely
- Fixed that invalid Subtitles sent the Pursuit Tech notification upwards
- Fixed that clicking on a dropdown option outside the UV Menu, the menu would close if it was set to "Close on Unfocus"
- Fixed a lag spike when pursuit music plays for the first time
- Fixed that Pursuit Breakers sometimes did not wreck Units
]],
},

["0.39.1"] = {
Date = { year = 2025, month = 12, day = 17 },
Text = [[
# New Features
- **UV Menu**: Added **Carbon** Menu SFX
- **Race Manager**: Added new race options:
> - Start a pursuit X seconds after a race begins
> - Stop the pursuit after the race finishes
> - Clear all AI racers and/or Units when the race finishes
> - Visually hide the checkpoint boxes when racing

- **Race Invites** now use the new menu system
- **Unit Totaled**: Slightly tweaked appearance

**Chatter**
- Added more lines for Cop6

And various other undocumented tweaks
]],
},

["0.39.0"] = {
Date = { year = 2025, month = 12, day = 11 },
Type = "Minor",
Text = [[
# New Features
**UV Menu**
Say hello to the newly introduced UV Menu, the full replacement for the Spawn Menu options and more. Accessed via the Context Menu or **unitvehicles_menu** command:

- **Welcome Page** - Includes some quick access buttons and variables, and a handy **What's New** section, where we will post update notes
- **Race Manager** - Moved the Race Manager tool race control variables here
- **Pursuit Manager** - Moved all Pursuit Manager buttons here
- **Addons** - The one place for both included and third-party UV addons. Moved **Circular Functions** variables here
- **FAQ** - Need some quick help? The Discord FAQ has been uploaded here!
- **Settings** - Want to tweak something? All Client and Server settings are present here

Additionally, both the **Unit Totaled** and **Unit Select** now use the same menu system.

Don't like the colours? Then change it! Change the colour of buttons, the background and more in the **User Interface** settings tab!

**Things to note**
- Many options are server only, meaning they will not be displayed to clients.
- The options present in the menu can still be accessed via their original methods (Spawn Menu > Options > Unit Vehicles) for roughly 3 update cycles of UV before they will be removed.
- The menu isn't perfect - it will be refined over time.

# Changes
**Tools**
- Race Manager - Renamed to **Creator: Races**

**UI**
- MW HUD: Fixed that the "Split Time" notification did not fade out properly
- Carbon HUD: Fixed that the notifications did not fade out properly

**AI**
- Fixed that the AI did not always respect Nitrous settings (Circular Functions)

**Pursuit**
- Fixed roadblocks not always spawning properly, and sometimes didn't spawn with any Units
- Fixed that regular Units sometimes appeared in Rhino-only roadblocks
- Air Support now gets removed when despawning AI Units

And various other undocumented tweaks
]],
},

}