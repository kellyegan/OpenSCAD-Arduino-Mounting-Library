arduino();
translate([arduinoWidth + 5, 0, 0])
	arduino("Due");
translate([-(arduinoWidth + 5), 0, 0])
	arduino("Leonardo");

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
}

module boundingBox(boardType = "Uno") {

}

//Creates standsoff for different boards
module standoffs( boardType = "Uno", height = 10, topRadius = mountingHoleRadius + 1, bottomRadius =  mountingHoleRadius + 2, tapHole = mountingHoleRadius * 0.75 ) {
	holePlacement(boardType = boardType)
		difference() {
			cylinder(r1 = bottomRadius, r2 = topRadius, h = height, $fn=32);
			cylinder(r =  tapHole, h = height * 4, center = true, $fn=32);
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
		translate([11.2 - offset, -(1.1 + extend ), boardHeight - offset])
			cube([7.5 + offset, 5.9 + extend, 3 + offset]);
	} else {
		//B USB
		translate([9.34 - offset, -(6.5 + extend), boardHeight - offset]) 
			cube([12 + offset * 2, 16 + extend, 11 + offset * 2]);
	}
}

//similar to usb function but for the power jack
module power( boardType = "Uno", extend = 0, offset = 0 ) {
	translate([41.14 - offset,-(1.8 + extend), boardHeight - offset])
		cube([9 + offset * 2, 13.2 + extend, 10.9 + offset * 2]);
}

module headers( boardType = "Uno", extend = 0, offset = 0 ) {

}



//Arduino dimensions

boardHeight = 1.7;

arduinoWidth = 53.34;
unoDepth = 68.58;
dueDepth = 101.6;
arduinoHeight = 11 + boardHeight;

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
