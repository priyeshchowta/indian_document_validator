import 'utils.dart';

/// PAN (Permanent Account Number) validator for Indian tax identification.
/// 
/// PAN format: 5 letters + 4 digits + 1 letter (e.g., ABCDE1234F)
class PanValidator {
  /// Validates a PAN number.
  /// 
  /// [input] - The PAN string to validate
  /// Returns true if valid, false otherwise
  static bool validate(String input) {
    final sanitized = sanitizeInput(input);
    return ValidationPatterns.panPattern.hasMatch(sanitized);
  }
  
  /// Validates a PAN number with detailed result.
  /// 
  /// [input] - The PAN string to validate
  /// Returns [PanValidationResult] with validation details
  static PanValidationResult validateDetailed(String input) {
    if (input.isEmpty) {
      return const PanValidationResult(
        isValid: false,
        error: 'PAN cannot be empty',
      );
    }
    
    final sanitized = sanitizeInput(input);
    
    if (sanitized.length != 10) {
      return const PanValidationResult(
        isValid: false,
        error: 'PAN must be 10 characters long',
      );
    }
    
    if (!ValidationPatterns.panPattern.hasMatch(sanitized)) {
      return const PanValidationResult(
        isValid: false,
        error: 'PAN format is invalid. Expected format: 5 letters + 4 digits + 1 letter',
      );
    }
    
    return PanValidationResult(
      isValid: true,
      normalizedPan: sanitized,
    );
  }
  
  /// Normalizes a PAN by removing spaces/hyphens and converting to uppercase.
  /// 
  /// [input] - The PAN string to normalize
  /// Returns normalized PAN string
  static String normalize(String input) {
    return sanitizeInput(input);
  }
  
  /// Masks a PAN for display purposes (shows only first 3 and last character).
  /// 
  /// [input] - The PAN string to mask
  /// Returns masked PAN string (e.g., ABC****F)
  static String mask(String input) {
    final sanitized = sanitizeInput(input);
    if (!validate(sanitized)) {
      throw ArgumentError('Invalid PAN format');
    }
    
    return '${sanitized.substring(0, 3)}${'*' * 6}${sanitized.substring(9)}';
  }
}