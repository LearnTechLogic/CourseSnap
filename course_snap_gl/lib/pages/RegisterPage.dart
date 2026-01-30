import 'package:course_snap_gl/api/register.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/LoadingDialog.dart';
import '../utils/ToastUtils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _accountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  Widget _buildHeader() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "请输入以下信息进注册",
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
    return Row(
      children: [
        SizedBox(width: 30),
        Text(
          "账号：",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "请输入账号";
              }
              if (!RegExp(r"^[0-9]{8}$").hasMatch(value)) {
                return "账号格式错误";
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
    );
   }
  Widget _buildPasswordTextField() {
    return Row(
      children: [
        SizedBox(width: 30),
        Text(
          "密码：",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "请输入密码";
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
                borderRadius: BorderRadius.circular(25),
              )
            )
          )
        )
      ]
    );
  }
  Widget _buildNameTextField() {
    return Row(
      children: [
        SizedBox(width: 30),
        Text(
          "姓名：",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "请输入姓名";
              }
              return null;
            },
            controller: _nameController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 20),
              hintText: "请输入姓名",
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
    );
  }
  Widget _buildButton() {
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
          )
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _register();
          }
        },
        child: Text("注册", style: TextStyle(fontSize: 20, color: Colors.white))
      )
    );
  }

  void _register() async{
    try {
      LoadingDialog.show(context, message: "注册中...");
      await managerRegisterAPI({
        "account": _accountController.text,
        "password": _passwordController.text,
        "name": _nameController.text
      });
      LoadingDialog.hide(context);
      ToastUtils.showToast(context, "注册成功");
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
        backgroundColor: Colors.white
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
              _buildNameTextField(),
              SizedBox(height: 40),
              _buildButton(),
            ]
          )
        )
      )
    );
  }
}
