import 'dart:math';

import 'package:course_snap_gl/pojo/UserInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/manager.dart';
import '../pojo/ManagerInfo.dart';
import '../stores/ManagerController.dart';
import '../stores/TokenManager.dart';

class MineView extends StatefulWidget {
  const MineView({super.key});

  @override
  State<MineView> createState() => _MineViewState();
}

class _MineViewState extends State<MineView> {
  final ManagerController _managerController = Get.find();
  int _price = 0;
  List<UserInfo> users = [];
  bool isLoading = false;
  Future<void> _getUsers() async {
    isLoading = true;
    _price = 0;
    try {
      users = await getUserPaidAPI();
      List.generate(users.length, (int index) {
        _price += users[index].price;
      });
    } catch (e) {
      print(e);
    }finally {
      isLoading = false;
      setState(() {});
    }
  }

  void refreshData() async {
    _getUsers();
  }

  Widget _buildHeader() {
    return Container(
     padding: const EdgeInsets.only(left: 20, right: 40, top: 80, bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              return GestureDetector(
                onTap: () {
                  if (_managerController.manager.value.name.isEmpty) {
                    Navigator.pushNamed(context, "/login");
                  }
                },
                child: Text(
                  _managerController.manager.value.name.isNotEmpty
                      ? _managerController.manager.value.name
                      : '未登录',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                )
              );
            })
          ),
          Expanded(
            child: Obx(() {
              if (_managerController.manager.value.name.isEmpty) {
                return const Text('');
              } else {
                return GestureDetector(
                  onTap: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                          title: Text('提示'),
                          content: Text('确定要退出登录吗？'),
                          actions: [
                            TextButton(
                                onPressed: () {Navigator.pop(context);},
                                child: Text("取消")
                            ),
                            TextButton(
                                onPressed: () async{
                                  await tokenManager.deleteToken();
                                  _managerController.updateManagerInfo(ManagerInfo.fromJson({}));
                                  Navigator.pop(context);
                                },
                                child: Text("确认", style: TextStyle(color: Colors.grey))
                            )
                          ]
                      );
                    });
                  },
                  child: const Text('退出登录', textAlign: TextAlign.end),
                );
              }
            })
          )

        ]
      )
    );
   }
   Widget _buildDivider() {
     return Container(
       padding: const EdgeInsets.only(left: 20, right: 20),
       child: const Divider(
         height: 1,
         thickness: 1,
         color: Colors.grey,
       ),
     );
   }

   Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (users.isEmpty) {
      return const Center(
        child: Text('暂无数据'),
      );
    }
    return Expanded(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text("姓名：${users[index].name}"),
            subtitle: Text("学号：${users[index].account.toString()}"),
            trailing: Text(users[index].price.toString()),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(height: 2, color: Colors.amber);
        },
        itemCount: users.length,
      )
    );
   }

   @override
   void initState() {
     super.initState();
     refreshData();
   }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        children: [
          _buildHeader(),
          // 创建分割线
          _buildDivider(),
          Text('总金额：${_price}', style: const TextStyle(fontSize: 20)),
          _buildDivider(),
          _buildBody(),
        ]
      ),
    );
  }
}
