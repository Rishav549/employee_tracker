import 'package:flutter/material.dart';
import 'package:trackme/components/heading.dart';
import 'package:trackme/config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _buttonPosition = 0;
  bool _isButtonAtEnd = false;

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width - 65;
    double buttonDiameter = 40;
    double triggerThreshold = containerWidth * 0.7;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Heading(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 500,
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Card corner radius
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        // Match card corner radius
                        topRight: Radius.circular(16),
                      ),
                      child: SizedBox(
                        height: 400,
                        child: Image.asset(
                          AppImages.user,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Arjun Patel",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 24),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Sales & Marketing",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "+91 90736 97862",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "example@gmail.com",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color:
                          _isButtonAtEnd ? Colors.red : const Color(0xFF2A7D6B),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: double.infinity,
                    height: 60,
                    alignment: Alignment.center,
                    child: _isButtonAtEnd
                        ? const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Slide To Log Out",
                                style: TextStyle(color: Colors.white),
                              ),
                              //timer field to be added Here
                            ],
                          )
                        : const Text(
                            "Slide To Log In",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                  // Draggable button
                  Positioned(
                    left: _buttonPosition,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _buttonPosition += details.delta.dx;
                          if (_buttonPosition < 0) _buttonPosition = 0;
                          if (_buttonPosition >
                              containerWidth - buttonDiameter) {
                            _buttonPosition = containerWidth - buttonDiameter;
                            _isButtonAtEnd =
                                _buttonPosition >= triggerThreshold;
                          } else {
                            _isButtonAtEnd = false;
                          }
                        });
                      },
                      onHorizontalDragEnd: (details) {
                        setState(() {
                          if (!_isButtonAtEnd) {
                            _buttonPosition = 0;
                          }
                        });
                      },
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: _isButtonAtEnd
                            ? const Icon(
                                Icons.chevron_left,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.chevron_right,
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
