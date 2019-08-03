A simple and flexible print for making nearly any block-based structure! 
You print one part - a 'side with connectors' - and can assemble it as 
needed into a cube, large rectangle, or any other shape you can dream up. 

I plan to use this as the basis of a more ambitious design. My hope is you can too! :) 

## Notes on Thingiverse Customizer
 * Customizer limitations make the SCAD source files look terrible, visit [Github](https://github.com/hamiltont/gunny_blocks) for original SCAD files
 * Customizer limitations mean you cannot see/edit all variables. Original scad files have far more editable values & explanatory comments if you bump into limitations 

## Implementation

There are a few terms you should know: 

 * side: a fully printed side containing the mesh, two clasps, and two pins
 * mesh: This is the innermost component, basically a flat sheet (e.g. very short cube) with 
   multiple holes cut out. Open to PRs that can cut meshes other than circles :-) 
 * connector: A generic term for either the clasp or the pin. During assembly of sides 
   you want the clasp and pin to have roughly the same geometry so they match up well. 
   Defining a common connector bounding box is the primary way this is achieved
 * pin: Little more than a cylinder turned sideways, with two 'mounts' on either end 
   so the pin is connected to the main object instead of floating in space
 * clasp: The 'female' side to the 'male' pin. Has space for the pin to be inserted
   and to freely rotate


