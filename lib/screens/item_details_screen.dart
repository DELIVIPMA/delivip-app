import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/glass_container.dart';
import '../widgets/global_background.dart';
import '../widgets/responsive_helper.dart';
import '../data/models.dart';
import '../data/cart_provider.dart';

// ═══════════════════════════════════════════════════════════════════
//  ITEM DETAILS SCREEN — Product Customization / Options (Uber Eats)
//  Full Glassmorphism Premium Design
// ═══════════════════════════════════════════════════════════════════

// ─── Option Models ─────────────────────────────────────────────────

enum OptionType { radio, checkbox }

class OptionItem {
  final String id;
  final String name;
  final double price;
  final bool isDefault;

  const OptionItem({
    required this.id,
    required this.name,
    this.price = 0.0,
    this.isDefault = false,
  });
}

class OptionGroup {
  final String id;
  final String title;
  final String? subtitle;
  final OptionType type;
  final bool isRequired;
  final List<OptionItem> options;

  const OptionGroup({
    required this.id,
    required this.title,
    this.subtitle,
    required this.type,
    this.isRequired = false,
    required this.options,
  });
}

// ─── Dummy Product Data ────────────────────────────────────────────

class ProductDetail {
  final String name;
  final String description;
  final double basePrice;
  final String emoji;
  final String imageUrl;
  final List<OptionGroup> optionGroups;

  const ProductDetail({
    required this.name,
    required this.description,
    required this.basePrice,
    required this.emoji,
    this.imageUrl = '',
    this.optionGroups = const [],
  });
}

