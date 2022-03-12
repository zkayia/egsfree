
import 'package:args/command_runner.dart';
import 'package:egs_free_games/commands.dart';


void main(List<String> arguments) {
	final runner = CommandRunner("egsfree", "Epic Games Store free games cli.");
	for (final command in commands) {
		runner.addCommand(command);
	}
	runner.run(arguments);
}
