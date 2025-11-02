import 'package:flutter/material.dart';

/// Preview Card Widget
/// Collapsible card showing bill breakdown with slide-up animation
/// Displays when valid data is entered
class PreviewCard extends StatefulWidget {
  final bool isVisible;
  final String currency;
  final double billAmount;
  final double taxAmount;
  final double tipAmount;
  final double grandTotal;
  final double perPersonAmount;
  final int numberOfPeople;
  final Color? color;

  const PreviewCard({
    Key? key,
    required this.isVisible,
    required this.currency,
    required this.billAmount,
    required this.taxAmount,
    required this.tipAmount,
    required this.grandTotal,
    required this.perPersonAmount,
    required this.numberOfPeople,
    this.color,
  }) : super(key: key);

  @override
  State<PreviewCard> createState() => _PreviewCardState();
}

class _PreviewCardState extends State<PreviewCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void didUpdateWidget(PreviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.forward();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    final accentColor = widget.color ?? const Color(0xFF00B4D8);

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentColor.withOpacity(0.1),
                accentColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: accentColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.preview_rounded,
                    color: accentColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Live Preview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bill breakdown
              _BreakdownRow(
                label: 'Bill Amount',
                amount: widget.billAmount,
                currency: widget.currency,
              ),
              
              if (widget.taxAmount > 0) ...[
                const SizedBox(height: 8),
                _BreakdownRow(
                  label: 'Tax',
                  amount: widget.taxAmount,
                  currency: widget.currency,
                  isAddition: true,
                ),
              ],
              
              if (widget.tipAmount > 0) ...[
                const SizedBox(height: 8),
                _BreakdownRow(
                  label: 'Tip',
                  amount: widget.tipAmount,
                  currency: widget.currency,
                  isAddition: true,
                ),
              ],

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: Color(0xFFE0E0E0)),
              ),

              // Grand total
              _BreakdownRow(
                label: 'Grand Total',
                amount: widget.grandTotal,
                currency: widget.currency,
                isBold: true,
              ),

              const SizedBox(height: 16),

              // Per person amount (highlighted)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Per Person',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.numberOfPeople} people',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${widget.currency}${widget.perPersonAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Breakdown row showing label and amount
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
              const Icon(
                Icons.add,
                size: 14,
                color: Color(0xFF9E9E9E),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: isBold ? 16 : 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: const Color(0xFF2D3142),
              ),
            ),
          ],
        ),
        Text(
          '$currency${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isBold ? 18 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? const Color(0xFF2D3142) : const Color(0xFF424242),
          ),
        ),
      ],
    );
  }
}
