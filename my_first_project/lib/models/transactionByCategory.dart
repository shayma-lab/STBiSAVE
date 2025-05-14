import 'category.dart';
import 'transaction.dart';

class TransactionByCategory {
  final Category category;
  final num totalAmount;
  final int count;
  final List<Transaction> transactions;

  TransactionByCategory(
    this.category,
    this.totalAmount,
    this.count,
    this.transactions,
  );

  factory TransactionByCategory.fromJson(Map<String, dynamic> json) {
    return TransactionByCategory(
      Category.fromJson(json['category']),
      json['totalAmount'] ?? 0,
      json['count'] ?? 0,
      (json['transactions'] as List<dynamic>?)
              ?.map((tx) => Transaction.fromJson(tx))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category.toJson(),
      'totalAmount': totalAmount,
      'count': count,
      'transactions': transactions.map((tx) => tx.toJson()).toList(),
    };
  }
}
