import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackme/bloc/auth/auth_bloc.dart';
import 'package:trackme/components/heading.dart';
import 'package:trackme/config.dart';
import 'package:trackme/utilities/localStorage.dart';
import 'package:trackme/utilities/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _buttonPosition = 0;
  bool _isButtonAtEnd = false;
  String? image, name, designation, phone, email, password;

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  void fetchImage() async {
    image = await SecureLocalStorage.getValue("emp_picture");
    name = await SecureLocalStorage.getValue("emp_name");
    phone = await SecureLocalStorage.getValue("emp_phone");
    designation = await SecureLocalStorage.getValue("emp_designation");
    email = await SecureLocalStorage.getValue("emp_email");
    password = await SecureLocalStorage.getValue("password");
    setState(() {});
  }

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
        body: BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(),
          child: BlocConsumer<AuthBloc, AuthStates>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 500,
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16), // Card corner radius
                        ),
                        child: Column(
                          children: [
                            image == null
                                ? const CircularProgressIndicator()
                                : ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      // Match card corner radius
                                      topRight: Radius.circular(16),
                                    ),
                                    child: SizedBox(
                                      height: 400,
                                      child: Image.network(
                                        '${UrlConfig.baseurl}/${image!.replaceAll('\\', '/')}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        name == null ? '' : name!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 24),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        designation == null ? '' : designation!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        phone == null ? '' : phone!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      Text(
                                        email == null ? '' : email!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
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
                              color: _isButtonAtEnd
                                  ? Colors.red
                                  : const Color(0xFF2A7D6B),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.center,
                            child: _isButtonAtEnd
                                ? const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    _buttonPosition =
                                        containerWidth - buttonDiameter;
                                    _isButtonAtEnd =
                                        _buttonPosition >= triggerThreshold;
                                    context.read<AuthBloc>().add(
                                        AuthenticateUser(
                                            email: email!,
                                            password: password!));
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
              );
            },
          ),
        ));
  }
}
