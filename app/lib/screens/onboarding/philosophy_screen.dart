import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_theme.dart';
import '../../router/app_routes.dart';

/// 理念页
///
/// 解释产品核心方法论：不靠恐吓、不靠硬忍，拆掉绑定
/// 这页的目的是让用户第一次感觉"被理解了"
class PhilosophyScreen extends StatefulWidget {
  const PhilosophyScreen({super.key});

  @override
  State<PhilosophyScreen> createState() => _PhilosophyScreenState();
}

class _PhilosophyScreenState extends State<PhilosophyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
          child: Column(
            children: [
              const SizedBox(height: AppTheme.spacingXxl),

              // ─── 核心文案 ───────────────────────────
              _buildAnimatedText(
                delay: 0.0,
                child: Text(
                  '很多人戒烟失败',
                  style: AppTypography.headlineLarge.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppTheme.spacingSm),

              _buildAnimatedText(
                delay: 0.15,
                child: Text(
                  '不是因为不知道吸烟有害',
                  style: AppTypography.headlineLarge.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppTheme.spacingXxl),

              // ─── 核心洞察 ───────────────────────────
              _buildAnimatedText(
                delay: 0.35,
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
                      Text(
                        '而是因为',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLg),
                      _buildInsightItem('🛋️', '烟和休息绑定在了一起'),
                      _buildInsightItem('🍜', '饭后一支已经成了仪式'),
                      _buildInsightItem('🤝', '社交场合不抽怕不合群'),
                      _buildInsightItem('😑', '无聊时烟是最方便的消遣'),
                      _buildInsightItem('😰', '压力大了它是唯一出口'),
                      _buildInsightItem('🎁', '不抽之后好像少了点奖励'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingXxl),

              // ─── 方法论 ────────────────────────────
              _buildAnimatedText(
                delay: 0.55,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacingXl),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primarySurface,
                        Color(0xFFF0FCFB),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.auto_fix_high_rounded,
                        color: AppColors.primary,
                        size: 32,
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      Text(
                        '我们要做的\n不是让你硬忍',
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.primaryDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      Text(
                        '而是把这些绑定\n一条条拆掉',
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingXxl),

              // ─── 行动按钮 ─────────────────────────────
              _buildAnimatedText(
                delay: 0.7,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.questionnaire);
                    },
                    child: const Text(
                      '开始我的戒烟扫描',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildInsightItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedText({
    required double delay,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = ((_controller.value - delay) / (1.0 - delay))
            .clamp(0.0, 1.0);
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
