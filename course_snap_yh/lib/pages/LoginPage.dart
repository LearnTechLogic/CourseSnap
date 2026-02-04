import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/index.dart';
import '../utils/LoadingDialog.dart';
import '../stores/TokenManager.dart';
import '../stores/UserController.dart';
import '../utils/ToastUtils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isChecked = false;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserController _userController = Get.find();
  Widget _buildLoginForm() {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入账号';
            }
            if (!RegExp(r"^[0-9]{8}$").hasMatch(value)){
              return '学号格式错误';
            }
            return null;
          },
          controller: _accountController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 20),
              hintText: "请输入账号",
              fillColor: Colors.grey[200],
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(25)
              )
          )
        ),
        SizedBox(height: 20),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '请输入密码';
            }
            return null;
          },
          controller: _passwordController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 20),
              hintText: "请输入密码",
              fillColor: Colors.grey[200],
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(25)
              )
          )
        )
      ]
    );
  }
  Widget _buildCheckBox() {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          activeColor: Colors.black,
          checkColor: Colors.white,
          onChanged: (bool? value) {
            _isChecked = value ?? false;
            setState(() {});
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          side: BorderSide(color: Colors.grey, width: 2),
        ),
        Text.rich(
            TextSpan(
                children: [
                  TextSpan(text: "查看并同意"),
                  TextSpan(text: "《用户协议》", style: TextStyle(color: Colors.blue)
                  ),
                ]
            )
        )
      ],
    );
  }
  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_isChecked) {
                    _login();
                  } else {
                    ToastUtils.showToast(context, "请先阅读并同意用户协议");
                  }
                }
              },
              child: Text("登录", style: TextStyle(fontSize: 20, color: Colors.white))
            )
          ),
          SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/register");
                },
                child: Text("注册", style: TextStyle(fontSize: 20, color: Colors.white))
            ),
          )
        ],
      ),
    );
  }
  void _login() async{
    try {
      LoadingDialog.show(context, message: "登录中...");
      final result = await userLoginAPI({
        "account": _accountController.text,
        "password": _passwordController.text
      });
      _userController.updateUserInfo(result);
      tokenManager.setToken(result.token);
      LoadingDialog.hide(context);
      ToastUtils.showToast(context, "登录成功");
      Navigator.pop(context);
    }catch(e) {
      LoadingDialog.hide(context);
      String errorMsg = "登录失败，请重试";
      // 分类型处理错误
      if (e is DioException) {
        errorMsg = e.message ?? errorMsg;
      } else if (e is TypeError) {
        errorMsg = "数据解析错误：${e.toString()}";
      } else {
        errorMsg = "未知错误：${e.toString()}";
      }
      ToastUtils.showToast(context, errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('欢迎使用云课速抢', style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(30),
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildLoginForm(),
              SizedBox(height: 20),
              _buildCheckBox(),
              SizedBox(height: 20),
              _buildButton(),
            ]
          )
        )
      )

    );
  }
}
