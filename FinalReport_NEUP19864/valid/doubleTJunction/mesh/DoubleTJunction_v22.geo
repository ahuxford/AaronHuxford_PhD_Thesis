// Dimensions
L_extMain=0.22; // = main outlet extension
L_extSide=0.22; // = side outlet extension

L1=0.145;
L2=0.128;
Lmain=0.428;
SHIFT_LEFT=0.1;
R=0.025;
ratio=0.4;
ratio2=0.8;
ratio_wall=0.8;
R_constraint=R*ratio;
RB=R*ratio2;
R_wall=R*ratio_wall;

//+
SetFactory("OpenCASCADE");

N_core=3;    // #elements in the radial direction on the core of the main inlet (regularized based on Reynolds number and the length of the others)
N_middle=3;  // #elements in the radial direction in the intermediate (between the core and the wall region) of the main inlet (regularized based on Reynolds number and the length of the others)
N_wall=2;    // #elements in the radial direction towards the wall in the main inlet (regularized based on Reynolds number and the length of the others)
N_global=3;

//N_stream=10; // #elements in the streamwise of the main inlet (regularized based on Reynolds number and the length of the others)
N_stream_1=6; // between junctions, mainline streamwise
N_stream_2=20; // main outlet streamwise
N_stream_3=8; // side inlet streamwise
N_stream_4=20; // side outlet streamwise
N_main = 6;   // main line, ~ radial elements+1, WARNING, max value is possible 6, nek jacobian crashes otherwise

compress_main = 0.95;

compressRatio_B=0.5;  //ratio of grid compression toward the wall (<1)
compressRatio_M=0.85;  //compression ratio in the middle layer

