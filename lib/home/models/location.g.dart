// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      name: json['name'] as String,
      since: json['since'] as String,
      lastUpdated: json['lastUpdated'] as String,
      place: json['place'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'name': instance.name,
      'since': instance.since,
      'lastUpdated': instance.lastUpdated,
      'place': instance.place,
      'coordinates': instance.coordinates,
    };
