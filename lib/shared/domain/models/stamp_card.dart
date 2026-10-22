import 'json_utils.dart';
import 'loyalty_program.dart';
import 'redemption.dart';

enum StampCardStatus { collecting, ready, redeemed }

enum StampSource { payment, staffScan, admin }

/// The business summary embedded in cards, payments and visits.
class BusinessRef {
  final String id;
  final String name;
  final String? logoUrl;
  final String? categoryName;
  final String? categoryIcon;

  const BusinessRef({required this.id, required this.name, this.logoUrl, this.categoryName, this.categoryIcon});

  factory BusinessRef.fromJson(Json? json) {
    final category = readMap(json?['category']);
    return BusinessRef(
      id: readString(json?['id']),
      name: readString(json?['name']),
      logoUrl: json?['logoUrl']?.toString(),
      categoryName: category?['name']?.toString(),
      categoryIcon: category?['icon']?.toString(),
    );
  }
}

class BranchRef {
  final String id;
  final String name;
  final String? address;

  const BranchRef({required this.id, required this.name, this.address});

  static BranchRef? fromJson(dynamic json) {
    final map = readMap(json);
    if (map == null) return null;
    return BranchRef(id: readString(map['id']), name: readString(map['name']), address: map['address']?.toString());
  }
}

class Stamp {
  final String id;
  final StampSource source;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final BranchRef? branch;

  /// `active`, `expired`, `used` — only active ones count toward the card.
  final String state;

  const Stamp({
    required this.id,
    required this.source,
    required this.createdAt,
    this.expiresAt,
    this.branch,
    this.state = 'active',
  });

  bool get isActive => state == 'active';

  factory Stamp.fromJson(Json json) => Stamp(
        id: readString(json['id']),
        source: readEnum(StampSource.values, json['source'], StampSource.staffScan),
        createdAt: readDate(json['createdAt']) ?? DateTime.now(),
        expiresAt: readDate(json['expiresAt']),
        branch: BranchRef.fromJson(json['branch']),
        state: readString(json['state'], 'active'),
      );
}

/// One customer's card at one business (spec §8.1). The list endpoint returns
/// the summary; `GET /me/cards/:id` adds [program], [stamps] and
/// [activeRedemption].
class StampCard {
  final String id;
  final String businessId;
  final BusinessRef business;
  final StampCardStatus status;
  final int stampsCount;

  /// The target this card started with; later program edits don't change it.
  final int stampsRequired;
  final int remaining;
  final double progress;
  final String rewardText;
  final int cycleNumber;
  final int programVersion;
  final DateTime? readyAt;
  final DateTime? nextStampExpiresAt;
  final LoyaltyProgram? program;
  final String? terms;
  final List<Stamp> stamps;
  final Redemption? activeRedemption;

  const StampCard({
    required this.id,
    required this.businessId,
    required this.business,
    required this.status,
    required this.stampsCount,
    required this.stampsRequired,
    required this.remaining,
    required this.progress,
    required this.rewardText,
    required this.cycleNumber,
    required this.programVersion,
    this.readyAt,
    this.nextStampExpiresAt,
    this.program,
    this.terms,
    this.stamps = const [],
    this.activeRedemption,
  });

  bool get isReady => status == StampCardStatus.ready;

  double get ratio => progress.clamp(0, 1).toDouble();

  factory StampCard.fromJson(Json json) {
    final program = readMap(json['program']);
    final redemption = readMap(json['activeRedemption']);
    final required = readInt(json['stampsRequired'], 1);
    final count = readInt(json['stampsCount']);
    return StampCard(
      id: readString(json['id']),
      businessId: readString(json['businessId'], readString(readMap(json['business'])?['id'])),
      business: BusinessRef.fromJson(readMap(json['business'])),
      status: readEnum(StampCardStatus.values, json['status'], StampCardStatus.collecting),
      stampsCount: count,
      stampsRequired: required,
      remaining: readInt(json['remaining'], (required - count).clamp(0, required)),
      progress: readDouble(json['progress'], required == 0 ? 0 : count / required),
      rewardText: readString(json['rewardText']),
      cycleNumber: readInt(json['cycleNumber'], 1),
      programVersion: readInt(json['programVersion'], 1),
      readyAt: readDate(json['readyAt']),
      nextStampExpiresAt: readDate(json['nextStampExpiresAt']),
      program: program == null ? null : LoyaltyProgram.fromJson(program),
      terms: json['terms']?.toString(),
      stamps: readList(json['stamps'], Stamp.fromJson),
      activeRedemption: redemption == null ? null : Redemption.fromJson(redemption),
    );
  }
}
