import 'utils.dart';

/// Aadhaar validator for Indian Unique Identification Number.
/// 
/// Aadhaar format: 12 digits with Verhoeff checksum validation
class AadhaarValidator {
  /// Validates an Aadhaar number using Verhoeff checksum algorithm.
  /// 
  /// [input] - The Aadhaar string to validate
  /// Returns true if valid (format + checksum), false otherwise
  static bool validate(String input) {
    final sanitized = sanitizeInput(input);
    
    // Check basic format
    if (!ValidationPatterns.aadhaarPattern.hasMatch(sanitized)) {
      return false;
    }

    // Reject numbers with all identical digits
      if (RegExp(r'^(\d)\1{11}$').hasMatch(sanitized)) {
      return false;
    }
    
    // Check if it starts with 0 or 1 (invalid Aadhaar numbers)
    if (sanitized.startsWith('0') || sanitized.startsWith('1')) {
      return false;
    }
    
    // Validate Verhoeff checksum
    return VerhoeffChecksum.validate(sanitized);
  }
  
  /// Validates an Aadhaar number with detailed result.
  /// 
  /// [input] - The Aadhaar string to validate
  /// Returns [AadhaarValidationResult] with validation details
  static AadhaarValidationResult validateDetailed(String input) {
    if (input.isEmpty) {
      return const AadhaarValidationResult(
        isValid: false,
        error: 'Aadhaar cannot be empty',
      );
    }
    
    final sanitized = sanitizeInput(input);
    
    if (sanitized.length != 12) {
      return const AadhaarValidationResult(
        isValid: false,
        error: 'Aadhaar must be 12 digits long',
      );
    }
    
    if (!ValidationPatterns.aadhaarPattern.hasMatch(sanitized)) {
      return const AadhaarValidationResult(
        isValid: false,
        error: 'Aadhaar must contain only digits',
      );
    }
    
    if (sanitized.startsWith('0') || sanitized.startsWith('1')) {
      return const AadhaarValidationResult(
        isValid: false,
        error: 'Aadhaar cannot start with 0 or 1',
      );
    }
    
    if (!VerhoeffChecksum.validate(sanitized)) {
      return const AadhaarValidationResult(
        isValid: false,
        error: 'Aadhaar checksum validation failed',
      );
    }
    
    return AadhaarValidationResult(
      isValid: true,
      maskedAadhaar: mask(sanitized),
    );
  }
  
  /// Normalizes an Aadhaar by removing spaces and hyphens.
  /// 
  /// [input] - The Aadhaar string to normalize
  /// Returns normalized Aadhaar string
  static String normalize(String input) {
    return sanitizeInput(input);
  }
  
  /// Masks an Aadhaar for display purposes (shows only last 4 digits).
  /// 
  /// [input] - The Aadhaar string to mask
  /// Returns masked Aadhaar string (e.g., XXXX XXXX 1234)
  static String mask(String input) {
    final sanitized = sanitizeInput(input);
    if (!validate(sanitized)) {
      throw ArgumentError('Invalid Aadhaar format');
    }
    
    final lastFour = sanitized.substring(8);
    return 'XXXX XXXX $lastFour';
  }
  
  /// Formats an Aadhaar with standard spacing (XXXX XXXX XXXX).
  /// 
  /// [input] - The Aadhaar string to format
  /// Returns formatted Aadhaar string
  static String format(String input) {
    final sanitized = sanitizeInput(input);
    if (!validate(sanitized)) {
      throw ArgumentError('Invalid Aadhaar format');
    }
    
    return '${sanitized.substring(0, 4)} ${sanitized.substring(4, 8)} ${sanitized.substring(8)}';
  }
}