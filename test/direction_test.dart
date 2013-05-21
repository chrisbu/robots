library direction_test.dart;

import 'package:unittest/unittest.dart';

import 'package:robot/direction.dart';

/// Included to allow stand-alone execution
main() => runTests();

runTests() {
  group("MajorCompassFacing:", test_majorCompassFacing);
}

test_majorCompassFacing() {
  MajorCompassFacing.initialize();
  
  test("point is looked up from facings by character", () {
    var north = MajorCompassFacing.facings[MajorCompassFacing.NORTH_CHAR];
    expect(north, equals(MajorCompassFacing.NORTH));
    
    var south = MajorCompassFacing.facings[MajorCompassFacing.SOUTH_CHAR];
    expect(south, equals(MajorCompassFacing.SOUTH));
    
    var west = MajorCompassFacing.facings[MajorCompassFacing.WEST_CHAR];
    expect(west, equals(MajorCompassFacing.WEST));
    
    var east = MajorCompassFacing.facings[MajorCompassFacing.EAST_CHAR];
    expect(east, equals(MajorCompassFacing.EAST));
  });
  
  test("we can turn left until we get back to the original point", () {
    expect(MajorCompassFacing.NORTH.turnLeft(), equals(MajorCompassFacing.WEST));
    expect(MajorCompassFacing.WEST.turnLeft(), equals(MajorCompassFacing.SOUTH));
    expect(MajorCompassFacing.SOUTH.turnLeft(), equals(MajorCompassFacing.EAST));
    expect(MajorCompassFacing.EAST.turnLeft(), equals(MajorCompassFacing.NORTH));
  });
  
  test("we can turn right until we get back to the original point", () {
    expect(MajorCompassFacing.NORTH.turnRight(), equals(MajorCompassFacing.EAST));
    expect(MajorCompassFacing.EAST.turnRight(), equals(MajorCompassFacing.SOUTH));
    expect(MajorCompassFacing.SOUTH.turnRight(), equals(MajorCompassFacing.WEST));
    expect(MajorCompassFacing.WEST.turnRight(), equals(MajorCompassFacing.NORTH));
  });
}