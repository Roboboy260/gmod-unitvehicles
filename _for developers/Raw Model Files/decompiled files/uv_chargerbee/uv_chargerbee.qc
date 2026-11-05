// Created by Crowbar 0.74

$modelname "unitvehiclescars\uv_chargerbee\uv_chargerbee.mdl"

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
$bodygroup "Rear bumper"
{
	studio "rebumper.smd"
	studio "rebumper_1.smd"
	studio "rebumper_2.smd"
	blank
}
$bodygroup "Fender left"
{
	studio "fenderleft.smd"
	studio "fenderleft_1.smd"
	studio "fenderleft_2.smd"
}
$bodygroup "Fender right"
{
	studio "fenderright.smd"
	studio "fenderright_1.smd"
	studio "fenderright_2.smd"
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
$bodygroup "Rear door left"
{
	studio "redoorleft.smd"
	studio "redoorleft_1.smd"
	studio "redoorleft_2.smd"
}
$bodygroup "Rear door right"
{
	studio "redoorright.smd"
	studio "redoorright_1.smd"
	studio "redoorright_2.smd"
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
$bodygroup "Exhaust1"
{
	studio "exhaust_1.smd"
	blank
}
$bodygroup "Brakelight"
{
	studio "brakelight.smd"
	studio "brakelight_1.smd"
}
$bodygroup "Lit"
{
	studio "lit.smd"
	studio "lit_1.smd"
}
$bodygroup "Lit full"
{
	studio "litfull.smd"
	studio "litfull_1.smd"
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
$bodygroup "Headlight"
{
	studio "headlight.smd"
}
$bodygroup "Body"
{
	studio "body.smd"
}
$bodygroup "Skirts"
{
	studio "skirts.smd"
}
$bodygroup "Skirts"
{
	studio "skirts.smd"
}
$bodygroup "Police Siren"
{
	studio "policesiren.smd"
}


$surfaceprop "metal"

$contents "solid"

$illumposition 0 0.248 24.646

$cdmaterials "models\unitvehiclescars\uv_chargerbee\"
$cdmaterials "models\unitvehiclescars\shared\"

$cbox 0 0 0 0 0 0

$bbox -100.438 -46.863 -0.409 99.943 46.863 49.554

$definebone "root" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "steering_wheel" "root" 19.9163 17.934299 33.308498 0 0 0 0 0 0 0 0 0


$poseparameter "vehicle_steer" -1 1 loop 0

$weightlist "weights_turning" {
	 "root" 1
	 "steering_wheel" 2
}

$animation "left_corrective_animation" "uv_chargerbee_anims\left_corrective_animation.smd" {
	fps 30
}

$animation "mid_corrective_animation" "uv_chargerbee_anims\mid_corrective_animation.smd" {
	fps 30
}

$animation "right_corrective_animation" "uv_chargerbee_anims\right_corrective_animation.smd" {
	fps 30
}

$animation "neutral" "uv_chargerbee_anims\neutral.smd" {
	fps 30
}

$animation "left" "uv_chargerbee_anims\left.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "left_corrective_animation" 0
	weightlist "weights_turning"
}

$animation "mid" "uv_chargerbee_anims\mid.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "mid_corrective_animation" 0
	weightlist "weights_turning"
}

$animation "right" "uv_chargerbee_anims\right.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "right_corrective_animation" 0
	weightlist "weights_turning"
}

$sequence "turning" {
	"left"
	"mid"
	"right"
	autoplay
	blend "vehicle_steer" -1 1
	blendwidth 3
	delta
	fadein 0.2
	fadeout 0.2
}

$sequence "idle" {
	"uv_chargerbee_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "uv_chargerbee_physics.smd"
{
	$mass 1887
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
