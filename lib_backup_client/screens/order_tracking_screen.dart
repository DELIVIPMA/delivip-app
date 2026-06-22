import 'package:flutter/material.dart';
import 'dart:async';
import '../models/app_state.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';
import 'multi_store_home_screen.dart';
import 'delivery_map_screen.dart';

class OrderTrackingScreen extends StatefulWidget {
  final AppState appState;
  final Order? order;

  const OrderTrackingScreen({super.key, required this.appState, this.order});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with SingleTickerProviderStateMixin {
  Timer? _statusTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startStatusUpdates();
  }

  void _startStatusUpdates() {
    _statusTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (widget.appState.currentOrder == null) {
        timer.cancel();
        return;
      }

      final currentStatus = widget.appState.currentOrder!.status;

      switch (currentStatus) {
        case OrderStatus.received:
          widget.appState.updateOrderStatus(OrderStatus.preparing);
          break;
        case OrderStatus.preparing:
          widget.appState.updateOrderStatus(OrderStatus.delivering);
          break;
        case OrderStatus.delivering:
          widget.appState.updateOrderStatus(OrderStatus.delivered);
          timer.cancel();
          _showDeliveredDialog();
          break;
        case OrderStatus.delivered:
          timer.cancel();
          break;
        case OrderStatus.cancelled:
          timer.cancel();
          break;
      }
    });
  }

  void _showDeliveredDialog() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Commande livrée !',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Votre commande a été livrée avec succès. Bon appétit !',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            MultiStoreHomeScreen(appState: widget.appState),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Retour à l'accueil"),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.received:
        return 'Commande reçue';
      case OrderStatus.preparing:
        return 'En préparation';
      case OrderStatus.delivering:
        return 'Livreur en route';
      case OrderStatus.delivered:
        return 'Livré';
      case OrderStatus.cancelled:
        return 'Annulé';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi de commande'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>
                    MultiStoreHomeScreen(appState: widget.appState),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: AnimatedBuilder(
        animation: widget.appState,
        builder: (context, child) {
          final order = widget.appState.currentOrder;
          if (order == null) {
            return const Center(child: Text('Aucune commande en cours'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildOrderHeader(order),
                if (order.status == OrderStatus.delivering) _buildMapButton(),
                _buildStatusTimeline(order),
                _buildOrderDetails(order),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderHeader(Order order) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryCyan,
            AppTheme.primaryCyan.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryCyan.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delivery_dining,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _getStatusText(order.status),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Commande #${order.id.substring(3, 10)}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DeliveryMapScreen(appState: widget.appState),
              ),
            );
          },
          icon: const Icon(Icons.map, size: 22),
          label: const Text(
            'Voir le livreur sur la carte',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryCyan,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            shadowColor: AppTheme.primaryCyan.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(Order order) {
    final statuses = [
      (
        _getStatusText(OrderStatus.received),
        'Votre commande a été confirmée',
        OrderStatus.received,
      ),
      (
        _getStatusText(OrderStatus.preparing),
        'Le magasin prépare votre commande',
        OrderStatus.preparing,
      ),
      (
        _getStatusText(OrderStatus.delivering),
        'Votre commande est en chemin',
        OrderStatus.delivering,
      ),
      (
        _getStatusText(OrderStatus.delivered),
        'Commande livrée avec succès',
        OrderStatus.delivered,
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progression', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          ...statuses.asMap().entries.map((entry) {
            final index = entry.key;
            final title = entry.value.$1;
            final subtitle = entry.value.$2;
            final status = entry.value.$3;
            final isLast = index == statuses.length - 1;
            final isCompleted = order.status.index >= status.index;
            final isActive = order.status == status;
            return _buildTimelineStep(
              icon: _getStatusIcon(status),
              title: title,
              subtitle: subtitle,
              isCompleted: isCompleted,
              isActive: isActive,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.received:
        return Icons.receipt_long;
      case OrderStatus.preparing:
        return Icons.inventory_2;
      case OrderStatus.delivering:
        return Icons.two_wheeler;
      case OrderStatus.delivered:
        return Icons.home;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.primaryCyan
                    : Theme.of(context).cardTheme.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? AppTheme.primaryCyan
                      : Colors.grey.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryCyan.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                isCompleted ? Icons.check : icon,
                color: isCompleted ? Colors.white : Colors.grey,
                size: 24,
              ),
            ),
            if (!isLast)
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 2,
                height: 60,
                color: isCompleted
                    ? AppTheme.primaryCyan
                    : Colors.grey.withValues(alpha: 0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCompleted
                        ? Theme.of(context).textTheme.bodyLarge?.color
                        : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isCompleted
                        ? Theme.of(context).textTheme.bodyMedium?.color
                        : Colors.grey,
                  ),
                ),
                if (isActive)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryCyan,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'En cours...',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryCyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails(Order order) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Détails de la commande',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Text(
                    '${item.quantity}x',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryCyan,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item.name)),
                  Text(
                    '${item.totalPrice.toStringAsFixed(2)} MAD',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 24),
          _buildDetailRow('Sous-total', order.subtotal),
          const SizedBox(height: 8),
          _buildDetailRow('Livraison', order.deliveryFee),
          const SizedBox(height: 8),
          _buildDetailRow('Taxes', order.tax),
          const Divider(height: 24),
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${order.total.toStringAsFixed(2)} MAD',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryCyan,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, double amount) {
    return Row(
      children: [
        Text(label),
        const Spacer(),
        Text(
          '${amount.toStringAsFixed(2)} MAD',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
