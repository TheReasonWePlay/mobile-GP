import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/pages/qr_scanner.dart';

import '../utils/api_service.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int present = 0;
  int late = 0;
  int agent = 0;
  int percent = 0;
  bool isLoading = true;

  /// 🔹 Appel API pour récupérer les données du backend Node.js
  Future<void> fetchDashboardData() async {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final String apiUrl = '$baseUrl/mobile/dashBoard';
    //print("📡 Tentative de connexion à l'API: $apiUrl");

    try {
      final response = await ApiService.fetchWithAuth(Uri.parse(apiUrl));

      //print("✅ Code de statut HTTP: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        //print("📦 Réponse brute: ${response.body}");
        //print("📊 Données parsées: $data");

        setState(() {
          present = data['present'] ?? 0;
          late = data['late'] ?? 0;
          agent = data['agent'] ?? 0;
          percent = data['percent'] ?? 0;
          isLoading = false;
        });

        //print("🎯 Mise à jour réussie -> present=$present, late=$late, agent=$agent, percent=$percent");
      } else {
        //print("❌ Erreur serveur (${response.statusCode}): ${response.reasonPhrase}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      //print("🚨 Erreur de connexion à l'API: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDashboardData(); // 🔥 Appel dès l'ouverture de l'écran
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    double h(double v) => v * height / 800;
    double w(double v) => v * width / 400;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    }

    Widget topWid = Container(
      height: h(300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(w(100))),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blueAccent, Colors.deepPurpleAccent],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: h(60), left: w(30), right: w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined, color: Colors.white),
                SizedBox(width: w(8)),
                Text(
                  "${DateTime.now().toLocal()}".split(' ')[0],
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: h(20)),
            const Text(
              "Welcome back",
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Here's today's attendance overview",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );

    Widget averageCard = Column(
      children: [
        // --- Taux de présence ---
        Container(
          margin: EdgeInsets.only(top: h(210), left: w(20), right: w(20)),
          height: h(180),
          padding: EdgeInsets.symmetric(horizontal: w(25)),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(w(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: h(60)),
                child: Column(
                  children: [
                    const Text(
                      "Attendance Rate",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text("$present of $agent checked in"),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(w(20)),
                width: w(95),
                height: h(80),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(w(10)),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "$percent%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: h(10)),

        // --- Présent / En retard ---
        Container(
          margin: EdgeInsets.symmetric(horizontal: w(20)),
          height: h(140),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(w(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMiniCard(
                width: w(175),
                title: "Present",
                value: present,
                color: Colors.blueAccent,
                icon: Icons.person_outline,
              ),
              _buildMiniCard(
                width: w(175),
                title: "Late",
                value: late,
                color: Colors.redAccent,
                icon: Icons.watch_later_outlined,
              ),
            ],
          ),
        ),

        // --- Quick Scan ---
        Material(
          color: Colors.transparent, // pour afficher le ripple sur le gradient
          child: InkWell(
            borderRadius: BorderRadius.circular(w(20)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QrScanner()),
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: h(48), left: w(20), right: w(20)),
              height: h(90),
              padding: EdgeInsets.symmetric(horizontal: w(30)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(w(20)),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurpleAccent.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: h(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Quick Scan",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Make Attendance",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: h(60),
                    width: h(60),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(h(30)),
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),

      ],
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              topWid,
              averageCard,
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 Widget réutilisable pour les petites cartes (Present / Late)
  Widget _buildMiniCard({
    required double width,
    required String title,
    required int value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "$value",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
