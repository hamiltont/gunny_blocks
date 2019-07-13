
$fn=10; 

// Overall mode
// 1 - Generate side (mesh with clasp-pins)
// 2 - Generate clasp
mode = 1;

// === Mesh Variables ============
  side_length = 50;
  height = 3;
  hole_diameter = 10;
  border = 6;
  grid_spacing = 1;
// === End =======================

// === Clasp Pin Variables ============
  cp_len = side_length / 4;
  cp_rad = 1.5;
  cp_box_depth = border*0.75;
// === End =======================

// === Clasp Variables ============
  clasp_len = cp_len * 0.85;
  clasp_mouth = cp_rad*1.2;
  clasp_inner_rad = cp_rad+0.25;
  clasp_outer_rad = clasp_inner_rad*1.4;
// === End =======================

include <mesh.scad>
include <clasp.scad>

module clasp_pin() {
  difference() {
    // Make the cube bigger (in Z) to ensure no edge artifact 
    translate([0, 0,-1]) 
      cube([cp_len, 1+cp_box_depth, height+2]);

    // You can rotate it to get a better print angle, but you 
    //   will need 8xSupports while printing
    //   which is tedious to clean
    // rotate(a=45, v=[1,0,0])
    translate([-1, cp_box_depth/2, height/2])
      rotate([0, 90, 0]) 
      cylinder(r=cp_rad, h=cp_len+2);
  }
}


module mesh_with_clasp_pins() {
  difference() {
    mesh(side_length, 
      height, 
      hole_diameter, 
      border, 
      grid_spacing / 10);

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



echo(str("Clasp pins are ", cp_len, 
  "mm long and ", cp_rad, "mm round")); 
echo(str("Using ", cp_box_depth, " of the ", 
  border, "mm border"));

if (mode == 1) {
  mesh_with_clasp_pins();
  // clasp_pin();
} else if (mode == 2) {
     clasp();
} else if (mode == 3) {
      translate([0, cp_len / 2, 0]) 

   translate([0,cp_len,0])
   rotate([0,0,270])
    clasp_pin(); 
}

