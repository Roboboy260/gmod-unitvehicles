// Created by Crowbar 0.74

$modelname "unitvehiclescars\uv_fordexplorer\uv_fordexplorer.mdl"

$bodygroup "body"
{
	studio "body.smd"
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
$bodygroup "Left door"
{
	studio "leftdoor.smd"
	studio "leftdoor_1.smd"
}
$bodygroup "Rear left door"
{
	studio "releftdoor.smd"
	studio "releftdoor_1.smd"
}
$bodygroup "Right door"
{
	studio "rightdoor.smd"
	studio "rightdoor_1.smd"
}
$bodygroup "Rear door right"
{
	studio "redoorright.smd"
	studio "redoorright_1.smd"
}
$bodygroup "Trunk"
{
	studio "trunk.smd"
	studio "trunk_1.smd"
	studio "trunk_2.smd"
	blank
}
$bodygroup "Rear bumper"
{
	studio "rebumper.smd"
	studio "rebumper_1.smd"
	studio "rebumper_2.smd"
	blank
}
$bodygroup "Red"
{
	studio "red.smd"
	studio "redlit.smd"
}
$bodygroup "Blue"
{
	studio "blue.smd"
	studio "bluelit.smd"
}
$bodygroup "Driver"
{
	blank
	studio "driver.smd"
}
$bodygroup "Headlight"
{
	studio "headlight.smd"
}
$bodygroup "Brakelight"
{
	studio "brakelight.smd"
}
$bodygroup "Window"
{
	studio "window.smd"
}
$bodygroup "Police siren"
{
	studio "policesiren.smd"
}
$bodygroup "Window"
{
	studio "window_2.smd"
}


$surfaceprop "metal"

$contents "solid"

$illumposition 0 0.248 24.646

$cdmaterials "models\unitvehiclescars\uv_fordexplorer\"
$cdmaterials "models\unitvehiclescars\shared\"

$cbox 0 0 0 0 0 0

$bbox -100.438 -46.863 -0.409 99.943 46.863 49.554

$definebone "root" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"uv_fordexplorer_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "uv_fordexplorer_physics.smd"
{
	$mass 2067
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
