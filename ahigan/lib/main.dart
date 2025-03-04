import 'package:ahigan/firebase_options.dart';
import 'package:ahigan/menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:ahigan/auth/redirection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RedirectionPage(),
    );
  }
}

// class _MyHomePageState extends State<MyHomePage>
//     with SingleTickerProviderStateMixin {
//   int _tabIndex = 1;
//   int get tabIndex => _tabIndex;
//   set tabIndex(int v) {
//     _tabIndex = v;
//     setState(() {});
//   }

//   late PageController pageController;

//   @override
//   void initState() {
//     super.initState();
//     pageController = PageController(initialPage: _tabIndex);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       bottomNavigationBar: CircleNavBar(
//         activeIcons: const [
//           Icon(Icons.home, color: Colors.orange),
//           Icon(Icons.person, color: Colors.orange),
//           Icon(Icons.favorite, color: Colors.orange),
//         ],
//         inactiveIcons: const [
//           Icon(Icons.home, color: Colors.orange),
//           Icon(Icons.person, color: Colors.orange),
//           Icon(Icons.favorite, color: Colors.orange),
//         ],
//         color: Colors.white,
//         height: 60,
//         circleWidth: 60,
//         activeIndex: tabIndex,
//         onTap: (index) {
//           tabIndex = index;
//           pageController.jumpToPage(tabIndex);
//         },
//         padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
//         cornerRadius: const BorderRadius.only(
//           topLeft: Radius.circular(8),
//           topRight: Radius.circular(8),
//           bottomRight: Radius.circular(24),
//           bottomLeft: Radius.circular(24),
//         ),
//         shadowColor: Colors.deepPurple,
//         elevation: 10,
//       ),
//       body: PageView(
//         controller: pageController,
//         onPageChanged: (v) {
//           tabIndex = v;
//         },
//         children: [
//           MenuPage(title: 'Menu Page',),
//           Container(
//               width: double.infinity,
//               height: double.infinity,
//               color: Colors.green),
//           Container(
//               width: double.infinity,
//               height: double.infinity,
//               color: Colors.blue),
//         ],
//       ),
//     );
//   }
// }
