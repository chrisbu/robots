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
  
  test("constructor should initialize fields", () {
    
    var p = new Point(X,Y);
    expect(p.x, equals(X));
    expect(p.y, equals(Y));
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