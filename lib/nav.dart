import 'package:flutter/material.dart';
import 'package:teamwork/home.dart';
import 'package:teamwork/profile.dart';
import 'package:teamwork/study.dart';
import 'package:teamwork/study_func/addquiz.dart';

import 'color/color.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    StudyPage(),
    ProfilePage(),

  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      // If the selected page is the same as the tapped page, do nothing.
      return;
    }

    _pageController.jumpToPage(index);

    setState(() {
      _selectedIndex = index;
    });
  }
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _widgetOptions,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2_outlined),
            label: 'Study',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),

        ],
        currentIndex: _selectedIndex,
        backgroundColor: CustomColor.primary,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}