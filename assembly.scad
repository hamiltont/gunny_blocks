
$fn=10; 

// Overall mode
// 1 - Generate one side (mesh with clasps & pins)
// 2 - Testing code
mode = 1;

if (mode == 1) {
  mesh_with_clasps_and_pins();
} else if (mode == 2) {
  test();
}

// === Mesh Variables ============
  mesh_size = 180;
  mesh_height = 1; // 3.5
  mesh_hole_diameter = 15;
  mesh_border = 2.5;
  mesh_border_height = 10;
  mesh_grid_spacing = 3;
// === End =======================

// === Connector Variables ============
// These define the bounding box used by both
// the clasp pin and the clasp
  con_width = mesh_size;
  con_height = mesh_border_height; 
  con_depth = con_height; // Keep con square so corners interlock OK
// === End =======================

// === Clasp Pin Variables ============
  cp_length = con_width;
  cp_rad = 2.5;
  // TODO define cp_mount_width = 1;
// === End =======================

// === Clasp Variables ============
  clasp_len = con_width - 3;
  clasp_mouth = cp_rad * 1.65;
  clasp_inner_rad = cp_rad + 0.65;
  clasp_outer_rad = clasp_inner_rad * 1.25;
// === End =======================

include <mesh.scad>
include <clasp.scad>

module mesh_with_clasps_and_pins() {
  
  // Make mesh & slide to have room for connectors
  translate([con_depth, con_depth, 0])
  mesh(side_length = mesh_size, 
        hole_diameter = mesh_hole_diameter,
        height = mesh_height,
        border = mesh_border, 
        border_height = mesh_border_height,
        grid_spacing = mesh_grid_spacing / 10);
  
  // Create male sides
  color("red") translate([con_depth, 0 , 0]) 
    male_pin_and_mount();
  color("red") translate([0, mesh_size + con_depth,0])
    rotate([0, 0, 270])
    male_pin_and_mount();
    
  // Create female sides
  color("green") translate([con_depth, mesh_size + con_depth, 0])
    female_clasp_and_mount();
  color("green") translate([mesh_size + con_depth, mesh_size + con_depth,0])
    rotate([0, 0, -90])
    female_clasp_and_mount();

  module female_clasp_and_mount() {
    // Helper variables
    clasp_thickness = clasp_outer_rad - clasp_inner_rad;
    clasp_mount_depth = con_depth - clasp_outer_rad*2; // Does not incl. thickness
    // Fudge factor, we need to keep the clasp within the 
    // bounding box or our 3D arrangement won't work right. However, we also
    // need it to be roughly aligned with the pin or the 3D arrangement will 
    // be hard to assemble. Calculating directly is tough, as the bigger the
    // mouth cut is, the more of a fudge factor we need. So we approx an OK val
    clasp_extra_mount_depth = clasp_mouth / 3.6; 

    // Assume we need to reserve 3mm (total) in X-axis the clasp mounts
    // Realign Y-axix to zero 
    translate([1.5, clasp_outer_rad + clasp_mount_depth,0])
    union() {

      // Shift clasp down to ease alignment
      translate([0,
                 clasp_extra_mount_depth, 
                 (mesh_border_height / 2) - clasp_outer_rad]) 
        clasp(length = clasp_len, 
              pin_radius = cp_rad,
              mouth = clasp_mouth,
              inner_radius = clasp_inner_rad,
              outer_radius=clasp_outer_rad);
      // Build + align clasp mount
      translate([0, -clasp_outer_rad-clasp_mount_depth, 0])
        cube([con_width - 3, 
              clasp_mount_depth + clasp_thickness + clasp_extra_mount_depth,
              con_height]);
      
      // Debug (for ensuring the bounding box is right)
      // translate([0, -clasp_outer_rad-clasp_mount_depth, 0])
      // cube([1, con_depth, con_height]);
     }
 }

  
  // Helper function
  module male_pin_and_mount() {
    // color("green") cube([con_width, con_depth, con_height]);  
    // Assume mounts are each 1mm wide
    // Assume we want the CP 2.5mm deep
    pin_mount_height = (mesh_border_height / 2) - cp_rad;
    union() {
      cube([1, con_depth, con_height]);
      translate([0, 2.5, pin_mount_height])
        clasp_pin(radius=cp_rad, length=cp_length);
      translate([con_width-1, 0, 0]) 
        cube([1, con_depth, con_height]);
    }
  }
}
