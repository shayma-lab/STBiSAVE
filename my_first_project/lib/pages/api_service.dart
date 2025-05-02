import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:5000/api/auth"; // À modifier en prod

  // Méthode pour s'inscrire
  static Future<Map<String, dynamic>?> registerUser(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body); // Succès
      } else {
        return {"error": jsonDecode(response.body)["msg"]}; // Erreur côté serveur
      }
    } catch (e) {
      return {"error": "Erreur de connexion au serveur"};
    }
  }

  // Méthode pour se connecter
  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
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
