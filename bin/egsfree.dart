
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:binary_updater/binary_updater.dart';
import 'package:egsfree/commands.dart';
import 'package:egsfree/constants.dart';


void main(List<String> arguments) async {
  final runner = CommandRunner("egsfree", "A cli to fetch EpicGamesStore free games.");
  commands.forEach(runner.addCommand);
  runner.argParser.addFlag("version", negatable: false, help: "Displays the current cli version.");
  final argResults = runner.argParser.parse(arguments);
  if (argResults["version"] ?? false) {
    final updater = BinaryUpdater(
      exec: runner.executableName,
      repo: "zkayia/${runner.executableName}",
      execScheme: "{exec}_{platform}_{arch}{ext}",
    );
    stdout.writeln("Current: $currentVersion");
    final latest = await updater.getLatest();
    if (latest == null) {
      stderr.writeln("Failed to fetch latest version information.");
      exit(1);
    }
    stdout.writeln("Latest: $latest");
    switch (currentVersion.compareTo(latest)) {
      case 0:
        stdout.writeln("You have the latest version.");
        break;
      case -1:
        stdout.writeln("Run egsfree update to get the latest version.");
        break;
      case 1:
        stdout.writeln("Somehow, you're living in the future!");
        break;
    }
    updater.dispose();
    exit(0);
  }
  runner.runCommand(argResults).catchError((err) {
    stderr.writeln(err);
    exit(err is UsageException ? 2 : 1);
  });
}
