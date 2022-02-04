import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:snap_app/helper/dialog_helper.dart';
import 'package:snap_app/provider/base_provider.dart';

class HomeProvider extends BaseProvider{
  File? image;

  Future<bool> permissionCheck() async {
    var status = await Permission.storage.status;
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      if (release!.contains(".")) {
        release = release.substring(0, 1);
      }
      if (int.parse(release) > 10) {
        status = await Permission.manageExternalStorage.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.storage.request();
    }
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      Permission.storage.request();
      return false;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  Future getImage(BuildContext context, int type) async {
    final picker = ImagePicker();
    // type : 1 for camera in and 2 for gallery
    Navigator.of(context).pop();
    if (type == 1) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 90, maxHeight: 720);
      if (pickedFile != null) {
        image = File(pickedFile.path);
        Navigator.pushNamed(context, RouteConstants.photoScreen, arguments: image).then((value) {
          if(value == true){
            DialogHelper.showMessage(context, "image_sent_successfully".tr());
          }
        });
      } else {
        print('No image selected.');
        return;
      }
      notifyListeners();
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90, maxHeight: 720);
      //  image = File(pickedFile!.path);
      if (pickedFile != null) {
        image = File(pickedFile.path);
        Navigator.pushNamed(context, RouteConstants.photoScreen, arguments: image).then((value) {
          if(value == true){
            DialogHelper.showMessage(context, "image_sent_successfully".tr());
          }
        });
      } else {
        print('No image selected.');
        return;
      }
      notifyListeners();
    }
  }

}