// Arduino connectors library
//
// Copyright (c) 2013 Kelly Egan
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
// and associated documentation files (the "Software"), to deal in the Software without restriction, 
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do 
// so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT 
// NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

include <pins.scad>

//Constructs a roughed out arduino board
//Current only USB, power and headers
module arduino(boardType = UNO) {
	//The PCB with holes
	difference() {
		color("SteelBlue") 
			boardShape( boardType );
		translate([0,0,-pcbHeight * 0.5]) holePlacement(boardType = boardType)
			cylinder(r = mountingHoleRadius, h = pcbHeight * 2, $fn=32);
	}

	color("Black")
		components( boardType = boardType, component = HEADERS);
	color("LightGray")
		components( boardType = boardType, component = USB );
	color("Black")
		components( boardType = boardType,component = POWER );
}

module bumper( boardType = UNO ) {
	difference() {
		union() {
			difference() {
				boardShape(boardType = boardType, offset=1.4, height = pcbHeight + 2);
				translate([0,0,-0.5])
				boardShape(boardType = boardType, height = pcbHeight + 5.5);
			}		
			difference() {
				boardShape(boardType = boardType, offset=1, height = 1.5);
				translate([0,0,-0.5])
				boardShape(boardType = boardType, offset=-2, height = pcbHeight + 2);
			}
			holePlacement(boardType=boardType)
				cylinder(r = mountingHoleRadius + 1.5, h = 1.5, $fn = 32);
		}
		translate([0,0,-0.5])
		holePlacement(boardType=boardType)
			cylinder(r = mountingHoleRadius, h = pcbHeight + 2, $fn = 32);	
		translate([0,0,1.5]) {
			components(boardType = boardType, component=USB, offset = 1);
			components(boardType = boardType, component=POWER, offset = 1);
		}
	}
}

module box( boardType = UNO, wall = 4, offset = 1, standoffHeight = 5, topExtention = 10, cornerRadius = 0 ) {
	exteriorHeight = boardHeight[boardType] + offset * 2 + standoffHeight + topExtention + wall * 2;
	interiorHeight = exteriorHeight - wall;

	//This should be generalized
	additionalOffset = boardType == LEONARDO ? 1.1 : 6.5;

	difference() {
		translate([wall + offset, wall + offset + additionalOffset, 0]) difference() {
			//Outside
			boundingBox( boardType=boardType, offset = wall + offset, height = exteriorHeight, cornerRadius = cornerRadius);
			//Inside
			translate([0,0,wall])
				boundingBox( boardType=boardType, offset = offset, height = interiorHeight + 0.5, cornerRadius = cornerRadius);
			//Lid cut
			translate([0,wall + 0.5, interiorHeight]) 
				boundingBox( boardType=boardType, offset = offset, height = wall + 0.5 );
			translate( [(boardWidth[boardType] + offset * 2) * 0.33333, boardDepth[boardType] - (wall + offset), interiorHeight]) 
				rotate([0,90,0]) 
					cylinder( r = wall * 0.35, h = (boardWidth[boardType] + offset * 2) * 0.33333, $fn = 16 );
			//Component holes
			translate([0, 0,wall + standoffHeight]) {
				components(boardType=boardType, component=USB, offset = 1.5, extension = wall + offset + 5);
				components(boardType=boardType, component=POWER, offset = 1.5, extension = wall + offset + 5);
			}
		}
	
		//Lid slides
		translate([0, 2 * wall + 2 * offset + boardDepth[boardType], interiorHeight + wall ]) 
		rotate([180, 0, 0]) {
			lid( boardType = UNO, wall = wall, offset = offset );
		}

		//Wiring holes
		cylinder(r = 10, h = wall + 2);
	}
	
	translate([wall + offset, wall + offset, wall]) {
		standoffs(boardType=boardType, height=standoffHeight);
	}
}

//Setting for enclosure mounting holes (Not Arduino mounting)
NOMOUNTINGHOLES = 0;
INTERIORMOUNTINGHOLES = 1;
EXTERIORMOUNTINGHOLES = 2;

module lid( boardType = UNO, wall = 4, offset = 1 ) {
	depth = wall + offset * 2 + boardDepth[boardType];
	width = boardWidth[boardType] + 2 * offset;

	union() {
		translate([wall, 0, 0]) {
			cube([width, depth, wall]);
		}
	
		translate([wall/2, 0, wall / 2])  {
			rotate([0,45,0])
				cube([sides(wall),boardDepth[boardType] + 2 * offset + wall,sides(wall)]);
			translate([boardWidth[boardType] + 2 * offset,0,0]) rotate([0,45,0])
				cube([sides(wall),boardDepth[boardType] + 2 * offset + wall,sides(wall)]);
		}
		translate( [wall + width * 0.33333, wall * 0.6, wall * .85]) rotate([0,90,0]) 
			cylinder( r = wall * 0.35, h = (boardWidth[boardType] + offset * 2) * 0.33333, $fn = 16 );
	}
}

