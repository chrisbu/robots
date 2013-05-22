library direction_test.dart;

import 'package:unittest/unittest.dart';
import 'package:robot/planet.dart';
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

  group("comparator:", () {
    test("equals", () {
      expect(MajorCompassFacing.NORTH == MajorCompassFacing.NORTH, isTrue);
    });

    test("does not equal", () {
      expect(MajorCompassFacing.NORTH != MajorCompassFacing.SOUTH, isTrue);
    });

    test("does not equal (null)", () {
      expect(MajorCompassFacing.NORTH == null, isFalse);
    });

    test("does not equal (String)", () {
      expect(MajorCompassFacing.NORTH == "Foo", isFalse);
    });
  });

  group("turn:", () {
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
  });

  group("moving:", () {
    final X = 2;
    final Y = 3;

    test("a point is translated y+1 to move north", () {
      final point = new Point(X,Y);
      final movedPoint = MajorCompassFacing.NORTH.move(point);
      expect(movedPoint.x, equals(X),reason:"x should not be translated");
      expect(movedPoint.y, equals(Y+1), reason: "y should be inc by 1");
    });

    test("a point is translated x+1 to move east", () {
      final point = new Point(X,Y);
      final movedPoint = MajorCompassFacing.EAST.move(point);
      expect(movedPoint.x, equals(X+1),reason:"x should be inc by 1");
      expect(movedPoint.y, equals(Y), reason: "y should not be translated");
    });

    test("a point is translated y-1 to move south", () {
      final point = new Point(X,Y);
      final movedPoint = MajorCompassFacing.SOUTH.move(point);
      expect(movedPoint.x, equals(X),reason:"x should not be translated");
      expect(movedPoint.y, equals(Y-1), reason: "y should be dec by 1");
    });

    test("a point is translated x-1 to move west", () {
      final point = new Point(X,Y);
      final movedPoint = MajorCompassFacing.WEST.move(point);
      expect(movedPoint.x, equals(X-1),reason:"x should be dec by 1");
      expect(movedPoint.y, equals(Y), reason: "y should not be translated");
    });
  });
}