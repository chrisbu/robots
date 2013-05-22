library mars_landing;

import 'dart:collection';

import 'direction.dart';
import 'planet.dart';
import 'robot.dart';

import 'package:logging_handlers/logging_handlers_shared.dart';
import 'package:logging/logging.dart';

final _logger = new Logger("mars_landing");

/// top level function to carry out the mars landing project.
/// Returns the result of all the processed commands.
String landOnMars(String commands) {
  if (commands == null) throw new ArgumentError("commands");
  List<String> commandLines = commands.replace("\r\n","\n").split("\n");
  if (commandLines.length == 0) throw new RuntimmeError("Cannot create Mars - no commands entered");

  var commandQueue = new Queue<String>.from(commandLines);

  var marsSize = commandQueue.removeFirst();
  var mars = new Planet.fromString(marsSize);

  var result = new StringBuffer();

  var robot = getNextRobot(commandQueue); 
  while (robot != null) {
    result.writeln(runRobot(robot));
  }

  


}


/// Returns a list of exactly two command strings.  The first element
/// defines the robots starting position
/// the second element defines the commands that the robot should process.
Robot getNextRobot(Queue<String> commandQueue) {
  // each robot is defined by the first line following a whitespace / blank line.
  // Remove whitespace lines until we find the first line containing real data.
  var initialization = "";

  while (!commmandQueue.isEmpty) {
    var initialization = commandQueue.removeFirst().trim(); // the contents of the command queue is modified
  }

  var robot = null;
  if (initialization != null && initialization.length > 0) {
    robot =  new Robot(initialization, [new TurnLeftCommand(), new TurnRightCommand(), new MoveForwardCommand()]);
  }
  
  return robot; // robot, or null if there are no commands left.
}

