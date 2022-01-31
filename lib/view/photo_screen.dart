import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:snap_app/provider/photo_screen_provider.dart';
import 'package:snap_app/view/base_view.dart';
import 'package:snap_app/widgets/image_view.dart';
import 'dart:ui' as ui;

class PhotoScreen extends StatelessWidget {
  PhotoScreen({Key? key, required this.image}) : super(key: key);
  File image;
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  static GlobalKey screenshotKey =  GlobalKey();
  FocusNode imageTextFocusNode = FocusNode();
  final imageTextController = TextEditingController();
  double x1 = 0.0, x2 = 0.0, y1 = 100.0,
      y2 = 200.0, x1Prev = 100.0, x2Prev = 200.0, y1Prev = 100.0,
      y2Prev = 100.0;
  final GlobalKey stackKey = GlobalKey();

  AppBar? appBar;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonWidgets.hideKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: ColorConstants.backgroundColor,
        appBar: CommonWidgets.appBar(context, "photo".tr(),
            suffix: true, suffixImgPath: ImageConstants.textIcon, suffixTap: (){
              imageTextFocusNode.requestFocus();
            }),
        body: BaseView<PhotoScreenProvider>(
          builder: (context, provider, _){
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
                                  topLeft: Radius.circular(DimensionConstants.d44.r),
                                  topRight: Radius.circular(DimensionConstants.d44.r)),
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
                                left: x1,
                                top: y1,
              //                   child: Draggable( // 6.
              //                   child: Container(
              //                           margin: const EdgeInsets.only(top: 10.0),
              //                           padding: EdgeInsets.symmetric(vertical: DimensionConstants.d25.h, horizontal: DimensionConstants.d25.w),
              //                           width: DimensionConstants.d300.w,
              //                           height: DimensionConstants.d200.h,
              //                           child: Center(
              //                             child: TextField(
              //                               textInputAction: TextInputAction.done,
              //                               maxLines: 5,
              //                               focusNode: imageTextFocusNode,
              //                               style: TextStyle(
              //                                   color: ColorConstants.colorRed, fontSize: DimensionConstants.d20.sp),
              //                               controller: imageTextController,
              //                               decoration: const InputDecoration(
              //                                 border: InputBorder.none,
              //                               ),
              //                             ),
              //                           ),),
              //   childWhenDragging: SizedBox(),
              //   onDragEnd: (dragDetails) { // 10.
              //
              //     x1 = dragDetails.offset.dx;
              //     // We need to remove offsets like app/status bar from Y
              //     y1 = dragDetails.offset.dy;
              //
              //   }, feedback:  SizedBox(),
              // ),
                              child:  GestureDetector(
                                    onPanDown:(d){
                                      x1Prev = x1;
                                      y1Prev = y1;
                                    },
                                    onPanUpdate: (details) {
                                      x1 = x1Prev + details.localPosition.dx;
                                      y1 = y1Prev + details.localPosition.dy;
                                      provider.setState(ViewState.busy);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10.0),
                                      padding: EdgeInsets.symmetric(vertical: DimensionConstants.d25.h, horizontal: DimensionConstants.d25.w),
                                      width: DimensionConstants.d300.w,
                                      height: DimensionConstants.d200.h,
                                      child: Center(
                                        child: TextField(
                                          textInputAction: TextInputAction.done,
                                          maxLines: 5,
                                          focusNode: imageTextFocusNode,
                                          style: TextStyle(
                                              color: ColorConstants.colorRed, fontSize: DimensionConstants.d20.sp),
                                          controller: imageTextController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ))
                            ),
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
                            GestureDetector(
                              onTap: () {
                                _takeScreenShot();
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
        )
      ),
    );
  }

  Widget emailTextField() {
    return SizedBox(
      height: DimensionConstants.d63.h,
      child: TextFormField(
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
          // if (value!.trim().isEmpty) {
          //   return "email_required".tr();
          // } else if (!Validations.emailValidation(
          //     value.trim())) {
          //   return "invalid_email".tr();
          // } else {
          //   return null;
          // }
        },
      ),
    );
  }

  void _takeScreenShot() async {
    try {
      RenderRepaintBoundary? boundary = screenshotKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      final image = await boundary!.toImage(pixelRatio: 2.0); // image quality
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      saveFile(pngBytes);
    } catch (e) {
      print(e);
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
    String filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';

    return filePath;
  }

  void saveFile(Uint8List image) async {
    final file = File(await getFilePath());
    await file.writeAsBytes(image);
    final result = await ImageGallerySaver.saveImage(image,
        quality: 100, name: "${StringConstants.appName.toLowerCase()}/${DateTime.now().millisecondsSinceEpoch}.png");
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

}
