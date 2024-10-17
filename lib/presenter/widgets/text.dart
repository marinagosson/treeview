import 'package:flutter/material.dart';
import 'package:treeview_tractian/presenter/utils/colors.dart';

class CustomText {
  final String fontFamily = 'Roboto';
  final String value;
  final Color? color;
  final TextAlign? textAlign;

  CustomText({required this.value, this.color, this.textAlign});

  Widget get tile => Text(
        value,
        textAlign: textAlign,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          color: color ?? AppColors.white,
        ),
      );

  Widget get tree => Text(
        value,
        textAlign: textAlign,
        style: TextStyle(
            fontFamily: fontFamily, fontSize: 14, color: color ?? Colors.black),
      );

  Widget get filterButton => Text(
        value,
        textAlign: textAlign,
        style: TextStyle(
            fontFamily: fontFamily, fontSize: 14, color: color ?? Colors.black),
      );

  Widget get body => Text(
        value,
        textAlign: textAlign,
        style: TextStyle(
            fontFamily: fontFamily, fontSize: 16, color: color ?? Colors.black),
      );
}
