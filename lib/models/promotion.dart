
import 'dart:convert';


class Promotion {

  final String startDate;
  final String endDate;
  final int percentage;

  Promotion({
    required this.startDate,
    required this.endDate,
    required this.percentage,
  });

  DateTime get startDateTime => DateTime.parse(startDate);
  DateTime get endDateTime => DateTime.parse(endDate);

  Promotion copyWith({
    String? startDate,
    String? endDate,
    int? percentage,
  }) => Promotion(
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    percentage: percentage ?? this.percentage,
  );

  factory Promotion.fromMap(Map<String, dynamic> map) => Promotion(
    startDate: map["startDate"] ?? "",
    endDate: map["endDate"] ?? "",
    percentage: map["discountSetting"]?["discountPercentage"] ?? -1,
  );

  factory Promotion.fromJson(String source) => Promotion.fromMap(json.decode(source));

  @override
  String toString() => "Promotion(startDate: $startDate, endDate: $endDate, percentage: $percentage)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {return true;}
    return other is Promotion &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.percentage == percentage;
  }

  @override
  int get hashCode => startDate.hashCode ^ endDate.hashCode ^ percentage.hashCode;
}
