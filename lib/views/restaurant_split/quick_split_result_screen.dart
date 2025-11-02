import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/person_payment_tile.dart';
import '../../view_models/restaurant/quick_split_view_model.dart';

/// Quick Split Result Screen
/// Displays calculation results with payment tracking and share options
class QuickSplitResultScreen extends StatefulWidget {
  final QuickSplitViewModel viewModel;

  const QuickSplitResultScreen({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<QuickSplitResultScreen> createState() => _QuickSplitResultScreenState();
}

class _QuickSplitResultScreenState extends State<QuickSplitResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _animationController.forward();

    widget.viewModel.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveToHistory() async {
    setState(() => _isSaving = true);
    try {
      await widget.viewModel.saveToHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Split saved successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving split: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _shareResults() {
    final result = widget.viewModel.result;
    if (result == null) return;

    final restaurantName = widget.viewModel.restaurantNameController.text.isEmpty
        ? 'Restaurant'
        : widget.viewModel.restaurantNameController.text;

    final taxLine = result.hasTax 
        ? '📊 Tax: ${widget.viewModel.currency}${result.taxAmount.toStringAsFixed(2)} (${(result.effectiveTaxPercentage ?? 0).toStringAsFixed(1)}%)\n' 
        : '';
    
    final tipLine = result.hasTip 
        ? '� Tip: ${widget.viewModel.currency}${result.tipAmount.toStringAsFixed(2)} (${(result.effectiveTipPercentage ?? 0).toStringAsFixed(1)}%)\n' 
        : '';

    final shareText = '''
🍽️ $restaurantName - Bill Split

� Bill Amount: ${widget.viewModel.currency}${result.billAmount.toStringAsFixed(2)}
$taxLine$tipLine━━━━━━━━━━━━━━━━━━
💳 Grand Total: ${widget.viewModel.currency}${result.grandTotal.toStringAsFixed(2)}

👥 Split ${result.numberOfPeople} ways:
💸 Each person pays: ${widget.viewModel.currency}${result.perPersonAmount.toStringAsFixed(2)}

Shared from SmartSplit 🚀
''';

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.copy, color: Colors.white),
            SizedBox(width: 12),
            Text('Split details copied to clipboard!'),
          ],
        ),
        backgroundColor: Color(0xFF00B4D8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _splitAnother() {
    widget.viewModel.reset();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushNamed(context, '/quick-split-input');
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.viewModel.result;
    
    if (result == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: const Color(0xFF00B4D8),
        ),
        body: const Center(
          child: Text('No calculation result available'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Split Complete',
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
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Share',
            onPressed: _shareResults,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Success animation
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      'Bill Successfully Split!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Bill breakdown card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _BreakdownRow(
                            label: 'Bill Amount',
                            amount: result.billAmount,
                            currency: widget.viewModel.currency,
                          ),
                          if (result.hasTax) ...[
                            const SizedBox(height: 12),
                            _BreakdownRow(
                              label: 'Tax (${(result.effectiveTaxPercentage ?? 0).toStringAsFixed(1)}%)',
                              amount: result.taxAmount,
                              currency: widget.viewModel.currency,
                              isAddition: true,
                            ),
                          ],
                          if (result.hasTip) ...[
                            const SizedBox(height: 12),
                            _BreakdownRow(
                              label: 'Tip (${(result.effectiveTipPercentage ?? 0).toStringAsFixed(1)}%)',
                              amount: result.tipAmount,
                              currency: widget.viewModel.currency,
                              isAddition: true,
                            ),
                          ],
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(height: 1),
                          ),
                          _BreakdownRow(
                            label: 'Grand Total',
                            amount: result.grandTotal,
                            currency: widget.viewModel.currency,
                            isBold: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Per person amount (highlighted)
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00B4D8), Color(0xFF0096C7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00B4D8).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Each Person Pays',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${widget.viewModel.currency}${result.perPersonAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Split ${result.numberOfPeople} ways',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Payment tracking section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Payment Tracking',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        Text(
                          '${widget.viewModel.paidCount}/${result.numberOfPeople} paid',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: widget.viewModel.paidCount == result.numberOfPeople
                                ? Colors.green
                                : const Color(0xFF00B4D8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Mark all buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: widget.viewModel.markAllAsPaid,
                            icon: const Icon(Icons.check_circle_outline, size: 18),
                            label: const Text('Mark All Paid'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: const BorderSide(color: Colors.green),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: widget.viewModel.markAllAsUnpaid,
                            icon: const Icon(Icons.cancel_outlined, size: 18),
                            label: const Text('Mark All Unpaid'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Person list
                    ...List.generate(
                      result.numberOfPeople,
                      (index) => PersonPaymentTile(
                        personNumber: index + 1,
                        amount: result.perPersonAmount,
                        currency: widget.viewModel.currency,
                        isPaid: widget.viewModel.paidStatus[index],
                        onPaidChanged: (value) {
                          widget.viewModel.togglePaidStatus(index);
                        },
                        color: const Color(0xFF00B4D8),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Action buttons
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
              child: Column(
                children: [
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _saveToHistory,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save_rounded),
                      label: Text(_isSaving ? 'Saving...' : 'Save to History'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B4D8),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Split another button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: _splitAnother,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Split Another Bill'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF00B4D8),
                        side: const BorderSide(
                          color: Color(0xFF00B4D8),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Breakdown row widget
class _BreakdownRow extends StatelessWidget {
  final String label;
  final double amount;
  final String currency;
  final bool isBold;
  final bool isAddition;

  const _BreakdownRow({
    Key? key,
    required this.label,
    required this.amount,
    required this.currency,
    this.isBold = false,
    this.isAddition = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (isAddition) ...[
              const Icon(Icons.add, size: 16, color: Color(0xFF9E9E9E)),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: isBold ? 18 : 15,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: const Color(0xFF2D3142),
              ),
            ),
          ],
        ),
        Text(
          '$currency${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isBold ? 20 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold
                ? const Color(0xFF00B4D8)
                : const Color(0xFF2D3142),
          ),
        ),
      ],
    );
  }
}
