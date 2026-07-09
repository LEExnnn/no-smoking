import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_theme.dart';
import '../../router/app_routes.dart';

/// 烟瘾急救 - 触发原因选择
///
/// "这次想抽，是因为什么？"
/// 用户快速选择一个原因，系统立即启动 AI 急救
class CravingTriggerScreen extends StatelessWidget {
  const CravingTriggerScreen({super.key});

  static const _triggers = [
    {'emoji': '😫', 'label': '我累了', 'key': 'tired'},
    {'emoji': '😤', 'label': '我烦', 'key': 'irritated'},
    {'emoji': '😑', 'label': '我无聊', 'key': 'bored'},
    {'emoji': '🍜', 'label': '饭后习惯', 'key': 'after_meal'},
    {'emoji': '💻', 'label': '工作想休息', 'key': 'work_break'},
    {'emoji': '🤲', 'label': '别人递烟', 'key': 'offered'},
    {'emoji': '🍺', 'label': '喝酒了', 'key': 'drinking'},
    {'emoji': '🎮', 'label': '打游戏', 'key': 'gaming'},
    {'emoji': '🌙', 'label': '睡前', 'key': 'before_sleep'},
    {'emoji': '🤷', 'label': '我也不知道', 'key': 'unknown'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spacingLg),

              Text(
                '这次想抽',
                style: AppTypography.displayMedium,
              ),
              Text(
                '是因为什么？',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: AppTheme.spacingSm),

              Text(
                '选一个最接近的，不用太精确',
                style: AppTypography.bodySmall,
              ),

              const SizedBox(height: AppTheme.spacingXl),

              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: _triggers.length,
                  itemBuilder: (context, index) {
                    final trigger = _triggers[index];
                    return _TriggerCard(
                      emoji: trigger['emoji'] as String,
                      label: trigger['label'] as String,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.cravingRescue,
                          arguments: trigger['key'],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TriggerCard extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _TriggerCard({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
            vertical: AppTheme.spacingMd,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.labelLarge.copyWith(fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
