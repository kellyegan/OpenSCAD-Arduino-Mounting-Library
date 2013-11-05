include <arduino.scad>

//Arduino boards
//You can create a boxed out version of a variety of boards by calling the arduino() module
//The default board for all functions is the Uno

dueDimensions = boardDimensions( DUE );
unoDimensions = boardDimensions( UNO );

//Board mockups
arduino();

translate( [unoDimensions[0] + 50, 0, 0] )
	arduino(DUE);

translate( [-(unoDimensions[0] + 50), 0, 0] )
	arduino(LEONARDO);

translate([0, 0, -75]) {
	enclosure();

	translate( [unoDimensions[0] + 50, 0, 0] )
		bumper(DUE);

	translate( [-(unoDimensions[0] + 50), 0, 0] ) union() {
		standoffs(LEONARDO, mountType=PIN);
		boardShape(LEONARDO, offset = 3);
	}
}

translate([0, 0, 75]) {
	enclosureLid();
}
