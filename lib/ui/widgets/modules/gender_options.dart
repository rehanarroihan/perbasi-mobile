import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:perbasitlg/utils/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum Gender {
  P, L
}

class GenderOptions extends StatelessWidget {
  final Gender value;
  final ValueChanged<Gender> onChange;

  GenderOptions({
    @required this.value,
    @required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 1,
          child: _genderOption(
            assetUri: 'assets/icons/male.svg',
            title: 'Laki-laki',
            selected: value == Gender.L,
            onTap: () => onChange(Gender.L)
          )
        ),
        SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: _genderOption(
            assetUri: 'assets/icons/female.svg',
            title: 'Perempuan',
            selected: value == Gender.P,
            onTap: () => onChange(Gender.P)
          )
        ),
      ],
    );
  }

  Widget _genderOption({
    String assetUri,
    String title,
    bool selected,
    Function onTap
  }) {
    return OutlineButton(
      onPressed: onTap,
      highlightedBorderColor: AppColor.primaryColor,
      splashColor: AppColor.primaryColor.withOpacity(0.25),
      highlightColor: AppColor.primaryColor.withOpacity(0.2),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      borderSide: BorderSide(
        width: 1,
        color: selected
            ? AppColor.primaryColor
            : AppColor.primaryColor.withOpacity(0.2),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              assetUri,
              color: selected
                  ? AppColor.primaryColor
                  : AppColor.primaryColor.withOpacity(0.2),
            ),
          ),
          SizedBox(width: 20.w),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: selected
                  ? AppColor.primaryColor
                  : AppColor.primaryColor.withOpacity(0.2),
              fontSize: 15
            ),
          )
        ],
      ),
    );
  }
}
