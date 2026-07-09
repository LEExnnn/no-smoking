import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'router/app_routes.dart';

/// 《这个APP能让你戒烟》
///
/// 一个基于用户画像、行为数据、AI 多智能体、场景预测和认知重塑的个性化戒烟操作系统。
/// 不靠恐吓、不靠硬忍，而是通过 AI 个性化画像、认知重塑、场景干预、烟瘾急救、
/// 复吸修复和价值奖励，帮助用户真正降低对烟的心理依赖。
class QuitSmokingApp extends StatelessWidget {
  const QuitSmokingApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 设置状态栏样式
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: '这个APP能让你戒烟',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
