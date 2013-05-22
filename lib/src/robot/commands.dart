part of robot;

/// Wrapper to contain the result of the command, which may modify either
/// the position, direction, or both (or neither).
class CommandResult {
  Position position;
  Direction facing;
  CommandResult(pos, facing) {
    print(pos);
    this.position = new Position(pos.x,pos.y);
    this.facing = facing;
  }
}

/// Interface to define the command.  [execute] the command to
/// retrieve a command result, which may by applied to the robot.
abstract class Command {
  String commandChar;
  CommandResult execute(Robot robot);
}

/// Maintins the robots position, but turns the robot to the left
class TurnLeftCommand implements Command {
  final commandChar = "L";
  CommandResult execute(Robot robot) {
    if (robot == null) throw new ArgumentError("robot");
    return new CommandResult(robot.position, robot.facing.turnLeft());
  }
}

/// Maintins the robots position, but turns the robot to the right
class TurnRightCommand implements Command {
  final commandChar = "R";
  CommandResult execute(Robot robot) {
    if (robot == null) throw new ArgumentError("robot");
    return new CommandResult(robot.position, robot.facing.turnRight());
  }
}

/// Maintains the robots facing, but moves the robot by 1 grid square
class MoveForwardCommand implements Command {
  final commandChar = "F";
  CommandResult execute(Robot robot) {
    if (robot == null) throw new ArgumentError("robot");
    var result = robot.facing.move(robot.position);
    return new CommandResult(result, robot.facing);
  }
}