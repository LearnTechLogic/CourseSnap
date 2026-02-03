import 'package:course_snap_yh/pojo/UserInfo.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  var user = UserInfo.fromJson({}).obs;
  updateUserInfo(UserInfo userInfo) {
    this.user.value = userInfo;
  }
 }