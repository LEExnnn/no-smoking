import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_theme.dart';
import '../../router/app_routes.dart';
import '../../api/api_client.dart';
import '../../services/profile_engine.dart';
import '../../services/storage_service.dart';

/// 画像生成动画页
///
/// 展示分析过程，给用户仪式感
/// "正在分析你的吸烟模式" → "正在识别高危场景" → "正在生成戒烟策略" → "正在搭建专属首页"
class ProfileGeneratingScreen extends StatefulWidget {
  const ProfileGeneratingScreen({super.key});

  @override
  State<ProfileGeneratingScreen> createState() =>
      _ProfileGeneratingScreenState();
}

class _ProfileGeneratingScreenState extends State<ProfileGeneratingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentStep = 0;
  bool _isSubmitting = false;

  final _steps = [
    {'icon': Icons.psychology_rounded, 'text': '正在分析你的吸烟模式'},
    {'icon': Icons.radar_rounded, 'text': '正在识别你的高危场景'},
    {'icon': Icons.auto_fix_high_rounded, 'text': '正在生成你的戒烟策略'},
    {'icon': Icons.dashboard_customize_rounded, 'text': '正在搭建你的专属首页'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isSubmitting) {
      _isSubmitting = true;
      final answers = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
      _submitAndRunSteps(answers);
    }
  }

  void _submitAndRunSteps(Map<String, dynamic> answers) async {
    // 启动视觉步骤切换（不等待，让它在后台自己跑）
    _startFakeSteps();
    
    try {
      // 1. 本地计算画像
      final result = ProfileEngine.generateProfile(answers);
      
      // 2. 本地持久化保存
      await StorageService().saveProfile(result);
      
      // 等待至少让动画播完前面几步
      await Future.delayed(const Duration(milliseconds: 2500));
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.profileReport,
            arguments: result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('分析失败: $e，请稍后重试。')),
        );
        Navigator.pop(context); // 退回到问卷页
      }
    }
  }
  
  void _startFakeSteps() async {
    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;
      setState(() => _currentStep = i);
      await Future.delayed(const Duration(milliseconds: 1000));
    }
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 动画指示器
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary
                                .withValues(alpha: 0.3 * _controller.value),
                            blurRadius: 20 + 10 * _controller.value,
                            spreadRadius: 2 * _controller.value,
                          ),
                        ],
                      ),
                      child: Icon(
                        _steps[_currentStep]['icon'] as IconData,
                        color: Colors.white,
                        size: 36,
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppTheme.spacingXxl),

                // 步骤文字
                AnimatedSwitcher(
                  duration: AppTheme.animNormal,
                  child: Text(
                    _steps[_currentStep]['text'] as String,
                    key: ValueKey(_currentStep),
                    style: AppTypography.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: AppTheme.spacingXxl),

                // 进度条
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentStep + 1) / _steps.length,
                    minHeight: 4,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),

                const SizedBox(height: AppTheme.spacingLg),

                // 步骤指示
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_steps.length, (i) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i <= _currentStep
                            ? AppColors.primary
                            : AppColors.surfaceVariant,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
