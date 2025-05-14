import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_first_project/models/category.dart';
import 'package:my_first_project/models/http_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final url = dotenv.env['API_URL'];

  Future<void> createCategory(String title) async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;

      final response = await http.post(
        Uri.parse("$url/category/create"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "title": title,
        }),
      );
      if (response.statusCode != 201) {
        throw CustomHttpException("Erreur lors de la création de l'objectif");
      }
    });
  }

  Future<List<Category>> getAllCategoriesByUser() async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;

      final response = await http.get(
        Uri.parse("$url/category/all/user"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw CustomHttpException("Impossible de récupérer les objectifs");
      }
    });
  }

  Future<void> deleteCategory(String id) async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;

      final response = await http.delete(
        Uri.parse("$url/category/delete/$id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw CustomHttpException(
            "Erreur lors de la suppression de l'objectif");
      }
    });
  }

  Future<void> updateTransactionCategory(
      String transactionId, String categoryId) async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;

      final response = await http.put(
        Uri.parse("$url/transaction/$transactionId/category"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "categoryId": categoryId,
        }),
      );
      if (response.statusCode != 200) {
        throw CustomHttpException(
            "Erreur lors de la mise à jour de la catégorie");
      }
    });
  }
}
