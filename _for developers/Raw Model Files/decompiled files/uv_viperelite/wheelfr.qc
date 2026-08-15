// Created by Crowbar 0.74

$modelname "wheelfr.mdl"

$bodygroup "base"
{
	studio "wheelfr.smd"
}


$surfaceprop "rubbertire"

$contents "solid"

$illumposition 0 -0.274 0.011

$cdmaterials "mokanfsw\viperelite\"
$cdmaterials "mokanfsw\universal\"

$cbox 0 0 0 0 0 0

$bbox -6.968 -12.913 -12.835 7.522 12.912 12.857

$definebone "root" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"wheelfr_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "wheelfr_physics.smd"
{
	$mass 1
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
