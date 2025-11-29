import 'package:test/test.dart';
import 'package:indian_document_validators/indian_document_validators.dart';

void main() {
  group('AadhaarValidator', () {
    group('validate', () {
      test('should return true for valid Aadhaar numbers', () {
        // Build valid Aadhaar numbers using Verhoeff check digit
        final a1 = '23412341234' + VerhoeffChecksum.generate('23412341234');
        final a2 = '37894561235' + VerhoeffChecksum.generate('37894561235');
        final a3 = '52345678901' + VerhoeffChecksum.generate('52345678901');
        expect(AadhaarValidator.validate(a1), true);
        expect(AadhaarValidator.validate(a2), true);
        expect(AadhaarValidator.validate(a3), true);
      });

      test('should return true for valid Aadhaar with spaces and hyphens', () {
        final a = '23412341234' + VerhoeffChecksum.generate('23412341234');
        expect(
            AadhaarValidator.validate(
                '${a.substring(0, 4)}-${a.substring(4, 8)}-${a.substring(8)}'),
            true);
        expect(
            AadhaarValidator.validate(
                '${a.substring(0, 4)} ${a.substring(4, 8)} ${a.substring(8)}'),
            true);
        expect(AadhaarValidator.validate(' $a '), true);
      });

      test('should return false for invalid Aadhaar format', () {
        expect(AadhaarValidator.validate(''), false);
        expect(AadhaarValidator.validate('23412341234'), false); // Too short
        expect(AadhaarValidator.validate('2341234123456'), false); // Too long
        expect(AadhaarValidator.validate('23412341234A'),
            false); // Contains letter
        expect(AadhaarValidator.validate('abcd1234efgh'),
            false); // Contains letters
      });

      test('should return false for Aadhaar starting with 0 or 1', () {
        expect(AadhaarValidator.validate('023412341234'), false);
        expect(AadhaarValidator.validate('123412341234'), false);
      });

      test('should return false for invalid Verhoeff checksum', () {
        expect(AadhaarValidator.validate('234123412345'),
            false); // Invalid checksum
        expect(AadhaarValidator.validate('378945612356'),
            false); // Invalid checksum
        expect(AadhaarValidator.validate('523456789016'),
            false); // Invalid checksum
      });

      test('should return false for all same digits', () {
        // All same digits are invalid due to checksum
        expect(AadhaarValidator.validate('222222222222'), false);
        expect(AadhaarValidator.validate('333333333333'), false);
        expect(AadhaarValidator.validate('999999999999'), false);
      });
    });

    group('validateDetailed', () {
      test('should return detailed result for valid Aadhaar', () {
        final result = AadhaarValidator.validateDetailed('234123412346');
        expect(result.isValid, true);
        expect(result.error, null);
        expect(result.maskedAadhaar, 'XXXX XXXX 2346');
      });

      test('should return detailed result for valid Aadhaar with formatting',
          () {
        final result = AadhaarValidator.validateDetailed('2341-2341-2346');
        expect(result.isValid, true);
        expect(result.error, null);
        expect(result.maskedAadhaar, 'XXXX XXXX 2346');
      });

      test('should return detailed error for empty Aadhaar', () {
        final result = AadhaarValidator.validateDetailed('');
        expect(result.isValid, false);
        expect(result.error, 'Aadhaar cannot be empty');
        expect(result.maskedAadhaar, null);
      });

      test('should return detailed error for wrong length', () {
        final result = AadhaarValidator.validateDetailed('23412341234');
        expect(result.isValid, false);
        expect(result.error, 'Aadhaar must be 12 digits long');
      });

      test('should return detailed error for non-digits', () {
        final result = AadhaarValidator.validateDetailed('23412341234A');
        expect(result.isValid, false);
        expect(result.error, 'Aadhaar must contain only digits');
      });

      test('should return detailed error for starting with 0 or 1', () {
        final result1 = AadhaarValidator.validateDetailed('023412341234');
        expect(result1.isValid, false);
        expect(result1.error, 'Aadhaar cannot start with 0 or 1');

        final result2 = AadhaarValidator.validateDetailed('123412341234');
        expect(result2.isValid, false);
        expect(result2.error, 'Aadhaar cannot start with 0 or 1');
      });

      test('should return detailed error for invalid checksum', () {
        final result = AadhaarValidator.validateDetailed('234123412345');
        expect(result.isValid, false);
        expect(result.error, 'Aadhaar checksum validation failed');
      });
    });

    group('normalize', () {
      test('should normalize Aadhaar correctly', () {
        expect(AadhaarValidator.normalize('234123412346'), '234123412346');
        expect(AadhaarValidator.normalize('2341-2341-2346'), '234123412346');
        expect(AadhaarValidator.normalize('2341 2341 2346'), '234123412346');
        expect(AadhaarValidator.normalize(' 234123412346 '), '234123412346');
      });
    });

    group('mask', () {
      test('should mask valid Aadhaar correctly', () {
        final a = '23412341234' + VerhoeffChecksum.generate('23412341234');
        expect(AadhaarValidator.mask(a), 'XXXX XXXX ${a.substring(8)}');
      });

      test('should throw for invalid Aadhaar', () {
        expect(() => AadhaarValidator.mask('INVALID'), throwsArgumentError);
        expect(
            () => AadhaarValidator.mask('234123412345'), throwsArgumentError);
      });
    });

    group('format', () {
      test('should format valid Aadhaar correctly', () {
        final a = '23412341234' + VerhoeffChecksum.generate('23412341234');
        expect(AadhaarValidator.format(a),
            '${a.substring(0, 4)} ${a.substring(4, 8)} ${a.substring(8)}');
      });

      test('should throw for invalid Aadhaar', () {
        expect(() => AadhaarValidator.format('INVALID'), throwsArgumentError);
        expect(
            () => AadhaarValidator.format('234123412345'), throwsArgumentError);
      });
    });
  });

  group('VerhoeffChecksum', () {
    test('should validate generated test cases', () {
      final a1 = '23412341234' + VerhoeffChecksum.generate('23412341234');
      final a2 = '37894561235' + VerhoeffChecksum.generate('37894561235');
      final a3 = '52345678901' + VerhoeffChecksum.generate('52345678901');
      expect(VerhoeffChecksum.validate(a1), true);
      expect(VerhoeffChecksum.validate(a2), true);
      expect(VerhoeffChecksum.validate(a3), true);
      expect(VerhoeffChecksum.validate('234123412345'), false);
    });

    test('should return false for empty string', () {
      expect(VerhoeffChecksum.validate(''), false);
    });
  });
}