pref=newp; Printf("pref =%g", pref);
Point(newp) = {0.0, 0.0, 0.0, 1.0};
Point(newp) = {-R_constraint*Cos(Pi/4), 0.0, R_constraint*Cos(Pi/4), 1.0};
Point(newp) = {-R_constraint, 0.0, 0, 1.0};
Point(newp) = {-R_wall*Cos(Pi/4), 0.0, R_wall*Cos(Pi/4), 1.0};
Point(newp) = {-R_wall, 0.0, 0, 1.0};
Point(newp) = {-R*Cos(Pi/4), 0.0, R*Cos(Pi/4), 1.0};
Point(newp) = {-R, 0.0, 0, 1.0};
Point(newp) = {RB*Cos(Pi/8), 0.0, -RB*Sin(Pi/8), 1.0};
//+
Point(newp) = {0.0, 0.0, R_constraint, 1.0};
Point(newp) = {0.0, 0.0, R_wall, 1.0};
Point(newp) = {0.0, 0.0, R, 1.0};
Point(newp) = {RB*Sin(Pi/8), 0.0, -RB*Cos(Pi/8), 1.0};
//+
Circle(1) = {11, 1, 6};
//+
Circle(2) = {6, 1, 7};
//+
Circle(3) = {10, 1, 4};
//+
Circle(4) = {4, 1, 5};
//+
Circle(5) = {2, 8, 3};
//+
Circle(6) = {9, 12, 2};
//+
Line(7) = {11, 10};
//+
Line(8) = {6, 4};
//+
Line(9) = {7, 5};
//+
Line(10) = {5, 3};
//+
Line(11) = {4, 2};
//+
Line(12) = {10, 9};
//+
Line(13) = {9, 1};
//+
Line(14) = {3, 1};
//+
Curve Loop(1) = {2, 9, -4, -8};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {8, -3, -7, 1};
//+
Plane Surface(2) = {2};
//+
Curve Loop(3) = {10, -5, -11, 4};
//+
Plane Surface(3) = {3};
//+
Curve Loop(4) = {6, -11, -3, 12};
//+
Plane Surface(4) = {4};
//+
Curve Loop(5) = {14, -13, 6, 5};
//+
Plane Surface(5) = {5};
//+
Cylinder(1) = {-SHIFT_LEFT, L1, 0, 2*L1, 0, 0, R*1.01, 2*Pi};
//+
Rotate {{0, 1, 0}, {0, 0, 0}, Pi/2} {
  Duplicata {Point{6}; Point{8}; Point{4}; Point{2}; Point{11}; Point{10}; Point{9}; Point{12};}
}
//+
Circle(18) = {19, 1, 15};
//+
Circle(19) = {15, 1, 11};
//+
Circle(20) = {20, 1, 17};
//+
Circle(21) = {17, 1, 10};
//+
Circle(22) = {21, 22, 18};
//+
Circle(23) = {18, 16, 9};
//+
Line(24) = {19, 20};
//+
Line(25) = {15, 17};
//+
Line(26) = {20, 21};
//+
Line(27) = {17, 18};
//+
Line(28) = {21, 1};
//+
Rotate {{0, 1, 0}, {0, L1, 0}, Pi/2} {
  Duplicata { Point{19}; Point{15}; Point{17}; Point{18}; Point{21}; Point{20}; Point{16}; Point{22}; }
}
//+
Circle(29) = {23, 1, 24};
//+
Circle(30) = {24, 1, 19};
//+
Circle(31) = {28, 1, 25};
//+
Circle(32) = {25, 1, 20};
//+
Circle(33) = {27, 30, 26};
//+
Circle(34) = {26, 29, 21};
//+
Line(35) = {23, 28};
//+
Line(36) = {28, 27};
//+
Line(37) = {24, 25};
//+
Line(38) = {25, 26};
//+
Rotate {{0, 1, 0}, {0, 0, 0}, Pi/2} {
  Duplicata { Point{29}; Point{30}; Point{26}; Point{27}; Point{24}; Point{25}; }
}
//+
Circle(39) = {23, 1, 35};
//+
Circle(40) = {35, 1, 7};
//+
Circle(41) = {28, 1, 36};
//+
Circle(42) = {36, 1, 5};
//+
Circle(43) = {27, 31, 33};
//+
Circle(44) = {33, 32, 3};
//+
Line(45) = {35, 36};
//+
Line(46) = {36, 33};
//+
Line(47) = {27, 1};
//+
Curve Loop(9) = {12, -23, -27, 21};
//+
Plane Surface(9) = {9};
//+
Curve Loop(10) = {22, 23, 13, -28};
//+
Plane Surface(10) = {10};
//+
Curve Loop(11) = {27, -22, -26, 20};
//+
Plane Surface(11) = {11};
//+
Curve Loop(12) = {21, -7, -19, 25};
//+
Plane Surface(12) = {12};
//+
Curve Loop(13) = {20, -25, -18, 24};
//+
Plane Surface(13) = {13};
//+
Curve Loop(14) = {32, -24, -30, 37};
//+
Plane Surface(14) = {14};
//+
Curve Loop(15) = {38, 34, -26, -32};
//+
Plane Surface(15) = {15};
//+
Curve Loop(16) = {31, 38, -33, -36};
//+
Plane Surface(16) = {16};
//+
Curve Loop(17) = {31, -37, -29, 35};
//+
Plane Surface(17) = {17};
//+
Curve Loop(18) = {39, 45, -41, -35};
//+
Plane Surface(18) = {18};
//+
Curve Loop(19) = {41, 46, -43, -36};
//+
Plane Surface(19) = {19};
//+
Curve Loop(20) = {42, 10, -44, -46};
//+
Plane Surface(20) = {20};
//+
Curve Loop(21) = {40, 9, -42, -45};
//+
Plane Surface(21) = {21};
//+
Curve Loop(22) = {28, -47, 33, 34};
//+
Plane Surface(22) = {22};
//+
Curve Loop(23) = {47, -14, -44, -43};
//+
Plane Surface(23) = {23};
//+
Extrude {0, L1, 0} {
  Surface{12}; Surface{13}; Surface{2}; Surface{9}; Surface{11}; Surface{4}; Surface{10}; Surface{1}; Surface{5}; Surface{14}; Surface{22}; Surface{15}; Surface{3}; Surface{23}; Surface{16}; Surface{17}; Surface{20}; Surface{21}; Surface{19}; Surface{18};
}
BooleanFragments{ Volume{2}; Delete; }{ Volume{1}; Delete;}
//+
BooleanFragments{ Volume{3}; Delete; }{ Volume{24}; Delete;}
//+
BooleanFragments{ Volume{4}; Delete; }{ Volume{26}; Delete;}
//+
BooleanFragments{ Volume{5}; Delete; }{ Volume{28}; Delete;}
//+
BooleanFragments{ Volume{6}; Delete; }{ Volume{30}; Delete;}
//+
BooleanFragments{ Volume{7}; Delete; }{ Volume{32}; Delete;}
//+
BooleanFragments{ Volume{8}; Delete; }{ Volume{34}; Delete;}
//+
BooleanFragments{ Volume{9}; Delete; }{ Volume{36}; Delete;}
//+
BooleanFragments{ Volume{10}; Delete; }{ Volume{38}; Delete;}
//+
BooleanFragments{ Volume{11}; Delete; }{ Volume{40}; Delete;}
//+
BooleanFragments{ Volume{12}; Delete; }{ Volume{42}; Delete;}
//+
BooleanFragments{ Volume{13}; Delete; }{ Volume{44}; Delete;}
//+
BooleanFragments{ Volume{14}; Delete; }{ Volume{46}; Delete;}
//+
BooleanFragments{ Volume{15}; Delete; }{ Volume{48}; Delete;}
//+
BooleanFragments{ Volume{16}; Delete; }{ Volume{50}; Delete;}
//+
BooleanFragments{ Volume{17}; Delete; }{ Volume{52}; Delete;}
//+
BooleanFragments{ Volume{18}; Delete; }{ Volume{54}; Delete;}
//+
BooleanFragments{ Volume{19}; Delete; }{ Volume{56}; Delete;}
//+
BooleanFragments{ Volume{20}; Delete; }{ Volume{58}; Delete;}
//+
BooleanFragments{ Volume{21}; Delete; }{ Volume{60}; Delete;}
//+
Extrude {0, L1, 0} {
  Surface{106}; Surface{136}; Surface{182}; Surface{202}; Surface{235}; Surface{227}; Surface{263}; Surface{271}; Surface{245}; Surface{254}; Surface{210}; Surface{164}; Surface{146}; Surface{117}; Surface{96}; Surface{127}; Surface{153}; Surface{192}; Surface{217}; Surface{173};
}
//+
BooleanFragments{ Volume{76}; Delete; }{ Volume{62}; Delete; }
//+
BooleanFragments{ Volume{75}; Delete; }{ Volume{85}; Delete; }
//+
BooleanFragments{ Volume{69}; Delete; }{ Volume{87}; Delete; }
//+
BooleanFragments{ Volume{70}; Delete; }{ Volume{89}; Delete; }
//+
BooleanFragments{ Volume{77}; Delete; }{ Volume{91}; Delete; }
//+
BooleanFragments{ Volume{78}; Delete; }{ Volume{93}; Delete; }
//+
BooleanFragments{ Volume{79}; Delete; }{ Volume{95}; Delete; }
//+
BooleanFragments{ Volume{80}; Delete; }{ Volume{97}; Delete; }
//+
BooleanFragments{ Volume{68}; Delete; }{ Volume{99}; Delete; }
//+
BooleanFragments{ Volume{67}; Delete; }{ Volume{101}; Delete; }
//+
BooleanFragments{ Volume{64}; Delete; }{ Volume{103}; Delete; }
//+
BooleanFragments{ Volume{63}; Delete; }{ Volume{105}; Delete; }
//+
BooleanFragments{ Volume{66}; Delete; }{ Volume{107}; Delete; }
//+
BooleanFragments{ Volume{65}; Delete; }{ Volume{109}; Delete; }
//+
BooleanFragments{ Volume{81}; Delete; }{ Volume{111}; Delete; }
//+
BooleanFragments{ Volume{82}; Delete; }{ Volume{113}; Delete; }
//+
BooleanFragments{ Volume{71}; Delete; }{ Volume{115}; Delete; }
//+
BooleanFragments{ Volume{72}; Delete; }{ Volume{117}; Delete; }
//+
BooleanFragments{ Volume{73}; Delete; }{ Volume{119}; Delete; }
//+
BooleanFragments{ Volume{74}; Delete; }{ Volume{121}; Delete; }
//+
//+
Recursive Delete {
  Volume{92}; Volume{84}; Volume{86}; Volume{94}; Volume{122}; Volume{106}; Volume{114}; Volume{96}; Volume{120}; Volume{104}; Volume{116}; Volume{108}; Volume{112}; Volume{98}; Volume{118}; Volume{110}; Volume{88}; Volume{100}; Volume{90}; Volume{102};
}
//+
Recursive Delete {
  Volume{123};
}
//+
//+
Extrude {-SHIFT_LEFT, 0, 0} {
  Surface{368}; Surface{481}; Surface{496}; Surface{342}; Surface{270}; Surface{253}; Surface{162}; Surface{118};
}
pref=newp; Printf("pref =%g", pref);
Point(newp) = {-SHIFT_LEFT, 0.0, 2*R, 1.0};
//+
Extrude {0, 2*L1, 0} {
  Point{154};
}
//+
Extrude {0, 0, -4*R} {
  Curve{543};
}
//+
//+
BooleanFragments{ Volume{129}; Volume{125}; Volume{128}; Volume{124}; Volume{123}; Volume{127}; Volume{122}; Volume{126}; Delete; }{ Surface{528}; Delete; }
//+
Recursive Delete {
  Volume{123}; Volume{125}; Volume{129}; Volume{127}; Volume{133}; Volume{131}; Volume{137}; Volume{135};
}
//+
Recursive Delete {
  Surface{554};
}
//+
Extrude {L2/2, 0, 0} {
  Surface{380}; Surface{438}; Surface{452}; Surface{422}; Surface{98}; Surface{108}; Surface{184}; Surface{237};
}
pref=newp; Printf("pref =%g", pref);
Point(newp) = {L2/2, 0.0, 2*R, 1.0};
//+
Extrude {0, 2*L1, 0} {
  Point{178};
}
//+
Extrude {0, 0, -4*R} {
  Curve{606};
}
//+
BooleanFragments{ Volume{141}; Volume{137}; Volume{142}; Volume{138}; Volume{143}; Volume{139}; Volume{140}; Volume{144}; Delete; }{ Surface{582}; Delete; }
//+
Recursive Delete {
  Volume{140}; Volume{138}; Volume{142}; Volume{144}; Volume{146}; Volume{148}; Volume{150}; Volume{152};
}
//+
Recursive Delete {
  Surface{608};
}
//+
//+
Symmetry {1, 0, 0, -L2/2} {
  Duplicata { Volume{137}; Volume{139}; Volume{27}; Volume{83}; Volume{91}; Volume{23}; Volume{93}; Volume{85}; Volume{33}; Volume{29}; Volume{25}; Volume{121}; Volume{141}; Volume{143}; Volume{37}; Volume{105}; Volume{113}; Volume{95}; Volume{39}; Volume{35}; Volume{47}; Volume{103}; Volume{119}; Volume{31}; Volume{45}; Volume{115}; Volume{55}; Volume{107}; Volume{43}; Volume{97}; Volume{49}; Volume{111}; Volume{57}; Volume{117}; Volume{41}; Volume{145}; Volume{109}; Volume{147}; Volume{99}; Volume{87}; Volume{59}; Volume{51}; Volume{101}; Volume{89}; Volume{61}; Volume{53}; Volume{149}; Volume{151}; }
}
//+
BooleanUnion{ Volume{139}; Delete; }{ Volume{153}; Delete; }
//+
//+
BooleanUnion{ Volume{137}; Delete; }{ Volume{152}; Delete; }
//+
BooleanUnion{ Volume{141}; Delete; }{ Volume{164}; Delete; }
//+
BooleanUnion{ Volume{145}; Delete; }{ Volume{187}; Delete; }
//+
BooleanUnion{ Volume{143}; Delete; }{ Volume{165}; Delete; }
//+
BooleanUnion{ Volume{147}; Delete; }{ Volume{189}; Delete; }
//+
BooleanUnion{ Volume{151}; Delete; }{ Volume{199}; Delete; }
//+
BooleanUnion{ Volume{149}; Delete; }{ Volume{198}; Delete; }
//+
pref=newp; Printf("pref =%g", pref);
Point(newp) = {L2/2, 0.0, 2*R, 1.0};
//+
Extrude {0, 2*L1, 0} {
  Point{1019};
}
//+
Extrude {0, 0, -4*R} {
  Curve{1888};
}
//+
BooleanFragments{ Volume{200}; Volume{201}; Volume{204}; Volume{202}; Volume{203}; Volume{205}; Volume{206}; Volume{207}; Delete; }{ Surface{1230}; Delete; }
//+
Recursive Delete {
  Surface{1230};
}
//+
Extrude {Lmain, 0, 0} {
  Surface{916}; Surface{960}; Surface{1092}; Surface{1152}; Surface{910}; Surface{978}; Surface{1086}; Surface{1158};
}
//+
pref=newp; Printf("pref =%g", pref);
Point(newp) = {Lmain-SHIFT_LEFT+L_extMain, 0.0, 2*R, 1.0};
//+
Extrude {0, 2*L1, 0} {
  Point{1001};
}
//+
Extrude {0, 0, -4*R} {
  Curve{1898};
}
//+
BooleanFragments{ Volume{214}; Volume{215}; Volume{218}; Volume{219}; Volume{216}; Volume{220}; Volume{217}; Volume{221}; Delete; }{ Surface{1270}; Delete; }
//+
Recursive Delete {
  Surface{1298};
}
//+
Recursive Delete {
  Volume{215}; Volume{217}; Volume{219}; Volume{221}; Volume{223}; Volume{225}; Volume{227}; Volume{229};
}
//+
Extrude {0, -L1-0.5, 0} {
  Surface{925}; Surface{907}; Surface{955}; Surface{1033}; Surface{949}; Surface{943}; Surface{1015}; Surface{979}; Surface{1009}; Surface{1003}; Surface{1099}; Surface{1039}; Surface{1063}; Surface{1075}; Surface{1051}; Surface{1087}; Surface{1165}; Surface{1141}; Surface{1135}; Surface{1159};
}
//+
pref=newp; Printf("pref =%g", pref);
Point(newp) = {L2+2*R, -0.1-L_extSide, 2*R, 1.0};
//+
//+
Extrude {-4*R, 0, 0} {
  Point{1089};
}
//+
Extrude {0, 0, -4*R} {
  Curve{2087};
}
//+
BooleanFragments{ Volume{230}; Volume{229}; Volume{234}; Volume{233}; Volume{236}; Volume{238}; Volume{231}; Volume{237}; Volume{235}; Volume{232}; Volume{243}; Volume{240}; Volume{242}; Volume{244}; Volume{241}; Volume{239}; Volume{247}; Volume{246}; Volume{248}; Volume{245}; Delete; }{ Surface{1395}; Delete; }
//+
Recursive Delete {
  Volume{230}; Volume{232}; Volume{236}; Volume{234}; Volume{242}; Volume{238}; Volume{244}; Volume{240}; Volume{246}; Volume{248}; Volume{250}; Volume{252}; Volume{254}; Volume{258}; Volume{256}; Volume{260}; Volume{262}; Volume{264}; Volume{268}; Volume{266};
}
//+
Recursive Delete {
  Surface{1443};
}
//+
Coherence;
//+
Transfinite Curve {122, 128, 2074, 2076, 2079, 361, 2091, 2094, 2096, 2104, 2106, 508, 511, 513, 521, 523, 2133, 1760, 1903, 1763, 1764, 1778, 1780, 1911, 117, 359, 358, 1898, 7, 52, 2128, 2132, 1909, 1900, 1901, 1908, 126, 121, 2131, 1915, 360, 2089, 2090, 1918, 1919, 1922, 2092, 1924, 123, 1779, 2093, 1777, 1776, 1767, 1766, 125, 2095, 1765, 2102, 1906, 2103, 129, 130, 2105, 1897, 401, 402, 1902, 1762, 1761, 356, 506, 2138, 507, 2136, 509, 510, 512, 519, 148, 520, 522, 151, 152, 2078, 2077, 2075, 1910, 120, 1895, 2129, 1840, 1838, 1839, 55, 1899, 1837, 2130, 1916, 1917, 50, 25, 21, 118, 63, 1920, 1836, 2134, 1894, 64, 354, 1921, 355, 150, 1914, 1896, 1923, 124, 2135, 2137, 1913, 1912, 1892, 2127, 357, 2126, 119, 398, 1904, 1905, 146, 143, 1893, 127, 1907, 400, 399, 371, 1941, 2139, 1842, 1925, 1926, 1927, 1940, 369, 67, 160, 1841, 154, 2140, 367, 368, 370, 408, 409, 410, 1945, 1944, 1943, 1942, 1939, 175, 172, 1938, 170, 161, 1937, 1936, 1935, 1934, 1844, 158, 156, 1933, 1932, 1931, 1930, 69, 70, 1929, 1928, 75, 76, 2141, 2142, 2143, 2144, 2145, 2146, 1851, 1850, 1849, 1845, 1843, 1997, 1996, 1995, 1994, 1998, 494, 99, 1874, 87, 86, 132, 136, 137, 139, 140, 141, 84, 83, 79, 78, 73, 72, 60, 57, 2166, 2165, 1862, 164, 166, 168, 1861, 179, 180, 182, 185, 188, 189, 191, 192, 193, 195, 198, 200, 1993, 1992, 1991, 1990, 1989, 1988, 1987, 1860, 1986, 1985, 1859, 1984, 227, 1983, 1858, 1857, 1982, 1981, 1980, 1979, 1978, 1977, 1976, 1975, 1974, 1973, 1972, 1971, 1970, 1969, 1968, 1967, 1966, 2080, 2081, 2082, 2097, 2098, 1965, 1964, 1963, 1856, 1962, 1961, 1960, 1959, 1958, 1957, 1956, 1955, 1954, 2099, 2100, 2101, 1855, 1854, 2107, 1853, 1852, 415, 416, 417, 418, 419, 1953, 1952, 2164, 2163, 1951, 1950, 1949, 1948, 1947, 1946, 447, 448, 449, 454, 455, 456, 2108, 2109, 473, 474, 2162, 480, 485, 1848, 487, 492, 1847, 500, 505, 527, 528, 529, 531, 537, 539, 1846, 2161, 2147, 2148, 1786, 1787, 1788, 1789, 1790, 1796, 1797, 1798, 2149, 2150, 2151, 2152, 2153, 2154, 2155, 2156, 2157, 2158, 1831, 1832, 1833, 1834, 1835, 2159, 2160, 475, 427, 426, 379, 237, 235, 220, 216, 2023, 2020, 2169, 2019, 2018, 1870, 2014, 1872, 2013, 97, 1875, 2010, 1877, 101, 2005, 2000, 2171, 2172, 2173, 2003, 2183, 2179, 2178, 2177, 234, 219, 217, 214, 2030, 102, 382, 383, 1876, 96, 1871, 1869, 1868, 94, 424, 425, 2025, 2026, 2027, 2028, 2029, 2031, 2032, 2033, 2034, 2035, 1886, 1863, 1885, 2024, 486, 2022, 462, 2021, 89, 2017, 434, 2016, 432, 1864, 2015, 2167, 1873, 2012, 2011, 2168, 98, 380, 2009, 2008, 376, 2007, 2006, 2170, 2004, 2002, 2001, 1999, 260, 258, 255, 110, 111, 202, 209, 2174, 2175, 1884, 2176, 222, 2040, 2186, 211, 210, 2185, 207, 206, 2184, 1887, 114, 2182, 2181, 2180, 263, 1888, 266, 268, 1889, 269, 2083, 1867, 1866, 1865, 388, 391, 439, 92, 440, 467, 493, 543, 544, 545, 546, 547, 553, 554, 555, 2036, 2037, 2038, 2039, 2041, 2042, 2043, 2044, 2045, 2046, 2047, 2048, 2049, 2050, 2051, 1814, 1813, 1812, 2117, 2116, 2115, 2114, 2113, 2112, 2111, 2110, 1806, 1805, 1804, 1803, 1802, 2085, 2084, 242, 2190, 2189, 2188, 2187, 244, 115, 105, 104, 1890, 271, 1880, 1879, 1878, 377, 378, 381, 433, 239, 2052, 2053, 2062, 2061, 2060, 2059, 2058, 2057, 2054, 2055, 2056, 2121, 2122, 2123, 2124, 2125, 2120, 2119, 2118, 2063, 2064, 1818, 2065, 1819, 2066, 561, 560, 559, 2067, 441, 1820, 2068, 1821, 2069, 1822, 392, 1828, 568, 1829, 390, 1830, 389, 567, 2070, 2071, 2072, 281, 2073, 562, 563, 1881, 277, 1882, 1883, 1891, 108, 253, 252, 566, 250, 249, 2088, 2087, 2086, 2191, 2192, 2193, 2194} = N_global Using Progression 1;

