// import 'dart:async';

// import 'package:background_fetch/background_fetch.dart';

// class BackgroundLocationService {
//   static Future<void> start() async {
//     await BackgroundFetch.configure(
//       BackgroundFetchConfig(
//         // minimumFetchInterval: 15, // ⏱ every 15 minutes
//         // stopOnTerminate: false,   // ✅ continue after app is killed
//         // enableHeadless: true,     // ✅ run in background isolate
//         // startOnBoot: true,        // ✅ restart after device reboot
//         // requiresBatteryNotLow: false,
//         // requiresCharging: false,
//         // requiresDeviceIdle: false,
//         minimumFetchInterval: 15, // 15 min in real scenario
//         stopOnTerminate: false,
//         enableHeadless: true,
//         startOnBoot: true,
//         requiresBatteryNotLow: false,
//         requiresCharging: false,
//       ),
//       (String taskId) async {
//         print("📦 [BackgroundFetch] Event received: $taskId");
//         // await fetchAndSendLocation();
//         BackgroundFetch.finish(taskId);
//       },
//       (String taskId) async {
//         print("⚠️ [BackgroundFetch] TASK TIMEOUT: $taskId");
//         BackgroundFetch.finish(taskId);
//       },
//     );

//     print("✅ BackgroundFetch configured successfully");
//   }

//   static Future<void> stop() async {
//     await BackgroundFetch.stop();
//   }

// static Future<void> scheduleManualTask() async {
//     await BackgroundFetch.scheduleTask(TaskConfig(
//       taskId: "manual_test_task",
//       delay: 5000, // 5 seconds
//       periodic: false,
//       stopOnTerminate: false,
//       enableHeadless: true,
//     ));
//   }

// }
