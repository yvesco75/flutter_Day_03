import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/routes.dart';
import '../dashboard_screen.dart';
import '../../widgets/common/loading.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  // Fonction pour valider l'email
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    const inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );

    final authProvider = Provider.of<AuthProvider>(context);

    return FlutterLogin(
      logo: const AssetImage('images/profil.jpg'),
      onLogin: (LoginData loginData) async {
        if (loginData.name.isEmpty || loginData.password.isEmpty) {
          return 'Veuillez remplir tous les champs';
        }
        if (!isValidEmail(loginData.name)) {
          return 'Email invalide';
        }

        final success = await authProvider.login(
          email: loginData.name,
          password: loginData.password,
        );

        if (success) {
          Navigator.of(context).pushReplacementNamed(Routes.home);
        }

        return null;
      },
      onSignup: (SignupData signupData) async {
        if (signupData.name == null || signupData.password == null) {
          return 'Veuillez remplir tous les champs';
        }
        if (signupData.name!.isEmpty || signupData.password!.isEmpty) {
          return 'Veuillez remplir tous les champs';
        }

        final confirmPassword =
            signupData.additionalSignupData?['confirmPassword'];
        if (signupData.password != confirmPassword) {
          return 'Les mots de passe ne correspondent pas';
        }

        final name = signupData.additionalSignupData?['name'];
        final phone = signupData.additionalSignupData?['phone'];

        print('Nom: $name, Téléphone: $phone');

        return null;
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ));
      },
      onRecoverPassword: (String email) async {
        if (email.isEmpty || !isValidEmail(email)) {
          return 'Email invalide';
        }
        return null;
      },
      additionalSignupFields: [
        UserFormField(
          keyName: 'name',
          displayName: 'Nom',
          icon: const Icon(Icons.person),
          fieldValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre nom';
            }
            return null;
          },
        ),
        UserFormField(
          keyName: 'phone',
          displayName: 'Téléphone',
          icon: const Icon(Icons.phone),
          userType: LoginUserType.phone,
          fieldValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre téléphone';
            }
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'Le téléphone ne doit contenir que des chiffres';
            }
            return null;
          },
        ),
        UserFormField(
          keyName: 'confirmPassword',
          displayName: 'Confirmer le mot de passe',
          icon: const Icon(Icons.lock_outline),
          fieldValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez confirmer votre mot de passe';
            }
            return null;
          },
        ),
      ],
      messages: LoginMessages(
        userHint: 'Email',
        passwordHint: 'Mot de passe',
        confirmPasswordHint: 'Confirmer le mot de passe',
        loginButton: 'SE CONNECTER',
        signupButton: 'S\'INSCRIRE',
        forgotPasswordButton: 'Mot de passe oublié ?',
        recoverPasswordButton: 'RÉCUPÉRER',
        goBackButton: 'RETOUR',
        confirmPasswordError: 'Les mots de passe ne correspondent pas !',
        recoverPasswordDescription:
            'Veuillez entrer votre email pour récupérer votre mot de passe.',
        recoverPasswordSuccess: 'Mot de passe récupéré avec succès',
      ),
      theme: LoginTheme(
        primaryColor: Colors.teal,
        accentColor: Colors.yellow,
        errorColor: Colors.deepOrange,
        titleStyle: const TextStyle(
          color: Colors.greenAccent,
          fontFamily: 'Quicksand',
          letterSpacing: 4,
        ),
        bodyStyle: const TextStyle(
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
        ),
        textFieldStyle: const TextStyle(
          color: Colors.orange,
          shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
        ),
        buttonStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.yellow,
        ),
        cardTheme: CardTheme(
          color: Colors.yellow.shade100,
          elevation: 5,
          margin: const EdgeInsets.only(top: 15),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.purple.withOpacity(.1),
          contentPadding: EdgeInsets.zero,
          errorStyle: const TextStyle(
            backgroundColor: Colors.orange,
            color: Colors.white,
          ),
          labelStyle: const TextStyle(fontSize: 12),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
            borderRadius: inputBorder,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
            borderRadius: inputBorder,
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade700, width: 7),
            borderRadius: inputBorder,
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade400, width: 8),
            borderRadius: inputBorder,
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 5),
            borderRadius: inputBorder,
          ),
        ),
        buttonTheme: LoginButtonTheme(
          splashColor: Colors.purple,
          backgroundColor: Colors.pinkAccent,
          highlightColor: Colors.lightGreen,
          elevation: 9.0,
          highlightElevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