Transfinite Curve {1857, 1836, 7, 25, 1834, 1866, 1882, 1889} = N_global Using Progression 1;


Transfinite Curve {508, 513, 523, 506, 509, 519, 537, 529, 527, 553, 547, 544, 563, 560, 566} = N_stream_1 Using Progression 1;
//+
Transfinite Curve {122, 117, 125, 1838, 119, 1837, 1842, 1845, 1850, 1848, 1835, 1861, 1859, 1856, 1854, 1832, 1872, 1877, 1871, 1885, 1864, 1888, 1867, 1879, 1883} = N_stream_3 Using Progression 1/1.05;
//+
Transfinite Curve {1760, 1763, 1778, 1762, 1767, 1776, 1796, 1790, 1787, 1814, 1804, 1802, 1820, 1818, 1830} = N_stream_1 Using Progression 1;
//+
Transfinite Curve {2079, 2074, 2076, 2078, 2075, 2077, 2082, 2080, 2081, 2083, 2084, 2085, 2086, 2087, 2088} = N_stream_1 Using Progression 1;
//+
Transfinite Curve {2133, 2128, 2129, 2138, 2126, 2134, 2139, 2141, 2145, 2147, 2150, 2162, 2161, 2157, 2152, 2155, 2172, 2169, 2177, 2167, 2174, 2180, 2184, 2187, 2191} = N_stream_4 Using Progression 1.05;
//+
Transfinite Curve {2091, 2096, 2104, 2102, 2089, 2092, 2099, 2107, 2097, 2115, 2114, 2111, 2122, 2119, 2123} = N_stream_2 Using Progression 1.05;

Transfinite Curve {562, 538, 521, 568, 530, 511} = N_main Using Progression 1;
//+
Transfinite Curve {538, 520, 546} = N_main Using Progression 1/compress_main;
Transfinite Curve {530, 555, 510} = N_main Using Progression compress_main;


