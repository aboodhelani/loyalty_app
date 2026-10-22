import 'json_utils.dart';
import 'transaction.dart';

enum ActivityRange { today, week, month }

extension ActivityRangeX on ActivityRange {
  /// Value for `?range=`.
  String get wire =>
      switch (this) { ActivityRange.today => 'today', ActivityRange.week => '7d', ActivityRange.month => '30d' };
}

class ActivityPoint {
  final DateTime date;
  final int payments;
  final double revenue;
  final int stamps;
  final int redemptions;

  const ActivityPoint({
    required this.date,
    required this.payments,
    required this.revenue,
    required this.stamps,
    required this.redemptions,
  });

  factory ActivityPoint.fromJson(Json json) => ActivityPoint(
        date: DateTime.tryParse(readString(json['date'])) ?? DateTime.now(),
        payments: readInt(json['payments']),
        revenue: readDouble(json['revenue']),
        stamps: readInt(json['stamps']),
        redemptions: readInt(json['redemptions']),
      );
}

/// Owner dashboard for one range (B4).
class ActivitySummary {
  final int payments;
  final double revenue;
  final String currency;
  final int stampsIssued;
  final int rewardsRedeemed;
  final int customers;
  final int newCustomers;
  final int returningCustomers;
  final List<ActivityPoint> series;
  final List<PaymentTransaction> recentTransactions;

  const ActivitySummary({
    required this.payments,
    required this.revenue,
    required this.currency,
    required this.stampsIssued,
    required this.rewardsRedeemed,
    required this.customers,
    required this.newCustomers,
    required this.returningCustomers,
    this.series = const [],
    this.recentTransactions = const [],
  });

  factory ActivitySummary.fromJson(Json json) {
    final totals = readMap(json['totals']) ?? const {};
    return ActivitySummary(
      payments: readInt(totals['payments']),
      revenue: readDouble(totals['revenue']),
      currency: readString(totals['currency'], 'AED'),
      stampsIssued: readInt(totals['stampsIssued']),
      rewardsRedeemed: readInt(totals['rewardsRedeemed']),
      customers: readInt(totals['customers']),
      newCustomers: readInt(totals['newCustomers']),
      returningCustomers: readInt(totals['returningCustomers']),
      series: readList(json['series'], ActivityPoint.fromJson),
      recentTransactions: readList(json['recentTransactions'], PaymentTransaction.fromJson),
    );
  }
}
