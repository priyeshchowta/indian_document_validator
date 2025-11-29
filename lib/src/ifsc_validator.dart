import 'utils.dart';

/// IFSC (Indian Financial System Code) validator.
/// 
/// IFSC format: 11 characters
/// Structure: 4 letters (bank code) + '0' + 6 alphanumeric (branch code)
class IfscValidator {
  /// Validates an IFSC code.
  /// 
  /// [input] - The IFSC string to validate
  /// Returns true if valid, false otherwise
  static bool validate(String input) {
    final sanitized = sanitizeInput(input);
    return ValidationPatterns.ifscPattern.hasMatch(sanitized);
  }
  
  /// Validates an IFSC code with detailed result.
  /// 
  /// [input] - The IFSC string to validate
  /// Returns [IfscValidationResult] with validation details
  static IfscValidationResult validateDetailed(String input) {
    if (input.isEmpty) {
      return const IfscValidationResult(
        isValid: false,
        error: 'IFSC cannot be empty',
      );
    }
    
    final sanitized = sanitizeInput(input);
    
    if (sanitized.length != 11) {
      return const IfscValidationResult(
        isValid: false,
        error: 'IFSC must be 11 characters long',
      );
    }
    
    // Check bank code (first 4 characters)
    final bankCode = sanitized.substring(0, 4);
    if (!RegExp(r'^[A-Z]{4}$').hasMatch(bankCode)) {
      return const IfscValidationResult(
        isValid: false,
        error: 'Bank code must be 4 letters',
      );
    }
    
    // Check 5th character (must be '0')
    if (sanitized[4] != '0') {
      return const IfscValidationResult(
        isValid: false,
        error: '5th character of IFSC must be 0',
      );
    }
    
    // Check branch code (last 6 characters)
    final branchCode = sanitized.substring(5);
    if (!RegExp(r'^[A-Z0-9]{6}$').hasMatch(branchCode)) {
      return const IfscValidationResult(
        isValid: false,
        error: 'Branch code must be 6 alphanumeric characters',
      );
    }
    
    return IfscValidationResult(
      isValid: true,
      bankCode: bankCode,
      branchCode: branchCode,
    );
  }
  
  /// Normalizes an IFSC by removing spaces/hyphens and converting to uppercase.
  /// 
  /// [input] - The IFSC string to normalize
  /// Returns normalized IFSC string
  static String normalize(String input) {
    return sanitizeInput(input);
  }
  
  /// Extracts the bank code from a valid IFSC.
  /// 
  /// [input] - The IFSC string
  /// Returns bank code portion of the IFSC
  /// Throws [ArgumentError] if IFSC is invalid
  static String extractBankCode(String input) {
    final sanitized = sanitizeInput(input);
    if (!validate(sanitized)) {
      throw ArgumentError('Invalid IFSC format');
    }
    
    return sanitized.substring(0, 4);
  }
  
  /// Extracts the branch code from a valid IFSC.
  /// 
  /// [input] - The IFSC string
  /// Returns branch code portion of the IFSC
  /// Throws [ArgumentError] if IFSC is invalid
  static String extractBranchCode(String input) {
    final sanitized = sanitizeInput(input);
    if (!validate(sanitized)) {
      throw ArgumentError('Invalid IFSC format');
    }
    
    return sanitized.substring(5);
  }
  
  /// Gets bank name for common bank codes.
  /// 
  /// [bankCode] - The 4-character bank code
  /// Returns bank name or null if not found
  static String? getBankName(String bankCode) {
    const bankNames = {
      'SBIN': 'State Bank of India',
      'HDFC': 'HDFC Bank',
      'ICIC': 'ICICI Bank',
      'AXIS': 'Axis Bank',
      'PUNB': 'Punjab National Bank',
      'BARB': 'Bank of Baroda',
      'CNRB': 'Canara Bank',
      'UBIN': 'Union Bank of India',
      'IDIB': 'Indian Bank',
      'IOBA': 'Indian Overseas Bank',
      'ALLA': 'Allahabad Bank',
      'CBIN': 'Central Bank of India',
      'CORP': 'Corporation Bank',
      'INDB': 'IndusInd Bank',
      'KKBK': 'Kotak Mahindra Bank',
      'YESB': 'Yes Bank',
      'FDRL': 'Federal Bank',
      'KARB': 'Karnataka Bank',
      'KVBL': 'Karur Vysya Bank',
      'SCBL': 'Standard Chartered Bank',
      'HSBC': 'HSBC Bank',
      'CIUB': 'City Union Bank',
      'DCBL': 'DCB Bank',
      'DBSS': 'DBS Bank',
      'NKGS': 'NKGSB Co-op Bank',
      'RATN': 'RBL Bank',
      'TMBL': 'Tamilnad Mercantile Bank',
      'UTBI': 'United Bank of India',
      'VIJB': 'Vijaya Bank',
    };
    
    return bankNames[bankCode.toUpperCase()];
  }
}