//Offset from board. Negative values are insets
module boardShape( boardType = UNO, offset = 0, height = pcbHeight ) {
	xScale = (boardWidth[boardType] + offset * 2) / boardWidth[boardType];
	yScale = (boardDepth[boardType] + offset * 2) / boardDepth[boardType];

	translate([-offset, -offset, 0])
		scale([xScale, yScale, 1.0])
			linear_extrude(height = height) 
				polygon(points = boardShape[boardType]);
}

//Create a bounding box around the board
//Offset - will increase the size of the box on each side,
//Height - overides the boardHeight and offset in the z direction
module boundingBox(boardType = UNO, offset = 0, height = 0, cornerRadius = 0) {
	height = height == 0 ? boardHeight[boardType] + offset * 2 : height;

	//This should be generalized
	additionalOffset = boardType == LEONARDO ? 1.1 : 6.5;

	translate([-offset, -(additionalOffset + offset), height == 0 ? -offset: 0]) {
		if( cornerRadius == 0 ) {
			cube([boardWidth[boardType] + offset * 2, boardDepth[boardType] + offset * 2, height]);
		} else {
			roundedCube([boardWidth[boardType] + offset * 2, boardDepth[boardType] + offset * 2, height], cornerRadius = cornerRadius);
		}
	}
}

//Creates standoffs for different boards
module standoffs( 
	boardType = UNO, 
	height = 10, 
	topRadius = mountingHoleRadius + 1, 
	bottomRadius =  mountingHoleRadius + 1, 
	holeRadius = mountingHoleRadius,
	mountType = TAPHOLE
	) {

	holePlacement(boardType = boardType)
		union() {
			difference() {
				cylinder(r1 = bottomRadius, r2 = topRadius, h = height, $fn=32);
				if( mountType == TAPHOLE ) {
					cylinder(r =  holeRadius, h = height * 4, center = true, $fn=32);
				}
			}
			if( mountType == PIN ) {
				translate([0, 0, height - 1])
				pintack( h=pcbHeight + 3, r = holeRadius, lh=3, lt=1, bh=1, br=topRadius );
			}
		}	
}

TAPHOLE = 0;
PIN = 1;

//This is used for placing the mounting holes and for making standoffs
//child elements will be centered on that chosen boards mounting hole centers
module holePlacement(boardType = UNO ) {
	for(i = boardHoles[boardType] ) {
		translate(i)
			child(0);
	}
}

//Places components on board
//  compenent - the data set with a particular component (like boardHeaders)
//  extend - the amount to extend the component in the direction of its socket
//  offset - the amount to increase the components other two boundaries
module components( boardType = UNO, component = HEADERS, extension = 0, offset = 0 ) {
	translate([0, 0, pcbHeight]) {
		for( i = [0:len(component[boardType]) - 1] ){
			assign(
          //Calculates position + adjustment for offset and extention
				position = component[boardType][i][0] - (([1,1,1] - component[boardType][i][2]) * offset)
					+ [	min(component[boardType][i][2][0],0), 
					 	min(component[boardType][i][2][1],0),
               			min(component[boardType][i][2][2],0) ] * extension,
				//Calculates the full box size including offset and extention
				dimensions = component[boardType][i][1] 
					+ ((component[boardType][i][2] * [1,1,1]) 
						* component[boardType][i][2]) * extension
					+ ([1,1,1] - component[boardType][i][2]) * offset * 2 
				) {
				
				translate( position ) 
					cube( dimensions );
			}
		}	
	}
}

module roundedCube( dimensions = [10,10,10], cornerRadius = 1, faces=32 ) {
	translate([ cornerRadius, cornerRadius, 0]) hull() {
		cylinder( r = cornerRadius, $fn = faces, h = dimensions[2] );
		translate([dimensions[0] - cornerRadius * 2, 0, 0]) cylinder( r = cornerRadius, $fn = faces, h = dimensions[2] );
		translate([0, dimensions[1] - cornerRadius * 2, 0]) {
			cylinder( r = cornerRadius, $fn = faces, h = dimensions[2] );
			translate([dimensions[0] - cornerRadius * 2, 0, 0]) cylinder( r = cornerRadius, $fn = faces, h = dimensions[2] );
		}
	}
}

function sides( diagonal ) = sqrt(diagonal * diagonal  / 2);

/******************************* BOARD SPECIFIC DATA ******************************/

//Board IDs
NG = 0;
DIECIMILA = 1;
DUEMILANOVE = 2;
UNO = 3;
LEONARDO = 4;
MEGA = 5;
MEGA2560 = 6;
DUE = 7;
YUN = 8; 
INTELGALILEO = 9;
TRE = 10;

