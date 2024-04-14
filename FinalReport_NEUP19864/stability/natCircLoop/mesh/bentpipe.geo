/*
    make bent pipe section
*/

//constants
PI=3.14159265359;


// Bent pipe settings
R = 0.03;   //Pipe radius
R_bend = 0.07; // bend radius 
L_str = 0.5;   //length of straight sections
L_hor = 0.2;   //length of horizontal section

N_in   = 10; // no. of elements in straight inlet
N_out  = 50; // no. of elements in straight outlet
N_hor  = 50; // no. of elements in horizontal section
N_bend = 20; // no. of elements in bends

// GRID SETTINGS ///////////////////////////////////////
//***** Geometrical parameters
// Note: r<RB<R
r=0.02;
RB=R*0.98; // R for boundary layer;   
th=PI/4.;  // theta
lambda=0.2;   //=R_{arc}/R
//f_in= (0.2/1.8);
//***** Grid Paramaters
Nc=4;  // no. of nodes (=#elem+1) in azimuthal direction
NB=1;   // no. of elemtns adjacent to the wall
NM=4;   // no. of nodes (=#elem+1) between the near wall layer and central square part
// compression ratios over the radial lines of the mesh
compressRatio_B=0.4;  //ratio of grid compression toward the wall (<1)
compressRatio_M=0.7;  //compression ratio in the middle layer
///////////////////////////////////////////////////

dx=r*Cos(th);
dy=r*Sin(th);
dxB=RB*Cos(th);
dyB=RB*Sin(th);
Dx=R*Cos(th);
Dy=R*Sin(th);

//***** define points coordinates
//auxiliary points (only help define the geometry)
Point(1) = {0, 0, 0, 1.0};
Point(2) = {0, 0, lambda*R, 1.0};
Point(3) = {0, -lambda*R, 0, 1.0};
Point(4) = {0, 0, -lambda*R, 1.0};
Point(5) = {0 , lambda*R, 0, 1.0};

//blocks vertices
Point(6)={0.0, dy, dx, 1.0};
Point(7)={0.0, -dy, dx, 1.0};
Point(8)={0.0,-dy, -dx, 1.0};
Point(9)={0.0, dy, -dx, 1.0};
Point(10)={0.0, dyB, dxB, 1.0};
Point(11)={0.0, -dyB, dxB, 1.0};
Point(12)={0.0,-dyB, -dxB, 1.0};
Point(13)={0.0, dyB, -dxB, 1.0};
Point(14)={0.0, Dy, Dx, 1.0};
Point(15)={0.0, -Dy, Dx, 1.0};
Point(16)={0.0,-Dy, -Dx, 1.0};
Point(17)={0.0, Dy, -Dx, 1.0};

//***** define lines and curves
Circle(1)={9, 3, 6};   //Circle()={startNode, circleCenter, endNode}
Circle(2)={6, 4, 7};   
Circle(3)={7, 5, 8};   
Circle(4)={8, 2, 9};   
Circle(5)={13, 1, 10};
Circle(6)={10, 1, 11};
Circle(7)={11, 1, 12};
Circle(8)={12, 1, 13};
Circle(9)={17, 1, 14};
Circle(10)={14, 1, 15};
Circle(11)={15, 1, 16};
Circle(12)={16, 1, 17};
Line(13)={6, 10};
Line(14)={7, 11};
Line(15)={8, 12};
Line(16)={9, 13};
Line(17)={10, 14};
Line(18)={11, 15};
Line(19)={12, 16};
Line(20)={13, 17};

//***** assign number of mesh on the created lines/arcs
Transfinite Line {1, 2, 3, 4} = Nc Using Bump 1.0;   
Transfinite Line {5, 6, 7, 8} = Nc;   
Transfinite Line {9, 10, 11, 12} = Nc;   
Transfinite Line {13, 14, 15, 16} = NM Using Progression compressRatio_M;  
Transfinite Line {17, 18, 19, 20} = NB Using Progression compressRatio_B;   //over the radial lines near the wall. Note: "For example Progression 2 meaning that each line element in the series will be twice as long as the preceding one)".

