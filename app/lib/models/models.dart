/// 《这个APP能让你戒烟》- 数据模型
///
/// 对应后端数据库表结构

// ─── 用户画像 ──────────────────────────────────────────

/// 戒烟动机类型
enum MotivationType {
  health('健康', '🏥'),
  money('省钱', '💰'),
  baby('宝宝', '👶'),
  partner('伴侣', '❤️'),
  parents('父母', '👨‍👩‍👧'),
  image('形象', '✨'),
  smell('口气/烟味', '👃'),
  efficiency('工作效率', '⚡'),
  freedom('自由感', '🕊️'),
  dignity('自尊', '💪'),
  sneaking('不想偷偷摸摸', '🙈'),
  control('不想被烟控制', '🔓'),
  prove('想证明自己可以', '🏆');

  final String label;
  final String emoji;
  const MotivationType(this.label, this.emoji);
}

/// 吸烟触发场景
enum TriggerType {
  wakeUp('起床后', '🌅'),
  toilet('上厕所', '🚻'),
  afterMeal('吃饭后', '🍜'),
  workTired('工作累了', '💻'),
  codingBreak('写代码/办公间隙', '⌨️'),
  afterMeeting('开完会', '🤝'),
  afternoonTired('下午犯困', '😴'),
  stress('压力大', '😰'),
  irritated('情绪烦躁', '😤'),
  bored('无聊', '😑'),
  gaming('打游戏', '🎮'),
  scrolling('刷短视频', '📱'),
  coffee('喝咖啡', '☕'),
  drinking('喝酒', '🍺'),
  driving('开车', '🚗'),
  waiting('等人', '⏳'),
  offered('同事递烟', '🤲'),
  socializing('朋友聚会', '🎉'),
  beforeSleep('睡觉前', '🌙'),
  beforeHome('回家前', '🏠');

  final String label;
  final String emoji;
  const TriggerType(this.label, this.emoji);
}

/// 心理信念标签
enum BeliefTag {
  relaxation('烟能让我放松', '放松幻觉'),
  reward('烟是奖励自己', '奖励幻觉'),
  social('不抽烟社交会尴尬', '社交幻觉'),
  inspiration('烟让我有灵感', '灵感幻觉'),
  boredomFix('不抽烟人生无聊', '无聊补偿'),
  rebellion('人生总得有点不良嗜好', '反叛认同'),
  identity('我就是个烟民', '身份绑定'),
  lowConfidence('我觉得我戒不掉', '低自信预期'),
  willpower('戒烟主要靠意志力', '意志力误区');

  final String question;
  final String tag;
  const BeliefTag(this.question, this.tag);
}

/// 依赖程度
enum DependenceLevel {
  low('低依赖'),
  medium('中依赖'),
  mediumHigh('中高依赖'),
  high('高依赖'),
  professionalNeeded('建议专业支持');

  final String label;
  const DependenceLevel(this.label);
}

/// 戒烟阶段
enum QuitStage {
  observing('观察期', '还没决定戒，先了解'),
  preparing('准备期', '想戒但未开始'),
  quitDay('自由日', '今天开始不抽'),
  earlyQuit('早期戒烟', '第 1-7 天'),
  stabilizing('稳定期', '第 8-30 天'),
  identityBuilding('身份巩固', '30 天以上'),
  lapseRepair('偶然复吸', '抽了一支或少量'),
  relapseRecovery('恢复期', '需要重建计划');

  final String label;
  final String description;
  const QuitStage(this.label, this.description);
}

/// 用户吸烟画像
class SmokingProfile {
  final int smokingYears;
  final double cigarettesPerDay;
  final double packPrice;
  final int cigarettesPerPack;
  final String? firstCigaretteAfterWakeup;
  final int previousQuitAttempts;
  final int longestQuitDays;
  final String? relapseReason;
  final DependenceLevel dependenceLevel;

  const SmokingProfile({
    required this.smokingYears,
    required this.cigarettesPerDay,
    required this.packPrice,
    this.cigarettesPerPack = 20,
    this.firstCigaretteAfterWakeup,
    this.previousQuitAttempts = 0,
    this.longestQuitDays = 0,
    this.relapseReason,
    this.dependenceLevel = DependenceLevel.medium,
  });

  /// 每支烟价格
  double get pricePerCigarette => packPrice / cigarettesPerPack;

