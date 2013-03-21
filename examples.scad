include <arduino.scad>

//Arduino boards
//You can create a boxed out version of a variety of boards by calling the arduino() module
//The default board for all functions is the Uno

translate([0,-2 * (dueDepth + 20),0]) {
	arduino();
	
	translate( [arduinoWidth + 30, 0, 0] )
		arduino("Due");
	
	translate( [-(arduinoWidth + 30), 0, 0] )
		arduino("Leonardo");
}


//Standoffs
//The standoffs() module allows you to place standoff posts at each of the mounting holes

translate( [ 0, -(dueDepth + 20), 0] ) {
	standoffs();
	
	translate( [arduinoWidth + 30, 0, 0] )
		standoffs("Due", height = 20);
	
	translate( [-(arduinoWidth + 30), 0, 0] )
		standoffs("Leonardo", bottomRadius = 5);
}

//Board shape
//Creates the board shape with holes or components
translate([0, 0, 0]) {	
	boardShape();

	//the Shape height can be changed from the default board height
	translate( [arduinoWidth + 30, 0, 0] )
		boardShape(boardType="Due", height = 8);

	//The shape can also be offset. Negative values will create an inset.
	translate( [-(arduinoWidth + 30), 0, 0] )
		boardShape(boardType="Leonardo", offset=3);
}


//Bounding box
//Creates a box that contains the board including usb connector and headers

translate( [ 0, dueDepth + 20, 0] ) {
	boundingBox();
	
	//You can change the height value
	translate( [arduinoWidth + 30, 0, 0] )
		boundingBox("Due", height = 2);
	
	//You can also offset the boundaries of the box as well
	translate( [-(arduinoWidth + 30), 0, 0] )
		boundingBox("Leonardo", offset=5);
}

