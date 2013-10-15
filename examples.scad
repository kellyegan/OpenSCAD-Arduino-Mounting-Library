include <arduino.scad>

//Arduino boards
//You can create a boxed out version of a variety of boards by calling the arduino() module
//The default board for all functions is the Uno

translate([0,-2 * (boardDepth[DUE] + 20),0]) {
	arduino();
	
	translate( [boardWidth[UNO] + 30, 0, 0] )
		arduino(DUE);
	
	translate( [-(boardWidth[UNO] + 30), 0, 0] )
		arduino(LEONARDO);
}


//Standoffs
//The standoffs() module allows you to place standoff posts at each of the mounting holes

translate( [ 0, -(boardDepth[DUE] + 20), 0] ) {
	standoffs();
	
	translate( [boardWidth[UNO] + 30, 0, 0] )
		standoffs(DUE, height = 20);
	
	translate( [-(boardWidth[UNO] + 30), 0, 0] )
		standoffs(LEONARDO, bottomRadius = 5);
}

//Board shape
//Creates the board shape with holes or components
translate([0, 0, 0]) {	
	boardShape();

	//the Shape height can be changed from the default board height
	translate( [boardWidth[UNO] + 30, 0, 0] )
		boardShape(boardType=DUE, height = 8);

	//The shape can also be offset. Negative values will create an inset.
	translate( [-(boardWidth[UNO] + 30), 0, 0] )
		boardShape(boardType=LEONARDO, offset=3);
}


//Bounding box
//Creates a box that contains the board including usb connector and headers

translate( [ 0, boardDepth[DUE] + 20, 0] ) {
	boundingBox();
	
	//You can change the height value
	translate( [boardWidth[UNO] + 30, 0, 0] )
		boundingBox(DUE, height = 2);
	
	//You can also offset the boundaries of the box as well
	translate( [-(boardWidth[UNO] + 30), 0, 0] )
		boundingBox(LEONARDO, offset=5);
}

