import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/number_stepper.dart';
import 'widgets/tax_tip_toggle.dart';
import 'widgets/quick_tip_selector.dart';
import 'widgets/preview_card.dart';
import '../../view_models/restaurant/quick_split_view_model.dart';
import '../../services/database/user_service.dart';
import '../../models/restaurant/quick_split_model.dart';

/// Quick Split Input Screen
/// Form for entering bill details with real-time preview
class QuickSplitInputScreen extends StatefulWidget {
  final QuickSplitModel? existingSplit; // For loading from history

  const QuickSplitInputScreen({
    Key? key,
    this.existingSplit,
  }) : super(key: key);

  @override
  State<QuickSplitInputScreen> createState() => _QuickSplitInputScreenState();
}

class _QuickSplitInputScreenState extends State<QuickSplitInputScreen> {
  late QuickSplitViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    final userService = UserService();
    final user = await userService.getCurrentUser();
    final currency = user?.preferredCurrency ?? '₹';

    _viewModel = QuickSplitViewModel();
    _viewModel.init(currency);

    // Load existing split if provided
    if (widget.existingSplit != null) {
      _viewModel.loadFromHistory(widget.existingSplit!);
    }

    _viewModel.addListener(() {
      setState(() {}); // Rebuild on ViewModel changes
    });

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _calculateAndNavigate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _viewModel.validateAndCalculate();

    // Show warnings if needed
    if (_viewModel.showTaxWarning) {
      _showWarningDialog(
        'High Tax Amount',
        'The tax amount seems unusually high (>30%). Please verify.',
        onContinue: () => _navigateToResult(),
      );
    } else if (_viewModel.showTipWarning) {
      _showWarningDialog(
        'High Tip Amount',
        'The tip amount seems unusually high (>25%). Please verify.',
        onContinue: () => _navigateToResult(),
      );
    } else {
      _navigateToResult();
    }
  }

  void _showWarningDialog(String title, String message, {required VoidCallback onContinue}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_rounded, color: Colors.orange),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Edit'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onContinue();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B4D8),
            ),
            child: const Text('Continue Anyway'),
          ),
        ],
      ),
    );
  }

  void _navigateToResult() {
    Navigator.pushNamed(
      context,
      '/quick-split-result',
      arguments: _viewModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00B4D8)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Quick Split',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2D3142)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset',
            onPressed: () {
              _viewModel.reset();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Form reset successfully'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bill amount input
                      _buildSectionTitle('Bill Amount'),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _viewModel.billAmountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              _viewModel.currency,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00B4D8),
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF00B4D8),
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter bill amount';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'Amount must be greater than 0';
                          }
                          if (amount > 999999) {
                            return 'Amount too large (max: 999,999)';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Number of people
                      NumberStepper(
                        value: _viewModel.numberOfPeople,
                        min: 2,
                        max: 50,
                        label: 'Number of People',
                        onChanged: (value) {
                          if (value > _viewModel.numberOfPeople) {
                            _viewModel.incrementPeople();
                          } else {
                            _viewModel.decrementPeople();
                          }
                        },
                        color: const Color(0xFF00B4D8),
                      ),

                      const SizedBox(height: 24),

                      // Restaurant name (optional)
                      _buildSectionTitle('Restaurant Name (Optional)'),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _viewModel.restaurantNameController,
                        textCapitalization: TextCapitalization.words,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'e.g., Pizza Palace',
                          prefixIcon: const Icon(Icons.restaurant_rounded, color: Color(0xFF00B4D8)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF00B4D8),
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      const SizedBox(height: 24),

                      // Tax section
                      _buildSectionTitle('Tax (Optional)'),
                      const SizedBox(height: 12),
                      TaxTipToggle(
                        isPercentage: _viewModel.isTaxPercentage,
                        onChanged: (bool value) => _viewModel.toggleTaxType(),
                        label: 'Tax Type',
                        color: const Color(0xFF00B4D8),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _viewModel.taxController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: _viewModel.isTaxPercentage ? 'e.g., 5' : 'e.g., 50.00',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              _viewModel.isTaxPercentage ? '%' : _viewModel.currency,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF00B4D8),
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF00B4D8),
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      const SizedBox(height: 24),

                      // Tip section
                      _buildSectionTitle('Tip (Optional)'),
                      const SizedBox(height: 12),
                      TaxTipToggle(
                        isPercentage: _viewModel.isTipPercentage,
                        onChanged: (bool value) => _viewModel.toggleTipType(),
                        label: 'Tip Type',
                        color: const Color(0xFF00B4D8),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _viewModel.tipController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: _viewModel.isTipPercentage ? 'e.g., 10' : 'e.g., 100.00',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              _viewModel.isTipPercentage ? '%' : _viewModel.currency,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF00B4D8),
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF00B4D8),
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      // Quick tip selector (only if percentage mode)
                      if (_viewModel.isTipPercentage) ...[
                        const SizedBox(height: 16),
                        QuickTipSelector(
                          selectedPercentage: double.tryParse(_viewModel.tipController.text),
                          onSelected: _viewModel.setTipPercentage,
                          color: const Color(0xFF00B4D8),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Preview card
                      if (_viewModel.hasPreview && _viewModel.previewResult != null)
                        PreviewCard(
                          isVisible: _viewModel.hasPreview,
                          currency: _viewModel.currency,
                          billAmount: _viewModel.previewResult!.billAmount,
                          taxAmount: _viewModel.previewResult!.taxAmount,
                          tipAmount: _viewModel.previewResult!.tipAmount,
                          grandTotal: _viewModel.previewResult!.grandTotal,
                          perPersonAmount: _viewModel.previewResult!.perPersonAmount,
                          numberOfPeople: _viewModel.previewResult!.numberOfPeople,
                          color: const Color(0xFF00B4D8),
                        ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Calculate button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _calculateAndNavigate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B4D8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Calculate Split',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3142),
      ),
    );
  }
}
