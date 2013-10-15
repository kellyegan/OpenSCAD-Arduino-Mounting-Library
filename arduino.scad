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

//arduino("Mega");

//Constructs a roughed out arduino board
//Current only USB and power on the board but will add headers later
module arduino(boardType = "Uno") {
	//The PCB with holes
	difference() {
		boardShape( boardType );
		translate([0,0,-boardHeight * 0.5]) holePlacement(boardType = boardType)
			cylinder(r = mountingHoleRadius, h = boardHeight * 2, $fn=32);
	}

	//USB
	usb( boardType = boardType );

	//Power supply
	power();

	//Headers
	headers( boardType = boardType );
}

module boundingBox(boardType = "Uno", offset = 0, height = 0) {
	if( height != 0 ) {
		if( boardType == "Uno" || boardType == "NG" || boardType == "Diecimila" || boardType == "Duemilanove" ) {
			translate([-offset, -(6.5 + offset), 0])
				cube([arduinoWidth + offset * 2, unoDepth + offset * 2, height]);
		} else if ( boardType == "Leonardo" ) {
			translate([-offset, -(1.1 + offset), 0])
				cube([arduinoWidth + offset * 2, unoDepth + offset * 2, height]);
		} else if ( boardType == "Mega 2560" || boardType == "Due" || boardType == "Mega" ) {
			translate([-offset, -(6.5 + offset), 0])
				cube([arduinoWidth + offset * 2, dueDepth + offset * 2, height]);
		} else {
			echo("Board type not found!");
		}
	} else {
		if( boardType == "Uno" || boardType == "NG" || boardType == "Diecimila" || boardType == "Duemilanove" ) {
			translate([-offset, -(6.5 + offset), -offset])
				cube([arduinoWidth + offset * 2, unoDepth + offset * 2, arduinoHeight + offset * 2]);
		} else if ( boardType == "Leonardo" ) {
			translate([-offset, -(1.1 + offset), -offset])
				cube([arduinoWidth + offset * 2, unoDepth + offset * 2, arduinoHeight + offset * 2]);
		} else if ( boardType == "Mega 2560" || boardType == "Due" || boardType == "Mega" ) {
			translate([-offset, -(6.5 + offset), -offset])
				cube([arduinoWidth + offset * 2, dueDepth + offset, arduinoHeight + offset * 2]);
		} else {
			echo("Board type not found!");
		}
	}
}

//Creates standoffs for different boards
module standoffs( boardType = "Uno", height = 10, topRadius = mountingHoleRadius + 1, bottomRadius =  mountingHoleRadius + 1, holeRadius = mountingHoleRadius ) {
	holePlacement(boardType = boardType)
		difference() {
			cylinder(r1 = bottomRadius, r2 = topRadius, h = height, $fn=32);
			cylinder(r =  holeRadius, h = height * 4, center = true, $fn=32);
		}
}

//Offset from board. Negative values are insets
module boardShape( boardType = "Uno", offset = 0, height = boardHeight ) {
	xScale = (arduinoWidth + offset * 2) / arduinoWidth;
	yScaleUno = (unoDepth + offset * 2) / unoDepth;
	yScaleDue = (dueDepth + offset * 2) / dueDepth;

	translate([-offset, -offset, 0])
	if( boardType == "Leonardo" || boardType == "Uno" || boardType == "NG" || boardType == "Diecimila" || boardType == "Duemilanove" ) {
		scale([xScale, yScaleUno, 1.0])
			linear_extrude(height = height) 
				polygon(points = unoBoardPath);
	} else if ( boardType == "Mega 2560" || boardType == "Due" || boardType == "Mega" ) {
		scale([xScale, yScaleDue, 1.0])
			linear_extrude(height = height) 
				polygon(points = dueBoardPath);
	} else {
		echo("Board type not found!");
	}	
}

//This is used for placing the mounting holes 
//child elements will be centered on that chosen boards mounting hole centers
//Used as the basis for making standoffs
module holePlacement(boardType = "Uno" ) {
	if( boardType == "Leonardo" || boardType == "Uno" ) {
		for(i = unoHoles ) {
			translate(i)
				child(0);
		}
	} else if ( boardType == "NG" || boardType == "Diecimila" || boardType == "Duemilanove" ) {
		for(i = ngHoles ) {
			translate(i)
				child(0);	
		}
	} else if ( boardType == "Mega 2560" || boardType == "Due" ) {
		for(i = dueHoles ) {
			translate(i)
				child(0);	
		}
	} else if ( boardType == "Mega" ) {
		for(i = megaHoles ) {
			translate(i)
				child(0);	
		}
	} else {
		echo("Board type not found");
	}
}

