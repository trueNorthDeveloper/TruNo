import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/dummyData/admin_dummy_data.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/model/admin_all_employee.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/all_user_card.dart';

class AdminUserManagementScreens extends StatefulWidget {
  const AdminUserManagementScreens({super.key});
  //final MapOptions options;

  @override
  State<AdminUserManagementScreens> createState() =>
      _AdminUserManagementScreensState();
}

class _AdminUserManagementScreensState
    extends State<AdminUserManagementScreens> {
//===============================map implement code==========
  // late List<UserLocationModel> _users =
  //     AdminDummyData.userLocation.map((UserLocationModel.fromJson)).toList();

  // @override
  // void initState() {
  //   super.initState();
  //   loadLocation();
  // }

  // void loadLocation() {
  //   final result = AdminDummyData.userLocation
  //       .map(
  //         (json) => UserLocationModel.fromJson(json),
  //       )
  //       .toList();
  //   setState(() {
  //     _users = result;
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: const Text('User Management Map'),
  //       ),
  //       body: FlutterMap(
  //           options: const MapOptions(
  //             initialCenter: const LatLng(23.2599, 77.4126),
  //             initialZoom: 13.0, // Starting zoom level
  //             minZoom: 3.0, // Maximum distance user can zoom out
  //             maxZoom: 10.0, // Maximum depth user can zoom in
  //           ),
  //           children: [
  //             TileLayer(
  //               urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  //             ),
  //             MarkerLayer(
  //               markers: _users.map((user) {
  //                 return Marker(
  //                     point: LatLng(user.lat, user.lng),
  //                     width: 120,
  //                     height: 80,
  //                     child: Column(
  //                       children: [
  //                         Text(
  //                           user.name,
  //                           style: const TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             backgroundColor: Colors.white,
  //                           ),
  //                         ),
  //                         const Icon(
  //                           Icons.location_pin,
  //                           color: Colors.red,
  //                           size: 40,
  //                         ),
  //                       ],
  //                     ));
  //               }).toList(),
  //             )
  //           ]));
  // }
  //=================================end map code
late final List<Employee> _users =
      AdminDummyData.allEmployee.map(Employee.fromJson).toList();
  @override
  Widget build(BuildContext context) {
    final card = <Widget>[
      AllUserCard(users: _users),
      for (int i = 1; i <= 6; i++) _PlaceholderTileManage('$i'),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final columns = w >= 1200 ? 2 : (w >= 700 ? 2 : 1);
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 420),
              itemCount: card.length,
          itemBuilder: (_, i) => card[i]);
    });
  }
}

class _PlaceholderTileManage extends StatelessWidget {
  const _PlaceholderTileManage(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16)),
        child: Center(
          child: Text(label),
        ),
      );
}
