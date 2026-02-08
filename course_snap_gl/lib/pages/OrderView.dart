import 'package:course_snap_gl/api/image.dart';
import 'package:course_snap_gl/api/user.dart';
import 'package:course_snap_gl/pojo/UserInfo.dart';
import 'package:course_snap_gl/stores/ManagerController.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/LoadingDialog.dart';
import '../utils/ToastUtils.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final ManagerController _managerController = Get.find();
  List<UserInfo> _userList = [];
  bool _isLoading = false;
  Future<void> _getUserList() async {
    _isLoading = true;
    _userList = await getUserInfoAPI();
    _isLoading = false;
    setState(() {});
  }
  Future<void> _pickImage(int account, int imageNum) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      try {
        LoadingDialog.show(context, message: "上传中...");
        await postImageAPI(image, account, imageNum);
        LoadingDialog.hide(context);
        ToastUtils.showToast(context, "上传成功");
        _getUserList();
      } catch (e) {
        LoadingDialog.hide(context);
        ToastUtils.showToast(context, (e as DioException).message);
      }
    }
  }

  // 上传图片
  Widget _buildImageUp(UserInfo userInfo) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              userInfo.image1.isNotEmpty ?
                Image.network(
                  userInfo.image1,
                  width: 100,
                  height: 100,
                ) :
                  Text(''),
              SizedBox(height: 8),
                // Text(""),
              ElevatedButton(
                onPressed: () {
                  _pickImage(userInfo.account, 1);
                },
                child: Text("上传图片")
              )
            ],
          )
        ),
        Expanded(
          child: Column(
            children: [
              userInfo.image2.isNotEmpty ?
                Image.network(
                  userInfo.image2,
                  width: 100,
                  height: 100,
                ) :
                  Text(''),
              SizedBox(height: 8),
                // Text(""),
              ElevatedButton(
                onPressed: () {
                  _pickImage(userInfo.account, 2);
                },
                child: Text("上传图片")
              )
            ]
          )
        )
      ],
    );
  }
  
  
  final List<String> _states = ['仅注册', '申请', '等待', '进行中', '未支付', '已支付', '拒绝'];
  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return _states
        .map((String option) => DropdownMenuItem<String>(
          value: option, // 选项的实际值（如 "正常"）
          child: Text(option), // 选项显示的文字
        ))
        .toList();
  }
  void _updatateUser(UserInfo userInfo) async {
    try {
      // 更新数据库
      LoadingDialog.show(context, message: "修改中...");
      await updateUserInfoAPI({
        "account": userInfo.account,
        "name": userInfo.name,
        "password": userInfo.password,
        "state": userInfo.state,
        "price": userInfo.price,
        "qq": userInfo.qq,
        "requirement":userInfo.requirement,
      });
      LoadingDialog.hide(context);
      ToastUtils.showToast(context, "修改成功");
    } catch (e) {
      LoadingDialog.hide(context);
      ToastUtils.showToast(context, (e as DioException).message);
      }
  }

  Future<void> _getUserDetail(BuildContext context,int account) async{
    UserInfo userInfo = await getUserInfoByIdAPI(account);
    final nameController = TextEditingController(text: userInfo.name);
    final passwordController = TextEditingController(text: userInfo.password);
    final priceController = TextEditingController(text: userInfo.price.toString());
    final requirementController = TextEditingController(text: userInfo.requirement);
    final qqController = TextEditingController(text: userInfo.qq.toString());
    final stateController = TextEditingController(text: userInfo.state);
    // 弹出弹窗并等待用户操作结果
    final updatedUser = await showDialog<UserInfo>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("用户详情"),
          // 内容：学号（不可改）+ 姓名/状态（可改）
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 学号：仅展示，不可编辑
                Text("学号：${userInfo.account}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                // 姓名输入框
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '姓名',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                // 密码输入框
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: '密码',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                // 价格输入框
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: '价格',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: requirementController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: '需求',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: qqController,
                  decoration: const InputDecoration(
                    labelText: 'QQ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                // 状态下拉列表
                DropdownButtonFormField<String>(
                  value: userInfo.state,
                  hint: const Text('请选择状态'),
                  decoration: const InputDecoration(
                    labelText: '状态',
                    border: OutlineInputBorder(),
                  ),
                  items: _buildDropdownItems(),
                  onChanged: (String? newValue) {
                    stateController.text = newValue!;
                  }
                ),
                const SizedBox(height: 8),
                _buildImageUp(userInfo)
              ],
            ),
          ),
          actions: [
            // 取消按钮
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text("取消"),
            ),
            // 确认按钮：返回修改后的用户信息
            TextButton(
              onPressed: () {
                // 直接修改原对象值
                userInfo.name = nameController.text.trim();
                userInfo.password = passwordController.text.trim();
                userInfo.state = stateController.text.trim();
                userInfo.qq = qqController.text.trim();
                userInfo.requirement = requirementController.text.trim();
                if (_managerController.manager.value.identity == 1){
                  userInfo.price = int.parse(priceController.text.trim());
                }
                Navigator.of(context).pop(userInfo);
              },
              child: const Text("确认修改"),
            ),
          ],
        );
      },
    );

    // 如果用户确认修改，更新列表并刷新UI
    if (updatedUser != null) {
      setState(() {
        // 找到列表中对应的用户并替换
        final index = _userList.indexWhere((u) => u.account == updatedUser.account);
        if (index != -1) {
          _updatateUser(updatedUser);
          _userList[index] = updatedUser;
        }
      });
      // 提示修改成功
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${updatedUser.name} 的信息已更新")),
        );
      }
    }
  }

  Future<void> _deleteUser(BuildContext context, int account) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text("确定要删除该用户吗？"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("确定"),
            )
          ]
        );
      }
    );
    if (confirm == false) {
      return;
    }
    try {
      // 删除用户
      await deleteUserInfoAPI(account);
      // 删除成功，提示并刷新列表
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("用户已删除")),
        );
      }
      // 删除成功，从列表中移除该用户
      setState(() {
        _getUserList();
      });
    } catch (e) {
      // 删除失败，提示并保持列表不变
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("删除用户失败：$e")),
        );
      }
    }
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
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _getUserDetail(context, _userList[index].account);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text("学号：${_userList[index].account}"),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text("姓名：${_userList[index].name}", style: TextStyle(fontSize: 12)),
                        ),
                        // Text("价格：${_userList[index].price}"),
                        Text("状态：${_userList[index].state}", style: TextStyle(fontSize: 10)),
                      ]
                    )
                  )
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    _deleteUser(context, _userList[index].account);
                  }
                ),

              ]
            )
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(height: 2, width: double.infinity, color: Colors.amber);
        },
        itemCount: _userList.length,
      )
      // child:
    );
  }

  Widget _buildRefreshButton() {
    return ElevatedButton(
      onPressed: () {
        _getUserList();
      },
      child: const Text("刷新"),
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
