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
          child: Row(
            children: [
              SizedBox(
                width: 140,
                child: Text("学号:${user.account}"),
              ),
              SizedBox(
                width: 140,
                child: Text("姓名:${user.name}")
              ),
              Text("价格:${user.price}")
            ],
          )
        )
    ];
  }

  Future<void> refreshData() async{
    await _getManagerInfoList();
    await _getUserInfoList();
  }

  Future<void> _changeManagerDetail(BuildContext context, int account) async {
    ManagerInfo managerInfo = await getManagerInfoByIdAPI(account);
    final nameController = TextEditingController(text: managerInfo.name);
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
                controller: nameController,
                decoration: InputDecoration(
                  hintText: '请输入管理员姓名',
                  labelText: '姓名',
                ),
              ),
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
                managerInfo.name = nameController.text;
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
          title: const Text('抢课信息'),
          // 优化：设置弹窗宽度，适配列表显示
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // 占屏幕80%宽度
            child: Column(
              mainAxisSize: MainAxisSize.min, // 关键：Column仅占最小高度
              children: [
                const Text("添加人员"),
                // 优化：DropdownButtonFormField补充默认值、提示文字
                DropdownButtonFormField<int>(
                  hint: const Text('请选择分配的管理者ID'), // 提示文字
                  value: null, // 默认值（可根据需求设置初始值）
                  items: _buildDropdownItems(),
                  onChanged: (int? value) async {
                    if (value != null) {
                      try {
                        // 异步操作加异常捕获
                        await updateManagerAllocationAPI(account, value);
                        await refreshData();
                        if (mounted) {
                          Navigator.pop(context); // 关闭弹窗
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('分配成功！')),
                          );
                        }
                      } catch (e) {
                        // 接口调用失败时提示
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('分配失败：${e.toString()}')),
                          );
                        }
                      }
                    }
                  },
                ),
                // 核心修正：给ListView固定高度，解决无界高度问题
                const SizedBox(height: 8), // 间距，优化视觉
                SizedBox(
                  height: 200, // 固定ListView高度（可根据需求调整）
                  child: ListView.separated(
                    key: UniqueKey(), // 解决mouse_tracker异常
                    physics: const ClampingScrollPhysics(), // 允许列表内部滚动
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        key: ValueKey(userInfo[index].account), // 唯一key，避免复用冲突
                        title: Text(
                          '学号：${userInfo[index].account}\t姓名：${userInfo[index].name}\t状态：${userInfo[index].state}',
                          maxLines: 2, // 限制行数
                          overflow: TextOverflow.ellipsis, // 文本溢出显示省略号
                          style: const TextStyle(fontSize: 12), // 缩小字体，适配弹窗
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(height: 2, width: double.infinity - 16, color: Colors.amber);
                    },
                    itemCount: userInfo.length,
                  ),
                ),
              ],
            ),
          ),
          // 补充：添加弹窗关闭按钮，优化交互
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('关闭'),
            ),
          ],
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

  Widget _buildRefreshButton() {
    return ElevatedButton(
      onPressed: () async {
        await refreshData();
      },
      child: Text('刷新'),
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
              _buildRefreshButton(),
              const SizedBox(height: 10),
              _buildListItem()
            ],
          )
        )
    );
  }
}
