import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_theme.dart';
import '../../router/app_routes.dart';
import '../../services/storage_service.dart';

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
  
  bool _isResolving = true;
  bool _isRelapsed = false;
  int _cravingsDefeated = 0;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_resolved) {
      _resolved = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map) {
        final eventId = args['event_id'] as String?;
        final outcome = args['outcome'] as String? ?? 'resisted';
        if (eventId != null && eventId != 'offline_event') {
          _resolveEvent(eventId, outcome);
        } else {
          setState(() => _isResolving = false);
        }
      } else {
        setState(() => _isResolving = false);
      }
    }
  }

  void _resolveEvent(String eventId, String outcome) async {
    final storage = StorageService();
    
    if (outcome == 'resisted') {
      await storage.addCravingDefeated();
    } else if (outcome == 'relapsed') {
      await storage.addSlipUp();
      _isRelapsed = true;
    }
    
    if (mounted) {
      setState(() {
        _cravingsDefeated = storage.getCravingsDefeated();
        _isResolving = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isResolving) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }
    
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
                  _isRelapsed ? '没关系，原谅自己' : '这次你没有喂它',
                  style: AppTypography.headlineLarge.copyWith(
                    color: _isRelapsed ? AppColors.textPrimary : AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              _buildAnimated(
                delay: 0.3,
                child: Text(
                  _isRelapsed ? '一根烟不代表全面失败，这只是漫长旅途中的一个小跟头。' : '它下次会弱一点',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppTheme.spacingXxl),

              // 收益可视化
              if (!_isRelapsed)
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
                        Text(
                          '🎉 成功抢救寿命',
                          style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        const Text(
                          '+11 分钟',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryDark,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingLg),
                        const Divider(height: 1, color: AppColors.borderLight),
                        const SizedBox(height: AppTheme.spacingLg),
                        _buildRewardRow('🛡️', '累计击退烟瘾', '$_cravingsDefeated 次'),
                        const SizedBox(height: AppTheme.spacingSm),
                        _buildRewardRow('🏠', '今天没有把烟味带回家', '✓'),
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
                gradient: _isRelapsed ? null : AppColors.primaryGradient,
                color: _isRelapsed ? AppColors.surfaceVariant : null,
                boxShadow: _isRelapsed ? null : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                _isRelapsed ? Icons.favorite_border_rounded : Icons.check_rounded,
                color: _isRelapsed ? AppColors.textSecondary : Colors.white,
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
