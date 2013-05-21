part of planet;


/// Represents a point on a grid, eastings represented by [x], northings
/// represented by [y]
class Point {
  /// The position along the horizontal axis
  num get x => _x;
  set x(value) {
    if (value == null) throw new ArgumentError("x");
    _x = value;
  }
  
  /// The position along the vertical axis
  num get y => _y;
  set y(value) {
    if (value == null) throw new ArgumentError("y");
    _y = value;
  }
  
  /// Create a initialized point.
  Point(num x, num y) {
    this.x = x;
    this.y = y;
  }
  
  // private fields
  num _x; 
  num _y; 
}


