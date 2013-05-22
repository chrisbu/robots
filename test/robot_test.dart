library robot_test.dart;

import 'package:unittest/unittest.dart';

import 'package:robot/robot.dart';

/// Included to allow stand-alone execution
main() => runTests();

runTests() {
  group("robot", robotTests);
  group("commands:", commandTests);
}

robotTests() {
  test("constructor", () {
    var robot = new Robot("N","2 5", [new TurnLeftCommand(), new TurnRightCommand(), new MoveForwardCommand()]);
  });
}

commandTests() {

}