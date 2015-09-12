# OpenSCAD Arduino Mounting library

The library has a variety of modules for creating Arduinos and Arduino mounts. Here is a basic description of the included modules. It includes all official boards through the Due. For examples see the included example SCAD.

![openscadarduinomounting](https://cloud.githubusercontent.com/assets/492003/9833469/f1cbe2dc-5965-11e5-8357-0297916c8885.jpg)

###arduino(boardType)
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560, ETHERNET

*This module creates an Arduino board with USB connector, power supply and headers.*

###bumper(boardType, mountingHoles)
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560, ETHERNET

**mountingHoles** - (OPTIONAL) True or false for external mounting holes for bumper. 

*Create a simple bumper style encloser for a particular board*

###enclosure(boardType, wall, offset, heightExtension, cornerRadius, mountType)
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560, ETHERNET

**wall** - Thickness of enclosure walls. Default is 3.

**offset** - Distance of PCB from walls.

**heightExtension** - Additional space at the top of the box.

**cornerRadius** - Corner radius for outside of box.

**mountType** - TAPHOLES, PINS How the standoffs attach to the board either using tap holes for screws or pins.

*Creates a box enclosure with a snap-on lid for a particular board*

###enclosureLid(boardType, wall, offset, cornerRadius, ventHoles)
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560, ETHERNET

**wall** - Thickness of enclosure walls. Default is 3.

**offset** - Distance of PCB from walls.

**cornerRadius** - Corner radius for outside of box.

**ventHoles** - true, false for holes in the lid.

*Creates a lid for the box enclosure*

###standoffs(boardType, height, bottomRadius, topRadius)
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560, ETHERNET

**height** - height of standoffs

**bottomRadius** - Radius of bottom of standoff cylinder.

**topRadius** - Radius of top of standoff cylinder.

**holeRadius** - Radius of tap hole in the standoff.

*This creates standoffs for mounting holes. These are simple cylinders that can be tapered. For custom standoffs use the holePlacement() module.*

###boardShape( boardType, offset, height )
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560, ETHERNET

**offset** - creates the shape offset from actual board size. Negative values create an inset shape.

**height** - default is pcb height but can be any value needed.

*This creates the shape of the PCB with no holes. The default create a basic Uno PCB.*

###boundingBox(boardType, offset, height, cornerRadius, include)
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560, ETHERNET

**offset** - creates the shape offset from actual board size. Negative values create an inset shape.

**height** - default is board height (including components) but can be any value needed.

**cornerRadius** - 

**include** - BOARD, PCB, COMPONENTS What to include in bounding box, just the PCB, just the components or both (BOARD)

*This creates a box whos dimensions are the extremes of the board.*

###holePlacement()
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560, ETHERNET

*This is used for placing holes and is the basis of the standoff module. holePlacement takes a child element and places it at each of the mounting hole centers for a given board.*



###components(boardType, component, extension, offset)
**boardType** - UNO, LEONARDO, DUEMILANOVE, DIECIMILA, DUE, MEGA, MEGA 2560, ETHERNET

**component** - ALL, HEADER\_F, HEADER\_M, USB, POWER, RJ45

**extension** - Extention off the board in direction of connector. The default is the standard dimension of the connector, but can be set to an arbitrary value.

**offset** - Offsets the connector cube in the other two dimensions.

*Creates the components( headers, power and usb jacks) for a given board. Also used for creating punchout, by using the extension and offset values.*

