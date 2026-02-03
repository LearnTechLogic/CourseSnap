import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/index.dart';
import '../utils/LoadingDialog.dart';
import '../utils/ToastUtils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  Widget _buildRegisterForm() {
    return Column(
      children: [
        Row(
          children: [
            Text('账号：', style: TextStyle(fontSize: 20)),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入账号';
                  }
                  if (!RegExp(r"^[0-9]{8}$").hasMatch(value)) {
                    return '请输入8位数字账号';
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
                      borderRadius: BorderRadius.circular(25),
                    )
                )
              )
            )
          ]
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Text('密码：', style: TextStyle(fontSize: 20)),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
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
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25),
                  ),
                )
              )
            )
          ]
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
  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _register();
        }
      },
      child: Text('注册', style: TextStyle(fontSize: 20)),
    );
  }
  void _register() async {
    try {
      LoadingDialog.show(context, message: "注册中...");
      await userRegisterAPI({
        "account": _accountController.text,
        "password": _passwordController.text,
      });
      LoadingDialog.hide(context);
      ToastUtils.showToast(context, "注册成功");
      Navigator.pop(context);
    }catch(e) {
      LoadingDialog.hide(context);
      ToastUtils.showToast(context, (e as DioException).message);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册账户'),
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
              _buildRegisterForm(),
              SizedBox(height: 20),
              _buildCheckBox(),
              SizedBox(height: 20),
              _buildRegisterButton()
            ]
          )
        )
      )
    );
  }
}
