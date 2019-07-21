// clasp(length = 10);
// Need a sample pin?
// color("blue") cylinder(r=5, h=12);

module clasp(length=20, 
             pin_radius=5,
             // All of these are defined below due to 
             // SCAD language limits (no derived params)
             mouth = undef,
             inner_radius = undef,
             outer_radius = undef
             ) {            
  mouth = is_undef(mouth) ? pin_radius * 1.75 : mouth;
  inner_radius = is_undef(inner_radius) ? pin_radius + 0.25 : inner_radius;
  outer_radius = is_undef(outer_radius) ? inner_radius * 1.4 : outer_radius;

  echo(str("Building clasp with: "));
  echo(str("  Length: ", length));
  echo(str("  In Radius: ", inner_radius));
  echo(str("  Out Radius: ", outer_radius));
  echo(str("  Mouth : ", mouth));
  echo(str("  PinRad: ", pin_radius));

  difference() {
    cylinder(r=outer_radius,h=length);
   
    translate([0,0,-1]) 
      cylinder(r=inner_radius,h=length+2);
        
    cutout_mouth(mouth, inner_radius);
  }
  
  // Helper module
  module cutout_mouth(mouth, radius) {
    echo(str("Cutting mouth with: "));
    echo(str("  Mouth: ", mouth));
    echo(str("  InnerRad: ", radius));
    angle_rad = mouth / radius; // circle central angle (rad)
    angle_deg = angle_rad * 57.2958; // (degrees)
    echo(str("  Angle: ", angle_deg));

    size = length + 2;
    if (angle_deg <= 90) {
      translate([0,0,-1]) 
      intersection() {
        cube(size);
        rotate(angle_deg-90) cube(size);
      }
    } else if (angle_deg <= 180) {
      translate([0,0,-1]) 
      union() {
        cube(size);
        rotate(angle_deg-90) cube(size);
      }      
    } else {
      echo(str("FAILURE - Angle cannot exceed 180"));
    } 
  }

}

/*
THIS is not working right now. It's a good idea to combine these, but
the sad truth is a large amount of the correct clasp pin design has to do 
with how you combine it with the mesh border. So it's a bit hard to embed
with the clasp.scad file after the fact
module clasp_pin(length=cp_len,
    radius=cp_rad) {
      
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
      cylinder(r=radius, h=length+2);
  }
}
*/

