import 'package:flutter/cupertino.dart';

class WaitView extends StatefulWidget {
  const WaitView({super.key});

  @override
  State<WaitView> createState() => _WaitViewState();
}

class _WaitViewState extends State<WaitView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("等待"),
    );
  }
}
