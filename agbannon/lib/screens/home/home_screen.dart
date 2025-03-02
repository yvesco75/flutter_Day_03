import 'dart:async';
import 'package:flutter/material.dart';
import '../home/categories.dart'; // Importez votre écran de catégories ici

class HomeWelcomeScreen extends StatefulWidget {
  const HomeWelcomeScreen({Key? key}) : super(key: key);

  @override
  _HomeWelcomeScreenState createState() => _HomeWelcomeScreenState();
}

class _HomeWelcomeScreenState extends State<HomeWelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeOutAnimation;
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();

    // Configuration des animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // Animation d'apparition (0-2 secondes)
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // Animation de disparition (3-5 secondes)
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    // Démarrer l'animation
    _animationController.forward();

    // Configurer le timer pour la redirection après 5 secondes
    _redirectTimer = Timer(
      const Duration(seconds: 5),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) =>
                const CategoriesScreen(), // Utilisez votre écran de catégories
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _redirectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 97, 13, 233),
              const Color.fromARGB(255, 97, 13, 233).withOpacity(0.7),
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeInAnimation.value * _fadeOutAnimation.value,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo ou icône
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.store,
                          size: 70,
                          color: Color.fromARGB(255, 97, 13, 233),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Titre principal
                      const Text(
                        'Bienvenue au Marché',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Message de bienvenue
                      const Text(
                        'Chère vendeuse, découvrez notre plateforme pour vendre vos produits en toute simplicité',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Indicateur de chargement
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
