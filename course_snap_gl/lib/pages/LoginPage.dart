import 'package:course_snap_gl/stores/TokenManager.dart';
import 'package:course_snap_gl/stores/UserController.dart';
import 'package:course_snap_gl/utils/LoadingDialog.dart';
import 'package:course_snap_gl/utils/ToastUtils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserController _userController = Get.find();
  TextEditingController _accountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Widget _buildHeader() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "账号密码登录",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
  Widget _buildAccountTextField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入学号';
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
    );
  }
  Widget _buildPasswordTextField() {
    return TextFormField(
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
    );
  }
  bool _isChecked = false;
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

  void _login() async {
    try {
      LoadingDialog.show(context, message: "登录中...");
      final result = await loginAPI({
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
      ToastUtils.showToast(context, (e as DioException).message);
    }
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("云课速抢", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(30),
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildHeader(),
              SizedBox(height: 30),
              _buildAccountTextField(),
              SizedBox(height: 20),
              _buildPasswordTextField(),
              SizedBox(height: 20),
              _buildCheckBox(),
              SizedBox(height: 40),
              _buildButton(),
            ],
          ),
        )

      )
    );
  }
}
