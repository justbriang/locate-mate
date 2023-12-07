import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:on_space/home/models/item_location.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({required this.itemLocation, super.key});
  final ItemLocation itemLocation;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          itemLocation.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CachedNetworkImage(
                  height: 200,
                  width: 200,
                  imageUrl: itemLocation.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
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
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),

                const SizedBox(height: 20),
                Container(
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
                  width: size.width * .9,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton.outlined(
                        onPressed: () {},
                        icon: const Icon(Icons.info_outline),
                      ),
                      ChoiceChip(
                        label: Text(
                          itemLocation.id,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        selected: true,
                        selectedColor: Colors.green,
                      ),
                      IconButton.outlined(
                        onPressed: () {},
                        icon: const Icon(Icons.chat_bubble_outline_rounded),
                      ),
                    ],
                  ),
                ), // Example ID

                const SizedBox(
                  height: 20,
                ),
                _buildInfoSection(itemLocation),
                const SizedBox(
                  height: 20,
                ),
                _buildUpdatesList(itemLocation),
              ],
            ),
          ),
          SizedBox(
            height: size.height,
            width: size.width,
          ),
          _buildTopFloatingActionButtons(size, context),
        ],
      ),
    );
  }

  Widget _buildInfoSection(ItemLocation itemLocation) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Adjust the color to match the screenshot
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 5,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Now is',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              Icon(Icons.pin_drop_outlined),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                itemLocation.currentLocation.place,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Text(
                'Since ${itemLocation.currentLocation.since}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                itemLocation.currentLocation.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
              Text(
                itemLocation.currentLocation.lastUpdated,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatesList(ItemLocation itemLocation) {
    // This should be dynamically built with ListView.builder in a real app
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white, // Adjust the color to match the screenshot
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 5,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        shape: const Border(),
        initiallyExpanded: true,
        childrenPadding:
            const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        // leading: Icon(Icons.timelapse_outlined),
        title: const Text('Latest Updates'),
        children: itemLocation.history
            .map(
              (e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.place,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    e.since,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildTopFloatingActionButtons(Size size, BuildContext context) {
    return Positioned(
      bottom: 10,
      child: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {},
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              child: const Icon(Icons.call_outlined),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 60),
              decoration: BoxDecoration(
                color: Colors.black, // Adjust the color to match the screenshot
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0.5,
                    blurRadius: 5,
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: const Text(
                'Follow',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            FloatingActionButton(
              onPressed: () {},
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              child: const RotatedBox(
                quarterTurns: 1,
                child: Icon(Icons.battery_2_bar_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
