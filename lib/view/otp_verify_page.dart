import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/extensions/all_extensions.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:snap_app/helper/dialog_helper.dart';
import 'package:snap_app/provider/otp_verify_provider.dart';
import 'package:snap_app/view/base_view.dart';

class OtpVerifyPage extends StatelessWidget {
   OtpVerifyPage({Key? key, required this.email}) : super(key: key);
   TextEditingController otpController = TextEditingController();
   StreamController<ErrorAnimationType>? errorController =
   StreamController<ErrorAnimationType>();
   String email;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return GestureDetector(
      onTap: (){
        CommonWidgets.hideKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: ColorConstants.backgroundColor,
        appBar: CommonWidgets.appBar(context, "verify_otp".tr()),
        body: BaseView<OtpVerifyProvider>(
          onModelReady: (provider){
          },
          builder: (context, provider, _){
            return Container(
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
                    Text("verify_identity".tr()).semiBoldText(ColorConstants.colorBlackDown, DimensionConstants.d26.sp, TextAlign.left),
                    Text("enter_code_email_address".tr()).regularText(ColorConstants.colorGrayDown, DimensionConstants.d15.sp, TextAlign.left, maxLines: 2),
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
                          activeColor: provider.otpCorrect == true ? ColorConstants.backgroundColor : ColorConstants.colorRed,
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
                        provider.verifyOtp(context, email, v);
                      },
                      onChanged: (value) {},
                      beforeTextPaste: (text) {
                        return true;
                      },
                    ),
                    SizedBox(height: DimensionConstants.d18.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: (){
                          provider.resendOTP == true ?  provider.timerFun() : provider.resendCode();
                          provider.resendOtpApi(context, email).then((value){
                           // if(value){
                              provider.timer!.cancel();
                              provider.enableResend = false;
                         //   }
                          });
                          provider.updateVerify(true);
                        },
                        child: Text(provider.enableResend == false ? "resend_otp".tr() : "0 : ${provider.secondsRemaining.toString()}").boldText(ColorConstants.colorGrayDown, DimensionConstants.d15.sp, TextAlign.left),
                      )
                    ),
                    provider.state == ViewState.busy ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: DimensionConstants.d28.h),
                          const CircularProgressIndicator(),
                          SizedBox(height: DimensionConstants.d4.h),
                          Text("otp_verifying".tr()).regularText(ColorConstants.primaryColor, DimensionConstants.d15.sp, TextAlign.left),
                        ],
                      ),
                    ) : Container(),
                   // SizedBox(height: DimensionConstants.d221.h),
                    // GestureDetector(
                    //   onTap: (){
                    //
                    //   },
                    //   child:  CommonWidgets.commonBtn(context, "next".tr(), DimensionConstants.d63.h, DimensionConstants.d330.w),
                    // )
                  ],
                ),
              ),);
          },
        )
      ),
    );
  }
}
