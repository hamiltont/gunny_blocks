
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

// clasp(length = 10);
// Need a sample pin?
// color("blue") cylinder(r=5, h=12);