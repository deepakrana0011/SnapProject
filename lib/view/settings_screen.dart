import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/decoration.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/validations.dart';
import 'package:snap_app/extensions/all_extensions.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:snap_app/helper/shared_pref.dart';


class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController.text = SharedPref.prefs?.getString(SharedPref.userEmail) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: CommonWidgets.appBar(context, ""),
      body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(DimensionConstants.d72.w, DimensionConstants.d163.h, DimensionConstants.d64.w, DimensionConstants.d19.h),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("${"update_email".tr()}!").boldText(ColorConstants.colorBlackDown, DimensionConstants.d28.sp, TextAlign.center),
                  ),
                ),
                emailTextField(),
                Padding(
                  padding: EdgeInsets.fromLTRB(DimensionConstants.d22_46.w, DimensionConstants.d102.h, DimensionConstants.d23.w, 0.0),
                  child: GestureDetector(
                      onTap: (){
                        if(_formKey.currentState!.validate()){
                          CommonWidgets.hideKeyboard(context);
                          SharedPref.prefs?.setString(SharedPref.userEmail, emailController.text) ?? "";
                          Navigator.of(context).pop();
                        }
                      },
                      child: CommonWidgets.commonBtn(context, "update".tr(), DimensionConstants.d57.h, DimensionConstants.d330.w)),
                ),
              ],
            ),
          )
      ),
    );
  }

  Widget emailTextField(){
    return Padding(
      padding: EdgeInsets.fromLTRB(DimensionConstants.d22.w, DimensionConstants.d117.h, DimensionConstants.d23_46.w, 0.0),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        controller: emailController..text,
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
    );
  }
}
