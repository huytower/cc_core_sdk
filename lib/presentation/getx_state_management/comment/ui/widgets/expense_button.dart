import 'package:flutter/material.dart';
import 'package:theme/data/data_source/color/prj_color.dart';

class ExpenseButton extends StatefulWidget {
  const ExpenseButton({super.key, required this.onTap});

  final VoidCallback? onTap;

  @override
  State<ExpenseButton> createState() => _ExpenseButtonState();
}

class _ExpenseButtonState extends State<ExpenseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown() {
    _animationController.forward();
  }

  void _handleTapUp() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) {
        _handleTapUp();
        widget.onTap?.call();
      },
      onTapCancel: () => _handleTapUp(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 80,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [PrjColors.primary, PrjColors.primaryGradientEnd],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Expense',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: PrjColors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
