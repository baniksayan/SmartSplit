import 'package:flutter/material.dart';

/// Number Stepper Widget
/// Displays +/- buttons for incrementing/decrementing a number value
/// with bounce animation and min/max limits
class NumberStepper extends StatefulWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final String label;
  final Color? color;

  const NumberStepper({
    Key? key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.label,
    this.color,
  }) : super(key: key);

  @override
  State<NumberStepper> createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    if (widget.value < widget.max) {
      _playBounce();
      widget.onChanged(widget.value + 1);
    }
  }

  void _decrement() {
    if (widget.value > widget.min) {
      _playBounce();
      widget.onChanged(widget.value - 1);
    }
  }

  void _playBounce() {
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? const Color(0xFF00B4D8);
    final canDecrement = widget.value > widget.min;
    final canIncrement = widget.value < widget.max;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Decrement button
              _StepperButton(
                icon: Icons.remove_rounded,
                onTap: canDecrement ? _decrement : null,
                color: color,
                enabled: canDecrement,
              ),
              
              const SizedBox(width: 16),

              // Value display
              Expanded(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.value.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Increment button
              _StepperButton(
                icon: Icons.add_rounded,
                onTap: canIncrement ? _increment : null,
                color: color,
                enabled: canIncrement,
              ),
            ],
          ),
        ),
        
        // Min/Max hint
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Range: ${widget.min} - ${widget.max}',
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF2D3142).withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}

/// Stepper Button (+ or -)
class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final bool enabled;

  const _StepperButton({
    Key? key,
    required this.icon,
    required this.onTap,
    required this.color,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: enabled ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : color.withOpacity(0.3),
          size: 24,
        ),
      ),
    );
  }
}
