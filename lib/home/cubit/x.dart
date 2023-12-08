import 'package:bloc/bloc.dart';
import 'package:on_space/home/models/item_location.dart';

class ItemsLocationCubit extends Cubit<ItemsLocationState> {
  ItemsLocationCubit() : super(ItemsLocationInitial());

  Future<void> loadItemLocation() async {
    try {
      final data = await loadMockData();

      final itemLocations = data.map(ItemLocation.fromJson).toList();

      emit(
        ItemsLocationLoaded(
          itemLocations: itemLocations,
          filteredLocations: itemLocations,
        ),
      );
    } on Exception catch (e) {
      emit(ItemsLocationLoadFailure(e.toString()));
    }
  }

  void filterList(String tag) {
    final currentState = state;
    if (currentState is ItemsLocationLoaded) {
      final filteredLocations = currentState.itemLocations.where((location) {
        switch (tag.toLowerCase()) {
          case 'all':
            return true;
          case 'people':
            return location.type.toLowerCase() == 'person';
          case 'items':
            return location.type.toLowerCase() == 'item';
          default:
            return false;
        }
      }).toList();

      emit(
        currentState.copyWith(
          filteredLocations: filteredLocations,
          selectedFilter: tag,
        ),
      );
    }
  }
}

abstract class ItemsLocationState {}

class ItemsLocationInitial extends ItemsLocationState {}

class ItemsLocationLoaded extends ItemsLocationState {
  ItemsLocationLoaded({
    this.itemLocations = const [],
    this.filteredLocations = const [],
    this.selectedFilter = 'All',
  });

  final List<ItemLocation> itemLocations;
  final List<ItemLocation> filteredLocations;
  final String selectedFilter;

  ItemsLocationLoaded copyWith({
    List<ItemLocation>? itemLocations,
    List<ItemLocation>? filteredLocations,
    String? selectedFilter,
  }) {
    return ItemsLocationLoaded(
      itemLocations: itemLocations ?? this.itemLocations,
      filteredLocations: filteredLocations ?? this.filteredLocations,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

class ItemsLocationLoadFailure extends ItemsLocationState {
  ItemsLocationLoadFailure(this.error);
  final String error;
}

// Mock data loader
Future<List<Map<String, dynamic>>> loadMockData() async {
  //fetch mock data
  return [
    {
      'id': 'id 1446787',
      'name': 'Jeniffer',
      'type': 'person',
      'imageUrl':
          'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600',
      'currentLocation': {
        'name': 'Golden Gate Park',
        'since': '7:54',
        'lastUpdated': '9 min updated',
        'place': 'park',
        'coordinates': [37.76904, -122.48352],
      },
      'history': [
        {
          'name': 'Lombard Street',
          'since': '8:07',
          'lastUpdated': '9 min updated',
          'place': 'tourist attraction',
          'coordinates': [37.80214, -122.41874],
        },
        {
          'name': 'Alamo Square',
          'since': '7:54',
          'lastUpdated': '9 min updated',
          'place': 'residential area',
          'coordinates': [37.77636, -122.43463],
        },
        // ... additional history items
      ],
    },
    {
      'id': 'id 1446789',
      'name': 'Car Keys',
      'type': 'item',
      'imageUrl':
          'https://images.pexels.com/photos/97075/pexels-photo-97075.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'currentLocation': {
        'name': 'Pier 39',
        'since': '8:30',
        'lastUpdated': '5 min updated',
        'place': 'shopping area',
        'coordinates': [37.80867, -122.40982],
      },
      'history': [
        {
          'name': '84 Kamaraja St',
          'since': '8:07',
          'lastUpdated': '9 min updated',
          'place': 'school',
          'coordinates': [37.77483, -122.41942],
        },
        {
          'name': '84 Kamaraja St',
          'since': '7:54',
          'lastUpdated': '9 min updated',
          'place': 'school',
          'coordinates': [38.77483, -121.41942],
        },
      ],
    },
    {
      'id': 'id 1446788',
      'name': 'Michael',
      'type': 'person',
      'imageUrl':
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'currentLocation': {
        'name': 'Oracle Park',
        'since': '7:54',
        'lastUpdated': '12 min updated',
        'place': 'stadium',
        'coordinates': [37.77860, -122.38927],
      },
      'history': [
        {
          'name': '84 Kamaraja St',
          'since': '8:07',
          'lastUpdated': '9 min updated',
          'place': 'school',
          'coordinates': [37.77483, -122.41942],
        },
        {
          'name': '84 Kamaraja St',
          'since': '7:54',
          'lastUpdated': '9 min updated',
          'place': 'school',
          'coordinates': [38.77483, -121.41942],
        },
      ],
    },
  ];
}
