
import 'package:args/command_runner.dart';
import 'package:egsfree/commands.dart';


void main(List<String> arguments) {
	final runner = CommandRunner("egsfree", "A cli to fetch EpicGamesStore free games.");
	for (final command in commands) {
		runner.addCommand(command);
	}
	runner.run(arguments);
}
