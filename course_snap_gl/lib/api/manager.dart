import 'package:course_snap_gl/constants/index.dart';
import 'package:course_snap_gl/pojo/ManagerInfo.dart';
import 'package:course_snap_gl/pojo/UserInfo.dart';
import 'package:course_snap_gl/utils/DioRequest.dart';

Future<ManagerInfo> getManagerInfoAPI() async {
  return ManagerInfo.fromJson(
    await dioRequest.get(HttpConstants.MANAFER_PROFILE)
  );
}

Future<List<ManagerInfo>> getManagerInfoListAPI() async {
  return
    ((await dioRequest.get(HttpConstants.MANAGER_PROFILE_LIST)) as List).map((item) {
      return ManagerInfo.fromJson(item as Map<String, dynamic>);
    }).toList();
}

Future<ManagerInfo> getManagerInfoByIdAPI(int account) async {
  return ManagerInfo.fromJson(
    await dioRequest.get(HttpConstants.MANAGER_PROFILE_DETAIL, params: {"account": account})
  );
}

Future<bool> updateManagerInfoAPI(ManagerInfo managerInfo) async {
  Map<String, dynamic> data = {
    "account": managerInfo.account,
    "name": managerInfo.name,
    "password": managerInfo.password,
    "identity": managerInfo.identity,
  };
  return await dioRequest.post(HttpConstants.MANAGER_PROFILE_UPDATE, data: data);
}

Future<bool> updateManagerAllocationAPI(int managerAccount, int userId) async {
  await dioRequest.post(HttpConstants.MANAGER_ALLOCATION_UPDATE, data: {
    "managerAccount": managerAccount,
    "userAccount": userId
  });
  return true;
}

Future<List<UserInfo>> getUserPaidAPI() async {
  return ((await dioRequest.get(HttpConstants.USER_PAID_LIST)) as List).map((item) {
    return UserInfo.fromJson(item as Map<String, dynamic>);
  }).toList();
}