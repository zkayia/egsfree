
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dolumns/dolumns.dart';
import 'package:egs_free_games/models/game.dart';
import 'package:egs_free_games/models/promotion.dart';
import 'package:egs_free_games/utils/cli_config_handler.dart';
import 'package:http/http.dart' show get;


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
		final response = await get(uri);
		final games = _getGames(jsonDecode(response.body));
		if (games.isEmpty) {
			stdout.writeln("No free game found.");
			exit(0);
		}
		_displayGameList(games, argResults);
	}
}

List<Game> _getGames(data) {
	final List? games = data?["data"]?["Catalog"]?["searchStore"]?["elements"];
	if (games == null) {
		stderr.writeln("Error: failed to get egs free games.");
		exit(2);
	}
	return games.map((e) => Game.fromMap(e)).where((e) => e.status == "ACTIVE" && !e.isCodeRedemptionOnly).toList();
}

String _formatDate(DateTime date) =>
	"${_zpad(date.day)}/${_zpad(date.month)}/${_zpad(date.year)} ${_zpad(date.hour)}:${_zpad(date.minute)}";

String _zpad(int data) => data.toString().padLeft(2, "0");

Promotion? _extractOffer(Game game) => game.promotions == null
	? null
	: game.promotions!.promotionalOffers.isEmpty
		? game.promotions!.upcomingPromotionalOffers.isEmpty
			? null
			: game.promotions!.upcomingPromotionalOffers.first
		: game.promotions!.promotionalOffers.first;

void _displayGameList(List<Game> games, ArgResults? argResults) {
	List<List<String>> discountedGames = [["", "Name", "Publisher", "Starts", "Ends", "Original price"]];
	List<List<String>> otherGames = [["", "Name", "Publisher"]];
	for (final game in games) {
		if (game.promotions == null) {
			otherGames.add(["  -", game.title, game.seller]);
			continue;
		}
		final offer = _extractOffer(game);
		discountedGames.add([
			"  -",
			game.title,
			game.seller,
			offer == null ? "Unknown" : _formatDate(offer.startDateTime),
			offer == null ? "Unknown" : _formatDate(offer.endDateTime),
			"${(game.originalPrice / 100).toString()} ${game.currencyCode}",
		]);
	}
	final showAll = argResults?["all"] ?? false;
	if (discountedGames.length <= 1 && (otherGames.length <= 1 || !showAll)) {
		stdout.writeln("No free games.");
		exit(0);
	}
	if (discountedGames.length > 1) {
		stdout.writeln("\nDiscounted free games:\n");
		stdout.writeln(dolumnify(discountedGames));
	}
	if (otherGames.length > 1 && showAll) {
		stdout.writeln("\nOther free games:\n");
		stdout.writeln(dolumnify(otherGames));
	}
}
