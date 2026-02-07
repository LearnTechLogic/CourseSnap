import 'dart:math';

import 'package:course_snap_yh/api/index.dart';
import 'package:course_snap_yh/stores/UserController.dart';
import 'package:course_snap_yh/utils/ToastUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  Widget _buildRefresh() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
      onPressed: refreshData,
      child: Text("刷新")
    );
  }

  Widget _buildHeader() {
    return Container(
        padding: const EdgeInsets.only(left: 20, right: 40, top: 20, bottom: 20),
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
          _buildTextField("需求", _requirementController),
          _buildState()
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
                final price = int.tryParse(value);
                if (price! < 20) {
                  return "价格最低为20";
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

  Widget _buildButton() {
    return Obx(() {
      return Row(
        children: [
          _userController.user.value.state == "拒绝" || _userController.user.value.state == "申请" || _userController.user.value.state == "仅注册" || _userController.user.value.state == "等待" || _userController.user.value.state == "进行中"?
            Expanded(
                child: GestureDetector(
                    onTap: ()  {
                      if (_formKey.currentState!.validate()) {
                        _update();
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child: Text(
                          "修改个人信息",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        )
                    )
                )
            )
          : Text(""),
          const SizedBox(width: 20),
          _userController.user.value.state == "拒绝" ||  _userController.user.value.state == "仅注册"?
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _apply();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(25)
                  ),
                  child: Text(
                    "提交抢课申请",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  )
                )
              )
            )
          : Text("")
        ]
      );

    });
  }

  Widget _buildState() {
    if (_userController.user.value.state == "已支付") {
      return Row(
        children: [
          Expanded(
            child: Image.network(
              _userController.user.value.image1,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
          Expanded(
            child: Image.network(
              _userController.user.value.image2,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            )
          )
        ]
      );
    }else if (_userController.user.value.state == "拒绝") {
      return Text("提供的信息存在错误，请联系管理员");
    }else if (_userController.user.value.state == "进行中") {
      return Row(
        children: [
          Expanded(
            child: Text(
              "正在抢课中请稍等",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center
            )
          )
        ]
      );
    }else if (_userController.user.value.state == "未支付") {
      return Row(
        children: [
          Expanded(
            child: Text(
              "抢课已完成，请联系管理员支付抢课费用",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center
            )
          )
        ]
      );
    }else if (_userController.user.value.state == "申请") {
      return Row(
        children: [
          Expanded(
            child: Text(
              "申请已提交请耐心等待管理员审核",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center
            )
          )
        ]
      );
    }else if (_userController.user.value.state == "仅注册") {
      return Row(
        children: [
          Expanded(
            child: Text(
              "仅注册成功，请修改信息，并提交抢课申请",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center
            )
          )
        ]
      );
    }else {
      return Row(
        children: [
          Expanded(
            child: Text(
              "抢课正在进行中请稍等",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center
            )
          )
        ]
      );
    }
  }

  void _update() async {
    final price = int.tryParse(_priceController.text);
    Map<String, dynamic> data = {
      "account": _userController.user.value.account,
      "name": _nameController.text,
      "password": _passwordController.text,
      "price": price,
      "qq": _qqController.text,
      "requirement": _requirementController.text
    };
    _userInfo = await userUpdateAPI(data);
    _userController.updateUserInfo(_userInfo);
    refreshData();
  }

  void _apply() async {
    final price = int.tryParse(_priceController.text);
    Map<String, dynamic> data = {
      "account": _userController.user.value.account,
      "name": _nameController.text,
      "password": _passwordController.text,
      "price": price,
      "qq": _qqController.text,
      "requirement": _requirementController.text
    };
    _userInfo = await userApplyAPI(data);
    _userController.updateUserInfo(_userInfo);
    refreshData();
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
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
          children: [
            _buildRefresh(),
            _buildHeader(),
            _buildDivider(),
            _buildBody(),
            SizedBox(height: 20),
            _buildButton(),
          ]
          )
        )
      ]
    );
  }
}
