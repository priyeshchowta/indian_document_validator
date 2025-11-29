/// Pure Dart validators for Indian identification codes and financial codes.
/// 
/// This library provides offline validation for:
/// - PAN (Permanent Account Number)
/// - Aadhaar (Unique Identification Number)
/// - GSTIN (Goods and Services Tax Identification Number)
/// - IFSC (Indian Financial System Code)
/// - UPI VPA (Virtual Payment Address)
/// 
/// All validators work without network requests or external data dependencies.
library indian_document_validators;

// Export all validators
export 'src/pan_validator.dart';
export 'src/aadhaar_validator.dart';
export 'src/gstin_validator.dart';
export 'src/ifsc_validator.dart';
export 'src/upi_vpa_validator.dart';

// Export utility classes for detailed validation results
export 'src/utils.dart' show 
  ValidationResult,
  PanValidationResult,
  AadhaarValidationResult,
  GstinValidationResult,
  IfscValidationResult,
  UpiVpaValidationResult,
  VerhoeffChecksum,
  GstChecksum,
  ValidationPatterns,
  sanitizeInput,
  sanitizeInputPreserveCase;