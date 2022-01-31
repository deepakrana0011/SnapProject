import 'package:get_it/get_it.dart';
import 'package:snap_app/provider/home_provider.dart';
import 'package:snap_app/provider/photo_screen_provider.dart';

GetIt locator = GetIt.instance;

void setupLocator(){

  locator.registerFactory<HomeProvider>(() => HomeProvider());
  locator.registerFactory<PhotoScreenProvider>(() => PhotoScreenProvider());
}