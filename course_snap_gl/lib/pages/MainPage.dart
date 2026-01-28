import 'package:course_snap_gl/pages/DispatchView.dart';
import 'package:course_snap_gl/pages/MineView.dart';
import 'package:course_snap_gl/pages/OrderView.dart';
import 'package:course_snap_gl/pojo/user.dart';
import 'package:course_snap_gl/stores/TokenManager.dart';
import 'package:course_snap_gl/stores/UserController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/user.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Map<String, String>> _tabList = [
    {
      "text": "派单",
      "icon": "lib/images/dispatch.png",
      "active_icon": "lib/images/dispatch_active.png"
    },
    {
      "text": "订单",
      "icon": "lib/images/order.png",
      "active_icon": "lib/images/order_active.png"
    },
    {
      "text": "我的",
      "icon": "lib/images/mine.png",
      "active_icon": "lib/images/mine_active.png"
    }
  ];
  List<BottomNavigationBarItem> _getTabBarWidget() {
    return List.generate(_tabList.length, (int index) {
      return BottomNavigationBarItem(
        icon: Image.asset(_tabList[index]["icon"]!),
        activeIcon: Image.asset(_tabList[index]["active_icon"]!),
        label: _tabList[index]["text"]
      );
    });
  }
  List<Widget> _getChildren() {
    return [DispatchView(), OrderView(), MineView()];
  }
  final UserController _userController = Get.put(UserController());
  void _initUser() async {
    await tokenManager.init();
    _userController.updateUserInfo(await getUserInfoAPI());
  }
  @override
  void initState() {
    super.initState();
    _initUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: _getChildren()
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
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
