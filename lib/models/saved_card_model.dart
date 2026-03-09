class SavedCard {
  final String id;
  final String holderName;
  final String cardNumber; // full number, mask when showing
  final String expiryMonth;
  final String expiryYear;

  SavedCard({
    required this.id,
    required this.holderName,
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
  });

  String get maskedNumber {
    if (cardNumber.length < 4) return cardNumber;
    final last4 = cardNumber.substring(cardNumber.length - 4);
    return "**** **** **** $last4";
  }
}

