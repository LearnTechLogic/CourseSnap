class GlobalConstants {
  static const String BASE_URL = "http://localhost:8080/";
  static const int TIME_OUT = 10;
  static const String SUCCESS = "1";
  static const String TOKEN = "course_snap_token";
}

class HttpConstants {
  static const String MANAGER_LOGIN = "/manager/login";
  static const String MANAFER_PROFILE = "/manager/profile"; // 用户信息
  static const String MANAGER_REGISTER = "/manager/register"; // 注册
  static const String MANAGER_USER = "/manager/user";
  static const String MANAGER_USER_ID = "/manager/user/account";
  static const String MANAGER_USER_UPDATE = "/manager/user/update";
  static const String MANAGER_PROFILE_LIST = "/manager/profile/list";
  static const String MANAGER_USER_DELETE = "/manager/user/delete";
  static const String MANAGER_PROFILE_DETAIL = "/manager/profile/detail";
  static const String MANAGER_PROFILE_UPDATE = "/manager/profile/update";
  static const String MANAGER_USER_MANAGER = "/manager/user/manager";
  static const String MANAGER_USER_WAITING = "/manager/user/waiting";
  static const String MANAGER_ALLOCATION_UPDATE = "/manager/allocation";
  static const String USER_PAID_LIST = "/manager/paid";
  static const String IMAGE_POST = "/image/post";
}