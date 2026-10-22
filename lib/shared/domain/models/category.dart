import 'json_utils.dart';

class Category {
  final String id;
  final String name;

  /// Stable key (`cafe`, `car-wash`…) that picks the icon and accent colour.
  final String slug;

  /// Icon name from the API (`coffee`, `scissors`…).
  final String icon;

  const Category({required this.id, required this.name, required this.slug, required this.icon});

  factory Category.fromJson(Json json) => Category(
        id: readString(json['id']),
        name: readString(json['name']),
        slug: readString(json['slug']),
        icon: readString(json['icon']),
      );
}
