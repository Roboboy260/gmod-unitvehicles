- Extract and place this under sound/chatter2
- Rename and/or duplicate 'example_pd' folder if you like
- You can also rename and/or duplicate 'airunit' and 'groundunit' folders if you like for added variety
- 'dispatch' and 'misc' folders are already handled by the chatter system, DO NOT RENAME/DUPLICATE THEM
- Example lines shown below are just generic. Be creative when recording new chatter lines. Use your vocabulary! :)

--- DISPATCH ---

*no voice restriction, so it's not just dispatch themself who is talking ... could be roadblock/support units

*during a call, these folders will play in order: 
addressgroup > dispatchcalldamagetoproperty/dispatchcallhitandrun/dispatchcallspeeding/dispatchcallstreetracing > d_location > unitrequest

*when cooldown starts, these folders will play in order: 
dispbreakaway > d_location > quadrant

addressgroup = "Attention all Units ..."
addressgroup_map
    - *name of the map* = "Attention all Units in *name of the map* ..."
airinitalize = "Air Unit has been deployed"
arrestacknowledge = "Copy that, suspect is in custody"
backuponscene = "Backup is on scene"
backupontheway = "Backup is on its way"
callrequestdescription = "Do you have the make and model of the suspect's vehicle?"
d_location = "... near the *location* ..."
denybackup = "Unable to send out backup units, hold on... / We are still working on your backup"
dispatchacknowledgerequest = "Roger that"
dispatchcalldamagetoproperty = "... we got reports of a driver doing a lot of damage, they were last seen ..."
dispatchcallhitandrun = "... we got reports of a hit and run driver, they were last seen ..."
dispatchcallspeeding = "... we got reports of a speeding driver, they were last seen ..."
dispatchcallstreetracing = "... we got reports of a group of street racers, they were last seen ..."
dispatchcallunknowndescription = "Caller did not get a good look at the vehicle, standby"
dispatchcallvehicledescription = (TO BE IMPLEMENTED WITH UVGetVehicleMakeAndModel SCRIPT)
dispatchdenyrequest = "Negative"
dispatchidletalk = *random conversation between dispatch and unit*
dispatchjammerend = "All radio communications restored, resume call on Channel *number*"
dispatchmultipleunitsdownacknowledge = "Roger that, EMS are on their way"
dispbreakaway = "All Units, suspect was last seen ..."
heat2 = "Condition 2"
heat3 = "Condition 3"
heat4 = "Condition 4"
heat5 = "Condition 5/Special Units taking over the pursuit soon"
heat5reassure = "Not much I can do"
heat6 = "Condition 6"
heat7 = "Condition 7"
heat8 = "Condition 8"
heat9 = "Condition 9"
heat10 = "CONDITION 10"
idletalk = *random conversation between Units*
losingupdate = "We got a possible match"
lost = "Dispatch, we should clear this call"
lostacknowledge = "All Units, clear this call and resume patrols"
pursuitbreaker = "Units reporting suspect has hit a structure, watch for debris"
pursuitbreakergas = "Units reporting suspect has hit the gas pumps"
pursuitstartacknowledge = "All Units, we got a pursuit in progress"
pursuitstartacknowledgehigh = "All Units, we have found our Most Wanted suspect"
pursuitstartacknowledgemed = "All Units, we have found a high-risk street racer"
pursuitstartacknowledgemultipleenemies = "Be advised, Units are in pursuit of multiple vehicles"
quadrant = "... quadrant to be set up near their last known location"
requestsitrep = "Units on pursuit, please update status" 
responding = "Unit here, show me responding to the pursuit"
roadblockdeployed = "Roadblock deployed"
roadblockhit = "Suspect has hit the roadblock"
roadblockmissed = "Suspect has gone around the roadblock"
spikestriphit = "Suspect hit the spikes"
unitrequest = "... I need Units to respond"
vehicledescription = 
    - *name of the brand*
        - default = "Suspect is in a *name of the brand*."
        - *color* = "Suspect is in a *color* *name of the brand*."
    - policecar
        - default = "Suspect is in a police car."

