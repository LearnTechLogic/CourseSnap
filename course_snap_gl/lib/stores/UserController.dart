import 'package:course_snap_gl/pojo/UserInfo.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  var user = UserInfo.fromJson({}).obs;
  updateUserInfo(UserInfo newUser){
    this.user.value = newUser;
  }
}