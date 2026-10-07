import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/dummyData/admin_dummy_data.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/model/user_location_modal.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late List<UserLocationModel> _users =
      AdminDummyData.userLocation.map((UserLocationModel.fromJson)).toList();

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  void loadLocation() {
    final result = AdminDummyData.userLocation
        .map(
          (json) => UserLocationModel.fromJson(json),
        )
        .toList();
    setState(() {
      _users = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('street map'),
        ),
        body: FlutterMap(
            options: const MapOptions(
              initialCenter: const LatLng(23.2599, 77.4126),
              initialZoom: 13.0, // Starting zoom level
              minZoom: 3.0, // Maximum distance user can zoom out
              maxZoom: 10.0, // Maximum depth user can zoom in
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                      ));
                }).toList(),
              )
            ]));
  }
}
