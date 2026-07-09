import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_theme.dart';
import '../../router/app_routes.dart';

/// 烟瘾急救 - AI 短句接管
///
/// AI 根据触发原因 + 用户画像生成 3-5 句个性化短句
/// 不说教、不恐吓、不羞辱，直接给动作
class CravingRescueScreen extends StatefulWidget {
  const CravingRescueScreen({super.key});

  @override
  State<CravingRescueScreen> createState() => _CravingRescueScreenState();
}

class _CravingRescueScreenState extends State<CravingRescueScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentMessage = 0;

  // 模拟 AI 输出 - 后续对接 DeepSeek API
  final _messages = [
    '你现在不是需要烟。',
    '你是想从工作状态里出来。',
    '但"出去"对你来说就是抽烟动线。',
    '这次别下楼。',
    '我陪你过 90 秒。',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _showMessages();
  }

  void _showMessages() async {
    for (int i = 0; i < _messages.length; i++) {
      await Future.delayed(Duration(milliseconds: i == 0 ? 500 : 1200));
      if (mounted) {
        setState(() => _currentMessage = i);
        _controller.forward(from: 0);
      }
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
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXl),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // AI 消息列表
              ...List.generate(
                _currentMessage + 1,
                (i) => _buildMessage(i),
              ),

              const Spacer(flex: 2),

              // 按钮
              if (_currentMessage == _messages.length - 1) ...[
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.cravingTimer,
                        arguments: 90,
                      );
                    },
                    child: const Text(
                      '开始 90 秒倒计时',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.cravingTimer,
                          arguments: 180,
                        );
                      },
                      child: Text(
                        '3 分钟',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.cravingTimer,
                          arguments: 300,
                        );
                      },
                      child: Text(
                        '5 分钟（强烈烟瘾）',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: AppTheme.spacingXl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(int index) {
    final isLast = index == _currentMessage;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingLg),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: 1.0,
        child: Text(
          _messages[index],
          style: AppTypography.aiMessage.copyWith(
            color: isLast ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
