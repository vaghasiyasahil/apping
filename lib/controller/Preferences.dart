import 'package:shared_preferences/shared_preferences.dart';

class Preferences{
  static late SharedPreferences prefs;

  static iniMemory() async {
    prefs = await SharedPreferences.getInstance();
  }

  static setLoginNumber(String number) async {
    await prefs.setString('number', number);
  }
  static String getLoginNumber() {
    return prefs.getString('number')??"";
  }

  static setLoginName(String name) async {
    await prefs.setString('name', name);
  }
  static String getLoginName() {
    return prefs.getString('name')??"";
  }

}