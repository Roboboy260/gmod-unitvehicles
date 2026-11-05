// Created by Crowbar 0.74

$modelname "unitvehiclescars\uv_chargerbee\uv_chargerbee_wheel.mdl"

$bodygroup "wheel"
{
	studio "wheel.smd"
}


$surfaceprop "rubbertire"

$contents "solid"

$illumposition 0.062 0 0

$cdmaterials "models\unitvehiclescars\uv_chargerbee\"
$cdmaterials "models\unitvehiclescars\shared\"

$cbox 0 0 0 0 0 0

$bbox -14.428 -7.717 -14.428 14.428 7.88 14.428

$definebone "root" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"uv_chargerbee_wheel_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "uv_chargerbee_wheel_physics.smd"
{
	$mass 15
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
