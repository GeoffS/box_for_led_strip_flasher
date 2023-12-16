makeTop = false;
makeBottomWithSideLeads = false;
makeBottomWithBottomLeads = false;

screwExtendingBelowConverterBoard = 5.5;
bottomOfScrewHoleZ = 1;
boardPostZ = screwExtendingBelowConverterBoard + bottomOfScrewHoleZ;

clearanceAboveBoard = 17;

// Needs to be included here (instead of at the top) because boxInsideZ is declared in there.
include <../box_for_2x18650_battery_holder_with_switch/box_for_2x18650_battery_holder_with_switch.scad>

boxInsideZ = boardPostZ + clearanceAboveBoard;

module basicFlasherBoxBottom()
{
    difference()
    {
        union()
        {
            basicBoxBottom();
            ledWireSupport();
            converterMount();
        }

        converterMountHoles();

        ledWireHole();
    }
}

module flasherBoxBottomWithSideLeads()
{
    difference()
    {
        basicFlasherBoxBottom();
        sideBatteryLeadsHole();
    }
}

module flasherBoxBottomWithBotomLeads()
{
    difference()
    {
        basicFlasherBoxBottom();
        bottomBatteryLeadsHole();
    }
}

cmX1 = boxWallXY + 6.5;
cmY1 = boxOutsideY - boxWallXY - 15;
converterMount1 = [cmX1+15.8, cmY1];
converterMount2 = [cmX1, cmY1-31.1];

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

// // Just shrink tube:
// ledStripWireZ = 2.1 + 0.62;
// ledStripWireX = 4 + 0.77;
// ledWireSupportDia = 10;
// ledWireSupportZ = 10;

// 3mm Dyneema sheath:
ledStripWireZ = 3.4;
ledStripWireX = 5.2;
ledWireSupportDia = 11;
ledWireSupportZ = 11;

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
    d=ledWireSupportDia;
    wireTieWidth = 4;
    tcy([boxOutsideX/2, boxWallXY + d/2 + wireTieWidth, 0], d=d, h=boxWallZ+ledWireSupportZ);
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
    // tcu([boxOutsideX-15.5-400, -200, -10], 400);
    // tcu([-10, 20, -10], 400);
}

if(developmentRender)
{
    display() flasherBoxBottomWithBotomLeads();
	display() translate([60,0,0]) flasherBoxBottomWithSideLeads();
    // display() translate([0,0,0.1]) flasherBoxTop();
    // displayGhost() flasherBoxTop();
}
else
{
	if(makeTop) rotate([0,0,90]) rotate(180, [0,1,0]) translate([0,0,-boxOutsideZ]) flasherBoxTop();
    if(makeBottomWithSideLeads) rotate([0,0,90]) flasherBoxBottomWithSideLeads();
    if(makeBottomWithBottomLeads) rotate([0,0,90]) flasherBoxBottomWithBotomLeads();
}