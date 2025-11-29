import 'package:test/test.dart';
import 'package:indian_document_validators/indian_document_validators.dart';

void main() {
  group('GstinValidator', () {
    group('validate', () {
      test('should return true for valid GSTIN numbers', () {
        // Build valid GSTINs using calculated checksum
        final g1 = '29ABCDE1234F1Z' + GstChecksum.calculate('29ABCDE1234F1Z');
        final g2 = '09ALWPG5809L1Z' + GstChecksum.calculate('09ALWPG5809L1Z');
        final g3 = '27BNZAA2318J1Z' + GstChecksum.calculate('27BNZAA2318J1Z');
        expect(GstinValidator.validate(g1), true);
        expect(GstinValidator.validate(g2), true);
        expect(GstinValidator.validate(g3), true);
      });

      test('should return true for valid GSTIN with spaces and hyphens', () {
        final g = '29ABCDE1234F1Z' + GstChecksum.calculate('29ABCDE1234F1Z');
        expect(GstinValidator.validate('29ABCDE-1234F-1Z${g[14]}'), true);
        expect(GstinValidator.validate('29ABCDE 1234F 1Z${g[14]}'), true);
        expect(GstinValidator.validate(' $g '), true);
      });

      test('should return true for lowercase GSTIN (auto-normalized)', () {
        final g = '29ABCDE1234F1Z' + GstChecksum.calculate('29ABCDE1234F1Z');
        expect(GstinValidator.validate(g.toLowerCase()), true);
      });

      test('should return false for invalid GSTIN format', () {
        expect(GstinValidator.validate(''), false);
        expect(GstinValidator.validate('29ABCDE1234F1Z'), false); // Too short
        expect(GstinValidator.validate('29ABCDE1234F1Z56'), false); // Too long
      });

      test('should return false for invalid state code', () {
        expect(GstinValidator.validate('99ABCDE1234F1Z5'), false);
        expect(GstinValidator.validate('00ABCDE1234F1Z5'), false);
        expect(GstinValidator.validate('ABABCDE1234F1Z5'), false);
      });

      test('should return false for invalid PAN in GSTIN', () {
        expect(GstinValidator.validate('2912CDE1234F1Z5'), false); // Invalid PAN
        expect(GstinValidator.validate('29ABCDE123F41Z5'), false); // Invalid PAN
      });

      test('should return false for invalid entity code', () {
        expect(GstinValidator.validate('29ABCDE1234F0Z5'), false); // 0 not allowed
        expect(GstinValidator.validate('29ABCDE1234F#Z5'), false); // Special char not allowed
      });

      test('should return false for missing Z character', () {
        expect(GstinValidator.validate('29ABCDE1234F1A5'), false);
        expect(GstinValidator.validate('29ABCDE1234F115'), false);
      });

      test('should return false for invalid checksum', () {
        expect(GstinValidator.validate('29ABCDE1234F1Z6'), false); // Wrong checksum
        expect(GstinValidator.validate('29ABCDE1234F1Z4'), false); // Wrong checksum
      });
    });

    group('validateDetailed', () {
      test('should return detailed result for valid GSTIN', () {
        final g = '29ABCDE1234F1Z' + GstChecksum.calculate('29ABCDE1234F1Z');
        final result = GstinValidator.validateDetailed(g);
        expect(result.isValid, true);
        expect(result.error, null);
        expect(result.stateCode, '29');
        expect(result.panNumber, 'ABCDE1234F');
      });

      test('should return detailed result for valid GSTIN with formatting', () {
        final g = '29ABCDE1234F1Z' + GstChecksum.calculate('29ABCDE1234F1Z');
        final result = GstinValidator.validateDetailed('29abcde-1234f-1z${g[14]}');
        expect(result.isValid, true);
        expect(result.error, null);
        expect(result.stateCode, '29');
        expect(result.panNumber, 'ABCDE1234F');
      });

      test('should return detailed error for empty GSTIN', () {
        final result = GstinValidator.validateDetailed('');
        expect(result.isValid, false);
        expect(result.error, 'GSTIN cannot be empty');
      });

      test('should return detailed error for wrong length', () {
        final result = GstinValidator.validateDetailed('29ABCDE1234F1Z');
        expect(result.isValid, false);
        expect(result.error, 'GSTIN must be 15 characters long');
      });

      test('should return detailed error for invalid state code', () {
        final result = GstinValidator.validateDetailed('99ABCDE1234F1Z5');
        expect(result.isValid, false);
        expect(result.error, 'Invalid state code in GSTIN');
      });

      test('should return detailed error for invalid PAN', () {
        final result = GstinValidator.validateDetailed('2912CDE1234F1Z5');
        expect(result.isValid, false);
        expect(result.error, 'Invalid PAN in GSTIN');
      });

      test('should return detailed error for invalid entity code', () {
        final result = GstinValidator.validateDetailed('29ABCDE1234F0Z5');
        expect(result.isValid, false);
        expect(result.error, 'Invalid entity code in GSTIN');
      });

      test('should return detailed error for missing Z', () {
        final result = GstinValidator.validateDetailed('29ABCDE1234F1A5');
        expect(result.isValid, false);
        expect(result.error, 'GSTIN must have Z as 14th character');
      });

      test('should return detailed error for invalid checksum', () {
        final result = GstinValidator.validateDetailed('29ABCDE1234F1Z6');
        expect(result.isValid, false);
        expect(result.error, 'GSTIN checksum validation failed');
      });
    });

    group('normalize', () {
      test('should normalize GSTIN correctly', () {
        expect(GstinValidator.normalize('29abcde1234f1z5'), '29ABCDE1234F1Z5');
        expect(GstinValidator.normalize('29ABCDE-1234F-1Z5'), '29ABCDE1234F1Z5');
        expect(GstinValidator.normalize('29ABCDE 1234F 1Z5'), '29ABCDE1234F1Z5');
        expect(GstinValidator.normalize(' 29abcde-1234f-1z5 '), '29ABCDE1234F1Z5');
      });
    });

    group('extractPan', () {
      test('should extract PAN from valid GSTIN', () {
        final g1 = '29ABCDE1234F1Z' + GstChecksum.calculate('29ABCDE1234F1Z');
        final g2 = '09ALWPG5809L1Z' + GstChecksum.calculate('09ALWPG5809L1Z');
        expect(GstinValidator.extractPan(g1), 'ABCDE1234F');
        expect(GstinValidator.extractPan(g2), 'ALWPG5809L');
      });

      test('should throw for invalid GSTIN', () {
        expect(() => GstinValidator.extractPan('INVALID'), throwsArgumentError);
        expect(() => GstinValidator.extractPan('29ABCDE1234F1Z6'), throwsArgumentError);
      });
    });

    group('extractStateCode', () {
      test('should extract state code from valid GSTIN', () {
        final g1 = '29ABCDE1234F1Z' + GstChecksum.calculate('29ABCDE1234F1Z');
        final g2 = '09ALWPG5809L1Z' + GstChecksum.calculate('09ALWPG5809L1Z');
        expect(GstinValidator.extractStateCode(g1), '29');
        expect(GstinValidator.extractStateCode(g2), '09');
      });

      test('should throw for invalid GSTIN', () {
        expect(() => GstinValidator.extractStateCode('INVALID'), throwsArgumentError);
        expect(() => GstinValidator.extractStateCode('29ABCDE1234F1Z6'), throwsArgumentError);
      });
    });

    group('getStateName', () {
      test('should return correct state names', () {
        expect(GstinValidator.getStateName('29'), 'Karnataka');
        expect(GstinValidator.getStateName('09'), 'Uttar Pradesh');
        expect(GstinValidator.getStateName('27'), 'Maharashtra');
        expect(GstinValidator.getStateName('07'), 'Delhi');
        expect(GstinValidator.getStateName('22'), 'Chhattisgarh');
      });

      test('should return null for invalid state codes', () {
        expect(GstinValidator.getStateName('99'), null);
        expect(GstinValidator.getStateName('00'), null);
        expect(GstinValidator.getStateName('AB'), null);
      });
    });
  });

  group('GstChecksum', () {
    test('should calculate checksum and validate GSTIN', () {
      final c1 = GstChecksum.calculate('29ABCDE1234F1Z');
      final c2 = GstChecksum.calculate('09ALWPG5809L1Z');
      final c3 = GstChecksum.calculate('27BNZAA2318J1Z');
      expect(GstChecksum.validate('29ABCDE1234F1Z$c1'), true);
      expect(GstChecksum.validate('09ALWPG5809L1Z$c2'), true);
      expect(GstChecksum.validate('27BNZAA2318J1Z$c3'), true);
    });

    test('should validate correct checksum', () {
      final c1 = GstChecksum.calculate('29ABCDE1234F1Z');
      final c2 = GstChecksum.calculate('09ALWPG5809L1Z');
      final c3 = GstChecksum.calculate('27BNZAA2318J1Z');
      expect(c1.length, 1);
      expect(c2.length, 1);
      expect(c3.length, 1);
    });

    test('should throw for invalid input length', () {
      expect(() => GstChecksum.calculate('29ABCDE1234F1'), throwsArgumentError);
      expect(() => GstChecksum.calculate('29ABCDE1234F1ZZ'), throwsArgumentError);
    });

    test('should throw for invalid characters', () {
      expect(() => GstChecksum.calculate('29ABCDE1234F1@'), throwsArgumentError);
      expect(() => GstChecksum.calculate('29ABCDE1234F1#'), throwsArgumentError);
    });

    test('should return false for wrong length in validate', () {
      expect(GstChecksum.validate('29ABCDE1234F1'), false);
      expect(GstChecksum.validate('29ABCDE1234F1ZZ5'), false);
    });
  });
}