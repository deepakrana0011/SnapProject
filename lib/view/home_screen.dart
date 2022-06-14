import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/image_constants.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/extensions/all_extensions.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:snap_app/helper/dialog_helper.dart';
import 'package:snap_app/helper/shared_pref.dart';
import 'package:snap_app/provider/home_provider.dart';
import 'package:snap_app/view/base_view.dart';
import 'package:snap_app/widgets/image_picker_dialog.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({Key? key}) : super(key: key);
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
        ScreenUtil.init(context, designSize: const Size(375, 812));
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorConstants.backgroundColor,
      // appBar: CommonWidgets.appBar(context, "home".tr(), suffix: true, suffixImgPath: ImageConstants.homeRefresh, prefix: true, suffixTap: (){
      //   Navigator.pushNamed(context, RouteConstants.historyScreen);
      // }),
        appBar: CommonWidgets.appBar(context, "home".tr(), prefix: true, suffix: true, suffixTap: (){
          Navigator.pushNamed(context, RouteConstants.settingsScreen);
        }),
      body: BaseView<HomeProvider>(
        builder: (context, provider, _){
          return  Container(
            height: MediaQuery.of(context).size.height,
            width: DimensionConstants.d375.w,
            margin: EdgeInsets.only(top: DimensionConstants.d36.h),
            decoration: BoxDecoration(
              color: ColorConstants.colorWhite,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(DimensionConstants.d44.r),
                topLeft: Radius.circular(DimensionConstants.d44.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: DimensionConstants.d73.h),
                CommonWidgets.goodMorningText(),
                Padding(
                  padding: EdgeInsets.fromLTRB(DimensionConstants.d20.w, DimensionConstants.d54.h, DimensionConstants.d19.w, 0.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, RouteConstants.noteScreen).then((value) {
                                  if(value == true){
                                    DialogHelper.showMessage(context, "hey_snap".tr());
                                  }
                                });
                              },
                              child: cardView("note".tr(), ColorConstants.primaryColor,DimensionConstants.d22.h, DimensionConstants.d72.w)),
                          SizedBox(width: DimensionConstants.d15.w),
                          GestureDetector(
                              onTap: () async {
                               // var value = await provider.permissionCheck();
                              //  if(value){
                                var status = await Permission.storage.status;
                                if (await Permission.storage.request().isGranted) {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CustomDialog(
                                            cameraClick: () async {
                                              var status = await Permission.camera.status;
                                              if (await Permission.camera.request().isGranted) {
                                                provider.getImage(_scaffoldKey.currentContext!, 1);
                                              } else if (status.isDenied) {
                                                await Permission.camera.request();
                                                if(status.isDenied){
                                                  CommonWidgets.permissionErrorDialog(context, "camera_permission".tr(), "camera_permission_not_granted".tr());
                                                }
                                              } else if (await status.isPermanentlyDenied) {
                                                CommonWidgets.permissionErrorDialog(context, "camera_permission".tr(), "camera_permission_not_granted".tr());
                                              }
                                            },
                                            galleryClick: () async {
                                              if(Platform.isIOS){
                                                var status = await Permission.photos.status;
                                                if (await Permission.photos.request().isGranted) {
                                              provider.getImage(_scaffoldKey.currentContext!, 2);
                                              } else if (status.isDenied) {
                                              await Permission.photos.request();
                                              if(status.isDenied){
                                              CommonWidgets.permissionErrorDialog(context, "media_permission".tr(), "media_permission_not_granted".tr());
                                              }
                                              } else if (await status.isPermanentlyDenied) {
                                              CommonWidgets.permissionErrorDialog(context, "media_permission".tr(), "media_permission_not_granted".tr());
                                              }
                                              } else{
                                                provider.getImage(
                                                    _scaffoldKey.currentContext!, 2);
                                              }
                                            },
                                            cancelClick: () {
                                              Navigator.of(context).pop();
                                            },
                                          ));
                                } else if (status.isDenied) {
                                  await Permission.storage.request();
                                  if(status.isDenied){
                                    CommonWidgets.permissionErrorDialog(context, "storage_permission".tr(), "storage_permission_not_granted".tr());
                                  }
                                } else if (await status.isPermanentlyDenied) {
                                  // The user opted to never again see the permission request dialog for this
                                  // app. The only way to change the permission's status now is to let the
                                  // user manually enable it in the system settings.
                                  CommonWidgets.permissionErrorDialog(context, "storage_permission".tr(), "storage_permission_not_granted".tr());
                                }
                              //   }
                              },
                              child: cardView("photo".tr(), ColorConstants.colorYellowDown,DimensionConstants.d22.h, DimensionConstants.d72.w))
                        ],
                      ),
                      SizedBox(height: DimensionConstants.d17.h),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, RouteConstants.documentScreen).then((value) {
                                if(value == true){
                                  DialogHelper.showMessage(context, "document_send_successfully".tr());
                                }
                              });
                            },
                              child: cardView("document".tr(), ColorConstants.colorGreenDown, DimensionConstants.d32.h, DimensionConstants.d73.w)),
                          SizedBox(width: DimensionConstants.d15.w),
                          GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, RouteConstants.voiceScreen).then((value) {
                                  if(value == true){
                                    DialogHelper.showMessage(context, "recording_send_successfully".tr());
                                  }
                                });
                              },
                              child: cardView("voice".tr(), ColorConstants.colorRedDown, DimensionConstants.d32.h, DimensionConstants.d74.w))
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            ),);
        },
      )
    );
  }

  Widget cardView(String title, color, double height, double width){
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.all(Radius.circular(DimensionConstants.d30.r)),
      child: Container(
        decoration: BoxDecoration(
           color: color,
            borderRadius: BorderRadius.all(Radius.circular(DimensionConstants.d30.r))
        ),
        alignment: Alignment.center,
        width: DimensionConstants.d160.w,
        height: DimensionConstants.d200.h,
        child: Column(
          children: [
            SizedBox(height: height),
           Row(
             children: [
               SizedBox(width: width),
              Expanded(
                child: Text(title).boldText(ColorConstants.colorWhite.withOpacity(0.1), DimensionConstants.d40.sp, TextAlign.right, maxLines: 1),
              )
             ],
           ),
            Text(title).boldText(ColorConstants.colorWhite, DimensionConstants.d22.sp, TextAlign.center, maxLines: 2)
          ],
        ),
      ),
    );
  }
}
