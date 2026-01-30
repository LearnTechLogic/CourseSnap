import 'package:course_snap_gl/constants/index.dart';
import 'package:course_snap_gl/pojo/ManagerInfo.dart';
import 'package:course_snap_gl/utils/DioRequest.dart';

Future<ManagerInfo> getManagerInfoAPI() async {
  return ManagerInfo.fromJson(
    await dioRequest.get(HttpConstants.USER_PROFILE)
  );
}