Transfinite Curve {126, 160, 182, 219, 244} = N_main Using Progression 1/compress_main;
//+
Transfinite Curve {356, 492, 388, 378, 383, 419, 369, 358} = N_main Using Progression compress_main;
Transfinite Curve {151, 191, 269} = N_main Using Progression 1/compress_main;

Transfinite Curve {130, 141, 211} = N_main Using Progression 1/compress_main;
Transfinite Curve {456, 440, 402} = N_main Using Progression compress_main;
//+
Transfinite Curve {1779, 1798, 1805} = N_main Using Progression 1/compress_main;
//+
Transfinite Curve {1765, 1789, 1813} = N_main Using Progression compress_main;

// set flat side to no progression
Transfinite Curve {1911, 1903, 1764, 1780, 361, 128, 2067, 2071, 1829, 1821, 390, 253} = N_main Using Progression 1;

Transfinite Curve {1924, 1953, 2048, 2060, 2028, 1986, 1940, 1900} = N_main Using Progression 1/compress_main;
//+
Transfinite Curve {2051, 1971, 1919, 2054, 2031, 1973, 1926, 1908} = N_main Using Progression compress_main;


//+
Transfinite Curve {2042, 1955, 1906} = N_main Using Progression compress_main;
Transfinite Curve {1895, 1963, 2038} = N_main Using Progression 1/compress_main;

Transfinite Curve {2094, 2106, 2121, 2125} = N_main Using Progression 1;
//+
Transfinite Curve {2113, 2100, 2093} = N_main Using Progression 1/compress_main;
Transfinite Curve {2117, 2109, 2105} = N_main Using Progression compress_main;

Transfinite Curve {432, 449, 399, 409, 416, 427} = N_main Using Progression compress_main;
//+
Transfinite Curve {485, 354, 367, 474, 379, 376} = N_main Using Progression compress_main;

Transfinite Curve {260, 237, 193, 200, 150, 175, 127, 139, 209, 220, 168, 161} = N_main Using Progression 1/compress_main;

Transfinite Curve {2002, 2000, 1991, 1948, 1921, 1945, 2016, 2019, 1987, 1966, 1893, 1939} = N_main Using Progression 1/compress_main;
Transfinite Curve {2022, 1968, 1914, 1931, 1982, 2020, 1904, 1934, 1975, 1959, 2009, 2014} = N_main Using Progression compress_main;

