import 'package:my_first_project/models/transaction.dart';

class UserData {
  final String name;
  final String prenom;
  final String email;
  final String phone;
  final String civilite;
  final String gouvernorat;
  final DateTime dateNaissance;
  final num solde;
  final List<Transaction> transactions;

  UserData(
     this.name,
     this.prenom,
     this.email,
     this.phone,
     this.civilite,
     this.gouvernorat,
     this.dateNaissance,
     this.solde,
     this.transactions,
  );

  factory UserData.fromJson(Map<String, dynamic> json) {
    final transactionsJson = json['transactions'];
    return UserData(
       json['name'] ?? '',
       json['prenom'] ?? '',
       json['email'] ?? '',
       json['phone'] ?? '',
       json['civilite'] ?? '',
       json['gouvernorat'] ?? '',
       json['dateNaissance'] != null
          ? DateTime.parse(json['dateNaissance'])
          : DateTime.now(),
       (json['solde'] ?? json['soldeBancaire'] ?? 0).toDouble(),
       transactionsJson != null
          ? (transactionsJson as List)
              .map((e) => Transaction.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'prenom': prenom,
      'email': email,
      'phone': phone,
      'civilite': civilite,
      'gouvernorat': gouvernorat,
      'dateNaissance': dateNaissance.toIso8601String(),
      'solde': solde,
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }
}
