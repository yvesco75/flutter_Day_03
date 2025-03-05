import 'package:intl/intl.dart';

// Formatteur de devise pour FCFA
String formatCurrency(double amount) {
  final formatCurrency =
      NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA ', decimalDigits: 0);
  return formatCurrency.format(amount);
}

// Classe DateFormatter
class DateFormatter {
  // Formatteur de date (jour/mois/année)
  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  // Formatteur de date et heure (jour/mois/année heure:minute)
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }
}

// Formatteur de devise pour Euro (classe, utile pour les widgets)
class CurrencyFormatter {
  static String formatPrice(double price) {
    final formatter = NumberFormat.currency(
        locale: 'fr_FR', symbol: '€'); // Adapte la locale et le symbole
    return formatter.format(price);
  }
}
