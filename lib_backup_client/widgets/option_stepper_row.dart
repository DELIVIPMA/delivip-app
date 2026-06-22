import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';

class OptionStepperRow extends StatelessWidget {
  final ProductOption option;
  final int value;
  final int min;
  final int max;
  final int defaultValue;
  final ValueChanged<int> onChanged;

  const OptionStepperRow({
    super.key,
    required this.option,
    required this.value,
    this.min = 0,
    this.max = 4,
    this.defaultValue = 1,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          if (option.emoji != null) ...[
            Text(option.emoji!, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              option.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: value > min ? () => onChanged(value - 1) : null,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: value > min
                        ? (value < defaultValue
                              ? Colors.red[50]
                              : AppTheme.primary.withValues(alpha: 0.1))
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.remove,
                      size: 18,
                      color: value > min
                          ? (value < defaultValue
                                ? Colors.red
                                : AppTheme.primary)
                          : Colors.grey[300],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: value < max ? () => onChanged(value + 1) : null,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: value < max
                        ? AppTheme.primary.withValues(alpha: 0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: value < max ? AppTheme.primary : Colors.grey[300],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
