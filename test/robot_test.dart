library robot_test.dart;

import 'package:unittest/unittest.dart';

import 'package:robot/robot.dart';
import 'package:robot/direction.dart';
import 'package:robot/planet.dart';

/// Included to allow stand-alone execution
main() => runTests();

runTests() {
  group("robot", robotTests);
  group("commands:", commandTests);
}

robotTests() {
  test("constructor", () {
    var robot = getRobotWithCommands();
    expect(robot.commands.length, equals(3));
    expect(robot.facing, equals(MajorCompassFacing.NORTH));
    expect(robot.position, equals(new Point(2,5)));
  });

  test("run turn left command", () {
    var robot = getRobotWithCommands();
    robot.runCommand("L", new Planet.fromString("10 10"));
    expect(robot.facing, equals(MajorCompassFacing.WEST));
  });

  test("run turn right command", () {
    var robot = getRobotWithCommands();
    robot.runCommand("R", new Planet.fromString("10 10"));
    expect(robot.facing, equals(MajorCompassFacing.EAST));
  });
}

Robot getDefaultRobot() => new Robot("N","2 5", []);
Robot getRobotWithCommands() => new Robot("N","2 5", [new TurnLeftCommand(), new TurnRightCommand(), new MoveForwardCommand()]);

commandTests() {
  test("turn left command", () {
    var cmd = new TurnLeftCommand();
    var result = cmd.execute(getDefaultRobot());
    expect(result.facing, equals(MajorCompassFacing.WEST));
  });

  test("turn right command", () {
    var cmd = new TurnRightCommand();
    var result = cmd.execute(getDefaultRobot());
    expect(result.facing, equals(MajorCompassFacing.EAST));
  });

  test("move forward command", () {
    var cmd = new MoveForwardCommand();
    var result = cmd.execute(getDefaultRobot());
    expect(result.position, equals(new Point(2,6)));
  });
}