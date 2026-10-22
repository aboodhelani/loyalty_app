import '../../../core/translations/l10n.dart';
import '../../domain/models/business.dart';

/// "Daily 08:00 – 22:00", or today's hours when the week varies.
String hoursText(S s, OpeningHours hours) {
  final every = hours.everyDay;
  if (every != null) return s.dailyHours(every);
  final today = hours.today();
  return today.isEmpty ? s.closedToday : s.todayHours(today);
}
