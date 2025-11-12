import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/history_service.dart'; // ⚠️ chemin à adapter selon ton projet

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await HistoryService.getHistory();
    setState(() {
      _history = data;
    });
  }

  Future<void> _clearHistory() async {
    await HistoryService.clearHistory();
    setState(() {
      _history = [];
    });
  }

  String traduireAction(String message) {
    // Liste de remplacements courants
    final Map<String, String> traductions = {
      'Check in': 'arrivé(e) au bureau',
      'Check out': 'quitté le bureau',
      'Leaving': 'est sorti(e)',
      'Return': 'est rentré(e)',
      'at': 'à',
    };

    // Remplacer les mots anglais par leur équivalent français
    traductions.forEach((anglais, francais) {
      message = message.replaceAll(anglais, francais);
    });

    // Expression régulière pour détecter une heure du type HH:mm:ss
    final regexHeure = RegExp(r'\b(\d{2}):(\d{2}):\d{2}\b');

    // Transformer 09:33:23 → 09h33
    message = message.replaceAllMapped(regexHeure, (match) {
      final heure = match.group(1);
      final minute = match.group(2);
      return '${heure}h${minute}';
    });

    return message;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, d MMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // 🟦 Bande supérieure
          Container(
            height: 260,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(60)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueAccent, Colors.deepPurpleAccent],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 80, left: 25, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        today,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Activité récente",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Voici vos derniers pointages",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // 📜 Liste d’historique
          Padding(
            padding: const EdgeInsets.only(top: 210, left: 12, right: 12),
            child: _history.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.history, size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "Aucun historique pour le moment",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                final lowerItem = item.toLowerCase();
                final isCheckIn =
                    lowerItem.contains("check in") || lowerItem.contains("return");
                final timePart = item.split(" ").last; // extrait éventuellement l’heure si elle existe

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor:
                      isCheckIn ? Colors.blueAccent.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      child: Icon(
                        isCheckIn ? Icons.login_rounded : Icons.logout_rounded,
                        color: isCheckIn ? Colors.blueAccent : Colors.redAccent,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      traduireAction(item),
                      style: const TextStyle(
                        fontSize: 15.5,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      "Pointé à $timePart",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
