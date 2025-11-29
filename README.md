# Indian Document Validators

[![Pub Version](https://img.shields.io/pub/v/indian_document_validators)](https://pub.dev/packages/indian_document_validators)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive Flutter/Dart package for offline validation of Indian identification codes and financial codes. This package provides pure Dart implementations that work without network requests or external data dependencies.

## Features

✅ **Pure Dart Implementation** - Works offline without network requests  
✅ **Comprehensive Validation** - Supports format, checksum, and business rule validation  
✅ **Detailed Results** - Get specific error messages and extracted information  
✅ **Production Ready** - Thoroughly tested with edge cases  
✅ **Zero Dependencies** - No external packages required  

## Supported Document Types

| Document Type | Description | Validation Features |
|---------------|-------------|-------------------|
| **PAN** | Permanent Account Number | Format validation, case normalization |
| **Aadhaar** | Unique Identification Number | Format validation, Verhoeff checksum |
| **GSTIN** | Goods and Services Tax ID | Format, state code, PAN, checksum validation |
| **IFSC** | Indian Financial System Code | Format validation, bank code extraction |
| **UPI VPA** | Virtual Payment Address | Format validation, provider extraction |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  indian_document_validators: ^0.1.0
```

Then run:

```bash
dart pub get
```

## Usage

### Basic Validation

```dart
import 'package:indian_document_validators/indian_document_validators.dart';

// PAN Validation
bool isValidPan = PanValidator.validate('ALWPG5809L');
print(isValidPan); // true

// Aadhaar Validation (with Verhoeff checksum)
// Build a valid sample using Verhoeff check digit
final aadhaarBase = '23412341234';
final aadhaar = aadhaarBase + VerhoeffChecksum.generate(aadhaarBase);
bool isValidAadhaar = AadhaarValidator.validate(aadhaar);
print(isValidAadhaar); // true

// GSTIN Validation (with checksum and state code validation)
// Build a valid sample using GST checksum
final gstinBase = '29ABCDE1234F1Z';
final gstin = gstinBase + GstChecksum.calculate(gstinBase);
bool isValidGstin = GstinValidator.validate(gstin);
print(isValidGstin); // true

// IFSC Validation
bool isValidIfsc = IfscValidator.validate('SBIN0001234');
print(isValidIfsc); // true

// UPI VPA Validation
bool isValidUpi = UpiVpaValidator.validate('user@paytm');
print(isValidUpi); // true
```

### Detailed Validation with Error Messages

```dart
// Get detailed validation results
final panResult = PanValidator.validateDetailed('ALWPG5809L');
if (panResult.isValid) {
  print('Normalized PAN: ${panResult.normalizedPan}');
  print('Masked PAN: ${PanValidator.mask(panResult.normalizedPan!)}');
} else {
  print('Error: ${panResult.error}');
}

// Aadhaar with formatted output
final aadhaarBase = '23412341234';
final aadhaar = aadhaarBase + VerhoeffChecksum.generate(aadhaarBase);
final aadhaarResult = AadhaarValidator.validateDetailed(aadhaar);
if (aadhaarResult.isValid) {
  print('Masked Aadhaar: ${aadhaarResult.maskedAadhaar}');
} else {
  print('Error: ${aadhaarResult.error}');
}

// GSTIN with state and PAN extraction
final gstinBase = '29ABCDE1234F1Z';
final gstin = gstinBase + GstChecksum.calculate(gstinBase);
final gstinResult = GstinValidator.validateDetailed(gstin);
if (gstinResult.isValid) {
  print('State Code: ${gstinResult.stateCode}');
  print('PAN Number: ${gstinResult.panNumber}');
  final stateName = GstinValidator.getStateName(gstinResult.stateCode!);
  print('State Name: $stateName');
}
```

### Utility Functions

```dart
// Normalize and format inputs
String normalizedPan = PanValidator.normalize('alwpg-5809-l');
print(normalizedPan); // ALWPG5809L

String maskedPan = PanValidator.mask('ALWPG5809L');
print(maskedPan); // ALW******L

// Extract components
String bankCode = IfscValidator.extractBankCode('SBIN0001234');
print(bankCode); // SBIN

String bankName = IfscValidator.getBankName('SBIN');
print(bankName); // State Bank of India

String username = UpiVpaValidator.extractUsername('user@paytm');
print(username); // user

String provider = UpiVpaValidator.extractProvider('user@paytm');
print(provider); // paytm
```

## Validation Rules

### PAN (Permanent Account Number)
- **Format**: 5 letters + 4 digits + 1 letter (e.g., ABCDE1234F)
- **Normalization**: Converts to uppercase, removes spaces and hyphens
- **Examples**: ALWPG5809L, BNZAA2318J

### Aadhaar (Unique Identification Number)
- **Format**: 12 digits
- **Checksum**: Validates using Verhoeff algorithm
- **Rules**: Cannot start with 0 or 1
- **Examples**: Use any 11-digit base not starting with 0/1 and append `VerhoeffChecksum.generate(base)`

### GSTIN (Goods and Services Tax Identification Number)
- **Format**: 15 characters (2-digit state + 10-char PAN + 1 entity code + Z + checksum)
- **Validation**: State code, embedded PAN validation, GST checksum algorithm
- **Examples**: Compose the first 14 chars as `SSPANNNNNNELZ` and append `GstChecksum.calculate(first14)`

### IFSC (Indian Financial System Code)
- **Format**: 4 letters + '0' + 6 alphanumeric (e.g., SBIN0001234)
- **Validation**: Bank code format, branch code format
- **Examples**: SBIN0001234, HDFC0000001

### UPI VPA (Virtual Payment Address)
- **Format**: username@provider
- **Rules**: Username allows letters, numbers, dots, hyphens, underscores
- **Provider**: Letters only, no special characters
- **Examples**: user@paytm, john.doe@phonepe

## Error Handling

The package provides detailed error messages for invalid inputs:

```dart
final result = PanValidator.validateDetailed('INVALID123');
print(result.error); // "PAN format is invalid. Expected format: 5 letters + 4 digits + 1 letter"

final aadhaarResult = AadhaarValidator.validateDetailed('123456789012');
print(aadhaarResult.error); // "Aadhaar cannot start with 0 or 1"
```

## Example App

Check out the [example app](example/) for a complete Flutter application demonstrating all validators with a user interface.

## Testing

Run the comprehensive test suite:

```bash
dart pub get
dart test
```

The package includes extensive tests covering:
- Valid and invalid format validation
- Edge cases and boundary conditions  
- Checksum algorithm verification
- Normalization and formatting functions
- Error message accuracy

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This package is for validation purposes only. Always verify document authenticity through official government channels for production use. The checksum algorithms are implemented based on publicly available specifications.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes.

---

**Note**: This is a pure Dart package that performs offline validation. It does not verify the actual existence or authenticity of documents with government databases.