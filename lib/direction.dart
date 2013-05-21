library direction;

import 'package:robot/planet.dart';

/// Translate the current position to a new position for the current 
/// direction instance.
typedef Point MoveFunc(Point currentPosition);

/**
 * Interface to define how a direction works 
 * 
 * For any given direction, you can [turnLeft], [turnRight] or [move] 
 * one position in that direction.
 */
abstract class Direction {
  Direction turnLeft();
  Direction turnRight();
  MoveFunc move;
}

class MajorCompassFacing implements Direction {
  static final NORTH_CHAR = "N";
  static final EAST_CHAR = "E";
  static final SOUTH_CHAR = "S";
  static final WEST_CHAR = "W";
  
  final String ident;
  
  factory MajorCompassFacing(ident, moveFunc) {
    var result = facings[ident];
    if (result == null) {
      result = new MajorCompassFacing._(ident, moveFunc);
      facings[ident] = result;
    }
    
    return result;
  }
  
  MajorCompassFacing._(this.ident, this.move);
  
  /**
   * Need to initialize the reference data
   */
  static initialize() {
    // this might be loaded from the DB in a larger solution.    
    // calling each of these values populates the [facing] and [directionCycle] 
    // collections
    NORTH;
    EAST;
    SOUTH;
    WEST;
    
    _directionCycle[0] = NORTH;
    _directionCycle[1] = EAST;
    _directionCycle[2] = SOUTH;
    _directionCycle[3] = WEST;
    _directionCycle[4] = NORTH; // back to north again, so that we can
                                // go LEFT from north
  }
  
  static final facings = new Map<String, MajorCompassFacing>();
  
  static final NORTH = new MajorCompassFacing(NORTH_CHAR, (p) => p..y = p.y - 1);
  static final EAST = new MajorCompassFacing(EAST_CHAR, (p) => p..x = p.x + 1);
  static final SOUTH = new MajorCompassFacing(SOUTH_CHAR, (p) => p..y = p.y + 1);
  static final WEST = new MajorCompassFacing(WEST_CHAR, (p) => p..x = p.x - 1);
  
  static final _directionCycle = new List(5);
  static List get directionCycle => _directionCycle;
  
  /// Find this item in the DirectionCycle (starting at the second element),
  /// and return the item immediately before it (turning left).
  turnLeft() => directionCycle[directionCycle.indexOf(this, 1)-1];

  /// Find this item in the DirectionCycle (starting at the first  element),
  /// and return the item immediately after it (turning right).
  turnRight() => directionCycle[directionCycle.indexOf(this, 0)+1];
  
  MoveFunc move;
  
  toString() => "MajorCompassPoint: $ident";
  
}