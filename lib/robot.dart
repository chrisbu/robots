library robot;

import 'direction.dart';
import 'planet.dart';

part 'src/robot/commands.dart';

class RobotError extends RuntimeError {
  RobotError(msg) : super(msg);
  toString() => "RobotError: $message";
}

class Robot {
  /// List of commands for quick lookup
  Map<String, Command> commands = new Map<String, Command>(); // <CommandChar, Command>
  /// What direction is the robot facing?
  Direction facing;
  /// What is the current position in the grid of the robot?
  Point position;

  Robot(String facingChar, String positonString, List<Command> commandList) {
    // lookup the correct facing (if one exists for the char)
    // non-existance also acts as validation of the input char.
    MajorCompassFacing.initialize();
    this.facing = MajorCompassFacing.facings[facingChar.toUpperCase()];
    if (this.facing == null) throw new ArgumentError("facingChar must be one of N E S W");
    if (positonString == null) throw new ArgumentError("positionString must not be null");
    this.position = new Point.fromString(positonString);

    /// insert the commands into the command map for quick lookup.
    if (commandList == null) throw new ArgumentError("commandList");
    commandList.forEach((command) => commands[command.commandChar] = command);
  }

  /**
   * Runs a command for the given [commandChar] on the given [planet].
   *
   * Returns [true] if the robot is still active after the command has
   * been applied.  If the robot is lost or no longer active, it returns
   * false.
   */
  bool runCommand(String commandChar, planet) {
    if (planet == null) throw new ArgumentError("planet");

    var command = commands[commandChar.toUpperCase()];
    if (command == null) throw new RobotError("I don't understand command: $commandChar");

    if (this._isActive) {
      /// run the command
      var result = command.execute(this);

      /// apply the result of the command
      _applyFacingChange(result);
      _applyPositionChange(result, planet);
    }

    return this._isActive;
  }

  // private fields

  /// Is the robot still active (or has it "died" "been lost" etc...?
  bool _isActive = true;

  // private methods

  /// Facing changes are non-destructive.  They simply change
  /// the direction the robot is facing.
  _applyFacingChange(CommandResult result) {
    // has the result changed the facing?
    if (result.facing != this.facing) {
      // if so, apply it.  no danger there.
      this.facing = result.facing;
    }
  }

  /// Position changes might cause the robot to drop off the planet.
  /// When this happens, a "scent" is left on the planet in the position
  /// that was moved from.   If we're about to drop off the planet, but
  /// there is already a "scent" in the position we are moving from, we can
  /// save ourselves and ignore the movement.
  _applyPositionChange(CommandResult result, planet) {
    // has the result changed the position?
    if (result.position != this.position) {
      // could the new position result in the robot being lost?
      if (planet.isOutOfBounds(result.position)) {
        // but if there is a "robot scent" in the current position,
        // we can safely ignore the "movement" command and stay where
        // we are.
        if (!planet.hasRobotScent(this.position)) {
          // no scent, so we're lost.
          planet.addScent(this.position); // leave our own scent in position we moved from
          this._isActive = false; // set ourself to be no-longer active
          this.position = result.position; // recourd our new "Lost" position
        }
      }
    }
  }
}