/********************************** MEASUREMENTS **********************************/
pcbHeight = 1.7;
headerWidth = 2.54;
headerHeight = 9;
mountingHoleRadius = 3.2 / 2;

ngWidth = 53.34;
leonardoDepth = 68.58 + 1.1;
ngDepth = 68.58 + 6.5;
megaDepth = 101.6 + 6.5;               //Coding is my business and business is good!
arduinoHeight = 11 + pcbHeight + 0;

/********************************* MOUNTING HOLES *********************************/

//Duemilanove, Diecimila, NG and earlier
ngHoles = [
		[  2.54, 15.24 ],
		[  17.78, 66.04 ],
		[  45.72, 66.04 ]
		];

//Uno, Leonardo holes
unoHoles = [
		[  2.54, 15.24 ],
		[  17.78, 66.04 ],
		[  45.72, 66.04 ],
		[  50.8, 13.97 ]
		];

//Due and Mega 2560
dueHoles = [
		[  2.54, 15.24 ],
		[  17.78, 66.04 ],
		[  45.72, 66.04 ],
		[  50.8, 13.97 ],
		[  2.54, 90.17 ],
		[  50.8, 96.52 ]
		];

// Original Mega holes
megaHoles = [
		[  2.54, 15.24 ],
		[  50.8, 13.97 ],
		[  2.54, 90.17 ],
		[  50.8, 96.52 ]
		];

boardHoles = [ 
		ngHoles,        //NG
		ngHoles,        //Diecimila
		ngHoles,        //Duemilanove
		unoHoles,       //Uno
		unoHoles,       //Leonardo
		megaHoles,      //Mega
		dueHoles,       //Mega 2560
		dueHoles,       //Due
		0,              //Yun
		0,              //Intel Galileo
       	0               //Tre
		];

/********************************* BOARD OUTLINES *********************************/
ngBoardPath = [ 
		[  0.0, 0.0 ],
		[  53.34, 0.0 ],
		[  53.34, 66.04 ],
		[  50.8, 66.04 ],
		[  48.26, 68.58 ],
		[  15.24, 68.58 ],
		[  12.7, 66.04 ],
		[  1.27, 66.04 ],
		[  0.0, 64.77 ]
		];

megaBoardPath = [ 
		[  0.0, 0.0 ],
		[  53.34, 0.0 ],
		[  53.34, 99.06 ],
		[  52.07, 99.06 ],
		[  49.53, 101.6 ],
		[  15.24, 101.6 ],
		[  12.7, 99.06 ],
		[  2.54, 99.06 ],
		[  0.0, 96.52 ]
		];

boardShape = [ 	
					ngBoardPath,   //NG
					ngBoardPath,   //Diecimila
					ngBoardPath,   //Duemilanove
					ngBoardPath,   //Uno
					ngBoardPath,   //Leonardo
					megaBoardPath, //Mega
					megaBoardPath, //Mega 2560
					megaBoardPath, //Due
					0,             //Yun
					0,             //Intel Galileo
					0              //Tre
				];	

/*********************************** DIMENSIONS ***********************************/

boardDimensions = [
					[ngWidth, ngDepth, 11 + pcbHieght],  		//NG
					[ngWidth, ngDepth, 11 + pcbHieght],  		//Diecimila
					[ngWidth, ngDepth, 11 + pcbHieght], 			//Duemilanove
					[ngWidth, ngDepth, 11 + pcbHieght],    		//Uno
					[ngWidth, leonardoDepth, 11 + pcbHieght],	//Leonardo
					[ngWidth, megaDepth, 11 + pcbHieght],		//Mega
					[ngWidth, megaDepth, 11 + pcbHieght],		//Mega 2560
					[ngWidth, megaDepth, 11 + pcbHieght],		//Due
					[0,0,0],              //Yun
					[0,0,0],              //Intel Galileo
					[0,0,0]               //Tre
				];

boardWidth = [ 	
					ngWidth,        //NG
					ngWidth,        //Diecimila
					ngWidth,        //Duemilanove
					ngWidth,        //Uno
					ngWidth,        //Leonardo
					ngWidth,        //Mega
					ngWidth,        //Mega 2560
					ngWidth,        //Due
					0,              //Yun
					0,              //Intel Galileo
					0               //Tre
				];

boardDepth = [ 	
					ngDepth,        //NG
					ngDepth,        //Diecimila
					ngDepth,        //Duemilanove
					ngDepth,        //Uno
					leonardoDepth,  //Leonardo
					megaDepth,      //Mega
					megaDepth,      //Mega 2560
					megaDepth,      //Due
					0,              //Yun
					0,              //Intel Galileo
					0               //Tre
				];

