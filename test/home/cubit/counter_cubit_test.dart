import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:on_space/home/cubit/items_location_cubit.dart';
import 'package:on_space/home/models/item_location.dart';
import 'package:on_space/home/repository/item_location_repository.dart';

// Create a Mock Repository
class MockItemLocationRepository extends Mock
    implements BaseItemLocationRepository {}

void main() {
  group('ItemsLocationCubit', () {
    late MockItemLocationRepository mockItemLocationRepository;
    late ItemsLocationCubit itemsLocationCubit;

    setUp(() {
      mockItemLocationRepository = MockItemLocationRepository();
      itemsLocationCubit = ItemsLocationCubit(mockItemLocationRepository);
    });

    blocTest<ItemsLocationCubit, ItemsLocationState>(
      'emits [] when nothing is added',
      build: () => itemsLocationCubit,
      expect: () => [],
    );

    blocTest<ItemsLocationCubit, ItemsLocationState>(
      'emits [ItemsLocationLoaded] with a list of item locations when loadItemLocation is called',
      build: () {
        when(() => mockItemLocationRepository.getItemLocations())
            .thenAnswer((_) async => loadMockData()); // Use your mock data
        return ItemsLocationCubit(mockItemLocationRepository);
      },
      act: (cubit) => cubit.loadItemLocation(),
      expect: () => [
        isA<ItemsLocationLoaded>().having(
            (state) => state.itemLocations, 'itemLocations', isNotEmpty),
      ],
    );

    blocTest<ItemsLocationCubit, ItemsLocationState>(
      'emits [ItemsLocationLoadFailure] when loadItemLocation throws Exception',
      build: () {
        when(() => mockItemLocationRepository.getItemLocations())
            .thenThrow(Exception('Failed to fetch data'));
        return ItemsLocationCubit(mockItemLocationRepository);
      },
      act: (cubit) => cubit.loadItemLocation(),
      expect: () => [isA<ItemsLocationLoadFailure>()],
    );

    // Add more tests for filterList method
  });
}
