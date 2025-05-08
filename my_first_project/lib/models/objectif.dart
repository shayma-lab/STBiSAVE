class Objectif {
  final String id;
  final String name;
  final num amount;
  final DateTime date;
  final num progression;
  final DateTime createdAt;
  final DateTime updatedAt;

  Objectif({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.progression,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Objectif.fromJson(Map<String, dynamic> json) {
    return Objectif(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      progression: (json['progression'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'progression': progression,
    };
  }
}
