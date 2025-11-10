import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String baseUrl = dotenv.env['BASE_URL'] ?? '';

  /// Récupère le token d'accès depuis SharedPreferences
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Rafraîchit le token d’accès en utilisant le refreshToken
  static Future<String?> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    print("refresh tkn");
    print(refreshToken);

    if (refreshToken == null) return null;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/refresh"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );
      print("before if");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'];
        print("newaccestoken : ");
        print(newAccessToken);
        // Sauvegarde du nouveau token
        await prefs.setString('auth_token', newAccessToken);
        return newAccessToken;
      } else {
        print("dans else");
        return null;
      }
    } catch (e) {
      print("Erreur lors du rafraîchissement du token : $e");
      return null;
    }
  }

  /// Supprime les tokens (utilisé lors de la déconnexion)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
  }
}
