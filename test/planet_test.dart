library planet_test;

import 'package:unittest/unittest.dart';
import 'package:robot/planet.dart';

/// Included to allow stand-alone execution
main() => runTests();

runTests() {
  group("Point:", test_point);
}

/**
 * Tests to test the Point class.
 */
test_point() {
  final X = 2;
  final Y = 3;

  group("default constructor:", () {
    test("should initialize fields", () {
      var p = new Point(X,Y);
      expect(p.x, equals(X));
      expect(p.y, equals(Y));
    });

    group("fromString:", () {
      test("happy path", () {
        var p = new Point.fromString("2 3");
        expect(p.x, equals(X));
        expect(p.y, equals(Y));
      });

      test("invalid string raises error", () {
        var argError = null;
        try {
          var p = new Point.fromString("foo");
        }
        on ArgumentError catch(ex) {
          argError = ex;
        }
        expect(argError, isNotNull);
      });

      test("only 1 element raises error", () {
        var argError = null;
        try {
          var p = new Point.fromString("2");
        }
        on ArgumentError catch(ex) {
          argError = ex;
        }
        expect(argError, isNotNull);
      });

      test("non integer raises error", () {
        var error = null;
        try {
          var p = new Point.fromString("2 X");
        }
        on StringConversionError catch(ex) {
          print(ex);
          error = ex;
        }
        expect(error, isNotNull);
      });
    });


  });

  group("comparator:", () {
    test("equals", () {
      var pointA = new Point(1,2);
      var pointB = new Point(1,2);
      expect(pointA == pointB, isTrue);
    });

    test("does not equal (X)", () {
      var pointA = new Point(1,2);
      var pointB = new Point(2,2);
      expect(pointA == pointB, isFalse);
    });

    test("does not equal (Y)", () {
      var pointA = new Point(1,2);
      var pointB = new Point(1,1);
      expect(pointA == pointB, isFalse);
    });

    test("does not equal (null)", () {
      var pointA = new Point(1,2);
      expect(pointA == null, isFalse);
    });

    test("does not equal (String)", () {
      var pointA = new Point(1,2);
      expect(pointA == "Foo", isFalse);
    });
  });

  group("null values not allowed in constructor:", () {
    test("x", () {
      var xArgError = null;
      try {
        var p = new Point(null,Y);
      }
      on ArgumentError catch (ex) {
        xArgError = ex;
      }
      expect(xArgError, isNotNull);
      expect(xArgError.message, equals("x"));
    });

    test("y", () {
      var yArgError = null;
      try {
        var p = new Point(X,null);
      }
      on ArgumentError catch (ex) {
        yArgError = ex;
      }
      expect(yArgError, isNotNull);
      expect(yArgError.message, equals("y"));
    });
  });

  group("fields cannot be set to null:", () {
    test("x", () {
      var p = new Point(X,Y);
      var xArgError = null;
      try {
        p.x = null;
      }
      on ArgumentError catch (ex) {
        xArgError = ex;
      }
      expect(xArgError, isNotNull);
      expect(xArgError.message, equals("x"));
    });

    test("y", () {
      var p = new Point(X,Y);
      var xArgError = null;
      try {
        p.y = null;
      }
      on ArgumentError catch (ex) {
        xArgError = ex;
      }
      expect(xArgError, isNotNull);
      expect(xArgError.message, equals("y"));
    });
  });
}