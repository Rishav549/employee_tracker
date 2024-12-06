import 'package:flutter/material.dart';

import '../config.dart';

class Heading extends StatefulWidget {
  final Color color;
  const Heading({super.key, required this.color});

  @override
  State<Heading> createState() => _HeadingState();
}

class _HeadingState extends State<Heading> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppImages.trackMe,
          width: 20,
          height: 18,
          color: widget.color,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          "Trackme",
          style: TextStyle(
              color: widget.color, fontSize: 24, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
