import 'package:flutter/foundation.dart';

class ProfileEngine {
  static Map<String, dynamic> generateProfile(Map<String, dynamic> answers) {
    debugPrint('Calculating profile from answers: $answers');
    
    // 基础数据
    int smokingYears = 5;
    if (answers['start_age'] == '初中或更早') smokingYears = 15;
    if (answers['start_age'] == '高中') smokingYears = 10;
    if (answers['start_age'] == '大学') smokingYears = 8;
    if (answers['start_age'] == '工作以后') smokingYears = 5;
    if (answers['start_age'] == '最近几年') smokingYears = 2;

    int cigarettesPerDay = 3;
    if (answers['cigarettes_per_day'] == '1-5 支') cigarettesPerDay = 3;
    if (answers['cigarettes_per_day'] == '6-10 支') cigarettesPerDay = 8;
    if (answers['cigarettes_per_day'] == '11-15 支') cigarettesPerDay = 13;
    if (answers['cigarettes_per_day'] == '16-20 支（约一包）') cigarettesPerDay = 20;
    if (answers['cigarettes_per_day'] == '一包以上') cigarettesPerDay = 30;

    double packPrice = 20.0;
    if (answers['pack_price'] == '15 元以下') packPrice = 12.0;
    if (answers['pack_price'] == '15-25 元') packPrice = 20.0;
    if (answers['pack_price'] == '25-40 元') packPrice = 30.0;
    if (answers['pack_price'] == '40-60 元') packPrice = 50.0;
    if (answers['pack_price'] == '60 元以上') packPrice = 80.0;

    String dependenceLevel = 'medium';
    if (answers['first_cigarette'] == '5 分钟以内') dependenceLevel = 'high';
    else if (answers['first_cigarette'] == '5-30 分钟') dependenceLevel = 'mediumHigh';
    else if (answers['first_cigarette'] == '30 分钟到 1 小时') dependenceLevel = 'medium';
    else dependenceLevel = 'low';

    // 分析标签
    List<String> userTypes = [];
    if (answers['smoke_identity'] == '🧑‍🤝‍🧑 朋友' || answers['smoke_identity'] == '🤗 陪伴') userTypes.add('情感依赖型');
    if (answers['smoke_identity'] == '🤝 社交工具') userTypes.add('社交需求型');
    if (answers['smoke_identity'] == '🛋️ 放松' || answers['smoke_identity'] == '🎁 奖励') userTypes.add('缓解压力型');
    
    if (userTypes.isEmpty) userTypes.add('习惯依赖型');

    return {
      "smoking_years": smokingYears,
      "cigarettes_per_day": cigarettesPerDay,
      "pack_price": packPrice,
      "dependence_level": dependenceLevel,
      "user_types": userTypes,
      "motivation_weights": _extractList(answers['motivations']),
      "trigger_weights": _extractList(answers['triggers']),
      "belief_tags": _extractList(answers['previous_attempts']),
      "recommended_modules": ["ai_rescue", "money_bank", "health_recovery"]
    };
  }

  static List<String> _extractList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }
}
