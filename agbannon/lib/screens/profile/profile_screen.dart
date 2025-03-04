import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilScreen extends StatefulWidget {
  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('marchands').doc(_user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>?;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil du Marchand'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Nom: ${_userData!['nom']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Email: ${_userData!['email']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Téléphone: ${_userData!['telephone']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Adresse: ${_userData!['adresse']}',
                      style: TextStyle(fontSize: 20)),
                  // Ajoutez d'autres champs selon les données stockées dans Firestore
                ],
              ),
            ),
    );
  }
}
