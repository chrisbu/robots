library planet;

import 'direction.dart';

part 'src/planet/point.dart';

class Planet {
  final Point maxPosition;
  final Point minPosition = new Point(0,0);
  final List<Point> _robotScents = new List<Point>();

  Planet(this.maxPosition);

  /// Allows creation of a planet with a max bounds from a string.
  /// Eg: "4 6" will create a planet with maxX=4 and maxY=6
  factory Planet.fromString(maxPositionString) {
    var maxPosition = new Point.fromString(maxPositionString);
    return new Planet(maxPosition);
  }

  /// Is the [position] out of bounds (in any direction?
  bool isOutOfBounds(Point position) => (position > maxPosition) || (position < minPosition);

  /// Is there a robot scent left at the [position]
  bool hasRobotScent(Point position) {
    var matchingPosition = null;
    // find the first position in the list that matches the input position
    return _robotScents.contains(position);
    //return matchingPosition != null; // if not null, then there's a scent.
  }

  addScent(Point position) => _robotScents.add(position);
}