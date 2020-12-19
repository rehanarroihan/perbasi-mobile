import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/utils/app_color.dart';

enum AppButtonStyle {
  primary,
  secondary
}

class Button extends StatelessWidget {
  final AppButtonStyle style;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final Function onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final double padding;

  Button({
    this.style = AppButtonStyle.primary,
    this.text = '',
    @required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w500,
    this.padding = 15,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: !isDisabled ? onPressed : null,
      color: _getButtonColorByStyle(this.style),
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(padding)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6)
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(fontSize),
          color: Colors.white,
          fontWeight: fontWeight
        ),
      )
    );
  }

  Color _getButtonColorByStyle(AppButtonStyle style) {
    Color color;

    switch (style) {
      case AppButtonStyle.primary:
        color = AppColor.primaryColor;
        break;

      case AppButtonStyle.secondary:
        color = AppColor.secondaryColor;
        break;
    }

    return color;
  }
}
