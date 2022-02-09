import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snap_app/constants/string_constants.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/helper/dialog_helper.dart';
import 'package:snap_app/helper/shared_pref.dart';
import 'package:snap_app/provider/base_provider.dart';
import 'package:snap_app/service/fetch_data_exception.dart';

class VoiceProvider extends BaseProvider{
  final token = SharedPref.prefs?.getString(SharedPref.token) ?? '';

  bool record = false;

  updateRecord(bool val){
    record = val;
    notifyListeners();
  }

  Future<bool> sendRecording(
      BuildContext context, String email, File recording) async {
    setState(ViewState.busy);
    try {
      var model =  await api.sendRecording(token, email, recording);

      if(model.success == true){
        DialogHelper.showMessage(context, "recording_send_successfully".tr());
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
    } on FileSystemException catch(err){
      setState(ViewState.idle);
      DialogHelper.showMessage(context, "no_recording_found".tr());
      return false;
    } catch(err){
      setState(ViewState.idle);
      DialogHelper.showMessage(context, "something_went_wrong".tr());
      return false;
    }
  }


  String _directoryPath = '/storage/emulated/0/SoundRecorder';

   createFile() async {
    File(_directoryPath + '/' + "recording.mp4")
        .create(recursive: true)
        .then((File file) async {
      //write to file
      Uint8List bytes = await file.readAsBytes();
      file.writeAsBytes(bytes);
      print(file.path);
    });
  }

   writeFileToStorage(File audioFile) async {
     audioFile = File(await getFilePath());
     Uint8List bytes = await audioFile.readAsBytesSync();
     final byteData = bytes.buffer.asUint8List(); //
     return byteData;
  }

   writeFileToStorage1(String fileName) async {
    File audioFile = File('$_directoryPath/$fileName');
    Uint8List bytes = await audioFile.readAsBytes();
    audioFile.writeAsBytes(bytes);
  }

  Future<String> getFilePath() async {
    final folderName = StringConstants.appName.toLowerCase();
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    final directory = Directory(_directoryPath);
    if ((await directory.exists())) {
    } else {
      directory.create();
    }
    String filePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

    return filePath;
  }

}