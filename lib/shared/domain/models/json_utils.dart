/// Lenient readers for API payloads, so a missing or mistyped field degrades to
/// a default instead of throwing during parsing.
typedef Json = Map<String, dynamic>;

DateTime? readDate(dynamic v) => v == null ? null : DateTime.tryParse(v.toString())?.toLocal();

double readDouble(dynamic v, [double fallback = 0]) {
  if (v is num) return v.toDouble();
  return double.tryParse(v?.toString() ?? '') ?? fallback;
}

double? readDoubleOrNull(dynamic v) => v == null ? null : readDouble(v);

int readInt(dynamic v, [int fallback = 0]) {
  if (v is num) return v.toInt();
  return int.tryParse(v?.toString() ?? '') ?? fallback;
}

String readString(dynamic v, [String fallback = '']) => v?.toString() ?? fallback;

Json? readMap(dynamic v) => v is Map ? Map<String, dynamic>.from(v) : null;

List<T> readList<T>(dynamic v, T Function(Json) parse) {
  if (v is! List) return <T>[];
  return v.whereType<Map>().map((e) => parse(Map<String, dynamic>.from(e))).toList();
}

/// The API sends enums in SCREAMING_SNAKE_CASE (`STAFF_SCAN`); Dart uses
/// camelCase (`staffScan`). Compares with case and underscores ignored.
T readEnum<T extends Enum>(List<T> values, dynamic v, T fallback) {
  final s = v?.toString().toLowerCase().replaceAll('_', '');
  for (final value in values) {
    if (value.name.toLowerCase() == s) return value;
  }
  return fallback;
}

/// `staffScan` → `STAFF_SCAN`.
String enumWire(Enum e) => e.name.replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m[0]!}').toUpperCase();
