// Created by Crowbar 0.74

$modelname "unitvehiclescars\uv_coloradozr2\uv_coloradozr2.mdl"

$bodygroup "base"
{
	studio "base.smd"
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
}
$bodygroup "Rear bumper"
{
	studio "rebumper.smd"
	studio "rebumper_1.smd"
	studio "rebumper_2.smd"
	blank
}
$bodygroup "Exhaust"
{
	studio "exhaust.smd"
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
$bodygroup "Mirror left"
{
	studio "mirrorleft.smd"
	blank
}
$bodygroup "Mirror right"
{
	studio "mirrorright.smd"
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
$bodygroup "Brakelight"
{
	studio "brakelight.smd"
}
$bodygroup "Headlight"
{
	studio "headlight.smd"
}
$bodygroup "Skirts"
{
	studio "skirts.smd"
}
$bodygroup "Windows"
{
	studio "windows.smd"
}
$bodygroup "Police Siren"
{
	studio "policesiren.smd"
}
$bodygroup "Interior"
{
	studio "interior.smd"
}
$bodygroup "Driver"
{
	blank
	studio "driver.smd"
}


$surfaceprop "metal"

$contents "solid"

$illumposition 0 0.248 24.646

$cdmaterials "models\unitvehiclescars\uv_coloradozr2\"
$cdmaterials "models\unitvehiclescars\shared\"

$cbox 0 0 0 0 0 0

$bbox -100.438 -46.863 -0.409 99.943 46.863 49.554

$definebone "root" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"uv_coloradozr2_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "uv_coloradozr2_physics.smd"
{
	$mass 2273
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
