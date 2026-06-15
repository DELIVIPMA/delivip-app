import 'package:flutter/material.dart';
import 'admin_models.dart';
import 'models.dart';

// ═══════════════════════════════════════════════════════
//  APP DATA PROVIDER — Source unique des données
//  Admin ET Client partagent les mêmes données
// ═══════════════════════════════════════════════════════

class AppDataProvider extends ChangeNotifier {
  List<AdminStore> _stores = [];
  List<AdminOrder> _orders = [];
  List<AdminCategory> _categories = [];
  AppSettings _settings = AppSettings();

  // ─── Getters ─────────────────────────────────────────
  List<AdminStore> get stores => _stores;
  List<AdminOrder> get orders => _orders;
  List<AdminCategory> get categories => _categories;
  AppSettings get settings => _settings;

  /// Restaurants prêts pour l'app client (convertis depuis AdminStore)
  List<Restaurant> get restaurants =>
      _stores.where((s) => s.isActive).map((s) => s.toRestaurant()).toList();

  // ─── Initialisation avec les données sample ──────────
  void loadSampleData() {
    _stores = getSampleStores();
    _orders = getSampleOrders();
    _categories = getSampleCategories();
    _settings = AppSettings();
    notifyListeners();
  }

  // ─── Méthodes pour l'Admin ───────────────────────────
  void updateStores(List<AdminStore> stores) {
    _stores = stores;
    notifyListeners();
  }

  void updateOrders(List<AdminOrder> orders) {
    _orders = orders;
    notifyListeners();
  }

  void updateCategories(List<AdminCategory> categories) {
    _categories = categories;
    notifyListeners();
  }

  void updateSettings(AppSettings settings) {
    _settings = settings;
    notifyListeners();
  }

  /// Récupère un restaurant par son ID
  Restaurant? getRestaurantById(String id) {
    final store = _stores.where((s) => s.id == id).firstOrNull;
    return store?.toRestaurant();
  }
}
