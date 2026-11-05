// Created by Crowbar 0.74

$modelname "unitvehiclescars\uv_rhinotruck\uv_rhinotruck_wheel.mdl"

$bodygroup "wheel"
{
	studio "wheel.smd"
}


$surfaceprop "rubbertire"

$contents "solid"

$illumposition 0.208 0 0

$cdmaterials "models\unitvehiclescars\uv_rhinotruck\"
$cdmaterials "models\unitvehiclescars\shared\"

$cbox 0 0 0 0 0 0

$bbox -14.792 -7.908 -14.792 14.792 8.075 14.792

$definebone "root" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"uv_rhinotruck_wheel_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "uv_rhinotruck_wheel_physics.smd"
{
	$mass 15
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
