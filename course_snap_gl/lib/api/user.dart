import '../constants/index.dart';
import '../pojo/UserInfo.dart';
import '../utils/DioRequest.dart';

Future<List<UserInfo>> getUserInfoAPI() async {
    return ((await dioRequest.get(HttpConstants.MANAGER_USER)) as List).map((item) {
      return UserInfo.fromJson(item as Map<String, dynamic>);
    }).toList();
}

Future<UserInfo> getUserInfoByIdAPI(int account) async {
  return UserInfo.fromJson(
      await dioRequest.get(HttpConstants.MANAGER_USER_ID, params: {"account": account})
  );
}

Future<bool> updateUserInfoAPI(Map<String, dynamic> userInfo) async {
 return await dioRequest.post(HttpConstants.MANAGER_USER_UPDATE, data: userInfo);
}

 Future<bool> deleteUserInfoAPI(int account) async {
   var result = await dioRequest.delete(HttpConstants.MANAGER_USER_DELETE, params: {"account": account});
   if (result == null) {
     return true;
   } else {
     return false;
   }
 }
