import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String _key = 'user_history';

  /// Récupère la liste des historiques (max 8)
  static Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data;
  }

  /// Ajoute un nouvel élément à l’historique
  static Future<void> addToHistory(String item) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_key) ?? [];

    // Empêcher les doublons successifs
    if (history.isNotEmpty && history.first == item) return;

    history.insert(0, item); // Ajoute en tête
    if (history.length > 30) {
      history = history.sublist(0, 30); // Conserve uniquement les 8 premiers
    }

    await prefs.setStringList(_key, history);
  }

  /// Efface tout l’historique
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
