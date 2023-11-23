include <../box_for_2x18650_battery_holder_with_switch/box_for_2x18650_battery_holder_with_switch.scad>

makeTop = false;
makeBottom = false;

boxInsideZ = 25;

	display() flasherBoxBottom();
module flasherBoxBottom()
{
    boxBottom();
}

module flasherBoxTop()
{
    boxTop();
}

module clip(d=0)
{
    // tc([-200, boxOutsideY/2-d, -200], [400, 400, 400]);
    // rotate([0,0,45]) tcu([-200, 0, -200], 400);
    // tcu([batteryLeadsHoleX, -200, -200], 400);
    // tcu([batteryLeadsHoleX+5, -200, -200], 400);
}

if(developmentRender)
{
	display() flasherBoxBottom();
    // display() translate([0,0,0.1]) flasherBoxTop();
    // displayGhost() flasherBoxTop();
}
else
{
	if(makeTop) rotate([0,0,90]) rotate(180, [0,1,0]) translate([0,0,-boxOutsideZ]) boxTop();
    if(makeBottom) rotate([0,0,90]) boxBottom();
}