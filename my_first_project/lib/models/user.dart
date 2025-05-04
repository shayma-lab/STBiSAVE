import 'package:my_first_project/models/transaction.dart';

class UserData {
  final String name;
  final double solde;
  final List<TransactionData> transactions;

  UserData({
    required this.name,
    required this.solde,
    required this.transactions,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    final transactionsJson = json['transactions'];
    return UserData(
      name: json['name'],
      solde: (json['solde'] ?? 0).toDouble(),
      transactions: transactionsJson != null
          ? (transactionsJson as List)
              .map((e) => TransactionData.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'solde': solde,
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }
}
