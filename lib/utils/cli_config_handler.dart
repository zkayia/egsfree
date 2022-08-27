
import 'dart:convert';
import 'dart:io';

import 'package:egsfree/constants.dart';
import 'package:egsfree/models/cli_config.dart';


class CliConfigHandler {

  static Future<CliConfig> read() async {
    if (!configFile.existsSync()) {
      final defaultConfig = CliConfig.withDefaults();
      await _configCreate(defaultConfig);
      return defaultConfig;
    }
    return CliConfig.fromJson(await configFile.readAsString());
  }
  
  static Future<void> write(CliConfig config) async {
    try {
      if (!configFile.existsSync()) {
        return _configCreate(config);
      }
      await configFile.writeAsString(_prettyJsonEncode(config.toMap()), flush: true);
    } on Exception catch (err) {
      stderr.writeln("Error: Failed to write to config file at '$configPath'.");
      stderr.writeln("$err");
      exit(1);
    }
  }

  static File get configFile => File(configPath);
  
  static String get configPath => Platform.isWindows ? "$_home$configPathWindows" : "$_home$configPathUnix";

  static String get _home {
    final home = Platform.isWindows
      ? Platform.environment["USERPROFILE"]
      : Platform.environment["HOME"];
    if (home == null) {
      stderr.writeln("Error: Failed to find the user home folder.");
      exit(1);
    }
    return home;
  }

  static Future<void> _configCreate(CliConfig config) async {
    try {
      await configFile.create(recursive: true);
      await configFile.writeAsString(_prettyJsonEncode(config.toMap()), flush: true);
    } on Exception catch (err) {
      stderr.writeln("Error: Failed to write to or create the config file at '$configPath'.");
      stderr.writeln("$err");
      exit(1);
    }
  }
}

String _prettyJsonEncode(Object json) {
  final encoder = JsonEncoder.withIndent("\t");
  return encoder.convert(json);
}