Transfinite Surface {88};Transfinite Surface {89};Transfinite Surface {90};Transfinite Surface {91};Transfinite Surface {92};Transfinite Surface {93};Recombine Surface {88,89,90,91,92,93};Transfinite Volume {22};Transfinite Surface {91};Transfinite Surface {94};Transfinite Surface {95};Transfinite Surface {96};Transfinite Surface {97};Transfinite Surface {98};Recombine Surface {91,94,95,96,97,98};Transfinite Volume {23};Transfinite Surface {92};Transfinite Surface {102};Transfinite Surface {1227};Transfinite Surface {1228};Transfinite Surface {1229};Transfinite Surface {1230};Recombine Surface {92,102,1227,1228,1229,1230};Transfinite Volume {24};Transfinite Surface {97};Transfinite Surface {102};Transfinite Surface {105};Transfinite Surface {106};Transfinite Surface {107};Transfinite Surface {108};Recombine Surface {97,102,105,106,107,108};Transfinite Volume {25};Transfinite Surface {90};Transfinite Surface {112};Transfinite Surface {1231};Transfinite Surface {1232};Transfinite Surface {1233};Transfinite Surface {1234};Recombine Surface {90,112,1231,1232,1233,1234};Transfinite Volume {26};Transfinite Surface {95};Transfinite Surface {112};Transfinite Surface {115};Transfinite Surface {116};Transfinite Surface {117};Transfinite Surface {118};Recombine Surface {95,112,115,116,117,118};Transfinite Volume {27};Transfinite Surface {88};Transfinite Surface {122};Transfinite Surface {1235};Transfinite Surface {1236};Transfinite Surface {1237};Transfinite Surface {1238};Recombine Surface {88,122,1235,1236,1237,1238};Transfinite Volume {28};Transfinite Surface {94};Transfinite Surface {122};Transfinite Surface {125};Transfinite Surface {126};Transfinite Surface {127};Transfinite Surface {128};Recombine Surface {94,122,125,126,127,128};Transfinite Volume {29};Transfinite Surface {132};Transfinite Surface {1227};Transfinite Surface {1238};Transfinite Surface {1239};Transfinite Surface {1240};Transfinite Surface {1241};Recombine Surface {132,1227,1238,1239,1240,1241};Transfinite Volume {30};Transfinite Surface {105};Transfinite Surface {128};Transfinite Surface {132};Transfinite Surface {135};Transfinite Surface {136};Transfinite Surface {137};Recombine Surface {105,128,132,135,136,137};Transfinite Volume {31};Transfinite Surface {141};Transfinite Surface {1233};Transfinite Surface {1235};Transfinite Surface {1242};Transfinite Surface {1243};Transfinite Surface {1244};Recombine Surface {141,1233,1235,1242,1243,1244};Transfinite Volume {32};Transfinite Surface {116};Transfinite Surface {125};Transfinite Surface {141};Transfinite Surface {144};Transfinite Surface {145};Transfinite Surface {146};Recombine Surface {116,125,141,144,145,146};Transfinite Volume {33};Transfinite Surface {150};Transfinite Surface {1237};Transfinite Surface {1240};Transfinite Surface {1245};Transfinite Surface {1246};Transfinite Surface {1247};Recombine Surface {150,1237,1240,1245,1246,1247};Transfinite Volume {34};Transfinite Surface {126};Transfinite Surface {135};Transfinite Surface {150};Transfinite Surface {153};Transfinite Surface {154};Transfinite Surface {155};Recombine Surface {126,135,150,153,154,155};Transfinite Volume {35};Transfinite Surface {159};Transfinite Surface {1231};Transfinite Surface {1248};Transfinite Surface {1249};Transfinite Surface {1250};Transfinite Surface {1251};Recombine Surface {159,1231,1248,1249,1250,1251};Transfinite Volume {36};Transfinite Surface {115};Transfinite Surface {159};Transfinite Surface {162};Transfinite Surface {163};Transfinite Surface {164};Transfinite Surface {165};Recombine Surface {115,159,162,163,164,165};Transfinite Volume {37};Transfinite Surface {169};Transfinite Surface {1242};Transfinite Surface {1247};Transfinite Surface {1252};Transfinite Surface {1253};Transfinite Surface {1254};Recombine Surface {169,1242,1247,1252,1253,1254};Transfinite Volume {38};Transfinite Surface {144};Transfinite Surface {155};Transfinite Surface {169};Transfinite Surface {172};Transfinite Surface {173};Transfinite Surface {174};Recombine Surface {144,155,169,172,173,174};Transfinite Volume {39};Transfinite Surface {178};Transfinite Surface {1229};Transfinite Surface {1255};Transfinite Surface {1256};Transfinite Surface {1257};Transfinite Surface {1258};Recombine Surface {178,1229,1255,1256,1257,1258};Transfinite Volume {40};Transfinite Surface {107};Transfinite Surface {178};Transfinite Surface {181};Transfinite Surface {182};Transfinite Surface {183};Transfinite Surface {184};Recombine Surface {107,178,181,182,183,184};Transfinite Volume {41};Transfinite Surface {188};Transfinite Surface {1246};Transfinite Surface {1259};Transfinite Surface {1260};Transfinite Surface {1261};Transfinite Surface {1262};Recombine Surface {188,1246,1259,1260,1261,1262};Transfinite Volume {42};Transfinite Surface {154};Transfinite Surface {188};Transfinite Surface {191};Transfinite Surface {192};Transfinite Surface {193};Transfinite Surface {194};Recombine Surface {154,188,191,192,193,194};Transfinite Volume {43};Transfinite Surface {198};Transfinite Surface {1241};Transfinite Surface {1255};Transfinite Surface {1261};Transfinite Surface {1263};Transfinite Surface {1264};Recombine Surface {198,1241,1255,1261,1263,1264};Transfinite Volume {44};Transfinite Surface {137};Transfinite Surface {181};Transfinite Surface {193};Transfinite Surface {198};Transfinite Surface {201};Transfinite Surface {202};Recombine Surface {137,181,193,198,201,202};Transfinite Volume {45};Transfinite Surface {206};Transfinite Surface {1244};Transfinite Surface {1251};Transfinite Surface {1254};Transfinite Surface {1265};Transfinite Surface {1266};Recombine Surface {206,1244,1251,1254,1265,1266};Transfinite Volume {46};Transfinite Surface {145};Transfinite Surface {165};Transfinite Surface {174};Transfinite Surface {206};Transfinite Surface {209};Transfinite Surface {210};Recombine Surface {145,165,174,206,209,210};Transfinite Volume {47};Transfinite Surface {214};Transfinite Surface {1252};Transfinite Surface {1260};Transfinite Surface {1267};Transfinite Surface {1268};Transfinite Surface {1269};Recombine Surface {214,1252,1260,1267,1268,1269};Transfinite Volume {48};Transfinite Surface {172};Transfinite Surface {191};Transfinite Surface {214};Transfinite Surface {217};Transfinite Surface {218};Transfinite Surface {219};Recombine Surface {172,191,214,217,218,219};Transfinite Volume {49};Transfinite Surface {223};Transfinite Surface {1262};Transfinite Surface {1263};Transfinite Surface {1270};Transfinite Surface {1271};Transfinite Surface {1272};Recombine Surface {223,1262,1263,1270,1271,1272};Transfinite Volume {50};Transfinite Surface {194};Transfinite Surface {201};Transfinite Surface {223};Transfinite Surface {226};Transfinite Surface {227};Transfinite Surface {228};Recombine Surface {194,201,223,226,227,228};Transfinite Volume {51};Transfinite Surface {232};Transfinite Surface {1257};Transfinite Surface {1270};Transfinite Surface {1273};Transfinite Surface {1274};Transfinite Surface {1275};Recombine Surface {232,1257,1270,1273,1274,1275};Transfinite Volume {52};Transfinite Surface {183};Transfinite Surface {226};Transfinite Surface {232};Transfinite Surface {235};Transfinite Surface {236};Transfinite Surface {237};Recombine Surface {183,226,232,235,236,237};Transfinite Volume {53};Transfinite Surface {241};Transfinite Surface {1265};Transfinite Surface {1269};Transfinite Surface {1276};Transfinite Surface {1277};Transfinite Surface {1278};Recombine Surface {241,1265,1269,1276,1277,1278};Transfinite Volume {54};Transfinite Surface {209};Transfinite Surface {219};Transfinite Surface {241};Transfinite Surface {244};Transfinite Surface {245};Transfinite Surface {246};Recombine Surface {209,219,241,244,245,246};Transfinite Volume {55};Transfinite Surface {250};Transfinite Surface {1250};Transfinite Surface {1276};Transfinite Surface {1279};Transfinite Surface {1280};Transfinite Surface {1281};Recombine Surface {250,1250,1276,1279,1280,1281};Transfinite Volume {56};Transfinite Surface {163};Transfinite Surface {244};Transfinite Surface {250};Transfinite Surface {253};Transfinite Surface {254};Transfinite Surface {255};Recombine Surface {163,244,250,253,254,255};Transfinite Volume {57};Transfinite Surface {259};Transfinite Surface {1268};Transfinite Surface {1272};Transfinite Surface {1278};Transfinite Surface {1282};Transfinite Surface {1283};Recombine Surface {259,1268,1272,1278,1282,1283};Transfinite Volume {58};Transfinite Surface {218};Transfinite Surface {228};Transfinite Surface {246};Transfinite Surface {259};Transfinite Surface {262};Transfinite Surface {263};Recombine Surface {218,228,246,259,262,263};Transfinite Volume {59};Transfinite Surface {267};Transfinite Surface {1274};Transfinite Surface {1281};Transfinite Surface {1282};Transfinite Surface {1284};Transfinite Surface {1285};Recombine Surface {267,1274,1281,1282,1284,1285};Transfinite Volume {60};Transfinite Surface {236};Transfinite Surface {255};Transfinite Surface {262};Transfinite Surface {267};Transfinite Surface {270};Transfinite Surface {271};Recombine Surface {236,255,262,267,270,271};Transfinite Volume {61};Transfinite Surface {117};Transfinite Surface {339};Transfinite Surface {340};Transfinite Surface {341};Transfinite Surface {342};Transfinite Surface {343};Recombine Surface {117,339,340,341,342,343};Transfinite Volume {83};Transfinite Surface {146};Transfinite Surface {340};Transfinite Surface {349};Transfinite Surface {350};Transfinite Surface {351};Transfinite Surface {352};Recombine Surface {146,340,349,350,351,352};Transfinite Volume {85};Transfinite Surface {263};Transfinite Surface {358};Transfinite Surface {359};Transfinite Surface {360};Transfinite Surface {361};Transfinite Surface {362};Recombine Surface {263,358,359,360,361,362};Transfinite Volume {87};Transfinite Surface {271};Transfinite Surface {358};Transfinite Surface {368};Transfinite Surface {369};Transfinite Surface {370};Transfinite Surface {371};Recombine Surface {271,358,368,369,370,371};Transfinite Volume {89};Transfinite Surface {96};Transfinite Surface {343};Transfinite Surface {377};Transfinite Surface {378};Transfinite Surface {379};Transfinite Surface {380};Recombine Surface {96,343,377,378,379,380};Transfinite Volume {91};Transfinite Surface {127};Transfinite Surface {352};Transfinite Surface {377};Transfinite Surface {386};Transfinite Surface {387};Transfinite Surface {388};Recombine Surface {127,352,377,386,387,388};Transfinite Volume {93};Transfinite Surface {153};Transfinite Surface {386};Transfinite Surface {394};Transfinite Surface {395};Transfinite Surface {396};Transfinite Surface {397};Recombine Surface {153,386,394,395,396,397};Transfinite Volume {95};Transfinite Surface {192};Transfinite Surface {396};Transfinite Surface {403};Transfinite Surface {404};Transfinite Surface {405};Transfinite Surface {406};Recombine Surface {192,396,403,404,405,406};Transfinite Volume {97};Transfinite Surface {227};Transfinite Surface {361};Transfinite Surface {406};Transfinite Surface {412};Transfinite Surface {413};Transfinite Surface {414};Recombine Surface {227,361,406,412,413,414};Transfinite Volume {99};Transfinite Surface {235};Transfinite Surface {371};Transfinite Surface {412};Transfinite Surface {420};Transfinite Surface {421};Transfinite Surface {422};Recombine Surface {235,371,412,420,421,422};Transfinite Volume {101};Transfinite Surface {136};Transfinite Surface {388};Transfinite Surface {394};Transfinite Surface {428};Transfinite Surface {429};Transfinite Surface {430};Recombine Surface {136,388,394,428,429,430};Transfinite Volume {103};Transfinite Surface {106};Transfinite Surface {379};Transfinite Surface {429};Transfinite Surface {436};Transfinite Surface {437};Transfinite Surface {438};Recombine Surface {106,379,429,436,437,438};Transfinite Volume {105};Transfinite Surface {202};Transfinite Surface {405};Transfinite Surface {413};Transfinite Surface {430};Transfinite Surface {444};Transfinite Surface {445};Recombine Surface {202,405,413,430,444,445};Transfinite Volume {107};Transfinite Surface {182};Transfinite Surface {420};Transfinite Surface {437};Transfinite Surface {445};Transfinite Surface {451};Transfinite Surface {452};Recombine Surface {182,420,437,445,451,452};Transfinite Volume {109};Transfinite Surface {217};Transfinite Surface {362};Transfinite Surface {403};Transfinite Surface {458};Transfinite Surface {459};Transfinite Surface {460};Recombine Surface {217,362,403,458,459,460};Transfinite Volume {111};Transfinite Surface {173};Transfinite Surface {349};Transfinite Surface {397};Transfinite Surface {458};Transfinite Surface {466};Transfinite Surface {467};Recombine Surface {173,349,397,458,466,467};Transfinite Volume {113};Transfinite Surface {245};Transfinite Surface {359};Transfinite Surface {460};Transfinite Surface {473};Transfinite Surface {474};Transfinite Surface {475};Recombine Surface {245,359,460,473,474,475};Transfinite Volume {115};Transfinite Surface {254};Transfinite Surface {369};Transfinite Surface {473};Transfinite Surface {481};Transfinite Surface {482};Transfinite Surface {483};Recombine Surface {254,369,473,481,482,483};Transfinite Volume {117};Transfinite Surface {210};Transfinite Surface {350};Transfinite Surface {467};Transfinite Surface {474};Transfinite Surface {489};Transfinite Surface {490};Recombine Surface {210,350,467,474,489,490};Transfinite Volume {119};Transfinite Surface {164};Transfinite Surface {339};Transfinite Surface {482};Transfinite Surface {490};Transfinite Surface {496};Transfinite Surface {497};Recombine Surface {164,339,482,490,496,497};Transfinite Volume {121};Transfinite Surface {118};Transfinite Surface {498};Transfinite Surface {499};Transfinite Surface {500};Transfinite Surface {501};Transfinite Surface {502};Recombine Surface {118,498,499,500,501,502};Transfinite Volume {122};Transfinite Surface {342};Transfinite Surface {502};Transfinite Surface {507};Transfinite Surface {508};Transfinite Surface {509};Transfinite Surface {510};Recombine Surface {342,502,507,508,509,510};Transfinite Volume {124};Transfinite Surface {162};Transfinite Surface {499};Transfinite Surface {514};Transfinite Surface {515};Transfinite Surface {516};Transfinite Surface {517};Recombine Surface {162,499,514,515,516,517};Transfinite Volume {126};Transfinite Surface {496};Transfinite Surface {507};Transfinite Surface {517};Transfinite Surface {522};Transfinite Surface {523};Transfinite Surface {524};Recombine Surface {496,507,517,522,523,524};Transfinite Volume {128};Transfinite Surface {481};Transfinite Surface {522};Transfinite Surface {528};Transfinite Surface {529};Transfinite Surface {530};Transfinite Surface {531};Recombine Surface {481,522,528,529,530,531};Transfinite Volume {130};Transfinite Surface {253};Transfinite Surface {515};Transfinite Surface {528};Transfinite Surface {536};Transfinite Surface {537};Transfinite Surface {538};Recombine Surface {253,515,528,536,537,538};Transfinite Volume {132};Transfinite Surface {368};Transfinite Surface {530};Transfinite Surface {542};Transfinite Surface {543};Transfinite Surface {544};Transfinite Surface {545};Recombine Surface {368,530,542,543,544,545};Transfinite Volume {134};Transfinite Surface {270};Transfinite Surface {537};Transfinite Surface {542};Transfinite Surface {549};Transfinite Surface {550};Transfinite Surface {551};Recombine Surface {270,537,542,549,550,551};Transfinite Volume {136};Transfinite Surface {1286};Transfinite Surface {1287};Transfinite Surface {1288};Transfinite Surface {1289};Transfinite Surface {1290};Transfinite Surface {1291};Recombine Surface {1286,1287,1288,1289,1290,1291};Transfinite Volume {154};Transfinite Surface {1289};Transfinite Surface {1292};Transfinite Surface {1293};Transfinite Surface {1294};Transfinite Surface {1295};Transfinite Surface {1296};Recombine Surface {1289,1292,1293,1294,1295,1296};Transfinite Volume {155};Transfinite Surface {1296};Transfinite Surface {1297};Transfinite Surface {1298};Transfinite Surface {1299};Transfinite Surface {1300};Transfinite Surface {1301};Recombine Surface {1296,1297,1298,1299,1300,1301};Transfinite Volume {156};Transfinite Surface {1291};Transfinite Surface {1298};Transfinite Surface {1302};Transfinite Surface {1303};Transfinite Surface {1304};Transfinite Surface {1305};Recombine Surface {1291,1298,1302,1303,1304,1305};Transfinite Volume {157};Transfinite Surface {1297};Transfinite Surface {1306};Transfinite Surface {1307};Transfinite Surface {1308};Transfinite Surface {1309};Transfinite Surface {1310};Recombine Surface {1297,1306,1307,1308,1309,1310};Transfinite Volume {158};Transfinite Surface {1293};Transfinite Surface {1306};Transfinite Surface {1311};Transfinite Surface {1312};Transfinite Surface {1313};Transfinite Surface {1314};Recombine Surface {1293,1306,1311,1312,1313,1314};Transfinite Volume {159};Transfinite Surface {1288};Transfinite Surface {1312};Transfinite Surface {1315};Transfinite Surface {1316};Transfinite Surface {1317};Transfinite Surface {1318};Recombine Surface {1288,1312,1315,1316,1317,1318};Transfinite Volume {160};Transfinite Surface {1302};Transfinite Surface {1307};Transfinite Surface {1318};Transfinite Surface {1319};Transfinite Surface {1320};Transfinite Surface {1321};Recombine Surface {1302,1307,1318,1319,1320,1321};Transfinite Volume {161};Transfinite Surface {1304};Transfinite Surface {1322};Transfinite Surface {1323};Transfinite Surface {1324};Transfinite Surface {1325};Transfinite Surface {1326};Recombine Surface {1304,1322,1323,1324,1325,1326};Transfinite Volume {162};Transfinite Surface {1292};Transfinite Surface {1327};Transfinite Surface {1328};Transfinite Surface {1329};Transfinite Surface {1330};Transfinite Surface {1331};Recombine Surface {1292,1327,1328,1329,1330,1331};Transfinite Volume {163};Transfinite Surface {1286};Transfinite Surface {1328};Transfinite Surface {1332};Transfinite Surface {1333};Transfinite Surface {1334};Transfinite Surface {1335};Recombine Surface {1286,1328,1332,1333,1334,1335};Transfinite Volume {166};Transfinite Surface {1300};Transfinite Surface {1324};Transfinite Surface {1336};Transfinite Surface {1337};Transfinite Surface {1338};Transfinite Surface {1339};Recombine Surface {1300,1324,1336,1337,1338,1339};Transfinite Volume {167};Transfinite Surface {1311};Transfinite Surface {1340};Transfinite Surface {1341};Transfinite Surface {1342};Transfinite Surface {1343};Transfinite Surface {1344};Recombine Surface {1311,1340,1341,1342,1343,1344};Transfinite Volume {168};Transfinite Surface {1308};Transfinite Surface {1342};Transfinite Surface {1345};Transfinite Surface {1346};Transfinite Surface {1347};Transfinite Surface {1348};Recombine Surface {1308,1342,1345,1346,1347,1348};Transfinite Volume {169};Transfinite Surface {1315};Transfinite Surface {1341};Transfinite Surface {1349};Transfinite Surface {1350};Transfinite Surface {1351};Transfinite Surface {1352};Recombine Surface {1315,1341,1349,1350,1351,1352};Transfinite Volume {170};Transfinite Surface {1320};Transfinite Surface {1346};Transfinite Surface {1351};Transfinite Surface {1353};Transfinite Surface {1354};Transfinite Surface {1355};Recombine Surface {1320,1346,1351,1353,1354,1355};Transfinite Volume {171};Transfinite Surface {1317};Transfinite Surface {1335};Transfinite Surface {1352};Transfinite Surface {1356};Transfinite Surface {1357};Transfinite Surface {1358};Recombine Surface {1317,1335,1352,1356,1357,1358};Transfinite Volume {172};Transfinite Surface {1310};Transfinite Surface {1336};Transfinite Surface {1345};Transfinite Surface {1359};Transfinite Surface {1360};Transfinite Surface {1361};Recombine Surface {1310,1336,1345,1359,1360,1361};Transfinite Volume {173};Transfinite Surface {1313};Transfinite Surface {1331};Transfinite Surface {1344};Transfinite Surface {1358};Transfinite Surface {1362};Transfinite Surface {1363};Recombine Surface {1313,1331,1344,1358,1362,1363};Transfinite Volume {174};Transfinite Surface {1321};Transfinite Surface {1322};Transfinite Surface {1353};Transfinite Surface {1359};Transfinite Surface {1364};Transfinite Surface {1365};Recombine Surface {1321,1322,1353,1359,1364,1365};Transfinite Volume {175};Transfinite Surface {1365};Transfinite Surface {1366};Transfinite Surface {1367};Transfinite Surface {1368};Transfinite Surface {1369};Transfinite Surface {1370};Recombine Surface {1365,1366,1367,1368,1369,1370};Transfinite Volume {176};Transfinite Surface {1362};Transfinite Surface {1371};Transfinite Surface {1372};Transfinite Surface {1373};Transfinite Surface {1374};Transfinite Surface {1375};Recombine Surface {1362,1371,1372,1373,1374,1375};Transfinite Volume {177};Transfinite Surface {1356};Transfinite Surface {1372};Transfinite Surface {1376};Transfinite Surface {1377};Transfinite Surface {1378};Transfinite Surface {1379};Recombine Surface {1356,1372,1376,1377,1378,1379};Transfinite Volume {178};Transfinite Surface {1361};Transfinite Surface {1369};Transfinite Surface {1380};Transfinite Surface {1381};Transfinite Surface {1382};Transfinite Surface {1383};Recombine Surface {1361,1369,1380,1381,1382,1383};Transfinite Volume {179};Transfinite Surface {1355};Transfinite Surface {1368};Transfinite Surface {1384};Transfinite Surface {1385};Transfinite Surface {1386};Transfinite Surface {1387};Recombine Surface {1355,1368,1384,1385,1386,1387};Transfinite Volume {180};Transfinite Surface {1348};Transfinite Surface {1381};Transfinite Surface {1386};Transfinite Surface {1388};Transfinite Surface {1389};Transfinite Surface {1390};Recombine Surface {1348,1381,1386,1388,1389,1390};Transfinite Volume {181};Transfinite Surface {1349};Transfinite Surface {1379};Transfinite Surface {1385};Transfinite Surface {1391};Transfinite Surface {1392};Transfinite Surface {1393};Recombine Surface {1349,1379,1385,1391,1392,1393};Transfinite Volume {182};Transfinite Surface {1340};Transfinite Surface {1375};Transfinite Surface {1388};Transfinite Surface {1392};Transfinite Surface {1394};Transfinite Surface {1395};Recombine Surface {1340,1375,1388,1392,1394,1395};Transfinite Volume {183};Transfinite Surface {1334};Transfinite Surface {1376};Transfinite Surface {1396};Transfinite Surface {1397};Transfinite Surface {1398};Transfinite Surface {1399};Recombine Surface {1334,1376,1396,1397,1398,1399};Transfinite Volume {184};Transfinite Surface {1329};Transfinite Surface {1371};Transfinite Surface {1398};Transfinite Surface {1400};Transfinite Surface {1401};Transfinite Surface {1402};Recombine Surface {1329,1371,1398,1400,1401,1402};Transfinite Volume {185};Transfinite Surface {1325};Transfinite Surface {1370};Transfinite Surface {1403};Transfinite Surface {1404};Transfinite Surface {1405};Transfinite Surface {1406};Recombine Surface {1325,1370,1403,1404,1405,1406};Transfinite Volume {186};Transfinite Surface {1338};Transfinite Surface {1383};Transfinite Surface {1404};Transfinite Surface {1407};Transfinite Surface {1408};Transfinite Surface {1409};Recombine Surface {1338,1383,1404,1407,1408,1409};Transfinite Volume {188};Transfinite Surface {1380};Transfinite Surface {1390};Transfinite Surface {1410};Transfinite Surface {1411};Transfinite Surface {1412};Transfinite Surface {1413};Recombine Surface {1380,1390,1410,1411,1412,1413};Transfinite Volume {190};Transfinite Surface {1374};Transfinite Surface {1395};Transfinite Surface {1413};Transfinite Surface {1414};Transfinite Surface {1415};Transfinite Surface {1416};Recombine Surface {1374,1395,1413,1414,1415,1416};Transfinite Volume {191};Transfinite Surface {1378};Transfinite Surface {1393};Transfinite Surface {1415};Transfinite Surface {1417};Transfinite Surface {1418};Transfinite Surface {1419};Recombine Surface {1378,1393,1415,1417,1418,1419};Transfinite Volume {192};Transfinite Surface {1366};Transfinite Surface {1387};Transfinite Surface {1411};Transfinite Surface {1419};Transfinite Surface {1420};Transfinite Surface {1421};Recombine Surface {1366,1387,1411,1419,1420,1421};Transfinite Volume {193};Transfinite Surface {1408};Transfinite Surface {1410};Transfinite Surface {1422};Transfinite Surface {1423};Transfinite Surface {1424};Transfinite Surface {1425};Recombine Surface {1408,1410,1422,1423,1424,1425};Transfinite Volume {194};Transfinite Surface {1402};Transfinite Surface {1414};Transfinite Surface {1424};Transfinite Surface {1426};Transfinite Surface {1427};Transfinite Surface {1428};Recombine Surface {1402,1414,1424,1426,1427,1428};Transfinite Volume {195};Transfinite Surface {1399};Transfinite Surface {1417};Transfinite Surface {1427};Transfinite Surface {1429};Transfinite Surface {1430};Transfinite Surface {1431};Recombine Surface {1399,1417,1427,1429,1430,1431};Transfinite Volume {196};Transfinite Surface {1405};Transfinite Surface {1420};Transfinite Surface {1422};Transfinite Surface {1431};Transfinite Surface {1432};Transfinite Surface {1433};Recombine Surface {1405,1420,1422,1431,1432,1433};Transfinite Volume {197};Transfinite Surface {380};Transfinite Surface {1170};Transfinite Surface {1171};Transfinite Surface {1172};Transfinite Surface {1173};Transfinite Surface {1174};Recombine Surface {380,1170,1171,1172,1173,1174};Transfinite Volume {198};Transfinite Surface {1172};Transfinite Surface {1301};Transfinite Surface {1434};Transfinite Surface {1435};Transfinite Surface {1436};Transfinite Surface {1437};Recombine Surface {1172,1301,1434,1435,1436,1437};Transfinite Volume {199};Transfinite Surface {98};Transfinite Surface {1170};Transfinite Surface {1180};Transfinite Surface {1181};Transfinite Surface {1182};Transfinite Surface {1183};Recombine Surface {98,1170,1180,1181,1182,1183};Transfinite Volume {200};Transfinite Surface {1182};Transfinite Surface {1305};Transfinite Surface {1434};Transfinite Surface {1438};Transfinite Surface {1439};Transfinite Surface {1440};Recombine Surface {1182,1305,1434,1438,1439,1440};Transfinite Volume {201};Transfinite Surface {438};Transfinite Surface {1173};Transfinite Surface {1188};Transfinite Surface {1189};Transfinite Surface {1190};Transfinite Surface {1191};Recombine Surface {438,1173,1188,1189,1190,1191};Transfinite Volume {202};Transfinite Surface {1189};Transfinite Surface {1339};Transfinite Surface {1436};Transfinite Surface {1441};Transfinite Surface {1442};Transfinite Surface {1443};Recombine Surface {1189,1339,1436,1441,1442,1443};Transfinite Volume {203};Transfinite Surface {108};Transfinite Surface {1181};Transfinite Surface {1188};Transfinite Surface {1196};Transfinite Surface {1197};Transfinite Surface {1198};Recombine Surface {108,1181,1188,1196,1197,1198};Transfinite Volume {204};Transfinite Surface {1198};Transfinite Surface {1326};Transfinite Surface {1439};Transfinite Surface {1441};Transfinite Surface {1444};Transfinite Surface {1445};Recombine Surface {1198,1326,1439,1441,1444,1445};Transfinite Volume {205};Transfinite Surface {184};Transfinite Surface {1197};Transfinite Surface {1202};Transfinite Surface {1203};Transfinite Surface {1204};Transfinite Surface {1205};Recombine Surface {184,1197,1202,1203,1204,1205};Transfinite Volume {206};Transfinite Surface {1204};Transfinite Surface {1406};Transfinite Surface {1445};Transfinite Surface {1446};Transfinite Surface {1447};Transfinite Surface {1448};Recombine Surface {1204,1406,1445,1446,1447,1448};Transfinite Volume {207};Transfinite Surface {452};Transfinite Surface {1190};Transfinite Surface {1205};Transfinite Surface {1210};Transfinite Surface {1211};Transfinite Surface {1212};Recombine Surface {452,1190,1205,1210,1211,1212};Transfinite Volume {208};Transfinite Surface {1210};Transfinite Surface {1409};Transfinite Surface {1442};Transfinite Surface {1448};Transfinite Surface {1449};Transfinite Surface {1450};Recombine Surface {1210,1409,1442,1448,1449,1450};Transfinite Volume {209};Transfinite Surface {237};Transfinite Surface {1203};Transfinite Surface {1216};Transfinite Surface {1217};Transfinite Surface {1218};Transfinite Surface {1219};Recombine Surface {237,1203,1216,1217,1218,1219};Transfinite Volume {210};Transfinite Surface {1218};Transfinite Surface {1433};Transfinite Surface {1447};Transfinite Surface {1451};Transfinite Surface {1452};Transfinite Surface {1453};Recombine Surface {1218,1433,1447,1451,1452,1453};Transfinite Volume {211};Transfinite Surface {422};Transfinite Surface {1211};Transfinite Surface {1219};Transfinite Surface {1224};Transfinite Surface {1225};Transfinite Surface {1226};Recombine Surface {422,1211,1219,1224,1225,1226};Transfinite Volume {212};Transfinite Surface {1224};Transfinite Surface {1425};Transfinite Surface {1449};Transfinite Surface {1453};Transfinite Surface {1454};Transfinite Surface {1455};Recombine Surface {1224,1425,1449,1453,1454,1455};Transfinite Volume {213};Transfinite Surface {1295};Transfinite Surface {1456};Transfinite Surface {1457};Transfinite Surface {1458};Transfinite Surface {1459};Transfinite Surface {1460};Recombine Surface {1295,1456,1457,1458,1459,1460};Transfinite Volume {214};Transfinite Surface {1327};Transfinite Surface {1457};Transfinite Surface {1461};Transfinite Surface {1462};Transfinite Surface {1463};Transfinite Surface {1464};Recombine Surface {1327,1457,1461,1462,1463,1464};Transfinite Volume {216};Transfinite Surface {1290};Transfinite Surface {1456};Transfinite Surface {1465};Transfinite Surface {1466};Transfinite Surface {1467};Transfinite Surface {1468};Recombine Surface {1290,1456,1465,1466,1467,1468};Transfinite Volume {218};Transfinite Surface {1332};Transfinite Surface {1461};Transfinite Surface {1466};Transfinite Surface {1469};Transfinite Surface {1470};Transfinite Surface {1471};Recombine Surface {1332,1461,1466,1469,1470,1471};Transfinite Volume {220};Transfinite Surface {1400};Transfinite Surface {1462};Transfinite Surface {1472};Transfinite Surface {1473};Transfinite Surface {1474};Transfinite Surface {1475};Recombine Surface {1400,1462,1472,1473,1474,1475};Transfinite Volume {222};Transfinite Surface {1396};Transfinite Surface {1470};Transfinite Surface {1472};Transfinite Surface {1476};Transfinite Surface {1477};Transfinite Surface {1478};Recombine Surface {1396,1470,1472,1476,1477,1478};Transfinite Volume {224};Transfinite Surface {1426};Transfinite Surface {1474};Transfinite Surface {1479};Transfinite Surface {1480};Transfinite Surface {1481};Transfinite Surface {1482};Recombine Surface {1426,1474,1479,1480,1481,1482};Transfinite Volume {226};Transfinite Surface {1429};Transfinite Surface {1477};Transfinite Surface {1479};Transfinite Surface {1483};Transfinite Surface {1484};Transfinite Surface {1485};Recombine Surface {1429,1477,1479,1483,1484,1485};Transfinite Volume {228};Transfinite Surface {1287};Transfinite Surface {1486};Transfinite Surface {1487};Transfinite Surface {1488};Transfinite Surface {1489};Transfinite Surface {1490};Recombine Surface {1287,1486,1487,1488,1489,1490};Transfinite Volume {229};Transfinite Surface {1303};Transfinite Surface {1489};Transfinite Surface {1491};Transfinite Surface {1492};Transfinite Surface {1493};Transfinite Surface {1494};Recombine Surface {1303,1489,1491,1492,1493,1494};Transfinite Volume {231};Transfinite Surface {1316};Transfinite Surface {1486};Transfinite Surface {1495};Transfinite Surface {1496};Transfinite Surface {1497};Transfinite Surface {1498};Recombine Surface {1316,1486,1495,1496,1497,1498};Transfinite Volume {233};Transfinite Surface {1319};Transfinite Surface {1491};Transfinite Surface {1495};Transfinite Surface {1499};Transfinite Surface {1500};Transfinite Surface {1501};Recombine Surface {1319,1491,1495,1499,1500,1501};Transfinite Volume {235};Transfinite Surface {1333};Transfinite Surface {1487};Transfinite Surface {1502};Transfinite Surface {1503};Transfinite Surface {1504};Transfinite Surface {1505};Recombine Surface {1333,1487,1502,1503,1504,1505};Transfinite Volume {237};Transfinite Surface {1350};Transfinite Surface {1496};Transfinite Surface {1506};Transfinite Surface {1507};Transfinite Surface {1508};Transfinite Surface {1509};Recombine Surface {1350,1496,1506,1507,1508,1509};Transfinite Volume {239};Transfinite Surface {1323};Transfinite Surface {1494};Transfinite Surface {1510};Transfinite Surface {1511};Transfinite Surface {1512};Transfinite Surface {1513};Recombine Surface {1323,1494,1510,1511,1512,1513};Transfinite Volume {241};Transfinite Surface {1354};Transfinite Surface {1501};Transfinite Surface {1506};Transfinite Surface {1514};Transfinite Surface {1515};Transfinite Surface {1516};Recombine Surface {1354,1501,1506,1514,1515,1516};Transfinite Volume {243};Transfinite Surface {1357};Transfinite Surface {1498};Transfinite Surface {1502};Transfinite Surface {1509};Transfinite Surface {1517};Transfinite Surface {1518};Recombine Surface {1357,1498,1502,1509,1517,1518};Transfinite Volume {245};Transfinite Surface {1364};Transfinite Surface {1499};Transfinite Surface {1512};Transfinite Surface {1514};Transfinite Surface {1519};Transfinite Surface {1520};Recombine Surface {1364,1499,1512,1514,1519,1520};Transfinite Volume {247};Transfinite Surface {1377};Transfinite Surface {1517};Transfinite Surface {1521};Transfinite Surface {1522};Transfinite Surface {1523};Transfinite Surface {1524};Recombine Surface {1377,1517,1521,1522,1523,1524};Transfinite Volume {249};Transfinite Surface {1367};Transfinite Surface {1520};Transfinite Surface {1525};Transfinite Surface {1526};Transfinite Surface {1527};Transfinite Surface {1528};Recombine Surface {1367,1520,1525,1526,1527,1528};Transfinite Volume {251};Transfinite Surface {1391};Transfinite Surface {1507};Transfinite Surface {1524};Transfinite Surface {1529};Transfinite Surface {1530};Transfinite Surface {1531};Recombine Surface {1391,1507,1524,1529,1530,1531};Transfinite Volume {253};Transfinite Surface {1397};Transfinite Surface {1503};Transfinite Surface {1522};Transfinite Surface {1532};Transfinite Surface {1533};Transfinite Surface {1534};Recombine Surface {1397,1503,1522,1532,1533,1534};Transfinite Volume {255};Transfinite Surface {1384};Transfinite Surface {1516};Transfinite Surface {1525};Transfinite Surface {1529};Transfinite Surface {1535};Transfinite Surface {1536};Recombine Surface {1384,1516,1525,1529,1535,1536};Transfinite Volume {257};Transfinite Surface {1403};Transfinite Surface {1513};Transfinite Surface {1528};Transfinite Surface {1537};Transfinite Surface {1538};Transfinite Surface {1539};Recombine Surface {1403,1513,1528,1537,1538,1539};Transfinite Volume {259};Transfinite Surface {1418};Transfinite Surface {1521};Transfinite Surface {1530};Transfinite Surface {1540};Transfinite Surface {1541};Transfinite Surface {1542};Recombine Surface {1418,1521,1530,1540,1541,1542};Transfinite Volume {261};Transfinite Surface {1421};Transfinite Surface {1526};Transfinite Surface {1536};Transfinite Surface {1540};Transfinite Surface {1543};Transfinite Surface {1544};Recombine Surface {1421,1526,1536,1540,1543,1544};Transfinite Volume {263};Transfinite Surface {1430};Transfinite Surface {1532};Transfinite Surface {1541};Transfinite Surface {1545};Transfinite Surface {1546};Transfinite Surface {1547};Recombine Surface {1430,1532,1541,1545,1546,1547};Transfinite Volume {265};Transfinite Surface {1432};Transfinite Surface {1539};Transfinite Surface {1543};Transfinite Surface {1545};Transfinite Surface {1548};Transfinite Surface {1549};Recombine Surface {1432,1539,1543,1545,1548,1549};Transfinite Volume {267};

