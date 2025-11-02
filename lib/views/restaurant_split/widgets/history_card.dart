import 'package:flutter/material.dart';
import '../../../models/restaurant/quick_split_model.dart';
import 'package:intl/intl.dart';

/// History Card Widget
/// Displays a recent split with restaurant name, date, amount, and people count
/// Tappable to load split data into current form
class HistoryCard extends StatelessWidget {
  final QuickSplitModel split;
  final VoidCallback onTap;
  final Color? color;

  const HistoryCard({
    Key? key,
    required this.split,
    required this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accentColor = color ?? const Color(0xFF00B4D8);
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant name and date
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (split.restaurantName?.isEmpty ?? true)
                            ? 'Quick Split'
                            : split.restaurantName!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateFormat.format(split.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF2D3142).withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.history_rounded,
                  color: accentColor.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),

            const SizedBox(height: 12),
            
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            
            const SizedBox(height: 12),

            // Split details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // People count
                _DetailChip(
                  icon: Icons.group_rounded,
                  label: '${split.numberOfPeople} people',
                  color: accentColor,
                ),

                // Grand total
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFF2D3142).withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${split.currency}${split.grandTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Per person amount
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Per Person:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                  Text(
                    '${split.currency}${split.perPersonAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),

            // Payment status
            if (split.paidBy.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    split.isFullyPaid 
                        ? Icons.check_circle_rounded
                        : Icons.schedule_rounded,
                    size: 14,
                    color: split.isFullyPaid 
                        ? Colors.green
                        : Colors.orange,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    split.isFullyPaid
                        ? 'Fully Paid'
                        : '${split.paidCount}/${split.numberOfPeople} paid',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: split.isFullyPaid 
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Detail chip showing icon and label
class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _DetailChip({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
