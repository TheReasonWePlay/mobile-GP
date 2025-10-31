import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import '../services/history_service.dart';

class PointageTypeScreen extends StatefulWidget {
  final String qrCodeData;

  const PointageTypeScreen({super.key, required this.qrCodeData});

  @override
  State<PointageTypeScreen> createState() => _PointageTypeScreenState();
}

class Sortie {
  final String descr;
  final String hSortie;
  final String hRentree;
  final String idLeave;

  Sortie({
    required this.descr,
    required this.hSortie,
    required this.hRentree,
    required this.idLeave,
  });

  factory Sortie.fromJson(Map<String, dynamic> json) {
    return Sortie(
      descr: json['descr'] ?? "",
      hSortie: json['hSortie'] ?? "",
      hRentree: json['hRentree'] ?? "",
      idLeave: json['idLeave'] ?? "",
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots({Key? key}) : super(key: key);

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();
    _animation = StepTween(begin: 1, end: 3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        String dots = "." * _animation.value;
        return Text(
          "Chargement$dots",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        );
      },
    );
  }
}

class _PointageTypeScreenState extends State<PointageTypeScreen> {
  final TextEditingController descriptionController = TextEditingController();

  String c_in_AM = "00:00";
  String c_out_AM = "00:00";
  String c_in_PM = "00:00";
  String c_out_PM = "00:00";
  String nomComplet = "";
  List<Sortie> sorties = [];

  bool isLoading = true; // Pour le chargement initial
  bool isLoading1 = false; // Pour le bouton de pointage

  @override
  void initState() {
    super.initState();
    fetchInfo(); // Chargement initial
  }

  Future<void> fetchInfo() async {
    try {
      final url = Uri.parse(
          "http://192.168.88.18:5000/api/mobile/info?matricule=${widget.qrCodeData}");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          nomComplet = data['nom'] ?? "Aucun nom trouvé";
          c_in_AM = data['c_in_AM'] ?? "00:00";
          c_out_AM = data['c_out_AM'] ?? "00:00";
          c_in_PM = data['c_in_PM'] ?? "00:00";
          c_out_PM = data['c_out_PM'] ?? "00:00";
          sorties = (data['sorties'] as List)
              .map((e) => Sortie.fromJson(e))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception("Erreur serveur ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur fetchInfo : $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur de connexion au serveur")),
      );
    }
  }

  Future<void> onPointagePressed(
      String type, String description, String idLeave) async {
    if (isLoading1) return; // Empêche les clics multiples
    setState(() => isLoading1 = true);

    try {
      final url = Uri.parse("http://192.168.88.18:5000/api/mobile/pointage");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "type": type,
          "matricule": widget.qrCodeData,
          "description": description,
          "idSortie": idLeave,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await HistoryService.addToHistory("$nomComplet ${data['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Pointage $type enregistré !"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );

        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MyApp()),
        );
      } else {
        throw Exception("Erreur ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur pointage: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur lors du pointage."),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading1 = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context);

    double h(double v) => v * height / 800;
    double w(double v) => v * width / 400;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Widget topWid = Container(
      height: h(280),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(w(80))),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blueAccent, Colors.deepPurpleAccent],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: h(30), left: w(30), right: w(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h(25)),
              Row(
                children: const [
                  Icon(Icons.calendar_month_outlined,
                      color: Colors.white, size: 25),
                  SizedBox(width: 8),
                  Text(
                    "Thursday, October 23",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: h(25)),
              Text(
                nomComplet,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Matricule: ${widget.qrCodeData}",
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );

    Widget timeRow(String label, String time, IconData icon,
        {Color? color, Function()? onPressed}) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color ?? Colors.blueAccent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: isLoading1 ? null : onPressed,
              icon: isLoading1
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
                  : Icon(icon, size: 20, color: Colors.white),
              label: isLoading1
                  ? const Text(" En cours...",
                  style: TextStyle(color: Colors.white))
                  : const Text("Pointer",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: color ?? Colors.blueAccent,
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      );
    }

    Widget sectionLeaving({
      required Widget Function(String, String, IconData,
          {Color? color, Function()? onPressed})
      timeRow,
      required String desc,
      required String h_sortie,
      required String h_rentree,
      required String idLeave,
    }) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(desc, style: theme.textTheme.titleMedium),
          ),
          timeRow(
            desc,
            "$h_sortie - $h_rentree",
            Icons.logout_rounded,
            color: Colors.redAccent,
            onPressed: () => onPointagePressed("Return", "", idLeave),
          ),
        ],
      );
    }

    Widget sectionContainer({
      required String title,
      required List<Widget> children,
    }) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
            (title == "Attendance") ? Colors.blueAccent : Colors.redAccent,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: children),
            ),
          ],
        ),
      );
    }

    Widget newRow() {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.redAccent),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "Entrez une description...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: isLoading1
                  ? null
                  : () {
                final desc = descriptionController.text.trim();
                if (desc.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                        Text("Veuillez entrer une description.")),
                  );
                } else {
                  if ((c_in_AM == "00:00" && c_in_PM == "00:00") ||
                      (c_out_AM != "00:00" && c_in_PM == "00:00")) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Un agent qui n'a pas de pointage ne peut pas sortir."),
                      ),
                    );
                  } else {
                    if (sorties.isNotEmpty) {
                      final derniereSortie = sorties.last;
                      if (derniereSortie.hRentree != "00:00") {
                        onPointagePressed("Leaving", desc, "");
                        descriptionController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Un agent qui n'est pas rentré ne peut pas sortir."),
                          ),
                        );
                      }
                    } else {
                      onPointagePressed("Leaving", desc, "");
                      descriptionController.clear();
                    }
                  }
                }
              },
              icon: isLoading1
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
                  : const Icon(Icons.logout_rounded,
                  size: 20, color: Colors.white),
              label: isLoading1
                  ? const Text(" En cours...",
                  style: TextStyle(color: Colors.white))
                  : const Text("Pointer",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding:
                const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              topWid,

              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: h(200)),
                    sectionContainer(
                      title: "Attendance",
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Morning",
                                style: theme.textTheme.titleMedium)),
                        timeRow("Morning", "$c_in_AM - $c_out_AM",
                            Icons.login_rounded, onPressed: () {
                              onPointagePressed("Morning", "", "");
                            }),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Afternoon",
                                style: theme.textTheme.titleMedium)),
                        timeRow("Afternoon", "$c_in_PM - $c_out_PM",
                            Icons.login_rounded, onPressed: () {
                              if (c_in_AM != "00:00" && c_out_AM == "00:00") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "L'agent n'a pas fini son pointage du matin."),
                                  ),
                                );
                              } else {
                                onPointagePressed("Afternoon", "", "");
                              }
                            }),
                      ],
                    ),
                    sectionContainer(
                      title: "Leaving",
                      children: [
                        ...sorties.map((sortie) {
                          return sectionLeaving(
                            timeRow: timeRow,
                            desc: sortie.descr,
                            h_sortie: sortie.hSortie,
                            h_rentree: sortie.hRentree,
                            idLeave: sortie.idLeave,
                          );
                        }).toList(),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("New",
                                style: theme.textTheme.titleMedium)),
                        newRow(),
                      ],
                    ),
                    SizedBox(height: h(40)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
