// lib/utils/validators.dart

class Validators {
  // Validation pour les champs obligatoires
  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire';
    }
    return null;
  }

  // Validation pour l'email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'email est obligatoire';
    }

    // Expression régulière pour valider un email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer une adresse email valide';
    }

    return null;
  }

  // Validation pour le numéro de téléphone
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le numéro de téléphone est obligatoire';
    }

    // Expression régulière pour valider un numéro de téléphone (accepte différents formats)
    final phoneRegex = RegExp(r'^\+?[0-9]{8,}$');

    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'\s|-|\(|\)'), ''))) {
      return 'Veuillez entrer un numéro de téléphone valide';
    }

    return null;
  }

  // Validation pour le mot de passe
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est obligatoire';
    }

    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }

    return null;
  }

  // Validation pour la confirmation du mot de passe
  static String? validateConfirmPassword(
    String password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'La confirmation du mot de passe est obligatoire';
    }

    if (password != confirmPassword) {
      return 'Les mots de passe ne correspondent pas';
    }

    return null;
  }
}
