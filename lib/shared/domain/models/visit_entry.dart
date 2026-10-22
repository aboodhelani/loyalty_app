import 'json_utils.dart';
import 'stamp_card.dart';

/// One line of the customer's visit history (C12): a stamp, with the payment
/// behind it when there was one.
class VisitEntry {
  final String id;
  final StampSource source;
  final DateTime date;
  final BusinessRef business;
  final BranchRef? branch;
  final double? amount;
  final String? currency;
  final String? cardId;

  const VisitEntry({
    required this.id,
    required this.source,
    required this.date,
    required this.business,
    this.branch,
    this.amount,
    this.currency,
    this.cardId,
  });

  factory VisitEntry.fromJson(Json json) {
    final payment = readMap(json['payment']);
    return VisitEntry(
      id: readString(json['id']),
      source: readEnum(StampSource.values, json['source'], StampSource.staffScan),
      date: readDate(json['createdAt']) ?? DateTime.now(),
      business: BusinessRef.fromJson(readMap(json['business'])),
      branch: BranchRef.fromJson(json['branch']),
      amount: readDoubleOrNull(payment?['amount']),
      currency: payment?['currency']?.toString(),
      cardId: json['cardId']?.toString(),
    );
  }
}
