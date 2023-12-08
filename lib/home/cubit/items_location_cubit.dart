import 'package:bloc/bloc.dart';
import 'package:on_space/home/models/item_location.dart';
import 'package:on_space/home/repository/item_location_repository.dart';

class ItemsLocationCubit extends Cubit<ItemsLocationState> {
  ItemsLocationCubit() : super(ItemsLocationInitial());
  final BaseItemLocationRepository _baseItemLocationRepository =
      BaseItemLocationRepository();

  Future<void> loadItemLocation() async {
    try {
      final itemLocations =
          await _baseItemLocationRepository.getItemLocations();

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
