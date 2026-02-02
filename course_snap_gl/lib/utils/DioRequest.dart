import 'package:course_snap_gl/constants/index.dart';
import 'package:course_snap_gl/stores/TokenManager.dart';
import 'package:dio/dio.dart';

class DioRequest {
  final _dio = Dio();
  DioRequest() {
    _dio.options
        ..baseUrl = GlobalConstants.BASE_URL
        ..connectTimeout = Duration(seconds: GlobalConstants.TIME_OUT)
        ..sendTimeout = Duration(seconds: GlobalConstants.TIME_OUT);
    // 拦截器
    _addInterceptors();
  }
  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        // 请求拦截器
        onRequest: (request, handler) {
          if(tokenManager.getToken().isNotEmpty) {
            request.headers = {
              // 'Authorization': 'Bearer ${tokenManager.getToken()}'
              'token': tokenManager.getToken()
            };
          }
          handler.next(request);
        },
        // 响应拦截器
        onResponse: (response, handler) {
          if(response.statusCode! >= 200 && response.statusCode! < 300) {
            handler.next(response);
            return;
          }
          handler.reject(DioException(requestOptions: response.requestOptions));
        },
        // 错误拦截器
        onError: (error, handler) {
          handler.reject(DioException(requestOptions: error.requestOptions, message: error.response?.data['message'] ?? ""));
        }
      )
    );
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? params}) {
    return _handleResponse(_dio.get(url, queryParameters: params));
  }
  Future<dynamic> post(String url, {Map<String, dynamic>? data}) {
    return _handleResponse(_dio.post(url, data: data));
  }
  Future<dynamic> delete(String url, {Map<String, dynamic>? params}) {
    return _handleResponse(_dio.delete(url, queryParameters: params));
  }
  Future<dynamic> postImage(String url, FormData formData) {
    return _handleResponse(_dio.post(url, data: formData));
  }


  Future<dynamic> _handleResponse(Future<Response<dynamic>> task) async {
    try {
      Response<dynamic> response = await task;
      final data = response.data as Map<String, dynamic>;
      if(data['code'] == GlobalConstants.SUCCESS) {
        return data['data'];
      }
      throw DioException(requestOptions: response.requestOptions, message: data['message'] ?? "加载数据错误");
    } catch (e) {
      rethrow; // 不改变原来抛出的异常类型
    }
  }
}


// 单例对象
final dioRequest = DioRequest();