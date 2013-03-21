# Arduino OpenSCAD library

The library has a variety of modules for creating Arduinos and Arduino mounts. Here is a basic description of the included modules. For examples see the included example SCAD.

###arduino(boardType)
boardType - "Uno", "Leonardo", "Duemilanove", "Diecimila", "Due", "Mega", "Mega 2560"

This module creates an Arduino board with USB connector, power supply and headers.

###standoffs(boardType, height, bottomRadius, topRadius)
boardType - "Uno", "Leonardo", "Duemilanove", "Diecimila", "Due", "Mega", "Mega 2560"
height - height of standoffs
bottomRadius - Radius of bottom of standoff cylinder.
topRadius - Radius of top of standoff cylinder.
holeRadius - Radius of tap hole in the standoff.

This creates standoffs for mounting holes. These are simple cylinders that can be tapered. For custom standoffs use the holePlacement() module.

###boardShape( boardType, offset, height )
boardType - "Uno", "Leonardo", "Duemilanove", "Diecimila", "Due", "Mega", "Mega 2560"
offset - creates the shape offset from actual board size. Negative values create an inset shape.
height - default is board height but can be any value needed.

This creates the shape of the PCB with no holes. The default create a basic Uno PCB.

###boundingBox(boardType = "Uno")
boardType - "Uno", "Leonardo", "Duemilanove", "Diecimila", "Due", "Mega", "Mega 2560"

This creates a box whos dimensions are the extremes of the board.

###holePlacement()
boardType - "Uno", "Leonardo", "Duemilanove", "Diecimila", "Due", "Mega", "Mega 2560"

This is used for placing holes and is the basis of the standoff module. holePlacement takes a child element and places it at each of the mounting hole centers for a given board.

###usb(boardType, extension, offset)
boardType - "Uno", "Leonardo", "Duemilanove", "Diecimila", "Due", "Mega", "Mega 2560"
extension - Extention off the board in direction of connector. The default is the stand dimension of the connector, but can be set to an arbitrary value.
offset - Offsets the connector cube in the other dimensions.

Creates the usb connector for a given board. Also used for creating punchout, by using the extension and offset values.

###power(boardType, extension, offset)
boardType - "Uno", "Leonardo", "Duemilanove", "Diecimila", "Due", "Mega", "Mega 2560"
extension - Extention off the board in direction of connector. The default is the stand dimension of the connector, but can be set to an arbitrary value.
offset - Offsets the connector cube in the other dimensions.

Creates the power jack for a given board. Also used for creating knockouts, by using the extension and offset values.

###headers(boardType, extension, offset)
boardType = "Uno", "Leonardo", "Duemilanove", "Diecimila", "Due", "Mega", "Mega 2560"
extension - Extention off the board in direction of connector. The default is the stand dimension of the connector, but can be set to an arbitrary value.
offset - Offsets the connector cube in the other dimensions.

Creates the headers for a given board. Also used for creating knockouts, by using the extension and offset values.
