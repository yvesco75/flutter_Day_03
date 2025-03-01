import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import '../../services/auth_service.dart';
import 'forgot_password_screen.dart'; // Assurez-vous que le fichier est correctement importé
import '../home/home_screen.dart'; // Importez votre écran d'accueil (HomeScreen)

class LoginScreen extends StatefulWidget {
  final Function toggleView;

  LoginScreen({required this.toggleView});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<AuthService>(context); // Accès à AuthService

    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
        automaticallyImplyLeading: false, // Désactive la flèche de retour
        actions: [
          TextButton.icon(
            icon: Icon(Icons.person,
                color: const Color.fromARGB(255, 97, 13, 233)),
            label: Text(
              'S\'inscrire',
              style: TextStyle(color: const Color.fromARGB(255, 97, 13, 233)),
            ),
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
                  'images/chariot.jpg',
                  height: 150,
                  width: 200,
                ),
                SizedBox(height: 30.0),
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
                      icon: Icon(_obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  obscureText: _obscureText,
                  validator: (val) => (val?.length ?? 0) < 6
                      ? 'Le mot de passe doit contenir au moins 6 caractères'
                      : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
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
                ),
                SizedBox(height: 20.0),
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
                          'Se connecter',
                          style: TextStyle(fontSize: 16),
                        ),
                  onPressed: loading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() => loading = true);

                            try {
                              await authService.signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                              // Redirection vers l'écran d'accueil après une connexion réussie
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
                            } catch (e) {
                              setState(() {
                                error =
                                    'Identifiants incorrects. Veuillez réessayer.';
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
