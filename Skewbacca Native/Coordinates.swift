import Cocoa

struct Coordinates {
    var TL: CIVector;
    var TR: CIVector;
    var BL: CIVector;
    var BR: CIVector;
}

enum Directions {
    case TL, TR, BL, BR
}
