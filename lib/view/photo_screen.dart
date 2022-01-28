import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/decoration.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/image_constants.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:snap_app/widgets/image_view.dart';

class PhotoScreen extends StatelessWidget {
  PhotoScreen({Key? key, required this.image}) : super(key: key);
  File image;
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonWidgets.hideKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: ColorConstants.backgroundColor,
        appBar: CommonWidgets.appBar(context, "photo".tr(),
            suffix: true, suffixImgPath: ImageConstants.textIcon),
        body: Form(
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
                            Navigator.pushNamed(
                                context, RouteConstants.otpVerify);
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
        ),
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
}
