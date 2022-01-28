import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/extensions/all_extensions.dart';
import 'package:snap_app/helper/common_widgets.dart';

class OtpVerifyPage extends StatelessWidget {
   OtpVerifyPage({Key? key}) : super(key: key);
   final otpController = TextEditingController();
   StreamController<ErrorAnimationType>? errorController =
   StreamController<ErrorAnimationType>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        CommonWidgets.hideKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: ColorConstants.backgroundColor,
        appBar: CommonWidgets.appBar(context, "verify_otp".tr()),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(DimensionConstants.d20.h, DimensionConstants.d73.h, DimensionConstants.d20.h, 0.0),
          margin: EdgeInsets.only(top: DimensionConstants.d36.h),
          decoration: BoxDecoration(
            color: ColorConstants.colorWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(DimensionConstants.d44.r),
              topLeft: Radius.circular(DimensionConstants.d44.r),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Text("verify_identity".tr()).semiBoldText(ColorConstants.colorBlackDown, DimensionConstants.d26, TextAlign.left),
                    Text("enter_code_email_address".tr()).regularText(ColorConstants.colorGrayDown, DimensionConstants.d15, TextAlign.left, maxLines: 2),
                SizedBox(height: DimensionConstants.d55.h),
               PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: ColorConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 4,
                    obscuringCharacter: '*',
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                        activeColor: ColorConstants.backgroundColor,
                        disabledColor: ColorConstants.backgroundColor,
                        inactiveFillColor: ColorConstants.backgroundColor,
                        inactiveColor: ColorConstants.backgroundColor,
                        selectedColor: ColorConstants.primaryColor,
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(DimensionConstants.d8.r),
                        fieldHeight: DimensionConstants.d55.h,
                        fieldWidth: DimensionConstants.d55.w,
                        errorBorderColor: ColorConstants.colorRed,
                        activeFillColor: ColorConstants.backgroundColor,
                        selectedFillColor: ColorConstants.backgroundColor),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    boxShadows: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: ColorConstants.backgroundColor,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) {

                    },
                    onChanged: (value) {},
                    beforeTextPaste: (text) {
                      return true;
                    },
                  ),
                SizedBox(height: DimensionConstants.d221.h),
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, RouteConstants.home);
                  },
                  child:  CommonWidgets.commonBtn(context, "next".tr(), DimensionConstants.d63.h, DimensionConstants.d330.w),
                )
              ],
            ),
          ),),
      ),
    );
  }
}
