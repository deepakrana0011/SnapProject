import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/helper/dialog_helper.dart';
import 'package:snap_app/helper/shared_pref.dart';
import 'package:snap_app/provider/base_provider.dart';
import 'package:snap_app/service/fetch_data_exception.dart';

class SignUpProvider extends BaseProvider{


  Future<bool> register(
      BuildContext context, String email) async {
    setState(ViewState.busy);
    try {
     var model =  await api.register(email);
     if(model.data.verifyStatus == 0){
       Navigator.pushNamed(context, RouteConstants.otpVerify, arguments: model.data.email);
     } else if(model.data.verifyStatus == 1){
       SharedPref.prefs?.setBool(SharedPref.isUserLogin, true);
       Navigator.of(context)
           .pushNamedAndRemoveUntil(
           RouteConstants.home,
               (Route<dynamic> route) =>
           false);
     } else{
       DialogHelper.showMessage(context, 'no_account_found'.tr());
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