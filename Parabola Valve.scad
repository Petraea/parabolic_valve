$fn = 50;
shim=0.01;

valve_id=10;
valve_od=12;
valve_length=20;
pre_valve_length=4;
pre_valve_stickout=1;
head_length=2;
seal_length=15;
seal_width=10;
back_seal_length=2;
flow_through_id=2.8;
flow_through_number=8;
example_gap=0.2;


module parabola(h=1,w=1,curve=2,resolution=20) {
step = 1/resolution; 
union() {
    for(t=[0:step:1]){
        u = t + step;
        taper=1;
        hull(){
        translate([0,0,pow(t,curve)*h]) cylinder(r =t*w/2, h = shim);
        translate([0,0,pow(u,curve)*h]) cylinder(r =u*w/2, h = shim);
       }
    }
  }
}

module valve() {
 flow_d=360/flow_through_number;
 flow_e=360-flow_d;

  difference() {
    cylinder(r=valve_od/2,h=valve_length,center=true);
    cylinder(r=valve_id/2,h=valve_length+shim,center=true);
  }

  translate([0,0,valve_length/2-head_length/2-pre_valve_length])
   difference() {
    cylinder(r=valve_id/2,h=head_length,center=true);
    translate([0,0,seal_length/2-pre_valve_length+pre_valve_stickout+example_gap]) rotate([0,180,0]) parabola(seal_length,seal_width,3,40);
   }
 
 
  translate([0,0,valve_length/2-head_length/2-pre_valve_length+seal_length/2-pre_valve_length+pre_valve_stickout]) {
    difference() {
      union() {
      translate([0,0,-seal_length-back_seal_length/2]) cylinder(r=valve_id/2,h=back_seal_length,center=true);
        rotate([0,180,0]) parabola(seal_length,seal_width,3,40);
        }
        for(q=[0:flow_d:flow_e]){
        rotate([0,0,q]) translate([valve_id/2,0,-seal_length/2])cylinder(h=valve_length*2,r=flow_through_id/2,center=true);
      }
    }
  }
}
difference() {
valve();
  translate([0,50,0])cube([100,100,100],center=true);
}