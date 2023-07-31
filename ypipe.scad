/**
 * Modules to produce Rings, Pipes and Y Pipes.
 */

/**
 * Create a ring given radius and wall thickness
 */
module Ring(radius=10, 
            wall_thickness=1) {
    difference() {
        circle(radius); 
        circle(radius - wall_thickness);
    }
}

/**
 * Create a Pipe given radius, height and wall thickness
 */
module Pipe(radius=10, 
            height=10, 
            wall_thickness=1) {
    linear_extrude(height=height) Ring(radius, wall_thickness);
}

/**
 * Create an Y Pipe given its radius, total height, y spacing, wall thickness and top and bottom extensions.
 */
module YPipe(radius=10, 
             total_height=40, 
             y_spacing=10, 
             wall_thickness=1, 
             top_extension=10, 
             bottom_extension=10) {
    height = total_height - top_extension - bottom_extension;
    topw = y_spacing + 2 * radius;
    Pipe(radius, bottom_extension, wall_thickness);
    translate([0, 0, bottom_extension]) 
        difference() {
            union() {
                hull() {
                    cylinder(0.001, radius, radius);
                    translate([topw/2, 0, height]) 
                        cylinder(0.001, radius, radius);
                }
                hull() {
                    cylinder(0.001, radius, radius);
                    translate([-(topw/2), 0, height]) 
                        cylinder(0.001, radius, radius);
                }
            }
            union() {
                hull() {
                    translate([0, 0, -0.001]) 
                        cylinder(0.001, radius - wall_thickness, radius - wall_thickness);
                    translate([topw/2, 0, height+0.001]) 
                        cylinder(0.001, radius - wall_thickness, radius - wall_thickness);
                }
                hull() {
                    translate([0, 0, -0.001]) 
                        cylinder(0.001, radius - wall_thickness, radius - wall_thickness);
                    translate([-(topw/2), 0, height+0.001]) 
                        cylinder(0.001, radius - wall_thickness, radius - wall_thickness);
                }
            }
        }
    translate([-(topw/2), 0, bottom_extension + height]) 
        Pipe(radius, top_extension, wall_thickness);
    translate([(topw/2), 0, bottom_extension + height]) 
        Pipe(radius, top_extension, wall_thickness);
}

module BentCylinder(radius=30, bend_radius_inner=100, angle=45, pre_length=20, post_length=20) {
    translate([-(bend_radius_inner + radius), 0, 0]) 
        union() {
            rotate([-90, 0, 0]) 
                translate([bend_radius_inner + radius, 0, 0]) 
                cylinder(pre_length, radius, radius);
            translate([0, pre_length, 0]) 
                rotate_extrude(angle=angle) 
                translate([bend_radius_inner + radius, 0, 0]) 
                circle(radius);
            translate([0, pre_length, 0]) 
                rotate([-90, 0, angle]) 
                translate([bend_radius_inner + radius, 0, 0]) 
                cylinder(post_length, radius, radius);
        }
}

//module rotate_at_axis(axis=[0,0,0], angle=[0,0,0]) {
//    translate([-axis.x, -axis.y, -axis.z]) rotate([angle.z, angle.y, angle.z]) translate([axis.x, axis.y, axis.z])
//}

module BentCylinder2(radius=30, bend_radius_inner=100, angle=45, pre_length=20, post_length=20) {
    // Pre-length
    rotate([-90, 0, 0]) cylinder(pre_length, radius, radius);

    // First bend
    translate([-(bend_radius_inner + radius), pre_length, 0]) 
        rotate_extrude(angle=angle) 
        translate([bend_radius_inner + radius, 0, 0]) 
        circle(radius);

    // Second bend
    translate([-(bend_radius_inner + radius), pre_length, 0]) 
        rotate([0, 0, angle])
        translate([bend_radius_inner + radius, 0, 0])
        rotate([0,180,0])
        translate([-(bend_radius_inner + radius), 0, 0])
        rotate_extrude(angle=angle) 
        translate([bend_radius_inner + radius, 0, 0]) 
        circle(radius);

    // Post-length
    translate([-(bend_radius_inner + radius), pre_length, 0]) 
        rotate([0, 0, angle])
        translate([bend_radius_inner + radius, 0, 0])
        rotate([0,180,0])
        translate([-(bend_radius_inner + radius), 0, 0])
        rotate([-90, 0, angle]) 
        translate([bend_radius_inner + radius, 0, 0]) 
        cylinder(post_length, radius, radius);
}

