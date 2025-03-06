import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart'; // Votre propre CustomAuthProvider

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool _isLoading = false;
  bool _forLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<CustomAuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(_forLogin ? widget.title : "Sign Up Page"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
                    }
                    return null;
                  },
                ),
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 20),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              if (_forLogin) {
                                await authProvider.signInWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              } else {
                                await authProvider
                                    .createUserWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              }
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.of(context)
                                  .pushReplacementNamed('/home');
                            } catch (e) {
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Erreur : ${e.toString()}"),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(_forLogin ? 'Se connecter' : "S'inscrire"),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _forLogin = !_forLogin;
                    _emailController.clear();
                    _passwordController.clear();
                    _passwordConfirmController.clear();
                  });
                },
                child: Text(
                  _forLogin
                      ? "Vous n'avez pas un compte ? Inscrivez-vous"
                      : "Vous avez un compte ? Connectez-vous",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
