import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models.dart';
import '../data/cart_provider.dart';

// ═══════════════════════════════════════════════════════
//  ADD-ON BOTTOM SHEET — Style Uber Eats
//  Proposé automatiquement après un tap sur un item
// ═══════════════════════════════════════════════════════

class AddonBottomSheet extends StatefulWidget {
  final MenuItem item;
  final CartProvider cart;
  final String restaurantId;
  final String restaurantName;

  const AddonBottomSheet({
    super.key,
    required this.item,
    required this.cart,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<AddonBottomSheet> createState() => _AddonBottomSheetState();
}

class _AddonBottomSheetState extends State<AddonBottomSheet> {
  int _quantity = 1;
  final Set<String> _selectedAddonIds = {};

  static const _teal = Color(0xFF39BCA8);

  List<AddonOption> get _addons => widget.item.defaultAddons;

  double get _itemTotal {
    final basePrice = widget.item.price;
    final addonsTotal = _selectedAddonIds.fold<double>(
      0.0,
      (sum, id) => sum + (_addons.firstWhere((a) => a.id == id).price),
    );
    return (basePrice + addonsTotal) * _quantity;
  }

  List<AddonOption> get _selectedAddons =>
      _addons.where((a) => _selectedAddonIds.contains(a.id)).toList();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Handle bar ─────────────────────────────
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ─── Header ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emoji / Image placeholder
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      widget.item.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Title & price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.item.price.toStringAsFixed(2)} DH',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _teal,
                        ),
                      ),
                    ],
                  ),
                ),
                // Close button
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close_rounded, size: 18),
                    color: Colors.black54,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade200, height: 1),

          // ─── Accompagnements Section ────────────────
          if (_addons.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Accompagnements',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                'Personnalisez votre choix',
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black45),
              ),
            ),
            // Add-on list (max height ~200)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 210),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _addons.length,
                separatorBuilder: (_, _) =>
                    Divider(height: 1, color: Colors.grey.shade100),
                itemBuilder: (_, i) {
                  final addon = _addons[i];
                  final isSelected = _selectedAddonIds.contains(addon.id);
                  return _AddonTile(
                    addon: addon,
                    isSelected: isSelected,
                    onToggle: () {
                      setState(() {
                        if (isSelected) {
                          _selectedAddonIds.remove(addon.id);
                        } else {
                          _selectedAddonIds.add(addon.id);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],

          // ─── Sticky Bottom Bar ──────────────────────
          const Spacer(),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                // ── Quantity Selector ──
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_quantity > 1) {
                            setState(() => _quantity--);
                          }
                        },
                        child: Container(
                          width: 44,
                          height: 48,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.remove_rounded,
                            size: 20,
                            color: _quantity > 1
                                ? Colors.black54
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                      Text(
                        '$_quantity',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _quantity++),
                        child: Container(
                          width: 44,
                          height: 48,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.add_rounded,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // ── Ajouter Button ──
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.cart.add(
                        widget.item,
                        widget.restaurantId,
                        widget.restaurantName,
                        addons: _selectedAddons,
                        quantity: _quantity,
                      );
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: _teal,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ajouter',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_itemTotal.toStringAsFixed(2)} DH',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  ADD-ON TILE — Checkbox + label + price
// ═══════════════════════════════════════════════════════

class _AddonTile extends StatelessWidget {
  final AddonOption addon;
  final bool isSelected;
  final VoidCallback onToggle;

  const _AddonTile({
    required this.addon,
    required this.isSelected,
    required this.onToggle,
  });

  static const _teal = Color(0xFF39BCA8);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
          children: [
            // Emoji
            Text(addon.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            // Name
            Expanded(
              child: Text(
                addon.name,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            // Price
            Text(
              '+${addon.price.toStringAsFixed(2)} DH',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 12),
            // Circle checkbox
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? _teal : Colors.transparent,
                border: Border.all(
                  color: isSelected ? _teal : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  SHOW FUNCTION — Convenient trigger
// ═══════════════════════════════════════════════════════

void showAddonSheet(
  BuildContext context, {
  required MenuItem item,
  required CartProvider cart,
  required String restaurantId,
  required String restaurantName,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black38,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => AddonBottomSheet(
      item: item,
      cart: cart,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
    ),
  );
}