module BentPipe(radius=30, wall_thickness=1, angle=45, bend_radius=100, pre_length=30, post_length=30) { 
    translate([-(bend_radius + radius), 0, 0]) union() {
        rotate([-90, 0, 0]) translate([bend_radius + radius, 0, 0]) Pipe(radius, pre_length, wall_thickness); 
        translate([0, pre_length, 0]) rotate_extrude(angle=angle) translate([bend_radius + radius, 0, 0]) Ring(radius, wall_thickness);
        translate([0, pre_length, 0]) rotate([-90, 0, angle]) translate([bend_radius + radius, 0, 0]) Pipe(radius, post_length, wall_thickness);
    }
}

module BentPipe2(radius=30, wall_thickness=1, bend_radius_inner=100, angle=90, pre_length=20, post_length=20) {
    difference() {
        BentCylinder(radius, bend_radius_inner, angle, pre_length, post_length);
        BentCylinder(radius-wall_thickness, bend_radius_inner+wall_thickness, angle, pre_length, post_length);
    }
}

module YPipe2(top_diameter=10, 
              bottom_diameter=10,
              total_height=40, 
              y_spacing=10, 
              wall_thickness=1, 
              top_extension=10, 
              bottom_extension=10,
              bottom_extension_flange_outside=true,
              bottom_extension_flange_thickness=0,
              bottom_extension_flange_distance=5) {
    top_radius = top_diameter / 2;
    bottom_radius = bottom_diameter / 2;
    height = total_height - top_extension - bottom_extension;
    topw = y_spacing + 2 * top_radius;
    Pipe(bottom_radius, bottom_extension, wall_thickness);
    translate([0, 0, bottom_extension]) 
        difference() {
            union() {
                hull() {
                    cylinder(0.001, bottom_radius, bottom_radius);
                    translate([topw/2, 0, height]) 
                        cylinder(0.001, top_radius, top_radius);
                }
                hull() {
                    cylinder(0.001, bottom_radius, bottom_radius);
                    translate([-(topw/2), 0, height]) 
                        cylinder(0.001, top_radius, top_radius);
                }
            }
            union() {
                hull() {
                    translate([0, 0, -0.001]) 
                        cylinder(0.001, bottom_radius - wall_thickness, bottom_radius - wall_thickness);
                    translate([topw/2, 0, height+0.001]) 
                        cylinder(0.001, top_radius - wall_thickness, top_radius - wall_thickness);
                }
                hull() {
                    translate([0, 0, -0.001]) 
                        cylinder(0.001, bottom_radius - wall_thickness, bottom_radius - wall_thickness);
                    translate([-(topw/2), 0, height+0.001]) 
                        cylinder(0.001, top_radius - wall_thickness, top_radius - wall_thickness);
                }
            }
        }
    translate([-(topw/2), 0, bottom_extension + height]) 
        Pipe(top_radius, top_extension, wall_thickness);
    translate([(topw/2), 0, bottom_extension + height]) 
        Pipe(top_radius, top_extension, wall_thickness);
/*    if (bottom_extension_flange_thickness > 0) {
        if (bottom_extension_flange_outside) {
            translate([0, 0, bottom_extension_flange_distance])
                Pipe(top_radius + wall_thickness,
                     bottom_extension_flange_thickness,
                     bottom_extension_flange_thickness);
        } else {
            translate([0, 0, bottom_extension_flange_distance])
                Pipe(top_radius - bottom_extension_flange_thickness ,
                     bottom_extension_flange_thickness,
                     bottom_extension_flange_thickness);
        }
    }*/
}


$fn=120;

YPipe2(top_diameter=95, 
       bottom_diameter=68, 
       total_height=40+20+60, 
       wall_thickness=1.2, 
       y_spacing=20, 
       top_extension=40, 
       bottom_extension=20,
       bottom_extension_flange_outside=false,
       bottom_extension_flange_thickness=5,
       bottom_extension_flange_distance=20);




/*
i=20;
a=65;
pre=50;
post=50;

difference() {
    union() {
        BentCylinder2(radius=47, bend_radius_inner=i, angle=a);
        rotate([0,180,0]) BentCylinder2(radius=47, bend_radius_inner=i, angle=a);
    }
    union() {
        BentCylinder2(radius=45, bend_radius_inner=i+2, angle=a);
        rotate([0,180,0]) BentCylinder2(radius=45, bend_radius_inner=i+2, angle=a);
    }
}
*/


//BentPipe2(angle=30, bend_radius_inner=0, wall_thickness=1);

/*
difference() {
    union() {
        BentCylinder(radius=30, bend_radius_inner=50, pre_length=0, post_length=0);
        rotate([0,180,0]) BentCylinder(radius=30, bend_radius_inner=50, pre_length=0, post_length=0);
    }
    union() {
        BentCylinder(radius=29, bend_radius_inner=51, pre_length=0, post_length=0);
        rotate([0,180,0]) BentCylinder(radius=29, bend_radius_inner=51, pre_length=0, post_length=0);
    }
}
*/

