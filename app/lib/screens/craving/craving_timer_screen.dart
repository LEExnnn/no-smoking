import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_theme.dart';
import '../../router/app_routes.dart';

/// 烟瘾急救 - 倒计时页面
///
/// 核心体验：烟雾随时间消散 + 呼吸波纹 + 每 30-60 秒出现短卡
/// 按钮：我还想抽 / 我已经过去了 / 重新开始
class CravingTimerScreen extends StatefulWidget {
  const CravingTimerScreen({super.key});

  @override
  State<CravingTimerScreen> createState() => _CravingTimerScreenState();
}

class _CravingTimerScreenState extends State<CravingTimerScreen>
    with TickerProviderStateMixin {
  late int _totalSeconds;
  late int _remainingSeconds;
  Timer? _timer;
  int _currentCardIndex = 0;

  late AnimationController _breathController;
  late AnimationController _smokeController;

  // 过程中出现的短卡
  final _cards = [
    '下楼不是休息，下楼是旧路径。',
    '这次你只需要把这段时间过完。',
    '烟瘾会催你，但它不能替你做决定。',
    '每一次不喂它，它就会弱一点。',
    '你想要的是休息，不是烟。',
  ];

  @override
  void initState() {
    super.initState();
    _totalSeconds = 90; // 默认值，会在 build 中从 arguments 获取
    _remainingSeconds = _totalSeconds;

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _smokeController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _totalSeconds),
    )..forward();

    _startTimer();
  }

  String? _eventId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _eventId = args['event_id'] as String?;
      final dur = args['duration'] as int?;
      if (dur != null && dur != _totalSeconds) {
        _totalSeconds = dur;
        _remainingSeconds = _totalSeconds;
        _smokeController.duration = Duration(seconds: _totalSeconds);
        _smokeController.forward(from: 0);
      }
    } else if (args is int && args != _totalSeconds) {
      _totalSeconds = args;
      _remainingSeconds = _totalSeconds;
      _smokeController.duration = Duration(seconds: _totalSeconds);
      _smokeController.forward(from: 0);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          // 每 30 秒切换短卡
          if (_remainingSeconds > 0 && _remainingSeconds % 30 == 0) {
            _currentCardIndex =
                (_currentCardIndex + 1) % _cards.length;
          }
        });
      } else {
        _timer?.cancel();
        _onCompleted();
      }
    });
  }

  void _onCompleted() {
    Navigator.pushReplacementNamed(
      context, 
      AppRoutes.cravingComplete,
      arguments: {
        'event_id': _eventId,
        'outcome': 'resisted'
      }
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathController.dispose();
    _smokeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalSeconds > 0
        ? (_totalSeconds - _remainingSeconds) / _totalSeconds
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // ─── 烟雾背景（随时间消散）────────────────
            AnimatedBuilder(
              animation: _smokeController,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _SmokePainter(
                    progress: _smokeController.value,
                  ),
                );
              },
            ),

            // ─── 主内容 ────────────────────────────
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // 呼吸波纹
                  AnimatedBuilder(
                    animation: _breathController,
                    builder: (context, child) {
                      return Container(
                        width: 160 + 20 * _breathController.value,
                        height: 160 + 20 * _breathController.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(
                              alpha: 0.15 + 0.1 * _breathController.value,
                            ),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(
                                alpha: 0.08,
                              ),
                            ),
                            child: Center(
                              // 倒计时数字
                              child: Text(
                                _formatTime(_remainingSeconds),
                                style: AppTypography.countdown,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppTheme.spacingMd),

                  // 呼吸提示
                  AnimatedBuilder(
                    animation: _breathController,
                    builder: (context, child) {
                      return Text(
                        _breathController.value < 0.5 ? '慢慢吸气...' : '慢慢呼气...',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppTheme.spacingXxxl),

                  // 短卡
                  AnimatedSwitcher(
                    duration: AppTheme.animNormal,
                    child: Container(
                      key: ValueKey(_currentCardIndex),
                      margin: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingXl),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingXl,
                        vertical: AppTheme.spacingLg,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMd),
                        boxShadow: AppTheme.shadowSm,
                      ),
                      child: Text(
                        _cards[_currentCardIndex],
                        style: AppTypography.aiMessage.copyWith(
                          fontSize: 16,
                          color: AppColors.primaryDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // 进度条
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingXl),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingXl),

                  // 按钮组
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingXl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: _onCompleted,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('我已经挺过去了', style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _remainingSeconds = _totalSeconds;
                                    _smokeController.forward(from: 0);
                                  });
                                },
                                child: const Text('重新开始倒计时'),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingMd),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.cravingComplete,
                                    arguments: {
                                      'event_id': _eventId,
                                      'outcome': 'relapsed',
                                    },
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.textTertiary,
                                ),
                                child: const Text('不行我忍不住了'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingXl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    if (mins > 0) {
      return '$mins:${secs.toString().padLeft(2, '0')}';
    }
    return '$secs';
  }
}

/// 烟雾消散画布
class _SmokePainter extends CustomPainter {
  final double progress;

  _SmokePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42); // 固定种子保证一致性
    final opacity = (1.0 - progress) * 0.15;

    for (int i = 0; i < 8; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.7;
      final radius = 40.0 + random.nextDouble() * 80;

      // 烟雾随进度上移并消散
      final offsetY = y - progress * 100 * (i + 1) / 8;

      final paint = Paint()
        ..color = AppColors.smokeMedium.withValues(alpha: opacity * (1 - i / 8))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

      canvas.drawCircle(
        Offset(x, offsetY),
        radius * (1 - progress * 0.3),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SmokePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
