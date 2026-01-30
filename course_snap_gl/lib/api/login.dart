import '../constants/index.dart';
import '../pojo/ManagerInfo.dart';
import '../utils/DioRequest.dart';

Future<ManagerInfo> loginAPI(Map<String, dynamic> data) async {
  return ManagerInfo.fromJson(
      await dioRequest.post(HttpConstants.LOGIN, data: data)
  );
}