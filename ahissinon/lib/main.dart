import 'package:ahissinon/firebase_options.dart';
import 'package:flutter/material.dart';
import 'page_accueil.dart'; 
import 'package:firebase_core/firebase_core.dart';



Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform
  );
  
   runApp(const MyApp()); 
}
  
 


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mon Application',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage(), 
    );
  }
}
