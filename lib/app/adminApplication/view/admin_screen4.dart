import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/public/config/break_points.dart';

class AdminUiScreen4 extends StatefulWidget {
  const AdminUiScreen4({super.key});

  @override
  State<AdminUiScreen4> createState() => _AdminUiScreen4State();
}

class _AdminUiScreen4State extends State<AdminUiScreen4> {
  Widget build(BuildContext context) {
    // SizeConFig.init(context);
    // SizeConFig.init(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            int crossAxisCount;

            if (BreakPoint.isMobile(width)) {
              // Mobile
              crossAxisCount = width < 400 ? 1 : 2;
            } else if (BreakPoint.isWeb(width)) {
              // Tablet
              crossAxisCount = 3;
            } else {
              // Web / Desktop
              crossAxisCount = 3;
            }

            return Padding(
              padding: EdgeInsets.all(
                width < BreakPoint.mobile ? 12 : 24,
              ),
              child: GridView.builder(
                itemCount: 6, // 3 x 3
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: width < BreakPoint.mobile ? 12 : 20,
                  mainAxisSpacing: width < BreakPoint.mobile ? 12 : 20,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  return _buildGridItem(index);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Center(
        child: Text(
          "Grid ${index + 1}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
