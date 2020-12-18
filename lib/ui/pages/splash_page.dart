import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/ui/pages/home/home_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // Future.delayed(Duration(seconds: 3)).then((_) async {
    //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
    //     builder: (context) => HomePage()
    //   ), (Route<dynamic> route) => false);
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 720), allowFontScaling: true);

    return Scaffold(
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
    );
  }
}
