import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/pages/dash_board.dart';
import 'package:untitled/pages/history.dart';
import 'package:untitled/pages/qr_scanner.dart';
import 'package:untitled/pages/settings.dart';
import 'login.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Figer en portrait uniquement
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await initializeDateFormatting('fr_FR', null); // ⚠️ important
  Intl.defaultLocale = 'fr_FR';

  // Charger les variables depuis .env
  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  runApp(MyApp(initialPage: token == null ? const LoginPage() : const HomePage()));
}

class MyApp extends StatelessWidget {
  final Widget initialPage;
  const MyApp({super.key, this.initialPage = const HomePage()});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Scan Manager',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: initialPage,
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
/// Page principale avec navigation
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        DashBoard(),
        History(),
        Settings()
      ][_currentIndex],
      floatingActionButton: Container(
        margin: const EdgeInsets.all(12),
        height: 60,
        width: 60,
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QrScanner()),
            );
          },
          tooltip: 'Scan QR code',
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blueAccent,
                  Colors.deepPurpleAccent,
                ],
              ),
            ),
            child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 40),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setCurrentIndex(index),
        selectedItemColor: Colors.blueAccent,
        elevation: 15,
        iconSize: 32,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: "DashBoard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Historiques",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Paramètre",
          )
        ],
      ),
    );
  }
}
