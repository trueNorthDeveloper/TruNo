import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/controller/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/public/config/downlaod_latest_version.dart';

class VersiondownloadScreen extends StatefulWidget {
  const VersiondownloadScreen({super.key});

  @override
  State<VersiondownloadScreen> createState() => _VersiondownloadScreenState();
}

class _VersiondownloadScreenState extends State<VersiondownloadScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<UserDashboardProvider>(context, listen: false);

      final url = DownlaodLatestVersion.downloadUrl;

      if (url != null && url.isNotEmpty) {
        provider.downloadApk(url);
      } else {
        print("❌ ERROR: Download URL is empty or null");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDashboardProvider>(context, listen: true);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              provider.isDownloading
                  ? Column(
                      children: [
                        LinearProgressIndicator(
                          value: provider.progress,
                        ),
                        const SizedBox(height: 16.0),
                        Text(provider.downloadMessage),
                      ],
                    )
                  : Center(child: const Text("finalizing...")),
            ],
          ),
        ),
      ),
    );
  }
}
