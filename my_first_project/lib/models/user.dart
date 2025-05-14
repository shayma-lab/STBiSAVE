class UserData {
  final String id;
  final String name;
  final String prenom;
  final String email;
  final String phone;
  final String civilite;
  final String gouvernorat;
  final DateTime dateNaissance;
  final num soldeBancaire;
  final UserRole role;
  final String image;

  UserData(
    this.id,
    this.name,
    this.prenom,
    this.email,
    this.phone,
    this.civilite,
    this.gouvernorat,
    this.dateNaissance,
    this.soldeBancaire,
    this.role,
    this.image,
  );

  factory UserData.fromJson(Map<String, dynamic> json) {
    final transactionsJson = json['transactions'];
    return UserData(
      json['_id'] ?? '',
      json['name'] ?? '',
      json['prenom'] ?? '',
      json['email'] ?? '',
      json['phone'] ?? '',
      json['civilite'] ?? '',
      json['gouvernorat'] ?? '',
      json['dateNaissance'] != null
          ? DateTime.parse(json['dateNaissance'])
          : DateTime.now(),
      json['soldeBancaire'] ?? 0,
      parseUserRole(json['role']),
      json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'prenom': prenom,
      'email': email,
      'phone': phone,
      'civilite': civilite,
      'gouvernorat': gouvernorat,
      'dateNaissance': dateNaissance.toIso8601String(),
      'soldeBancaire': soldeBancaire,
      'role': role.name,
      'image': image,
    };
  }

  static UserRole parseUserRole(String userRole) {
    switch (userRole) {
      case 'admin':
        return UserRole.admin;
      case 'user':
        return UserRole.user;
      default:
        return UserRole.user;
    }
  }
}

enum UserRole { admin, user }
