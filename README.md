# UI Masked Text

A simple, declarative Flutter widget to safely mask and obfuscate sensitive read-only data (Personally Identifiable Information) to prevent shoulder-surfing.

Stop writing messy regex in your `utils.dart` file and use a dedicated UI component designed for financial dashboards, CRM ledgers, and secure profile screens.

## Features
* **7 Built-in PII Formats:** Standardized masking for `email`, `phone`, `creditCard`, `bankAccount`, `ssn`, `token` (API/Crypto), and `name`.
* **Custom Logic Escape Hatch:** Use `MaskType.custom` to pass your own masking function for internal company IDs, wallet addresses, or license plates.
* **Highly Customizable:** Easily override the default `•` masking character, adjust the number of visible ending characters, and pass custom `TextStyle`s.
* **Zero Dependencies:** Built entirely with pure Dart string manipulation. No native code, no transient dependencies, guaranteeing a perfect 140/140 pub.dev score.

## Getting started
Add `ui_masked_text` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  ui_masked_text: ^0.0.1
```

## Basic Usage

Import the package and drop the `MaskedText` widget anywhere you'd normally use a standard `Text` widget.

```dart
import 'package:ui_masked_text/ui_masked_text.dart';

// 1. User Name (Preserves first name and first letter of last name)
MaskedText('Joe Smith', maskType: MaskType.name) 
// Renders: Joe S••••

// 2. Email (Keeps the first 2 letters and the domain intact)
MaskedText('donjohn@gmail.com', maskType: MaskType.email) 
// Renders: do*****@gmail.com

// 3. Phone Number (Shows only the last 4 digits)
MaskedText('+91 98765 43210', maskType: MaskType.phone) 
// Renders: •••••••••3210

// 4. Credit Card (Formats into blocks of 4)
MaskedText('4111222233334444', maskType: MaskType.creditCard) 
// Renders: •••• •••• •••• 4444

// 5. Bank Account (Hides all but the last 4 digits)
MaskedText('123456789012', maskType: MaskType.bankAccount) 
// Renders: ••••••••9012

// 6. National ID / SSN (Formats to 3-2-4)
MaskedText('123456789', maskType: MaskType.ssn) 
// Renders: •••-••-6789

// 7. API / Crypto Token (Shows first 4 and last 4)
MaskedText('sk_live_998877665544', maskType: MaskType.token) 
// Renders: sk_l••••••••5544
```

## Customization & Advanced Usage

You have full control over the masking characters, the visibility length, and the text styling.

```dart
// Customize the mask character and visible tail length
MaskedText(
  '9876543210',
  maskType: MaskType.phone,
  maskChar: 'X',
  visibleEndChars: 2,
  style: TextStyle(fontSize: 16, color: Colors.grey),
) // Renders: XXXXXXXX10

// Use a completely custom rule for internal/custom IDs
MaskedText(
  'ABC-FIN-998822',
  maskType: MaskType.custom,
  customMasker: (String input) {
    if (input.length > 8) {
      return '${input.substring(0, 4)}XXXXXX${input.substring(input.length - 2)}';
    }
    return input;
  },
) // Renders: SMC-XXXXXX22
```

Check out the `example/` folder for a fully working demonstration!