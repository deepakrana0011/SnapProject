import 'package:flutter/material.dart';
import 'package:snap_app/constants/string_constants.dart';

extension ExtendText on Text {
  lightText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow,}) {
    return Text(
      data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
        color: color,
        fontFamily: StringConstants.poppins,
        fontWeight: FontWeight.w300,
        fontSize: textSize,),
    );
  }

  regularText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow, letterSpacing = 0.0}) {
    return Text(
      data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.poppins,
          fontWeight: FontWeight.w400,
          fontSize: textSize,
         letterSpacing: letterSpacing),
    );
  }

  mediumText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow}) {
    return Text(
      data!,
      maxLines: maxLines,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.poppins,
          fontWeight: FontWeight.w500,
          fontSize: textSize),
    );
  }

  semiBoldText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow}) {
    return Text(
      data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.poppins,
          fontWeight: FontWeight.w600,
          fontSize: textSize),
    );
  }

  boldText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow}) {
    return Text(
      data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.poppins,
          fontWeight: FontWeight.w700,
          fontSize: textSize),
    );
  }
}