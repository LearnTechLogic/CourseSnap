import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        ]
      ),
    );
  }
}
