import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/decoration.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/helper/common_widgets.dart';

class VoiceScreen extends StatelessWidget {
  VoiceScreen({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        CommonWidgets.hideKeyboard(context);
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants.backgroundColor,
        appBar: CommonWidgets.appBar(context, "voice".tr()),
        body: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            margin: EdgeInsets.only(top: DimensionConstants.d36.h),
            padding: EdgeInsets.only(top: DimensionConstants.d73.h),
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
                  // SizedBox(height: DimensionConstants.d73.h),
                  CommonWidgets.goodMorningText(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(DimensionConstants.d20.w, DimensionConstants.d55.h, DimensionConstants.d20.w, 0.0),
                    child: Column(
                      children: [
                        emailTextField(),
                        SizedBox(height: DimensionConstants.d21.h),
                        GestureDetector(
                          onTap: (){
                            //    Navigator.pushNamed(context, RouteConstants.otpVerify);
                          },
                          child:  CommonWidgets.commonBtn(context, "next".tr(), DimensionConstants.d63.h, DimensionConstants.d330.w),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ),),
        ),
      ),
    );
  }

  Widget emailTextField(){
    return SizedBox(
      height: DimensionConstants.d63.h,
      child: TextFormField(
        controller: emailController,
        style: ViewDecoration.textFieldStyle(
            DimensionConstants.d12, FontWeight.w400, ColorConstants.colorBlack),
        decoration: ViewDecoration.inputDecorationForEmailTextField(
            "email_address".tr(),  EdgeInsets.fromLTRB(DimensionConstants.d23.w, DimensionConstants.d26.h, 0.0, DimensionConstants.d19.h)),
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

}
