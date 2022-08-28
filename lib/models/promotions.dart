
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:egsfree/models/promotion.dart';


class Promotions {

  final List<Promotion> promotionalOffers;
  final List<Promotion> upcomingPromotionalOffers;

  Promotions({
    required this.promotionalOffers,
    required this.upcomingPromotionalOffers,
  });

  Promotions copyWith({
    List<Promotion>? promotionalOffers,
    List<Promotion>? upcomingPromotionalOffers,
  }) => Promotions(
    promotionalOffers: promotionalOffers ?? this.promotionalOffers,
    upcomingPromotionalOffers: upcomingPromotionalOffers ?? this.upcomingPromotionalOffers,
  );

  factory Promotions.fromMap(Map<String, dynamic> map) => Promotions(
    promotionalOffers: List<Promotion>.from(
      map["promotionalOffers"]?.isEmpty ?? true
        ? []
        // ignore: unnecessary_lambdas
        : map["promotionalOffers"]?.first?["promotionalOffers"]?.map((e) => Promotion.fromMap(e)),
    ),
    upcomingPromotionalOffers: List<Promotion>.from(
      map["upcomingPromotionalOffers"]?.isEmpty ?? true
        ? []
        // ignore: unnecessary_lambdas
        : map["upcomingPromotionalOffers"]?.first?["promotionalOffers"]?.map((e) => Promotion.fromMap(e)),
    ),
  );

  factory Promotions.fromJson(String source) => Promotions.fromMap(json.decode(source));

  @override
  String toString() =>
    "Promotions(promotionalOffers: $promotionalOffers, upcomingPromotionalOffers: $upcomingPromotionalOffers)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {return true;}
    final listEquals = const DeepCollectionEquality().equals;
    return other is Promotions &&
      listEquals(other.promotionalOffers, promotionalOffers) &&
      listEquals(other.upcomingPromotionalOffers, upcomingPromotionalOffers);
  }

  @override
  int get hashCode => promotionalOffers.hashCode ^ upcomingPromotionalOffers.hashCode;
}
