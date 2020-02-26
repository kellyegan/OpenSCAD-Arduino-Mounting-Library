// Pin Connectors V3
// Tony Buser <tbuser@gmail.com>
// Modified by Emmett Lalish

object=0;//[0:pin,1:pinpeg,2:pinhole]
length=20;
diameter=8;
//Only affects pinhole
hole_twist=0;//[0:free,1:fixed]
//Only affects pinhole
hole_friction=0;//[0:loose,1:tight]
//Radial gap to help pins fit into tight holes
pin_tolerance=0.2;
//Extra gap to make loose hole
loose=0.3;
lip_height=3;
lip_thickness=1;
hf=hole_friction==0 ? false : true;
ht=hole_twist==0 ? false : true;

if(object==0)pin(h=length,r=diameter/2,lh=lip_height,lt=lip_thickness,t=pin_tolerance);
if(object==1)pinpeg(h=length,r=diameter/2,lh=lip_height,lt=lip_thickness,t=pin_tolerance);
if(object==2)pinhole(h=length,r=diameter/2,lh=lip_height,lt=lip_thickness,t=loose,
	tight=hf,fixed=ht);

module test() {
  tolerance = 0.3;
  
  translate([-12, 12, 0]) pinpeg(h=20);
  translate([12, 12, 0]) pintack(h=10);
  
  difference() {
    union() {
      translate([0, -12, 2.5]) cube(size = [59, 20, 5], center = true);
      translate([24, -12, 7.5]) cube(size = [12, 20, 15], center = true);
    }
    translate([-24, -12, 0]) pinhole(h=5, t=tolerance);
    translate([-12, -12, 0]) pinhole(h=5, t=tolerance, tight=false);
    translate([0, -12, 0]) pinhole(h=10, t=tolerance);
    translate([12, -12, 0]) pinhole(h=10, t=tolerance, tight=false);
    translate([24, -12, 15]) rotate([0, 180, 0]) pinhole(h=10, t=tolerance);
  }
}

module pinhole(h=10, r=4, lh=3, lt=1, t=0.3, tight=true, fixed=false) {
  // h = shaft height
  // r = shaft radius
  // lh = lip height
  // lt = lip thickness
  // t = extra tolerance for loose fit
  // tight = set to false if you want a joint that spins easily
  // fixed = set to true so pins can't spin
  
intersection(){
  union() {
	if (tight == true || fixed == true) {
      pin_solid(h, r, lh, lt);
	  translate([0,0,-t/2])cylinder(h=h+t, r=r, $fn=30);
	} else {
	  pin_solid(h, r+t/2, lh, lt);
	  translate([0,0,-t/2])cylinder(h=h+t, r=r+t/2, $fn=30);
	}
    
    
    // widen the entrance hole to make insertion easier
    //translate([0, 0, -0.1]) cylinder(h=lh/3, r2=r, r1=r+(t/2)+(lt/2),$fn=30);
  }
  if (fixed == true) {
	translate([-r*2, -r*0.75, -1])cube([r*4, r*1.5, h+2]);
  }
}}

module pin(h=10, r=4, lh=3, lt=1, t=0.2, side=false) {
  // h = shaft height
  // r = shaft radius
  // lh = lip height
  // lt = lip thickness
  // side = set to true if you want it printed horizontally

  if (side) {
    pin_horizontal(h, r, lh, lt, t);
  } else {
    pin_vertical(h, r, lh, lt, t);
  }
}

module pintack(h=10, r=4, lh=3, lt=1, t=0.2, bh=3, br=8.75) {
  // bh = base_height
  // br = base_radius
  
  union() {
    cylinder(h=bh, r=br);
    translate([0, 0, bh]) pin(h, r, lh, lt, t);
  }
}

module pinpeg(h=20, r=4, lh=3, lt=1, t=0.2) {
  union() {
    translate([0,-0.05, 0]) pin(h/2+0.1, r, lh, lt, t, side=true);
    translate([0,0.05, 0]) rotate([0, 0, 180]) pin(h/2+0.1, r, lh, lt, t, side=true);
  }
}

// just call pin instead, I made this module because it was easier to do the rotation option this way
// since openscad complains of recursion if I did it all in one module
module pin_vertical(h=10, r=4, lh=3, lt=1, t=0.2) {
  // h = shaft height
  // r = shaft radius
  // lh = lip height
  // lt = lip thickness

  difference() {
    pin_solid(h, r-t/2, lh, lt);
    
    // center cut
    translate([-lt*3/2, -(r*2+lt*2)/2, h/5+lt*3/2]) cube([lt*3, r*2+lt*2, h]);
    //translate([0, 0, h/4]) cylinder(h=h+lh, r=r/2.5, $fn=20);
    // center curve
    translate([0, 0, h/5+lt*3/2]) rotate([90, 0, 0]) cylinder(h=r*2, r=lt*3/2, center=true, $fn=20);
  
    // side cuts
    translate([-r*2, -r-r*0.75+t/2, -1]) cube([r*4, r, h+2]);
    translate([-r*2, r*0.75-t/2, -1]) cube([r*4, r, h+2]);
  }
}

// call pin with side=true instead of this
module pin_horizontal(h=10, r=4, lh=3, lt=1, t=0.2) {
  // h = shaft height
  // r = shaft radius
  // lh = lip height
  // lt = lip thickness
  translate([0, 0, r*0.75-t/2]) rotate([-90, 0, 0]) pin_vertical(h, r, lh, lt, t);
}

// this is mainly to make the pinhole module easier
module pin_solid(h=10, r=4, lh=3, lt=1) {
  union() {
    // shaft
    cylinder(h=h-lh, r=r, $fn=30);
    // lip
    // translate([0, 0, h-lh]) cylinder(h=lh*0.25, r1=r, r2=r+(lt/2), $fn=30);
    // translate([0, 0, h-lh+lh*0.25]) cylinder(h=lh*0.25, r2=r, r1=r+(lt/2), $fn=30);
    // translate([0, 0, h-lh+lh*0.50]) cylinder(h=lh*0.50, r1=r, r2=r-(lt/2), $fn=30);

    // translate([0, 0, h-lh]) cylinder(h=lh*0.50, r1=r, r2=r+(lt/2), $fn=30);
    // translate([0, 0, h-lh+lh*0.50]) cylinder(h=lh*0.50, r1=r+(lt/2), r2=r-(lt/3), $fn=30);    

    translate([0, 0, h-lh]) cylinder(h=lh*0.25, r1=r, r2=r+(lt/2), $fn=30);
    translate([0, 0, h-lh+lh*0.25]) cylinder(h=lh*0.25, r=r+(lt/2), $fn=30);    
    translate([0, 0, h-lh+lh*0.50]) cylinder(h=lh*0.50, r1=r+(lt/2), r2=r-(lt/2), $fn=30);    

    // translate([0, 0, h-lh]) cylinder(h=lh, r1=r+(lt/2), r2=1, $fn=30);
    // translate([0, 0, h-lh-lt/2]) cylinder(h=lt/2, r1=r, r2=r+(lt/2), $fn=30);
  }
}

module pinshaft(h=10, r=4, t=0.2, side=false){
flip=side ? 1 : 0;
translate(flip*[0,h/2,r*0.75-t/2])rotate(flip*[90,0,0])
intersection(){
	cylinder(h=h, r=r-t/2, $fn=30);
	translate([-r*2, -r*0.75+t/2, -1])cube([r*4, r*1.5-t, h+2]);
}
}