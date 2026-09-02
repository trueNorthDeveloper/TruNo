import 'package:flutter/material.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/controller/logout_provider.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';

class Logoutui extends StatefulWidget {
  const Logoutui({super.key});

  @override
  State<Logoutui> createState() => _Logoutscreenui();
}

class _Logoutscreenui extends State<Logoutui> {
  // @override
  // void dispose() {
  //   super.dispose();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return PopScope(
  //       canPop: !context.watch<LoginControll>().isLoggingOut,
  //       // ignore: deprecated_member_use
  //       onPopInvoked: (didPop) {
  //         if (!didPop) {
  //           ShowTaostMessage.toastMessage(
  //             context,
  //             "Please wait, logging out...",
  //           );
  //         }
  //       },
  //       child: Scaffold(
  //           appBar: AppBar(),
  //           body: Center(
  //               child: Consumer<LoginControll>(builder: (context, log, child) {
  //             return ElevatedButton(
  //               onPressed: () async {
  //                 log.logout(context);
  //               },
  //               child: log.isLoggingOut
  //                   ? Center(
  //                       child: LoadingAnimationWidget.inkDrop(
  //                         color: Color(0xfffb934d),
  //                         size: 50,
  //                       ),
  //                     )
  //                   : Icon(Icons.logout),
  //             );
  //           }))));
  // }

  @override
  Widget build(BuildContext context) {
    // final loginProvider = context.watch<LoginControll>();
    final provider = context.watch<LogoutProvider>();

    return PopScope(
      canPop: !provider.isLoggingOut,
      // Updated from deprecated onPopInvoked to the current Flutter framework standard
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ShowTaostMessage.toastMessage(
            context,
            "Please wait, logging out...",
          );
        }
      },
      child: Scaffold(
        backgroundColor:
            const Color(0xFFF8F9FA), // Clean, light grey background
        appBar: AppBar(
          title: const Text('Account Settings'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Illustration or visual anchor zone (Optional spacing)
                const Spacer(),

                // Central Informational Card
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Consumer<LogoutProvider>(
                      builder: (context, log, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Top visual cue (Dynamic icon or loading state)
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: log.isLoggingOut
                                  ? SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: LoadingAnimationWidget.inkDrop(
                                          color: const Color(0xfffb934d),
                                          size: 40,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xfffb934d)
                                            .withAlpha(30),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.logout_rounded,
                                        size: 32,
                                        color: Color(0xfffb934d),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 20),

                            // Descriptive Header text
                            Text(
                              log.isLoggingOut
                                  ? 'Logging You Out'
                                  : 'See You Soon!',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212529),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Body Context Label
                            Text(
                              log.isLoggingOut
                                  ? 'Safely disconnecting from your account...'
                                  : 'Are you sure you want to sign out of your current session?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Action Button Block

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: log.isLoggingOut
                                    ? null // Disables interaction while loading
                                    : () async => await log.logout(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xfffb934d),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  disabledBackgroundColor: Colors.grey.shade200,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: log.isLoggingOut
                                    ? Text(
                                        'Processing...',
                                        style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w600),
                                      )
                                    : const Text(
                                        'Log Out',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                            // SizedBox(
                            //   width: double.infinity,
                            //   height: 52,
                            //   child: ElevatedButton(
                            //     onPressed: log.isLoggingOut
                            //         ? null // Disables interaction while loading
                            //         : () async => await log.logout(context),
                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: const Color(0xfffb934d),
                            //       foregroundColor: Colors.white,
                            //       elevation: 0,
                            //       disabledBackgroundColor: Colors.grey.shade200,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(12),
                            //       ),
                            //     ),
                            //     child: log.isLoggingOut
                            //         ? Text(
                            //             'Processing...',
                            //             style: TextStyle(
                            //                 color: Colors.grey.shade500,
                            //                 fontWeight: FontWeight.w600),
                            //           )
                            //         : const Text(
                            //             'Log Out',
                            //             style: TextStyle(
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.bold),
                            //           ),
                            //   ),
                            // ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
