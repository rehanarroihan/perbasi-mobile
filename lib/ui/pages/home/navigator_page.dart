import 'package:flutter/material.dart';
import 'package:perbasitlg/ui/pages/home/home_page.dart';
import 'package:perbasitlg/ui/pages/home/team_page.dart';
import 'package:perbasitlg/ui/pages/profile/profile_page.dart';

class NavigatorPage extends StatefulWidget {
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  List<Widget> _pages = [
    HomePage(),
    Container(),
    Container(),
    TeamPage(),
    ProfilePage(),
  ];

  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
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
          currentIndex: _selectedPage,
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
              label:'Email',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search'
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
          onTap: (int index) {
            print(index);
            setState(() {
              _selectedPage = index;
            });
          },
        ),
      ),
    );
  }
}
