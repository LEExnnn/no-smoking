import 'package:flutter/material.dart';

/// 《这个APP能让你戒烟》设计系统 - 色彩
///
/// 设计关键词: 浅色、高级、干净、柔和、微烟雾、玻璃拟态
/// 像: Apple Health 的干净 + Headspace 的温柔 + 高级金融 APP 的价值感
/// 不像: 医院、公益广告、打卡工具、廉价游戏
class AppColors {
  AppColors._();

  // ─── 主色系 ───────────────────────────────────────────
  /// 品牌主色 - 清新薄荷绿（代表自由、清新、新生）
  static const Color primary = Color(0xFF4ECDC4);
  static const Color primaryLight = Color(0xFF7EDCD6);
  static const Color primaryDark = Color(0xFF36B5AC);
  static const Color primarySurface = Color(0xFFE8F8F7);

  // ─── 辅助色 ───────────────────────────────────────────
  /// 温暖金色 - 用于烟钱银行、奖励、价值感
  static const Color gold = Color(0xFFE8B94A);
  static const Color goldLight = Color(0xFFF5D88A);
  static const Color goldSurface = Color(0xFFFFF8E7);

  /// 柔和蓝 - 用于信息、引导、冷静
  static const Color blue = Color(0xFF5B9BD5);
  static const Color blueSurface = Color(0xFFEBF3FB);

  /// 柔和粉 - 用于宝宝/家庭模块
  static const Color pink = Color(0xFFE8878C);
  static const Color pinkSurface = Color(0xFFFFF0F1);

  /// 柔和紫 - 用于身份转变、高级感
  static const Color purple = Color(0xFF9B8EC4);
  static const Color purpleSurface = Color(0xFFF3F0FA);

  // ─── 功能色 ───────────────────────────────────────────
  /// 成功 - 柔和绿（不是刺眼的绿）
  static const Color success = Color(0xFF6BC89F);
  static const Color successSurface = Color(0xFFEDF8F3);

  /// 警示 - 柔和橙（不是警告红）
  static const Color warning = Color(0xFFE8A94A);
  static const Color warningSurface = Color(0xFFFFF6E7);

  /// 高危 - 柔和珊瑚色（不是恐吓红）
  static const Color danger = Color(0xFFE07A7A);
  static const Color dangerSurface = Color(0xFFFFF0F0);

  // ─── 中性色 ───────────────────────────────────────────
  /// 背景色系
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF2F4F6);
  static const Color cardBackground = Color(0xFFFFFFFF);

  /// 文字色系
  static const Color textPrimary = Color(0xFF1A1D21);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF);

  /// 边框 & 分隔线
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF0F1F3);
  static const Color divider = Color(0xFFF0F1F3);

  // ─── 烟雾动效色 ─────────────────────────────────────────
  /// 烟雾消散动效专用色系
  static const Color smokeLight = Color(0x33D1D5DB);
  static const Color smokeMedium = Color(0x669CA3AF);
  static const Color smokeDark = Color(0x336B7280);

  // ─── 渐变 ───────────────────────────────────────────
  /// 主渐变 - 薄荷清新
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4ECDC4), Color(0xFF44A9A0)],
  );

  /// 金色渐变 - 烟钱银行
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8B94A), Color(0xFFD4A43E)],
  );

  /// 急救渐变 - 冷静蓝绿
  static const LinearGradient rescueGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF8F9FA), Color(0xFFE8F8F7)],
  );

  /// 身份升级渐变
  static const LinearGradient identityGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9B8EC4), Color(0xFF7B6FA8)],
  );

  // ─── 玻璃拟态 ─────────────────────────────────────────
  /// 玻璃效果背景色
  static const Color glassBackground = Color(0xCCFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
}
