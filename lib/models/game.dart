
import 'dart:convert';

import 'package:egsfree/models/promotions.dart';


class Game {

  final String title;
  final String status;
  final bool isCodeRedemptionOnly;
  final String seller;
  final String productSlug;
  final int originalPrice;
  final String currencyCode;
  final Promotions? promotions;

  Game({
    required this.title,
    required this.status,
    required this.isCodeRedemptionOnly,
    required this.seller,
    required this.productSlug,
    required this.originalPrice,
    required this.currencyCode,
    this.promotions,
  });
  

  Game copyWith({
    String? title,
    String? status,
    bool? isCodeRedemptionOnly,
    String? seller,
    String? productSlug,
    int? originalPrice,
    String? currencyCode,
    Promotions? promotions,
  }) => Game(
    title: title ?? this.title,
    status: status ?? this.status,
    isCodeRedemptionOnly: isCodeRedemptionOnly ?? this.isCodeRedemptionOnly,
    seller: seller ?? this.seller,
    productSlug: productSlug ?? this.productSlug,
    originalPrice: originalPrice ?? this.originalPrice,
    currencyCode: currencyCode ?? this.currencyCode,
    promotions: promotions ?? this.promotions,
  );

  factory Game.fromMap(Map<String, dynamic> map) => Game(
    title: map["title"] ?? "",
    status: map["status"] ?? "",
    isCodeRedemptionOnly: map["isCodeRedemptionOnly"] ?? false,
    seller: map["seller"]?["name"] ?? "",
    productSlug: map["productSlug"] ?? "",
    originalPrice: map["price"]?["totalPrice"]?["originalPrice"] ?? "",
    currencyCode: map["price"]?["totalPrice"]?["currencyCode"] ?? "",
    promotions: map["promotions"] != null ? Promotions.fromMap(map["promotions"]) : null,
  );

  factory Game.fromJson(String source) => Game.fromMap(json.decode(source));

  @override
  String toString() =>
    "Game(title: $title, status: $status, isCodeRedemptionOnly: $isCodeRedemptionOnly, seller: $seller, productSlug: $productSlug, originalPrice: $originalPrice, currencyCode: $currencyCode, promotions: $promotions)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {return true;}
    return other is Game &&
      other.title == title &&
      other.status == status &&
      other.isCodeRedemptionOnly == isCodeRedemptionOnly &&
      other.seller == seller &&
      other.productSlug == productSlug &&
      other.originalPrice == originalPrice &&
      other.currencyCode == currencyCode &&
      other.promotions == promotions;
  }

  @override
  int get hashCode => title.hashCode ^
    status.hashCode ^
    isCodeRedemptionOnly.hashCode ^
    seller.hashCode ^
    productSlug.hashCode ^
    originalPrice.hashCode ^
    currencyCode.hashCode ^
    promotions.hashCode;
}
