import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/controller/homeLayoutController.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/view/user_home_page_screen.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/view/user_work_history_screen.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/view/user_profile_screen.dart';

class FooterScreen extends StatefulWidget {
  const FooterScreen({super.key});

  @override
  State<FooterScreen> createState() => _FooterScreenState();
}

class _FooterScreenState extends State<FooterScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final List<Widget> screens = [
    UserHomePage(),
    UserWorkHistory(),
    UserProfileUI(),
  ];
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pro = Provider.of<Homelayoutcontroller>(context, listen: false);
      if (_pageController.hasClients) {
        _pageController.jumpToPage(pro.pagePosition);
      }
    });
  }

  @override
  void dispose() {
    // 3. Always dispose to prevent memory leaks
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The Consumer should wrap the parts of the UI that need to rebuild
//       body: Consumer<Homelayoutcontroller>(
//         builder: (context, pro, child) {
//           print(pro.pagePosition);
//           return IndexedStack(
//             index: pro.pagePosition,
//             children: screens,
//           );
//         },
//       ),
//       bottomNavigationBar: Consumer<Homelayoutcontroller>(
//         builder: (context, pro, child) {
//           return BottomNavigationBar(
//             // Use the value from your Provider
//             currentIndex: pro.pagePosition,
//             onTap: (index) {
//               // Call the method in your Provider instead of setState
//               pro.homePageIncrement(index);
//             },
//             selectedItemColor: Colors.blue,
//             unselectedItemColor: Colors.grey,
//             type: BottomNavigationBarType.fixed,
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.explore), label: "Explore"),
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.person), label: "Profile"),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

      body: Consumer<Homelayoutcontroller>(
        builder: (context, pro, child) {
          return PageView(
            controller: _pageController,
            // FIX: Only update the provider if the page actually changed
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              if (index != pro.pagePosition) {
                pro.homePageIncrement(index);
              }
            },

            children: screens,
          );
        },
      ),
      bottomNavigationBar: Consumer<Homelayoutcontroller>(
        builder: (context, pro, child) {
          return BottomNavigationBar(
            currentIndex: pro.pagePosition,
            // onTap: (index) {

            //   if (index != pro.pagePosition) {
            //     // Calculate how many pages we are moving
            //     int distance = (index - pro.pagePosition).abs();

            //     pro.homePageIncrement(index);

            //     if (_pageController.hasClients) {
            //       if (distance == 1) {
            //         // Only animate if they are next to each other
            //         _pageController.animateToPage(
            //           index,
            //           duration: const Duration(milliseconds: 600),
            //           curve: Curves.linear,
            //         );
            //       } else {
            //         // Jump instantly if moving more than 1 page to avoid seeing index 1
            //         _pageController.jumpToPage(index);
            //       }
            //     }
            //   }
            // },
            onTap: (index) {
              if (index != pro.pagePosition) {
                pro.homePageIncrement(index);

                if (_pageController.hasClients) {
                  // 2. INSTANT SWITCH: Removes animation and skip intermediate screens
                  _pageController.jumpToPage(index);
                }
              }
            },
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.explore), label: "History"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
            ],
          );
        },
      ),
    );
  }
}
