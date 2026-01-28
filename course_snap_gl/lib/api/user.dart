import 'package:course_snap_gl/constants/index.dart';
import 'package:course_snap_gl/pojo/UserInfo.dart';
import 'package:course_snap_gl/utils/DioRequest.dart';

Future<UserInfo> getUserInfoAPI() async {
  return UserInfo.fromJson(
    await dioRequest.get(HttpConstants.USER_PROFILE)
  );
}