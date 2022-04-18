
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dolumns/dolumns.dart';
import 'package:egsfree/models/cli_config.dart';
import 'package:egsfree/models/game.dart';
import 'package:egsfree/models/promotion.dart';
import 'package:egsfree/utils/cli_config_handler.dart';
import 'package:egsfree/utils/get_uri.dart';


class GetCommand extends Command {

	@override
	final name = "get";
	@override
	final description = "Get the current EGS free games.";
  
	GetCommand() {
		argParser
			..addFlag("all", abbr: "a", help: "Display all other free games.")
			..addOption("locale", abbr: "l", valueHelp: "en-US", help: "The locale to use when fetching data.")
			..addOption("country", abbr: "c", valueHelp: "US", help: "The country to use when fetching data.");
	}

	@override
	Future<void> run() async {
		exitCode = 0;
		final config = await CliConfigHandler.read();
		final uri = Uri.https(
			"store-site-backend-static.ak.epicgames.com",
			"/freeGamesPromotions",
			{
				"locale": argResults?["locale"] ?? config.locale,
				"country": argResults?["country"] ?? config.country,
				"allowCountries": argResults?["country"] ?? config.country,
			}
		);
		final data = await uri.get();
		final games = _parseGames(jsonDecode(data!));
		if (games.isEmpty) {
			stdout.writeln("No free game found.");
			exit(0);
		}
		_displayGameList(games, argResults, config);
	}
}

List<Game> _parseGames(data) {
	final List? games = data?["data"]?["Catalog"]?["searchStore"]?["elements"];
	if (games == null) {
		stderr.writeln("Error: failed to parse EGS free games.");
		exit(1);
	}
	return games.map((e) => Game.fromMap(e)).where((e) => e.status == "ACTIVE" && !e.isCodeRedemptionOnly).toList();
}

String _formatTimeframe(DateTime start, DateTime end) {
	final now = DateTime.now();
	switch (now.compareTo(start)) {
		case -1:
			final weeks = (
				start.millisecondsSinceEpoch - now.millisecondsSinceEpoch
			) ~/ (
				1000 * 60 * 60 * 24 * 7
			);
			switch (weeks) {
				case 0:
					return "On thursday";
				case 1:
					return "Next week";
				default:
					return "In $weeks weeks";
			}
		case 1:
			return now.compareTo(end) == -1
				? "Currently active"
				: "Expired";
		case 0:
			return "Currently active";
		default:
			return "Unknown";
	}
}

Promotion? _extractOffer(Game game) => game.promotions == null
	? null
	: game.promotions!.promotionalOffers.isEmpty
		? game.promotions!.upcomingPromotionalOffers.isEmpty
			? null
			: game.promotions!.upcomingPromotionalOffers.first
		: game.promotions!.promotionalOffers.first;

void _displayGameList(List<Game> games, ArgResults? argResults, CliConfig config) {
	List<MapEntry<Promotion?, dynamic>> discountedGames = [];
	List<List<String>> otherGames = [];
	for (final game in games) {
		final offer = _extractOffer(game);
		if (offer == null) {
			otherGames.add([
				"  -",
				game.title,
				game.seller,
				"\u001B]8;;https://www.epicgames.com/store/${config.locale}/p/${game.productSlug}\u001B\\Link\u001B]8;;\u001B\\",
			]);
			continue;
		}
		discountedGames.add(
			MapEntry(
				offer,
				[
					"  -",
					game.title,
					game.seller,
					_formatTimeframe(offer.startDateTime, offer.endDateTime),
					"${game.originalPrice / 100} ${game.currencyCode}",
					"\u001B]8;;https://www.epicgames.com/store/${config.locale}/p/${game.productSlug}\u001B\\Link\u001B]8;;\u001B\\",
				],
			),
		);
	}
	final showAll = argResults?["all"] ?? false;
	if (discountedGames.isEmpty && (otherGames.isEmpty || !showAll)) {
		stdout.writeln("No free games found.");
		exit(0);
	}
	if (discountedGames.isNotEmpty) {
		discountedGames.sort(
			(a, b) {
				if (a.key == null || b.key == null) {
					return a.key == null
						? b.key == null
							? 0
							: 1
						: -1;
				}
				final start = a.key!.startDateTime.compareTo(b.key!.startDateTime);
				return start == 0
					? a.key!.endDateTime.compareTo(b.key!.endDateTime)
					: start;
			},
		);
		stdout.writeln("Discounted free games:");
		stdout.writeln(
			dolumnify([
				["", "Name", "Publisher", "Starts", "Original price", "Store link\n"],
				...discountedGames.map((e) => e.value),
			]),
		);
	}
	if (otherGames.isNotEmpty && showAll) {
		stdout.writeln("\nOther free games:");
		stdout.writeln(
			dolumnify([
				["", "Name", "Publisher", "Store link"],
				...otherGames,
			]),
		);
	}
}
