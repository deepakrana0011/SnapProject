import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/string_constants.dart';

class ViewDecoration {
  static InputDecoration inputDecorationForLoginTextField(String fieldName) {
    return InputDecoration(
        hintText: fieldName,
        hintStyle: textFieldStyle(DimensionConstants.d16.sp, FontWeight.w300, ColorConstants.colorGrayDown),
        filled: true,
        isDense: true,
        // contentPadding: const EdgeInsets.fromLTRB(
        //     DimensionConstants.d18,
        //     DimensionConstants.d20,
        //     0.0,
        //     DimensionConstants.d21),
        fillColor: ColorConstants.textFieldGrayColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.d15.r),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ));
  }

  static InputDecoration inputDecorationForEmailTextField(String fieldName, contentPadding) {
    return InputDecoration(
        hintText: fieldName,
        hintStyle: textFieldStyle(DimensionConstants.d12.sp, FontWeight.w400, ColorConstants.colorGrayDown),
        filled: true,
        isDense: true,
        contentPadding: contentPadding,
        fillColor: ColorConstants.textFieldGrayColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionConstants.d15.r),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ));
  }

  static TextStyle textFieldStyle(double size, fontWeight, color) {
    return TextStyle(
        color: color,
        fontFamily: StringConstants.poppins,
        fontWeight: fontWeight,
        fontSize: size,
    letterSpacing: 1.0);
  }
}
