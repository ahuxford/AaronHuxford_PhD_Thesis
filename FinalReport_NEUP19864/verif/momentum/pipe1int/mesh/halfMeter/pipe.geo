r=5e-2;
Point(1) = {r,0,0};

Point(2) = {0.707*r,0.707*r,0};

Point(3) = {0,r,0};

Point(4) = {-0.707*r,0.707*r,0};

Point(5) = {-r,0,0};

Point(6) = {-0.707*r,-0.707*r,0};

Point(7) = {0,-r,0};

Point(8) = {0.707*r,-0.707*r,0};

Point(9) = {0.75*r,0,0};

Point(10) = {0.75*0.707*r,0.75*0.707*r,0};

Point(11) = {0,0.75*r,0};

Point(12) = {-0.75*0.707*r,0.75*0.707*r,0};

Point(13) = {-0.75*r,0,0};

Point(14) = {-0.75*0.707*r,-0.75*0.707*r,0};

Point(15) = {0,-0.75*r,0};

Point(16) = {0.75*0.707*r,-0.75*0.707*r,0};

Point(17) = {0,0,0};

Line(1) = {9,10};
Line(2) = {10,11};
Line(3) = {11,12};
Line(4) = {12,13};
Line(5) = {13,14};
Line(6) = {14,15};
Line(7) = {15,16};
Line(8) = {16,9};

Line Loop(1) = {1,2,3,4,5,6,7,8};
Plane Surface(1) = {1};

Circle(9) = {1,17,2};
Circle(10) = {2,17,3};
Circle(11) = {3,17,4};
Circle(12) = {4,17,5};
Circle(13) = {5,17,6};
Circle(14) = {6,17,7};
Circle(15) = {7,17,8};
Circle(16) = {8,17,1};


Line(17) = {1,9};

Line(18) = {2,10};

Line(19) = {3,11};

Line(20) = {4,12};

Line(21) = {5,13};

Line(22) = {6,14};

Line(23) = {7,15};

Line(24) = {8,16};


Line Loop(2) = {1,-18,-9,17};
Plane Surface(2) = {2};

Line Loop(3) = {2,-19,-10,18};
Plane Surface(3) = {3};

Line Loop(4) = {3,-20,-11,19};
Plane Surface(4) = {4};

Line Loop(5) = {4,-21,-12,20};
Plane Surface(5) = {5};

Line Loop(6) = {5,-22,-13,21};
Plane Surface(6) = {6};

Line Loop(7) = {6,-23,-14,22};
Plane Surface(7) = {7};

Line Loop(8) = {7,-24,-15,23};
Plane Surface(8) = {8};

Line Loop(9) = {8,-17,-16,24};
Plane Surface(9) = {9};

Transfinite Surface {2,3,4,5,6,7,8,9};
Recombine Surface {1,2,3,4,5,6,7,8,9};

Transfinite Curve{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16} = 3;
Transfinite Curve{17,18,19,20,21,22,23,24} = 5 Using Progression 1.8;

//+
Rotate {{0, 1, 0}, {0, 0, 0}, Pi/2} {
  Point{2}; Point{3}; Point{10}; Point{11}; Point{1}; Point{9}; Point{4}; Point{12}; Point{17}; Point{16}; Point{8}; Point{13}; Point{5}; Point{15}; Point{14}; Point{7}; Point{6}; Curve{10}; Curve{18}; Curve{19}; Curve{2}; Curve{9}; Curve{1}; Curve{17}; Curve{11}; Curve{20}; Curve{3}; Curve{8}; Curve{16}; Curve{24}; Curve{4}; Curve{12}; Curve{21}; Curve{7}; Curve{6}; Curve{5}; Curve{15}; Curve{23}; Curve{22}; Curve{13}; Curve{14}; Surface{3}; Surface{2}; Surface{4}; Surface{9}; Surface{5}; Surface{1}; Surface{8}; Surface{6}; Surface{7}; 
}

Extrude {0.5,0,0}{
	Surface {1,2,3,4,5,6,7,8,9};
	Layers{25};
	Recombine;
}
//+
Coherence;

//+
Physical Surface("INLET") = {3, 4, 5, 6, 7, 8, 9, 2, 1};
//+
Physical Surface("OUTLET") = {154, 132, 110, 88, 242, 220, 198, 176, 66};
//+
Physical Surface("WALL") = {127, 105, 83, 237, 215, 193, 171, 149};
//+
Physical Volume("FLUID") = {1, 3, 4, 5, 6, 7, 8, 9, 2};
//+
//
// Mesh
Mesh.ElementOrder = 2;
Mesh.MshFileVersion = 2.16;
Mesh 3;
Save "pipe.msh";