//***** create surfaces
// Note: use a negative sign if a line is swept in the opposite direction of the original definition
Line Loop(1)={1, 2, 3 ,   4};   Plane Surface(1)={1}; //central part of the mesh
Line Loop(2)={5, -13, -1, 16};  Plane Surface(2)={2}; 
Line Loop(3)={13, 6, -14 , -2}; Plane Surface(3)={3}; 
Line Loop(4)={-3, 14, 7, -15};  Plane Surface(4)={4}; 
Line Loop(5)={-16, -4, 15, 8};  Plane Surface(5)={5}; 
Line Loop(6)={9, -17, -5, 20};  Plane Surface(6)={6}; 
Line Loop(7)={17, 10, -18, -6}; Plane Surface(7)={7}; 
Line Loop(8)={-7, 18, 11, -19}; Plane Surface(8)={8}; 
Line Loop(9)={-8, 19, 12, -20}; Plane Surface(9)={9}; 

Recombine Surface "*";
Transfinite Surface "*";

// rotate so that inlet points in negative z direction
Rotate {{0, 1, 0}, {0, 1, 0}, Pi/2} {
  Point{16}; Point{12}; Point{8}; Point{3}; Point{4}; Point{15}; Point{11}; Point{7}; Point{1}; Point{9}; Point{13}; Point{17}; Point{2}; Point{5}; Point{6}; Point{10}; Point{14}; Curve{19}; Curve{15}; Curve{11}; Curve{7}; Curve{18}; Curve{14}; Curve{3}; Curve{4}; Curve{8}; Curve{16}; Curve{12}; Curve{20}; Curve{2}; Curve{1}; Curve{6}; Curve{5}; Curve{13}; Curve{9}; Curve{10}; Curve{17}; 
}

// inlet straight
Extrude {0, 0, -L_str} {
  Surface{1:9}; 
  Layers{N_in}; Recombine;
}

// bend
Extrude {{1, 0, 0}, {0, R_bend, -L_str}, Pi/2} {
  Surface{196}; Surface{108}; Surface{174}; Surface{86}; Surface{152}; Surface{64}; Surface{218}; Surface{130}; Surface{42};
  Layers{N_bend}; Recombine;
}

// bottom horizontal section
Extrude {0, L_hor, 0} {
  Surface{328}; Surface{350}; Surface{306}; Surface{416}; Surface{394}; Surface{284}; Surface{372}; Surface{262}; Surface{240};
  Layers{N_hor}; Recombine;
}

// bend
Extrude {{1, 0, 0}, {0, L_hor+ R_bend, -L_str}, Pi/2} {
  Surface{438}; Surface{460}; Surface{570}; Surface{482}; Surface{504}; Surface{526}; Surface{548}; Surface{592}; Surface{614};
  Layers{N_bend}; Recombine;
}

// outlet straight
Extrude {0, 0, L_str} {
  Surface{636}; Surface{658}; Surface{768}; Surface{702}; Surface{724}; Surface{746}; Surface{680}; Surface{790}; Surface{812};
  Layers{N_out}; Recombine;
}

// physical groups
Physical Surface("INLET") = {6, 7, 8, 9, 5, 2, 3, 4, 1};
Physical Surface("OUTLET") = {834, 856, 922, 966, 944, 1010, 988, 900,878};
Physical Surface("WALL") = {139, 213, 191, 165, 315, 367, 235, 275, 425, 565, 609, 539, 623, 759, 807, 675, 821, 869, 1005, 961};
Physical Volume("FLUID") = {1:45};


Coherence;

Mesh.ElementOrder = 2;
Mesh.MshFileVersion = 2.16;
Mesh 3;
Save "bentpipe.msh";

