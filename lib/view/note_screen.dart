import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/decoration.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/constants/validations.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:snap_app/provider/note_provider.dart';
import 'package:snap_app/view/base_view.dart';

class NoteScreen extends StatelessWidget {
   NoteScreen({Key? key}) : super(key: key);
   final emailController = TextEditingController();
   final descriptionController = TextEditingController();
   final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return GestureDetector(
      onTap: (){
        CommonWidgets.hideKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: ColorConstants.backgroundColor,
        appBar: CommonWidgets.appBar(context, "note".tr()),
        body: BaseView<NoteProvider>(
          onModelReady: (provider){
            emailController.text = provider.email;
          },
          builder: (context, provider, _){
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(DimensionConstants.d20.w, DimensionConstants.d55.h, DimensionConstants.d20.w, 0.0),
                        child: Column(
                          children: [
                          //  emailTextField(),
                          //  SizedBox(height: DimensionConstants.d20.h),
                            descriptionTextField(),
                            SizedBox(height: DimensionConstants.d38.h),
                            provider.state == ViewState.busy
                                ? const CircularProgressIndicator(): GestureDetector(
                              onTap: (){
                                CommonWidgets.hideKeyboard(context);
                                if(_formKey.currentState!.validate()){
                                  provider.sendNote(context, emailController.text, descriptionController.text).then((value) {
                                    if(value){
                                    //  emailController.clear();
                                      descriptionController.clear();
                                    }
                                  });
                                }
                              },
                              child:  CommonWidgets.commonBtn(context, "next".tr(), DimensionConstants.d63.h, DimensionConstants.d330.w),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ),),
            );
          },
        )
      ),
    );
  }

   Widget emailTextField(){
     return TextFormField(
       readOnly: true,
       controller: emailController,
       style: ViewDecoration.textFieldStyle(
           DimensionConstants.d12, FontWeight.w400, ColorConstants.colorBlack),
       decoration: ViewDecoration.inputDecorationForEmailTextField(
           "email_address".tr(),  EdgeInsets.fromLTRB(DimensionConstants.d23.w, DimensionConstants.d26.h, 0.0, DimensionConstants.d19.h)),
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


   Widget descriptionTextField(){
     return SizedBox(
       height: DimensionConstants.d163.h,
       child: TextFormField(
         textCapitalization: TextCapitalization.sentences,
         controller: descriptionController,
         style: ViewDecoration.textFieldStyle(
             DimensionConstants.d12, FontWeight.w400, ColorConstants.colorBlack),
         decoration: ViewDecoration.inputDecorationForEmailTextField(
             "description".tr(), EdgeInsets.fromLTRB(DimensionConstants.d18.w, DimensionConstants.d40.h, 0.0, 0.0)),
         textInputAction: TextInputAction.newline,
         keyboardType: TextInputType.multiline,
         maxLines: 10,
         validator: (value) {
           if(value!.trim().isEmpty){
             return "description_empty".tr();
           } else{
             return null;
           }
         },
       ),
     );
   }

}
