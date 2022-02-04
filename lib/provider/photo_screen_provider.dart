import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/helper/dialog_helper.dart';
import 'package:snap_app/helper/shared_pref.dart';
import 'package:snap_app/provider/base_provider.dart';
import 'package:snap_app/service/fetch_data_exception.dart';
import 'dart:io';

class PhotoScreenProvider extends BaseProvider{
  final token = SharedPref.prefs?.getString(SharedPref.token) ?? '';

   Color pickerColor = const Color(0xff443a49);
   Color currentColor = const Color(0xff443a49);

  void changeColor(Color color) {
     pickerColor = color;
     notifyListeners();
  }

  bool color = false;

  updateColor(bool val){
    color = val;
    notifyListeners();
  }

  bool text = false;

  updateText(bool val){
    text = val;
    notifyListeners();
  }

   Future<bool> sendPhoto(
       BuildContext context, String email, File imageFile) async {
     setState(ViewState.busy);
     try {
       var model =  await api.sendPhoto(token, email, imageFile);

       if(model.success == true){
         Navigator.of(context).pop(true);
         DialogHelper.showMessage(context, model.message);
       } else{
         DialogHelper.showMessage(context, "something_went_wrong".tr());
     }
       setState(ViewState.idle);
       return true;
     } on FetchDataException catch (c) {
       setState(ViewState.idle);
       DialogHelper.showMessage(context, c.toString());
       return false;
     } on SocketException catch (c) {
       setState(ViewState.idle);
       DialogHelper.showMessage(context, 'internet_connection'.tr());
       return false;
     }
   }
}