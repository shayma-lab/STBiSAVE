import 'package:my_first_project/models/transaction.dart';

class UserData {
  final String name;
  final double solde;
  final List<TransactionData> transactions;

  UserData(
      {required this.name, required this.solde, required this.transactions});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      solde: (json['solde'] ?? 0).toDouble(),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => TransactionData.fromJson(e))
          .toList(),
    );
  }
}
