// lib/widgets/layouts/app_scaffold.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../common/app_bar.dart';
import '../common/drawer.dart';
import '../common/bottom_nav.dart';

class AppScaffold extends StatefulWidget {
  final Widget body;
  final String title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool? showDrawer;
  final bool? showBottomNav;
  final int initialBottomNavIndex;

  const AppScaffold({
    Key? key,
    required this.body,
    this.title = '',
    this.actions,
    this.floatingActionButton,
    this.showDrawer = true,
    this.showBottomNav = true,
    this.initialBottomNavIndex = 0,
  }) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialBottomNavIndex;
  }

  void _onBottomNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Naviguer vers la page correspondante
    switch (index) {
      case 0: // Accueil
        context.go('/home');
        break;
      case 1: // Catégories/Produits
        context.go('/categories');
        break;
      case 2: // Commandes
        context.go('/orders');
        break;
      case 3: // Statistiques
        context.go('/stats');
        break;
      case 4: // Offres
        context.go('/offers');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        actions: widget.actions,
      ),
      drawer: widget.showDrawer == true ? const MyDrawer() : null,
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.showBottomNav == true
          ? BottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onBottomNavBarItemTapped,
            )
          : null,
    );
  }
}
