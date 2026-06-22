import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/cart_provider.dart';
import 'add_new_address_screen.dart';
import 'order_tracking_screen.dart';

// ═══════════════════════════════════════════════════════════════════
//  CHECKOUT SCREEN — "La Caisse" (Uber Eats / Glovo Premium Style)
//  Pure Light Mode | White backgrounds | Subtle dividers
//  ✅ Interactive address & payment selection via Bottom Sheets
// ═══════════════════════════════════════════════════════════════════

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const _teal = Color(0xFF39BCA8);
  static const _dark = Color(0xFF1E1E24);

  // ─── State variables ────────────────────────────────────
  String _selectedAddress = 'Agadir, Maroc — Rue des Orangers, Rés. Al Wafa';
  String _selectedPayment = 'Paiement à la livraison (Cash)';

  // ─── Address options ────────────────────────────────────
  static const List<_AddressOption> _addresses = [
    _AddressOption(
      icon: Icons.home_rounded,
      label: 'Maison',
      detail: 'Rue des Orangers, Rés. Al Wafa',
    ),
    _AddressOption(
      icon: Icons.business_rounded,
      label: 'Travail',
      detail: 'Centre ville, Agadir',
    ),
  ];

  // ─── Payment options ────────────────────────────────────
  static const List<_PaymentOption> _payments = [
    _PaymentOption(icon: Icons.money, label: 'Paiement à la livraison (Cash)'),
    _PaymentOption(icon: Icons.credit_card, label: 'Carte Bancaire'),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _buildDeliveryAddress(context),
                _buildDivider(),
                _buildDeliveryTime(context),
                _buildDivider(),
                _buildPaymentSection(context),
                _buildDivider(),
                _buildCartItemsRecap(context, cart),
                const SizedBox(height: 4),
                _buildDivider(),
                _buildPriceBreakdown(cart),
              ],
            ),
          ),
          _buildBottomButton(context, cart),
        ],
      ),
    );
  }

  // ─── APP BAR ─────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: _dark),
        onPressed: () {
          final rootNav = Navigator.of(context, rootNavigator: true);
          if (rootNav.canPop()) {
            rootNav.pop();
          } else if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
      ),

      title: Text(
        'La Caisse',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _dark,
        ),
      ),
      centerTitle: false,
    );
  }

  // ─── DIVIDER ─────────────────────────────────────────────
  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
      indent: 0,
      endIndent: 0,
    );
  }

  // ─── SECTION 1: Livrer à ────────────────────────────────
  Widget _buildDeliveryAddress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on_outlined, color: _teal, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adresse de livraison',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedAddress,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => _showAddressPicker(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Modifier',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _teal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── SECTION 2: Temps de livraison ──────────────────────
  Widget _buildDeliveryTime(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          const Icon(Icons.access_time_rounded, color: _teal, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Temps de livraison',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Standard (20–30 min)',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── SECTION 3: Paiement ────────────────────────────────
  Widget _buildPaymentSection(BuildContext context) {
    // Determine which icon to show based on selection
    final isCash = _selectedPayment.contains('Cash');
    final paymentIcon = isCash ? Icons.money : Icons.credit_card;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paiement',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _dark,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(paymentIcon, color: _teal, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  _selectedPayment,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _dark,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _showPaymentPicker(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Modifier',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _teal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── SECTION 4: Détails du prix ─────────────────────────
  Widget _buildPriceBreakdown(CartProvider cart) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Récapitulatif',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _priceRow('Sous-total', '${cart.subtotal.toStringAsFixed(2)} DH'),
          const SizedBox(height: 12),
          _priceRow(
            'Frais de livraison',
            '${cart.deliveryFee.toStringAsFixed(2)} DH',
          ),
          const SizedBox(height: 12),
          _priceRow('Frais de service', '2.00 DH'),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _dark,
          ),
        ),
      ],
    );
  }

  // ─── CART ITEMS RECAP ───────────────────────────────────
  Widget _buildCartItemsRecap(BuildContext context, CartProvider cart) {
    if (cart.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${item.quantity}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _teal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.item.name,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: _dark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.addonsDescription.isNotEmpty)
                          Text(
                            '+ ${item.addonsDescription}',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '${item.totalPrice.toStringAsFixed(2)} DH',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _dark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════
  //  ADDRESS SELECTION — Full‑page screen (Uber Eats style)
  // ═════════════════════════════════════════════════════════
  void _showAddressPicker(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewAddressScreen()),
    );
  }

  // ═════════════════════════════════════════════════════════
  //  PAYMENT BOTTOM SHEET
  // ═════════════════════════════════════════════════════════
  void _showPaymentPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Handle ──
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Méthode de paiement',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: _dark,
                ),
              ),
              const SizedBox(height: 20),

              // ── Payment options ──
              ..._payments.map(
                (pm) => _PaymentTile(
                  icon: pm.icon,
                  label: pm.label,
                  isSelected: _selectedPayment == pm.label,
                  teal: _teal,
                  onTap: () {
                    setState(() {
                      _selectedPayment = pm.label;
                    });
                    Navigator.pop(ctx);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── BOTTOM BUTTON ──────────────────────────────────────
  Widget _buildBottomButton(BuildContext context, CartProvider cart) {
    const serviceFee = 2.00;
    final total = cart.subtotal + cart.deliveryFee + serviceFee;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 0.5),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: cart.isEmpty ? null : () => _onPlaceOrder(context, cart),
            style: ElevatedButton.styleFrom(
              backgroundColor: _teal,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade200,
              disabledForegroundColor: Colors.grey[400],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Placer la commande',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  ' \u2022 ${total.toStringAsFixed(2)} DH',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── PLACE ORDER ────────────────────────────────────────
  void _onPlaceOrder(BuildContext context, CartProvider cart) {
    if (cart.isEmpty) return;

    cart.clear();

    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const OrderTrackingScreen()),
      (route) => false,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  PRIVATE MODELS
// ═══════════════════════════════════════════════════════════════════

class _AddressOption {
  final IconData icon;
  final String label;
  final String detail;
  const _AddressOption({
    required this.icon,
    required this.label,
    required this.detail,
  });
}

class _PaymentOption {
  final IconData icon;
  final String label;
  const _PaymentOption({required this.icon, required this.label});
}

// ═══════════════════════════════════════════════════════════════════
//  ADDRESS TILE
// ═══════════════════════════════════════════════════════════════════

class _AddressTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String detail;
  final bool isSelected;
  final Color teal;
  final VoidCallback onTap;

  const _AddressTile({
    required this.icon,
    required this.label,
    required this.detail,
    required this.isSelected,
    required this.teal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected ? teal.withOpacity(0.06) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: teal, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E1E24),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        detail,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: teal, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  PAYMENT TILE
// ═══════════════════════════════════════════════════════════════════

class _PaymentTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color teal;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.teal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected ? teal.withOpacity(0.06) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: teal, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1E1E24),
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: teal, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
