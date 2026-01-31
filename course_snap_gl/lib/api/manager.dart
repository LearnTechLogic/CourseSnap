import 'package:course_snap_gl/constants/index.dart';
import 'package:course_snap_gl/pojo/ManagerInfo.dart';
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