import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TestMapScreen extends StatelessWidget {
  const TestMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Map'),
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(
            23.1833014,
            77.4215657,
          ),
          initialZoom: 10,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),

          MarkerLayer(
            markers: [
              Marker(
                point: const LatLng(
                  23.1833014,
                  77.4215657,
                ),
                width: 100,
                height: 60,
                child: Column(
                  children: const [
                    Text(
                      'Alice Smith',
                      style: TextStyle(
                        backgroundColor: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 35,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
