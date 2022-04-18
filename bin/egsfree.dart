
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:egsfree/commands.dart';
import 'package:egsfree/constants.dart';
import 'package:egsfree/utils/version.dart';


void main(List<String> arguments) async {
	final runner = CommandRunner("egsfree", "A cli to fetch EpicGamesStore free games.");
	for (final command in commands) {
		runner.addCommand(command);
	}
	runner.argParser.addFlag("version", negatable: false, help: "Displays the current cli version.");
	final argResults = runner.argParser.parse(arguments);
	if (argResults["version"] ?? false) {
		final latest = await getLatestVersion();
		stdout.writeln("Current: $currentVersion");
		stdout.writeln("Latest: $latest");
		switch (compareVersions(currentVersion, latest)) {
			case 0:
				stdout.writeln("You have the latest version.");
				break;
			case -1:
				stdout.writeln("Download the latest version at https://github.com/zkayia/egsfree/releases/latest.");
				break;
			case 1:
				stdout.writeln("Somehow, you're living in the future!");
				break;
		}
		exit(0);
	}
	runner.runCommand(argResults).catchError((err) {
		stderr.writeln(err);
		exit(err is UsageException ? 2 : 1);
	});
}
