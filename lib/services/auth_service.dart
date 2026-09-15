import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  // Même serveur que ApiService — gardez les deux baseUrl synchronisées
  // si l'adresse Codespaces change.
  static const String baseUrl = 'https://glorious-space-fiesta-gxv7v4xrw54h9j4p-3000.app.github.dev';

  static const String boxName = 'authBox';

  /// Inscription. Retourne true si succès.
  static Future<void> register({
    required String nom,
    required String prenom,
    required String email,
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auths/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'username': username,
        'password': password,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erreur lors de l'inscription");
    }
  }

  /// Connexion. Stocke le token en local si succès.
  static Future<void> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auths/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Identifiants incorrects');
    }

    final data = jsonDecode(response.body);
    final box = await Hive.openBox(boxName);
    await box.put('access_token', data['access_token']);
    await box.put('refresh_token', data['refresh_token']);
    await box.put('username', username);
  }

  /// Récupère le token stocké, ou null si non connecté.
  static Future<String?> getToken() async {
    final box = await Hive.openBox(boxName);
    return box.get('access_token');
  }

  /// Vérifie si l'utilisateur est déjà connecté (token présent).
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  /// Déconnexion : efface le token stocké.
  static Future<void> logout() async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }

  /// Récupère le profil de l'utilisateur connecté.
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/auths/profils'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Impossible de récupérer le profil');
  }

  /// Met à jour le profil de l'utilisateur connecté.
  static Future<void> updateProfile(Map<String, dynamic> updates) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/auths/profils'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updates),
    );
    if (response.statusCode != 200) {
      throw Exception('Impossible de mettre à jour le profil');
    }
  }
}