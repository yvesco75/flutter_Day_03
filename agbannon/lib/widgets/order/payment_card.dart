// payment_card.dart

class PaymentCard {
  String cardNumber;
  String expirationDate; // MM/YY format
  String cvv;
  String cardholderName;

  PaymentCard({
    required this.cardNumber,
    required this.expirationDate,
    required this.cvv,
    required this.cardholderName,
  });

  // Method to validate card number (basic example)
  bool isValidCardNumber() {
    // Basic validation: Ensure card number is not empty and has a length between 13 and 16 digits.
    return cardNumber.isNotEmpty &&
        cardNumber.length >= 13 &&
        cardNumber.length <= 16 &&
        RegExp(r'^\d+$').hasMatch(cardNumber);
  }

  // Method to validate expiration date
  bool isValidExpirationDate() {
    // Basic validation: Ensure date is in MM/YY format and month is between 1 and 12.
    final parts = expirationDate.split('/');
    if (parts.length != 2) return false;
    final month = int.parse(parts[0]);
    final year = int.parse(parts[1]);
    return month >= 1 && month <= 12 && year >= 0;
  }

  // Method to validate CVV
  bool isValidCVV() {
    // Basic validation: Ensure CVV is not empty and has a length of 3 or 4 digits.
    return cvv.isNotEmpty &&
        (cvv.length == 3 || cvv.length == 4) &&
        RegExp(r'^\d+$').hasMatch(cvv);
  }

  // Method to validate cardholder name
  bool isValidCardholderName() {
    // Basic validation: Ensure name is not empty.
    return cardholderName.isNotEmpty;
  }

  // Method to validate the entire card
  bool isValid() {
    return isValidCardNumber() &&
        isValidExpirationDate() &&
        isValidCVV() &&
        isValidCardholderName();
  }
}
