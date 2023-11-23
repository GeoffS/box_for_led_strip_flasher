include <../box_for_2x18650_battery_holder_with_switch/box_for_2x18650_battery_holder_with_switch.scad>

makeTop = false;
makeBottom = false;

boxInsideZ = 25;

	display() flasherBoxBottom();
module flasherBoxBottom()
{
    difference()
    {
        boxBottom();

        // Hole for wires to led strip:
        translate([boxOutsideX/2, boxWallXY/2, 10]) rotate([90,0,0]) hull()
        {
            ledStripWireZ = 1.7;
            ledStripWireX = 3.6;

            dx = ledStripWireX/2 - ledStripWireZ/2;
            tcy([ dx,0,-10], d=1.7, h=20);
            tcy([-dx,0,-10], d=ledStripWireZ, h=20);
        }
    }
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