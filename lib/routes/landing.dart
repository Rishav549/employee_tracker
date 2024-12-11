import 'package:flutter/material.dart';
import 'package:trackme/routes/qrScanner.dart';

import '../utilities/localStorage.dart';
import 'home.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    _decideNavigation();
  }

  void _decideNavigation() async {
    String? storedData = await SecureLocalStorage.getValue("emp_picture");
    if (storedData != null && storedData.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const QrScanner()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
