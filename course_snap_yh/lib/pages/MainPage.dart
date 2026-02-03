import 'package:course_snap_yh/pages/ContactView.dart';
import 'package:course_snap_yh/pages/HomeView.dart';
import 'package:course_snap_yh/pojo/UserInfo.dart';
import 'package:course_snap_yh/stores/TokenManager.dart';
import 'package:course_snap_yh/stores/UserController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/index.dart';
import 'MineView.dart';
import 'WaitView.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final UserController _userController = Get.put(UserController());
  void refreshData() async{
    tokenManager.init();
    try {
      UserInfo userInfo = await userInfoAPI();
      _userController.updateUserInfo(userInfo);
    } catch (e) {
      print("获取用户信息失败：$e");
    }
    if (_userController.user.value.account <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 加mounted判断：防止页面已销毁时执行跳转，触发框架警告
        if (mounted) {
          Navigator.pushNamed(context, "/login");
        }
      });
    }
    setState(() {});
  }

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
      "text": "联系",
      "icon": "lib/images/contact.png",
      "active_icon": "lib/images/contact_active.png"
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
          label: _tabList[index]["text"],
        );
      }
    );
  }

  List<Widget> _getChildren() {
    return [HomeView(), WaitView(), ContactView(), MineView()];
  }
  @override
  void initState() {
    super.initState();
    refreshData();
    ever(_userController.user, (UserInfo user) {
      if (mounted) {
        setState(() {});
      }
    });
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
