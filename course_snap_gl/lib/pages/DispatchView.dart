import 'package:course_snap_gl/api/user.dart';
import 'package:course_snap_gl/pojo/ManagerInfo.dart';
import 'package:course_snap_gl/pojo/UserInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/manager.dart';

class DispatchView extends StatefulWidget {
  const DispatchView({super.key});

  @override
  State<DispatchView> createState() => _DispatchViewState();
}

class _DispatchViewState extends State<DispatchView> {
  List<ManagerInfo> _managerInfoList = [];
  List<UserInfo> _userInfoList = [];
  bool _isLoading = false;
  Future<void> _getManagerInfoList() async {
    _isLoading = true;
    _managerInfoList = await getManagerInfoListAPI();
    _isLoading = false;
    setState(() {});
  }
  Future<void> _getUserInfoList() async {
    _isLoading = true;
    _userInfoList = await getUserWaitingAPI();
    _isLoading = false;
    setState(() {});
  }
  List<DropdownMenuItem<int>> _buildDropdownItems() {
    return [
      for (var user in _userInfoList)
        DropdownMenuItem(
          value: user.account,
          child: Text('学号：${user.account}\t姓名：${user.name}'),
        )
    ];
  }
  Future<void> refreshData() async{
    await _getManagerInfoList();
    await _getUserInfoList();
  }

  Future<void> _changeManagerDetail(BuildContext context, int account) async {
    ManagerInfo managerInfo = await getManagerInfoByIdAPI(account);
    final passwordController = TextEditingController(text: managerInfo.password);
    final identityController = TextEditingController(text: managerInfo.identity.toString());
    final updateManager = await showDialog<ManagerInfo>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('修改管理员信息'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: '请输入管理员密码',
                  labelText: '密码',
                ),
              ),
              TextField(
                controller: identityController,
                decoration: InputDecoration(
                  hintText: '请输入管理员身份',
                  labelText: '身份',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                managerInfo.password = passwordController.text;
                managerInfo.identity = int.parse(identityController.text);
                Navigator.of(context).pop(managerInfo);
              },
              child: Text('确定'),
            )
          ]
        );
      }
    );
    if (updateManager != null) {
      await updateManagerInfoAPI(updateManager);
      await refreshData();
    }
  }

  Future<void> _giveManagerOrder(BuildContext context, int account) async {
    List<UserInfo> userInfo = await getUserInfoByManagerAPI(account);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('抢课信息'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var user in userInfo)
                Text('学号：${user.account}\t姓名：${user.name}\t状态：${user.state}'),
              Text("添加人员"),
              DropdownButtonFormField<int>(
                items: _buildDropdownItems(),
                onChanged: (int? value) async{
                  if (value != null) {
                   await updateManagerAllocationAPI(account, value);
                   await refreshData();
                   if (mounted) {
                     Navigator.pop(context);
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('分配成功！')),
                     );
                   }
                  }
                },
              )
            ]
          )
        );
      }
    );
  }

  Widget _buildListItem() {
    if (_managerInfoList.isEmpty && !_isLoading) {
      return Center(
        child: Text('暂无数据'),
      );
    }
    return Expanded(
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return Container(
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      selected: true,
                      title: Text("姓名：${_managerInfoList[index].name}"),
                      subtitle: Text("正常进行中：${_managerInfoList[index].doing}\n已完成：${_managerInfoList[index].done}"),
                      onTap: () {
                      }
                    )
                  ),
                  IconButton(
                    onPressed: () {
                      _giveManagerOrder(context, _managerInfoList[index].account);
                    },
                    icon: const Icon(Icons.bookmark_border),
                  ),
                  IconButton(
                    onPressed: () {
                      _changeManagerDetail(context, _managerInfoList[index].account);
                    },
                    icon: const Icon(Icons.update),
                  )
                ]
              )
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(height: 2, width: double.infinity, color: Colors.amber);
          },
          itemCount: _managerInfoList.length
      )
    );
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('云课速抢派单'),
        centerTitle: true,
      ),
        body: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              _buildListItem()
            ],
          )
        )
    );
  }
}
