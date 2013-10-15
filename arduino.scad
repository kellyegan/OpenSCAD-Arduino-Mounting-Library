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

//arduino(MEGA);

//Constructs a roughed out arduino board
//Current only USB, power and headers
module arduino(boardType = UNO) {
	//The PCB with holes
	difference() {
		color("SteelBlue") boardShape( boardType );
		translate([0,0,-pcbHeight * 0.5]) holePlacement(boardType = boardType)
			cylinder(r = mountingHoleRadius, h = pcbHeight * 2, $fn=32);
	}

	color("Black")components( boardType = boardType, component = HEADERS);
	color("LightGray") components( boardType = boardType, component = USB );
	color("Black") components( boardType = boardType,component = POWER );
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
module boundingBox(boardType = UNO, offset = 0, height = 0) {
	height = height == 0 ? boardHeight[boardType] : height;

	//This should be generalized
	additionalOffset = boardType == LEONARDO ? 1.1 : 6.5;

	translate([-offset, -(additionalOffset + offset), -offset])
		cube([boardWidth[boardType] + offset * 2, boardDepth[boardType] + offset * 2, height + offset * 2]);
}

//Creates standoffs for different boards
module standoffs( boardType = UNO, height = 10, topRadius = mountingHoleRadius + 1, bottomRadius =  mountingHoleRadius + 1, holeRadius = mountingHoleRadius ) {
	holePlacement(boardType = boardType)
		difference() {
			cylinder(r1 = bottomRadius, r2 = topRadius, h = height, $fn=32);
			cylinder(r =  holeRadius, h = height * 4, center = true, $fn=32);
		}
}

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
module components( boardType = UNO, component = HEADERS, extend = 0, offset = 0 ) {
	translate([0, 0, pcbHeight]) {
		for( i = [0:len(component[boardType]) - 1] ){
			assign(
          //Calculates position + adjustment for offset and extention
				position = component[boardType][i][0] - (([1,1,1] - component[boardType][i][2]) * offset)
					+ [	min(component[boardType][i][2][0],0), 
					 	min(component[boardType][i][2][1],0),
               min(component[boardType][i][2][2],0) ] * extend,
				//Calculates the full box size including offset and extention
				dimensions = component[boardType][i][1] 
					+ ((component[boardType][i][2] * [1,1,1]) 
						* component[boardType][i][2]) * extend
					+ ([1,1,1] - component[boardType][i][2]) * offset * 2 
				) {
				translate( position ) 
					cube( dimensions );
			}
		}	
	}
}

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

USB = [ 	ngUSB,         //NG
				ngUSB,         //Diecimila
				ngUSB,         //Duemilanove
				ngUSB,         //Uno
				LeonardoUSB,         //Leonardo
				ngUSB,       //Mega
				ngUSB,   //Mega 2560
				DueUSB,   //Due
				0,                 //Yun
				0,                 //Intel Galileo
				0                  //Tre
			];

ngPower = [
	[[41.14, -1.8, 0], [9.0, 13.2, 10.9], [0, -1, 0]]
	];

POWER  = [ 	
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


