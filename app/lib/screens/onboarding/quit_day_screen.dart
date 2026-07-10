import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_theme.dart';
import '../../router/app_routes.dart';
import '../../services/storage_service.dart';

/// 自由日选择页
///
/// 用户选择什么时候开始不抽烟
/// 支持"今天就开始"和"观察模式（先不戒，先了解自己）"
class QuitDayScreen extends StatefulWidget {
  const QuitDayScreen({super.key});

  @override
  State<QuitDayScreen> createState() => _QuitDayScreenState();
}

class _QuitDayScreenState extends State<QuitDayScreen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),

              Text(
                '你想什么时候\n开始你的自由？',
                style: AppTypography.displayMedium,
              ),

              const SizedBox(height: AppTheme.spacingSm),

              Text(
                '没有标准答案，选你准备好的那个',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: AppTheme.spacingXxl),

              // 选项
              _buildOption(
                key: 'today',
                emoji: '🔥',
                title: '今天就开始',
                description: '从现在起，不再喂烟瘾',
                isRecommended: true,
              ),

              const SizedBox(height: AppTheme.spacingMd),

              _buildOption(
                key: 'tomorrow',
                emoji: '🌅',
                title: '明天开始',
                description: '今晚做好准备，明早开始新的一天',
              ),

              const SizedBox(height: AppTheme.spacingMd),

              _buildOption(
                key: 'this_week',
                emoji: '📅',
                title: '这周内',
                description: '先用几天时间观察自己的吸烟模式',
              ),

              const SizedBox(height: AppTheme.spacingMd),

              _buildOption(
                key: 'observe',
                emoji: '👀',
                title: '先不戒，先观察',
                description: '不设目标，先记录和了解自己的习惯',
              ),

              const Spacer(flex: 2),

              // 按钮
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selected != null
                      ? () async {
                          if (_selected != 'observe') {
                            await StorageService().saveQuitDate(DateTime.now());
                          }
                          if (mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.home,
                              (route) => false,
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selected != null
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    foregroundColor: _selected != null
                        ? Colors.white
                        : AppColors.textTertiary,
                  ),
                  child: Text(
                    _selected == 'observe' ? '进入观察模式' : '开始我的自由',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingLg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required String key,
    required String emoji,
    required String title,
    required String description,
    bool isRecommended = false,
  }) {
    final isSelected = _selected == key;

    return GestureDetector(
      onTap: () => setState(() => _selected = key),
      child: AnimatedContainer(
        duration: AppTheme.animFast,
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTypography.labelLarge.copyWith(
                          color: isSelected
                              ? AppColors.primaryDark
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: Text(
                            '推荐',
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: AppTypography.bodySmall),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }
}
