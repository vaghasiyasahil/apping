import 'package:apping/controller/Preferences.dart';
import 'package:apping/view/Biometric_Auth_Page.dart';
import 'package:apping/view/Home_Page.dart';
import 'package:apping/view/Log_In_Page.dart';
import 'package:apping/view/Register_Page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.iniMemory();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  LocalAuthentication authService = LocalAuthentication();
  bool isSupported = await authService.isDeviceSupported();
  bool canCheckBiometrics = await authService.canCheckBiometrics;

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Preferences.getLoginNumber()==""?LogInPage():(!isSupported || !canCheckBiometrics)?HomePage():BiometricAuthPage(),
    )
  );
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//
//     return ChangeNotifierProvider<ThemeChanger>(
//         create: (_) => ThemeChanger(),
//         child: Builder(
//         builder: (BuildContext context) {
//           final themeChanger = Provider.of<ThemeChanger>(context);
//           return  MaterialApp(
//             title: 'Flutter Demo',
//             home:  HomeScreen(),
//             themeMode: themeChanger.themeMode,
//             theme: ThemeData(
//               brightness: Brightness.light,
//               primarySwatch: Colors.teal,
//               textTheme: const TextTheme(
//                   displaySmall: TextStyle(fontFamily: 'Bold', fontSize: 20.0,color: Colors.black ),
//                   headlineMedium: TextStyle(fontFamily: 'Bold', fontSize: 18.0,color: Color(0xff25292B) ),
//                   headlineSmall: TextStyle(fontFamily: Bold,fontSize: 16.0,color: Color(0xff25292B) ),
//                   titleLarge: TextStyle(fontFamily: Bold, fontSize: 14.0,color: Color(0xff25292B)),
//                   bodyLarge: TextStyle(fontFamily: Regular, fontSize: 12.0, color: Color(0xff25292B)),
//                   bodyMedium: TextStyle(fontFamily: Regular, fontSize: 10.0, color:Color(0xff25292B)),
//               ),
//                 iconTheme: IconThemeData(
//                 color: Colors.grey.shade600
//           ),
//             ),
//
//             darkTheme: ThemeData(
//               brightness: Brightness.dark,
//                 textTheme: const TextTheme(
//                     displaySmall: TextStyle(fontFamily: 'Bold', fontSize: 20.0,color: Colors.white ),
//                     headlineMedium: TextStyle(fontFamily: 'Bold', fontSize: 18.0,color: Colors.white ),
//                     headlineSmall: TextStyle(fontFamily: Bold,fontSize: 16.0, color: Colors.white),
//                     titleLarge: TextStyle(fontFamily: Bold, fontSize: 14.0,color: Colors.white),
//                     bodyLarge: TextStyle(fontFamily: Regular, fontSize: 12.0, color: Colors.white),
//                     bodyMedium: TextStyle(fontFamily: Regular, fontSize: 10.0,color: Colors.white),
//                 ),
//           iconTheme: IconThemeData(
//               color: Colors.grey
//           )
//             ),
//             debugShowCheckedModeBanner: false,
//           );
//
//         })
//     );
//   }
// }

