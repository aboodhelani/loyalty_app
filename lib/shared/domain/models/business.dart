import 'category.dart';
import 'json_utils.dart';
import 'loyalty_program.dart';
import 'stamp_card.dart';

enum BusinessStatus { pending, live, hidden }

/// `{ "mon": [{ "open": "08:00", "close": "22:00" }], … }`
class OpeningHours {
  static const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

  final Map<String, List<(String, String)>> byDay;

  const OpeningHours(this.byDay);

  factory OpeningHours.fromJson(dynamic json) {
    final map = <String, List<(String, String)>>{};
    if (json is Map) {
      json.forEach((day, ranges) {
        map[day.toString()] = readList(ranges, (r) => (readString(r['open']), readString(r['close'])));
      });
    }
    return OpeningHours(map);
  }

  bool get isEmpty => byDay.isEmpty;

  static String format(List<(String, String)> ranges) => ranges.map((r) => '${r.$1} – ${r.$2}').join(', ');

  /// Same hours seven days a week → one line is enough.
  String? get everyDay {
    final all = days.map((d) => format(byDay[d] ?? const [])).toSet();
    return all.length == 1 && all.first.isNotEmpty ? all.first : null;
  }

  String today([DateTime? now]) => format(byDay[days[(now ?? DateTime.now()).weekday - 1]] ?? const []);
}

class Branch {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String? phone;
  final OpeningHours openingHours;
  final double? distanceKm;

  const Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    this.phone,
    this.openingHours = const OpeningHours({}),
    this.distanceKm,
  });

  factory Branch.fromJson(Json json) => Branch(
        id: readString(json['id']),
        name: readString(json['name']),
        address: readString(json['address']),
        lat: readDouble(json['lat']),
        lng: readDouble(json['lng']),
        phone: json['phone']?.toString(),
        openingHours: OpeningHours.fromJson(json['openingHours']),
        distanceKm: readDoubleOrNull(json['distanceKm']),
      );
}

class Business {
  final String id;
  final String name;
  final Category? category;
  final String? logoUrl;
  final String? coverUrl;
  final List<String> photos;
  final String description;
  final String phone;
  final String? website;
  final String? instagram;
  final BusinessStatus status;
  final List<Branch> branches;
  final Branch? nearestBranch;
  final LoyaltyProgram? program;

  /// Filled when the request carried lat/lng.
  final double? distanceKm;

  /// The signed-in customer's current card here, if any.
  final StampCard? myProgress;

  const Business({
    required this.id,
    required this.name,
    this.category,
    this.logoUrl,
    this.coverUrl,
    this.photos = const [],
    required this.description,
    required this.phone,
    this.website,
    this.instagram,
    this.status = BusinessStatus.live,
    this.branches = const [],
    this.nearestBranch,
    this.program,
    this.distanceKm,
    this.myProgress,
  });

  /// The branch to show and route to: the nearest one, else the first.
  Branch? get mainBranch => nearestBranch ?? (branches.isEmpty ? null : branches.first);

  String? get categoryId => category?.id;

  factory Business.fromJson(Json json) {
    final category = readMap(json['category']);
    final nearest = readMap(json['nearestBranch']);
    final program = readMap(json['program']);
    final progress = readMap(json['myProgress']);
    return Business(
      id: readString(json['id']),
      name: readString(json['name']),
      category: category == null ? null : Category.fromJson(category),
      logoUrl: json['logoUrl']?.toString(),
      coverUrl: json['coverUrl']?.toString(),
      photos: (json['photos'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      description: readString(json['description']),
      phone: readString(json['phone']),
      website: json['website']?.toString(),
      instagram: json['instagram']?.toString(),
      status: readEnum(BusinessStatus.values, json['status'], BusinessStatus.live),
      branches: readList(json['branches'], Branch.fromJson),
      nearestBranch: nearest == null ? null : Branch.fromJson(nearest),
      program: program == null ? null : LoyaltyProgram.fromJson(program),
      distanceKm: readDoubleOrNull(json['distanceKm']),
      myProgress: progress == null ? null : StampCard.fromJson(progress),
    );
  }
}
