import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

 static PreferredSizeWidget appBar(BuildContext context, String title, {double prefixWidth = DimensionConstants.d20, bool prefix = false, String? prefixImgPath, bool suffix = false, String? suffixImgPath}){
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: ColorConstants.backgroundColor,
      leading: Row(
        children: [
          SizedBox(width: prefixWidth.w),
          GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: prefix == true ? ImageView(path: prefixImgPath) :  const ImageView(path: ImageConstants.backArrow)),
        ],
      ),
      title: Text(title).boldText(ColorConstants.colorBlackDown, DimensionConstants.d22.sp, TextAlign.center),
      actions: [
        Row(
          children: [
            suffix == true ? ImageView(path: suffixImgPath) : Container(),
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
          Text("good_morning_snap".tr()).semiBoldText(ColorConstants.colorBlackDown, DimensionConstants.d26, TextAlign.left),
          Text("we_wish_you_have_a_good_day".tr()).regularText(ColorConstants.colorGrayDown, DimensionConstants.d15, TextAlign.left)
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
}