import 'json_utils.dart';

/// What earns a stamp (spec B2).
enum EarnRule { visit, payment }

enum ProgramStatus { active, paused }

class LoyaltyProgram {
  final String id;
  final int stampsRequired;
  final EarnRule earnRule;

  /// In-app payments below this do not earn a stamp; staff scans are trusted.
  final double? minSpend;
  final String rewardText;
  final String? terms;
  final int stampExpiryDays;
  final ProgramStatus status;

  /// Bumped when target or reward change. Cards keep their version (spec §8.9).
  final int version;

  /// Server-written plain-words version ("Visit 5 times, get a free haircut").
  final String summary;

  const LoyaltyProgram({
    required this.id,
    required this.stampsRequired,
    required this.earnRule,
    this.minSpend,
    required this.rewardText,
    this.terms,
    required this.stampExpiryDays,
    required this.status,
    required this.version,
    this.summary = '',
  });

  bool get isActive => status == ProgramStatus.active;

  factory LoyaltyProgram.fromJson(Json json) => LoyaltyProgram(
        id: readString(json['id']),
        stampsRequired: readInt(json['stampsRequired'], 1),
        earnRule: readEnum(EarnRule.values, json['earnRule'], EarnRule.visit),
        minSpend: readDoubleOrNull(json['minSpend']),
        rewardText: readString(json['rewardText']),
        terms: json['terms']?.toString(),
        stampExpiryDays: readInt(json['stampExpiryDays'], 180),
        status: readEnum(ProgramStatus.values, json['status'], ProgramStatus.active),
        version: readInt(json['version'], 1),
        summary: readString(json['summary']),
      );

  /// Body for `PUT /owner/businesses/:id/program`.
  Json toRequest() => {
        'stampsRequired': stampsRequired,
        'earnRule': enumWire(earnRule),
        'minSpend': minSpend,
        'rewardText': rewardText,
        if (terms != null && terms!.isNotEmpty) 'terms': terms,
        'stampExpiryDays': stampExpiryDays,
        'status': enumWire(status),
      };
}

/// A ready-made program to start from (B2 "Choose a template").
class ProgramTemplate {
  final String key;
  final String label;
  final int stampsRequired;
  final EarnRule earnRule;
  final double? minSpend;
  final String rewardText;
  final int stampExpiryDays;

  const ProgramTemplate({
    required this.key,
    required this.label,
    required this.stampsRequired,
    required this.earnRule,
    this.minSpend,
    required this.rewardText,
    required this.stampExpiryDays,
  });

  factory ProgramTemplate.fromJson(Json json) => ProgramTemplate(
        key: readString(json['key']),
        label: readString(json['label']),
        stampsRequired: readInt(json['stampsRequired'], 5),
        earnRule: readEnum(EarnRule.values, json['earnRule'], EarnRule.visit),
        minSpend: readDoubleOrNull(json['minSpend']),
        rewardText: readString(json['rewardText']),
        stampExpiryDays: readInt(json['stampExpiryDays'], 180),
      );
}
