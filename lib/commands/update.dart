
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:binary_updater/binary_updater.dart';
import 'package:egsfree/constants.dart';
import 'package:version/version.dart';


class UpdateCommand extends Command {

  @override
  final name = "update";
  @override
  final description = "Updates the cli.";
  
  UpdateCommand() {
    argParser
      ..addOption(
        "version",
        abbr: "v",
        help: "The version to update to.",
      )
      ..addFlag(
        "force",
        abbr: "f",
        help: "Force an update to the given/latest version even if it's the one currently installed.",
        defaultsTo: false,
      );
  }

  @override
  Future<void> run() async {
    exitCode = 0;
    final versionOption = argResults?["version"];
    final forceFlag = argResults?["force"] ?? false;
    final exec = runner!.executableName;
    final updater = BinaryUpdater(
      exec: exec,
      repo: "zkayia/$exec",
      execScheme: "{exec}_{platform}_{arch}{ext}",
    );
    stdout.writeln("Current: $currentVersion");
    final latest = await updater.getLatest();
    if (latest == null) {
      stderr.writeln("Failed to fetch latest version information");
      exit(1);
    }
    stdout.writeln("Latest: $latest");
    final target = versionOption == null ? latest : Version.parse(versionOption);
    stdout.writeln("Updating to: $target");
    final update = updater.update(
      currentVersion,
      target,
      force: forceFlag,
      allowDowngrade: true,
    );
    await for (final progress in update) {
      if (!progress.hasValue) {
        stdout.write("\r${progress.progress}/${progress.total} ${progress.percentage.floor()}%");
      } else {
        stdout.writeln();
        updater.dispose();
        switch (progress.value?.exitCode) {
          case 0:
            stdout.writeln("Successfully updated!");
            break;
          case 1:
            stdout.writeln(
              "You already have ${
                target == currentVersion && target == latest
                  ? "the latest version"
                  : "version $target"
              }.",
            );
            break;
          case 2:
            stdout.writeln("Failed to find the update binary.");
            break;
          case 3:
            stdout.writeln("Could not install update.\n${progress.value?.error}");
            break;
          case 4:
          default:
            stdout.writeln("Something went wrong.");
            break;
        }
      }
    }
  }
}
