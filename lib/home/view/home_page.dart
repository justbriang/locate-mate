import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:on_space/home/cubit/items_location_cubit.dart';
import 'package:on_space/home/models/item_location.dart';
import 'package:on_space/home/view/profile_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ItemsLocationCubit()..loadItemLocation(),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key});

  GoogleMapController? mapController;
  final double _currentZoom = 12;

  final List<String> _chipLabels = ['All', 'People', 'Items'];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _zoomIn() {
    mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder<ItemsLocationCubit, ItemsLocationState>(
        builder: (context, state) {
          if (state is ItemsLocationLoaded) {
            return Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: const LatLng(37.77483, -122.41942),
                    zoom: _currentZoom,
                  ),
                  markers: _createMarkers(state.itemLocations),
                ),
                _buildTopFloatingActionButtons(size),
                _buildSideFloatingActionButtons(),
                _buildBottomPanel(size, context, state),
                _buildFloatingPanel(size),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Set<Marker> _createMarkers(List<ItemLocation> items) {
    return items
        .map(
          (e) => Marker(
            infoWindow: InfoWindow(title: e.name),
            markerId: MarkerId(e.id),
            position: LatLng(
              e.currentLocation.coordinates.first,
              e.currentLocation.coordinates.last,
            ),
            // icon: BitmapDescriptor.defaultMarker,
          ),
        )
        .toSet();
  }

  Widget _buildTopFloatingActionButtons(Size size) {
    return Positioned(
      left: 10,
      top: 10,
      child: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _zoomIn,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              child: const Icon(Icons.search),
            ),
            FloatingActionButton(
              onPressed: _zoomOut,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              child: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideFloatingActionButtons() {
    return Positioned(
      left: 10,
      top: 300,
      child: Column(
        children: <Widget>[
          FloatingActionButton(
            onPressed: _zoomIn,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: _zoomOut,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: _zoomOut,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(
    Size size,
    BuildContext context,
    ItemsLocationLoaded state,
  ) {
    return Positioned(
      bottom: 100,
      left: 20,
      right: 20,
      child: Container(
        height: 250,
        width: size.width,
        // padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 40,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: _chipLabels.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ChoiceChip(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            onSelected: (value) {
                              context.read<ItemsLocationCubit>().filterList(
                                    _chipLabels[index],
                                  );
                            },
                            selected: state.selectedFilter.toLowerCase() ==
                                _chipLabels[index].toLowerCase(),
                            label: Text(
                              _chipLabels[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                            ),
                            backgroundColor: Colors.grey.shade300,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: state.filteredLocations.length,
                (BuildContext context, int index) {
                  return state.filteredLocations[index].type.toLowerCase() ==
                          'person'
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  itemLocation: state.filteredLocations[index],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ), // Adjust the padding as needed
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left side: Avatar and Texts
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      height: 50,
                                      width: 50,
                                      imageUrl: state
                                          .filteredLocations[index].imageUrl,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            colorFilter: const ColorFilter.mode(
                                              Colors.black12,
                                              BlendMode.color,
                                            ),
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.filteredLocations[index].name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          state.filteredLocations[index]
                                              .currentLocation.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Right side: Status Icons
                                const Row(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 1,
                                      child: Icon(
                                        Icons.battery_3_bar_outlined,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Icon(
                                      Icons.send,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  itemLocation: state.filteredLocations[index],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ), // Adjust the padding as needed
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left side: Avatar and Texts
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      height: 50,
                                      width: 50,
                                      imageUrl: state
                                          .filteredLocations[index].imageUrl,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            colorFilter: const ColorFilter.mode(
                                              Colors.black12,
                                              BlendMode.color,
                                            ),
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.filteredLocations[index].name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          state.filteredLocations[index]
                                              .currentLocation.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Right side: Status Icons
                                Row(
                                  children: [
                                    Text(
                                      state.filteredLocations[index]
                                          .currentLocation.lastUpdated,
                                    ),
                                    const SizedBox(width: 15),
                                    const Icon(
                                      Icons.send,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                },

                // Add more ListTiles here
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingPanel(Size size) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 60,
        margin: const EdgeInsets.all(20),
        width: size.width, // Adjust height to desired value
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0.5,
              blurRadius: 5,
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map_outlined),
                Text(
                  'Location',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bluetooth_drive_outlined,
                  color: Colors.grey,
                ),
                Text(
                  'Driving',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.security_rounded, color: Colors.grey),
                Text(
                  'Safety',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble, color: Colors.grey),
                Text(
                  'Chat',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
