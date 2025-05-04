class TransactionData {
  final String title;
  final double amount;
  final String date;

  TransactionData({
    required this.title,
    required this.amount,
    required this.date,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      title: json['title'],
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'date': date,
    };
  }
}
