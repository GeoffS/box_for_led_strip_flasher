makeTop = false;
makeBottom = false;

screwExtendingBelowConverterBoard = 5.5;
bottomOfScrewHoleZ = 1;
boardPostZ = screwExtendingBelowConverterBoard + bottomOfScrewHoleZ;

clearanceAboveBoard = 17;

// Needs to be included here (instead of at the top) because boxInsideZ is declared in there.
include <../box_for_2x18650_battery_holder_with_switch/box_for_2x18650_battery_holder_with_switch.scad>

boxInsideZ = boardPostZ + clearanceAboveBoard;

module flasherBoxBottom()
{
    difference()
    {
        union()
        {
            boxBottom();
            ledWireSupport();
            converterMount();
        }

        converterMountHoles();

        ledWireHole();
    }
}

cmX1 = boxWallXY + 6.5;
cmY1 = 65; //boxOutsideY-boxWallXY - 6;
converterMount1 = [cmX1, cmY1];
converterMount2 = [cmX1+15.8, cmY1-31.1];

module converterMount()
{
    converterPost(converterMount1);
    converterPost(converterMount2);
}

module converterMountHoles()
{
    converterMountHole(converterMount1);
    converterMountHole(converterMount2);
}

module converterMountHole(p)
{
    tcy([p.x, p.y, bottomOfScrewHoleZ], d=2.5, h=20);
}

module converterPost(p)
{
    translate([p.x, p.y, 0])
    {
        difference()
        {
            union()
            {
                d = 4;
                cylinder(d=d, h=boardPostZ);
                cylinder(d1=10, d2=d, h=boardPostZ - 0.5);
            }
            
        }
    }
}

ledStripWireZ = 2.1;
ledStripWireX = 4;
module ledWireHole()
{
    translate([boxOutsideX/2, 0, 10]) rotate([90,0,0]) 
    {
        dx = ledStripWireX/2 - ledStripWireZ/2;

        hull()
        {
            ledWireHalfHole( dx);
            ledWireHalfHole(-dx);
        }
        translate([0,0,-5]) hull()
        {
            ledWireHalfHole( dx, dd=0.5);
            ledWireHalfHole(-dx, dd=0.5);
        }
        hull()
        {
            ledWireHalfChamfer( dx);
            ledWireHalfChamfer(-dx);
        }
    }
}

module ledWireHalfHole(dx, dd=0)
{
    tcy([dx, 0 ,-40+1], d=ledStripWireZ+dd, h=40);
}

module ledWireHalfChamfer(dx)
{
    translate([dx, 0, -ledStripWireZ/2-boxWallXY/2]) cylinder(d2=10, d1=0, h=5);
}

module ledWireSupport()
{
    d=8;
    wireTieWidth = 4;
    tcy([boxOutsideX/2, boxWallXY + d/2 + wireTieWidth, 0], d=d, h=boxWallZ+10);
}

module flasherBoxTop()
{
    boxTop();
}

module clip(d=0)
{
    // tc([-200, boxOutsideY/2-d, -200], [400, 400, 400]);
    // rotate([0,0,45]) tcu([-200, 0-d, -200], 400);
    // tcu([batteryLeadsHoleX, -200, -200], 400+d);
    // tcu([batteryLeadsHoleX+5-d, -200, -200], 400);
    // tcu([-10, -10, 10-d], 400);
}

if(developmentRender)
{
	display() flasherBoxBottom();
    // display() translate([0,0,0.1]) flasherBoxTop();
    // displayGhost() flasherBoxTop();
}
else
{
	if(makeTop) rotate([0,0,90]) rotate(180, [0,1,0]) translate([0,0,-boxOutsideZ]) flasherBoxTop();
    if(makeBottom) rotate([0,0,90]) flasherBoxBottom();
}