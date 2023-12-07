// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemLocation _$ItemLocationFromJson(Map<String, dynamic> json) => ItemLocation(
      id: json['id'] as String,
      name: json['name'] as String,
      currentLocation:
          Location.fromJson(json['currentLocation'] as Map<String, dynamic>),
      history: (json['history'] as List<dynamic>)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$ItemLocationToJson(ItemLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'imageUrl': instance.imageUrl,
      'currentLocation': instance.currentLocation,
      'history': instance.history,
    };
