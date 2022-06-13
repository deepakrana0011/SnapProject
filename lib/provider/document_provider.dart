import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snap_app/constants/string_constants.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:snap_app/helper/dialog_helper.dart';
import 'package:snap_app/helper/shared_pref.dart';
import 'package:snap_app/provider/base_provider.dart';
import 'package:snap_app/service/fetch_data_exception.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DocumentProvider extends BaseProvider{
  FilePickerResult? result;
  // PlatformFile? file;
  // String? filePath;
  final email = SharedPref.prefs?.getString(SharedPref.userEmail) ?? '';
 // final token = SharedPref.prefs?.getString(SharedPref.token) ?? '';

  File? imageFile;
  File? pdfFile;
  final pdf = pw.Document();

  bool pickFile = false;

  updatePickFile(bool val){
    pickFile = val;
    notifyListeners();
  }


  // pickAFile(BuildContext context) async{
  //   try{
  //     result = await FilePicker.platform.pickFiles(type: FileType.any);
  //     if (result == null) return;
  //     file = result!.files.first;
  //     var fullPath = file!.path!.split("file_picker/");
  //     filePath = fullPath[1];
  //     notifyListeners();
  //   }
  //   on PlatformException catch (err) {
  //
  //     var status = await Permission.storage.request();
  //     if (status.isGranted) {
  //       return true;
  //     } else if (status.isDenied) {
  //       Permission.storage.request();
  //       return false;
  //     } else if (status.isPermanentlyDenied) {
  //       CommonWidgets.permissionErrorDialog(context, 'storage_permission'.tr(), 'storage_permission_not_granted'.tr());
  //       return false;
  //     }
  //   } catch (err) {
  //     DialogHelper.showMessage(context, "something_went_wrong".tr());
  //   }
  //
  // }

  Future getFileFromCamera(BuildContext context) async {
    final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 90, maxHeight: 720);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        pdfFile =  await createPdf();
      } else {
        print('No image selected.');
        return;
      }
      notifyListeners();
  }

  Future<bool> sendDocument(
      BuildContext context, String email, File documentFile) async {
    setState(ViewState.busy);
    try {
      var model =  await api.sendDocument(email, documentFile);

      if(model.success == true){
        Navigator.of(context).pop(true);
    //  DialogHelper.showMessage(context, "document_send_successfully".tr());
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


  createPdf() async{
    final image = pw.MemoryImage(
      imageFile!.readAsBytesSync(),
    );
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Image(image),
      ); // Center
    })); // Page
    final file = File(await getFilePath());
    return await file.writeAsBytes(await pdf.save());
  }

  Future<String> getFilePath() async {
    final folderName = StringConstants.appName.toLowerCase();
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    final directory = Directory("$appDocumentsPath/$folderName");
    if ((await directory.exists())) {
    } else {
      directory.create();
    }
    String filePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.pdf';

    return filePath;
  }
}