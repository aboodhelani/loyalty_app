import 'json_utils.dart';
import 'loyalty_program.dart';
import 'stamp_card.dart';

/// What staff see after scanning a customer's QR (S1): first name only, the
/// program, and the customer's card here.
class ScanResult {
  final String customerId;
  final String firstName;
  final LoyaltyProgram? program;
  final StampCard? currentCard;
  final List<StampCard> readyCards;
  final bool canStampToday;

  /// Server-written reason when [canStampToday] is false.
  final String? blockedReason;

  const ScanResult({
    required this.customerId,
    required this.firstName,
    this.program,
    this.currentCard,
    this.readyCards = const [],
    required this.canStampToday,
    this.blockedReason,
  });

  int get stamps => currentCard?.stampsCount ?? 0;

  int get required => currentCard?.stampsRequired ?? program?.stampsRequired ?? 1;

  factory ScanResult.fromJson(Json json) {
    final customer = readMap(json['customer']) ?? const {};
    final program = readMap(json['program']);
    final card = readMap(json['currentCard']);
    return ScanResult(
      customerId: readString(customer['id']),
      firstName: readString(customer['firstName']),
      program: program == null ? null : LoyaltyProgram.fromJson(program),
      currentCard: card == null ? null : StampCard.fromJson(card),
      readyCards: readList(json['readyCards'], StampCard.fromJson),
      canStampToday: json['canStampToday'] != false,
      blockedReason: json['blockedReason']?.toString(),
    );
  }
}

/// Response of `POST /staff/stamps`.
class StaffStampResult {
  final StampCard card;
  final bool cardReady;

  const StaffStampResult({required this.card, required this.cardReady});

  factory StaffStampResult.fromJson(Json json) => StaffStampResult(
        card: StampCard.fromJson(readMap(json['card']) ?? const {}),
        cardReady: json['cardReady'] == true,
      );
}
