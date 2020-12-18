import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/cubit/auth/auth_cubit.dart';
import 'package:perbasitlg/ui/pages/splash_page.dart';
import 'package:perbasitlg/utils/constant_helper.dart';

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = AuthCubit();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => authCubit),
      ],
      child: MaterialApp(
        title: App().appTitle,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: ConstantHelper.MAIN_FONT_NAME
        ),
        home: SplashPage(),
      )
    );
  }
}
