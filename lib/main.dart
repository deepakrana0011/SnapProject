import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/helper/shared_pref.dart';
import 'package:snap_app/locator.dart';
import 'router.dart' as router;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SharedPref.prefs = await SharedPreferences.getInstance();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFFF4F7FF),
    statusBarColor: Color(0xFFF4F7FF),
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en'),
    ],
    path: 'langs',
    fallbackLocale: const Locale('en'),
    child: MyApp(),
  ));
  setupLocator();
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'snap'.tr(),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            primarySwatch: color,
          ),
          onGenerateRoute: router.OnGenerateRouter.onGenerate,
          initialRoute: RouteConstants.loginPage
              // SharedPref.prefs?.getBool(SharedPref.isUserLogin) == null || SharedPref.prefs?.getBool(SharedPref.isUserLogin) == false
              //     ? RouteConstants.loginPage
              //     : RouteConstants.home
      ),
    );
  }

  MaterialColor color = const MaterialColor(0xFF8E97FD, <int, Color>{
    50: Color(0xFF8E97FD),
    100: Color(0xFF8E97FD),
    200: Color(0xFF8E97FD),
    300: Color(0xFF8E97FD),
    400: Color(0xFF8E97FD),
    500: Color(0xFF8E97FD),
    600: Color(0xFF8E97FD),
    700: Color(0xFF8E97FD),
    800: Color(0xFF8E97FD),
    900: Color(0xFF8E97FD),
  });
}
