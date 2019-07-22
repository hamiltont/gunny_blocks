
$fn=10; 

// Overall mode
// 1 - Generate side (mesh with clasp-pins)
// 2 - Generate clasp
mode = 1;

// === Mesh Variables ============
  mesh_size = 50;
  mesh_height = 3;
  mesh_hole_diameter = 10;
  mesh_border = 6;
  mesh_grid_spacing = 1;
// === End =======================

// === Clasp Pin Variables ============
  cp_len = mesh_size / 4;
  cp_rad = 1.5;
  cp_box_depth = mesh_border*0.75;
// === End =======================

// === Clasp Variables ============
  clasp_len = cp_len * 0.85;
  clasp_mouth = cp_rad*1.2;
  clasp_inner_rad = cp_rad+0.25;
  clasp_outer_rad = clasp_inner_rad*1.4;
// === End =======================


if (mode == 1) {
  mesh_with_clasp_pins();
  clasp(length=clasp_len, 
    pin_radius=cp_rad,
    mouth=clasp_mouth,
    inner_radius=clasp_inner_rad,
    outer_radius=clasp_outer_rad);
} else if (mode == 2) {
     clasp();
} else if (mode == 3) {
  test();
}

include <mesh.scad>
include <clasp.scad>

module mesh_with_clasps_and_pins() {
  
  // Make mesh & slide to have room for connectors
  translate([con_depth, con_depth, 0])
  mesh(side_length = mesh_size, 
        hole_diameter = mesh_hole_diameter,
        height = mesh_height,
        border = mesh_border, 
        grid_spacing = mesh_grid_spacing / 10);
  
  // Create male sides
  translate([con_depth, 0 , 0]) 
    male_pin_and_mount();
  translate([0, mesh_size + con_depth,0])
    rotate([0, 0, 270])
    male_pin_and_mount();
    
  // Create female sides
  translate([con_depth, mesh_size + con_depth, 0])
    female_clasp_and_mount();
  translate([mesh_size + con_depth, mesh_size + con_depth,0])
    rotate([0, 0, -90])
    female_clasp_and_mount();

  module female_clasp_and_mount() {
    // Helper variables
    clasp_thickness = clasp_outer_rad - clasp_inner_rad;
    clasp_mount_depth = con_depth - clasp_outer_rad*2; // Does not incl. thickness

    // Assume we need to reserve 3mm (total) in X-axis the clasp mounts
    // Realign Y-axix to zero 
    translate([1.5, clasp_outer_rad + clasp_mount_depth,0])
    union() {
      // Shift clasp down to ease alignment
      translate([0,0,(mesh_height / 2) - clasp_outer_rad]) 
        clasp(length = clasp_len, 
              pin_radius = cp_rad,
              mouth = clasp_mouth,
              inner_radius = clasp_inner_rad,
              outer_radius=clasp_outer_rad);
      // Build + align clasp mount
      translate([0, -clasp_outer_rad-clasp_mount_depth, 0])
        cube([con_width - 3, clasp_mount_depth + clasp_thickness, con_height]);
     }
 }

  
  // Helper function
  module male_pin_and_mount() {
    // color("green") cube([con_width, con_depth, con_height]);  
    // Assume mounts are each 1mm wide
    // Assume we want the CP 2.5mm deep
    pin_mount_height = (mesh_height / 2) - cp_rad;
    union() {
      cube([1, con_depth, con_height]);
      translate([0, 2.5, pin_mount_height])
        clasp_pin(radius=cp_rad, length=cp_length);
      translate([con_width-1, 0, 0]) 
        cube([1, con_depth, con_height]);
    }
  }
}
