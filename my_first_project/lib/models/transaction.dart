class Transaction {
  final String id;
  final String title;
  final num amount;
  final String date;
  final String category;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      date: json['date'],
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'category': category,
    };
  }
}
