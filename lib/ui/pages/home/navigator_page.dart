import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perbasitlg/cubit/home/home_cubit.dart';
import 'package:perbasitlg/ui/pages/competition/all_competition_schedule_page.dart';
import 'package:perbasitlg/ui/pages/home/home_page.dart';
import 'package:perbasitlg/ui/pages/home/team_page.dart';
import 'package:perbasitlg/ui/pages/profile/profile_page.dart';

class NavigatorPage extends StatefulWidget {
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  HomeCubit _homeCubit;

  List<Widget> _pages = [
    HomePage(),
    AllCompetitionSchedulePage(),
    TeamPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _homeCubit,
      builder: (context, state) {
        return Scaffold(
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
              showUnselectedLabels: false,
              showSelectedLabels: false,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined),
                  label:'Jadwal Kompetisi',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_rounded),
                  label: 'Team'
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_pin),
                  label: 'Yea'
                )
              ],
              onTap: (int index) => _homeCubit.changeSelectedPage(index),
            ),
          ),
        );
      },
    );
  }
}
