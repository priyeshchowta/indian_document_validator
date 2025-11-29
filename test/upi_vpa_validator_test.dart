import 'package:test/test.dart';
import 'package:indian_document_validators/indian_document_validators.dart';

void main() {
  group('UpiVpaValidator', () {
    group('validate', () {
      test('should return true for valid UPI VPAs', () {
        expect(UpiVpaValidator.validate('user@paytm'), true);
        expect(UpiVpaValidator.validate('john.doe@phonepe'), true);
        expect(UpiVpaValidator.validate('test_user@googlepay'), true);
        expect(UpiVpaValidator.validate('user-123@ybl'), true);
        expect(UpiVpaValidator.validate('myname123@axl'), true);
        expect(UpiVpaValidator.validate('user.name_123@hdfcbank'), true);
      });

      test('should return true for valid UPI VPA with spaces (normalized)', () {
        expect(UpiVpaValidator.validate(' user@paytm '), true);
        expect(UpiVpaValidator.validate('user @paytm'), true);
        expect(UpiVpaValidator.validate('user@ paytm'), true);
      });

      test('should return false for invalid UPI VPA format', () {
        expect(UpiVpaValidator.validate(''), false);
        expect(UpiVpaValidator.validate('user'), false); // No @ symbol
        expect(UpiVpaValidator.validate('@paytm'), false); // No username
        expect(UpiVpaValidator.validate('user@'), false); // No provider
        expect(UpiVpaValidator.validate('user@@paytm'), false); // Multiple @
        expect(
            UpiVpaValidator.validate('user@paytm@extra'), false); // Multiple @
      });

      test('should return false for invalid username', () {
        expect(
            UpiVpaValidator.validate('.user@paytm'), false); // Starts with dot
        expect(UpiVpaValidator.validate('user.@paytm'), false); // Ends with dot
        expect(UpiVpaValidator.validate('-user@paytm'),
            false); // Starts with hyphen
        expect(
            UpiVpaValidator.validate('user-@paytm'), false); // Ends with hyphen
        expect(UpiVpaValidator.validate('_user@paytm'),
            false); // Starts with underscore
        expect(UpiVpaValidator.validate('user_@paytm'),
            false); // Ends with underscore
        expect(UpiVpaValidator.validate('user..name@paytm'),
            false); // Consecutive dots
        expect(UpiVpaValidator.validate('user--name@paytm'),
            false); // Consecutive hyphens
        expect(UpiVpaValidator.validate('user__name@paytm'),
            false); // Consecutive underscores
        expect(UpiVpaValidator.validate('user@#paytm'),
            false); // Special chars in username
        expect(UpiVpaValidator.validate('user\$@paytm'),
            false); // Special chars in username
      });

      test('should return false for invalid provider', () {
        expect(UpiVpaValidator.validate('user@paytm123'),
            false); // Numbers in provider
        expect(UpiVpaValidator.validate('user@pay-tm'),
            false); // Hyphen in provider
        expect(
            UpiVpaValidator.validate('user@pay.tm'), false); // Dot in provider
        expect(UpiVpaValidator.validate('user@pay_tm'),
            false); // Underscore in provider
        expect(UpiVpaValidator.validate('user@pay@tm'), false); // @ in provider
        expect(UpiVpaValidator.validate('user@pay#tm'),
            false); // Special chars in provider
      });

      test('should return false for too long username or provider', () {
        final longUsername = 'a' * 51;
        final longProvider = 'b' * 31;
        expect(UpiVpaValidator.validate('${longUsername}@paytm'), false);
        expect(UpiVpaValidator.validate('user@$longProvider'), false);
      });
    });

    group('validateDetailed', () {
      test('should return detailed result for valid UPI VPA', () {
        final result = UpiVpaValidator.validateDetailed('user@paytm');
        expect(result.isValid, true);
        expect(result.error, null);
        expect(result.username, 'user');
        expect(result.provider, 'paytm');
      });

      test('should return detailed result for valid UPI VPA with formatting',
          () {
        final result =
            UpiVpaValidator.validateDetailed(' user.name_123@hdfcbank ');
        expect(result.isValid, true);
        expect(result.error, null);
        expect(result.username, 'user.name_123');
        expect(result.provider, 'hdfcbank');
      });

      test('should return detailed error for empty UPI VPA', () {
        final result = UpiVpaValidator.validateDetailed('');
        expect(result.isValid, false);
        expect(result.error, 'UPI VPA cannot be empty');
      });

      test('should return detailed error for missing @ symbol', () {
        final result = UpiVpaValidator.validateDetailed('userpaytm');
        expect(result.isValid, false);
        expect(result.error, 'UPI VPA must contain @ symbol');
      });

      test('should return detailed error for multiple @ symbols', () {
        final result = UpiVpaValidator.validateDetailed('user@@paytm');
        expect(result.isValid, false);
        expect(result.error, 'UPI VPA must have exactly one @ symbol');
      });

      test('should return detailed error for empty username', () {
        final result = UpiVpaValidator.validateDetailed('@paytm');
        expect(result.isValid, false);
        expect(result.error, 'Username cannot be empty');
      });

      test('should return detailed error for empty provider', () {
        final result = UpiVpaValidator.validateDetailed('user@');
        expect(result.isValid, false);
        expect(result.error, 'Provider cannot be empty');
      });

      test('should return detailed error for long username', () {
        final longUsername = 'a' * 51;
        final result =
            UpiVpaValidator.validateDetailed('${longUsername}@paytm');
        expect(result.isValid, false);
        expect(result.error, 'Username cannot be longer than 50 characters');
      });

      test('should return detailed error for long provider', () {
        final longProvider = 'b' * 31;
        final result = UpiVpaValidator.validateDetailed('user@$longProvider');
        expect(result.isValid, false);
        expect(result.error, 'Provider cannot be longer than 30 characters');
      });

      test('should return detailed error for invalid username characters', () {
        final result = UpiVpaValidator.validateDetailed('user#@paytm');
        expect(result.isValid, false);
        expect(result.error,
            'Username can only contain letters, numbers, dots, hyphens, and underscores');
      });

      test(
          'should return detailed error for username starting with special char',
          () {
        final result = UpiVpaValidator.validateDetailed('.user@paytm');
        expect(result.isValid, false);
        expect(result.error,
            'Username cannot start or end with special characters');
      });

      test('should return detailed error for consecutive special chars', () {
        final result = UpiVpaValidator.validateDetailed('user..name@paytm');
        expect(result.isValid, false);
        expect(result.error,
            'Username cannot have consecutive special characters');
      });

      test('should return detailed error for invalid provider characters', () {
        final result = UpiVpaValidator.validateDetailed('user@paytm123');
        expect(result.isValid, false);
        expect(result.error, 'Provider can only contain letters');
      });
    });

    group('normalize', () {
      test('should normalize UPI VPA correctly', () {
        expect(UpiVpaValidator.normalize('user@paytm'), 'user@paytm');
        expect(UpiVpaValidator.normalize(' user@paytm '), 'user@paytm');
        expect(UpiVpaValidator.normalize('user @paytm'), 'user@paytm');
        expect(UpiVpaValidator.normalize('user@ paytm'), 'user@paytm');
      });
    });

    group('extractUsername', () {
      test('should extract username from valid UPI VPA', () {
        expect(UpiVpaValidator.extractUsername('user@paytm'), 'user');
        expect(UpiVpaValidator.extractUsername('john.doe@phonepe'), 'john.doe');
        expect(UpiVpaValidator.extractUsername('test_user@googlepay'),
            'test_user');
      });

      test('should throw for invalid UPI VPA', () {
        expect(() => UpiVpaValidator.extractUsername('invalid'),
            throwsArgumentError);
        expect(() => UpiVpaValidator.extractUsername('user@@paytm'),
            throwsArgumentError);
      });
    });

    group('extractProvider', () {
      test('should extract provider from valid UPI VPA', () {
        expect(UpiVpaValidator.extractProvider('user@paytm'), 'paytm');
        expect(UpiVpaValidator.extractProvider('john.doe@phonepe'), 'phonepe');
        expect(UpiVpaValidator.extractProvider('test_user@googlepay'),
            'googlepay');
      });

      test('should throw for invalid UPI VPA', () {
        expect(() => UpiVpaValidator.extractProvider('invalid'),
            throwsArgumentError);
        expect(() => UpiVpaValidator.extractProvider('user@@paytm'),
            throwsArgumentError);
      });
    });

    group('getProviderName', () {
      test('should return correct provider names', () {
        expect(UpiVpaValidator.getProviderName('paytm'), 'Paytm');
        expect(UpiVpaValidator.getProviderName('phonepe'), 'PhonePe');
        expect(UpiVpaValidator.getProviderName('googlepay'), 'Google Pay');
        expect(UpiVpaValidator.getProviderName('gpay'), 'Google Pay');
        expect(UpiVpaValidator.getProviderName('ybl'), 'Yes Bank');
        expect(UpiVpaValidator.getProviderName('axl'), 'Axis Bank');
        expect(UpiVpaValidator.getProviderName('hdfcbank'), 'HDFC Bank');
        expect(UpiVpaValidator.getProviderName('sbi'), 'State Bank of India');
        expect(UpiVpaValidator.getProviderName('icici'), 'ICICI Bank');
      });

      test('should handle case insensitive provider codes', () {
        expect(UpiVpaValidator.getProviderName('PAYTM'), 'Paytm');
        expect(UpiVpaValidator.getProviderName('PhonePe'), 'PhonePe');
        expect(UpiVpaValidator.getProviderName('GooglePay'), 'Google Pay');
      });

      test('should return null for unknown provider codes', () {
        expect(UpiVpaValidator.getProviderName('unknown'), null);
        expect(UpiVpaValidator.getProviderName('test'), null);
        expect(UpiVpaValidator.getProviderName('xyz'), null);
      });
    });
  });
}
