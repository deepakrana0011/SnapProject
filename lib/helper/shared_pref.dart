import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const isUserLogin = "userLogin";
  static const userEmail = "email";
  static const token = "token";

  static SharedPreferences? prefs;

  static clearSharePref() async {
    prefs!.setBool(isUserLogin, false);
    prefs!.remove(userEmail);
    prefs!.remove(token);
  }
}