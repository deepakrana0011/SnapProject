import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/helper/dialog_helper.dart';
import 'package:snap_app/helper/shared_pref.dart';
import 'package:snap_app/provider/base_provider.dart';
import 'package:snap_app/service/fetch_data_exception.dart';

class NoteProvider extends BaseProvider{
 // final email = SharedPref.prefs?.getString(SharedPref.userEmail) ?? '';
  final token = SharedPref.prefs?.getString(SharedPref.token) ?? '';

  Future<bool> sendNote(
      BuildContext context, String email,  String description) async {
    setState(ViewState.busy);
    try {
      var model =  await api.sendNote(email, description, token);
      if(model.success == true){
        DialogHelper.showMessage(context, "hey_snap".tr());
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