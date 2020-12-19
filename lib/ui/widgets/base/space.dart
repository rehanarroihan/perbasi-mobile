import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';

class Space extends StatelessWidget {
  final double height, width;

  Space({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    if (!GlobalMethodHelper.isEmpty(height) && !GlobalMethodHelper.isEmpty(width)) {
      return SizedBox(
        height: ScreenUtil().setHeight(height),
        width: ScreenUtil().setWidth(width),
      );
    }

    if (!GlobalMethodHelper.isEmpty(height)) {
      return SizedBox(
        height: ScreenUtil().setHeight(height),
      );
    }

    if (!GlobalMethodHelper.isEmpty(width)) {
      return SizedBox(
        width: ScreenUtil().setWidth(width),
      );
    }

    return SizedBox(height: 0, width: 0);
  }
}
