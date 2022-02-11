import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snap_app/constants/image_constants.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/helper/dialog_helper.dart';
import 'package:snap_app/helper/shared_pref.dart';
import 'package:snap_app/models/history_response.dart';
import 'package:snap_app/provider/base_provider.dart';
import 'package:snap_app/service/fetch_data_exception.dart';

class HistoryProvider extends BaseProvider{
  //type : 1 == Note
  //type : 2 == Image
  //type : 3 == Document
  //type : 4 == Recording

  final token = SharedPref.prefs?.getString(SharedPref.token) ?? '';

  List<Data> historyData = [];

  Future<bool> history(BuildContext context) async{
    try{
      setState(ViewState.busy);

      var model = await api.history(token);
      historyData.addAll(model.data!);
      setState(ViewState.idle);
      return true;
    }  on FetchDataException catch (c) {
      setState(ViewState.idle);
      DialogHelper.showMessage(context, c.toString());
      return false;
    } on SocketException catch (c) {
      setState(ViewState.idle);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  historyCardIcon(int type){
    switch(type){
      case 1:
        return ImageConstants.emailIcon;
      case 2:
        return ImageConstants.imageIcon;
      case 3:
        return ImageConstants.imageIcon;
      case 4:
        return ImageConstants.microphoneIcon;

      default:
    return ImageConstants.emailIcon;
  }
  }

  historyCardName(int type){
    switch(type){
      case 1:
        return "email".tr();
      case 2:
        return "photo".tr();
      case 3:
        return "document".tr();
      case 4:
        return  "voice".tr();

      default:
        return  "email".tr();
    }
  }
}