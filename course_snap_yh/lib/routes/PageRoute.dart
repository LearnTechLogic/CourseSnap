import 'package:course_snap_yh/pages/LoginPage.dart';
import 'package:course_snap_yh/pages/MainPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getRootWidget() {
  return MaterialApp(
    initialRoute: '/',// 默认路由
    routes: getRootRoutes(),
  );
}

Map<String, Widget Function(BuildContext)> getRootRoutes() {
  return {
    "/": (context) => MainPage(),
    "login": (context) => LoginPage(),
  };
}