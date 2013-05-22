library robot;

import 'dart:collection';

import 'direction.dart';
import 'planet.dart';

part 'src/robot/commands.dart';

class RobotError extends RuntimeError {
  RobotError(msg) : super(msg);
  toString() => "RobotError: $message";
}

class Robot {
  /// List of commands for quick lookup
  Map<String, Command> commandLibrary = new Map<String, Command>(); // <CommandChar, Command>
  /// What direction is the robot facing?
  Direction facing;
  /// What is the current position in the grid of the robot?
  Point position;

  bool _isActive = true;
  /// Is the robot still active (or has it "died" "been lost" etc...?
  /// Readonly getter
  bool get isActive => _isActive;

  /// The list of commands that the robot needs to process
  Queue<String> commandQueue = new Queue<String>();

  Robot(String initialization, String commandsToProcess, List<Command> availableCommands) {
    if (initialization == null || initialization.length == 0) throw new ArgumentError("initialization");
    // initialization should contain three distinct elements.  First two are the position, third is the facing.
    var elements = initialization.trim().split(" ");
    if (elements.length != 3) throw new ArgumentError("initialization should contain three distinct elements");

    // lookup the correct facing (if one exists for the char)
    // non-existance also acts as validation of the input char.
    // element 0 and 1 represent the X and Y starting position
    var positionString = "${elements[0]} ${elements[1]}";
    MajorCompassFacing.initialize();
    if (positionString == null) throw new ArgumentError("positionString must not be null");
    this.position = new Point.fromString(positionString);

    // element 2 is the facing
    this.facing = MajorCompassFacing.facings[elements[2]];
    if (this.facing == null) throw new ArgumentError("facingChar must be one of N E S W");

    /// insert the commands into the command map for quick lookup.
    if (availableCommands == null) throw new ArgumentError("availableCommands");
    availableCommands.forEach((command) => commandLibrary[command.commandChar] = command);

    /// insert the commands to run into a queue
    if (commandsToProcess == null) throw new ArgumentError("commandsToProcess");
    for (int i = 0; i < commandsToProcess.length; i++) {
      commandQueue.add(commandsToProcess[i]);
    }
  }


  /// Return true if the robot still has commands to process
  bool get hasCommands => !this.commandQueue.isEmpty;

  /// Returns true if the robot is still active, whether or not there
  /// are still commands to process.  Callers should check the [hasCommands]
  /// property.
  bool runNextCommand(planet) {
    var result = true;

    if (hasCommands) {
      var nextCommand = commandQueue.removeFirst();
      result = runCommand(nextCommand, planet);
    }

    return result;
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

    var command = commandLibrary[commandChar.toUpperCase()];
    if (command == null) throw new RobotError("I don't understand command: $commandChar");

    if (this.isActive) {
      /// run the command
      var result = command.execute(this);

      /// apply the result of the command
      _applyFacingChange(result);
      _applyPositionChange(result, planet);
    }

    return this.isActive;
  }

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
        if (planet.hasRobotScent(this.position)) {
          // but if there is a "robot scent" in the current position,
          // we can safely ignore the "movement" command and stay where
          // we are.  
          // Therefore NOOP          
        }
        else {
          // no scent, so we're LOST.
          planet.addScent(this.position); // leave our own scent in position we moved from
          this._isActive = false; // set ourself to be no-longer active
          this.position = result.position; // recourd our new "Lost" position
        }
      }
      else {
        // not out of bounds
        this.position = result.position; // recourd our new position
      }
    }
  }
}

