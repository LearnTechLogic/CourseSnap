import '../constants/index.dart';
import '../pojo/ManagerInfo.dart';
import '../utils/DioRequest.dart';

Future<ManagerInfo> managerLoginAPI(Map<String, dynamic> data) async {
  return ManagerInfo.fromJson(
      await dioRequest.post(HttpConstants.MANAGER_LOGIN, data: data)
  );
}