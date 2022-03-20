
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

	CliConfig copyWithKey({
		required String key,
		required dynamic value,
	}) {
		final config = toMap();
		config[key] = value;
		return CliConfig.fromMap(config);
	}

	factory CliConfig.withDefaults() => CliConfig(
		locale: configDefaultLocale,
		country: configDefaultCountry,
	);

	factory CliConfig.fromMap(Map<String, dynamic> map) => CliConfig(
		locale: map["locale"] ?? configDefaultLocale,
		country: map["country"] ?? configDefaultCountry,
	);

	Map<String, dynamic> toMap() => {
		"locale": locale,
		"country": country,
	};

	factory CliConfig.fromJson(String source) => CliConfig.fromMap(json.decode(source));

	String toJson() => json.encode(toMap());
	
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
