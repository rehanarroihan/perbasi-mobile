import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/ui/pages/auth/register_page.dart';
import 'package:perbasitlg/ui/widgets/base/box_input.dart';
import 'package:perbasitlg/ui/widgets/base/button.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/utils/app_color.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _greetings(),
            Space(height: 34),
            Text(
              'Masuk',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.w700
              ),
            ),
            BoxInput(
              controller: TextEditingController(),
              label: 'E-mail',
              /*suffixWidget: Button(
                onPressed: () {},
                padding: 4,
                fontSize: 12,
                text: 'asu',
                style: AppButtonStyle.primary,
                fontWeight: FontWeight.w300,
              ),*/
            ),

            Space(height: 24),
            BoxInput(
              controller: TextEditingController(),
              label: 'password',
              passwordField: true,
            ),
            Space(height: 34),
            Container(
              width: double.infinity,
              child: Button(
                onPressed: () {},
                text: 'masuk',
                style: AppButtonStyle.secondary,
              ),
            ),
            Space(height: 29),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Belum memiliki akun?'
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => RegisterPage()
                    ));
                  },
                  child: Text(
                    ' Daftar',
                    style: TextStyle(
                      color: Colors.deepOrange
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _greetings() {
    return Center(
      child: Stack(
        children: [
          Center(
            child: Container(
              transform: Matrix4.translationValues(20, -20, 0.0),
              child: Image(
                width: ScreenUtil().setWidth(136),
                height: ScreenUtil().setHeight(140),
                fit: BoxFit.contain,
                image: AssetImage('assets/images/login-radial.png'),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                Text(
                  'Perbasi'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: ScreenUtil().setSp(20)
                  ),
                ),
                Text(
                  'Kabupaten Tulungagung'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: ScreenUtil().setSp(12)
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}