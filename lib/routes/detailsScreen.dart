import 'package:flutter/material.dart';
import 'package:trackme/components/heading.dart';
import 'package:trackme/routes/qrScanner.dart';
import 'package:trackme/utilities/logger.dart';

class DetailsScreen extends StatefulWidget {
  final String qr;
  final String macId;

  const DetailsScreen({super.key, required this.qr, required this.macId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obText = true;

  @override
  void dispose() {
    super.dispose();
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    designationController.clear();
    passwordController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Heading(color: Colors.black),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: nameController,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                  hintText: "Arjun Patel",
                                  hintStyle: TextStyle(
                                    fontWeight:
                                        FontWeight.bold, // Bold text for hint
                                  ),
                                  suffixIcon: Icon(Icons.person_2_outlined),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  )),
                            )),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: phoneController,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                  hintText: "+91 90736 97862",
                                  hintStyle: TextStyle(
                                    fontWeight:
                                        FontWeight.bold, // Bold text for hint
                                  ),
                                  suffixIcon: Icon(Icons.call_outlined),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  )),
                            )),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: emailController,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                  hintText: "example@gmail.com",
                                  hintStyle: TextStyle(
                                    fontWeight:
                                        FontWeight.bold, // Bold text for hint
                                  ),
                                  suffixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  )),
                            )),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              labelText: 'Designation',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: designationController,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                  hintText: "Sales & Marketing",
                                  hintStyle: TextStyle(
                                    fontWeight:
                                        FontWeight.bold, // Bold text for hint
                                  ),
                                  suffixIcon: Icon(Icons.work_outline),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  )),
                            )),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: passwordController,
                              obscureText: obText,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                  hintText: "********",
                                  hintStyle: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold, // Bold text for hint
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obText = !obText;
                                        });
                                      },
                                      icon: const Icon(
                                          Icons.remove_red_eye_outlined)),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  )),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const QrScanner();
                        }));
                      },
                      child: const Text(
                        "Re-scan the QR",
                        style: TextStyle(
                            color: Color(0xFF2A7D6B),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A7D6B)),
                        onPressed: () {
                          CustomLogger.debug(
                              "${widget.qr}, ${widget.macId}, ${nameController.text}, ${phoneController.text}, ${emailController.text}, ${designationController.text},${passwordController.text}");
                        },
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
