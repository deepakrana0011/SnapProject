import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/helper/dialog_helper.dart';
import 'package:snap_app/helper/shared_pref.dart';
import 'package:snap_app/provider/base_provider.dart';
import 'package:snap_app/service/fetch_data_exception.dart';

class HistoryProvider extends BaseProvider{
  final token = SharedPref.prefs?.getString(SharedPref.token) ?? '';

  Future<bool> history(BuildContext context) async{
    try{
      setState(ViewState.busy);

      var model = await api.history(token);
      print(model);
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
}