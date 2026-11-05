// Created by Crowbar 0.74

$modelname "unitvehiclescars\uv_rhinotruck\uv_rhinotruck.mdl"

$bodygroup "base"
{
	studio "base.smd"
}
$bodygroup "Front bumper"
{
	studio "frbumper.smd"
	studio "frbumper_1.smd"
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
$bodygroup "Driver"
{
	blank
	studio "driver.smd"
}
$bodygroup "Rear bumper"
{
	studio "rebumper.smd"
}
$bodygroup "body"
{
	studio "body.smd"
}
$bodygroup "windows"
{
	studio "windows.smd"
}
$bodygroup "brakelights"
{
	studio "brakelights.smd"
}
$bodygroup "headlights"
{
	studio "headlights.smd"
}
$bodygroup "doorleft"
{
	studio "doorleft.smd"
}
$bodygroup "doorright"
{
	studio "doorright.smd"
}
$bodygroup "police siren"
{
	studio "policelights.smd"
}


$surfaceprop "metal"

$contents "solid"

$illumposition 0 0.248 24.646

$cdmaterials "models\unitvehiclescars\uv_rhinotruck\"
$cdmaterials "models\unitvehiclescars\shared\"

$cbox 0 0 0 0 0 0

$bbox -100.438 -46.863 -0.409 99.943 46.863 49.554

$definebone "root" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"uv_rhinotruck_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "uv_rhinotruck_physics.smd"
{
	$mass 2273
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
