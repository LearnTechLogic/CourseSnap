import 'package:course_snap_gl/api/user.dart';
import 'package:course_snap_gl/pojo/UserInfo.dart';
import 'package:course_snap_gl/stores/ManagerController.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/LoadingDialog.dart';
import '../utils/ToastUtils.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final ManagerController _managerController = Get.find();
  List<UserInfo> _userList = [];
  bool _isLoading = false;
  Future<void> _getUserList() async {
    _isLoading = true;
    _userList = await getUserInfoAPI();
    _isLoading = false;
    setState(() {});
    List.generate(_userList.length, (int  index) {
    });
  }
  final List<String> _states = ['申请', '等待', '进行中', '完成', '未支付', '已支付', '拒绝'];
  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return _states
        .map((String option) => DropdownMenuItem<String>(
          value: option, // 选项的实际值（如 "正常"）
          child: Text(option), // 选项显示的文字
        ))
        .toList();
  }
  void _updatateUser(UserInfo userInfo) async {
    try {
      // 更新数据库
      LoadingDialog.show(context, message: "修改中...");
      await updateUserInfoAPI({
        "account": userInfo.account,
        "name": userInfo.name,
        "password": userInfo.password,
        "state": userInfo.state,
        "price": userInfo.price,
        "qq": userInfo.qq,
        "requirement":userInfo.requirement,
      });
      LoadingDialog.hide(context);
      ToastUtils.showToast(context, "修改成功");
    } catch (e) {
      LoadingDialog.hide(context);
      ToastUtils.showToast(context, (e as DioException).message);
      }
  }

  Future<void> _getUserDetail(BuildContext context,int account) async{
    UserInfo userInfo = await getUserInfoByIdAPI(account);
    final nameController = TextEditingController(text: userInfo.name);
    final passwordController = TextEditingController(text: userInfo.password);
    final priceController = TextEditingController(text: userInfo.price.toString());
    final requirementController = TextEditingController(text: userInfo.requirement);
    final qqController = TextEditingController(text: userInfo.qq.toString());
    final stateController = TextEditingController(text: userInfo.state);
    // 弹出弹窗并等待用户操作结果
    final updatedUser = await showDialog<UserInfo>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("用户详情"),
          // 内容：学号（不可改）+ 姓名/状态（可改）
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 学号：仅展示，不可编辑
                Text("学号：${userInfo.account}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                // 姓名输入框
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '姓名',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                // 密码输入框
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: '密码',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                // 价格输入框
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: '价格',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: requirementController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: '需求',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: qqController,
                  decoration: const InputDecoration(
                    labelText: 'QQ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                // 状态下拉列表
                DropdownButtonFormField<String>(
                  value: userInfo.state,
                  hint: const Text('请选择状态'),
                  decoration: const InputDecoration(
                    labelText: '状态',
                    border: OutlineInputBorder(),
                  ),
                  items: _buildDropdownItems(),
                  onChanged: (String? newValue) {
                    stateController.text = newValue!;
                  })
              ],
            ),
          ),
          actions: [
            // 取消按钮
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text("取消"),
            ),
            // 确认按钮：返回修改后的用户信息
            TextButton(
              onPressed: () {
                // 直接修改原对象值
                userInfo.name = nameController.text.trim();
                userInfo.password = passwordController.text.trim();
                userInfo.state = stateController.text.trim();
                if (_managerController.manager.value.identity == 1){
                  userInfo.price = int.parse(priceController.text.trim());
                }
                Navigator.of(context).pop(userInfo);
              },
              child: const Text("确认修改"),
            ),
          ],
        );
      },
    );

    // 如果用户确认修改，更新列表并刷新UI
    if (updatedUser != null) {
      setState(() {
        // 找到列表中对应的用户并替换
        final index = _userList.indexWhere((u) => u.account == updatedUser.account);
        if (index != -1) {
          _updatateUser(updatedUser);
          _userList[index] = updatedUser;
        }
      });
      // 提示修改成功
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${updatedUser.name} 的信息已更新")),
        );
      }
    }
  }



  Widget _buildListItem() {
    // 处理空数据场景
    if (_userList.isEmpty && !_isLoading) {
      return const Center(child: Text("暂无用户数据"));
    }
    // Expanded让ListView占满剩余高度，解决Column嵌套问题
    return Expanded(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.grey[100], // 浅灰色更美观，避免深灰太刺眼
            child: ListTile(
                selected: true,
                title: Text("学号：${_userList[index].account}"),
                subtitle: Text("姓名：${_userList[index].name}"),
                trailing: Text("状态：${_userList[index].state}"),
                onTap: () {
                  _getUserDetail(context, _userList[index].account);
                }
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(height: 2, width: double.infinity, color: Colors.amber);
        },
        itemCount: _userList.length,
      )
      // child:
    );
  }

  @override
  void initState() {
    super.initState();
    _getUserList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("云课速抢订单"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
              _buildListItem()
          ],
        )
      )
    );
  }
}
