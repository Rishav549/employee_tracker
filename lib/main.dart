import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trackme/routes/landing.dart';
import 'package:trackme/services/setup.dart';

void main() {
  setup('');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: MediaQuery.of(context).size,
      child: const MaterialApp(title: 'Track Me', home: LandingScreen()),
    );
  }
}
