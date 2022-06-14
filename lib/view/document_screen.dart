import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/decoration.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/validations.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/extensions/all_extensions.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:snap_app/helper/dialog_helper.dart';
import 'package:snap_app/provider/document_provider.dart';
import 'package:snap_app/view/base_view.dart';

class DocumentScreen extends StatelessWidget {
   DocumentScreen({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return GestureDetector(
      onTap: () {
        CommonWidgets.hideKeyboard(context);
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
          backgroundColor: ColorConstants.backgroundColor,
          appBar: CommonWidgets.appBar(context, "document".tr()),
          body: BaseView<DocumentProvider>(
            onModelReady: (provider)  {
              emailController.text = provider.email;
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       // CommonWidgets.goodMorningText(),
                        pickFile(context, provider),
                          SizedBox(height: DimensionConstants.d40.h),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              DimensionConstants.d20.w,
                              DimensionConstants.d25.h,
                              DimensionConstants.d20.w,
                              0.0),
                          child: Column(
                            children: [
                              // emailTextField(),
                              // SizedBox(height: DimensionConstants.d21.h),
                              provider.state == ViewState.busy
                                  ? Center(child: const CircularProgressIndicator())
                                  : GestureDetector(
                                onTap: () async {
                                 // if(_formKey.currentState!.validate()){
                                 //    final kb = provider.file!.size / 1024;
                                 //    final mb = kb / 1024;
                                 //    if(mb > 20){
                                 //      DialogHelper.showMessage(context, "file_size_exceeds".tr());
                                 //    } else{
                                 //    }
                                 //  }
                                  if(provider.pdfFile != null){
                                    provider.sendDocument(context, emailController.text, provider.pdfFile!).then((value) {
                                      //   emailController.clear();
                                      //    provider.filePath = "";
                                      //    provider.file = null;
                                      provider.pdfFile!.delete();
                                      provider.updatePickFile(true);
                                    });
                                  } else{
                                    DialogHelper.showMessage(context, "please_select_document".tr());
                                  }

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
     return TextFormField(
       readOnly: true,
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
         if (value!.trim().isEmpty) {
           return "email_required".tr();
         } else if (!Validations.emailValidation(
             value.trim())) {
           return "invalid_email".tr();
         } else {
           return null;
         }
       },
     );
   }


   Widget pickFile(BuildContext context, DocumentProvider provider){
    return Container(
      margin: EdgeInsets.fromLTRB(DimensionConstants.d20.w,  DimensionConstants.d40.h,  DimensionConstants.d20.w,  DimensionConstants.d25.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
              //  provider.pickAFile(context);
                var status = await Permission.camera.status;
                if (await Permission.camera.request().isGranted) {
                  provider.getFileFromCamera(context);
                } else if (status.isDenied) {
                  await Permission.camera.request();
                  if(status.isDenied){
                    CommonWidgets.permissionErrorDialog(context, "camera_permission".tr(), "camera_permission_not_granted".tr());
                  }
                } else if (await status.isPermanentlyDenied) {
                  // The user opted to never again see the permission request dialog for this
                  // app. The only way to change the permission's status now is to let the
                  // user manually enable it in the system settings.
                  CommonWidgets.permissionErrorDialog(context, "camera_permission".tr(), "camera_permission_not_granted".tr());
                }
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
                child:  Text(provider.pdfFile == "" || provider.pdfFile == null ? "choose_a_document".tr() : "${CommonWidgets.fileName()}.pdf").regularText(ColorConstants.colorBlackDown, DimensionConstants.d15.sp, TextAlign.left)
              ),
            ),
          ),
          SizedBox(width: DimensionConstants.d10.w),
          GestureDetector(
            onTap: (){
              // provider.filePath = "";
              // provider.file = null;
              provider.pdfFile = null;
              provider.updatePickFile(true);
            },
              child: Icon(Icons.close, size: DimensionConstants.d32)),
        ],
      ),
    );
   }
}
