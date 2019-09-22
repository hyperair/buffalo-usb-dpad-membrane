use <MCAD/array/polar.scad>
use <MCAD/shapes/3Dshapes.scad>
include <MCAD/units/metric.scad>

$fs = 0.4;
$fa = 1;

module dpad_membrane ()
{
    size = [31, 15.3, 3];
    border_radius = 3.5;
    thickness = 1;

    button_cone_od1 = 7.2;
    button_cone_od2 = 5.3;
    button_cone_oh = 1.3;

    button_cone_id1 = 6.6;
    button_cone_id2 = 5.14;
    button_cone_ih = 0.8;
    button_cone_elevation = 1.39;

    button_nub_od = 5.3;
    button_nub_oh = 0.67;
    button_nub_id = 4.4;
    button_nub_ih = 0.3;

    button_orbit_r = 9.5;

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
        mcad_array_polar (number = 4, radius = button_orbit_r)
        children ();
    }

    difference () {
        union () {
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
            }

            /* button cones */
            translate ([0, 0, thickness - epsilon])
            place_buttons ()
            cylinder (
                d1 = button_cone_od1,
                d2 = button_cone_od2,
                h = button_cone_oh
            );
        }

        /* button internal cavity */
        place_buttons () {
            translate ([0, 0, button_cone_elevation - epsilon])
            cylinder (
                d1 = button_cone_id1,
                d2 = button_cone_id2,
                h = button_cone_ih
            );

            translate ([0, 0, -epsilon])
            cylinder (
                d = button_cone_id1,
                h = button_cone_elevation + epsilon
            );
        }

        /* shallow channels */
        channel_thickness = 0.2;
        channel_width = 1.47;
        translate ([0, 0, -epsilon])
        linear_extrude (height = channel_thickness) {
            rotate (45, Z)
            difference () {
                square (14.6, center = true);
                square (12, center = true);
            }

            mcad_array_polar (number = 4, radius = button_orbit_r)
            translate ([0, -channel_width / 2])
            square ([size[0] / 2, channel_width]);
        }
    }

    /* button nubs */
    place_buttons () {
        translate ([0, 0, thickness + button_cone_oh - epsilon])
        cylinder (d = button_nub_od, h = button_nub_oh);

        translate ([0, 0, button_cone_elevation + button_cone_ih])
        mirror (Z)
        cylinder (d = button_nub_id, h = button_nub_ih);
    }
}

dpad_membrane ();
