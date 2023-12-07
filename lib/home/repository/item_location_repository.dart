import 'dart:convert';

import 'package:on_space/home/models/item_location.dart';
import 'package:on_space/network/api_service.dart';

abstract class ItemLocationRepository {
  Future<List<ItemLocation>> getItemLocations();
}

class BaseItemLocationRepository implements ItemLocationRepository {
  BaseItemLocationRepository() {
    _service = ApiService.create();
  }

  late ApiService _service;

  @override
  Future<List<ItemLocation>> getItemLocations() async {
    try {
      final response = await _service.getItemLocations();

      if (response.isSuccessful) {
        final data = jsonDecode(response.bodyString) as Map<String, dynamic>;

        final agPreqs = <ItemLocation>[];
        if (data.isNotEmpty) {
          print(data);
          print(data.runtimeType);
          // return data.map(ItemLocation.fromJson).toList();
          // data.forEach((v) {
          //   agPreqs.add(ItemLocation.fromJson(v));
          // });
          return agPreqs;
        }
        return agPreqs;
      } else {
        print('is unessuccessful');
        throw 'Run into an expected error';
      }
    } catch (e) {
      print('is unessuccessful woht $e');
      rethrow;
    }
  }
}
