import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumericInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-numeric characters
    final numericValue = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    return TextEditingValue(
      text: numericValue,
      selection: TextSelection.collapsed(offset: numericValue.length),
    );
  }

}
