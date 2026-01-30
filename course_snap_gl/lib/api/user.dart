import '../constants/index.dart';
import '../pojo/UserInfo.dart';
import '../utils/DioRequest.dart';

Future<List<UserInfo>> getUserInfoAPI() async {
    return ((await dioRequest.get(HttpConstants.MANAGER_USER)) as List).map((item) {
      return UserInfo.fromJson(item as Map<String, dynamic>);
    }).toList();
}