import 'package:course_snap_gl/pages/DispatchView.dart';
import 'package:course_snap_gl/pages/MineView.dart';
import 'package:course_snap_gl/pages/OrderView.dart';
import 'package:course_snap_gl/pojo/UserInfo.dart';
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
  // 异步初始化用户方法：包含 初始化→获取信息→更新数据→登录判断 全流程
  void _initUser() async {
    // 步骤1：初始化token
    tokenManager.init();
    try {
      // 步骤2：等待获取用户信息API完成，更新用户数据（处理API异常）
      UserInfo userInfo = await getUserInfoAPI();
      _userController.updateUserInfo(userInfo);
    } catch (e) {
      // 捕获API请求异常（如网络错误、token过期），避免程序崩溃
      print("获取用户信息失败：$e");
    }
    // 步骤3：所有异步操作完成后，执行登录判断（此时token/用户信息已更新）
    if (tokenManager.getToken() == null || tokenManager.getToken().isEmpty) {
      print("token为空，跳转到登录页");
      // 确保在Flutter页面渲染完成后执行路由跳转
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 加mounted判断：防止页面已销毁时执行跳转，触发框架警告
        if (mounted) {
          Navigator.pushNamed(context, "/login");
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 步骤4：仅调用异步方法，无需后续判断（判断已移入方法内部）
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