--- AIR UNIT ---

acknowledgegeneral = "Roger that"
aggressive = "We are going to engage the suspect"
arrest = "Suspect is in custody"
backuponscene = "We got visual on the backup"
badweather = "We got bad weather"
bullhorn
    - arrest = "GET OUT OF THE CAR!"
    - closetoenemy = "PULL OVER!"
bustevaded = "Negative on the arrest, suspect is still moving"
bustevadedupdate = "How can we get this suspect stopped?"
busting = "Box them in"
callrequestdescription = "Do you have the make and model of the suspect's vehicle?"
damagedcheckin = "Are you guys ok?"
denybackupacknowledge = "(Insisting further on backup): We need to get that backup now or we are losing him!"
denyrequest = "Negative"
disengaging = "We are disengaging from the pursuit"
enemycrashed = "Suspect has crashed"
foundenemy = "We found the suspect"
foundmultipleenemies = "We got multiple suspects"
headingeast = "Suspect is heading east"
headingnorth = "Suspect is heading north"
headingsouth = "Suspect is heading south"
headingwest = "Suspect is heading west"
heat2 = "Condition 2"
heat3 = "Condition 3"
heat4 = "Condition 4"
heat5 = "Condition 5/Special Units taking over the pursuit soon"
heat6 = "Condition 6"
heat7 = "Condition 7"
heat8 = "Condition 8"
heat9 = "Condition 9"
heat10 = "CONDITION 10"
hit = "We got hit"
hitptemp = "We got hit by EMP, disengaging"
hittraffic = "Suspect has hit traffic"
identify = "Air Unit 1"
initialize = "We are lifting off"
losing = "We have lost the suspect, trying to regain visual"
lost = "We lost the suspect, unable to locate again, suggest to call off pursuit or request a follow-up from dispatch"
losingupdate = "We got a possible match"
lowonfuel = "We are low on fuel, leaving the pursuit"
multipleunitsdown = "We got multiple Units down, send EMS"
onscene = "We are on scene"
passive = "I'm pulling back, following the suspect for now"
ptexplosivebarreldeployed = "Explosive barrels deployed"
ptexplosivebarrelhit = "Explosive barrels hit"
ptexplosivebarrelmissed = "Explosive barrels missed"
ptskyhammerhit = "Skyhammer successful"
ptskyhammermissed = "Skyhammer unsuccessful"
ptskyhammerstart = "Starting Skyhammer"
ptspikestripdeployed = "Spikes strip deployed"
ptspikestriphit = "Spikes strip hit"
pursuitbreaker = "Suspect has hit a structure, watch for debris"
pursuitbreakergas = "Suspect has hit the gas pumps"
rammedenemy = "We rammed the suspect"
requestbackup = "Requesting backup"
requestdisengage = "Requesting permission to disengage"
roadblockdeployed = "Roadblock deployed"
roadblockmissed = "Suspect has gone around the roadblock"
sitrep = "Suspect still failing to stop"
spottedenemy = "Suspect in sight, in pursuit"
stuntjump = "Suspect made a jump"
stuntroll = "Suspect went upside down"
stuntspin = "Suspect spun out"
wreck = "Mayday, losing control"

--- GROUND UNIT ---

*inperson has no filter

acknowledgegeneral = "Roger that"
aggressive = "I am going to engage the suspect"
airdown = "Air Unit is down!"
arrest = "Suspect is in custody"
badweather = "We got bad weather"
bullhorn
    - arrest = "GET OUT OF THE CAR!"
    - closetoenemy = "PULL OVER!"
    - finearrest = "YOU ARE UNDER ARREST!" - suspect gets cited too many times
    - finepaid = "Fine paid, you are gree to go."
