import 'json_utils.dart';
import 'stamp_card.dart';

enum TransactionStatus { pending, succeeded, failed, refunded }

/// Why a payment did not earn a stamp; null when it did. Kept as the raw API
/// value too, so a new reason still shows the server's [PaymentTransaction.stampMessage].
enum StampOutcome { awarded, dailyLimitReached, belowMinSpend, programPaused, unknown }

class PaymentTransaction {
  final String id;
  final TransactionStatus status;
  final double amount;
  final String currency;
  final String gateway;
  final String? gatewayRef;
  final DateTime createdAt;
  final BusinessRef business;
  final BranchRef? branch;
  final String customerFirstName;
  final String? failureReason;

  /// Filled once the webhook was processed.
  final String? stampOutcomeRaw;
  final String? stampMessage;
  final StampCard? card;

  const PaymentTransaction({
    required this.id,
    required this.status,
    required this.amount,
    required this.currency,
    required this.gateway,
    this.gatewayRef,
    required this.createdAt,
    required this.business,
    this.branch,
    required this.customerFirstName,
    this.failureReason,
    this.stampOutcomeRaw,
    this.stampMessage,
    this.card,
  });

  bool get isSettled => status != TransactionStatus.pending;

  StampOutcome? get stampOutcome {
    if (stampOutcomeRaw == null) return null;
    return readEnum(StampOutcome.values, stampOutcomeRaw, StampOutcome.unknown);
  }

  factory PaymentTransaction.fromJson(Json json) {
    final stamp = readMap(json['stamp']);
    final card = readMap(json['card']) ?? readMap(stamp?['card']);
    return PaymentTransaction(
      id: readString(json['id']),
      status: readEnum(TransactionStatus.values, json['status'], TransactionStatus.pending),
      amount: readDouble(json['amount']),
      currency: readString(json['currency'], 'AED'),
      gateway: readString(json['gateway']),
      gatewayRef: json['gatewayRef']?.toString(),
      createdAt: readDate(json['createdAt']) ?? DateTime.now(),
      business: BusinessRef.fromJson(readMap(json['business'])),
      branch: BranchRef.fromJson(json['branch']),
      customerFirstName: readString(readMap(json['customer'])?['firstName']),
      failureReason: json['failureReason']?.toString(),
      stampOutcomeRaw: json['stampOutcome']?.toString(),
      stampMessage: json['stampMessage']?.toString(),
      card: card == null ? null : StampCard.fromJson(card),
    );
  }
}
