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
             y_spacing=45, 
             wall_thickness=1, 
             top_extension=10, 
             bottom_extension=10) {
    height = total_height - top_extension - bottom_extension;
    topw = y_spacing - 2 * radius;
    Pipe(radius, bottom_extension, wall_thickness);
    translate([0, 0, bottom_extension]) difference() {
        union() {
            hull() {
                cylinder(0.001, radius, radius);
                translate([topw/2, 0, height]) cylinder(0.001, radius, radius);
            }
            hull() {
                cylinder(0.001, radius, radius);
                translate([-(topw/2), 0, height]) cylinder(0.001, radius, radius);
            }
        }
        union() {
            hull() {
                translate([0, 0, -0.001]) cylinder(0.001, radius - wall_thickness, radius - wall_thickness);
                translate([topw/2, 0, height+0.001]) cylinder(0.001, radius - wall_thickness, radius - wall_thickness);
            }
            hull() {
                translate([0, 0, -0.001]) cylinder(0.001, radius - wall_thickness, radius - wall_thickness);
                translate([-(topw/2), 0, height+0.001]) cylinder(0.001, radius - wall_thickness, radius - wall_thickness);
            }
        }
    }
    translate([-(topw/2), 0, bottom_extension + height]) Pipe(radius, top_extension, wall_thickness);
    translate([(topw/2), 0, bottom_extension + height]) Pipe(radius, top_extension, wall_thickness);
}

YPipe();
