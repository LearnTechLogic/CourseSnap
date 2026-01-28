import 'package:course_snap_gl/constants/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  // 返回持久化对象的实例
  Future<SharedPreferences> _getInstance() async {
    return await SharedPreferences.getInstance();
  }

  String _token = "";
  // 初始化token
  init() async {
    final prefs = await _getInstance();
    _token = prefs.getString(GlobalConstants.TOKEN) ?? "";
  }

  // 获取token
  String getToken() {
    return _token;
  }

  // 设置token
  Future<void> setToken(String token) async {
    final prefs = await _getInstance();
    await prefs.setString(GlobalConstants.TOKEN, token);
    _token = token;
  }

  // 删除token
  Future<void> deleteToken() async {
    final prefs = await _getInstance();
    await prefs.remove(GlobalConstants.TOKEN);
    _token = "";
  }
}

final tokenManager = TokenManager();