  /// 每日烟钱
  double get dailyCost => pricePerCigarette * cigarettesPerDay;

  /// 年度烟钱
  double get yearlyCost => dailyCost * 365;

  factory SmokingProfile.fromJson(Map<String, dynamic> json) {
    return SmokingProfile(
      smokingYears: json['smoking_years'] as int,
      cigarettesPerDay: (json['cigarettes_per_day'] as num).toDouble(),
      packPrice: (json['pack_price'] as num).toDouble(),
      cigarettesPerPack: json['cigarettes_per_pack'] as int? ?? 20,
      firstCigaretteAfterWakeup:
          json['first_cigarette_after_wakeup'] as String?,
      previousQuitAttempts: json['previous_quit_attempts'] as int? ?? 0,
      longestQuitDays: json['longest_quit_days'] as int? ?? 0,
      relapseReason: json['relapse_reason'] as String?,
      dependenceLevel: DependenceLevel.values.firstWhere(
        (e) => e.name == json['dependence_level'],
        orElse: () => DependenceLevel.medium,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'smoking_years': smokingYears,
        'cigarettes_per_day': cigarettesPerDay,
        'pack_price': packPrice,
        'cigarettes_per_pack': cigarettesPerPack,
        'first_cigarette_after_wakeup': firstCigaretteAfterWakeup,
        'previous_quit_attempts': previousQuitAttempts,
        'longest_quit_days': longestQuitDays,
        'relapse_reason': relapseReason,
        'dependence_level': dependenceLevel.name,
      };
}

/// 用户戒烟画像（完整）
class UserQuitProfile {
  final List<String> userTypes;
  final Map<String, double> motivationWeights;
  final Map<String, double> triggerWeights;
  final List<String> beliefTags;
  final QuitStage stage;
  final List<String> recommendedModules;
  final DateTime? quitDate;
  final DateTime createdAt;

  const UserQuitProfile({
    required this.userTypes,
    required this.motivationWeights,
    required this.triggerWeights,
    required this.beliefTags,
    required this.stage,
    required this.recommendedModules,
    this.quitDate,
    required this.createdAt,
  });

  /// 主要动机
  String get primaryMotivation {
    if (motivationWeights.isEmpty) return 'health';
    return motivationWeights.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// 主要触发
  String get primaryTrigger {
    if (triggerWeights.isEmpty) return 'stress';
    return triggerWeights.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  factory UserQuitProfile.fromJson(Map<String, dynamic> json) {
    return UserQuitProfile(
      userTypes: List<String>.from(json['user_types'] ?? []),
      motivationWeights:
          Map<String, double>.from(json['motivation_weights'] ?? {}),
      triggerWeights: Map<String, double>.from(json['trigger_weights'] ?? {}),
      beliefTags: List<String>.from(json['belief_tags'] ?? []),
      stage: QuitStage.values.firstWhere(
        (e) => e.name == json['stage'],
        orElse: () => QuitStage.preparing,
      ),
      recommendedModules:
          List<String>.from(json['recommended_modules'] ?? []),
      quitDate: json['quit_date'] != null
          ? DateTime.parse(json['quit_date'] as String)
          : null,
      createdAt: DateTime.parse(
          json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_types': userTypes,
        'motivation_weights': motivationWeights,
        'trigger_weights': triggerWeights,
        'belief_tags': beliefTags,
        'stage': stage.name,
        'recommended_modules': recommendedModules,
        'quit_date': quitDate?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };
}

// ─── 烟瘾事件 ──────────────────────────────────────────

/// 烟瘾急救结果
enum CravingOutcome {
  resisted('抵抗成功'),
  smoked('还是抽了'),
  skipped('跳过'),
  unknown('未记录');

  final String label;
  const CravingOutcome(this.label);
}

/// 烟瘾事件
class CravingEvent {
  final String id;
  final String triggerType;
  final int intensity;
  final DateTime startedAt;
  final DateTime? resolvedAt;
  final String? interventionUsed;
  final CravingOutcome outcome;

  const CravingEvent({
    required this.id,
    required this.triggerType,
    required this.intensity,
    required this.startedAt,
    this.resolvedAt,
    this.interventionUsed,
    this.outcome = CravingOutcome.unknown,
  });

  /// 持续时长
  Duration? get duration =>
      resolvedAt != null ? resolvedAt!.difference(startedAt) : null;

  factory CravingEvent.fromJson(Map<String, dynamic> json) {
    return CravingEvent(
      id: json['id'] as String,
      triggerType: json['trigger_type'] as String,
      intensity: json['intensity'] as int,
      startedAt: DateTime.parse(json['started_at'] as String),
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      interventionUsed: json['intervention_used'] as String?,
      outcome: CravingOutcome.values.firstWhere(
        (e) => e.name == json['outcome'],
        orElse: () => CravingOutcome.unknown,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'trigger_type': triggerType,
        'intensity': intensity,
        'started_at': startedAt.toIso8601String(),
        'resolved_at': resolvedAt?.toIso8601String(),
        'intervention_used': interventionUsed,
        'outcome': outcome.name,
      };
}

// ─── 复吸事件 ──────────────────────────────────────────

/// 复吸事件
class LapseEvent {
  final String id;
  final int smokedCount;
  final DateTime occurredAt;
  final String? triggerType;
  final String? locationType;
  final String? socialContext;
  final String? emotionBefore;
  final String? source;
  final String? feltAfter;
  final Map<String, dynamic>? aiAnalysis;
  final List<String>? nextPlan;

  const LapseEvent({
    required this.id,
    required this.smokedCount,
    required this.occurredAt,
    this.triggerType,
    this.locationType,
    this.socialContext,
    this.emotionBefore,
    this.source,
    this.feltAfter,
    this.aiAnalysis,
    this.nextPlan,
  });

  factory LapseEvent.fromJson(Map<String, dynamic> json) {
    return LapseEvent(
      id: json['id'] as String,
      smokedCount: json['smoked_count'] as int,
      occurredAt: DateTime.parse(json['occurred_at'] as String),
      triggerType: json['trigger_type'] as String?,
      locationType: json['location_type'] as String?,
      socialContext: json['social_context'] as String?,
      emotionBefore: json['emotion_before'] as String?,
      source: json['source'] as String?,
      feltAfter: json['felt_after'] as String?,
      aiAnalysis: json['ai_analysis'] as Map<String, dynamic>?,
      nextPlan: json['next_plan'] != null
          ? List<String>.from(json['next_plan'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'smoked_count': smokedCount,
        'occurred_at': occurredAt.toIso8601String(),
        'trigger_type': triggerType,
        'location_type': locationType,
        'social_context': socialContext,
        'emotion_before': emotionBefore,
        'source': source,
        'felt_after': feltAfter,
        'ai_analysis': aiAnalysis,
        'next_plan': nextPlan,
      };
}

// ─── 烟钱账户 ──────────────────────────────────────────

/// 账户类型
enum MoneyAccountType {
  selfReward('自我奖励', '🎁'),
  baby('宝宝账户', '👶'),
  partner('伴侣礼物', '💝'),
  familyTrip('家庭旅行', '✈️'),
  digital('数码产品', '📱'),
  gaming('游戏', '🎮'),
  saving('存钱', '🏦'),
  custom('自定义', '⭐');

  final String label;
  final String emoji;
  const MoneyAccountType(this.label, this.emoji);
}

/// 烟钱账户
class MoneyAccount {
  final String id;
  final MoneyAccountType type;
  final String name;
  final double targetAmount;
  final double savedAmount;

  const MoneyAccount({
    required this.id,
    required this.type,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
  });

  /// 完成进度 0.0 ~ 1.0
  double get progress =>
      targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  /// 剩余金额
  double get remaining => (targetAmount - savedAmount).clamp(0.0, double.infinity);

  factory MoneyAccount.fromJson(Map<String, dynamic> json) {
    return MoneyAccount(
      id: json['id'] as String,
      type: MoneyAccountType.values.firstWhere(
        (e) => e.name == json['account_type'],
        orElse: () => MoneyAccountType.custom,
      ),
      name: json['name'] as String,
      targetAmount: (json['target_amount'] as num).toDouble(),
      savedAmount: (json['saved_amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'account_type': type.name,
        'name': name,
        'target_amount': targetAmount,
        'saved_amount': savedAmount,
      };
}

// ─── 首页数据 ──────────────────────────────────────────

/// 首页槽位数据
class HomeData {
  final IdentityCard identityCard;
  final MotivationCard primaryMotivationCard;
  final RiskCard? riskCard;
  final MoneyCard moneyCard;
  final TodayTask todayTask;

  const HomeData({
    required this.identityCard,
    required this.primaryMotivationCard,
    this.riskCard,
    required this.moneyCard,
    required this.todayTask,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      identityCard: IdentityCard.fromJson(json['identity_card']),
      primaryMotivationCard:
          MotivationCard.fromJson(json['primary_motivation_card']),
      riskCard: json['risk_card'] != null
          ? RiskCard.fromJson(json['risk_card'])
          : null,
      moneyCard: MoneyCard.fromJson(json['money_card']),
      todayTask: TodayTask.fromJson(json['today_task']),
    );
  }
}

class IdentityCard {
  final int freeDays;
  final int freeHours;
  final int freeMinutes;
  final QuitStage stage;
  final String stageMessage;

  const IdentityCard({
    required this.freeDays,
    required this.freeHours,
    required this.freeMinutes,
    required this.stage,
    required this.stageMessage,
  });

  factory IdentityCard.fromJson(Map<String, dynamic> json) {
    return IdentityCard(
      freeDays: json['free_days'] as int,
      freeHours: json['free_hours'] as int,
      freeMinutes: json['free_minutes'] as int,
      stage: QuitStage.values.firstWhere(
        (e) => e.name == json['stage'],
        orElse: () => QuitStage.preparing,
      ),
      stageMessage: json['stage_message'] as String,
    );
  }
}

class MotivationCard {
  final String type;
  final String message;
  final String emoji;

  const MotivationCard({
    required this.type,
    required this.message,
    required this.emoji,
  });

  factory MotivationCard.fromJson(Map<String, dynamic> json) {
    return MotivationCard(
      type: json['type'] as String,
      message: json['message'] as String,
      emoji: json['emoji'] as String? ?? '✨',
    );
  }
}

class RiskCard {
  final int riskScore;
  final String riskLevel;
  final String message;
  final String? suggestedAction;

  const RiskCard({
    required this.riskScore,
    required this.riskLevel,
    required this.message,
    this.suggestedAction,
  });

  factory RiskCard.fromJson(Map<String, dynamic> json) {
    return RiskCard(
      riskScore: json['risk_score'] as int,
      riskLevel: json['risk_level'] as String,
      message: json['message'] as String,
      suggestedAction: json['suggested_action'] as String?,
    );
  }
}

class MoneyCard {
  final double savedToday;
  final double savedTotal;
  final double yearlyProjection;
  final int cigarettesAvoided;
  final String message;

  const MoneyCard({
    required this.savedToday,
    required this.savedTotal,
    required this.yearlyProjection,
    required this.cigarettesAvoided,
    required this.message,
  });

  factory MoneyCard.fromJson(Map<String, dynamic> json) {
    return MoneyCard(
      savedToday: (json['saved_today'] as num).toDouble(),
      savedTotal: (json['saved_total'] as num).toDouble(),
      yearlyProjection: (json['yearly_projection'] as num).toDouble(),
      cigarettesAvoided: json['cigarettes_avoided'] as int,
      message: json['message'] as String,
    );
  }
}

class TodayTask {
  final String task;
  final String description;
  final bool completed;

  const TodayTask({
    required this.task,
    required this.description,
    this.completed = false,
  });

  factory TodayTask.fromJson(Map<String, dynamic> json) {
    return TodayTask(
      task: json['task'] as String,
      description: json['description'] as String,
      completed: json['completed'] as bool? ?? false,
    );
  }
}

// ─── AI 响应 ──────────────────────────────────────────

/// AI 急救响应
class AiRescueResponse {
  final List<String> messages;
  final String recommendedAction;
  final int timerSeconds;
  final String tone;
  final String safetyLevel;

  const AiRescueResponse({
    required this.messages,
    required this.recommendedAction,
    required this.timerSeconds,
    this.tone = 'firm_warm',
    this.safetyLevel = 'normal',
  });

  factory AiRescueResponse.fromJson(Map<String, dynamic> json) {
    return AiRescueResponse(
      messages: List<String>.from(json['messages'] ?? json['message'] ?? []),
      recommendedAction: json['recommended_action'] as String? ?? 'standard_3min',
      timerSeconds: json['timer_seconds'] as int? ?? 180,
      tone: json['tone'] as String? ?? 'firm_warm',
      safetyLevel: json['safety_level'] as String? ?? 'normal',
    );
  }
}
