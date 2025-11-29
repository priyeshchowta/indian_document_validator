import 'package:test/test.dart';
import 'package:indian_document_validators/indian_document_validators.dart';

void main() {
  group('IfscValidator', () {
    group('validate', () {
      test('should return true for valid IFSC codes', () {
        expect(IfscValidator.validate('SBIN0001234'), true);
        expect(IfscValidator.validate('HDFC0000001'), true);
        expect(IfscValidator.validate('ICIC0001234'), true);
        expect(IfscValidator.validate('AXIS0000123'), true);
        expect(IfscValidator.validate('PUNB0123456'), true);
      });

      test('should return true for valid IFSC with spaces and hyphens', () {
        expect(IfscValidator.validate('SBIN-0001234'), true);
        expect(IfscValidator.validate('SBIN 0001234'), true);
        expect(IfscValidator.validate(' SBIN0001234 '), true);
      });

      test('should return true for lowercase IFSC (auto-normalized)', () {
        expect(IfscValidator.validate('sbin0001234'), true);
        expect(IfscValidator.validate('HdFc0000001'), true);
      });

      test('should return false for invalid IFSC format', () {
        expect(IfscValidator.validate(''), false);
        expect(IfscValidator.validate('SBIN000123'), false); // Too short
        expect(IfscValidator.validate('SBIN00012345'), false); // Too long
        expect(IfscValidator.validate('SB1N0001234'), false); // Number in bank code
        expect(IfscValidator.validate('SBIN1001234'), false); // Should be 0 as 5th char
        expect(IfscValidator.validate('12IN0001234'), false); // Numbers in bank code
      });

      test('should return false for invalid bank code', () {
        expect(IfscValidator.validate('SB120001234'), false);
        expect(IfscValidator.validate('S@IN0001234'), false);
        expect(IfscValidator.validate('SBIN0001234'), true); // Valid for comparison
      });

      test('should return false for wrong 5th character', () {
        expect(IfscValidator.validate('SBIN1001234'), false); // Should be 0
        expect(IfscValidator.validate('SBINA001234'), false); // Should be 0
        expect(IfscValidator.validate('SBIN#001234'), false); // Should be 0
      });

      test('should return false for invalid branch code', () {
        expect(IfscValidator.validate('SBIN000123@'), false);
        expect(IfscValidator.validate('SBIN000123#'), false);
        expect(IfscValidator.validate('SBIN000123-'), false);
      });
    });

    group('validateDetailed', () {
      test('should return detailed result for valid IFSC', () {
        final result = IfscValidator.validateDetailed('SBIN0001234');
        expect(result.isValid, true);
        expect(result.error, null);
        expect(result.bankCode, 'SBIN');
        expect(result.branchCode, '001234');
      });

      test('should return detailed result for valid IFSC with formatting', () {
        final result = IfscValidator.validateDetailed('sbin-0001234');
        expect(result.isValid, true);
        expect(result.error, null);
        expect(result.bankCode, 'SBIN');
        expect(result.branchCode, '001234');
      });

      test('should return detailed error for empty IFSC', () {
        final result = IfscValidator.validateDetailed('');
        expect(result.isValid, false);
        expect(result.error, 'IFSC cannot be empty');
      });

      test('should return detailed error for wrong length', () {
        final result = IfscValidator.validateDetailed('SBIN000123');
        expect(result.isValid, false);
        expect(result.error, 'IFSC must be 11 characters long');
      });

      test('should return detailed error for invalid bank code', () {
        final result = IfscValidator.validateDetailed('SB1N0001234');
        expect(result.isValid, false);
        expect(result.error, 'Bank code must be 4 letters');
      });

      test('should return detailed error for wrong 5th character', () {
        final result = IfscValidator.validateDetailed('SBIN1001234');
        expect(result.isValid, false);
        expect(result.error, '5th character of IFSC must be 0');
      });

      test('should return detailed error for invalid branch code', () {
        final result = IfscValidator.validateDetailed('SBIN000123@');
        expect(result.isValid, false);
        expect(result.error, 'Branch code must be 6 alphanumeric characters');
      });
    });

    group('normalize', () {
      test('should normalize IFSC correctly', () {
        expect(IfscValidator.normalize('sbin0001234'), 'SBIN0001234');
        expect(IfscValidator.normalize('SBIN-0001234'), 'SBIN0001234');
        expect(IfscValidator.normalize('SBIN 0001234'), 'SBIN0001234');
        expect(IfscValidator.normalize(' sbin-0001234 '), 'SBIN0001234');
      });
    });

    group('extractBankCode', () {
      test('should extract bank code from valid IFSC', () {
        expect(IfscValidator.extractBankCode('SBIN0001234'), 'SBIN');
        expect(IfscValidator.extractBankCode('HDFC0000001'), 'HDFC');
        expect(IfscValidator.extractBankCode('ICIC0001234'), 'ICIC');
      });

      test('should throw for invalid IFSC', () {
        expect(() => IfscValidator.extractBankCode('INVALID'), throwsArgumentError);
        expect(() => IfscValidator.extractBankCode('SBIN1001234'), throwsArgumentError);
      });
    });

    group('extractBranchCode', () {
      test('should extract branch code from valid IFSC', () {
        expect(IfscValidator.extractBranchCode('SBIN0001234'), '001234');
        expect(IfscValidator.extractBranchCode('HDFC0000001'), '000001');
        expect(IfscValidator.extractBranchCode('ICIC0001234'), '001234');
      });

      test('should throw for invalid IFSC', () {
        expect(() => IfscValidator.extractBranchCode('INVALID'), throwsArgumentError);
        expect(() => IfscValidator.extractBranchCode('SBIN1001234'), throwsArgumentError);
      });
    });

    group('getBankName', () {
      test('should return correct bank names', () {
        expect(IfscValidator.getBankName('SBIN'), 'State Bank of India');
        expect(IfscValidator.getBankName('HDFC'), 'HDFC Bank');
        expect(IfscValidator.getBankName('ICIC'), 'ICICI Bank');
        expect(IfscValidator.getBankName('AXIS'), 'Axis Bank');
        expect(IfscValidator.getBankName('PUNB'), 'Punjab National Bank');
        expect(IfscValidator.getBankName('BARB'), 'Bank of Baroda');
        expect(IfscValidator.getBankName('YESB'), 'Yes Bank');
      });

      test('should handle case insensitive bank codes', () {
        expect(IfscValidator.getBankName('sbin'), 'State Bank of India');
        expect(IfscValidator.getBankName('hdfc'), 'HDFC Bank');
        expect(IfscValidator.getBankName('HdFc'), 'HDFC Bank');
      });

      test('should return null for unknown bank codes', () {
        expect(IfscValidator.getBankName('UNKN'), null);
        expect(IfscValidator.getBankName('TEST'), null);
        expect(IfscValidator.getBankName('ABCD'), null);
      });
    });
  });
}