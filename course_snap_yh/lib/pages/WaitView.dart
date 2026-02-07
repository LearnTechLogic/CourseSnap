import 'package:course_snap_yh/pojo/UserInfo.dart';
import 'package:course_snap_yh/stores/UserController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/index.dart';

class WaitView extends StatefulWidget {
  const WaitView({super.key});

  @override
  State<WaitView> createState() => _WaitViewState();
}

class _WaitViewState extends State<WaitView> {
  final UserController _userController = Get.find();
  List<UserInfo> waitList = [];
  Future<void> getWaitList() async {
    waitList = await userWaitListAPI();
  }

  void refreshData() {
    setState(() {
      getWaitList();
    });
  }

  Widget _buildRefreshButton() {
    return ElevatedButton(
      onPressed: refreshData,
      child: const Text("刷新"),
    );
  }

  Widget _buildWaitList() {
    if (waitList.isEmpty) {
      return const Text("没有等待中的用户");
    }
    return Expanded(
      child: ListView.separated(
        itemCount: waitList.length,
        itemBuilder: (BuildContext context, int index) {
          return Obx(() {
            return Container(
              padding: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: _userController.user.value.account == waitList[index].account
                  ? Colors.green[400]
                  : Colors.white
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    width: 50.0,
                    height: 50.0,
                    child: Text("${index + 1}", style: const TextStyle(fontSize: 24)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    width: 2,
                    height: 36,
                    color: Colors.blue,
                  ),
                  Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text("学号: ${waitList[index].account}", style: const TextStyle(fontSize: 20)),
                      )
                  ),
                  waitList[index].state == "已支付" ?
                  Text("已完成", style: const TextStyle(fontSize: 20, color: Colors.green))
                      : Text(waitList[index].state)
                ],
              )
            );
          });
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1.0,
            thickness: 1.0,
            color: Colors.grey,
          );
        }
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildRefreshButton(),
          const SizedBox(height: 16.0),
          _buildWaitList()
        ],
      )
    );
  }
}
