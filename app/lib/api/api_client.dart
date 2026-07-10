import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio dio;
  static const String _deviceIdKey = 'device_id';

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      // Default to 10.0.2.2, interceptor will override this if custom IP is set
      baseUrl: 'http://10.0.2.2:8000/api/v1',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        
        // 动态替换 Base URL
        String? customIp = prefs.getString('custom_server_ip');
        if (customIp != null && customIp.isNotEmpty) {
          options.baseUrl = 'http://$customIp:8000/api/v1';
        }
        String? deviceId = prefs.getString(_deviceIdKey);
        
        // 如果没有设备ID，生成一个临时的（真实环境中应获取真实设备ID或引导注册登录）
        if (deviceId == null) {
          deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
          await prefs.setString(_deviceIdKey, deviceId);
        }
        
        options.queryParameters['device_id'] = deviceId;
        return handler.next(options);
      },
    ));
  }

  /// 提交问卷并获取画像
  Future<Map<String, dynamic>> submitQuestionnaire(Map<String, dynamic> answers) async {
    try {
      final response = await dio.post('/profile/submit', data: answers);
      return response.data;
    } catch (e) {
      throw Exception('网络请求失败: $e');
    }
  }

  /// 获取个人画像
  Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final response = await dio.get('/profile/me');
      return response.data;
    } catch (e) {
      throw Exception('获取画像失败: $e');
    }
  }

  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await dio.get('/dashboard/me');
      return response.data;
    } catch (e) {
      throw Exception('网络请求失败: $e');
    }
  }

  Future<Map<String, dynamic>> triggerCravingSOS(String triggerType) async {
    try {
      final response = await dio.post('/craving/sos', data: {
        'trigger_type': triggerType,
        'intensity': 5,
      });
      return response.data;
    } catch (e) {
      throw Exception('急救请求失败: $e');
    }
  }

  Future<Map<String, dynamic>> resolveCraving(String eventId, String outcome) async {
    try {
      final response = await dio.post('/craving/resolve', data: {
        'event_id': eventId,
        'outcome': outcome,
      });
      return response.data;
    } catch (e) {
      throw Exception('上报结果失败: $e');
    }
  }
}
