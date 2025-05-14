import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_first_project/models/transaction.dart';
import 'package:my_first_project/models/transactionByCategory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exceptions.dart';

class TransactionService {
  final url = dotenv.env['API_URL'];

  Future<List<Transaction>> fetchTransactions() async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;
      final response = await http.get(
        Uri.parse('$url/transaction/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception(
            'Une erreur est survenue lors de la récupération des données.');
      }
    });
  }

  Future<List<TransactionByCategory>> getTransactionsByCategory() async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;

      final response = await http.get(
        Uri.parse("$url/transaction/by-category"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => TransactionByCategory.fromJson(json))
            .toList();
      } else {
        throw CustomHttpException("Impossible de récupérer les transactions");
      }
    });
  }

  Future<List<TransactionByCategory>> getTransactionsByCategoryAdmin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse("$url/transaction/by-category-admin"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        print('Raw response: $responseBody');

        final List<dynamic> data =
            json.decode(responseBody) as List<dynamic>? ?? [];

        return data.map((item) {
          try {
            return TransactionByCategory.fromJson(
                item as Map<String, dynamic>? ?? {});
          } catch (e) {
            print('Error parsing item: $e');
            print('Problematic item: $item');
            throw CustomHttpException("Failed to parse transaction data");
          }
        }).toList();
      } else {
        throw CustomHttpException(
            "Failed to fetch transactions: ${response.statusCode}");
      }
    } catch (e) {
      print('Error in getTransactionsByCategoryAdmin: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMonthlyTransactions() async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;

      final response = await http.get(
        Uri.parse("$url/transaction/monthly-summary"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw CustomHttpException("Impossible de récupérer les transactions");
      }
    });
  }
}
