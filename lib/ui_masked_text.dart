library ui_masked_text;

import 'package:flutter/material.dart';

/// Defines the supported types of data masking.
enum MaskType {
  /// Masks an email address, preserving the first two characters and the domain.
  /// Example: `donjohn@gmail.com` -> `do*****@gmail.com`
  email,

  /// Masks a phone number, preserving only the last few digits.
  /// Example: `+91 98765 43210` -> `••••••••3210`
  phone,

  /// Masks a credit or debit card, preserving only the last 4 digits
  /// and formatting into blocks of 4.
  /// Example: `4111222233334444` -> `•••• •••• •••• 4444`
  creditCard,

  /// Masks a bank account number, hiding all but the last few digits.
  /// Example: `123456789012` -> `••••••••9012`
  bankAccount,

  /// Masks a National ID or Social Security Number into a 3-2-4 layout.
  /// Example: `123456789` -> `•••-••-6789`
  ssn,

  /// Masks an API key, crypto wallet, or token.
  /// Preserves the first 4 and last 4 characters, masking the middle.
  /// Example: `sk_live_998877665544` -> `sk_l••••••••5544`
  token,

  /// Masks a person's name. Preserves the first name and the first letter
  /// of the last name, masking the rest.
  /// Example: `Joe Smith` -> `Joe S••••`
  name,

  /// Allows for a custom masking logic via the [customMasker] callback.
  custom,
}

/// A declarative Flutter widget to safely mask and obfuscate sensitive
/// read-only data (PII) to prevent shoulder-surfing.
class MaskedText extends StatelessWidget {
  /// The raw, unmasked string that needs to be displayed securely.
  final String text;

  /// The category of data being masked.
  ///
  /// If [MaskType.custom] is selected, you must provide a [customMasker] function.
  final MaskType maskType;

  /// The character used to hide the sensitive parts of the string.
  /// Defaults to '•'.
  final String maskChar;

  /// The number of characters to leave visible at the end of the string.
  /// Applies to [MaskType.phone] and [MaskType.bankAccount]. Defaults to 4.
  final int visibleEndChars;

  /// The text style to apply to the masked string.
  final TextStyle? style;

  /// A custom function to handle masking logic not covered by the default types.
  ///
  /// This is only executed if [maskType] is set to [MaskType.custom].
  final String Function(String)? customMasker;

  /// Creates a [MaskedText] widget.
  const MaskedText(
    this.text, {
    super.key,
    required this.maskType,
    this.maskChar = '•',
    this.visibleEndChars = 4,
    this.style,
    this.customMasker,
  })  : assert(
          maskType != MaskType.custom || customMasker != null,
          'A customMasker must be provided when using MaskType.custom',
        ),
        assert(
          visibleEndChars >= 0,
          'visibleEndChars cannot be a negative number',
        ),
        assert(maskChar.length > 0, 'maskChar cannot be an empty string');

  @override
  Widget build(BuildContext context) {
    return Text(_getMaskedText(), style: style);
  }

  /// Routes the raw text to the appropriate internal masking function.
  String _getMaskedText() {
    if (text.isEmpty) return text;

    switch (maskType) {
      case MaskType.email:
        return _maskEmail(text);
      case MaskType.phone:
        return _maskPhone(text);
      case MaskType.creditCard:
        return _maskCreditCard(text);
      case MaskType.bankAccount:
        return _maskBankAccount(text);
      case MaskType.ssn:
        return _maskSsn(text);
      case MaskType.token:
        return _maskToken(text);
      case MaskType.name:
        return _maskName(text);
      case MaskType.custom:
        return customMasker!(text);
    }
  }

  /// Masks an email by keeping the first 2 characters of the username
  /// and the full domain intact.
  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return text;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) {
      return '${maskChar * username.length}@$domain';
    }

    final visible = username.substring(0, 2);
    final masked = maskChar * (username.length - 2);
    return '$visible$masked@$domain';
  }

  /// Masks a phone number by stripping non-numeric characters and hiding
  /// everything except the last [visibleEndChars].
  String _maskPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.length <= visibleEndChars) {
      return maskChar * cleanPhone.length;
    }

    final maskedLength = cleanPhone.length - visibleEndChars;
    final visiblePart = cleanPhone.substring(maskedLength);
    return '${maskChar * maskedLength}$visiblePart';
  }

  /// Masks a credit card into blocks of 4, hiding the first 12 digits.
  String _maskCreditCard(String card) {
    final cleanCard = card.replaceAll(RegExp(r'\D'), '');
    if (cleanCard.length <= 4) return card;

    final lastFour = cleanCard.substring(cleanCard.length - 4);
    final block = maskChar * 4;

    return '$block $block $block $lastFour';
  }

  /// Masks a bank account by removing spaces and hiding everything
  /// except the last [visibleEndChars].
  String _maskBankAccount(String account) {
    final cleanAccount = account.replaceAll(RegExp(r'\s'), '');
    if (cleanAccount.length <= visibleEndChars) {
      return maskChar * cleanAccount.length;
    }

    final maskedLength = cleanAccount.length - visibleEndChars;
    final visiblePart = cleanAccount.substring(maskedLength);
    return '${maskChar * maskedLength}$visiblePart';
  }

  /// Masks a 9-digit SSN or National ID into a standard 3-2-4 format.
  String _maskSsn(String ssn) {
    final cleanSsn = ssn.replaceAll(RegExp(r'\D'), '');
    if (cleanSsn.length != 9) return ssn; // Returns raw if not exactly 9 digits

    final lastFour = cleanSsn.substring(5);
    final block3 = maskChar * 3;
    final block2 = maskChar * 2;

    return '$block3-$block2-$lastFour';
  }

  /// Masks an API token or crypto wallet by preserving the first 4
  /// and last 4 characters.
  String _maskToken(String token) {
    final cleanToken = token.trim();
    if (cleanToken.length <= 8) return token; // Too short to safely mask

    final firstFour = cleanToken.substring(0, 4);
    final lastFour = cleanToken.substring(cleanToken.length - 4);
    final maskedLength = cleanToken.length - 8;

    return '$firstFour${maskChar * maskedLength}$lastFour';
  }

  /// Masks a full name by preserving the first name and the first letter
  /// of the last name.
  String _maskName(String name) {
    final cleanName = name.trim();
    final parts = cleanName.split(RegExp(r'\s+'));

    if (parts.isEmpty || cleanName.isEmpty) return name;

    // Handle single-word names (e.g., just "John")
    if (parts.length == 1) {
      if (cleanName.length <= 2) return cleanName;
      final visible = cleanName.substring(0, 2);
      final masked = maskChar * (cleanName.length - 2);
      return '$visible$masked';
    }

    // Handle multi-word names
    final firstName = parts.first;
    final lastName = parts.last;

    if (lastName.isEmpty) return firstName;

    final maskedLastName = '${lastName[0]}${maskChar * (lastName.length - 1)}';
    return '$firstName $maskedLastName';
  }
}
