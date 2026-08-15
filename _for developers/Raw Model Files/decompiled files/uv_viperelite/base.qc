// Created by Crowbar 0.74

$modelname "base.mdl"

$bodygroup "base"
{
	studio "body.smd"
	studio "body1.smd"
}
$bodygroup "hood"
{
	studio "hood0.smd"
	studio "hood1.smd"
}
$bodygroup "fbumper"
{
	studio "fbumper0.smd"
	studio "fbumper1.smd"
}
$bodygroup "ldoor"
{
	studio "ldoor0.smd"
	studio "ldoor1.smd"
}
$bodygroup "rdoor"
{
	studio "rdoor0.smd"
	studio "rdoor1.smd"
}
$bodygroup "rbumper"
{
	studio "rbumper0.smd"
	studio "rbumper1.smd"
}
$bodygroup "boot"
{
	studio "boot0.smd"
	studio "boot1.smd"
}
$bodygroup "skirt"
{
	studio "skirts0.smd"
	studio "skirts1.smd"
}
$bodygroup "driver"
{
	blank
	studio "driver.smd"
}


$surfaceprop "metal"

$contents "solid"

$illumposition -0.011 1.85 25.242

$cdmaterials "models\unitvehiclescars\uv_viperelite\"

$cbox 0 0 0 0 0 0

$bbox -107.212 -49.63 -1.079 103.512 49.624 51.815

$definebone "root" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"base_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "base_physics.smd"
{
	$mass 1561
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
