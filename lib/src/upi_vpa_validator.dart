import 'utils.dart';

/// UPI VPA (Virtual Payment Address) validator.
/// 
/// UPI VPA format: username@provider
/// Username: alphanumeric with dots, hyphens, underscores allowed
/// Provider: alphabetic characters only
class UpiVpaValidator {
  /// Validates a UPI VPA.
  /// 
  /// [input] - The UPI VPA string to validate
  /// Returns true if valid, false otherwise
  static bool validate(String input) {
    final sanitized = sanitizeInputPreserveCase(input);
    
    if (sanitized.isEmpty || !sanitized.contains('@')) {
      return false;
    }
    
    final parts = sanitized.split('@');
    if (parts.length != 2) {
      return false;
    }
    
    final username = parts[0];
    final provider = parts[1];
    
    // Validate username
    if (username.isEmpty || username.length > 50) {
      return false;
    }
    
    if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(username)) {
      return false;
    }
    
    // Username cannot start or end with special characters
    if (RegExp(r'^[._-]|[._-]$').hasMatch(username)) {
      return false;
    }
    
    // Username cannot have consecutive special characters
    if (RegExp(r'[._-]{2,}').hasMatch(username)) {
      return false;
    }
    
    // Validate provider
    if (provider.isEmpty || provider.length > 30) {
      return false;
    }
    
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(provider)) {
      return false;
    }
    
    return true;
  }
  
  /// Validates a UPI VPA with detailed result.
  /// 
  /// [input] - The UPI VPA string to validate
  /// Returns [UpiVpaValidationResult] with validation details
  static UpiVpaValidationResult validateDetailed(String input) {
    if (input.isEmpty) {
      return const UpiVpaValidationResult(
        isValid: false,
        error: 'UPI VPA cannot be empty',
      );
    }
    
    final sanitized = sanitizeInputPreserveCase(input);
    
    if (!sanitized.contains('@')) {
      return const UpiVpaValidationResult(
        isValid: false,
        error: 'UPI VPA must contain @ symbol',
      );
    }
    
    final parts = sanitized.split('@');
    if (parts.length != 2) {
      return const UpiVpaValidationResult(
        isValid: false,
        error: 'UPI VPA must have exactly one @ symbol',
      );
    }
    
    final username = parts[0];
    final provider = parts[1];
    
    // Validate username
    if (username.isEmpty) {
      return const UpiVpaValidationResult(
        isValid: false,
        error: 'Username cannot be empty',
      );
    }
    
    if (username.length > 50) {
      return const UpiVpaValidationResult(
        isValid: false,
        error: 'Username cannot be longer than 50 characters',
      );
    }
    
    if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(username)) {
      return const UpiVpaValidationResult(
        isValid: false,
        error: 'Username can only contain letters, numbers, dots, hyphens, and underscores',
      );
    }
    
    if (RegExp(r'^[._-]|[._-]$').hasMatch(username)) {
      return const UpiVpaValidationResult(
        isValid: false,
        error: 'Username cannot start or end with special characters',
      );
    }
    
    if (RegExp(r'[._-]{2,}').hasMatch(username)) {
      return const UpiVpaValidationResult(
        isValid: false,
        error: 'Username cannot have consecutive special characters',
      );
    }
    
    // Validate provider
    if (provider.isEmpty) {
      return const UpiVpaValidationResult(
        isValid: false,
        error: 'Provider cannot be empty',
      );
    }
    
    if (provider.length > 30) {
      return const UpiVpaValidationResult(
        isValid: false,
        error: 'Provider cannot be longer than 30 characters',
      );
    }
    
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(provider)) {
      return const UpiVpaValidationResult(
        isValid: false,
        error: 'Provider can only contain letters',
      );
    }
    
    return UpiVpaValidationResult(
      isValid: true,
      username: username,
      provider: provider,
    );
  }
  
  /// Normalizes a UPI VPA by removing spaces.
  /// 
  /// [input] - The UPI VPA string to normalize
  /// Returns normalized UPI VPA string
  static String normalize(String input) {
    return sanitizeInputPreserveCase(input);
  }
  
  /// Extracts the username from a valid UPI VPA.
  /// 
  /// [input] - The UPI VPA string
  /// Returns username portion of the UPI VPA
  /// Throws [ArgumentError] if UPI VPA is invalid
  static String extractUsername(String input) {
    final sanitized = sanitizeInputPreserveCase(input);
    if (!validate(sanitized)) {
      throw ArgumentError('Invalid UPI VPA format');
    }
    
    return sanitized.split('@')[0];
  }
  
  /// Extracts the provider from a valid UPI VPA.
  /// 
  /// [input] - The UPI VPA string
  /// Returns provider portion of the UPI VPA
  /// Throws [ArgumentError] if UPI VPA is invalid
  static String extractProvider(String input) {
    final sanitized = sanitizeInputPreserveCase(input);
    if (!validate(sanitized)) {
      throw ArgumentError('Invalid UPI VPA format');
    }
    
    return sanitized.split('@')[1];
  }
  
  /// Gets provider name for common UPI providers.
  /// 
  /// [provider] - The provider code
  /// Returns provider name or null if not found
  static String? getProviderName(String provider) {
    const providerNames = {
      'paytm': 'Paytm',
      'phonepe': 'PhonePe',
      'googlepay': 'Google Pay',
      'gpay': 'Google Pay',
      'amazonpay': 'Amazon Pay',
      'ybl': 'Yes Bank',
      'axl': 'Axis Bank',
      'hdfcbank': 'HDFC Bank',
      'sbi': 'State Bank of India',
      'icici': 'ICICI Bank',
      'okaxis': 'Axis Bank',
      'okhdfc': 'HDFC Bank',
      'oksbi': 'State Bank of India',
      'okicici': 'ICICI Bank',
      'upi': 'UPI',
      'jupiteraxis': 'Jupiter (Axis Bank)',
      'indus': 'IndusInd Bank',
      'kotak': 'Kotak Mahindra Bank',
      'pnb': 'Punjab National Bank',
      'cnrb': 'Canara Bank',
      'ibl': 'IDBI Bank',
      'federal': 'Federal Bank',
      'boi': 'Bank of India',
      'ubi': 'Union Bank of India',
      'psb': 'Punjab & Sind Bank',
      'corp': 'Corporation Bank',
      'vijb': 'Vijaya Bank',
      'dbs': 'DBS Bank',
      'sc': 'Standard Chartered',
      'hsbc': 'HSBC',
      'citi': 'Citibank',
    };
    
    return providerNames[provider.toLowerCase()];
  }
}