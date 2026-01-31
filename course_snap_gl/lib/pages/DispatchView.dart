import 'package:course_snap_gl/pojo/ManagerInfo.dart';
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
  bool _isLoading = false;
  Future<void> _getManagerInfoList() async {
    _isLoading = true;
    _managerInfoList = await getManagerInfoListAPI();
    _isLoading = false;
    setState(() {});
  }

  Future<void> _getManagerDetail(BuildContext context, int account) async {
    ManagerInfo managerInfo = await getManagerInfoByIdAPI(account);
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
              child: ListTile(
                selected: true,
                title: Text("姓名：${_managerInfoList[index].name}"),
                subtitle: Text("正常进行中：${_managerInfoList[index].doing}\n已完成：${_managerInfoList[index].done}"),
                onTap: () {
                  _getManagerDetail(context, _managerInfoList[index].account);
                }
              ),
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
    _getManagerInfoList();
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
