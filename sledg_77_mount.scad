$fn=100;

// Lock wedge holder
module lock_wedge(length, width, height, cutout_width, cutout_length) {
    edge_radius=2.5;
    difference() {
        linear_extrude(width) {
            offset(r=edge_radius) {
                polygon([[0,0], [length,0], [length, height], [0,0]]);
            }
        }
        translate([length-cutout_length+(cutout_width/2), -edge_radius, width/2]) 
            rotate([-90,0,0]) 
            union() {
                cylinder(d=cutout_width,h=height+2*edge_radius);
                translate([0,-(cutout_width/2),0]) 
                    cube([cutout_length+edge_radius, cutout_width, height+(edge_radius*2)]);
            }
    }
}


difference() {
    linear_extrude(6) {
        offset(r=2.5) {
            square([60,26]);
        }
    }
    translate([30, 10+(20/2)+3, 0]) cylinder(d=4.2, h=8);
    translate([30, 10-(20/2)+3, 0]) cylinder(d=4.2, h=8);
    translate([30, 10+(20/2)+3, 3]) cylinder(d=8, h=3);
    translate([30, 10-(20/2)+3, 3]) cylinder(d=8, h=3);
}
translate([0, 10, 6]) lock_wedge(60, 37, 9, 20, 20);
