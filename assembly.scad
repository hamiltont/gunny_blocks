
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

module clasp_pin(length=cp_len) {
  difference() {
    // We oversize the cube (in Y and Z) to prevent edge artifacts 
    translate([0, -1, -1]) 
      cube([length, 2+cp_box_depth, mesh_height+2]);

    // You can rotate it to get a better print angle, but you 
    //   will need 8xSupports while printing
    //   which is tedious to clean
    // rotate(a=45, v=[1,0,0])
    translate([-1, cp_box_depth/2, mesh_height/2])
      rotate([0, 90, 0]) 
      cylinder(r=cp_rad, h=length+2);
  }
}


module mesh_with_clasp_pins() {
  difference() {
    mesh(side_length = side_length, 
      hole_diameter = hole_diameter,
      height = height,
      border = border, 
      grid_spacing = grid_spacing / 10);

    // Build and rotate all the clasp pins  
    translate([cp_len / 2, 0, 0]) 
      clasp_pin();
    
    translate([cp_len / 2 * 5, 0, 0]) 
      clasp_pin();
    
    translate([cp_len / 2, side_length - cp_box_depth, 0])
      // Spin it around (and re-align) 
      translate([cp_len, cp_box_depth, 0])
      rotate([0,0,180])
      clasp_pin();
    
    translate([cp_len / 2 * 5, side_length - cp_box_depth, 0]) 
      // Spin it around (and re-align) 
      translate([cp_len, cp_box_depth, 0])
      rotate([0,0,180])
      clasp_pin();
      
    translate([side_length, cp_len / 2, 0]) 
      rotate([0,0,90])
      clasp_pin();
      
    translate([side_length, cp_len / 2 * 5, 0]) 
      rotate([0,0,90])
      clasp_pin();
      
    translate([0, cp_len / 2, 0]) 
     // Spin and re-align
     translate([0,cp_len,0])
     rotate([0,0,270])
     clasp_pin();

    translate([0, cp_len / 2*5, 0]) 
     // Spin and re-align
     translate([0,cp_len,0])
     rotate([0,0,270])
     clasp_pin();
  }
}