boardHeight = [ 	
					11 + pcbHeight, //NG
					11 + pcbHeight, //Diecimila
					11 + pcbHeight, //Duemilanove
					11 + pcbHeight, //Uno
					11 + pcbHeight, //Leonardo
					11 + pcbHeight, //Mega
					11 + pcbHeight, //Mega 2560
					11 + pcbHeight, //Due
					0,              //Yun
					0,              //Intel Galileo
					0               //Tre
				];


/*********************************** COMPONENTS ***********************************/

//Array of vectors, each component has translation, dimensions
//and out vector( which axis is away from board ) to help with extending punch holes
ngHeaders = [
	[[1.27, 17.526, 0], [headerWidth, headerWidth * 10, headerHeight], [0, 0, 1]],
	[[1.27, 44.45, 0], [headerWidth, headerWidth * 8, headerHeight ], [0, 0, 1]],
	[[49.53, 26.67, 0], [headerWidth, headerWidth * 8, headerHeight ], [0, 0, 1]],
	[[49.53, 49.53, 0], [headerWidth, headerWidth * 6, headerHeight ], [0, 0, 1]],
	];

megaHeaders = [
	[[1.27, 22.86, 0], [headerWidth, headerWidth * 8, headerHeight], [0, 0, 1]],
	[[1.27, 44.45, 0], [headerWidth, headerWidth * 8, headerHeight], [0, 0, 1]],
	[[1.27, 67.31, 0], [headerWidth, headerWidth * 8, headerHeight], [0, 0, 1]],
	[[49.53, 31.75, 0], [headerWidth, headerWidth * 6, headerHeight ], [0, 0, 1]],
	[[49.53, 49.53, 0], [headerWidth, headerWidth * 8, headerHeight], [0, 0, 1]],
	[[49.53, 72.39, 0], [headerWidth, headerWidth * 8, headerHeight], [0, 0, 1]],
	[[1.27, 92.71, 0], [headerWidth * 18, headerWidth * 2, headerHeight], [0, 0, 1]]
	];

mega2560Headers = [
	[[1.27, 17.526, 0], [headerWidth, headerWidth * 10, headerHeight], [0, 0, 1]],
	[[1.27, 44.45, 0], [headerWidth, headerWidth * 8, headerHeight], [0, 0, 1]],
	[[1.27, 67.31, 0], [headerWidth, headerWidth * 8, headerHeight], [0, 0, 1]],
	[[49.53, 26.67, 0], [headerWidth, headerWidth * 8, headerHeight ], [0, 0, 1]],
	[[49.53, 49.53, 0], [headerWidth, headerWidth * 8, headerHeight], [0, 0, 1]],
	[[49.53, 72.39, 0], [headerWidth, headerWidth * 8, headerHeight], [0, 0, 1]],
	[[1.27, 92.71, 0], [headerWidth * 18, headerWidth * 2, headerHeight], [0, 0, 1]]
	];

HEADERS = [ 	ngHeaders,         //NG
				ngHeaders,         //Diecimila
				ngHeaders,         //Duemilanove
				ngHeaders,         //Uno
				ngHeaders,         //Leonardo
				megaHeaders,       //Mega
				mega2560Headers,   //Mega 2560
				mega2560Headers,   //Due
				0,                 //Yun
				0,                 //Intel Galileo
				0                  //Tre
			];

//USB

ngUSB = [ 
	[[9.34, -6.5, 0],[12, 16, 11],[0, -1, 0]]
	];

LeonardoUSB = [ 
	[[11.5, -1.1, 0],[7.5, 5.9, 3],[0, -1, 0]]
	];

DueUSB = [
	[[11.5, -1.1, 0], [7.5, 5.9, 3], [0, -1, 0]],
	[[27.365, -1.1, 0], [7.5, 5.9, 3], [0, -1, 0]]
	];

USB = [ 	
		ngUSB,         //NG
		ngUSB,         //Diecimila
		ngUSB,         //Duemilanove
		ngUSB,         //Uno
		LeonardoUSB,   //Leonardo
		ngUSB,         //Mega
		ngUSB,         //Mega 2560
		DueUSB,        //Due
		0,             //Yun
		0,             //Intel Galileo
		0              //Tre
  	  ];

ngPower = [
	[[40.7, -1.8, 0], [9.0, 13.2, 10.9], [0, -1, 0]]
	];

POWER = [ 	
			ngPower, //NG
			ngPower, //Diecimila
			ngPower, //Duemilanove
			ngPower, //Uno
			ngPower, //Leonardo
			ngPower, //Mega
			ngPower, //Mega 2560
			ngPower, //Due
			0,              //Yun
			0,              //Intel Galileo
			0               //Tre
		];


