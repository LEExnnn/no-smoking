import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_theme.dart';
import '../../services/storage_service.dart';

class SlipUpComfortScreen extends StatefulWidget {
  const SlipUpComfortScreen({super.key});

  @override
  State<SlipUpComfortScreen> createState() => _SlipUpComfortScreenState();
}

class _SlipUpComfortScreenState extends State<SlipUpComfortScreen> {
  @override
  void initState() {
    super.initState();
    _recordSlipUp();
  }

  void _recordSlipUp() async {
    await StorageService().addSlipUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              const Icon(
                Icons.self_improvement_rounded,
                size: 80,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: AppTheme.spacingXxl),
              Text(
                '没关系，深呼吸',
                style: AppTypography.headlineLarge.copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              Text(
                '复吸是戒烟旅程中极其常见的一部分。它不代表你失败了，它只是一次数据收集。',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Text(
                  '不要过度自责。体会一下刚才那根烟真的好抽吗？还是只是一种虚幻的解脱感？\n\n我们不会清零你的戒烟天数。一次踉跄不代表要回到起点，原谅自己，继续前行。',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.6),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceVariant,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                ),
                child: const Text('原谅自己，继续前行', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: AppTheme.spacingLg),
            ],
          ),
        ),
      ),
    );
  }
}
