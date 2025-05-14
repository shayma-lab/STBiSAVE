import 'package:flutter/material.dart';
import 'package:my_first_project/models/category.dart';

class Transaction {
  final String id;
  final UserModel user;
  final String cardId;
  final String transactionNumber;
  final num amount;
  final String beneficiaryAccount;
  final DateTime date;
  final Category category;

  Transaction(
    this.id,
    this.user,
    this.cardId,
    this.transactionNumber,
    this.amount,
    this.beneficiaryAccount,
    this.date,
    this.category,
  );

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      json['_id'] ?? json['id'],
      json['user'] != null
          ? UserModel.fromJson(json['user'])
          : UserModel('', '', ''),
      json['cardId']?.toString() ?? '',
      json['transactionNumber'] ?? '',
      json['amount'] ?? 0,
      json['beneficiaryAccount'] ?? '',
      json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      json['category'] != null
          ? Category.fromJson(json['category'])
          : Category('', '', "Autre", Colors.teal, Icons.category),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) '_id': id,
      'user': user,
      'cardId': cardId,
      'transactionNumber': transactionNumber,
      'amount': amount,
      'beneficiaryAccount': beneficiaryAccount,
      'date': date.toIso8601String(),
      'category': category,
    };
  }
}

class UserModel {
  final String id;
  final String name;
  final String prenom;

  UserModel(
    this.id,
    this.name,
    this.prenom,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final transactionsJson = json['transactions'];
    return UserModel(
      json['id'] ?? '',
      json['name'] ?? '',
      json['prenom'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'prenom': prenom,
    };
  }
}
