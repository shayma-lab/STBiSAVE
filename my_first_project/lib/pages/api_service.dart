import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final apiUrl = dotenv.env['API_URL'];

  // Méthode pour s'inscrire
  Future<Map<String, dynamic>?> registerUser(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body); // Succès
      } else {
        return {
          "error": jsonDecode(response.body)["msg"]
        }; // Erreur côté serveur
      }
    } catch (e) {
      return {"error": "Erreur de connexion au serveur"};
    }
  }

  // Méthode pour se connecter
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Retourne les données utilisateur
      } else {
        return {"error": jsonDecode(response.body)["error"]};
      }
    } catch (e) {
      return {"error": "Erreur de connexion au serveur"};
    }
  }
}
