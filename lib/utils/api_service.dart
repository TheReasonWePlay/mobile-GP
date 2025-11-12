import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../services/auth_service.dart';

class ApiService {


  static Future<void> handleSessionExpired() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    // Redirection vers la page login en supprimant tout l'historique de navigation
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
          (Route<dynamic> route) => false,
    );
  }
  /// Requête HTTP avec gestion automatique du token
  static Future<http.Response> fetchWithAuth(
      Uri url, {
        String method = 'GET',
        Map<String, String>? headers,
        Object? body,
      }) async {
    final token = await AuthService.getAccessToken();
    final mergedHeaders = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      ...?headers,
    };

    // 1️⃣ Envoi initial
    http.Response response;
    if (method == 'POST') {
      response = await http.post(url, headers: mergedHeaders, body: body);
    } else {
      response = await http.get(url, headers: mergedHeaders);
    }

    // 2️⃣ Si token expiré → tentative de refresh
    if (response.statusCode == 401) {
      print('⚠️ Token expiré, tentative de rafraîchissement...');
      final newToken = await AuthService.refreshAccessToken();

      if (newToken == null) {
        await handleSessionExpired();
        throw Exception('Session expirée');
      }

      final retryHeaders = {
        'Authorization': 'Bearer $newToken',
        'Content-Type': 'application/json',
        ...?headers,
      };

      if (method == 'POST') {
        response = await http.post(url, headers: retryHeaders, body: body);
      } else {
        response = await http.get(url, headers: retryHeaders);
      }
    }

    return response;
  }
}
