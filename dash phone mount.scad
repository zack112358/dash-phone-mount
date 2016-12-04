
use <threads.scad>;

$fa=12;

inch = 25.4;


y_front_drop = 3/4 * inch / pow(4 * inch, 2);
y_back_drop = 5/8 * inch / pow(4 * inch, 2);
x_drop = 1/4 * inch / pow(3 * inch, 2);

function dropfade(x, y) = (y_front_drop * (3*inch + x) - y_back_drop * x) / (3 * inch);

function drop(x, y) = pow(1.5*inch + x, 2) * x_drop + pow(y, 2) * dropfade(x, y);



module design() {
    dashboard();
    clamp_and_phone();
    mount();
    //footzone();
}

trough_to_trough = 22.5;
peak_to_peak = 23.8;

module screw() {
    translate([0,0,3]) intersection() {
        metric_thread(peak_to_peak + .1, 1.8, 13);
        cylinder(r1=13, r2=10, h=13);
    }
    cylinder(r=13.5, h=6, center=true);
}

design();
/*rotate([0,90,0]) intersection() {
    translate([0, side_jog, height]) rotate([0,-90,0]) cylinder(r=17, h=20);
    mount();
}*/
       /*
intersection() {
    translate([0,0,500]) cube([1000,1000,1000], center=true);
    rotate([0, 90, 0]) mount();
}

translate([110, -20, 0]) rotate([0,180,0]) intersection() {
    translate([0,0,-500.01]) cube([1000,1000,1000], center=true);
    rotate([0, 90, 0]) mount();
}
*/
side_jog = 25;
rounding = 6;
width = 110 - 2 * rounding;
depth = 75 - rounding;
height = 65;
clamp_thickness = 16;

foot_width = 150 - 2 * rounding;
foot_depth = 105 - rounding;

phone_angle = 90;

module dashboard() {
    rotate([0,0,0]) hull() {
        for (x = [-5*inch : .5 * inch : 1.1 * inch]) {
            for (y = [-5 * inch : .5 * inch : 5.1 * inch]) {
                translate([x,y,-drop(x,y)]) sphere(r=1, $fn=3);
            }
        }
    }
}

module footzone() {
    difference() {
        translate([0,0,7]) dashboard();
        dashboard();
    }
}

module clamp_and_phone() {
    translate([0,side_jog,height]) rotate([0, -phone_angle, 0]) {
        translate([0, 0, -.001]) screw();
        translate([-10, 0, -clamp_thickness / 2]) cube([90,38,clamp_thickness], center=true);
        translate([-(3/8 * inch), -side_jog, -clamp_thickness]) rotate([0,0,90]) phone();
    }
}

module phone() {
    translate([0, 0, -7.9/2]) cube([147, 72.2, 7.9], center=true);
}

module head() {
    translate([0,side_jog,0]) {
        intersection() {
            cylinder(r=20, h=100);
            sphere(r=17);
        }
        intersection() {
            cylinder(r=20, h=100);
            translate([0,0,10])  sphere(r=17);
        }
    }
}

module base_sphere(x, y) {
    intersection() {
        translate([0, 0, 500]) cube([1000, 1000, 1000], center=true);
        translate([-height - drop(x, y), y, -x]) sphere(r=rounding);
    }
}

module mount() {
    render() difference() {
        union() {
            translate([0,0,height]) rotate([0, -phone_angle, 0]) head();
            translate([0,0,height]) rotate([0, -phone_angle, 0]) {
                hull() {
                    intersection() {
                        translate([0,side_jog,0]) sphere(r=rounding);
                        head();
                    }
                    head();
                    base_sphere(0, width/2);
                    base_sphere(-depth, width/2);
                }
                hull() {
                    intersection() {
                        translate([0,side_jog,0]) sphere(r=rounding);
                        head();
                    }
                    base_sphere(0, -width/2);
                    base_sphere(-depth * .75, -width/2);
                }
            }
            intersection() {
                footzone();
                translate([0,0,height]) rotate([0, -phone_angle, 0]) {
                    hull() {
                        head();
                        
                        base_sphere(0, foot_width / 2);
                        base_sphere(0, -foot_width / 2);
                        base_sphere(-foot_depth, foot_width / 2);
                        base_sphere(-foot_depth, -foot_width / 2);
                    }
                }
            }
            translate([0,0,height]) rotate([0, -phone_angle, 0]) {
                hull() {
                    translate([0,-side_jog,-clamp_thickness]) sphere(r=rounding);
                    translate([-(3/4*inch),-side_jog,-clamp_thickness]) sphere(r=rounding);
                    
                    base_sphere(-foot_depth / 2 - depth / 2, width / 2);
                }
                
                
                
                
               /* hull() {
                    translate([2*inch, -80, 0]) sphere(r=rounding/2);
                    translate([2.5*inch, -80, -2.5*inch]) sphere(r=rounding/2);
                    translate([2*inch, 80, 0]) sphere(r=rounding/2);
                    translate([2.5*inch, 80, -2.5*inch]) sphere(r=rounding/2);
                }*/
            }
        }
        dashboard();
        clamp_and_phone();
    }
}

