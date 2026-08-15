// Created by Crowbar 0.74

$modelname "unitvehiclescars\uv_corvettec7\uv_corvettec7_wheel.mdl"

$bodygroup "wheel"
{
	studio "wheel.smd"
}


$surfaceprop "rubbertire"

$contents "solid"

$illumposition -0.111 0 0

$cdmaterials "models\unitvehiclescars\uv_corvettec7\"
$cdmaterials "models\unitvehiclescars\shared\"

$cbox 0 0 0 0 0 0

$bbox -15.228 -8.138 -15.228 15.228 8.31 15.228

$definebone "root" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"uv_corvettec7_wheel_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "uv_corvettec7_wheel_physics.smd"
{
	$mass 15
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
