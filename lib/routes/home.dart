import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trackme/bloc/auth/auth_bloc.dart';
import 'package:trackme/components/heading.dart';
import 'package:trackme/config.dart';
import 'package:trackme/model/attendance.dart';
import 'package:trackme/repo/attendance.dart';
import 'package:trackme/utilities/localStorage.dart';
import 'package:trackme/utilities/logger.dart';

import '../model/monitor.dart';
import '../repo/monitor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _buttonPosition = 0;
  bool _isButtonAtEnd = false;
  String? image, name, designation, phone, email, password, scanCode, macID;
  bool deviceFound = false;
  int? empId;
  String? attendanceDate,
      loginDateStamp,
      loginLat,
      loginLan,
      logoutLat,
      logoutLan;
  Timer? _timer;
  bool _isUploading = false;
  late StreamSubscription<Position> _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    checkLocationServices();
    foregroundServices();
    fetchImage();
    scanForDevices();
  }

  void foregroundServices() async {
    ForegroundService().start();
  }

  Future<void> checkLocationServices() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      Fluttertoast.showToast(msg: "Please turn on location services.");
      await Geolocator.openLocationSettings();
    } else {
      await requestLocationPermission();
    }
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    CustomLogger.debug(status);
    if (status.isDenied || status.isPermanentlyDenied) {
      if (await Permission.location.request().isGranted) {
        Fluttertoast.showToast(msg: "Location permission granted.");
      } else {
        Fluttertoast.showToast(
            msg: "Location permission is required to use this app.");
      }
    } else if (status.isGranted) {
      Fluttertoast.showToast(msg: "Location access is enabled.");
    }
  }

  void fetchImage() async {
    empId = int.parse(await SecureLocalStorage.getValue("emp_id"));
    scanCode = await SecureLocalStorage.getValue("scan_code");
    macID = await SecureLocalStorage.getValue("mac_id");
    image = await SecureLocalStorage.getValue("emp_picture");
    name = await SecureLocalStorage.getValue("emp_name");
    phone = await SecureLocalStorage.getValue("emp_phone");
    designation = await SecureLocalStorage.getValue("emp_designation");
    email = await SecureLocalStorage.getValue("emp_email");
    password = await SecureLocalStorage.getValue("password");
    setState(() {});
  }

  void scanForDevices() {
    Fluttertoast.showToast(msg: "Checking Bluetooth state...");
    FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on) {
        Fluttertoast.showToast(msg: "Scanning For Device");
        FlutterBluePlus.startScan();
        FlutterBluePlus.scanResults.listen((results) {
          setState(() {
            for (ScanResult r in results) {
              if (r.device.remoteId.toString() == macID) {
                Fluttertoast.showToast(msg: "Device Found");
                setState(() {
                  deviceFound = true;
                });
                FlutterBluePlus.stopScan();
                break;
              }
            }
          });
        });
      } else if (state == BluetoothAdapterState.off) {
        Fluttertoast.showToast(msg: "Turning Bluetooth on...");
        FlutterBluePlus.turnOn();
      }
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void updateLocation(bool login) async {
    Position position = await _determinePosition();
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,  // Set desired accuracy
          distanceFilter: 100, // Optional: filter updates based on distance change
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
            "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          )
      ),
    ).listen((Position position) {
      setState(() {
        if (login) {
          loginLat = position.latitude.toString();
          loginLan = position.longitude.toString();
        } else {
          logoutLat = position.latitude.toString();
          logoutLan = position.longitude.toString();
        }
      });
    });
  }

  void startPeriodicUpload(bool upload) {
    if (upload && !_isUploading) {
      setState(() {
        _isUploading = true;
      });
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
        updateLocation(true);
        final monitorData = Monitor(
          empId: empId!,
          timestamp: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          lat: loginLat!,
          lan: loginLan!,
          tagScanned: scanCode!,
        );
        CustomLogger.debug(monitorData);
        await uploadLog(monitorData);
      });
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  void stopUpload() {
    setState(() {
      _isUploading = false;
    });
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
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          name == null ? '' : name!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          designation == null
                                              ? ''
                                              : designation!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          height: 10,
                                        ),
                                        Text(
                                          email == null ? '' : email!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10),
                                        )
                                      ],
                                    ),
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
                    !deviceFound
                        ? SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                                onPressed: () {},
                                child: const Text(
                                  "Device Not Found",
                                  style: TextStyle(color: Colors.white),
                                )))
                        : SizedBox(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Slide To Log Out",
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                        if (_buttonPosition < 0) {
                                          _buttonPosition = 0;
                                        }
                                        if (_buttonPosition >
                                            containerWidth - buttonDiameter) {
                                          _buttonPosition =
                                              containerWidth - buttonDiameter;
                                          _isButtonAtEnd = _buttonPosition >=
                                              triggerThreshold;
                                          if (!_isUploading) {
                                            context.read<AuthBloc>().add(
                                                AuthenticateUser(
                                                    email: email!,
                                                    password: password!));
                                            attendanceDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(DateTime.now());
                                            loginDateStamp = DateFormat(
                                                    'yyyy-MM-dd HH:mm:ss')
                                                .format(DateTime.now());
                                            updateLocation(true);
                                            startPeriodicUpload(true);
                                          }
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
                                      updateLocation(false);
                                      AttendanceModel newData = AttendanceModel(
                                          empId: empId!.toString(),
                                          attnDate: attendanceDate!,
                                          loginDate: loginDateStamp!,
                                          loginLat: loginLat!,
                                          loginLan: loginLan!,
                                          tagSignedIn: scanCode!,
                                          logoutDate:
                                              DateFormat('yyyy-MM-dd HH:mm:ss')
                                                  .format(DateTime.now()),
                                          logoutLat: logoutLat!,
                                          logoutLan: logoutLan!,
                                          tagSignedOut: scanCode!);
                                      upload(newData);
                                      startPeriodicUpload(false);
                                      stopUpload();
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
