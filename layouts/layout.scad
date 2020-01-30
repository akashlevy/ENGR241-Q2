// RRAM Single Cell Test Structures
// Author: Akash Levy
// Last modified: 1/18/20

// All units in microns

// Array layout parameters
n_groups = 10;
n_rows = 20;
n_cols = 3;
pad_size = 200;
pad_spacing = 500;
group_spacing = 500;
rram_size = [1, 2, 3, 4, 5, 8, 10, 20, 40, 50];
font_size = 400;

// Tiling and alignment parameters
design_rows = 4;
design_cols = 2;
bound_gap = 2000;
mark_th = 10;

// Select when exporting: layer 0 is via trench pattern, layer 1 is TE pattern
layer = 0;

// Define design boundaries
trx = design_cols * (pad_spacing * n_cols + group_spacing) * n_groups + bound_gap;
try = design_rows * (pad_spacing * n_rows + font_size * 3) + bound_gap;

// Center around 0
translate([-trx/2, -try/2]) {

// Place alignment marks
translate([0, 0]) {
    square([mark_th, bound_gap/2], center=true);
    square([bound_gap/2, mark_th], center=true);
}
translate([trx, 0]) {
    square([mark_th, bound_gap/2], center=true);
    square([bound_gap/2, mark_th], center=true);
}
translate([0, try]) {
    square([mark_th, bound_gap/2], center=true);
    square([bound_gap/2, mark_th], center=true);
}
translate([trx, try]) {
    square([mark_th, bound_gap/2], center=true);
    square([bound_gap/2, mark_th], center=true);
}

// Tile design in rows and cols
translate([bound_gap*3/4, bound_gap*3/4, 0])
for (drow = [0 : design_rows - 1]) {
    translate([0, drow * (pad_spacing * n_rows + font_size * 3), 0])
    for (dcol = [0 : design_cols - 1]) {
        translate([dcol * (pad_spacing * n_cols + group_spacing) * n_groups, 0, 0]) {
            // Create pads/trenches in groups
            for (i = [0 : n_groups - 1]) {
                translate([i * (pad_spacing * n_cols + group_spacing), 0, 0])
                for (row = [0 : n_rows - 1]) {
                    translate([0, row * pad_spacing, 0])
                    for (col = [0 : n_cols - 1]) {
                        translate([col * pad_spacing, 0, 0])
                        if (layer == 1) square(pad_size, center=true);
                        else square(rram_size[i], center=true);
                    }
                }
            }

            // Pad group labels
            if (layer == 1)
            for (i = [0 : n_groups - 1]) {
                translate([i * (pad_spacing * n_cols + group_spacing) - font_size/4, n_rows * pad_spacing, 0])
                text(str(rram_size[i]," um"), size = font_size);
            }
        }
    }
}

}