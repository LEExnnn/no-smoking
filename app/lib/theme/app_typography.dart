import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 《这个APP能让你戒烟》设计系统 - 字体排版
///
/// 使用系统默认中文字体（苹方/思源黑体），确保中文渲染最佳
/// 整体风格：干净、克制、有呼吸感
class AppTypography {
  AppTypography._();

  // ─── 字体族 ───────────────────────────────────────────
  // 使用系统默认字体，中文渲染最优
  // Android: Noto Sans CJK / 思源黑体
  // iOS: PingFang SC / 苹方

  // ─── 标题 ───────────────────────────────────────────
  /// 超大标题 - 用于欢迎页、画像报告标题
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  /// 大标题 - 用于页面标题
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  /// 中标题 - 用于卡片标题、模块标题
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ─── 正文 ───────────────────────────────────────────
  /// 大正文 - 用于画像报告、课程内容
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textPrimary,
  );

  /// 标准正文 - 用于一般内容
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textPrimary,
  );

  /// 小正文 - 用于辅助说明
  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  // ─── 标签 ───────────────────────────────────────────
  /// 大标签 - 用于按钮、Tab
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// 标准标签 - 用于次要按钮、标签
  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  /// 小标签 - 用于辅助标签、时间戳
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textTertiary,
  );

  // ─── 特殊文本 ───────────────────────────────────────
  /// 数字显示 - 用于自由天数、烟钱金额
  static const TextStyle numberDisplay = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -1.0,
    color: AppColors.textPrimary,
  );

  /// 中号数字 - 用于卡片内数据
  static const TextStyle numberMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  /// AI 话术 - 用于急救短句、认知卡片
  static const TextStyle aiMessage = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.7,
    color: AppColors.textPrimary,
  );

  /// 引用/金句 - 用于仪式感文案
  static const TextStyle quote = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.7,
    fontStyle: FontStyle.italic,
    color: AppColors.textSecondary,
  );

  /// 倒计时数字 - 用于急救倒计时
  static const TextStyle countdown = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w300,
    height: 1.0,
    letterSpacing: -2.0,
    color: AppColors.primary,
  );
}