bustevaded = "Negative on the arrest, suspect is still moving"
busting = "Box them in"
callrequestdescription = "Do you have the make and model of the suspect's vehicle? / details on the call"
callresponding = "Responding to the call"
closetoenemy = "Gonna try a tactic against the suspect"
damaged = "My vehicle is damaged, can't last for much longer"
damagedcheckin = "Are you guys ok?"
denyrequest = "Negative"
denybackupacknowledge = "(Response to dispatch denying backup): We need to get that backup now or we are losing him!"
donotdisengage = "Do not disengage, remain in pursuit"
enemycrashed = "Suspect has crashed"
foundenemy = "I found the suspect"
foundmultipleenemies = "I got multiple suspects"
headingeast = "Suspect is heading east"
headingnorth = "Suspect is heading north"
headingsouth = "Suspect is heading south"
headingwest = "Suspect is heading west"
- OPTIONAL, works for all heats, usually made for heat5
heatXacknowledge = "Roger that, we will let those guys take over the pursuit"
heatXargue = "Don't let them take over, we got this under control"
-
heat2 = "Condition 2"
heat3 = "Condition 3"
heat4 = "Condition 4"
heat5 = "Condition 5"
heat6 = "Condition 6"
heat7 = "Condition 7"
heat8 = "Condition 8"
heat9 = "Condition 9"
heat10 = "CONDITION 10"
hittraffic = "Suspect has hit traffic"
hittrafficsemi = "Suspect has hit a semi truck"
identify = "Unit 1, X-Ray 2, Yankee 5 (generic, you can come up with your own "identification" callsigns)"
    - *name of Unit class* = "*name of Unit class* (ex. This is Interceptor Unit)"
inperson
    - finearrest = "YOU ARE UNDER ARREST!"
    - finepaid = "DRIVE CAREFULLY!"
leftpursuit = "I have fallen behind, leaving the pursuit"
losing = "I have lost the suspect, trying to regain visual"
lost = "We lost the suspect, unable to locate again, suggest to call off pursuit or request a follow-up from dispatch"
multipleunitsdown = "We got multiple Units down, send EMS"
onscene = "On scene"
passive = "I'm pulling back, following the suspect for now"
ptemphit = "EMP hit"
ptempmissed = "EMP missed"
ptempstart = "Starting EMP"
ptesfdeployed = "ESF deployed"
ptesfhit = "ESF hit"
ptesfmissed = "ESF missed"
ptgpsdartdeployed = "GPS dart deployed"
ptgpsdarthit = "GPS dart hit"
ptgpsdartmissed = "GPS dart missed"
ptgpsdartdeployed = "Grappler deployed"
ptgpsdarthit = "Grappler hit"
ptgpsdartmissed = "Grappler missed"
ptkillswitchhit = "Suspect has been killswitched"
ptkillswitchmissed = "Killswitch unsuccessful"
ptkillswitchstart = "Killswitching suspect vehicle"
ptrepairkitdeployed = "Repair kit deployed"
ptshockramdeployed = "Shock ram deployed"
ptshockramhit = "Shock ram hit"
ptshockrammissed = "Shock ram missed"
ptspikestripdeployed = "Spikes strip deployed"
ptspikestriphit = "Spikes strip hit"
ptspikestripmissed = "Spikes strip missed"
pursuitbreaker = "Suspect has hit a structure, watch for debris"
pursuitstartranaway = "Suspect took off, starting pursuit"
pursuitstartwanted = "Wanted suspect found, starting pursuit"
rammed = "I got hit by the suspect"
rammedenemy = "I hit the suspect"
rammedfront = "Took a head-on collision"
rammedrear = "I got hit from behind"
rammedside = "I got T-boned"
requestbackup = "Requesting backup"
requestdisengage = "Requesting permission to disengage"
responding = "Responding to the pursuit"
rhinohit = "This is Rhino Unit, hit successful"
rhinomiss = "This is Rhino Unit, hit unsuccessful"
roadblockdeployed = "Roadblock deployed"
roadblockhit = "Suspect has hit the roadblock"
roadblockmissed = "Suspect has gone around the roadblock"
sitrep = "Suspect still failing to stop"
stuntjump = "Suspect made a jump"
stuntroll = "Suspect went upside down"
stuntspin = "Suspect spun out / did 180"
trafficstoprammed = "Pulling over a vehicle that just hit me"
trafficstopspeeding = "Pulling over a speeding vehicle"
vehicledescription = 
    - *name of the brand*
        - default = "Suspect is in a *name of the brand*."
        - *color* = "Suspect is in a *color* *name of the brand*."
    - policecar
        - default = "Suspect is in a police car."
