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
