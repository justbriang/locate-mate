import 'dart:convert';

import 'package:on_space/home/models/item_location.dart';
import 'package:on_space/network/api_service.dart';

mixin ItemLocationRepository {
  Future<List<ItemLocation>> getItemLocations();
}

class BaseItemLocationRepository implements ItemLocationRepository {
  BaseItemLocationRepository() : _service = ApiService.create();

  final ApiService _service;

  @override
  Future<List<ItemLocation>> getItemLocations() async {
    final response = await _service.getItemLocations();

    if (response.isSuccessful && response.bodyString.isNotEmpty) {
      final dataList = jsonDecode(response.bodyString) as List<dynamic>;
      return dataList
          .map((json) => ItemLocation.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch item locations: ${response.error}');
    }
  }
}
