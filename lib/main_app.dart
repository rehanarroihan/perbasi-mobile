import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/cubit/auth/auth_cubit.dart';
import 'package:perbasitlg/cubit/home/home_cubit.dart';
import 'package:perbasitlg/cubit/profile/profile_cubit.dart';
import 'package:perbasitlg/cubit/team/team_cubit.dart';
import 'package:perbasitlg/ui/pages/splash_page.dart';
import 'package:perbasitlg/utils/constant_helper.dart';

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = AuthCubit();
    HomeCubit homeCubit = HomeCubit();
    TeamCubit teamCubit = TeamCubit();
    ProfileCubit profileCubit = ProfileCubit();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => authCubit),
        BlocProvider<HomeCubit>(create: (context) => homeCubit),
        BlocProvider<TeamCubit>(create: (context) => teamCubit),
        BlocProvider<ProfileCubit>(create: (context) => profileCubit),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          title: App().appTitle,
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: ConstantHelper.MAIN_FONT_NAME
          ),
          home: SplashPage(),
        ),
      )
    );
  }
}
