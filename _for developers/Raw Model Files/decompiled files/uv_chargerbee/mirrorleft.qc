// Created by Crowbar 0.74

$modelname "unitvehiclescars\uv_chargerbee\mirrorleft.mdl"

$bodygroup "Mirror left"
{
	studio "mirrorleft.smd"
}


$surfaceprop "metal"

$contents "solid"

$illumposition 0 0.248 24.646

$cdmaterials "models\unitvehiclescars\uv_chargerbee\"
$cdmaterials "models\unitvehiclescars\shared\"

$cbox 0 0 0 0 0 0

$bbox -100.438 -46.863 -0.409 99.943 46.863 49.554

$definebone "root" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"mirrorleft_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "mirrorleft_physics.smd"
{
	$mass 5
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
