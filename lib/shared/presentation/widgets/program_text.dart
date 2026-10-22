import '../../../core/helper/helper.dart';
import '../../../core/translations/l10n.dart';
import '../../domain/models/loyalty_program.dart';
import '../../domain/models/transaction.dart';

/// The program in plain words — "Visit 5 times, get a free haircut" (C5).
String programSummary(S s, LoyaltyProgram program) {
  return program.earnRule == EarnRule.payment
      ? s.programPayment(program.stampsRequired, program.rewardText)
      : s.programVisit(program.stampsRequired, program.rewardText);
}

String? programMinSpend(S s, LoyaltyProgram program) {
  final min = program.minSpend;
  return min == null ? null : s.minSpendPerStamp(Helper.formatMoney(min));
}

/// Fallback text for a payment that did not earn a stamp, when the server did
/// not send its own `stampMessage` (spec §11: "blocked with a clear message").
String stampOutcomeMessage(S s, StampOutcome? outcome) {
  switch (outcome) {
    case StampOutcome.dailyLimitReached:
      return s.blockedAlreadyToday;
    case StampOutcome.belowMinSpend:
      return s.blockedBelowMinSpend;
    case StampOutcome.programPaused:
      return s.blockedProgramPaused;
    case StampOutcome.awarded:
    case StampOutcome.unknown:
    case null:
      return s.somethingWentWrong;
  }
}
