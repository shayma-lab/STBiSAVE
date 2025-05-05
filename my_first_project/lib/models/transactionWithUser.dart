import 'package:my_first_project/models/user.dart';
import 'transaction.dart';

class TransactionWithUser {
  final UserData user;
  final num solde;
  final List<Transaction> transactions;

  TransactionWithUser(
    this.user,
    this.solde,
    this.transactions,
  );

  factory TransactionWithUser.fromJson(Map<String, dynamic> json) {
    final transactionsJson = json['transactions'] ?? [];
    return TransactionWithUser(
      json['user'] != null
          ? UserData.fromJson(json['user'])
          : UserData("", "", "", "", "", "", DateTime.now(), 0, []),
      (json['solde'] ?? 0).toDouble(),
      transactionsJson
          .map<Transaction>((e) => Transaction.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'solde': solde,
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }
}
