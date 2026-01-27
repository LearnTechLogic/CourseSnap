import 'package:course_snap_yh/pages/ContactView.dart';
import 'package:course_snap_yh/pages/HomeView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MineView.dart';
import 'WaitView.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Map<String, String>> _tabList = [
    {
      "text": "首页",
      "icon": "lib/images/home.png",
      "active_icon": "lib/images/home_active.png"
    },
    {
      "text": "等待",
      "icon": "lib/images/wait.png",
      "active_icon": "lib/images/wait_active.png"
    },
    {
      "text": "我的",
      "icon": "lib/images/mine.png",
      "active_icon": "lib/images/mine_active.png"
    },
    {
      "text": "联系",
      "icon": "lib/images/contact.png",
      "active_icon": "lib/images/contact_active.png"
    }
  ];

  List<BottomNavigationBarItem> _getTabBarWidget() {
    return List.generate(_tabList.length, (int index) {
        return BottomNavigationBarItem(
          icon: Image.asset(_tabList[index]["icon"]!),
          activeIcon: Image.asset(_tabList[index]["active_icon"]!),
          label: _tabList[index]["text"],
        );
      }
    );
  }

  List<Widget> _getChildren() {
    return [HomeView(), WaitView(), MineView(), ContactView()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: _getChildren(),
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        // showUnselectedLabels: true,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        currentIndex: _selectedIndex,
        items: _getTabBarWidget(),
      ),
    );
  }
}
