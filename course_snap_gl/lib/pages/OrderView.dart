import 'package:course_snap_gl/api/user.dart';
import 'package:course_snap_gl/pojo/UserInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  List<UserInfo> _userList = [];
  bool _isLoading = false;
  Future<void> _getUserList() async {
    _isLoading = true;
    _userList = await getUserInfoAPI();
    _isLoading = false;
    setState(() {});
    List.generate(_userList.length, (int  index) {
      print("==============");
      print(_userList[index].name);
    });
  }

  Widget _buildListItem() {
    // 处理空数据场景
    if (_userList.isEmpty && !_isLoading) {
      return const Center(child: Text("暂无用户数据"));
    }
    // Expanded让ListView占满剩余高度，解决Column嵌套问题
    return Expanded(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.grey[100], // 浅灰色更美观，避免深灰太刺眼
            child: ListTile(
              title: Text(_userList[index].name ?? "未知名称"), // 处理name为空的情况
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(height: 2, width: double.infinity, color: Colors.amber);
        },
        itemCount: _userList.length,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getUserList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("云课速抢订单"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            _buildListItem()
          ],
        )
      )
    );
  }
}
