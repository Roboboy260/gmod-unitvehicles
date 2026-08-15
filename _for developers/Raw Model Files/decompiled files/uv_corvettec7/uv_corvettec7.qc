// Created by Crowbar 0.74

$modelname "unitvehiclescars\uv_corvettec7\uv_corvettec7.mdl"

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
$bodygroup "Fenders"
{
	studio "fenders.smd"
	studio "fenders_1.smd"
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
$bodygroup "Rear bumper"
{
	studio "rebumper.smd"
	studio "rebumper_1.smd"
}
$bodygroup "Trunk"
{
	studio "trunk.smd"
	studio "trunk_1.smd"
	studio "trunk_2.smd"
}
$bodygroup "Exhaust"
{
	studio "exhaust.smd"
	blank
}
$bodygroup "Brakelight"
{
	studio "brakelight.smd"
	studio "brakelight_1.smd"
}
$bodygroup "Headlight"
{
	studio "headlight.smd"
	studio "headlight_1.smd"
}
$bodygroup "Red"
{
	studio "red.smd"
	studio "redlit.smd"
}
$bodygroup "Blue"
{
	studio "Blue.smd"
	studio "Bluelit.smd"
}
$bodygroup "Driver"
{
	blank
	studio "driver.smd"
}
$bodygroup "Body"
{
	studio "body.smd"
}
$bodygroup "Police Siren"
{
	studio "policesiren.smd"
}
$bodygroup "Interior"
{
	studio "interior.smd"
}


$surfaceprop "metal"

$contents "solid"

$illumposition 0 0.248 24.646

$cdmaterials "models\unitvehiclescars\uv_corvettec7\"
$cdmaterials "models\unitvehiclescars\shared\"

$cbox 0 0 0 0 0 0

$bbox -100.438 -46.863 -0.409 99.943 46.863 49.554

$definebone "root" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"uv_corvettec7_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "uv_corvettec7_physics.smd"
{
	$mass 1555
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
