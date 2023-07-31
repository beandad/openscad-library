$fn=100;

// Bar Clamp (Large)
module bar_clamp(inner_diam, thickness, length, bolt_diam, nut_diam) {
    outer_diam = inner_diam + 2*thickness;
    clamp_outer_length = outer_diam + 2 * (nut_diam + 2);
    bolt_dist_from_center = outer_diam/2 + (clamp_outer_length - outer_diam)/4;
    bolt_dist_from_bottom_edge = length/4;
    bolt_dist_from_top_edge = length - (length/4);
    difference() {
        union() {
            cylinder(d=outer_diam, h=length);
            translate([-(clamp_outer_length/2), -thickness, 0]) cube([clamp_outer_length, thickness*2, length]);
        }
        union() {
            cylinder(d=inner_diam, h=length);
            translate([-(clamp_outer_length/2), -0.5, 0]) cube([clamp_outer_length, 1, length]);
        }
        // Bolt holes
        translate([-bolt_dist_from_center, -thickness, bolt_dist_from_bottom_edge]) rotate([-90, 0, 0]) cylinder(d=bolt_diam, h=thickness*2);
        translate([-bolt_dist_from_center, -thickness, bolt_dist_from_top_edge]) rotate([-90, 0, 0]) cylinder(d=bolt_diam, h=thickness*2);
        translate([bolt_dist_from_center, -thickness, bolt_dist_from_bottom_edge]) rotate([-90, 0, 0]) cylinder(d=bolt_diam, h=thickness*2);
        translate([bolt_dist_from_center, -thickness, bolt_dist_from_top_edge]) rotate([-90, 0, 0]) cylinder(d=bolt_diam, h=thickness*2);
        // Nut cutouts
        translate([-bolt_dist_from_center, -thickness, bolt_dist_from_bottom_edge]) rotate([-90, 90, 0]) cylinder(d=nut_diam, h=2, $fn=6);
        translate([-bolt_dist_from_center, -thickness, bolt_dist_from_top_edge]) rotate([-90, 90, 0]) cylinder(d=nut_diam, h=2, $fn=6);
        translate([bolt_dist_from_center, -thickness, bolt_dist_from_bottom_edge]) rotate([-90, 90, 0]) cylinder(d=nut_diam, h=2, $fn=6);
        translate([bolt_dist_from_center, -thickness, bolt_dist_from_top_edge]) rotate([-90, 90, 0]) cylinder(d=nut_diam, h=2, $fn=6);
    }
}

// Bar clamp (slim version)
module bar_clamp_slim(inner_diam, 
                      thickness, 
                      length, 
                      bolt_diam, 
                      nut_diam, 
                      mount_bolt_diam=0, 
                      mount_bolt_dist=0, 
                      mount_bolt_nut_diam=0,
                      mount_bolt_nut_thickness=0) {
    outer_diam = inner_diam + 2*thickness;
    bolt_dist_from_center = inner_diam/2 + bolt_diam/2;
    bolt_dist_from_bottom_edge = length/4;
    bolt_dist_from_top_edge = length - (length/4);
    difference() {
        // Outer hull + mount
        union() {
            cylinder(d=outer_diam, h=length);
            if (mount_bolt_diam!=0) {
                translate([-(inner_diam*0.8/2), -((inner_diam/2)+thickness), 0]) 
                    cube([inner_diam*0.8, thickness, length]);
            }
        }
        // Inner cutout + division
        union() {
            cylinder(d=inner_diam, h=length);
            translate([-(outer_diam/2), -0.2, 0]) cube([outer_diam, 0.4, length]);
        }
        side=-1;
        // Bolt holes
        translate([-bolt_dist_from_center, -(outer_diam/2), bolt_dist_from_bottom_edge]) 
            rotate([-90, 0, 0]) cylinder(d=bolt_diam, h=outer_diam);
        translate([-bolt_dist_from_center, -(outer_diam/2), bolt_dist_from_top_edge]) 
            rotate([-90, 0, 0]) cylinder(d=bolt_diam, h=outer_diam);
        translate([bolt_dist_from_center, -(outer_diam/2), bolt_dist_from_bottom_edge]) 
            rotate([-90, 0, 0]) cylinder(d=bolt_diam, h=outer_diam);
        translate([bolt_dist_from_center, -(outer_diam/2), bolt_dist_from_top_edge]) 
        rotate([-90, 0, 0]) cylinder(d=bolt_diam, h=outer_diam);
        // bolt head cutouts
        translate([-bolt_dist_from_center, side*(inner_diam/3), bolt_dist_from_bottom_edge]) 
            rotate([side*-90, 90, 0]) cylinder(d=nut_diam, h=thickness*2);
        translate([-bolt_dist_from_center, side*(inner_diam/3), bolt_dist_from_top_edge]) 
            rotate([side*-90, 90, 0]) cylinder(d=nut_diam, h=thickness*2);
        translate([bolt_dist_from_center, side*(inner_diam/3), bolt_dist_from_bottom_edge]) 
            rotate([side*-90, 90, 0]) cylinder(d=nut_diam, h=thickness*2);
        translate([bolt_dist_from_center, side*(inner_diam/3), bolt_dist_from_top_edge]) 
            rotate([side*-90, 90, 0]) cylinder(d=nut_diam, h=thickness*2);
        // Nut cutouts
        translate([-bolt_dist_from_center, side*-(inner_diam/3), bolt_dist_from_bottom_edge]) 
            rotate([side*90, 90, 0]) cylinder(d=nut_diam, h=thickness*2, $fn=6);
        translate([-bolt_dist_from_center, side*-(inner_diam/3), bolt_dist_from_top_edge]) 
            rotate([side*90, 90, 0]) cylinder(d=nut_diam, h=thickness*2, $fn=6);
        translate([bolt_dist_from_center, side*-(inner_diam/3), bolt_dist_from_bottom_edge]) 
            rotate([side*90, 90, 0]) cylinder(d=nut_diam, h=thickness*2, $fn=6);
        translate([bolt_dist_from_center, side*-(inner_diam/3), bolt_dist_from_top_edge]) 
            rotate([side*90, 90, 0]) cylinder(d=nut_diam, h=thickness*2, $fn=6);

        if (mount_bolt_diam!=0) {
            translate([0, -inner_diam/3, length/2 - mount_bolt_dist/2]) 
                rotate([90, 0, 0]) 
                cylinder(d=mount_bolt_diam, h=inner_diam);
            translate([0, -inner_diam/3, length/2 + mount_bolt_dist/2]) 
                rotate([90, 0, 0]) 
                cylinder(d=mount_bolt_diam, h=inner_diam);
            translate([0, -inner_diam/2+1, length/2 - mount_bolt_dist/2]) 
                rotate([90,0,0]) cylinder(d=mount_bolt_nut_diam, h=mount_bolt_nut_thickness+1, $fn=6);
            translate([0, -inner_diam/2+1, length/2 + mount_bolt_dist/2]) 
                rotate([90,0,0]) cylinder(d=mount_bolt_nut_diam, h=mount_bolt_nut_thickness+1, $fn=6);
        }
    }
}


bar_clamp_slim(
    inner_diam=21, 
    thickness=7, 
    length=35, 
    bolt_diam=4.5, 
    nut_diam=9, 
    mount_bolt_diam=4.5, 
    mount_bolt_dist=20, 
    mount_bolt_nut_diam=9, 
    mount_bolt_nut_thickness=3);
