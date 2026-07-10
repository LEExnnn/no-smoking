import 'dart:convert';
import 'package:dio/dio.dart';

class DeepSeekClient {
  static final DeepSeekClient _instance = DeepSeekClient._internal();
  late Dio dio;
  
  // Note: For a production app, the API key should not be hardcoded here.
  // This is acceptable for a local-first standalone personal app.
  static const String _apiKey = 'sk-eb77ebc1f06141a291e52dbb064c58be';
  static const String _baseUrl = 'https://api.deepseek.com/chat/completions';

  factory DeepSeekClient() => _instance;

  DeepSeekClient._internal() {
    dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      }
    ));
  }

  Future<List<String>> generateCravingMessages(String triggerType, Map<String, dynamic>? profile) async {
    try {
      final prompt = '''
      用户因为 "$triggerType" 场景想抽烟了。
      这是他/她的画像：
      ${jsonEncode(profile ?? {})}
      
      请生成5句简短的安抚话术（每句不超过15字），语气像一个温和的心理专家，不需要编号，用换行符隔开。
      必须只返回5行纯文本，不要任何多余字符。
      ''';

      final response = await dio.post(_baseUrl, data: {
        "model": "deepseek-chat",
        "messages": [
          {"role": "system", "content": "你是一个专业的戒烟心理辅导专家。"},
          {"role": "user", "content": prompt}
        ],
        "temperature": 0.5,
      });

      final content = response.data['choices'][0]['message']['content'] as String;
      final lines = content.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      
      // Ensure we always have exactly 5 messages
      while(lines.length < 5) {
        lines.add("深呼吸，你会熬过去的");
      }
      return lines.take(5).toList();
    } catch (e) {
      // 离线兜底逻辑
      return [
        '想抽烟是很正常的感受',
        '但这只是大脑在向你索要多巴胺',
        '再坚持一下，冲动很快就会过去',
        '想想你最初决定戒烟的理由',
        '你已经做得很好了，不要轻易放弃'
      ];
    }
  }
}
