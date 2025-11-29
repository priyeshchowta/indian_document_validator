import 'package:flutter/material.dart';
import 'package:indian_document_validators/indian_document_validators.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indian Document Validators Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Indian Document Validators'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _panController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _gstinController = TextEditingController();
  final _ifscController = TextEditingController();
  final _upiController = TextEditingController();

  String _panResult = '';
  String _aadhaarResult = '';
  String _gstinResult = '';
  String _ifscResult = '';
  String _upiResult = '';

  void _validatePan() {
    final result = PanValidator.validateDetailed(_panController.text);
    setState(() {
      if (result.isValid) {
        _panResult = '✓ Valid PAN\nNormalized: ${result.normalizedPan}\nMasked: ${PanValidator.mask(result.normalizedPan!)}';
      } else {
        _panResult = '✗ Invalid: ${result.error}';
      }
    });
  }

  void _validateAadhaar() {
    final result = AadhaarValidator.validateDetailed(_aadhaarController.text);
    setState(() {
      if (result.isValid) {
        final normalized = AadhaarValidator.normalize(_aadhaarController.text);
        _aadhaarResult = '✓ Valid Aadhaar\nFormatted: ${AadhaarValidator.format(normalized)}\nMasked: ${result.maskedAadhaar}';
      } else {
        _aadhaarResult = '✗ Invalid: ${result.error}';
      }
    });
  }

  void _validateGstin() {
    final result = GstinValidator.validateDetailed(_gstinController.text);
    setState(() {
      if (result.isValid) {
        final stateName = GstinValidator.getStateName(result.stateCode!) ?? 'Unknown State';
        _gstinResult = '✓ Valid GSTIN\nState: ${result.stateCode} ($stateName)\nPAN: ${result.panNumber}';
      } else {
        _gstinResult = '✗ Invalid: ${result.error}';
      }
    });
  }

  void _validateIfsc() {
    final result = IfscValidator.validateDetailed(_ifscController.text);
    setState(() {
      if (result.isValid) {
        final bankName = IfscValidator.getBankName(result.bankCode!) ?? 'Unknown Bank';
        _ifscResult = '✓ Valid IFSC\nBank: ${result.bankCode} ($bankName)\nBranch Code: ${result.branchCode}';
      } else {
        _ifscResult = '✗ Invalid: ${result.error}';
      }
    });
  }

  void _validateUpi() {
    final result = UpiVpaValidator.validateDetailed(_upiController.text);
    setState(() {
      if (result.isValid) {
        final providerName = UpiVpaValidator.getProviderName(result.provider!) ?? 'Unknown Provider';
        _upiResult = '✓ Valid UPI VPA\nUsername: ${result.username}\nProvider: ${result.provider} ($providerName)';
      } else {
        _upiResult = '✗ Invalid: ${result.error}';
      }
    });
  }

  Widget _buildValidatorSection({
    required String title,
    required String hint,
    required TextEditingController controller,
    required VoidCallback onValidate,
    required String result,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => onValidate(),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: result.startsWith('✓') 
                    ? Colors.green.withOpacity(0.1)
                    : result.startsWith('✗')
                    ? Colors.red.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: result.startsWith('✓')
                      ? Colors.green
                      : result.startsWith('✗')
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              child: Text(
                result.isEmpty ? 'Enter value to validate' : result,
                style: TextStyle(
                  color: result.startsWith('✓')
                      ? Colors.green.shade700
                      : result.startsWith('✗')
                      ? Colors.red.shade700
                      : Colors.grey.shade700,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Indian Document Validators',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This example demonstrates offline validation of Indian identification codes and financial codes. All validations are performed locally without network requests.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildValidatorSection(
              title: 'PAN Validator',
              hint: 'Enter PAN (e.g., ABCDE1234F)',
              controller: _panController,
              onValidate: _validatePan,
              result: _panResult,
            ),
            _buildValidatorSection(
              title: 'Aadhaar Validator',
              hint: 'Enter Aadhaar (e.g., 234123412346)',
              controller: _aadhaarController,
              onValidate: _validateAadhaar,
              result: _aadhaarResult,
            ),
            _buildValidatorSection(
              title: 'GSTIN Validator',
              hint: 'Enter GSTIN (e.g., 29ABCDE1234F1Z5)',
              controller: _gstinController,
              onValidate: _validateGstin,
              result: _gstinResult,
            ),
            _buildValidatorSection(
              title: 'IFSC Validator',
              hint: 'Enter IFSC (e.g., SBIN0001234)',
              controller: _ifscController,
              onValidate: _validateIfsc,
              result: _ifscResult,
            ),
            _buildValidatorSection(
              title: 'UPI VPA Validator',
              hint: 'Enter UPI VPA (e.g., user@paytm)',
              controller: _upiController,
              onValidate: _validateUpi,
              result: _upiResult,
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sample Valid Values:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• PAN: ALWPG5809L, BNZAA2318J\n'
                      '• Aadhaar: 234123412346, 378945612357\n'
                      '• GSTIN: 29ABCDE1234F1Z5, 09ALWPG5809L1ZK\n'
                      '• IFSC: SBIN0001234, HDFC0000001\n'
                      '• UPI: user@paytm, john.doe@phonepe',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _panController.dispose();
    _aadhaarController.dispose();
    _gstinController.dispose();
    _ifscController.dispose();
    _upiController.dispose();
    super.dispose();
  }
}