
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dolumns/dolumns.dart';
import 'package:egs_free_games/models/game.dart';
import 'package:http/http.dart' show get;


class GetCommand extends Command {

	@override
	final name = "get";
	@override
	final description = "Get the current EGS free games.";
  
	GetCommand() {
		argParser.addFlag("all", abbr: "a", help: "Display all other free games.");
	}

	@override
	Future<void> run() async {
		exitCode = 0;
		final showAll = argResults?["all"] ?? false;
		final uri = Uri.https(
			"store-site-backend-static.ak.epicgames.com",
			"freeGamesPromotions",
			{
				"locale": "en-US",
				"country": "US",
				"allowCountries": "US",
			}
		);
		final response = await get(uri);
		final games = _getGames(jsonDecode(response.body));
		if (games.isEmpty) {
			stdout.writeln("No free game found.");
			exit(0);
		}
		List<List<String>> discountedGames = [["", "Name", "Publisher", "Starts", "Ends"]];
		List<List<String>> otherGames = [["", "Name", "Publisher"]];
		for (final game in games) {
			if (game.promotions == null) {
				otherGames.add(["  -", game.title, game.seller]);
				continue;
			}
			final offer = game.promotions!.promotionalOffers.isEmpty
				? game.promotions!.upcomingPromotionalOffers.isEmpty
					? null
					: game.promotions!.upcomingPromotionalOffers.first
				: game.promotions!.promotionalOffers.first;
			discountedGames.add([
				"  -",
				game.title,
				game.seller,
				offer == null ? "Unknown" : _formatDate(offer.startDateTime),
				offer == null ? "Unknown" : _formatDate(offer.endDateTime),
			]);
		}
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
