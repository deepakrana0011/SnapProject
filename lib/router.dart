import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/view/home_screen.dart';
import 'package:snap_app/view/login_page.dart';
import 'package:snap_app/view/note_screen.dart';
import 'package:snap_app/view/otp_verify_page.dart';
import 'package:snap_app/view/photo_screen.dart';
import 'package:snap_app/view/signup_page.dart';

class OnGenerateRouter {

  static Route<dynamic> onGenerate(RouteSettings settings) {
    final arg = settings.arguments;
    switch (settings.name) {
      case RouteConstants.loginPage:
        return MaterialPageRoute(
            builder: (_) => LoginPage(), settings: settings);

      case RouteConstants.signUp:
        return MaterialPageRoute(
            builder: (_) => SignUpPage(), settings: settings);

      case RouteConstants.otpVerify:
        return MaterialPageRoute(
            builder: (_) => OtpVerifyPage(), settings: settings);

      case RouteConstants.home:
        return MaterialPageRoute(
            builder: (_) => HomeScreen(), settings: settings);

      case RouteConstants.noteScreen:
        return MaterialPageRoute(
            builder: (_) => NoteScreen(), settings: settings);

      case RouteConstants.photoScreen:
        return MaterialPageRoute(
            builder: (_) => PhotoScreen(image: settings.arguments as File,), settings: settings);

      default:
        return _onPageNotFound();
    }
  }

  static Route<dynamic> _onPageNotFound() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Page Not Found'),
        ),
      ),
    );
  }
}
