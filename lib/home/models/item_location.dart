import 'package:json_annotation/json_annotation.dart';
import 'package:on_space/home/models/location.dart';

part 'item_location.g.dart';

@JsonSerializable()
class ItemLocation {
  const ItemLocation({
    required this.id,
    required this.name,
    required this.currentLocation,
    required this.history,
    required this.imageUrl,
    required this.type,
  });

  factory ItemLocation.fromJson(Map<String, dynamic> json) =>
      _$ItemLocationFromJson(json);
  final String id;
  final String name;
  final String type;
  final String imageUrl;
  final Location currentLocation;
  final List<Location> history;
  Map<String, dynamic> toJson() => _$ItemLocationToJson(this);
}
