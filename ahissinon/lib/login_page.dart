import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(_forLogin ? widget.title : "Sign Up Page"),
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
                    return 'Email is required';
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
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrez un Password';
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
                    labelText: 'Confirmer Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ' Veuillez Confirmer votre Password ';
                    } else if (value != _passwordController.text) {
                      return 'Les deux password ne correspondes pas';
                    } else {
                      return null;
                    }
                  },
                ),
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 20),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              //login
                              try {
                                if (_forLogin) {
                                  await Auth().loginWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                } else {
                                  await Auth().createUserWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                }
                                setState(() {
                                  _isLoading = true;
                                });
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  _isLoading = true;
                                });
                                //message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${e.message}")),
                                );
                                behavior:
                                SnackBarBehavior.floating;
                                backgroundColor:
                                Colors.red;
                                showCloseIcon:
                                true;
                              }
                            }
                          },
                  child:
                      _isLoading
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
                        ? "Vous n'avez pas un compte ?, Inscrivez-vous"
                        : "Vous avez un compte ? Connectez-vous",
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