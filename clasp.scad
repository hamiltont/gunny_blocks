/*
$fn = 10;

cp_rad = 1.5;

clasp_len =10;
clasp_mouth = cp_rad * 0.9;

clasp_inner_rad = cp_rad+0.25;
clasp_outer_rad = clasp_inner_rad*1.4;
*/

module half_clasp() {
  difference() {
    cylinder(r=clasp_outer_rad,h=clasp_len);
    // cube([clasp_rad, clasp_rad, clasp_len]);
    translate([0,0,-1]) cylinder(r=clasp_inner_rad,h=clasp_len+2);
    translate([-clasp_mouth/2,0,-1]) 
      cube([clasp_mouth,clasp_outer_rad+2,clasp_len+2]);
  }
}

module clasp() {
  echo(str("Building clasp with: "));
  echo(str("  Length: ", clasp_len));
  echo(str("  In Radius: ", clasp_inner_rad));
  echo(str("  Out Radius: ", clasp_outer_rad));
  echo(str("  Mouth : ", clasp_mouth));
  echo(str("  PinRad: ", cp_rad)); 
  union() {
    translate([0, clasp_outer_rad-(clasp_outer_rad - clasp_inner_rad), 0]) 
      half_clasp();
    translate([0, -clasp_outer_rad, 0]) rotate(180) 
      half_clasp();
    //color("blue") 
    //cylinder(r=1,h=10);
  }
}

//clasp();

/*
Attempt to cut clasp from square
difference() {
  cube([clasp_rad, clasp_rad, clasp_len]);
  // Cut out pin hole
  translate([clasp_rad/2,clasp_rad/2,-1]) 
    cylinder(r=cp_rad,h=clasp_len+2);
  // Cut mouth
  translate([-1, clasp_rad/2 - clasp_mouth/2,-1]) 
    cube([2, clasp_mouth, clasp_len+2]);
}
*/