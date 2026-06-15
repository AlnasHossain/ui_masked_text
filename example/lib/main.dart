import 'package:flutter/material.dart';
import 'package:ui_masked_text/ui_masked_text.dart';

void main() {
  runApp(const ExampleApp());
}

/// The main entry point application showcasing the capabilities of the
/// `ui_masked_text` package.
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI Masked Text Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Professional corporate blue
          brightness: Brightness.light,
        ),
      ),
      home: const MaskedTextDemoScreen(),
    );
  }
}

/// A screen showcasing different variations and use cases of the [MaskedText] widget.
class MaskedTextDemoScreen extends StatelessWidget {
  const MaskedTextDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Masked Text Demo'),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildSectionHeader('Standard PII Masking'),
            const SizedBox(height: 16),

            _buildDemoCard(
              label: 'User Name',
              child: const MaskedText(
                'Joe Smith',
                maskType: MaskType.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

            _buildDemoCard(
              label: 'Client Email',
              child: const MaskedText(
                'donjohn@smcfinance.com',
                maskType: MaskType.email,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

            _buildDemoCard(
              label: 'Client Phone',
              child: const MaskedText(
                '+91 98765 43210',
                maskType: MaskType.phone,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

            _buildDemoCard(
              label: 'Credit Card (16 digits)',
              child: const MaskedText(
                '4111222233334444',
                maskType: MaskType.creditCard,
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            _buildDemoCard(
              label: 'Bank Account Number',
              child: const MaskedText(
                '123456789012',
                maskType: MaskType.bankAccount,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

            _buildDemoCard(
              label: 'National ID / SSN',
              child: const MaskedText(
                '123456789',
                maskType: MaskType.ssn,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

            _buildDemoCard(
              label: 'API/Auth Token',
              child: const MaskedText(
                'sk_live_998877665544',
                maskType: MaskType.token,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Custom Masking Control'),
            const SizedBox(height: 16),

            _buildDemoCard(
              label: 'Custom Character & Visibility Control (Phone)',
              child: const MaskedText(
                '9876543210',
                maskType: MaskType.phone,
                maskChar: 'X',
                visibleEndChars: 2,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

            _buildDemoCard(
              label: 'Custom Logic Rule (Internal ID Syntax)',
              child: MaskedText(
                'ABC-FIN-998822',
                maskType: MaskType.custom,
                customMasker: (input) {
                  if (input.length > 8) {
                    return '${input.substring(0, 4)}XXXXXX${input.substring(input.length - 2)}';
                  }
                  return input;
                },
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget to generate structured section labels.
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  /// Helper widget to house each demonstration case neatly within a card layout.
  Widget _buildDemoCard({required String label, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
