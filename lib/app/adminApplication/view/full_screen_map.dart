import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/dummyData/admin_dummy_data.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/model/user_location_modal.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({super.key});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  late List<UserLocationModel> _users =
      AdminDummyData.userLocation.map(UserLocationModel.fromJson).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Street Map'),
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Exit full screen',
            icon: const Icon(Icons.close_fullscreen),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(23.2599, 77.4126),
            initialZoom: 13.0,
            minZoom: 3.0,
            maxZoom: 18.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              maxZoom: 18.0, // Tells the layer the absolute maximum available tile depth
      // If you want smooth zooming past level 18 without loading new tiles:
      maxNativeZoom: 18,
            ),
            MarkerLayer(
              markers: _users.map((user) {
                return Marker(
                  point: LatLng(user.lat, user.lng),
                  width: 120,
                  height: 80,
                  child: Column(
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ]),
    );
  }
}
