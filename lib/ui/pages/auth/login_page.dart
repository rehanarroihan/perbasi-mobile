import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/auth/auth_cubit.dart';
import 'package:perbasitlg/models/request/login_request.dart';
import 'package:perbasitlg/ui/pages/auth/register_page.dart';
import 'package:perbasitlg/ui/pages/splash_page.dart';
import 'package:perbasitlg/ui/widgets/modules/app_alert_dialog.dart';
import 'package:perbasitlg/ui/widgets/base/box_input.dart';
import 'package:perbasitlg/ui/widgets/base/button.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/ui/widgets/modules/loading_dialog.dart';
import 'package:perbasitlg/utils/app_color.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';
import 'package:perbasitlg/utils/show_flutter_toast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthCubit _authCubit;

  TextEditingController _emailInput = TextEditingController();
  TextEditingController _passwordInput = TextEditingController();

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _authCubit,
      listener: (context, state) {
        if (state is LoginInitialState) {
          LoadingDialog(
            title: 'Loading',
            description: 'Silahkan tunggu...'
          ).show(context);
        } else if (state is LoginSuccessfulState) {
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => SplashPage()
          ));
          showFlutterToast('Login Berhasil');
        } else if (state is LoginFailedState) {
          Navigator.pop(context);
          AppAlertDialog(
            title: 'Login Gagal',
            description: 'Email atau password yang anda masukkan salah',
            positiveButtonText: 'Ok',
            positiveButtonOnTap: () => Navigator.pop(context)
          ).show(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.pageBackgroundColor,
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
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
                  controller: _emailInput,
                  label: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                ),

                Space(height: 24),
                BoxInput(
                  controller: _passwordInput,
                  label: 'Password',
                  passwordField: true,
                ),
                Space(height: 34),
                Container(
                  width: double.infinity,
                  child: Button(
                    onPressed: () {
                      if (!GlobalMethodHelper.isEmpty(_emailInput.text)
                          && !GlobalMethodHelper.isEmpty(_passwordInput.text)) {
                        _authCubit.loginUser(LoginRequest(
                          email: _emailInput.text,
                          password: _passwordInput.text
                        ));
                      }
                    },
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