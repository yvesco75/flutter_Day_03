import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth.dart'; // Assurez-vous que le chemin est correct

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool _isLoading = false;
  bool _forLogin = true;
  final Auth _auth = Auth(); // Instance de Auth

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(_forLogin ? widget.title : "Inscription"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email requis';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 20),
              if (!_forLogin)
                TextFormField(
                  obscureText: true,
                  controller: _passwordConfirmController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Confirmer le mot de passe',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez confirmer votre mot de passe';
                    } else if (value != _passwordController.text) {
                      return 'Les deux mots de passe ne correspondent pas';
                    } else {
                      return null;
                    }
                  },
                ),
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 20),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            // Login ou inscription
                            try {
                              if (_forLogin) {
                                await _auth.loginWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              } else {
                                await _auth
                                    .createUserWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            } on FirebaseAuthException catch (e) {
                              if (!mounted) return; // Vérification de mounted
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${e.message}")),
                              );
                            }
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(_forLogin ? 'Se connecter' : "S'inscrire"),
                ),
              ),
              SizedBox(
                child: TextButton(
                  onPressed: () {
                    _emailController.text = "";
                    _passwordController.text = "";
                    _passwordConfirmController.text = "";
                    setState(() {
                      _forLogin = !_forLogin;
                    });
                  },
                  child: Text(
                    _forLogin
                        ? "Vous n'avez pas de compte ? Inscrivez-vous"
                        : "Vous avez déjà un compte ? Connectez-vous",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}