import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_theme.dart';
import '../../router/app_routes.dart';
import '../../models/models.dart';

/// 戒烟心理扫描问卷
///
/// 卡片式交互，一次只问一个问题
/// 减少用户压力，支持跳过，支持"我也不知道"
/// 问卷分为 5 个模块（对应画像 8 维度中最核心的 5 个）
class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late final List<QuestionCard> _questions;

  // 用户答案
  final Map<String, dynamic> _answers = {};

  @override
  void initState() {
    super.initState();
    _questions = _buildQuestions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<QuestionCard> _buildQuestions() {
    return [
      // ─── A. 你和烟的关系 ──────────────────────────
      QuestionCard(
        key: 'smoke_start_age',
        section: 'A',
        sectionTitle: '你和烟的关系',
        question: '你大概什么时候开始抽烟？',
        type: QuestionType.singleChoice,
        options: [
          '初中或更早',
          '高中',
          '大学',
          '工作以后',
          '最近几年',
        ],
      ),

      QuestionCard(
        key: 'smoke_identity',
        section: 'A',
        sectionTitle: '你和烟的关系',
        question: '你觉得烟最像什么？',
        subtitle: '选一个最符合你感受的',
        type: QuestionType.singleChoice,
        options: [
          '🧑‍🤝‍🧑 朋友',
          '🎁 奖励',
          '🛋️ 放松',
          '🔄 习惯',
          '🤗 陪伴',
          '🤝 社交工具',
          '😤 烦人的东西',
          '🔒 控制我的东西',
        ],
      ),

      // ─── B. 吸烟信息 ──────────────────────────────
      QuestionCard(
        key: 'cigarettes_per_day',
        section: 'B',
        sectionTitle: '你的吸烟习惯',
        question: '你一天大概抽几支？',
        type: QuestionType.singleChoice,
        options: [
          '1-5 支',
          '6-10 支',
          '11-15 支',
          '16-20 支（约一包）',
          '一包以上',
        ],
      ),

      QuestionCard(
        key: 'pack_price',
        section: 'B',
        sectionTitle: '你的吸烟习惯',
        question: '你常抽的烟多少钱一包？',
        type: QuestionType.singleChoice,
        options: [
          '15 元以下',
          '15-25 元',
          '25-40 元',
          '40-60 元',
          '60 元以上',
        ],
      ),

      QuestionCard(
        key: 'first_cigarette',
        section: 'B',
        sectionTitle: '你的吸烟习惯',
        question: '早上醒来多久会抽第一支？',
        subtitle: '这能帮助我们了解你的依赖程度',
        type: QuestionType.singleChoice,
        options: [
          '5 分钟以内',
          '5-30 分钟',
          '30 分钟到 1 小时',
          '1 小时以后',
          '不一定，看情况',
        ],
      ),

      // ─── C. 什么时候想抽 ─────────────────────────
      QuestionCard(
        key: 'triggers',
        section: 'C',
        sectionTitle: '什么时候最想抽',
        question: '下面哪些场景你会想抽烟？',
        subtitle: '选所有符合的，后面我们会一个个处理',
        type: QuestionType.multiChoice,
        options: TriggerType.values
            .map((t) => '${t.emoji} ${t.label}')
            .toList(),
      ),

      // ─── D. 为什么想戒 ──────────────────────────
      QuestionCard(
        key: 'motivations',
        section: 'D',
        sectionTitle: '你为什么想戒',
        question: '哪些原因让你真的想停下来？',
        subtitle: '选所有对你重要的',
        type: QuestionType.multiChoice,
        options: MotivationType.values
            .map((m) => '${m.emoji} ${m.label}')
            .toList(),
      ),

      QuestionCard(
        key: 'top_motivations',
        section: 'D',
        sectionTitle: '你为什么想戒',
        question: '最能让你停下来的 3 个理由？',
        subtitle: '按重要程度排序，最重要的先选',
        type: QuestionType.rankedChoice,
        maxSelections: 3,
        options: MotivationType.values
            .map((m) => '${m.emoji} ${m.label}')
            .toList(),
      ),

      // ─── E. 你的信念 ──────────────────────────────
      QuestionCard(
        key: 'beliefs',
        section: 'E',
        sectionTitle: '你对烟的看法',
        question: '下面哪些想法你有过？',
        subtitle: '选了不丢人，我们后面会一起拆掉这些想法',
        type: QuestionType.multiChoice,
        options: [
          '抽烟能让我放松',
          '饭后一支烟很舒服',
          '工作累了抽一支能恢复状态',
          '抽烟是奖励自己',
          '不抽烟人生会少点意思',
          '社交场合不抽烟会尴尬',
          '戒烟主要靠意志力',
          '我觉得我可能戒不掉',
        ],
      ),

      // ─── F. 戒烟史 ────────────────────────────────
      QuestionCard(
        key: 'quit_history',
        section: 'F',
        sectionTitle: '你的戒烟经历',
        question: '你以前尝试过戒烟吗？',
        type: QuestionType.singleChoice,
        options: [
          '没有，这是第一次',
          '试过 1 次',
          '试过 2-3 次',
          '试过很多次了',
          '一直在断断续续',
        ],
      ),

      QuestionCard(
        key: 'quit_fear',
        section: 'F',
        sectionTitle: '你的戒烟经历',
        question: '你最害怕失去什么？',
        subtitle: '这个问题很重要，请真实回答',
        type: QuestionType.multiChoice,
        options: [
          '😰 怕没法放松',
          '😑 怕生活无聊',
          '😬 怕社交尴尬',
          '😤 怕压力没出口',
          '💤 怕工作没状态',
          '😞 怕戒了又复吸',
          '😔 怕自己坚持不住',
          '🎭 怕人生太规矩',
        ],
      ),

      // ─── G. 支持环境 ──────────────────────────────
      QuestionCard(
        key: 'has_baby',
        section: 'G',
        sectionTitle: '你的生活',
        question: '你有孩子吗？',
        type: QuestionType.singleChoice,
        options: [
          '👶 有，还小',
          '🧒 有，已经大了',
          '🤰 伴侣怀孕中',
          '❌ 没有',
        ],
      ),

      QuestionCard(
        key: 'support_env',
        section: 'G',
        sectionTitle: '你的生活',
        question: '你身边的环境是怎样的？',
        subtitle: '选所有符合的',
        type: QuestionType.multiChoice,
        options: [
          '家人支持我戒烟',
          '伴侣反感烟味',
          '同事经常抽烟',
          '工作地点靠近吸烟区',
          '朋友经常递烟',
          '我愿意公开戒烟',
          '我想隐私戒烟',
        ],
      ),
    ];
  }

  void _nextPage() {
    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: AppTheme.animNormal,
        curve: AppTheme.animCurve,
      );
    } else {
      // 问卷完成，进入画像生成
      Navigator.pushNamed(context, AppRoutes.profileGenerating,
          arguments: _answers);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: AppTheme.animNormal,
        curve: AppTheme.animCurve,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                onPressed: _previousPage,
              )
            : null,
        title: _buildProgressIndicator(),
        actions: [
          TextButton(
            onPressed: _nextPage,
            child: Text(
              '跳过',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (page) => setState(() => _currentPage = page),
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final question = _questions[index];
          return _buildQuestionPage(question);
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progress = (_currentPage + 1) / _questions.length;
    return Column(
      children: [
        Text(
          '${_currentPage + 1} / ${_questions.length}',
          style: AppTypography.labelSmall,
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 3,
            backgroundColor: AppColors.surfaceVariant,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionPage(QuestionCard question) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spacingLg),

          // Section 标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Text(
              question.sectionTitle,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacingLg),

          // 问题
          Text(
            question.question,
            style: AppTypography.headlineLarge,
          ),

          if (question.subtitle != null) ...[
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              question.subtitle!,
              style: AppTypography.bodySmall,
            ),
          ],

          const SizedBox(height: AppTheme.spacingXl),

          // 选项
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _isSelected(question.key, option);

            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
              child: _buildOptionCard(
                option: option,
                isSelected: isSelected,
                onTap: () => _onOptionTap(question, option, index),
              ),
            );
          }),

          const SizedBox(height: AppTheme.spacingXl),

          // "我也不知道" 按钮
          if (question.type == QuestionType.singleChoice)
            Center(
              child: TextButton(
                onPressed: () {
                  _answers[question.key] = '不确定';
                  _nextPage();
                },
                child: Text(
                  '我也不知道',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

          // 多选确认按钮
          if (question.type == QuestionType.multiChoice ||
              question.type == QuestionType.rankedChoice)
            Padding(
              padding: const EdgeInsets.only(top: AppTheme.spacingMd),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage < _questions.length - 1 ? '下一题' : '完成扫描',
                  ),
                ),
              ),
            ),

          const SizedBox(height: AppTheme.spacingXxxl),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String option,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: AppTheme.animFast,
      child: Material(
        color: isSelected ? AppColors.primarySurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLg,
              vertical: AppTheme.spacingLg,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.borderLight,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    option,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isSelected(String key, String option) {
    final answer = _answers[key];
    if (answer is List) {
      return answer.contains(option);
    }
    return answer == option;
  }

  void _onOptionTap(QuestionCard question, String option, int index) {
    setState(() {
      switch (question.type) {
        case QuestionType.singleChoice:
          _answers[question.key] = option;
          // 单选自动前进
          Future.delayed(const Duration(milliseconds: 300), _nextPage);
          break;

        case QuestionType.multiChoice:
          final list = List<String>.from(
              (_answers[question.key] as List<String>?) ?? []);
          if (list.contains(option)) {
            list.remove(option);
          } else {
            list.add(option);
          }
          _answers[question.key] = list;
          break;

        case QuestionType.rankedChoice:
          final list = List<String>.from(
              (_answers[question.key] as List<String>?) ?? []);
          if (list.contains(option)) {
            list.remove(option);
          } else if (list.length < (question.maxSelections ?? 3)) {
            list.add(option);
          }
          _answers[question.key] = list;
          break;
      }
    });
  }
}

// ─── 问题数据结构 ──────────────────────────────────────

enum QuestionType { singleChoice, multiChoice, rankedChoice }

class QuestionCard {
  final String key;
  final String section;
  final String sectionTitle;
  final String question;
  final String? subtitle;
  final QuestionType type;
  final List<String> options;
  final int? maxSelections;

  const QuestionCard({
    required this.key,
    required this.section,
    required this.sectionTitle,
    required this.question,
    this.subtitle,
    required this.type,
    required this.options,
    this.maxSelections,
  });
}
