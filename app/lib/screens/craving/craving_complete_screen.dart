import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_theme.dart';
import '../../router/app_routes.dart';

/// 烟瘾急救 - 完成反馈页
///
/// 文案："这次你没有喂它。它下次会弱一点。"
/// 收益立刻可视化：击退烟瘾+1、少抽1支、省下X元
class CravingCompleteScreen extends StatefulWidget {
  const CravingCompleteScreen({super.key});

  @override
  State<CravingCompleteScreen> createState() => _CravingCompleteScreenState();
}

class _CravingCompleteScreenState extends State<CravingCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXl),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // 成功动画
              _buildSuccessAnimation(),

              const SizedBox(height: AppTheme.spacingXxl),

              // 核心文案
              _buildAnimated(
                delay: 0.2,
                child: Text(
                  '这次你没有喂它',
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              _buildAnimated(
                delay: 0.3,
                child: Text(
                  '它下次会弱一点',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppTheme.spacingXxl),

              // 收益可视化
              _buildAnimated(
                delay: 0.4,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacingXl),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    boxShadow: AppTheme.shadowSm,
                  ),
                  child: Column(
                    children: [
                      _buildRewardRow('🛡️', '击退烟瘾', '+1'),
                      const Divider(height: 24),
                      _buildRewardRow('🚭', '少抽', '1 支'),
                      const Divider(height: 24),
                      _buildRewardRow('💰', '省下约', '¥2'),
                      const Divider(height: 24),
                      _buildRewardRow('👶', '宝宝无烟账户', '+1'),
                      const Divider(height: 24),
                      _buildRewardRow('🏠', '回家少一次烟味风险', '✓'),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // 按钮
              _buildAnimated(
                delay: 0.6,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                    },
                    child: const Text(
                      '回到首页',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingXl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return _buildAnimated(
      delay: 0.0,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRewardRow(String emoji, String label, String value) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Text(label, style: AppTypography.bodyMedium),
        const Spacer(),
        Text(
          value,
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimated({required double delay, required Widget child}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress =
            ((_controller.value - delay) / (1.0 - delay)).clamp(0.0, 1.0);
        final curvedProgress = Curves.easeOutCubic.transform(progress);

        return Opacity(
          opacity: curvedProgress,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - curvedProgress)),
            child: child,
          ),
        );
      },
    );
  }
}
