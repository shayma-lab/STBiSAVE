class Objectif {
  final String id;
  final String name;
  final num amount;
  final DateTime date;
  final num progression;
  final DateTime createdAt;

  Objectif(
    this.id,
    this.name,
    this.amount,
    this.date,
    this.progression,
    this.createdAt,
  );

  factory Objectif.fromJson(Map<String, dynamic> json) {
    return Objectif(
      json['_id'] ?? '',
      json['name'] ?? '',
      (json['amount'] ?? 0).toDouble(),
      json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      (json['progression'] ?? 0).toDouble(),
      json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'progression': progression,
    };
  }
}

class ObjectifDetailResponse {
  final Objectif objectif;
  final num remainingAmount;
  final num dailyAmount;
  final int remainingDays;

  ObjectifDetailResponse(
    this.objectif,
    this.remainingAmount,
    this.dailyAmount,
    this.remainingDays,
  );

  factory ObjectifDetailResponse.fromJson(Map<String, dynamic> json) {
    return ObjectifDetailResponse(
      Objectif.fromJson(json['objectif']),
      (json['remainingAmount'] ?? 0).toDouble(),
      (json['dailyAmount'] ?? 0).toDouble(),
      json['remainingDays'] ?? 0,
    );
  }
}
