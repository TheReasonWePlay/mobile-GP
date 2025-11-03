import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _darkMode = false;
  bool _notifications = true;
  String? username;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // --- Récupération des données depuis SharedPreferences ---
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Utilisateur';
      email = prefs.getString('email') ?? 'inconnu@example.com';
    });
  }

  // --- Déconnexion ---
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _darkMode ? Colors.white : Colors.black87;
    final bgColor = _darkMode ? Colors.grey[900]! : Colors.grey[100]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              // --- Profil ---
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.blueAccent.withOpacity(0.2),
                      child: Text(
                        (username != null && username!.isNotEmpty)
                            ? username![0].toUpperCase()
                            : 'A',
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      username ?? 'Chargement...',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- Section Paramètres généraux ---
              _buildSection(
                title: "Paramètres généraux",
                textColor: textColor,
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                      title: const Text("Mode sombre"),
                      secondary:
                      const Icon(Icons.dark_mode, color: Colors.blueAccent),
                      value: _darkMode,
                      activeColor: Colors.blueAccent,
                      onChanged: (value) {
                        setState(() => _darkMode = value);
                      },
                    ),
                    const Divider(height: 0),
                    SwitchListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                      title: const Text("Notifications"),
                      secondary: const Icon(Icons.notifications_active,
                          color: Colors.blueAccent),
                      value: _notifications,
                      activeColor: Colors.blueAccent,
                      onChanged: (value) {
                        setState(() => _notifications = value);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- Section Compte ---
              _buildSection(
                title: "Compte",
                textColor: textColor,
                child: Column(
                  children: [
                    ListTile(
                      leading:
                      const Icon(Icons.person, color: Colors.blueAccent),
                      title: const Text("Profil"),
                      subtitle: const Text("Modifier vos informations"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading:
                      const Icon(Icons.lock, color: Colors.blueAccent),
                      title: const Text("Changer le mot de passe"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- Bouton Déconnexion ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "Se déconnecter",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget pour éviter de répéter le code de section ---
  Widget _buildSection({
    required String title,
    required Widget child,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: _darkMode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
