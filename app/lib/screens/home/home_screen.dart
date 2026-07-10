import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_theme.dart';
import '../../router/app_routes.dart';
import '../../api/api_client.dart';
import '../../services/storage_service.dart';

/// 个性化首页
///
/// 首页是行动驾驶舱，不是信息堆叠
/// 6 个槽位：身份 + 动力 + 高危预警 + 急救入口 + 收益 + 今日任务
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 模拟数据 - 后续对接 API
  late Timer _timer;
  late Timer _quoteTimer;
  DateTime _quitDate = DateTime.now().subtract(const Duration(days: 2, hours: 8, minutes: 35));
  int _cravingsDefeated = 7;
  double _moneySaved = 48.0;
  
  final List<String> _quotes = [
    "“你不需要放弃任何东西，你只是在挣脱牢笼”",
    "“吸烟并不能填补空虚，它正是造成空虚的罪魁祸首”",
    "“你不是在戒烟，你是在成为一个不吸烟的人”",
    "“停止吸烟不需要意志力，只需要看清真相”",
    "“每一口烟都在向毒瘾妥协，今天，你赢了”",
  ];
  int _currentQuoteIndex = 0;

  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
    // 实时更新自由时间
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (mounted) setState(() {});
    });
    // 跑马灯定时器
    _quoteTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (mounted) {
        setState(() {
          _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length;
        });
      }
    });
  }

  Future<void> _fetchDashboard() async {
    final storage = StorageService();
    final qDate = storage.getQuitDate();
    
    if (mounted) {
      setState(() {
        if (qDate != null) {
          _quitDate = qDate;
        } else {
          _quitDate = DateTime.now();
        }
        _cravingsDefeated = storage.getCravingsDefeated();
        
        // 动态计算资金
        final profile = storage.getProfile();
        int cigsPerDay = profile?['cigarettes_per_day'] as int? ?? 10;
        double packPrice = (profile?['pack_price'] ?? 20.0).toDouble();
        int slipUps = storage.getSlipUps();
        
        double daysElapsed = DateTime.now().difference(_quitDate).inSeconds / (24 * 3600);
        if (daysElapsed < 0) daysElapsed = 0;
        
        double savedCigs = (daysElapsed * cigsPerDay) - slipUps;
        if (savedCigs < 0) savedCigs = 0;
        
        _moneySaved = savedCigs * (packPrice / 20.0);
        
        _isLoading = false;
      });
    }
  }


  @override
  void dispose() {
    _timer.cancel();
    _quoteTimer.cancel();
    super.dispose();
  }

  Duration get _freeDuration => DateTime.now().difference(_quitDate);

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // 主内容
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingXl,
                AppTheme.spacingLg,
                AppTheme.spacingXl,
                100, // 底部留出"我想抽了"按钮空间
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── 顶部问候 ─────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getGreeting(),
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.person_outline_rounded),
                        onPressed: () {},
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingMd),
                  
                  // ─── 理念强化跑马灯 ────────────────────────
                  _buildQuoteCarousel(),

                  const SizedBox(height: AppTheme.spacingLg),

                  // ─── 身份卡 ──────────────────────────
                  _buildIdentityCard(),

                  const SizedBox(height: AppTheme.spacingLg),

                  // ─── 收益卡 ──────────────────────────
                  Row(
                    children: [
                      Expanded(child: _buildMoneyCard()),
                      const SizedBox(width: AppTheme.spacingMd),
                      Expanded(child: _buildCravingCard()),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingLg),

                  // ─── 动力卡 ──────────────────────────
                  _buildMotivationCard(),

                  const SizedBox(height: AppTheme.spacingLg),

                  // ─── 高危预警 ─────────────────────────
                  _buildRiskCard(),

                  const SizedBox(height: AppTheme.spacingLg),

                  // ─── 今日任务 ─────────────────────────
                  _buildTodayTask(),
                ],
              ),
            ),

            // ─── 底部常驻"我想抽了"按钮 ────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildCravingButton(context),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return '深夜了，好好休息 🌙';
    if (hour < 12) return '早上好 ☀️';
    if (hour < 18) return '下午好 🌤️';
    return '晚上好 🌙';
  }

  /// 身份卡 - 自由时间
  Widget _buildIdentityCard() {
    final days = _freeDuration.inDays;
    final hours = _freeDuration.inHours % 24;
    final minutes = _freeDuration.inMinutes % 60;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '你已经自由了',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$days',
                style: AppTypography.numberDisplay.copyWith(
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4),
                child: Text(
                  '天',
                  style: AppTypography.headlineMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '$hours 小时 $minutes 分钟',
                  style: AppTypography.bodyLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Text(
              _getStageMessage(days),
              style: AppTypography.labelSmall.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStageMessage(int days) {
    if (days == 0) return '🔥 今天是你的自由日';
    if (days < 3) return '💪 你正在拆掉旧路径';
    if (days < 7) return '🌱 你已经不再自动抽烟';
    if (days < 21) return '🌿 你开始习惯无烟生活';
    if (days < 60) return '🌳 你不再围着烟安排时间';
    if (days < 180) return '🕊️ 你是不抽烟的人';
    return '🏆 烟已经不是你的生活选项';
  }

  /// 烟钱卡
  Widget _buildMoneyCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.goldSurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💰', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                '已省下',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '¥${_moneySaved.toStringAsFixed(0)}',
            style: AppTypography.numberMedium.copyWith(
              color: Color(0xFFB8860B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '这些钱没有变成烟灰',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  /// 击退烟瘾卡
  Widget _buildCravingCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🛡️', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                '击退烟瘾',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$_cravingsDefeated 次',
            style: AppTypography.numberMedium.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '每一次都让它更弱',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  /// 动力卡
  Widget _buildMotivationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: AppColors.pinkSurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Row(
        children: [
          const Text('👶', style: TextStyle(fontSize: 36)),
          const SizedBox(width: AppTheme.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '今天你没有把烟味带回家',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '宝宝无烟账户 +¥${_moneySaved.toStringAsFixed(0)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.pink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 高危预警卡
  Widget _buildRiskCard() {
    final hour = DateTime.now().hour;
    // 下午 2-4 点显示高危预警
    if (hour >= 14 && hour <= 16) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        decoration: BoxDecoration(
          color: AppColors.warningSurface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: AppColors.warning.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.shield_outlined, color: AppColors.warning, size: 28),
            const SizedBox(width: AppTheme.spacingLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '下午高危时段',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '你通常会在这个时间段想抽烟。今天不要下楼，先做 90 秒工位重置。',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  /// 今日任务
  Widget _buildTodayTask() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag_rounded,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '今日任务',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            '工作累了不要下楼',
            style: AppTypography.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            '先完成 90 秒工位重置，看看是不是真的需要烟',
            style: AppTypography.bodySmall,
          ),
        ],
      ),
    );
  }

  /// 底部常驻"我想抽了"按钮
  Widget _buildCravingButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background.withValues(alpha: 0.0),
            AppColors.background,
          ],
          stops: const [0.0, 0.3],
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.cravingTrigger);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.danger,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          elevation: 4,
        ),
        child: const Text(
          '不行，我想抽了',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildQuoteCarousel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd, vertical: AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(Icons.format_quote_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.2),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                _quotes[_currentQuoteIndex],
                key: ValueKey<int>(_currentQuoteIndex),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primaryDark,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
