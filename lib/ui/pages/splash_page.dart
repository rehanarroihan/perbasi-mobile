import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/cubit/auth/auth_cubit.dart';
import 'package:perbasitlg/cubit/team/team_cubit.dart';
import 'package:perbasitlg/ui/pages/auth/login_page.dart';
import 'package:perbasitlg/ui/pages/home/navigator_page.dart';
import 'package:perbasitlg/utils/constant_helper.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AuthCubit _authCubit;
  TeamCubit _teamCubit;

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _teamCubit = BlocProvider.of<TeamCubit>(context);

    Future.delayed(Duration(milliseconds: 1500)).then((_) async {
      bool isLoggedIn = App().prefs.getBool(ConstantHelper.PREFS_IS_USER_LOGGED_IN) ?? false;
      if (isLoggedIn) {
        // Getting user data
        _authCubit.getUserDetail();
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => LoginPage()
        ), (Route<dynamic> route) => false);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 720), allowFontScaling: true);

    return BlocListener(
      cubit: _authCubit,
      listener: (context, state) {
        if (state is GetUserDataSuccessfulState) {
          _teamCubit.getMyTeamPage();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => NavigatorPage()
          ), (Route<dynamic> route) => false);
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(720),
          child: Stack(
            children: [
              Image(
                width: ScreenUtil().setWidth(360),
                height: ScreenUtil().setHeight(720),
                fit: BoxFit.cover,
                image: AssetImage('assets/images/splash-bg.png'),
              ),
              Stack(
                children: [
                  Center(
                    child: Container(
                      transform: Matrix4.translationValues(0.0, 14, 0.0),
                      width: ScreenUtil().setWidth(230),
                      height: ScreenUtil().setHeight(230),
                      child: Image(
                        image: AssetImage('assets/images/splash-radial.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome to'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setSp(14)
                          ),
                        ),
                        Text(
                          'Perbasi'.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(20)
                          ),
                        ),
                        Text(
                          'Kabupaten Tulungagung'.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(12)
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
