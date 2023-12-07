import 'package:json_annotation/json_annotation.dart';
part 'location.g.dart';

@JsonSerializable()
class Location {

  const Location({
    required this.name,
    required this.since,
    required this.lastUpdated,
    required this.place,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  final String name;
  final String since;
  final String lastUpdated;
  final String place;
  final List<double> coordinates;
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
