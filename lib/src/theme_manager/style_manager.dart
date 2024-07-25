import 'package:attendance/src/theme_manager/color_manager.dart';
import 'package:attendance/src/theme_manager/font_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle _getTextStyle(
  double fontSize,
  String fontFamily,
  FontWeight fontWeight,
  Color color,
) {
  return GoogleFonts.poppins().copyWith(
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    color: color,
  );
}

TextStyle getWhiteTextStyle({
  double fontSize = FontSizeManager.f16,
  FontWeight fontWeight = FontWeighManager.regular,
}) {
  return _getTextStyle(
    fontSize,
    FontFamilyConstant.fontFamily,
    fontWeight,
    ColorManager.white,
  );
}

TextStyle getBlack60TextStyle({
  double fontSize = FontSizeManager.f16,
  FontWeight fontWeight = FontWeighManager.regular,
}) {
  return _getTextStyle(
    fontSize,
    FontFamilyConstant.fontFamily,
    fontWeight,
    ColorManager.black60,
  );
}

TextStyle getBlack30TextStyle({
  double fontSize = FontSizeManager.f16,
  FontWeight fontWeight = FontWeighManager.regular,
}) {
  return _getTextStyle(
    fontSize,
    FontFamilyConstant.fontFamily,
    fontWeight,
    ColorManager.black30,
  );
}

TextStyle getBlackTextStyle({
  double fontSize = FontSizeManager.f16,
  FontWeight fontWeight = FontWeighManager.regular,
}) {
  return _getTextStyle(
    fontSize,
    FontFamilyConstant.fontFamily,
    fontWeight,
    ColorManager.black,
  );
}

TextStyle getGrey60TextStyle({
  double fontSize = FontSizeManager.f14,
  FontWeight fontWeight = FontWeighManager.regular,
}) {
  return _getTextStyle(
    fontSize,
    FontFamilyConstant.fontFamily,
    fontWeight,
    ColorManager.grey60,
  );
}

final ButtonStyle btnPrimaryStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
  backgroundColor: ColorManager.primary,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);

final ButtonStyle btnWhiteStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
  backgroundColor: ColorManager.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);
