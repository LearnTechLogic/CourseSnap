import '../constants/index.dart';
import '../pojo/UserInfo.dart';
import '../utils/DioRequest.dart';

Future<UserInfo> loginAPI(Map<String, dynamic> data) async {
  return UserInfo.fromJson(
      await dioRequest.post(HttpConstants.LOGIN, data: data)
  );
}