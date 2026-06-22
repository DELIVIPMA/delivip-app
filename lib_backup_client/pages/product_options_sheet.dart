import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product_model.dart';
import '../models/cart_item.dart';
import '../widgets/three_d_icon.dart';
import '../widgets/option_radio_row.dart';
import '../widgets/option_check_row.dart';
import '../widgets/option_stepper_row.dart';

class ProductOptionsSheet extends StatefulWidget {
  final ProductModel product;
  final String groupKey;
  final ValueChanged<CartItem> onAddToCart;

  const ProductOptionsSheet({
    super.key,
    required this.product,
    required this.groupKey,
    required this.onAddToCart,
  });

  @override
  State<ProductOptionsSheet> createState() => _ProductOptionsSheetState();
}

class _ProductOptionsSheetState extends State<ProductOptionsSheet> {
  int _quantity = 1;
  final Map<String, String> _radioSelections = {};
  final Map<String, List<String>> _checkboxSelections = {};
  final Map<String, int> _stepperValues = {};
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var group in widget.product.optionGroups) {
      if (group.type == OptionType.radio) {
        if (group.isRequired) {
          final defaultOption = group.options.firstWhere(
            (o) => o.isDefault,
            orElse: () => group.options.first,
          );
          _radioSelections[group.id] = defaultOption.id;
        }
      }
      if (group.type == OptionType.checkbox) {
        _checkboxSelections[group.id] = [];
      }
      if (group.type == OptionType.stepper) {
        for (var option in group.options) {
          _stepperValues[option.id] = option.isDefault ? 1 : 0;
        }
      }
    }
  }

  double get _totalOptionsPrice {
    double total = 0;
    for (var group in widget.product.optionGroups) {
      if (group.type == OptionType.radio) {
        final selectedId = _radioSelections[group.id];
        if (selectedId != null) {
          final opt = group.options.firstWhere(
            (o) => o.id == selectedId,
            orElse: () => group.options.first,
          );
          total += opt.price;
        }
      }
      if (group.type == OptionType.checkbox) {
        final selected = _checkboxSelections[group.id] ?? [];
        for (var id in selected) {
          final opt = group.options.firstWhere(
            (o) => o.id == id,
            orElse: () => group.options.first,
          );
          total += opt.price;
        }
      }
      if (group.type == OptionType.stepper) {
        for (var opt in group.options) {
          final val = _stepperValues[opt.id] ?? (opt.isDefault ? 1 : 0);
          total += opt.price * val;
        }
      }
    }
    return total;
  }

  double get _totalPrice =>
      (widget.product.basePrice + _totalOptionsPrice) * _quantity;

  void _addToCart() {
    final Map<String, List<String>> selectedOptions = {};
    for (var group in widget.product.optionGroups) {
      if (group.type == OptionType.radio) {
        final id = _radioSelections[group.id];
        if (id != null) {
          selectedOptions[group.id] = [id];
        }
      } else if (group.type == OptionType.checkbox) {
        selectedOptions[group.id] = _checkboxSelections[group.id] ?? [];
      } else if (group.type == OptionType.stepper) {
        final stepperItems = <String>[];
        for (var opt in group.options) {
          final val = _stepperValues[opt.id] ?? (opt.isDefault ? 1 : 0);
          if (val > 0) {
            stepperItems.add('${opt.id}:$val');
          }
        }
        if (stepperItems.isNotEmpty) {
          selectedOptions[group.id] = stepperItems;
        }
      }
    }

    final cartItem = CartItem(
      productId: widget.product.id,
      name: widget.product.name,
      price: widget.product.basePrice + _totalOptionsPrice,
      quantity: _quantity,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
      groupKey: widget.groupKey,
      selectedOptions: selectedOptions,
    );

    widget.onAddToCart(cartItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(bottom: bottomInset + 100),
                  children: [
                    // Product header with 3D icon
                    Stack(
                      children: [
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: widget.product.bgColor.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Center(
                            child: ThreeDIcon(
                              icon: AppIcons.forProduct(widget.product.emoji),
                              size: 100,
                              backgroundColor: widget.product.bgColor,
                              iconColor: AppTheme.primary,
                              borderRadius: 24,
                              padding: const EdgeInsets.all(20),
                            ),
                          ),
                        ),
                        // Close button
                        Positioned(
                          top: 8,
                          right: 16,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Product info
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.product.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '${widget.product.basePrice.toInt()} MAD',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                              if (widget.product.calories > 0) ...[
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.local_fire_department,
                                  size: 18,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.product.calories} cal',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    // Options sections
                    if (widget.product.optionGroups.isNotEmpty)
                      ...widget.product.optionGroups.map(
                        (group) => _buildOptionGroup(group),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No customization options available',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Note field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add a note',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: AppTheme.cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: TextField(
                              controller: _noteController,
                              decoration: const InputDecoration(
                                hintText: 'No onions, extra sauce...',
                                border: InputBorder.none,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              // Bottom sticky footer
              Container(
                padding: EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  16 + MediaQuery.of(context).padding.bottom,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      // Quantity selector
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.remove,
                                  size: 20,
                                  color: _quantity > 1
                                      ? AppTheme.primary
                                      : AppTheme.border,
                                ),
                              ),
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _quantity++),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Add to cart button
                      Expanded(
                        child: GestureDetector(
                          onTap: _addToCart,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'Add to cart · ${_totalPrice.toStringAsFixed(0)} MAD',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionGroup(ProductOptionGroup group) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Text(
                group.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (group.subtitle != null) ...[
                const SizedBox(width: 6),
                Text(
                  group.subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: group.isRequired
                      ? AppTheme.primary.withValues(alpha: 0.1)
                      : AppTheme.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  group.isRequired ? 'Required' : 'Optional',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: group.isRequired
                        ? AppTheme.primary
                        : AppTheme.accent.withValues(alpha: 0.8),
                  ),
                ),
              ),
              if (group.maxSelections != null && !group.isRequired) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Max ${group.maxSelections}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          // Options
          ...group.options.map((option) {
            switch (group.type) {
              case OptionType.radio:
                return OptionRadioRow(
                  option: option,
                  isSelected: _radioSelections[group.id] == option.id,
                  onTap: () {
                    setState(() {
                      _radioSelections[group.id] = option.id;
                    });
                  },
                );
              case OptionType.checkbox:
                final selected = _checkboxSelections[group.id] ?? [];
                final isSelected = selected.contains(option.id);
                final canSelect =
                    !isSelected &&
                    (selected.length < (group.maxSelections ?? 99));
                return OptionCheckRow(
                  option: option,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selected.remove(option.id);
                      } else if (canSelect) {
                        selected.add(option.id);
                      }
                    });
                  },
                );
              case OptionType.stepper:
                return OptionStepperRow(
                  option: option,
                  value:
                      _stepperValues[option.id] ?? (option.isDefault ? 1 : 0),
                  onChanged: (val) {
                    setState(() {
                      _stepperValues[option.id] = val;
                    });
                  },
                );
              default:
                return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
