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
            switchMountBody();
        }

        converterMountHoles();

        ledWireHole();

        switchMountCutout();
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

switchBodyX = 10.8;
switchBodyY = 5;

swtichFaceX = 20;
switchFaceY = 0.45;

switchBodyZ = 5.9;

switchSliderX = 7.7;
switchSliderY = 4.2;
switchSliderZ = 3.1;

switchOffsetZ = switchBodyZ + topLipZ;

module switchMountBody()
{
    translate([boxOutsideX/2, 0, boxBottomTopZ]) difference()
    {
        x = switchBodyX + 2;
        y = switchBodyY + switchSliderY;
        z = switchOffsetZ + 1;
        cxyz = y - boxWallXY;
        cxyz2 = 2 * cxyz;

        x1 = x + cxyz2;
        y1 = y; // No chamfer on Y.
        z1 = z + cxyz;

        tcu([-x1/2, 0, -z1], [x1, y1, z1]);

        // Trim a chamfer on the bottom:
        translate([0,0,-z1-boxWallXY]) rotate([45,0,0]) tcu([-50, -50, -100], 100);

        // Trim a chamfer on the sides:
        doubleX() translate([-x1/2-boxWallXY, 3, 0]) rotate([0,0,35]) tcu([-50, -0, -50], 100);

        // Trim the top to clear the box-cover:
        tcu([-50, -50, -topLipZ-0.1], 100);
    }
}

module switchMountCutout()
{
    translate([boxOutsideX/2, 0, boxBottomTopZ])
    {
        sliderCutoutOffsetZ = switchOffsetZ; // - switchSliderZ/2;
        // Cutout for the switch body, recessed so the slider is flush with the outside:
        tcu([-switchSliderX/2, -100+20, -sliderCutoutOffsetZ], [switchSliderX, 100, 100]);

        // Cutout for the switch-face:
        tcu([-swtichFaceX/2, switchSliderY, -sliderCutoutOffsetZ], [swtichFaceX, switchFaceY, 100]);

        // Cutout for the switch-slider:
        tcu([-switchBodyX/2, -100+switchSliderY, -sliderCutoutOffsetZ], [switchBodyX, 100, 100]);

        // Depression for better access to the slider:
        hull()
        {
            dx = 1.76;
            d = switchSliderZ + dx;
            // doubleX() tsp([switchSliderX/2,0,-switchOffsetZ + d/2], d=d);
            doubleX() translate([switchSliderX/2-d-1, switchSliderY-2, -switchOffsetZ + switchSliderZ/2]) 
                rotate([90,0,0]) 
                    cylinder(d2=d+20, d1=d, h=10);
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
    // rotate([0,0,45]) tcu([-200, 0-d, -200], 400);
    // tcu([batteryLeadsHoleX, -200, -200], 400+d);
    // tcu([batteryLeadsHoleX+5-d, -200, -200], 400);
    // tcu([-10, -10, 10-d], 400);
    // tcu([boxOutsideX-15.5-400, -200, -10], 400);
    // tcu([-10, 20, -10], 400);
    // tcu([boxOutsideX/2, -200, -10], 400);
    tcu([0-d, -200, -200], 400);
}

if(developmentRender)
{
    display() translate([-boxOutsideX/2,0,-boxBottomTopZ]) flasherBoxBottomWithBotomLeads();
    // displayGhost() translate([-boxOutsideX/2,0,-boxBottomTopZ]) flasherBoxTop();

	// display() translate([60,0,0]) flasherBoxBottomWithSideLeads();
    // display() translate([0,0,0.1]) flasherBoxTop();
    // displayGhost() flasherBoxTop();
}
else
{
	if(makeTop) rotate([0,0,90]) rotate(180, [0,1,0]) translate([0,0,-boxOutsideZ]) flasherBoxTop();
    if(makeBottomWithSideLeads) rotate([0,0,90]) flasherBoxBottomWithSideLeads();
    if(makeBottomWithBottomLeads) rotate([0,0,90]) flasherBoxBottomWithBotomLeads();
}