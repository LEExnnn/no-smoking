import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/onboarding/philosophy_screen.dart';
import '../screens/onboarding/questionnaire_screen.dart';
import '../screens/onboarding/profile_generating_screen.dart';
import '../screens/onboarding/profile_report_screen.dart';
import '../screens/onboarding/quit_day_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/craving/craving_trigger_screen.dart';
import '../screens/craving/craving_rescue_screen.dart';
import '../screens/craving/craving_timer_screen.dart';
import '../screens/craving/craving_complete_screen.dart';

/// 路由名称常量
class AppRoutes {
  AppRoutes._();

  // ─── 入门流程 ────────────────────────────────────────
  static const String welcome = '/welcome';
  static const String philosophy = '/philosophy';
  static const String questionnaire = '/questionnaire';
  static const String profileGenerating = '/profile-generating';
  static const String profileReport = '/profile-report';
  static const String quitDay = '/quit-day';

  // ─── 核心页面 ────────────────────────────────────────
  static const String home = '/home';

  // ─── 烟瘾急救 ────────────────────────────────────────
  static const String cravingTrigger = '/craving/trigger';
  static const String cravingRescue = '/craving/rescue';
  static const String cravingTimer = '/craving/timer';
  static const String cravingComplete = '/craving/complete';

  // ─── 路由表 ──────────────────────────────────────────
  static Map<String, WidgetBuilder> get routes => {
        welcome: (context) => const WelcomeScreen(),
        philosophy: (context) => const PhilosophyScreen(),
        questionnaire: (context) => const QuestionnaireScreen(),
        profileGenerating: (context) => const ProfileGeneratingScreen(),
        profileReport: (context) => const ProfileReportScreen(),
        quitDay: (context) => const QuitDayScreen(),
        home: (context) => const HomeScreen(),
        cravingTrigger: (context) => const CravingTriggerScreen(),
        cravingRescue: (context) => const CravingRescueScreen(),
        cravingTimer: (context) => const CravingTimerScreen(),
        cravingComplete: (context) => const CravingCompleteScreen(),
      };

  /// 初始路由（根据用户状态决定）
  static String get initialRoute {
    final profile = StorageService().getProfile();
    if (profile != null) {
      return home;
    }
    return welcome;
  }
}
