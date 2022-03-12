
import 'dart:convert';


class Promotion {

	final String startDate;
	final String endDate;

	Promotion({
		required this.startDate,
		required this.endDate,
	});

	DateTime get startDateTime => DateTime.parse(startDate);
	DateTime get endDateTime => DateTime.parse(endDate);

	Promotion copyWith({
		String? startDate,
		String? endDate,
	}) => Promotion(
		startDate: startDate ?? this.startDate,
		endDate: endDate ?? this.endDate,
	);

	factory Promotion.fromMap(Map<String, dynamic> map) => Promotion(
		startDate: map["startDate"] ?? "",
		endDate: map["endDate"] ?? "",
	);

	factory Promotion.fromJson(String source) => Promotion.fromMap(json.decode(source));

	@override
	String toString() => "Promotion(startDate: $startDate, endDate: $endDate)";

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) {return true;}
		return other is Promotion &&
			other.startDate == startDate &&
			other.endDate == endDate;
	}

	@override
	int get hashCode => startDate.hashCode ^ endDate.hashCode;
}
