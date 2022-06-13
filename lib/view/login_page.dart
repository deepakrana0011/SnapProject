import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/decoration.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/constants/validations.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/extensions/all_extensions.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:snap_app/helper/shared_pref.dart';
import 'package:snap_app/provider/login_provider.dart';
import 'package:snap_app/router.dart';
import 'package:snap_app/view/base_view.dart';

class LoginPage extends StatelessWidget {
   LoginPage({Key? key}) : super(key: key);

   final emailController = TextEditingController();
   final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      body: SingleChildScrollView(
        child: BaseView<LoginProvider>(
          builder: (context, provider, _){
            return  Form(
              key: _formKey,
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(DimensionConstants.d72.w, DimensionConstants.d163.h, DimensionConstants.d64.w, DimensionConstants.d19.h),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("${"welcome_back".tr()}!").boldText(ColorConstants.colorBlackDown, DimensionConstants.d28.sp, TextAlign.center),
                      ),
                    ),
                    emailTextField(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(DimensionConstants.d22_46.w, DimensionConstants.d102.h, DimensionConstants.d23.w, 0.0),
                      child: provider.state == ViewState.busy
                          ? const CircularProgressIndicator()
                          : GestureDetector(
                          onTap: (){
                            if(_formKey.currentState!.validate()){
                              CommonWidgets.hideKeyboard(context);
                              // provider.login(context, emailController.text).then((value) {
                              //   if(value){
                              //     emailController.clear();
                              //   }
                              // });
                              SharedPref.prefs?.setString(SharedPref.userEmail, emailController.text) ?? "";
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  RouteConstants.home,
                                      (Route<dynamic> route) =>
                                  false);
                            }
                          },
                          child: CommonWidgets.commonBtn(context, "login".tr(), DimensionConstants.d57.h, DimensionConstants.d330.w)),
                    ),
                   // SizedBox(height: DimensionConstants.d179.h),
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(DimensionConstants.d47.w, 0.0, DimensionConstants.d46.w, 0.0),
                    //   alignment: Alignment.bottomCenter,
                    //   child: Row(
                    //     children: [
                    //       Text("do_not_have_an_account".tr()).regularText(ColorConstants.colorGrayDown, DimensionConstants.d14.sp, TextAlign.center, letterSpacing: 1.0),
                    //       GestureDetector(
                    //         onTap: (){
                    //           Navigator.pushNamed(context, RouteConstants.signUp);
                    //         },
                    //         child: Text("sign_up".tr()).regularText(ColorConstants.primaryColor, DimensionConstants.d14.sp, TextAlign.center, letterSpacing: 1.0),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    //  SizedBox(height: DimensionConstants.d56.h),
                  ],
                ),
              ),
            );
          },
        )
      ),
    );
  }

  Widget emailTextField(){
    return Padding(
      padding: EdgeInsets.fromLTRB(DimensionConstants.d22.w, DimensionConstants.d117.h, DimensionConstants.d23_46.w, 0.0),
      child: SizedBox(
      //  height: DimensionConstants.d57.h,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          controller: emailController,
          style: ViewDecoration.textFieldStyle(
              DimensionConstants.d16, FontWeight.w300, ColorConstants.colorBlack),
          decoration: ViewDecoration.inputDecorationForLoginTextField(
              "email_address".tr()),
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
        ),
      ),
    );
  }
}
