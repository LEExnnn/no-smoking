import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_theme.dart';
import '../../router/app_routes.dart';

/// 画像报告页
///
/// 展示 AI 分析结果：用户类型、核心动机、高危场景、错误信念、最佳策略
/// 让用户感觉"被理解了"，建立产品信任
class ProfileReportScreen extends StatefulWidget {
  const ProfileReportScreen({super.key});

  @override
  State<ProfileReportScreen> createState() => _ProfileReportScreenState();
}

class _ProfileReportScreenState extends State<ProfileReportScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    
    final userTypes = (profile['user_types'] as List<dynamic>?)?.join(' · ') ?? '常规型';
    final primaryMotivation = profile['primary_motivation'] ?? '健康';
    final primaryTrigger = profile['primary_trigger'] ?? '压力';
    final beliefTags = (profile['belief_tags'] as List<dynamic>?)?.join(' · ') ?? '暂无明显错误信念';
    final modules = profile['recommended_modules'] as List<dynamic>? ?? ['ai_rescue'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spacingLg),

              // 标题
              Text(
                '你的吸烟模式',
                style: AppTypography.displayMedium,
              ),
              Text(
                '不是随机发生的',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: AppTheme.spacingXxl),

              // 用户类型
              _buildReportSection(
                icon: Icons.person_outline_rounded,
                title: '你的烟民类型',
                content: userTypes,
                description: '系统根据你的吸烟习惯、年龄、依赖程度为你识别的综合心理类型。',
                color: AppColors.blue,
                surfaceColor: AppColors.blueSurface,
              ),

              _buildReportSection(
                icon: Icons.favorite_outline_rounded,
                title: '你的核心动力',
                content: primaryMotivation,
                description: '这是你内心深处最在乎的事情，也是我们之后构建动力系统的核心。',
                color: AppColors.pink,
                surfaceColor: AppColors.pinkSurface,
              ),

              _buildReportSection(
                icon: Icons.warning_amber_rounded,
                title: '你的最大风险',
                content: primaryTrigger,
                description: '这个场景是你复吸概率最高的地方，也是我们急救系统会重点布防的区域。',
                color: AppColors.warning,
                surfaceColor: AppColors.warningSurface,
              ),

              _buildReportSection(
                icon: Icons.lightbulb_outline_rounded,
                title: '你的潜在卡点',
                content: beliefTags,
                description: '你想要的不是烟，而是底层的心理需求。我们会用更健康的方式来满足它。',
                color: AppColors.purple,
                surfaceColor: AppColors.purpleSurface,
              ),

              const SizedBox(height: AppTheme.spacingXxl),

              // 推荐模块
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacingXl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  boxShadow: AppTheme.shadowSm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '为你开启的功能',
                      style: AppTypography.headlineSmall,
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                    ...modules.map((m) => _buildModuleChip('✨ $m')),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacingXxl),

              // 进入按钮
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.quitDay);
                  },
                  child: const Text(
                    '选择我的自由日',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
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

  Widget _buildReportSection({
    required IconData icon,
    required String title,
    required String content,
    required String description,
    required Color color,
    required Color surfaceColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingLg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTypography.labelMedium.copyWith(color: color),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              content,
              style: AppTypography.headlineSmall.copyWith(
                color: color,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              description,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
