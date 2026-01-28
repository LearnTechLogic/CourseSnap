import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          return '请输入账号';
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
      height: 50,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_isChecked) {

                  } else {

                  }
                }
              },
              child: Text("登录"))
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              child: Text("注册")
            ),
          )
        ],
      ),
    );
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
