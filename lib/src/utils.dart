// Utility functions for Indian document validators.

/// Sanitizes input string by removing spaces, hyphens, and converting to uppercase.
String sanitizeInput(String input) {
  return input.replaceAll(RegExp(r'[\s\-]'), '').toUpperCase();
}

/// Sanitizes input string preserving case (for UPI VPA).
String sanitizeInputPreserveCase(String input) {
  return input.replaceAll(RegExp(r'[\s]'), '');
}

/// Verhoeff checksum implementation for Aadhaar validation.
class VerhoeffChecksum {
  // Multiplication table (d)
  static const List<List<int>> _d = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
    [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
    [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
    [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
    [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
    [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
    [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
    [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
  ];

  // Permutation table (p)
  static const List<List<int>> _p = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8],
  ];

  // Inverse table (inv)
  static const List<int> _inv = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9];

  /// Validates Verhoeff checksum for the given number string.
  static bool validate(String number) {
    if (number.isEmpty) return false;
    int c = 0;
    final digits = number.split('').map(int.parse).toList().reversed.toList();
    for (int i = 0; i < digits.length; i++) {
      c = _d[c][_p[i % 8][digits[i]]];
    }
    return c == 0;
  }

  /// Generates the Verhoeff check digit for a given numeric string.
  /// Provide the number without the check digit; returns a single digit char.
  static String generate(String numberWithoutCheckDigit) {
    if (numberWithoutCheckDigit.isEmpty) {
      throw ArgumentError('Input cannot be empty');
    }
    final digits = numberWithoutCheckDigit
        .split('')
        .map(int.parse)
        .toList()
        .reversed
        .toList();
    int c = 0;
    for (int i = 0; i < digits.length; i++) {
      c = _d[c][_p[(i + 1) % 8][digits[i]]];
    }
    final check = _inv[c];
    return check.toString();
  }
}

/// GST checksum calculation.
class GstChecksum {
  static const String _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _digits = '0123456789';

  /// Calculates GST checksum for the given 14-character string.
  static String calculate(String input) {
    if (input.length != 14) {
      throw ArgumentError('Input must be exactly 14 characters');
    }

    int factor = 2;
    int sum = 0;

    for (int i = input.length - 1; i >= 0; i--) {
      final char = input[i];
      int value;

      if (_digits.contains(char)) {
        value = int.parse(char);
      } else if (_alphabet.contains(char)) {
        value = _alphabet.indexOf(char) + 10;
      } else {
        throw ArgumentError('Invalid character in input: $char');
      }

      int product = factor * value;
      factor = factor == 2 ? 1 : 2;
      sum += (product ~/ 36) + (product % 36);
    }

    int remainder = sum % 36;
    int checkDigit = (36 - remainder) % 36;

    if (checkDigit < 10) {
      return checkDigit.toString();
    } else {
      return _alphabet[checkDigit - 10];
    }
  }

  /// Validates GST checksum for the given 15-character string.
  static bool validate(String gstin) {
    gstin = sanitizeInput(gstin);
    if (gstin.length != 15) return false;

    try {
      final first14 = gstin.substring(0, 14);
      final providedChecksum = gstin.substring(14);
      final calculatedChecksum = calculate(first14);

      return providedChecksum == calculatedChecksum;
    } catch (e) {
      return false;
    }
  }
}

/// Common regex patterns for validation.
class ValidationPatterns {
  /// PAN pattern: 5 letters + 4 digits + 1 letter
  static final RegExp panPattern = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

  /// Aadhaar pattern: 12 digits
  static final RegExp aadhaarPattern = RegExp(r'^[0-9]{12}$');

  /// GSTIN pattern: 15 characters
  static final RegExp gstinPattern =
      RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}[Z]{1}[0-9A-Z]{1}$');

  /// IFSC pattern: 4 letters + 0 + 6 alphanumeric
  static final RegExp ifscPattern = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');

  /// UPI VPA pattern: username@provider
  static final RegExp upiVpaPattern = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z]+$');

  /// State codes for GSTIN validation
  static const List<String> validStateCodes = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '97'
  ];
}

/// Validation result classes for detailed responses.
class ValidationResult {
  final bool isValid;
  final String? error;

  const ValidationResult({required this.isValid, this.error});
}

class PanValidationResult extends ValidationResult {
  final String? normalizedPan;

  const PanValidationResult({
    required super.isValid,
    super.error,
    this.normalizedPan,
  });
}

class AadhaarValidationResult extends ValidationResult {
  final String? maskedAadhaar;

  const AadhaarValidationResult({
    required super.isValid,
    super.error,
    this.maskedAadhaar,
  });
}

class GstinValidationResult extends ValidationResult {
  final String? stateCode;
  final String? panNumber;

  const GstinValidationResult({
    required super.isValid,
    super.error,
    this.stateCode,
    this.panNumber,
  });
}

class IfscValidationResult extends ValidationResult {
  final String? bankCode;
  final String? branchCode;

  const IfscValidationResult({
    required super.isValid,
    super.error,
    this.bankCode,
    this.branchCode,
  });
}

class UpiVpaValidationResult extends ValidationResult {
  final String? username;
  final String? provider;

  const UpiVpaValidationResult({
    required super.isValid,
    super.error,
    this.username,
    this.provider,
  });
}
