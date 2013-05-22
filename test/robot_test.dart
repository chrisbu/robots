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
    expect(robot.commandLibrary.length, equals(3));
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

  group("following commands", () {
    test("go in a circle", () {
      var robot = new Robot("2 5 N", "FLFLFLFL", [new TurnLeftCommand(), new TurnRightCommand(), new MoveForwardCommand()]);
      var planet = new Planet.fromString("10 10");
      robot.runNextCommand(planet); // forward
      expect(robot.position, equals(new Point(2,6)));
      robot.runNextCommand(planet); // left`
      expect(robot.facing, equals(MajorCompassFacing.WEST));

      robot.runNextCommand(planet); // forward
      expect(robot.position, equals(new Point(1,6)));
      robot.runNextCommand(planet); // left`
      expect(robot.facing, equals(MajorCompassFacing.SOUTH));

      robot.runNextCommand(planet); // forward
      expect(robot.position, equals(new Point(1,5)));
      robot.runNextCommand(planet); // left`
      expect(robot.facing, equals(MajorCompassFacing.EAST));

      robot.runNextCommand(planet); // forward
      expect(robot.position, equals(new Point(2,5)));
      robot.runNextCommand(planet); // left`
      expect(robot.facing, equals(MajorCompassFacing.NORTH));

      expect(robot.hasCommands, isFalse);
    });

    test("fall off the map", () {
      var robot = new Robot("2 2 W", "FFF", [new TurnLeftCommand(), new TurnRightCommand(), new MoveForwardCommand()]);
      var planet = new Planet.fromString("10 10");
      robot.runNextCommand(planet); // forward
      expect(robot.position, equals(new Point(1,2)));
      robot.runNextCommand(planet); // forward
      expect(robot.position, equals(new Point(0,2)));
      
      // next command will fall of the planet
      var result = robot.runNextCommand(planet); // forward
      expect(result, isFalse); // should have returned false, as the robot is nolonger active
      expect(robot.position, equals(new Point(-1,2))); 
      expect(robot.isActive, isFalse); // should be false
      expect(planet.hasRobotScent(new Point(0,2)), isTrue); // there should be a scent for the place where it fell off the map
    });
  });
}

Robot getDefaultRobot() => new Robot("2 5 N", "FLF", []);
Robot getRobotWithCommands() => new Robot("2 5 N", "FLF", [new TurnLeftCommand(), new TurnRightCommand(), new MoveForwardCommand()]);

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