class CreditCardValidator {
  static const STRIP_REGEX = r'[^\d]';
  static const int minLength = 13;
  static const int maxLength = 19;

  static String strip(String card) {
    RegExp regExp = RegExp(STRIP_REGEX);
    return card.replaceAll(regExp, "");
  }

  static bool _luhnCheck(String card) {
    int sum = 0;
    bool alternate = false;
    for (int i = card.length - 1; i >= 0; i--) {
      int n = int.parse(card[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n -= 9;
        }
      }
      sum += n;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  static bool isValid(String card, [stripBeforeValidation = true]) {
    if (stripBeforeValidation) {
      card = strip(card);
    }
    if (card.isEmpty) {
      return false;
    }
    if (card.length < minLength || card.length > maxLength) {
      return false;
    }
    if (!RegExp(r'^\d+$').hasMatch(card)) {
      return false;
    }
    if (RegExp(r'^(\d)\1+$').hasMatch(card)) {
      return false;
    }
    return _luhnCheck(card);
  }
}
