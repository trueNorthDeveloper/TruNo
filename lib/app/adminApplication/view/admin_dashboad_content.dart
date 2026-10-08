import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/dummyData/admin_dummy_data.dart';

import 'package:truenorthflutterfrontend/app/adminApplication/model/admin_login_record.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/model/admin_logout_record.dart';

import 'package:truenorthflutterfrontend/app/adminApplication/view/login_history_card.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/logout_history_card.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/map_screen.dart';

class AdminDashboardContent extends StatefulWidget {
  const AdminDashboardContent({super.key});

  @override
  State<AdminDashboardContent> createState() => _AdminDashboardContentState();
}

class _AdminDashboardContentState extends State<AdminDashboardContent> {
  @override
  void initState() {
    super.initState(); // Always call this first!
    // Do your one-time setup here
    //TODO   Implement fetch_all_login_user() to pull login details from the API.
  }

  // Convert once, not on every rebuild. Later: replace with
  late final List<AdminLoginRecord> _record =
      AdminDummyData.allLoginRecord.map(AdminLoginRecord.fromJson).toList();
  late final List<AdminLogoutRecord> _recordLogout =
      AdminDummyData.allLogoutRecord.map(AdminLogoutRecord.fromJson).toList();

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[
      LoginHistoryCard(records: _record),
      MapScreen(),
      LogoutHistoryCard(records: _recordLogout),
      for (int i = 2; i <= 6; i++) _PlaceholderTile('$i'),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final columns = w >= 1200 ? 2 : (w >= 700 ? 2 : 1);

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 420, // fixed height: no aspect-ratio overflow
          ),
          itemCount: cards.length,
          itemBuilder: (_, i) => cards[i],
        );
      },
    );
  }
}

class _PlaceholderTile extends StatelessWidget {
  const _PlaceholderTile(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(child: Text(label)),
      );
}
 