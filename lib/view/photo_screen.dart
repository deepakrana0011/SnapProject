import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/decoration.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/image_constants.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/constants/string_constants.dart';
import 'package:snap_app/constants/validations.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:snap_app/helper/dialog_helper.dart';
import 'package:snap_app/locator.dart';
import 'package:snap_app/provider/photo_screen_provider.dart';
import 'package:snap_app/view/base_view.dart';
import 'package:snap_app/widgets/image_view.dart';
import 'dart:ui' as ui;

class PhotoScreen extends StatelessWidget {
  PhotoScreen({Key? key, required this.image}) : super(key: key);
  File image;
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  static GlobalKey screenshotKey = GlobalKey();
  FocusNode imageTextFocusNode = FocusNode();
  final imageTextController = TextEditingController();
  double x1 = 0.0,
      x2 = 0.0,
      y1 = 100.0,
      y2 = 200.0,
      x1Prev = 100.0,
      x2Prev = 200.0,
      y1Prev = 100.0,
      y2Prev = 100.0;
  final GlobalKey stackKey = GlobalKey();
  Offset offset = Offset(100.0, 100.0);

  PhotoScreenProvider provider = locator<PhotoScreenProvider>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(375, 812),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return GestureDetector(
      onTap: () {
        CommonWidgets.hideKeyboard(context);
      },
      child: Scaffold(
          backgroundColor: ColorConstants.backgroundColor,
          appBar: CommonWidgets.appBar(context, "photo".tr(),
              suffix: true,
              suffixImgPath: ImageConstants.textIcon, suffixTap: () {
            imageTextFocusNode.requestFocus();
          }, colorPicker: colorPicker(context)),
          body: BaseView<PhotoScreenProvider>(
            onModelReady: (provider){
              this.provider = provider;
              emailController.text = provider.email;
            },
            builder: (context, provider, _) {
              return Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  // alignment: Alignment.bottomCenter,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: DimensionConstants.d36.h),
                  //   padding: EdgeInsets.only(top: DimensionConstants.d73.h),
                  decoration: BoxDecoration(
                    color: ColorConstants.colorWhite,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(DimensionConstants.d44.r),
                      topLeft: Radius.circular(DimensionConstants.d44.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      //  mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RepaintBoundary(
                          key: screenshotKey,
                          child: Stack(
                            key: stackKey,
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        DimensionConstants.d44.r),
                                    topRight: Radius.circular(
                                        DimensionConstants.d44.r)),
                                child: SizedBox(
                                  width: DimensionConstants.d375.w,
                                  height: DimensionConstants.d440.h,
                                  child: ImageView(
                                    file: image,
                                    fit: BoxFit.cover,
                                    width: DimensionConstants.d375.w,
                                    height: DimensionConstants.d440.h,
                                  ),
                                ),
                              ),
                              Positioned(
                                  left: offset.dx,
                                  top: offset.dy,
                                  child: GestureDetector(
                                      onPanUpdate: (details) {
                                        offset += details.delta;
                                        provider.updateText(true);
                                        if (offset.dx < -30 ||
                                            offset.dy < -55 ||
                                            offset.dx > 280 ||
                                            offset.dy > 350) {
                                          imageTextController.clear();
                                          offset = const Offset(100.0, 100.0);
                                          provider.updateText(true);
                                        }
                                       // print(offset);
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(top: 10.0),
                                        padding: EdgeInsets.symmetric(
                                            vertical: DimensionConstants.d25.h,
                                            horizontal:
                                                DimensionConstants.d25.w),
                                        width: DimensionConstants.d300.w,
                                        height: DimensionConstants.d200.h,
                                        child: Center(
                                          child: TextField(
                                            cursorColor: provider.currentColor,
                                            textInputAction:
                                                TextInputAction.done,
                                            maxLines: 5,
                                            focusNode: imageTextFocusNode,
                                            style: TextStyle(
                                                color: provider.currentColor,
                                                fontSize:
                                                    DimensionConstants.d25.sp,
                                                fontFamily: StringConstants.poppins,
                                                fontWeight: FontWeight.w500),
                                            controller: imageTextController,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              DimensionConstants.d20.w,
                              DimensionConstants.d27.h,
                              DimensionConstants.d20.w,
                              0.0),
                          child: Column(
                            children: [
                              emailTextField(),
                              SizedBox(height: DimensionConstants.d20.h),
                              provider.state == ViewState.busy
                                  ? const CircularProgressIndicator()
                                  : GestureDetector(
                                onTap: () async {
                                  CommonWidgets.hideKeyboard(context);
                                 if(_formKey.currentState!.validate()){
                                 var imageFile =  await _takeScreenShot(context);
                                   provider.sendPhoto(context, emailController.text, imageFile).then((value) {
                                   //  emailController.clear();
                                   });
                                 }
                                },
                                child: CommonWidgets.commonBtn(
                                    context,
                                    "next".tr(),
                                    DimensionConstants.d63.h,
                                    DimensionConstants.d330.w),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  Widget emailTextField() {
    return SizedBox(
    //  height: DimensionConstants.d63.h,
      child: TextFormField(
        readOnly: true,
        controller: emailController,
        style: ViewDecoration.textFieldStyle(
            DimensionConstants.d12, FontWeight.w400, ColorConstants.colorBlack),
        decoration: ViewDecoration.inputDecorationForEmailTextField(
            "email_address".tr(),
            EdgeInsets.fromLTRB(DimensionConstants.d23.w,
                DimensionConstants.d26.h, 0.0, DimensionConstants.d19.h)),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.trim().isEmpty) {
            return "email_required".tr();
          } else if (!Validations.emailValidation(
              value.trim())) {
            return "invalid_email".tr();
          } else {
            return null;
          }
        },
      ),
    );
  }

   _takeScreenShot(BuildContext context) async {
    try {
      RenderRepaintBoundary? boundary = screenshotKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      final image = await boundary!.toImage(pixelRatio: 2.0); // image quality
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
    //  saveFile(pngBytes);
      final file = File(await getFilePath());
     return await file.writeAsBytes(pngBytes);
    } catch (e) {
      DialogHelper.showMessage(context, "something_went_wrong_image_error".tr());
    }
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
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';

    return filePath;
  }

  void saveFile(Uint8List image) async {
    final file = File(await getFilePath());
    await file.writeAsBytes(image);
    final result = await ImageGallerySaver.saveImage(image,
        quality: 100,
        name:
            "${StringConstants.appName.toLowerCase()}/${DateTime.now().millisecondsSinceEpoch}.png");
    print(result);
  }

// Future<File> convertImageToFile(Uint8List image) async {
//   final folderName = StringConstants.appName.toLowerCase();
//   Directory appDocDir = await getApplicationDocumentsDirectory();
//   final directory = Directory("${appDocDir.path}/$folderName");
//   File file =  File('$directory/screenshot.png');
//   file.writeAsBytes(image);
//   await file.writeAsBytes(image);
//   this.image = file;
//   return file;
// }

Widget colorPicker(BuildContext context){
    return  GestureDetector(
      onTap: (){
        colorPickerAlert(context);
      },
        child: Icon(Icons.color_lens_outlined, color: ColorConstants.colorBlackDown));
}


colorPickerAlert(BuildContext context){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return  AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child:
            ColorPicker(
              pickerColor: provider.pickerColor,
              onColorChanged: provider.changeColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
               // imageTextController.clear();
                provider.currentColor = provider.pickerColor;
                provider.updateColor(true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
}
}
