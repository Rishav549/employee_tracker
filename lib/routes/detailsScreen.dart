import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trackme/bloc/add_details/add_details_bloc.dart';
import 'package:trackme/components/heading.dart';
import 'package:trackme/repo/sign_in.dart';
import 'package:trackme/routes/home.dart';
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
  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obText = true;
  PlatformFile? _image;

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _image = result.files.first;
        });
      } else {
        // User canceled the picker
        print('No files selected');
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    codeController.clear();
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
        body: BlocProvider<AddDetailsBloc>(
          create: (_) => AddDetailsBloc(),
          child: BlocConsumer<AddDetailsBloc, AddDetailsStates>(
            listener: (context, state) {
              if (state is AddDetailsErrorState) {
                Fluttertoast.showToast(
                    msg:
                        "Error Occurred In Uploading data , Re-Enter Details Correctly");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const QrScanner();
                }));
              } else if (state is AddDetailsLoadedState) {
                Fluttertoast.showToast(msg: "Details uploaded Successfully");
                context.read<AddDetailsBloc>().add(FetchEmployeeDetailsEvent());
              } else if (state is FetchDetailsLoadedState) {
                Fluttertoast.showToast(msg: "Details saved locally");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const HomePage();
                }));
              }
            },
            builder: (context, state) {
              if (state is AddDetailsLoadingState ||
                  state is FetchDetailsLoadedState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 170,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InputDecorator(
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        labelText: 'Employee Code',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: codeController,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        decoration: const InputDecoration(
                                            hintText: "001",
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight
                                                  .bold, // Bold text for hint
                                            ),
                                            suffixIcon:
                                                Icon(Icons.person_2_outlined),
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
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        labelText: 'Name',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: nameController,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        decoration: const InputDecoration(
                                            hintText: "Arjun Patel",
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight
                                                  .bold, // Bold text for hint
                                            ),
                                            suffixIcon:
                                                Icon(Icons.person_2_outlined),
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
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        labelText: 'Phone Number',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: phoneController,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        decoration: const InputDecoration(
                                            hintText: "+91 90736 97862",
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight
                                                  .bold, // Bold text for hint
                                            ),
                                            suffixIcon:
                                                Icon(Icons.call_outlined),
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
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        labelText: 'Email',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: emailController,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        decoration: const InputDecoration(
                                            hintText: "example@gmail.com",
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight
                                                  .bold, // Bold text for hint
                                            ),
                                            suffixIcon:
                                                Icon(Icons.email_outlined),
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
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        labelText: 'Designation',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: designationController,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        decoration: const InputDecoration(
                                            hintText: "Sales & Marketing",
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight
                                                  .bold, // Bold text for hint
                                            ),
                                            suffixIcon:
                                                Icon(Icons.work_outline),
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
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        labelText: 'Password',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: passwordController,
                                        obscureText: obText,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                            hintText: "********",
                                            hintStyle: const TextStyle(
                                              fontWeight: FontWeight
                                                  .bold, // Bold text for hint
                                            ),
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    obText = !obText;
                                                  });
                                                },
                                                icon: const Icon(Icons
                                                    .remove_red_eye_outlined)),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            )),
                                      )),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Upload Image:",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF2A7D6B)),
                                        onPressed: _pickImage,
                                        child: const Text(
                                          "Choose File",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 80,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          backgroundColor:
                                              const Color(0xFF2A7D6B)),
                                      onPressed: () async {
                                        try {
                                          context.read<AddDetailsBloc>().add(
                                              AddEmployeeDetailsEvent(
                                                  empCode: codeController.text,
                                                  scanCode: widget.qr,
                                                  macID: widget.macId,
                                                  empName: nameController.text,
                                                  empPhone:
                                                      phoneController.text,
                                                  empEmail:
                                                      emailController.text,
                                                  empDesignation:
                                                      designationController
                                                          .text,
                                                  taggedImei: "23750327509",
                                                  image: _image,
                                                  password:
                                                      passwordController.text));
                                        } catch (e) {
                                          CustomLogger.error(e);
                                        }
                                        // CustomLogger.debug(
                                        //     "${widget.qr}, ${widget.macId}, ${nameController.text}, ${phoneController.text}, ${emailController.text}, ${designationController.text},${passwordController.text}");
                                        // try {
                                        //   await createUser(
                                        //       qr: widget.qr,
                                        //       macId: widget.macId,
                                        //       code: codeController.text,
                                        //       name: nameController.text,
                                        //       phone: phoneController.text,
                                        //       email: emailController.text,
                                        //       designation: designationController.text,
                                        //       taggedIMEI: "489365803256320",
                                        //       password: passwordController.text,
                                        //       image: _image);
                                        // } catch (e) {
                                        //   CustomLogger.error(e);
                                        // }
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
                  ),
                ],
              );
            },
          ),
        ));
  }
}
