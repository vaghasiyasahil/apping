import 'package:apping/controller/AuthService.dart';
import 'package:apping/view/Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:local_auth/local_auth.dart';

import '../controller/allData.dart';

class BiometricAuthPage extends StatefulWidget {
  const BiometricAuthPage({Key? key}) : super(key: key);

  @override
  State<BiometricAuthPage> createState() => _BiometricAuthPageState();
}

class _BiometricAuthPageState extends State<BiometricAuthPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth();
    getPermission();
  }

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.blueGrey],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.fingerprint,
                      size: 120,
                      color: Colors.cyanAccent,
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Touch the fingerprint sensor',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      onPressed: () {
                        auth();
                      },
                      child: const Text(
                        'Authenticate',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> auth() async {
    final LocalAuthentication authService = LocalAuthentication();

    try {
      bool isSupported = await authService.isDeviceSupported();
      bool canCheckBiometrics = await authService.canCheckBiometrics;

      if (!isSupported || !canCheckBiometrics) {
        Get.snackbar("Not Available", "Biometric authentication not available on this device",
          colorText: Colors.orangeAccent);
        Get.to(HomePage());
        return;
      }

      bool isAuthenticated = await authService.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (isAuthenticated) {
        Get.to(HomePage());
      } else {
        Get.snackbar("Fail", "Authentication failed", colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "$e", colorText: Colors.redAccent);
    }
  }

  void getPermission()async {
    await FlutterContacts.requestPermission();
  }
}