// mesh(side_length=50);
/*mesh(side_length, 
      hole_diameter,
      height, 
      border, 
      grid_spacing / 10);
*/

module mesh(side_length, 
            hole_diameter = undef, 
            height=3,
            border=undef,
            grid_spacing=0.2) {
             
  hole_diameter = is_undef(hole_diameter) ? side_length / 8 : hole_diameter;
  border = is_undef(border) ? side_length *.1 : border;
              
  echo(str("Building mesh with: "));
  echo(str("  Side: ", side_length));
  echo(str("  Hole Diameter: ", hole_diameter));
  echo(str("  Height: ", height));
  echo(str("  Border : ", border));
  echo(str("  Grid Spacing: ", grid_spacing));

  // Ensure the border is sane
  // border = min(border, side_length / 2.5);
  size = side_length;

  // We can only place holes in the non-border, and 
  // each hole actually takes a bit of addl. spacing
  hole_footprint = hole_diameter * (1 + grid_spacing);
  s_avail = size - border*2;
  hole_count = ceil(s_avail / hole_footprint);  
  hole_r = hole_diameter / 2;

  // Diagnostic data
  /*echo(str("We have ", s_avail, "mm of space for holes"));
  echo(str("We will place ", hole_count, " holes"));
  echo(str("Each hole has a footprint of ", hole_footprint, "mm-squared"));
  */

  union(){
    color("gray") {
      cube([size,border,height]);
      cube([border,size,height]);
     
      translate([size-border,0,0]) 
      cube([border,size,height]);
     
      translate([0,size-border,0]) 
      cube([size,border,height]);
    }

    difference() {
      translate([border, border, 0])
        cube(size=[size - 2*border, size - 2*border, height]);
      
      translate([border + hole_r, border+hole_r, -1])
      for (x = [0:hole_count - 1]) {
        translate([x * hole_footprint, 0, 0])
        for (y = [0:hole_count - 1]) {
          translate([0, y * hole_footprint, 0])
          cylinder(r=hole_diameter / 2, h=height*4, $fn=20);
        }
      }
    }
  }
}


