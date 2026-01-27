import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/LoginPage.dart';
import '../pages/MainPage.dart';

Widget getRootWidget() {
  return MaterialApp(
    initialRoute: '/',
    routes: getRootRoutes()
  );
}
Map<String, Widget Function(BuildContext)> getRootRoutes() {
  return {
    '/': (context) => MainPage(),
    '/login': (context) => LoginPage()
  };
}