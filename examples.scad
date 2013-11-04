include <arduino.scad>

//Arduino boards
//You can create a boxed out version of a variety of boards by calling the arduino() module
//The default board for all functions is the Uno

dueDimensions = boardDimensions( DUE );
unoDimensions = boardDimensions( UNO );

//Board mockups
arduino();

translate( [unoDimensions[0] + 30, 0, 0] )
	arduino(MEGA);

translate( [-(unoDimensions[0] + 30), 0, 0] )
	arduino(LEONARDO);

translate([0, 0, -75]) {
	enclosure();

	translate( [unoDimensions[0] + 30, 0, 0] )
		bumper(MEGA);

	translate( [-(unoDimensions[0] + 30), 0, 0] ) union() {
		standoffs(LEONARDO, mountType=PIN);
		boardShape(LEONARDO, offset = 3);
	}
}

translate([0, 0, 75]) {
	enclosureLid();
}



//
////Standoffs
////The standoffs() module allows you to place standoff posts at each of the mounting holes
//color("OrangeRed") translate( [ 0, -(dueDimensions[1] + 20), 0] ) {
//	standoffs();
//	
//	translate( [unoDimensions[0] + 30, 0, 0] )
//		standoffs(DUE, height = 20);
//	
//	translate( [-(unoDimensions[0] + 30), 0, 0] )
//		standoffs(LEONARDO, bottomRadius = 5);
//}
//
////Board shape
////Creates the board shape with holes or components
//color("DarkOrange") translate([0, 0, 0]) {	
//	boardShape();
//
//	//the Shape height can be changed from the default board height
//	translate( [unoDimensions[0] + 30, 0, 0] )
//		boardShape(boardType=DUE, height = 8);
//
//	//The shape can also be offset. Negative values will create an inset.
//	translate( [-(unoDimensions[0] + 30), 0, 0] )
//		boardShape(boardType=LEONARDO, offset=10);
//}
//
//
////Bounding box
////Creates a box that contains the board including usb connector and headers
//
//translate( [ 0, dueDimensions[1] + 20, 0] ) {
//	boundingBox();
//	
//	//You can change the height value
//	translate( [unoDimensions[0] + 30, 0, 0] )
//		boundingBox(DUE, height = 2);
//	
//	//You can also offset the boundaries of the box as well
//	translate( [-(unoDimensions[0] + 30), 0, 0] )
//		boundingBox(LEONARDO, offset=5);
//}
//
