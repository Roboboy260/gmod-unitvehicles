// Created by Crowbar 0.74

$modelname "unitvehiclescars\uv_fordcrownvic\uv_fordcrownvic.mdl"

$bodygroup "base"
{
	studio "base.smd"
}
$bodygroup "Driver"
{
	blank
	studio "driver.smd"
}
$bodygroup "Front bumper"
{
	studio "frbumper.smd"
	studio "frbumper_1.smd"
	studio "frbumper_2.smd"
	blank
}
$bodygroup "Hood"
{
	studio "hood.smd"
	studio "hood_1.smd"
	studio "hood_2.smd"
	blank
}
$bodygroup "Door left"
{
	studio "doorleft.smd"
	studio "doorleft_1.smd"
	studio "doorleft_2.smd"
}
$bodygroup "Door right"
{
	studio "doorright.smd"
	studio "doorright_1.smd"
	studio "doorright_2.smd"
}
$bodygroup "Rear Door left"
{
	studio "redoorleft.smd"
	studio "redoorleft_1.smd"
	studio "redoorleft_2.smd"
}
$bodygroup "Rear Door right"
{
	studio "redoorright.smd"
	studio "redoorright_1.smd"
	studio "redoorright_2.smd"
}
$bodygroup "Rear bumper"
{
	studio "rebumper.smd"
	studio "rebumper_1.smd"
	studio "rebumper_2.smd"
	blank
}
$bodygroup "Trunk"
{
	studio "trunk.smd"
	studio "trunk_1.smd"
	studio "trunk_2.smd"
	blank
}
$bodygroup "Police Siren"
{
	studio "policesiren.smd"
	blank
}
$bodygroup "Blue"
{
	studio "blue.smd"
	studio "bluelit.smd"
}
$bodygroup "Red"
{
	studio "red.smd"
	studio "redlit.smd"
}
$bodygroup "Police Siren"
{
	studio "policesiren.smd"
}
$bodygroup "Brakelight"
{
	studio "brakelight.smd"
}
$bodygroup "Headlights"
{
	studio "headlights.smd"
}


$surfaceprop "metal"

$contents "solid"

$illumposition 0 0.248 24.646

$cdmaterials "models\unitvehiclescars\uv_fordcrownvic\"
$cdmaterials "models\unitvehiclescars\shared\"

$cbox 0 0 0 0 0 0

$bbox -100.438 -46.863 -0.409 99.943 46.863 49.554

$definebone "root" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"uv_fordcrownvic_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "uv_fordcrownvic_physics.smd"
{
	$mass 1850
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
