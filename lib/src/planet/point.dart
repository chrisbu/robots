part of planet;

class StringConversionError extends RuntimeError {
  StringConversionError(stringValue) : super("Could not convert $stringValue");
  String toString() => "StringConversionError: $message";
}

/// Represents a point on a grid, eastings represented by [x], northings
/// represented by [y]
class Point {
  /// The position along the horizontal axis
  int get x => _x;
  set x(value) {
    _x = value;
    _validate();
  }

  /// The position along the vertical axis
  int get y => _y;
  set y(value) {
    _y = value;
    _validate();
  }

  /// Create a initialized point.
  Point(int x, int y) {
    this._x = x;
    this._y = y;
    _validate();
  }

  /// Create a new [Point] from the [positionString]
  /// The input string must contain two [num] values separated
  /// by a single space.
  Point.fromString(String positionStr) {
    if (positionStr == null) throw new ArgumentError("positionStr");
    var elements = positionStr.split(" ");
    if (elements.length != 2) throw new ArgumentError("positionStr");

    // try and extract the two elements as ints. Throw error if not valid.
    this._x = int.parse(elements[0], onError: (err) => throw new StringConversionError(err));
    this._y = int.parse(elements[1], onError: (err) => throw new StringConversionError(err));
    _validate();
  }

  /// Override == to allow direct comparison of [Point]
  operator ==(other) {
    if (other == null || other is! Point) return false;
    return this.x == other.x && this.y == other.y;
  }

  /// Allows greater-than comparison with another point.  If **either** of the
  /// X or Y coordinates are greater, returns true.
  operator >(other) {
    if (other == null || other is! Point) return throw new ArgumentError(other);
    return this.x > other.x || this.y > other.y;
  }

  /// Allows less-than comparison with another point.  If **either** of the
  /// X or Y coordinates are less, returns true.
  operator <(other) {
    if (other == null || other is! Point) return throw new ArgumentError(other);
    return this.x < other.x || this.y < other.y;
  }

  toString() => "[$x, $y]";


  // private fields
  int _x;
  int _y;

  // private methods
  _validate() {
    if (x == null) throw new ArgumentError("x");
    if (x < 0 || x > 50) throw new RuntimeError("X co-ordintate must be between 0 and 50 inclusive");
    if (y== null) throw new ArgumentError("y");
    if (y < 0 || y > 50) throw new RuntimeError("Y co-ordintate must be between 0 and 50 inclusive");
  }
}