//Rough out USB for particular board extend extends the cube off the board beyond the usb port dimensions, 
//offset gives a border around the usb port (x and y ) These are good for making punch outs
module usb( boardType = "Uno", extend = 0, offset = 0 ) {
	if( boardType == "Leonardo" ) {
		//Mini-B USB
		translate([11.5 - offset, -(1.1 + extend ), boardHeight - offset])
			cube([7.5 + offset * 2, 5.9 + extend, 3 + offset * 2]);
	} else if (boardType == "Due" ){
		//Mini-B USB
		translate([11.5 - offset, -(1.1 + extend ), boardHeight - offset])
			cube([7.5 + offset * 2, 5.9 + extend, 3 + offset * 2]);
		translate([27.365 - offset, -(1.1 + extend ), boardHeight - offset])
			cube([7.5 + offset * 2, 5.9 + extend, 3 + offset * 2]);
	} else {
		//B USB
		translate([9.34 - offset, -(6.5 + extend), boardHeight - offset]) 
			cube([12 + offset * 2, 16 + extend, 11 + offset * 2]);
	}
}

//similar to usb function but for the power jack
module power( boardType = "Uno", extend = 0, offset = 0, circleCut = false ) {
	width = 9;
	height = 10.9;
	radius = 6.33 / 2;
	distanceFromTop = 1.36;
	if( !circleCut ) {
		translate([41.14, 0, boardHeight]) { // difference() { 
			translate([-offset, -(1.8 + extend), -offset]) 
				cube([width + offset * 2, 13.2 + extend, height + offset * 2]);
//			translate([ width / 2, 5, 10.9 - radius - distanceFromTop]) rotate( [90, 0, 0]) 
//				cylinder( r = radius, h = 20, $fn = 32 );
		}
	} else {
		translate([ 41.14 + width / 2, 0, boardHeight + height - radius - distanceFromTop]) 
		rotate( [90, 0, 0]) 
				cylinder( r = radius + offset, h = extend, $fn = 64 );
	}
}

module headers( boardType = "Uno", extend = 0, offset = 0 ) {

	if( boardType == "Due" || boardType == "Mega" || boardType == "Mega 2560" ) {
		//Top row
		if (boardType == "Mega")
			translate( [  2.54, 33.02, headerHeight / 2 + boardHeight])
				cube([2.54, 2.54 * 8, headerHeight ], center=true);
		else 
			translate( [  2.54, 30.226, headerHeight / 2 + boardHeight])
				cube([2.54, 2.54 * 10, headerHeight ], center=true);
		translate( [  2.54, 54.61, headerHeight / 2 + boardHeight])
			cube([2.54, 2.54 * 8, headerHeight ], center=true);
		translate( [  2.54, 77.47, headerHeight / 2 + boardHeight])
			cube([2.54, 2.54 * 8, headerHeight ], center=true);

		//Bottom row
		if (boardType == "Mega")
			translate( [  50.8, 39.37, headerHeight / 2 + boardHeight])
				cube([2.54, 2.54 * 6, headerHeight ], center=true);
		else
			translate( [  50.8, 36.83, headerHeight / 2 + boardHeight])
				cube([2.54, 2.54 * 8, headerHeight ], center=true);
		translate( [  50.8, 59.69, headerHeight / 2 + boardHeight])
			cube([2.54, 2.54 * 8, headerHeight ], center=true);
		translate( [  50.8, 82.55, headerHeight / 2 + boardHeight])
			cube([2.54, 2.54 * 8, headerHeight ], center=true);
		//Vertical row
		translate( [ 24.13, 95.25, headerHeight / 2 + boardHeight ])
			cube([2.54 * 18, 2.54 * 2, headerHeight], center=true);

	} else if( boardType == "Leonardo" || boardType == "Uno" || boardType == "NG" || boardType == "Diecimila" || boardType == "Duemilanove" ) {
		//Top row
		translate( [  2.54, 30.226, headerHeight / 2 + boardHeight])
			cube([2.54, 2.54 * 10, headerHeight ], center=true);
		translate( [ 2.54, 54.61, headerHeight / 2 + boardHeight])
			cube([2.54, 2.54 * 8, headerHeight ], center=true);

		//Bottom row
		translate( [  50.8, 36.83, headerHeight / 2 + boardHeight])
			cube([2.54, 2.54 * 8, headerHeight ], center=true);
		translate( [ 50.8, 57.15, headerHeight / 2 + boardHeight])
			cube([2.54, 2.54 * 6, headerHeight ], center=true);
	} else {
		echo("Board type not found");
	}

}



//Arduino dimensions

boardHeight = 1.7;

arduinoWidth = 53.34;
leonardoDepth = 68.58 + 1.1;
unoDepth = 68.58 + 6.5;
dueDepth = 101.6 + 6.5;
arduinoHeight = 11 + boardHeight + 0;


mountingHoleRadius = 3.2 / 2;

headerWidth = 0;
headerDepth = 0;
headerHeight = 9;

unoBoardPath = [ 
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

dueBoardPath = [ 
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
