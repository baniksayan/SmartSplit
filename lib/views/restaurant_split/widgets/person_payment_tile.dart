import 'package:flutter/material.dart';

/// Person Payment Tile Widget
/// List item showing "Person N", amount owed, and checkbox for paid status
class PersonPaymentTile extends StatelessWidget {
  final int personNumber;
  final double amount;
  final String currency;
  final bool isPaid;
  final ValueChanged<bool> onPaidChanged;
  final Color? color;

  const PersonPaymentTile({
    Key? key,
    required this.personNumber,
    required this.amount,
    required this.currency,
    required this.isPaid,
    required this.onPaidChanged,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accentColor = color ?? const Color(0xFF00B4D8);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPaid ? accentColor.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPaid ? accentColor.withOpacity(0.4) : const Color(0xFFE0E0E0),
          width: isPaid ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isPaid 
                ? accentColor.withOpacity(0.1)
                : Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () => onPaidChanged(!isPaid),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isPaid ? accentColor : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isPaid ? accentColor : const Color(0xFFBDBDBD),
                  width: 2,
                ),
              ),
              child: isPaid
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    )
                  : null,
            ),
          ),
          
          const SizedBox(width: 16),

          // Person info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Person $personNumber',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3142),
                    decoration: isPaid ? TextDecoration.lineThrough : null,
                    decorationColor: accentColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isPaid ? 'Paid ✓' : 'Pending',
                  style: TextStyle(
                    fontSize: 13,
                    color: isPaid 
                        ? accentColor
                        : const Color(0xFF2D3142).withOpacity(0.5),
                    fontWeight: isPaid ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '$currency${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isPaid ? accentColor : const Color(0xFF2D3142),
              decoration: isPaid ? TextDecoration.lineThrough : null,
              decorationColor: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
