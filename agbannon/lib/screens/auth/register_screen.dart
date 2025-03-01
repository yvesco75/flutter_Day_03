import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import '../../services/auth_service.dart';
import 'forgot_password_screen.dart';

class RegisterScreen extends StatefulWidget {
  final Function toggleView;

  RegisterScreen({required this.toggleView});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String nom = ''; // Ajouté
  String prenom = ''; // Ajouté
  String telephone = ''; // Ajouté
  String error = '';
  bool loading = false;
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
        automaticallyImplyLeading: false, // Désactive la flèche de retour
        actions: [
          TextButton.icon(
            icon: Icon(Icons.login,
                color: const Color.fromARGB(255, 97, 13, 233)),
            label: Text('Se connecter',
                style:
                    TextStyle(color: const Color.fromARGB(255, 97, 13, 233))),
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.0),
                Image.asset(
                  'images/profil.jpg',
                  height: 100,
                  width: 150,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (val) => (val?.length ?? 0) < 2
                      ? 'Le nom doit contenir au moins 2 caractères'
                      : null,
                  onChanged: (val) {
                    setState(() => nom = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Prénom',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (val) => (val?.length ?? 0) < 2
                      ? 'Le prénom doit contenir au moins 2 caractères'
                      : null,
                  onChanged: (val) {
                    setState(() => prenom = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Téléphone',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (val) => (val?.length ?? 0) < 8
                      ? 'Le numéro de téléphone doit contenir au moins 8 chiffres'
                      : null,
                  onChanged: (val) {
                    setState(() => telephone = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => !EmailValidator.validate(val ?? '')
                      ? 'Entrez un email valide'
                      : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureTextPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureTextPassword = !_obscureTextPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  obscureText: _obscureTextPassword,
                  validator: (val) {
                    if ((val?.length ?? 0) < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    // Vérifier si le mot de passe contient au moins un chiffre
                    if (!RegExp(r'\d').hasMatch(val ?? '')) {
                      return 'Le mot de passe doit contenir au moins un chiffre';
                    }
                    // Vérifier si le mot de passe contient au moins une lettre majuscule
                    if (!RegExp(r'[A-Z]').hasMatch(val ?? '')) {
                      return 'Le mot de passe doit contenir au moins une lettre majuscule';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureTextConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureTextConfirmPassword =
                              !_obscureTextConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  obscureText: _obscureTextConfirmPassword,
                  validator: (val) => val != password
                      ? 'Les mots de passe ne correspondent pas'
                      : null,
                  onChanged: (val) {
                    setState(() => confirmPassword = val);
                  },
                ),
                SizedBox(height: 30.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'S\'inscrire',
                          style: TextStyle(fontSize: 16),
                        ),
                  onPressed: loading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() => loading = true);

                            try {
                              await authService.registerWithEmailAndPassword(
                                email: email,
                                password: password,
                                nom: nom,
                                prenom: prenom,
                                telephone: telephone,
                                // Les paramètres optionnels peuvent être omis ou fournis
                                boutiqueName: 'Nom de la boutique', // Exemple
                                marche: 'Nom du marché', // Exemple
                                adresse: 'Adresse', // Exemple
                              );
                            } catch (e) {
                              setState(() {
                                if (e
                                    .toString()
                                    .contains('email-already-in-use')) {
                                  error = 'Cet email est déjà utilisé';
                                } else {
                                  error =
                                      'Échec d\'inscription. Veuillez réessayer.';
                                }
                              });
                            } finally {
                              setState(() => loading = false);
                            }
                          }
                        },
                ),
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                SizedBox(height: 10.0),
                TextButton(
                  child: Text(
                    'Mot de passe oublié?',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => forgotPasswordScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