/// Mock product based on a "Big Mac Menu" fast-food item with Uber Eats style options
final mockProductDetail = ProductDetail(
  name: 'Big Mac Menu',
  description:
      'Two 100% beef patties, special sauce, lettuce, cheese, pickles, onions on a sesame seed bun. Served with your choice of side and drink.',
  basePrice: 49.00,
  emoji: '🍔',
  imageUrl:
      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&q=80',
  optionGroups: [
    OptionGroup(
      id: 'menu_size',
      title: 'Choose Menu Size',
      subtitle: 'Required',
      type: OptionType.radio,
      isRequired: true,
      options: [
        OptionItem(id: 'best_of', name: 'Best Of', price: 0.0, isDefault: true),
        OptionItem(id: 'maxi_best_of', name: 'Maxi Best Of', price: 15.0),
      ],
    ),
    OptionGroup(
      id: 'side',
      title: 'Choose your side',
      subtitle: 'Required',
      type: OptionType.radio,
      isRequired: true,
      options: [
        OptionItem(id: 'frites', name: 'Frites', price: 0.0, isDefault: true),
        OptionItem(id: 'potatoes', name: 'Potatoes', price: 0.0),
      ],
    ),
    OptionGroup(
      id: 'drink',
      title: 'Choose your drink',
      subtitle: 'Required',
      type: OptionType.radio,
      isRequired: true,
      options: [
        OptionItem(id: 'coca', name: 'Coca-Cola', price: 0.0, isDefault: true),
        OptionItem(id: 'sprite', name: 'Sprite', price: 0.0),
        OptionItem(id: 'fanta', name: 'Fanta', price: 0.0),
      ],
    ),
    OptionGroup(
      id: 'extras',
      title: 'Extras',
      subtitle: 'Optional',
      type: OptionType.checkbox,
      isRequired: false,
      options: [
        OptionItem(id: 'extra_cheese', name: 'Extra Cheese', price: 5.0),
        OptionItem(id: 'extra_sauce', name: 'Extra Sauce', price: 2.0),
      ],
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════════
//  MAIN SCREEN
// ═══════════════════════════════════════════════════════════════════

class ItemDetailsScreen extends StatefulWidget {
  final ProductDetail product;
  final String restaurantId;
  final String restaurantName;
  final VoidCallback? onBack;
  final VoidCallback? onAddToCartCallback;

  const ItemDetailsScreen({
    super.key,
    required this.product,
    required this.restaurantId,
    required this.restaurantName,
    this.onBack,
    this.onAddToCartCallback,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  static const _teal = Color(0xFF39BCA8);
  static const _dark = Color(0xFF1E1E24);

  int _quantity = 1;

  // Radio selections: groupId -> selectedOptionId
  final Map<String, String> _radioSelections = {};

  // Checkbox selections: groupId -> list of selected option ids
  final Map<String, List<String>> _checkboxSelections = {};

  final TextEditingController _noteController = TextEditingController();

  late final ProductDetail _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;

    // Initialize required radio selections with defaults
    for (final group in _product.optionGroups) {
      if (group.type == OptionType.radio && group.isRequired) {
        final defaultOption = group.options.firstWhere(
          (o) => o.isDefault,
          orElse: () => group.options.first,
        );
        _radioSelections[group.id] = defaultOption.id;
      }
      if (group.type == OptionType.checkbox) {
        _checkboxSelections[group.id] = [];
      }
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // ─── Price Calculation ────────────────────────────────────────

  double get _optionsTotal {
    double total = 0.0;

    for (final group in _product.optionGroups) {
      if (group.type == OptionType.radio) {
        final selectedId = _radioSelections[group.id];
        if (selectedId != null) {
          final option = group.options.firstWhere((o) => o.id == selectedId);
          total += option.price;
        }
      } else if (group.type == OptionType.checkbox) {
        final selectedIds = _checkboxSelections[group.id] ?? [];
        for (final id in selectedIds) {
          final option = group.options.firstWhere((o) => o.id == id);
          total += option.price;
        }
      }
    }

    return total;
  }

  double get _unitPrice => _product.basePrice + _optionsTotal;
  double get _totalPrice => _unitPrice * _quantity;

  // ─── Actions ──────────────────────────────────────────────────

  void _addToCart(BuildContext context) {
    final cart = context.read<CartProvider>();

    // Basic validation: all required radio groups must have a selection
    for (final group in _product.optionGroups) {
      if (group.type == OptionType.radio && group.isRequired) {
        if (_radioSelections[group.id] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please select an option for "${group.title}"'),
              backgroundColor: _teal,
            ),
          );
          return;
        }
      }
    }

    // Build a custom unique ID based on selected options so the cart
    // differentiates between e.g. "Big Mac Best Of + Frites + Coca"
    final optionIds = <String>[];
    for (final group in _product.optionGroups) {
      if (group.type == OptionType.radio) {
        final id = _radioSelections[group.id];
        if (id != null) optionIds.add(id);
      } else if (group.type == OptionType.checkbox) {
        optionIds.addAll(_checkboxSelections[group.id] ?? []);
      }
    }
    final customId =
        '${_product.name.toLowerCase().replaceAll(' ', '_')}_${optionIds.join('_')}';

    // Build a display name with selected options summary
    final selectedLabels = <String>[];
    for (final group in _product.optionGroups) {
      if (group.type == OptionType.radio) {
        final id = _radioSelections[group.id];
        if (id != null) {
          final opt = group.options.firstWhere((o) => o.id == id);
          selectedLabels.add(opt.name);
        }
      } else if (group.type == OptionType.checkbox) {
        final ids = _checkboxSelections[group.id] ?? [];
        for (final id in ids) {
          final opt = group.options.firstWhere((o) => o.id == id);
          selectedLabels.add(opt.name);
        }
      }
    }

    final displayName = '${_product.name} (${selectedLabels.join(', ')})'
        .replaceAll(' ()', '');

    final menuItem = MenuItem(
      id: customId,
      name: displayName,
      description: _noteController.text.isNotEmpty
          ? _noteController.text
          : _product.description,
      price: _unitPrice,
      emoji: _product.emoji,
      category: 'Plats',
    );

    for (int i = 0; i < _quantity; i++) {
      cart.add(menuItem, widget.restaurantId, widget.restaurantName);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_quantity}x $_displayName added to cart 🛒'),
        backgroundColor: _teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  String get _displayName {
    final selectedLabels = <String>[];
    for (final group in _product.optionGroups) {
      if (group.type == OptionType.radio) {
        final id = _radioSelections[group.id];
        if (id != null) {
          final opt = group.options.firstWhere((o) => o.id == id);
          selectedLabels.add(opt.name);
        }
      }
    }
    return '${_product.name} (${selectedLabels.join(', ')})'.replaceAll(
      ' ()',
      '',
    );
  }

  // ─── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final horPad = ResponsiveHelper.horizontalPadding(context);
    return SafeArea(
      child: Center(
        child: ResponsiveHelper.constrainWidth(
          context,
          SizedBox(
            width: double.infinity,
            child: GlassScaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withAlpha(60),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () {
                        if (widget.onBack != null) {
                          widget.onBack!();
                        } else {
                          final rootNav = Navigator.of(
                            context,
                            rootNavigator: true,
                          );
                          if (rootNav.canPop()) {
                            rootNav.pop();
                          } else if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withAlpha(60),
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  children: [
                    // ─── Scrollable Content ──────────────────────────────
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          // ─── Hero Section ────────────────────────────────
                          SliverToBoxAdapter(
                            child: _HeroSection(
                              product: _product,
                              teal: _teal,
                              dark: _dark,
                            ),
                          ),

                          // ─── Customization Sections ──────────────────────
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                horPad,
                                8,
                                horPad,
                                8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Section header
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 4,
                                      bottom: 16,
                                    ),
                                    child: Text(
                                      'Customize your order',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: _dark,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ),

                                  // Option groups
                                  ...List.generate(
                                    _product.optionGroups.length,
                                    (i) {
                                      return _buildOptionGroup(
                                        _product.optionGroups[i],
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 16),

                                  // ─── Special Instructions ────────────────
                                  _buildSpecialInstructions(),

                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ─── Floating Action Bar (Bottom) ─────────────────
                    _BottomActionBar(
                      quantity: _quantity,
                      totalPrice: _totalPrice,
                      onDecrement: () {
                        if (_quantity > 1) {
                          setState(() => _quantity--);
                        }
                      },
                      onIncrement: () => setState(() => _quantity++),
                      onAddToCart: () => _addToCart(context),
                      teal: _teal,
                      dark: _dark,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Option Group Builder ──────────────────────────────────────

  Widget _buildOptionGroup(OptionGroup group) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(18),
        opacity: 0.12,
        tintColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Group Header ────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    group.title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _dark,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: group.isRequired
                        ? _teal.withValues(alpha: 0.15)
                        : Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    group.isRequired ? 'Required' : 'Optional',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: group.isRequired ? _teal : Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ─── Options ─────────────────────────────────────
            ...List.generate(group.options.length, (i) {
              final option = group.options[i];
              final isLast = i == group.options.length - 1;

              if (group.type == OptionType.radio) {
                final isSelected = _radioSelections[group.id] == option.id;
                return Column(
                  children: [
                    _RadioOptionRow(
                      option: option,
                      isSelected: isSelected,
                      teal: _teal,
                      dark: _dark,
                      onTap: () {
                        setState(() {
                          _radioSelections[group.id] = option.id;
                        });
                      },
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        color: Colors.black.withValues(alpha: 0.04),
                      ),
                  ],
                );
              } else if (group.type == OptionType.checkbox) {
                final selectedIds = _checkboxSelections[group.id] ?? [];
                final isSelected = selectedIds.contains(option.id);
                return Column(
                  children: [
                    _CheckboxOptionRow(
                      option: option,
                      isSelected: isSelected,
                      teal: _teal,
                      dark: _dark,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedIds.remove(option.id);
                          } else {
                            selectedIds.add(option.id);
                          }
                        });
                      },
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        color: Colors.black.withValues(alpha: 0.04),
                      ),
                  ],
                );
              }

              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  // ─── Special Instructions ─────────────────────────────────────

  Widget _buildSpecialInstructions() {
    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      borderRadius: BorderRadius.circular(18),
      opacity: 0.12,
      tintColor: Colors.white,
      child: TextField(
        controller: _noteController,
        maxLines: 3,
        minLines: 1,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: _dark,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: 'Add a note for the restaurant (e.g., no onions)',
          hintStyle: GoogleFonts.poppins(
            fontSize: 13,
            color: _dark.withValues(alpha: 0.35),
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              Icons.edit_note_rounded,
              color: _teal.withValues(alpha: 0.6),
              size: 22,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 24,
          ),
        ),
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  HERO SECTION
// ═══════════════════════════════════════════════════════════════════

class _HeroSection extends StatelessWidget {
  final ProductDetail product;
  final Color teal;
  final Color dark;

  const _HeroSection({
    required this.product,
    required this.teal,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ─── Large Item Image ─────────────────────────────────
        SizedBox(
          height: 260,
          width: double.infinity,
          child: Stack(
            children: [
              // Image / placeholder
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        teal.withValues(alpha: 0.2),
                        const Color(0xFF6ED4C2).withValues(alpha: 0.1),
                        teal.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      product.emoji,
                      style: GoogleFonts.poppins(fontSize: 100),
                    ),
                  ),
                ),
              ),
              // Gradient overlay at bottom for text readability
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 120,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ─── Glassmorphism Card for Title, Price, Description ─
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GlassContainer(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            borderRadius: BorderRadius.circular(22),
            opacity: 0.15,
            tintColor: Colors.white,
            margin: const EdgeInsets.only(top: -40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  product.name,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: dark,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),

                // Price row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: teal,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${product.basePrice.toStringAsFixed(2)} DH',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Color(0xFFFFC107),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.7',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  product.description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: dark.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  RADIO OPTION ROW
// ═══════════════════════════════════════════════════════════════════

class _RadioOptionRow extends StatelessWidget {
  final OptionItem option;
  final bool isSelected;
  final Color teal;
  final Color dark;
  final VoidCallback onTap;

  const _RadioOptionRow({
    required this.option,
    required this.isSelected,
    required this.teal,
    required this.dark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            // Custom Radio button
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? teal : dark.withValues(alpha: 0.2),
                  width: isSelected ? 6 : 2,
                ),
                color: isSelected ? teal : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),

            // Option name
            Expanded(
              child: Text(
                option.name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? teal : dark,
                ),
              ),
            ),

            // Price if applicable
            if (option.price > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? teal.withValues(alpha: 0.1)
                      : dark.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${option.price.toStringAsFixed(2)} DH',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? teal : dark.withValues(alpha: 0.5),
                  ),
                ),
              )
            else
              Text(
                'Included',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: dark.withValues(alpha: 0.35),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  CHECKBOX OPTION ROW
// ═══════════════════════════════════════════════════════════════════

class _CheckboxOptionRow extends StatelessWidget {
  final OptionItem option;
  final bool isSelected;
  final Color teal;
  final Color dark;
  final VoidCallback onTap;

  const _CheckboxOptionRow({
    required this.option,
    required this.isSelected,
    required this.teal,
    required this.dark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            // Custom Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? teal : dark.withValues(alpha: 0.2),
                  width: 2,
                ),
                color: isSelected ? teal : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 14),

            // Option name
            Expanded(
              child: Text(
                option.name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? teal : dark,
                ),
              ),
            ),

            // Price if applicable
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? teal.withValues(alpha: 0.1)
                    : dark.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                option.price > 0
                    ? '+${option.price.toStringAsFixed(2)} DH'
                    : 'Free',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? teal : dark.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  BOTTOM ACTION BAR (Glassmorphism + Quantity + Add to Cart)
// ═══════════════════════════════════════════════════════════════════

class _BottomActionBar extends StatelessWidget {
  final int quantity;
  final double totalPrice;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onAddToCart;
  final Color teal;
  final Color dark;

  const _BottomActionBar({
    required this.quantity,
    required this.totalPrice,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAddToCart,
    required this.teal,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      opacity: 0.25,
      tintColor: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, -6),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 6,
          offset: const Offset(0, -2),
        ),
      ],
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // ─── Quantity Selector ──────────────────────────
            Container(
              decoration: BoxDecoration(
                color: dark.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: dark.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  // Minus button
                  GestureDetector(
                    onTap: quantity > 1 ? onDecrement : null,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: quantity > 1
                            ? Colors.transparent
                            : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                        ),
                      ),
                      child: Icon(
                        Icons.remove_rounded,
                        size: 20,
                        color: quantity > 1
                            ? teal
                            : dark.withValues(alpha: 0.15),
                      ),
                    ),
                  ),

                  // Quantity number
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '$quantity',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: dark,
                      ),
                    ),
                  ),

                  // Plus button
                  GestureDetector(
                    onTap: onIncrement,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                      child: Icon(Icons.add_rounded, size: 20, color: teal),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // ─── Add to Cart Button ─────────────────────────
            Expanded(
              child: GestureDetector(
                onTap: onAddToCart,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [teal, const Color(0xFF6ED4C2)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: teal.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add to Cart',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 18,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${totalPrice.toStringAsFixed(2)} DH',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
