import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/image_constants.dart';
import 'package:snap_app/extensions/all_extensions.dart';
import 'package:snap_app/widgets/custom_shape.dart';
import 'package:snap_app/widgets/image_view.dart';

class CommonWidgets{
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static Widget commonBtn(BuildContext context, String txt, double height, double width,
      {VoidCallback? onTapFun}) {
    return GestureDetector(
      onTap: onTapFun,
      child: CustomShape(
        child: Center(
          child: Text(txt).semiBoldText(ColorConstants.colorWhite,
              DimensionConstants.d14.sp, TextAlign.center),
        ),
        bgColor: ColorConstants.primaryColor,
        radius: BorderRadius.circular(DimensionConstants.d12.r),
        width: width,
        height: height,
      ),
    );
  }


 static PreferredSizeWidget appBar(BuildContext context, String title, {double prefixWidth = DimensionConstants.d20, bool prefix = false, String? prefixImgPath, bool suffix = false, String? suffixImgPath, VoidCallback? suffixTap, Widget? colorPicker}){
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: ColorConstants.backgroundColor,
      leading: Row(
        children: [
          SizedBox(width: prefixWidth.w),
          GestureDetector(
              onTap: (){
                CommonWidgets.hideKeyboard(context);
                Navigator.of(context).pop();
              },
              child: prefix == true ? Container() :  const ImageView(path: ImageConstants.backArrow)),
        ],
      ),
      title: Text(title).boldText(ColorConstants.colorBlackDown, DimensionConstants.d22.sp, TextAlign.center),
      actions: [
        Row(
          children: [
           colorPicker ?? Container(),
            SizedBox(width: DimensionConstants.d20.w),
            suffix == true ? GestureDetector(
              onTap: suffixTap,
                child: ImageView(path: suffixImgPath)) : Container(),
            SizedBox(width: DimensionConstants.d20.w),
          ],
        )
      ],
    );
 }

 static Widget goodMorningText(){
    return Container(
      padding: EdgeInsets.only(left: DimensionConstants.d19.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(greeting()).semiBoldText(ColorConstants.colorBlackDown, DimensionConstants.d26.sp, TextAlign.left),
          Text("we_wish_you_have_a_good_day".tr()).regularText(ColorConstants.colorGrayDown, DimensionConstants.d15.sp, TextAlign.left)
        ],
      ),
    );
 }

  static errorDialog(BuildContext context, String content) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Permissions error'),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                }
            )
          ],
        ));
  }

  static String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'good_morning_snap'.tr();
    }
    if (hour < 16) {
      return 'good_afternoon_snap'.tr();
    }
    return 'good_evening_snap'.tr();
  }

  static recordStopBtn({required IconData icon, required Color iconColor, required VoidCallback onPressFunc}){
    return GestureDetector(
      onTap: onPressFunc,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.d40.sp),
        ),
        child: Container(
          padding: EdgeInsets.all(DimensionConstants.d6),
          child: Icon(
            icon,
            color: iconColor,
            size: 38.0,
          ),
        ),
      ),
    );
  }

  static permissionErrorDialog(BuildContext context, String title, String content){
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title).semiBoldText(ColorConstants.colorBlackDown, DimensionConstants.d16.sp, TextAlign.center),
          content: Text(content).regularText(ColorConstants.colorBlackDown, DimensionConstants.d12.sp, TextAlign.center),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Deny'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              child: Text('Settings'),
              onPressed: (){
                Navigator.of(context).pop();
                openAppSettings();
              }
            ),
          ],
        ));
  }
}