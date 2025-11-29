# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-11-29

### Added
- Initial release of Indian Document Validators package
- **PAN Validator**: Format validation, normalization, and masking
- **Aadhaar Validator**: Format validation with Verhoeff checksum algorithm
- **GSTIN Validator**: Comprehensive validation with state code, PAN, and GST checksum
- **IFSC Validator**: Format validation with bank code and branch code extraction
- **UPI VPA Validator**: Format validation with username and provider extraction
- Utility functions for input sanitization and normalization
- Detailed validation results with specific error messages
- Comprehensive test suite with 100+ test cases
- Example Flutter app demonstrating all validators
- Pure Dart implementation with zero external dependencies
- Support for case-insensitive input and automatic normalization
- Bank name and state name lookup functions
- Input formatting and masking utilities

### Features
- ✅ Offline validation without network requests
- ✅ Detailed error messages for debugging
- ✅ Extract components from valid documents (state codes, bank codes, etc.)
- ✅ Format and mask sensitive information
- ✅ Support for common input formats (with spaces, hyphens, different cases)
- ✅ Production-ready with comprehensive testing

### Validation Algorithms
- Implemented Verhoeff checksum algorithm for Aadhaar validation
- Implemented GST checksum algorithm for GSTIN validation
- Added state code validation for GSTIN
- Added comprehensive format validation for all document types

### Documentation
- Comprehensive README with usage examples
- API documentation with detailed examples
- Example Flutter app with interactive validation
- Changelog following semantic versioning