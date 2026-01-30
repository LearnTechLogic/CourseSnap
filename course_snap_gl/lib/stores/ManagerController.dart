import 'package:course_snap_gl/pojo/ManagerInfo.dart';
import 'package:get/get.dart';

class ManagerController extends GetxController{
  var manager = ManagerInfo.fromJson({}).obs;
  updateManagerInfo(ManagerInfo newUser){
    this.manager.value = newUser;
  }
}