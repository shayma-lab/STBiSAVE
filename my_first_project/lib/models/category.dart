import 'package:flutter/material.dart';

class Category {
  final String id;
  final String userId;
  final String title;
  final Color color;
  final IconData icon;

  Category(
    this.id,
    this.userId,
    this.title,
    this.color,
    this.icon,
  );

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      json['_id'] ?? '',
      json['userId'] ?? '',
      json['title'] ?? 'Autre',
      parseColor(json['color']),
      parseIcon(json['icon']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'color': color,
      'icon': icon,
    };
  }

  static Color parseColor(String? colorStr) {
    switch (colorStr) {
      case 'Colors.orange':
        return Colors.orange;
      case 'Colors.blue':
        return Colors.blue;
      case 'Colors.purple':
        return Colors.purple;
      case 'Colors.green':
        return Colors.green;
      case 'Colors.red':
        return Colors.red;
      default:
        return Colors.teal;
    }
  }

  static IconData parseIcon(String? iconStr) {
    switch (iconStr) {
      case 'Icons.fastfood':
        return Icons.fastfood;
      case 'Icons.directions_bus':
        return Icons.directions_bus;
      case 'Icons.movie':
        return Icons.movie;
      case 'Icons.shopping_cart':
        return Icons.shopping_cart;
      case 'Icons.receipt':
        return Icons.receipt;
      default:
        return Icons.category;
    }
  }
}
