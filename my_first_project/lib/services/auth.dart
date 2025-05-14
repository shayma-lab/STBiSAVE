import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_first_project/models/http_exceptions.dart';
import 'package:my_first_project/models/user.dart';
import 'package:my_first_project/pages/admin/admin.dart';
import 'package:my_first_project/pages/auth/connexion.dart';
import 'package:my_first_project/pages/client/tab_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final url = dotenv.env['API_URL'];

  Future<void> submitForm(
      String name,
      String prenom,
      String email,
      String password,
      String phone,
      String civilite,
      String gouvernorat,
      DateTime date) async {
    return await handleErrors(() async {
      final response = await http.post(
        Uri.parse("$url/auth/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "prenom": prenom,
          "email": email,
          "password": password,
          "phone": phone,
          "civilite": civilite,
          "gouvernorat": gouvernorat,
          "dateNaissance": date.toIso8601String().split('T')[0],
        }),
      );

      final body = json.decode(response.body);
      if (response.statusCode != 201) {
        throw CustomHttpException("Une erreur est survenue");
      }
    });
  }

  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    return await handleErrors(() async {
      final response = await http.post(
        Uri.parse("$url/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", responseData['token']);
        Map<String, dynamic> decodedToken =
            JwtDecoder.decode(responseData['token']);
        print(decodedToken);

        final userData = UserData.fromJson(decodedToken['user']);
        final jsonString = jsonEncode(userData.toJson());
        await prefs.setString('user', jsonString);
        if (userData.role == UserRole.admin) {
          Navigator.pushReplacementNamed(context, AdminPage.routeName);
        } else {
          Navigator.pushReplacementNamed(context, TabScreen.routeName);
        }
      } else {
        throw CustomHttpException("Une erreur est survenue");
      }
    });
  }

  Future<bool> autoLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return false;

    final token = prefs.getString('token')!;
    final decodedToken = JwtDecoder.decode(token);
    int expiration = decodedToken['exp'];

    bool isTokenExpired = DateTime.now().isAfter(
      DateTime.fromMillisecondsSinceEpoch(expiration * 1000),
    );

    if (isTokenExpired) {
      await logout(context);
      return false;
    } else {
      return true;
    }
  }

  Future<void> logout(BuildContext context) async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("token");
      Navigator.pushNamedAndRemoveUntil(
          context, LoginPage.routeName, (Route<dynamic> route) => false);
    });
  }

  Future<UserData> userData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user')!;
    final decodedUser = json.decode(user);
    return UserData.fromJson(decodedUser);
  }

  Future<void> updateUser(String name, String prenom, String phone,
      String civilite, String gouvernorat, DateTime date, File? photo) async {
    return await handleErrors(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')!;
      final request = http.MultipartRequest('PUT', Uri.parse('$url/auth/update'));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name'] = name;
      request.fields['prenom'] = prenom;
      request.fields['phone'] = phone;
      request.fields['civilite'] = civilite;
      request.fields['gouvernorat'] = gouvernorat;
      request.fields['dateNaissance'] = date.toIso8601String().split('T')[0];
      if (photo != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', photo.path));
      }
      final response = await request.send();
      final body = await response.stream.bytesToString();
      final responseData = json.decode(body);
      if (response.statusCode == 200) {
        final userData = UserData.fromJson(responseData);
        final jsonString = jsonEncode(userData.toJson());
        await prefs.setString('user', jsonString);
      } else {
        throw Exception(
            'Une erreur est survenue lors de la récupération des données.');
      }
    });
  }
}
