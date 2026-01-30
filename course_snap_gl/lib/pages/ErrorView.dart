import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatefulWidget {
  const ErrorView({super.key});

  @override
  State<ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text("请联系管理员",style: TextStyle(fontSize: 20, color: Colors.red)),
    );
  }
}
