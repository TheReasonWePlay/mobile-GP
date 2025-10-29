import 'package:flutter/material.dart';
import 'package:untitled/pages/dash_board.dart';
import 'package:untitled/pages/history.dart';
import 'package:untitled/pages/qr_scanner.dart';
import 'package:untitled/pages/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _currentIndex = 0;

  void setCurrentIndex(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
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
                    color: Colors.deepPurple,
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
                  label: "History",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "Settings",
                )
              ],
            ),
          );
        },
      ),

    );
  }
}





