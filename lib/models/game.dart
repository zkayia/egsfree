
import 'dart:convert';

import 'package:egs_free_games/models/promotions.dart';


class Game {

	final String title;
	final String status;
	final bool isCodeRedemptionOnly;
	final String seller;
	final String productSlug;
	final Promotions? promotions;

	Game({
		required this.title,
		required this.status,
		required this.isCodeRedemptionOnly,
		required this.seller,
		required this.productSlug,
		this.promotions,
	});
	

	Game copyWith({
		String? title,
		String? status,
		bool? isCodeRedemptionOnly,
		String? seller,
		String? productSlug,
		Promotions? promotions,
	}) => Game(
		title: title ?? this.title,
		status: status ?? this.status,
		isCodeRedemptionOnly: isCodeRedemptionOnly ?? this.isCodeRedemptionOnly,
		seller: seller ?? this.seller,
		productSlug: productSlug ?? this.productSlug,
		promotions: promotions ?? this.promotions,
	);

	factory Game.fromMap(Map<String, dynamic> map) => Game(
		title: map["title"] ?? "",
		status: map["status"] ?? "",
		isCodeRedemptionOnly: map["isCodeRedemptionOnly"] ?? false,
		seller: map["seller"]?["name"] ?? "",
		productSlug: map["productSlug"] ?? "",
		promotions: map["promotions"] != null ? Promotions.fromMap(map["promotions"]) : null,
	);

	factory Game.fromJson(String source) => Game.fromMap(json.decode(source));

	@override
	String toString() =>
		"Game(title: $title, status: $status, isCodeRedemptionOnly: $isCodeRedemptionOnly, seller: $seller, productSlug: $productSlug, promotions: $promotions)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) {return true;}
		return other is Game &&
			other.title == title &&
			other.status == status &&
			other.isCodeRedemptionOnly == isCodeRedemptionOnly &&
			other.seller == seller &&
			other.productSlug == productSlug &&
			other.promotions == promotions;
	}

	@override
	int get hashCode => title.hashCode ^
		status.hashCode ^
		isCodeRedemptionOnly.hashCode ^
		seller.hashCode ^
		productSlug.hashCode ^
		promotions.hashCode;
}
