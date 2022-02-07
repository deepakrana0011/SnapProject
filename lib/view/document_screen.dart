import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/decoration.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/extensions/all_extensions.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:snap_app/provider/document_provider.dart';
import 'package:snap_app/view/base_view.dart';

class DocumentScreen extends StatelessWidget {
   DocumentScreen({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
        // resizeToAvoidBottomInset: false,
          backgroundColor: ColorConstants.backgroundColor,
          appBar: CommonWidgets.appBar(context, "voice".tr()),
          body: BaseView<DocumentProvider>(
            onModelReady: (provider)  {
            },
            builder: (context, provider, _) {
              return Form(
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
                        pickFile(),
                          SizedBox(height: DimensionConstants.d40.h),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              DimensionConstants.d20.w,
                              DimensionConstants.d25.h,
                              DimensionConstants.d20.w,
                              0.0),
                          child: Column(
                            children: [
                              emailTextField(),
                              SizedBox(height: DimensionConstants.d21.h),
                              GestureDetector(
                                onTap: () {

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


   Widget pickFile(){
    return Container(
      margin: EdgeInsets.fromLTRB(DimensionConstants.d20.w,  DimensionConstants.d40.h,  DimensionConstants.d20.w,  DimensionConstants.d25.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){

              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(DimensionConstants.d15.r),
                    color: ColorConstants.colorWhite,
                    boxShadow: [
                      BoxShadow(color: ColorConstants.primaryColor, spreadRadius: 3),
                    ],
                  ),
                padding: EdgeInsets.fromLTRB(DimensionConstants.d30.w,  DimensionConstants.d32.h,  DimensionConstants.d30.w,  DimensionConstants.d32.h),
                child:  Text("choose_a_document".tr()).regularText(ColorConstants.colorBlackDown, DimensionConstants.d15.sp, TextAlign.left)
              ),
            ),
          ),
          SizedBox(width: DimensionConstants.d10.w),
          Icon(Icons.close, size: DimensionConstants.d32),
        ],
      ),
    );
   }
}
