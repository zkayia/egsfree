
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dolumns/dolumns.dart';
import 'package:egs_free_games/constants.dart';
import 'package:egs_free_games/models/cli_config.dart';
import 'package:egs_free_games/utils/cli_config_handler.dart';


class ConfigCommand extends Command {

	@override
	final name = "config";
	@override
	final description = "Display or edit the cli config.";
	
	ConfigCommand() {
		addSubcommand(_ConfigPathCommand());
		addSubcommand(_ConfigGetCommand());
		addSubcommand(_ConfigSetCommand());
	}
}

class _ConfigPathCommand extends Command {

	@override
	final name = "path";
	@override
	final description = "Display the config file path.";

	_ConfigPathCommand() {
		argParser.addFlag("all", abbr: "a", help: "Displays the path for every OS.");
	}

	@override
	Future<void> run() async {
		exitCode = 0;
		if (argResults?["all"] ?? false) {
			stdout.writeln(
				dolumnify([
					["Linux/MacOS", "~$configPathUnix"],
					["Windows", "%USERPROFILE%$configPathWindows"],
				]),
			);
			return;
		}
		stdout.writeln(CliConfigHandler.configPath);
	}
}

class _ConfigGetCommand extends Command {

	@override
	final name = "get";
	@override
	final description = "Display config values.";

	@override
	String get invocation => super.invocation.replaceAll("[arguments]", "[key key2 ...]");

	@override
	Future<void> run() async {
		exitCode = 0;
		final keys = argResults?.rest ?? [];
		final configMap = (await CliConfigHandler.read()).toMap();
		if (keys.isEmpty) {
			stdout.writeln(
				dolumnify(
					configMap.entries.map<List<Object>>((e) => [e.key, e.value]).toList(),	
				),
			);
			return;
		}
		stdout.writeln(
			dolumnify([
				for (String key in keys)
					[
						key,
						configMap.containsKey(key)
							? configMap[key]
							: "Error: Unknown key.",
					],
			]),
		);
	}
}

class _ConfigSetCommand extends Command {

	@override
	final name = "set";
	@override
	final description = "Edit config values.";

	_ConfigSetCommand() {
		final configMap = CliConfig.withDefaults().toMap();
		for (MapEntry<String, dynamic> entry in configMap.entries) {
			argParser.addOption(
				entry.key, 
				valueHelp: entry.value.toString(),
			);
		}
	}

	@override
	Future<void> run() async {
		exitCode = 0;
		final configKeys = CliConfig.withDefaults().toMap().keys;
		CliConfig config = await CliConfigHandler.read();
		for (String key in configKeys) {
			final value = argResults?[key];
			if (value != null) {
				config = config.copyWithKey(key: key, value: value);
				stdout.writeln("Set $key to $value.");
			}
		}
		await CliConfigHandler.write(config);
		stdout.writeln("New config successfully saved.");
	}
}