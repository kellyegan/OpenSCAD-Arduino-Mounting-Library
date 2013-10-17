# Arduino Mounting OpenSCAD library

The library has a variety of modules for creating Arduinos and Arduino mounts. Here is a basic description of the included modules. It includes all official boards through the Due. For examples see the included example SCAD.

###arduino(boardType)
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560

*This module creates an Arduino board with USB connector, power supply and headers.*

###box(boardType)
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560

*Creates a sliding box enclosure for a particular board*

###lid(boardType)

*Create a lid for the sliding box.

###bumper(boardType)
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560

*Create a simple bumper style encloser for a particular board*

###standoffs(boardType, height, bottomRadius, topRadius)
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560

**height** - height of standoffs

**bottomRadius** - Radius of bottom of standoff cylinder.

**topRadius** - Radius of top of standoff cylinder.

**holeRadius** - Radius of tap hole in the standoff.

*This creates standoffs for mounting holes. These are simple cylinders that can be tapered. For custom standoffs use the holePlacement() module.*

###boardShape( boardType, offset, height )
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560

**offset** - creates the shape offset from actual board size. Negative values create an inset shape.

**height** - default is pcb height but can be any value needed.

*This creates the shape of the PCB with no holes. The default create a basic Uno PCB.*

###boundingBox(boardType, offset, height)
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560

**offset** - creates the shape offset from actual board size. Negative values create an inset shape.

**height** - default is board height (including components) but can be any value needed.

*This creates a box whos dimensions are the extremes of the board.*

###holePlacement()
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560

*This is used for placing holes and is the basis of the standoff module. holePlacement takes a child element and places it at each of the mounting hole centers for a given board.*

###components(boardType, component, extension, offset)
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560

**component** - HEADERS, USB, POWER

**extension** - Extention off the board in direction of connector. The default is the stand dimension of the connector, but can be set to an arbitrary value.

**offset** - Offsets the connector cube in the other dimensions.

*Creates the components( headers, power and usb jacks) for a given board. Also used for creating punchout, by using the extension and offset values.*

