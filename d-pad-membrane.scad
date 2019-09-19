use <MCAD/array/polar.scad>
use <MCAD/shapes/3Dshapes.scad>
include <MCAD/units/metric.scad>

$fs = 0.4;
$fa = 1;

module dpad_membrane ()
{
    size = [30, 15, 2.5];
    border_radius = 3.5;
    thickness = 1;

    button_cone_od1 = 5;
    button_cone_od2 = 3;
    button_cone_h = 2;

    button_nub_d = 3;
    button_nub_h = 2;

    module cross_shape_2d ()
    {
        offset (r = border_radius)
        offset (r = -border_radius) {
            square ([size[0], size[1]], center = true);

            rotate (90, Z)
            square ([size[0], size[1]], center = true);
        }
    }

    module place_buttons ()
    {
        mcad_array_polar (number = 4, radius = 10)
        children ();
    }

    difference () {
        linear_extrude (height = size[2])
        cross_shape_2d ();

        /* inset area */
        translate ([0, 0, thickness])
        linear_extrude (height = size[2])
        offset (r = -1)
        cross_shape_2d ();

        /* center hole */
        cylinder (d = 6, h = size[2] + epsilon, center = true);

        /* button holes */
        place_buttons ()
        cylinder (d = 4, h = size[2] + epsilon, center = true);
    }

    translate ([0, 0, thickness - epsilon])
    place_buttons () {
        /* button cones */
        render ()
        difference () {
            cylinder (
                d1 = button_cone_od1,
                d2 = button_cone_od2,
                h = button_cone_h + epsilon
            );

            translate ([0, 0, -epsilon])
            cylinder (
                d1 = button_cone_od1 - thickness,
                d2 = button_cone_od2 - thickness,
                h = button_cone_h + epsilon * 2
            );
        }

        translate ([0, 0, button_cone_h - 0.5])
        cylinder (d = button_nub_d, h = button_nub_h, center = true);
    }
}

dpad_membrane ();
