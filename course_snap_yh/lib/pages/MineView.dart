import 'package:course_snap_yh/api/index.dart';
import 'package:course_snap_yh/stores/UserController.dart';
import 'package:course_snap_yh/utils/ToastUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pojo/UserInfo.dart';
import '../stores/TokenManager.dart';

class MineView extends StatefulWidget {
  const MineView({super.key});

  @override
  State<MineView> createState() => _MineViewState();
}

class _MineViewState extends State<MineView> {
  final UserController _userController = Get.find();
  UserInfo _userInfo = UserInfo.fromJson({});
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  late TextEditingController _qqController;
  late TextEditingController _priceController;
  late TextEditingController _requirementController;

  void refreshData() async {
    try {
      _userInfo = await userInfoAPI();
      _userController.updateUserInfo(_userInfo);
      if (mounted) { // 防止页面销毁后更新状态
        _nameController.text = _userInfo.name ?? '';
        _qqController.text = _userInfo.qq.toString() ?? '';
        _priceController.text = _userInfo.price.toString() ?? '';
        _requirementController.text = _userInfo.requirement ?? '';
        _passwordController.text = _userInfo.password ?? '';
      }
    } catch(e) {
      ToastUtils.showToast(context, "初始化个人数据失败");
    }
    setState(() {});
  }

  final GlobalKey _formKey = GlobalKey<FormState>();

  Widget _buildHeader() {
    return Container(
        padding: const EdgeInsets.only(left: 20, right: 40, top: 80, bottom: 20),
        child: Row(
            children: [
              Expanded(
                  child: Obx(() {
                    return GestureDetector(
                        onTap: () {
                          if (_userController.user.value.password.isEmpty) {
                            Navigator.pushNamed(context, "/login");
                          }
                        },
                        child: Text(
                          _userController.user.value.password.isNotEmpty
                              ? "学号：${_userController.user.value.account}"
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
                    if (_userController.user.value.password.isEmpty) {
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
                                        _userController.updateUserInfo(UserInfo.fromJson({}));
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
      // padding: const EdgeInsets.only(left: 20, right: 20),
      padding: const EdgeInsets.all(20),
      child: const Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 20,
        children: [
          Text("详细信息", style: TextStyle(fontSize: 20),),
          _buildTextField("姓名", _nameController),
          _buildTextField("密码", _passwordController),
          _buildTextField("价格", _priceController),
          _buildTextField("QQ", _qqController),
        ]
      )
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
              "${label}：",
              style: const TextStyle(fontSize: 16)
          )
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextFormField(
            validator: (value) {
              if (label == "QQ") {
                if (value == null || value.isEmpty) {
                  return "请输入QQ";
                }
                if (!RegExp(r'^[1-9]\d{4,10}$').hasMatch(value)) {
                  return "请输入正确的QQ";
                }
                return null;
              }
              if (label == "价格") {
                if (value == null || value.isEmpty) {
                  return "请输入价格";
                }
                if (!RegExp(r'^[1-9]\d*$').hasMatch(value)) {
                  return "请输入正确的价格";
                }
              }
              if (value == null || value.isEmpty) {
                return "请输入$label";
              }
              return null;
            },
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 20),
              hintText: "请输入$label",
              fillColor: Colors.grey[200],
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(25)
              )
            )
          )
        )
      ]
    );

  }

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _qqController = TextEditingController();
    _priceController = TextEditingController();
    _requirementController = TextEditingController();
    refreshData();
  }
  @override
  void dispose() {
    _passwordController.dispose();
    _nameController.dispose();
    _qqController.dispose();
    _priceController.dispose();
    _requirementController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(         
        children: [
          _buildHeader(),
          _buildDivider(),
          _buildBody()

        ]
      )
    );
  }
}
