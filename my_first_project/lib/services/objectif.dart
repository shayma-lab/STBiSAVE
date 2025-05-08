import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exceptions.dart';
import '../models/objectif.dart';

class ObjectifService {
  final url = dotenv.env['API_URL'];

  Future<void> createObjectif(String name, num amount, DateTime date) async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;

      final response = await http.post(
        Uri.parse("$url/objectif/create"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name": name,
          "amount": amount,
          "date": date.toIso8601String().split('T')[0],
        }),
      );
      if (response.statusCode != 201) {
        throw CustomHttpException("Erreur lors de la création de l'objectif");
      }
    });
  }

  Future<List<Objectif>> getAllObjectifsByUser() async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;

      final response = await http.get(
        Uri.parse("$url/objectif/all/user"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Objectif.fromJson(json)).toList();
      } else {
        throw CustomHttpException("Impossible de récupérer les objectifs");
      }
    });
  }

  Future<void> updateObjectif(
      String id, String name, num amount, DateTime date) async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;

      final response = await http.put(
        Uri.parse("$url/objectif/update/$id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name": name,
          "amount": amount,
          "date": date.toIso8601String(),
        }),
      );

      if (response.statusCode != 200) {
        throw CustomHttpException(
            "Erreur lors de la mise à jour de l'objectif");
      }
    });
  }

  Future<void> deleteObjectif(String id) async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;

      final response = await http.delete(
        Uri.parse("$url/objectif/delete/$id"),
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

  Future<void> updateObjectifProgress(String id, num amount) async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;

      final response = await http.put(
        Uri.parse("$url/objectif/progress/$id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "amount": amount,
        }),
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode != 200) {
        throw CustomHttpException(
            "Erreur lors de la récupération de la progression de l'objectif");
      }
    });
  }

  Future<ObjectifDetailResponse> getObjectifDetail(String id) async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;

      final response = await http.get(
        Uri.parse("$url/objectif/$id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return ObjectifDetailResponse.fromJson(json.decode(response.body));
      } else {
        throw CustomHttpException(
            "Erreur lors de la récupération des détails de l'objectif");
      }
    });
  }
}
