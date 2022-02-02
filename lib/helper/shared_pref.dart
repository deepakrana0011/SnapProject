import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const isUserLogin = "userLogin";

  static SharedPreferences? prefs;

  static clearSharePref() async {
    prefs!.setBool(isUserLogin, false);
  }
}