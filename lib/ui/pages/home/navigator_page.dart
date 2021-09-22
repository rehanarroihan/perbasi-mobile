import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:perbasitlg/cubit/auth/auth_cubit.dart';
import 'package:perbasitlg/cubit/home/home_cubit.dart';
import 'package:perbasitlg/ui/pages/competition/all_competition_schedule_page.dart';
import 'package:perbasitlg/ui/pages/home/home_page.dart';
import 'package:perbasitlg/ui/pages/home/team_page.dart';
import 'package:perbasitlg/ui/pages/profile/profile_page.dart';
import 'package:perbasitlg/utils/constant_helper.dart';

class NavigatorPage extends StatefulWidget {
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  HomeCubit _homeCubit;
  AuthCubit _authCubit;

  List<Widget> _pages;

  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    _authCubit = BlocProvider.of<AuthCubit>(context);

    _pages = _getPages();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showOverlayNotification((context) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: SafeArea(
              child: ListTile(
                leading: SizedBox.fromSize(
                    size: const Size(40, 40),
                    child: ClipOval(
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (AssetImage("assets/logos/logo_main.png")),
                                fit: BoxFit.fill,
                              )),
                        ))),
                title: Platform.isIOS
                    ? Text(message['aps']['alert']['title'])
                    : Text(message['notification']['title']),
                subtitle: Platform.isIOS
                    ? Text(message['aps']['alert']['body'])
                    : Text(message['notification']['body']),
                trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      OverlaySupportEntry.of(context).dismiss();
                    }),
              ),
            ),
          );
        }, duration: Duration(milliseconds: 4000));

        print(message['notification']['title']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) async {
      _homeScreenText = "Push Messaging token: $token";
      print(_homeScreenText);
    });
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _homeScreenText = "Push Messaging token: $newToken";
      print(_homeScreenText);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _homeCubit,
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (_homeCubit.selectedPage != 0) {
              _homeCubit.changeSelectedPage(0);
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            body: _pages[_homeCubit.selectedPage],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    offset: const Offset(0, -3),
                    blurRadius: 20,
                  ),
                ]
              ),
              child: BottomNavigationBar(
                currentIndex: _homeCubit.selectedPage,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                showSelectedLabels: true,
                items: _getMenuItems(),
                onTap: (int index) => _homeCubit.changeSelectedPage(index),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _getPages() {
    List<Widget> pages = [
      HomePage(),
      AllCompetitionSchedulePage(),
      TeamPage(),
      ProfilePage(),
    ];

    String loggedInRole = _authCubit.loggedInUserData.role.name;
    if (loggedInRole == ConstantHelper.ROLE_WASIT) {
      // if the logged in user was referee, then remove 'team' menu
      return [pages[0], pages[1], pages[3]];
    }

    return pages;
  }

  List<BottomNavigationBarItem> _getMenuItems() {
    List<BottomNavigationBarItem> mn = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Beranda',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today_outlined),
        label:'Kompetisi',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people_rounded),
        label: 'Club'
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_pin),
        label: 'Profile'
      )
    ];

    String loggedInRole = _authCubit.loggedInUserData.role.name;
    if (loggedInRole == ConstantHelper.ROLE_WASIT) {
      // if the logged in user was referee, then remove 'team' menu
      return [mn[0], mn[1], mn[3]];
    }

    return mn;
  }
}
