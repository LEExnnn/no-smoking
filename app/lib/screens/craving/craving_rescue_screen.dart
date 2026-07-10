import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_theme.dart';
import '../../router/app_routes.dart';
import '../../api/api_client.dart';

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

  List<String> _messages = [];
  bool _isLoading = true;
  String _error = '';
  String? _eventId;
  String? _triggerKey;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_triggerKey == null) {
      _triggerKey = ModalRoute.of(context)?.settings.arguments as String? ?? 'unknown';
      _fetchMessages();
    }
  }

  void _fetchMessages() async {
    try {
      final res = await ApiClient().triggerCravingSOS(_triggerKey!);
      if (mounted) {
        setState(() {
          _messages = List<String>.from(res['messages'] ?? []);
          if (_messages.isEmpty) {
            _messages = ['深呼吸，承认这份渴望。', '这股冲动只要 90 秒就会过去。', '跟我一起，闭上眼睛。'];
          }
          _eventId = res['event_id'];
          _isLoading = false;
        });
        _showMessages();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages = ['没关系，深呼吸。', '网络好像有点慢，但冲动马上就会过去。', '我陪你度过接下来的 90 秒。'];
          _eventId = 'offline_event';
          _isLoading = false;
        });
        _showMessages();
      }
    }
  }

  void _showMessages() async {
    for (int i = 0; i < _messages.length; i++) {
      await Future.delayed(Duration(milliseconds: i == 0 ? 500 : 1800));
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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text('AI 戒烟教练正在赶来...', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
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
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.cravingTimer,
                        arguments: {'event_id': _eventId, 'duration': 90},
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
