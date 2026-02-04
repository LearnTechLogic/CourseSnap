import 'package:course_snap_yh/constants/index.dart';
import 'package:course_snap_yh/pojo/UserInfo.dart';
import 'package:course_snap_yh/utils/DioRequest.dart';

Future<UserInfo> userLoginAPI(Map<String, dynamic> params) async {
  return UserInfo.fromJson(
    await dioRequest.get(HttpConstants.USER_LOGIN, params: params)
  );
}

Future<void> userRegisterAPI(Map<String, dynamic> user) async {
  return await dioRequest.post(HttpConstants.USER_REGISTER, data: user);
}

Future<UserInfo> userInfoAPI() async {
  return UserInfo.fromJson(
    await dioRequest.get(HttpConstants.USER_INFO)
  );
}

Future<UserInfo> userUpdateAPI(Map<String, dynamic> user) async {
  return UserInfo.fromJson(
    await dioRequest.post(HttpConstants.USER_UPDATE, data: user)
  );
}

Future<UserInfo> userApplyAPI(Map<String, dynamic> user) async {
  return UserInfo.fromJson(
    await dioRequest.post(HttpConstants.USER_APPLY, data: user)
  );
}