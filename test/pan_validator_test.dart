import 'package:test/test.dart';
import 'package:indian_document_validators/indian_document_validators.dart';

void main() {
  group('PanValidator', () {
    group('validate', () {
      test('should return true for valid PAN numbers', () {
        expect(PanValidator.validate('ABCDE1234F'), true);
        expect(PanValidator.validate('ALWPG5809L'), true);
        expect(PanValidator.validate('BNZAA2318J'), true);
        expect(PanValidator.validate('CQZPK7077K'), true);
      });

      test('should return true for valid PAN with spaces and hyphens', () {
        expect(PanValidator.validate('ABCDE-1234-F'), true);
        expect(PanValidator.validate('ABCDE 1234 F'), true);
        expect(PanValidator.validate(' ABCDE1234F '), true);
      });

      test('should return true for lowercase PAN (auto-normalized)', () {
        expect(PanValidator.validate('abcde1234f'), true);
        expect(PanValidator.validate('AbCdE1234f'), true);
      });

      test('should return false for invalid PAN format', () {
        expect(PanValidator.validate(''), false);
        expect(PanValidator.validate('ABCDE1234'), false); // Too short
        expect(PanValidator.validate('ABCDE1234FG'), false); // Too long
        expect(PanValidator.validate('12CDE1234F'), false); // Number at start
        expect(PanValidator.validate('ABCDE123F4'),
            false); // Letter in number section
        expect(PanValidator.validate('ABCDEZ234F'),
            false); // Letter in number section
        expect(PanValidator.validate('ABCDE12345'), false); // Number at end
      });

      test('should return false for PAN with special characters', () {
        expect(PanValidator.validate('ABCDE@234F'), false);
        expect(PanValidator.validate('ABCDE1234#'), false);
        expect(PanValidator.validate('ABC@E1234F'), false);
      });
    });

    group('validateDetailed', () {
      test('should return detailed result for valid PAN', () {
        final result = PanValidator.validateDetailed('ABCDE1234F');
        expect(result.isValid, true);
        expect(result.error, null);
        expect(result.normalizedPan, 'ABCDE1234F');
      });

      test('should return detailed result for valid PAN with formatting', () {
        final result = PanValidator.validateDetailed('abcde-1234-f');
        expect(result.isValid, true);
        expect(result.error, null);
        expect(result.normalizedPan, 'ABCDE1234F');
      });

      test('should return detailed error for empty PAN', () {
        final result = PanValidator.validateDetailed('');
        expect(result.isValid, false);
        expect(result.error, 'PAN cannot be empty');
        expect(result.normalizedPan, null);
      });

      test('should return detailed error for wrong length', () {
        final result = PanValidator.validateDetailed('ABCDE123');
        expect(result.isValid, false);
        expect(result.error, 'PAN must be 10 characters long');
      });

      test('should return detailed error for invalid format', () {
        final result = PanValidator.validateDetailed('12CDE1234F');
        expect(result.isValid, false);
        expect(result.error,
            'PAN format is invalid. Expected format: 5 letters + 4 digits + 1 letter');
      });
    });

    group('normalize', () {
      test('should normalize PAN correctly', () {
        expect(PanValidator.normalize('abcde1234f'), 'ABCDE1234F');
        expect(PanValidator.normalize('ABCDE-1234-F'), 'ABCDE1234F');
        expect(PanValidator.normalize('ABCDE 1234 F'), 'ABCDE1234F');
        expect(PanValidator.normalize(' abcde-1234-f '), 'ABCDE1234F');
      });
    });

    group('mask', () {
      test('should mask valid PAN correctly', () {
        expect(PanValidator.mask('ABCDE1234F'), 'ABC******F');
        expect(PanValidator.mask('alwpg5809l'), 'ALW******L');
      });

      test('should throw for invalid PAN', () {
        expect(() => PanValidator.mask('INVALID'), throwsArgumentError);
        expect(() => PanValidator.mask('12CDE1234F'), throwsArgumentError);
      });
    });
  });
}
