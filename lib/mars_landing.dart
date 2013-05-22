library mars_landing;

import 'dart:collection';

import 'direction.dart';
import 'planet.dart';
import 'robot.dart';

//import 'package:logging_handlers/logging_handlers_shared.dart';
//import 'package:logging/logging.dart';

//final _logger = new Logger("mars_landing");

/// top level function to carry out the mars landing project.
/// Returns the result of all the processed commands.
String landOnMars(String commands) {
  if (commands == null || commands.trim().length == 0) throw new ArgumentError("commands must be specified");
  List<String> commandLines = commands.replaceAll("\r\n","\n").split("\n");
  if (commandLines.length == 0) throw new RuntimeError("Cannot create Mars - no commands entered");

  var commandQueue = new Queue<String>.from(commandLines);

  var marsSize = commandQueue.removeFirst();
  print("creating mars");
  var planetMars = new Planet.fromString(marsSize);
  print("created mars");

  var result = new StringBuffer();

  var robot = getNextRobot(commandQueue);
  print("Got next robot: $robot");
  while (robot != null) {
    while (robot.isActive && robot.hasCommands) {
      if (!robot.runNextCommand(planetMars)) {
        break; // robot is dead.
      }
    }

    if (robot.isActive) {
      // robot lives!
      var msg = "${robot.position.x} ${robot.position.y} ${robot.facing.ident}";

      result.writeln(msg);
    }
    else {
      // robot's lost.
      var msg = "${robot.position.x} ${robot.position.y} ${robot.facing.ident} LOST";
      result.writeln(msg);
    }

    print(commandQueue);
    robot = getNextRobot(commandQueue);
    print("Got next robot: $robot");
  }

  return result.toString();
}


/// Returns a list of exactly two command strings.  The first element
/// defines the robots starting position
/// the second element defines the commands that the robot should process.
Robot getNextRobot(Queue<String> commandQueue) {
  // each robot is defined by the first line following a whitespace / blank line.
  // Remove whitespace lines until we find the first line containing real data.
  var initialization = "";
  var robot = null;

  // continue while we've not got a robot
  while (!commandQueue.isEmpty && robot == null) {
    var initialization = commandQueue.removeFirst().trim(); // the contents of the command queue is modified

    if (initialization != null && initialization.length > 0) {
      if (!commandQueue.isEmpty) {
        print("Init: $initialization");
        print("Cmds: robotCommands");
        var robotCommands = commandQueue.removeFirst().trim();
        robot =  new Robot(initialization, robotCommands,[new TurnLeftCommand(), new TurnRightCommand(), new MoveForwardCommand()]);
      }
      else {
        throw new RuntimeError("Robot initialization exists without commands");
      }
    }
  }

  return robot; // robot, or null if there are no commands left.
}