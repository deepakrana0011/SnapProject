

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/extensions/all_extensions.dart';
import 'package:snap_app/widgets/custom_shape.dart';

class CustomDialog extends StatelessWidget {
  final VoidCallback galleryClick;
  final VoidCallback cameraClick;
  final VoidCallback cancelClick;

  const CustomDialog(
      {Key? key, required this.galleryClick, required this.cameraClick, required this.cancelClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return Dialog(
      backgroundColor: Colors.transparent,
      child: CustomShape(
        bgColor: Colors.white,
        radius: BorderRadius.all(Radius.circular(DimensionConstants.d16.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Ink(
              decoration: BoxDecoration(
                  color: ColorConstants.primaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(DimensionConstants.d16.r), topRight: Radius.circular(DimensionConstants.d16.r))),
              child: Padding(
                padding: const EdgeInsets.all(DimensionConstants.d10),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "choose_from".tr(),
                    ).mediumText(ColorConstants.colorWhite, DimensionConstants.d14.sp, TextAlign.center)),
              ),
            ),
            GestureDetector(
              onTap: galleryClick,
              child: Padding(
                padding: const EdgeInsets.all(DimensionConstants.d8),
                child: Text("phone_gallery".tr()).regularText(ColorConstants.primaryColor,DimensionConstants.d14.sp,TextAlign.center),
              ),
            ),
            const Divider(
              height: 1.0,
              color: Colors.black,
            ),
            GestureDetector(
              onTap: cameraClick,
              child: Padding(
                padding: const EdgeInsets.all(DimensionConstants.d8),
                child: Text("camera".tr()).regularText(ColorConstants.primaryColor, DimensionConstants.d14.sp,TextAlign.center),
              ),
            ),
            const Divider(
              height: 1.0,
              color: Colors.black,
            ),
            GestureDetector(
              onTap: cancelClick,
              child: Padding(
                padding: const EdgeInsets.all(DimensionConstants.d8),
                child: Text("cancel".tr()).regularText(ColorConstants.colorRed, DimensionConstants.d14.sp,TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


