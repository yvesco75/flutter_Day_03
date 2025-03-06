// lib/widgets/common/bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Définir les couleurs et le style
    final primaryColor = Theme.of(context).primaryColor;
    final selectedItemColor = primaryColor;
    final unselectedItemColor = Colors.grey;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Accueil',
                index: 0,
                selectedIndex: selectedIndex,
                onTap: onItemTapped,
                selectedColor: selectedItemColor,
                unselectedColor: unselectedItemColor,
              ),
              _buildNavItem(
                icon: Icons.category_outlined,
                selectedIcon: Icons.category,
                label: 'Produits',
                index: 1,
                selectedIndex: selectedIndex,
                onTap: onItemTapped,
                selectedColor: selectedItemColor,
                unselectedColor: unselectedItemColor,
              ),
              _buildNavItem(
                icon: Icons.receipt_outlined,
                selectedIcon: Icons.receipt,
                label: 'Commandes',
                index: 2,
                selectedIndex: selectedIndex,
                onTap: onItemTapped,
                selectedColor: selectedItemColor,
                unselectedColor: unselectedItemColor,
              ),
              _buildNavItem(
                icon: Icons.pie_chart_outline,
                selectedIcon: Icons.pie_chart,
                label: 'Stats',
                index: 3,
                selectedIndex: selectedIndex,
                onTap: onItemTapped,
                selectedColor: selectedItemColor,
                unselectedColor: unselectedItemColor,
              ),
              _buildNavItem(
                icon: Icons.local_offer_outlined,
                selectedIcon: Icons.local_offer,
                label: 'Offres',
                index: 4,
                selectedIndex: selectedIndex,
                onTap: onItemTapped,
                selectedColor: selectedItemColor,
                unselectedColor: unselectedItemColor,
              ),
              _buildMoreMenuButton(
                context: context,
                color: unselectedItemColor,
                selectedColor: selectedItemColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required int selectedIndex,
    required Function(int) onTap,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? selectedColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedColor : unselectedColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreMenuButton({
    required BuildContext context,
    required Color color,
    required Color selectedColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: PopupMenuButton<String>(
        offset: const Offset(0, -180),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onSelected: (value) {
          switch (value) {
            case 'profile':
              GoRouter.of(context).go('/profile');
              break;
            case 'settings':
              // Ajouter la navigation vers les paramètres
              break;
            case 'help':
              // Ajouter la navigation vers l'aide
              break;
          }
        },
        itemBuilder: (context) => [
          _buildPopupMenuItem(
            value: 'profile',
            icon: Icons.person,
            text: 'Mon Profil',
          ),
          _buildPopupMenuItem(
            value: 'settings',
            icon: Icons.settings,
            text: 'Paramètres',
          ),
          _buildPopupMenuItem(
            value: 'help',
            icon: Icons.help,
            text: 'Aide',
          ),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.more_horiz,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              'Plus',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem({
    required String value,
    required IconData icon,
    required String text,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}
