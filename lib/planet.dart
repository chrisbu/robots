library planet;

import 'direction.dart';

part 'src/planet/point.dart';

class Planet {
  final Position maxPosition;
  final Position minPosition = new Position(0,0);
  final List<Position> _robotScents = new List<Position>();

  Planet(this.maxPosition);

  /// Allows creation of a planet with a max bounds from a string.
  /// Eg: "4 6" will create a planet with maxX=4 and maxY=6
  factory Planet.fromString(maxPositionString) {
    var maxPosition = new Position.fromString(maxPositionString);
    return new Planet(maxPosition);
  }

  /// Is the [position] out of bounds (in any direction?
  bool isOutOfBounds(Position position) => (position > maxPosition) || (position < minPosition);

  /// Is there a robot scent left at the [position]
  bool hasRobotScent(Position position) {
    var matchingPosition = null;
    // find the first position in the list that matches the input position
    return _robotScents.contains(position);
    //return matchingPosition != null; // if not null, then there's a scent.
  }

  addScent(Position position) => _robotScents.add(position);
}