import 'package:course_snap_gl/pages/DispatchView.dart';
import 'package:course_snap_gl/pages/ErrorView.dart';
import 'package:course_snap_gl/pages/MineView.dart';
import 'package:course_snap_gl/pages/OrderView.dart';
import 'package:course_snap_gl/pojo/ManagerInfo.dart';
import 'package:course_snap_gl/stores/TokenManager.dart';
import 'package:course_snap_gl/stores/ManagerController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/manager.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ManagerController _managerController = Get.put(ManagerController());
  int _selectedIndex = 0;
  // List<Map<String, String>> _tabList = [];
  List<Map<String, String>> _createTabList() {
    List<Map<String, String>> _tabList = [];
    if (_managerController.manager.value.identity == 1) {
      _tabList.addAll([
        {
          "text": "订单",
          "icon": "lib/images/order.png",
          "active_icon": "lib/images/order_active.png"
        },
        {
          "text": "派单",
          "icon": "lib/images/dispatch.png",
          "active_icon": "lib/images/dispatch_active.png"
        },
        {
          "text": "我的",
          "icon": "lib/images/mine.png",
          "active_icon": "lib/images/mine_active.png"
        }
      ]);
    } else if (_managerController.manager.value.identity == 2) {
      _tabList.addAll([
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
      ]);
    } else {
      _tabList.addAll([
        {
          "text": "我的",
          "icon": "lib/images/mine.png",
          "active_icon": "lib/images/mine_active.png"
        },
        {
          "text": "请联系管理员",
          "icon": "lib/images/error.png",
          "active_icon": "lib/images/error_active.png"
        }
      ]);
    }
    return _tabList;
  }
  List<BottomNavigationBarItem> _getTabBarWidget() {
    List<Map<String, String>> tabList = _createTabList();
    return List.generate(tabList.length, (int index) {
      return BottomNavigationBarItem(
        icon: Image.asset(tabList[index]["icon"]!),
        activeIcon: Image.asset(tabList[index]["active_icon"]!),
        label: tabList[index]["text"]
      );
    });
  }
  List<Widget> _getChildren() {
    if (_managerController.manager.value.identity == 1) {
      return [OrderView(), DispatchView(), MineView()];
    } else if (_managerController.manager.value.identity == 2) {
      return [OrderView(), MineView()];
    } else {
      return [MineView(), ErrorView()];
    }
  }
  // 异步初始化用户方法：包含 初始化→获取信息→更新数据→登录判断 全流程
  void _initUser() async {
    // 步骤1：初始化token
    tokenManager.init();
    try {
      ManagerInfo managerInfo = await getManagerInfoAPI();
      _managerController.updateManagerInfo(managerInfo);
    } catch (e) {
      print("获取用户信息失败：$e");
    }
    if (_managerController.manager.value.account <= 0) {
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
    _initUser();
    // 监听用户信息的响应式变化，变化时调用setState刷新页面
    ever(_managerController.manager, (ManagerInfo newManagerInfo) {
      if (mounted) {
        setState(() {
          // 刷新状态，触发build重新执行，基于最新用户信息生成布局
          _selectedIndex = 0; // 重置选中索引，避免索引越界
        });
      }
    });
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
