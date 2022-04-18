
import 'dart:convert';
import 'dart:io';

import 'package:egsfree/utils/get_uri.dart';


Future<String> getLatestVersion() async {
	final data = await Uri.https("api.github.com", "/repos/zkayia/egsfree/releases/latest").get(true);
	return data == null
		? "unknown"
		: jsonDecode(data)?["tag_name"] ?? "unknown";
}

/// Returns 1 if [version] is higher than [other], -1 is lower and 0 if equal.
int compareVersions(String version, String other) {
	
	int _getDiff(String a, String b) => int.parse(a) - int.parse(b);
	
	final reg = RegExp(r"(\d+)\.(\d+)\.(\d+)");
	if (!reg.hasMatch(version) || !reg.hasMatch(other)) {
		stderr.writeln("Error: failed to parse versions.");
		exit(1);
	}
	final versionMatches = reg.firstMatch(version)!;
	final otherMatches = reg.firstMatch(other)!;
	for (final segment in [
		for (var i = 1; i < 4; i++)
			_getDiff(versionMatches.group(i)!, otherMatches.group(i)!)
	]) {
		if (segment != 0) {
			return segment > 0 ? 1 : -1;
		}
	}
	return 0;
}