Physical Surface("InletMain") = {551, 543, 529, 523, 508, 500, 516, 538};
//+
Physical Surface("InletLoop") = {1285, 1280, 1249, 1232, 1283, 1277, 1266, 1243, 1267, 1253, 1273, 1271, 1259, 1245, 1236, 89, 1256, 1264, 1239, 1228};
//+
Physical Surface("OutletLoop") = {1548, 1538, 1511, 1492, 1544, 1527, 1519, 1500, 1515, 1535, 1547, 1542, 1508, 1531, 1497, 1488, 1534, 1523, 1518, 1504};
//+
Physical Surface("OutletMain") = {1467, 1458, 1471, 1463, 1478, 1473, 1485, 1480};
//+
Physical Surface("Wall") = {498, 514, 501, 509, 510, 524, 497, 489, 466, 395, 351, 341, 387, 378, 1234, 1248, 93, 1230, 1180, 1196, 1183, 1171, 1174, 1191, 436, 428, 1444, 1438, 1440, 1435, 1437, 1443, 1337, 1360, 1309, 1299, 1294, 1314, 1363, 1493, 1510, 1460, 1330, 1464, 1459, 1468, 1465, 1490, 1469, 1505, 1347, 1343, 1475, 1482, 1481, 1484, 1483, 1476, 1533, 1546, 1549, 1537, 1428, 1401, 1373, 1416, 1394, 1389, 1412, 1423, 1382, 1407, 1455, 1454, 1452, 1451, 1446, 1202, 1216, 1217, 1225, 1226, 1212, 1450, 1258, 1275, 1284, 421, 451, 444, 414, 360, 370, 459, 404, 1279, 549, 536, 550, 544, 545, 531, 483, 475};
//+
Physical Volume("Fluid") = {214, 218, 216, 220, 222, 155, 224, 156, 159, 226, 163, 154, 158, 174, 228, 157, 199, 160, 168, 166, 169, 173, 167, 161, 172, 201, 170, 185, 177, 183, 203, 171, 175, 162, 198, 181, 179, 191, 184, 178, 182, 200, 205, 188, 180, 190, 202, 91, 195, 176, 192, 209, 83, 194, 93, 186, 105, 193, 23, 196, 204, 85, 103, 229, 27, 197, 207, 29, 95, 25, 208, 231, 213, 113, 119, 121, 33, 233, 124, 31, 237, 235, 35, 245, 211, 109, 107, 97, 122, 206, 39, 47, 37, 111, 239, 22, 128, 243, 212, 247, 241, 115, 99, 41, 45, 43, 26, 117, 49, 87, 255, 249, 210, 253, 28, 101, 24, 126, 55, 257, 51, 32, 30, 89, 57, 59, 261, 251, 53, 130, 34, 259, 263, 265, 36, 61, 38, 46, 267, 40, 132, 44, 42, 134, 48, 50, 54, 136, 52, 56, 58, 60};
//+
Mesh.ElementOrder = 2;
Mesh.MshFileVersion = 2.16;
Mesh 3;
Save "DoubleTJunction_v22.msh";
