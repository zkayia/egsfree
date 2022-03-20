
import 'dart:convert';

import 'package:egs_free_games/constants.dart';


class CliConfig {

	final String locale;
	final String country;
	
	CliConfig({
		required this.locale,
		required this.country,
	});

	CliConfig copyWith({
		String? locale,
		String? country,
	}) => CliConfig(
		locale: locale ?? this.locale,
		country: country ?? this.country,
	);

	factory CliConfig.fromMap(Map<String, dynamic> map) => CliConfig(
		locale: map["locale"] ?? configDefaultLocale,
		country: map["country"] ?? configDefaultCountry,
	);

	factory CliConfig.fromJson(String source) => CliConfig.fromMap(json.decode(source));

	@override
	String toString() => "CliConfig(locale: $locale, country: $country)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) {
			return true;
		}
		return other is CliConfig &&
			other.locale == locale &&
			other.country == country;
	}

	@override
	int get hashCode => locale.hashCode ^ country.hashCode;
}
