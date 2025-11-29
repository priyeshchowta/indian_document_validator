import 'utils.dart';
import 'pan_validator.dart';

/// GSTIN (Goods and Services Tax Identification Number) validator.
///
/// GSTIN format: 15 characters
/// Structure: 2-digit state code + 10-char PAN + 1 entity code + 1 checksum
class GstinValidator {
  /// Validates a GSTIN number.
  ///
  /// [input] - The GSTIN string to validate
  /// Returns true if valid (format + PAN + checksum), false otherwise
  static bool validate(String input) {
    final sanitized = sanitizeInput(input);

    // Check basic format
    if (sanitized.length != 15) {
      return false;
    }

    // Check state code (first 2 digits)
    final stateCode = sanitized.substring(0, 2);
    if (!ValidationPatterns.validStateCodes.contains(stateCode)) {
      return false;
    }

    // Check PAN portion (characters 2-12)
    final panPortion = sanitized.substring(2, 12);
    if (!PanValidator.validate(panPortion)) {
      return false;
    }

    // Check 13th character (entity code)
    final entityCode = sanitized.substring(12, 13);
    if (!RegExp(r'^[1-9A-Z]$').hasMatch(entityCode)) {
      return false;
    }

    // Check 14th character (should be 'Z')
    if (sanitized.substring(13, 14) != 'Z') {
      return false;
    }

    // Validate checksum
    return GstChecksum.validate(sanitized);
  }

  /// Validates a GSTIN number with detailed result.
  ///
  /// [input] - The GSTIN string to validate
  /// Returns [GstinValidationResult] with validation details
  static GstinValidationResult validateDetailed(String input) {
    if (input.isEmpty) {
      return const GstinValidationResult(
        isValid: false,
        error: 'GSTIN cannot be empty',
      );
    }

    final sanitized = sanitizeInput(input);

    if (sanitized.length != 15) {
      return const GstinValidationResult(
        isValid: false,
        error: 'GSTIN must be 15 characters long',
      );
    }

    // Check state code
    final stateCode = sanitized.substring(0, 2);
    if (!ValidationPatterns.validStateCodes.contains(stateCode)) {
      return const GstinValidationResult(
        isValid: false,
        error: 'Invalid state code in GSTIN',
      );
    }

    // Check PAN portion
    final panPortion = sanitized.substring(2, 12);
    if (!PanValidator.validate(panPortion)) {
      return const GstinValidationResult(
        isValid: false,
        error: 'Invalid PAN in GSTIN',
      );
    }

    // Check entity code
    final entityCode = sanitized.substring(12, 13);
    if (!RegExp(r'^[1-9A-Z]$').hasMatch(entityCode)) {
      return const GstinValidationResult(
        isValid: false,
        error: 'Invalid entity code in GSTIN',
      );
    }

    // Check Z character
    if (sanitized.substring(13, 14) != 'Z') {
      return const GstinValidationResult(
        isValid: false,
        error: 'GSTIN must have Z as 14th character',
      );
    }

    // Validate checksum
    if (!GstChecksum.validate(sanitized)) {
      return const GstinValidationResult(
        isValid: false,
        error: 'GSTIN checksum validation failed',
      );
    }

    return GstinValidationResult(
      isValid: true,
      stateCode: stateCode,
      panNumber: panPortion,
    );
  }

  /// Normalizes a GSTIN by removing spaces/hyphens and converting to uppercase.
  ///
  /// [input] - The GSTIN string to normalize
  /// Returns normalized GSTIN string
  static String normalize(String input) {
    return sanitizeInput(input);
  }

  /// Extracts the PAN number from a valid GSTIN.
  ///
  /// [input] - The GSTIN string
  /// Returns PAN portion of the GSTIN
  /// Throws [ArgumentError] if GSTIN is invalid
  static String extractPan(String input) {
    final sanitized = sanitizeInput(input);
    if (!GstChecksum.validate(sanitized)) {
      throw ArgumentError('Invalid GSTIN format');
    }

    return sanitized.substring(2, 12);
  }

  /// Extracts the state code from a valid GSTIN.
  ///
  /// [input] - The GSTIN string
  /// Returns state code portion of the GSTIN
  /// Throws [ArgumentError] if GSTIN is invalid
  static String extractStateCode(String input) {
    final sanitized = sanitizeInput(input);
    if (!GstChecksum.validate(sanitized)) {
      throw ArgumentError('Invalid GSTIN format');
    }

    return sanitized.substring(0, 2);
  }

  /// Gets the state name for a given state code.
  ///
  /// [stateCode] - The 2-digit state code
  /// Returns state name or null if not found
  static String? getStateName(String stateCode) {
    const stateNames = {
      '01': 'Jammu and Kashmir',
      '02': 'Himachal Pradesh',
      '03': 'Punjab',
      '04': 'Chandigarh',
      '05': 'Uttarakhand',
      '06': 'Haryana',
      '07': 'Delhi',
      '08': 'Rajasthan',
      '09': 'Uttar Pradesh',
      '10': 'Bihar',
      '11': 'Sikkim',
      '12': 'Arunachal Pradesh',
      '13': 'Nagaland',
      '14': 'Manipur',
      '15': 'Mizoram',
      '16': 'Tripura',
      '17': 'Meghalaya',
      '18': 'Assam',
      '19': 'West Bengal',
      '20': 'Jharkhand',
      '21': 'Odisha',
      '22': 'Chhattisgarh',
      '23': 'Madhya Pradesh',
      '24': 'Gujarat',
      '25': 'Daman and Diu',
      '26': 'Dadra and Nagar Haveli',
      '27': 'Maharashtra',
      '28': 'Andhra Pradesh',
      '29': 'Karnataka',
      '30': 'Goa',
      '31': 'Lakshadweep',
      '32': 'Kerala',
      '33': 'Tamil Nadu',
      '34': 'Puducherry',
      '35': 'Andaman and Nicobar Islands',
      '36': 'Telangana',
      '37': 'Andhra Pradesh (New)',
      '97': 'Other Territory',
    };

    return stateNames[stateCode];
  }
}
