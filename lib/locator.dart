import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:snap_app/provider/document_provider.dart';
import 'package:snap_app/provider/history_provider.dart';
import 'package:snap_app/provider/home_provider.dart';
import 'package:snap_app/provider/login_provider.dart';
import 'package:snap_app/provider/note_provider.dart';
import 'package:snap_app/provider/otp_verify_provider.dart';
import 'package:snap_app/provider/photo_screen_provider.dart';
import 'package:snap_app/provider/signup_provider.dart';
import 'package:snap_app/provider/voice_provider.dart';
import 'package:snap_app/service/api.dart';
import 'package:snap_app/service/interceptor.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => Api());
  locator.registerFactory<HomeProvider>(() => HomeProvider());
  locator.registerFactory<PhotoScreenProvider>(() => PhotoScreenProvider());
  locator.registerFactory<SignUpProvider>(() => SignUpProvider());
  locator.registerFactory<LoginProvider>(() => LoginProvider());
  locator.registerFactory<OtpVerifyProvider>(() => OtpVerifyProvider());
  locator.registerFactory<NoteProvider>(() => NoteProvider());
  locator.registerFactory<VoiceProvider>(() => VoiceProvider());
  locator.registerFactory<DocumentProvider>(() => DocumentProvider());
  locator.registerFactory<HistoryProvider>(() => HistoryProvider());

  locator.registerLazySingleton<Dio>(() {
    Dio dio =  Dio();
    dio.interceptors.add(AppInterceptors(dio));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });
}