wreck = "I got taken out"

--- MISC ---

chirpgeneric = *beep*
emergency = *beep boop*
radiooff = After talking
radioon = Before talking
static = When Unit gets taken out

--- RADIO CODES ---

TEN-CODE
10-1: Receiving poorly
10-2: Receiving well
10-3: Stop transmitting
10-4: Message received and understood
10-5: Relay message
10-6: Responding from a distance
10-7: Detailed, out of service
10-8: In service
10-9: Repeat message
10-10: Negative, standing by
10-11: Talking too rapidly
10-12: Visitors present
10-13: Advise weather/road conditions
10-16: Urgent pickup at location
10-17: Urgent business
10-18: Anything for us?
10-19: Nothing for you, return to base
10-20: Current location
10-21: Call by landline
10-22: Report in person to
10-23: On scene
10-24: Completed last assignment
10-25: Out of service
10-26: Going for fuel
10-27: Moving to different radio channel
10-28: Identify your station
10-29: Run for wants and warrants
10-32: Wanted suspect
10-33: Officer needs help
10-34: Requesting Pursuit/Interceptor unit
10-35: Confidential information
10-36: Police unit traffic collision
10-37: Requesting tow truck
10-38: Requesting ambulance
10-39: PIT maneuver
10-41: Self PIT
10-42: Traffic accident
10-43: Traffic jam
10-44: Requesting Special/Commander unit
10-45: Ramming suspect
10-50: Hit & Run
10-59: Herding
10-60: What is next message number?
10-62: Unable to copy, use landline
10-63: Offset
10-65: Vehicle box
10-67: Spike strip
10-70: Requesting fire department
10-71: Requesting Air unit
10-73: Roadblock
10-75: Rolling roadblock
10-77: Negative contact
10-81: Speed Trap location
10-82: Rolling chicane
10-83: Set up quadrant
10-85: Backup
10-87: Vehicle/suspect pursuit
10-90: Smoke screen
10-93: Check my frequency on this channel
10-96: Traffic stop
10-100: 5-minute break

UNIT REQUEST CODES
Air Support: Police Helicopter (Air Unit)

PURSUIT STAGE CODES
Code 1: Situation under control
Code 2: ASAP, no lights or sirens(on)
Code 3: Emergency, lights and sirens(on)
Code 4: Suspect under arrest
Code 5: More units needed
Code 6: High-risk racer
Code 7: Change in Condition
Code 8: Suspect found
Code 10: Confidential information

PURSUIT CONDITIONS
Condition 1: Heat level 1
Condition 2: Heat level 2
Condition 3: Heat level 3
Condition 4: Heat level 4
Condition 5: Heat level 5
Condition 6: Heat level 6
Condition 7: Heat level 7
Condition 8: Heat level 8
Condition 9: Heat level 9
Condition 10: Heat level 10

OTHER CODES
28/29: Run suspect for wants/warrants
51-50: Possible mental disorder
"Positive hit": Ran suspect has a criminal record
APB: All-points bulletin
ACCI: Accident investigator
ASAP: As soon as possible
Assault PO: Assault on a police officer
DUI: Driving under the influence
EMS: Emergency medical services
ETA: Estimated time of arrival
GD: General duty
HAZMAT: Hazardous materials unit
HVT: High value target
KS: Kill switch
MHA: Mental Health Act
MVA: Motor vehicle accident
NCIC: National Criminal Information Center
PC: Police car/cruiser
PDT: Portable data transmitter/terminal
PID: Positive identification
Primary: Unit behind suspect
RTB: Return to base
Secondary: Unit behind primary
TAC: Tactical radio channel
TC: Traffic collision
VCB: Visual contact broken
Wrecker: Tow truck