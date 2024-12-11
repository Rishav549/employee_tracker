import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trackme/routes/detailsScreen.dart';
import 'package:trackme/routes/home.dart';
import 'package:trackme/routes/qrScanner.dart';
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
      child: const MaterialApp(
          title: 'Track Me',
          home: DetailsScreen(qr: "XC0012", macId: "98:76:45:09")),
    );
  }
}


