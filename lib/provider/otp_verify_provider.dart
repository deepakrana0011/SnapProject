import 'dart:async';
import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/helper/dialog_helper.dart';
import 'package:snap_app/helper/shared_pref.dart';
import 'package:snap_app/provider/base_provider.dart';
import 'package:snap_app/service/fetch_data_exception.dart';

class OtpVerifyProvider extends BaseProvider{
 bool otpCorrect = true;
 int secondsRemaining = 30;
 bool enableResend = false;
 Timer? timer;
 bool resendOTP = true;

 bool verify = false;

 updateVerify(bool val){
   verify = val;
   notifyListeners();
 }

  Future<bool> verifyOtp(
      BuildContext context, String email, String otp) async {
    setState(ViewState.busy);
    try {
      var model =  await api.verifyOtp(email, otp);
      if(model.success == true){
        otpCorrect = true;
        SharedPref.prefs?.setBool(SharedPref.isUserLogin, true);
        SharedPref.prefs?.setString(SharedPref.userEmail, email) ?? "";
        Navigator.of(context)
            .pushNamedAndRemoveUntil(
            RouteConstants.home,
                (Route<dynamic> route) =>
            false);
      } else{
        otpCorrect = false;
        DialogHelper.showMessage(context, model.message);
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

 bool resendOtp = false;

 updateResend(bool val){
   resendOtp = val;
   notifyListeners();
 }

 Future<bool> resendOtpApi(
     BuildContext context, String email) async {
   updateResend(true);
   try {
     var model =  await api.resendOtp(email);
     if(model.success == true){
       DialogHelper.showMessage(context, model.message);
     } else{
       DialogHelper.showMessage(context, model.message);
     }
     updateResend(false);
     return true;
   } on FetchDataException catch (c) {
     updateResend(false);
     DialogHelper.showMessage(context, c.toString());
     return false;
   } on SocketException catch (c) {
     updateResend(false);
     DialogHelper.showMessage(context, 'internet_connection'.tr());
     return false;
   }
 }

  timerFun(){
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
          enableResend = true;
          secondsRemaining--;
          notifyListeners();
      } else {
         resendOTP = false;
          enableResend = false;
          notifyListeners();
      }
    });
  }

 void resendCode() {
     secondsRemaining = 30;
     enableResend = true;
     notifyListeners();
 }

}