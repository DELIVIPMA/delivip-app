import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

/// Service de persistance des données DeliVIP
///
/// Gère :
/// - La sauvegarde/restauration des infos utilisateur
/// - La persistance via [SharedPreferences] pour les données textuelles
///
/// Note: Les opérations de fichiers (dart:io) ne sont pas disponibles sur le web,
///       donc la gestion des images (saveImagePermanently, deleteImage) a été
///       retirée. Pour la gestion des avatars, utilisez le stockage base64 ou
///       un service cloud.
class StorageService {
  // Clés SharedPreferences
  static const String _keyUserData = 'delivip_user_data';
  static const String _keyCartItems = 'delivip_cart_items';
  static const String _keyCurrentOrder = 'delivip_current_order';
  static const String _keyIsDarkMode = 'delivip_is_dark_mode';
  static const String _keyLocale = 'delivip_locale';
  static const String _keyNotificationsEnabled = 'delivip_notifications';
  static const String _keyLocationSharing = 'delivip_location_sharing';
  static const String _keyDataCollection = 'delivip_data_collection';

  late final SharedPreferences _prefs;

  // Singleton
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  bool _initialized = false;

  /// Initialise le service (appeler au démarrage de l'app)
  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  /// Vérifie si le service est initialisé
  bool get isInitialized => _initialized;

  // ═══════════════════════════════════════════════════════════════
  //  PERSISTANCE DES PRÉFÉRENCES (thème, langue...)
  // ═══════════════════════════════════════════════════════════════

  Future<void> saveDarkMode(bool isDark) async {
    await _prefs.setBool(_keyIsDarkMode, isDark);
  }

  bool? loadDarkMode() => _prefs.getBool(_keyIsDarkMode);

  Future<void> saveLocale(String locale) async {
    await _prefs.setString(_keyLocale, locale);
  }

  String? loadLocale() => _prefs.getString(_keyLocale);

  Future<void> saveNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  bool? loadNotificationsEnabled() => _prefs.getBool(_keyNotificationsEnabled);

  Future<void> saveLocationSharing(bool enabled) async {
    await _prefs.setBool(_keyLocationSharing, enabled);
  }

  bool? loadLocationSharing() => _prefs.getBool(_keyLocationSharing);

  Future<void> saveDataCollection(bool enabled) async {
    await _prefs.setBool(_keyDataCollection, enabled);
  }

  bool? loadDataCollection() => _prefs.getBool(_keyDataCollection);

  // ═══════════════════════════════════════════════════════════════
  //  PERSISTANCE DES DONNÉES UTILISATEUR
  // ═══════════════════════════════════════════════════════════════

  /// Sauvegarde l'utilisateur courant dans SharedPreferences
  Future<void> saveUser(User? user) async {
    if (user == null) {
      await _prefs.remove(_keyUserData);
      return;
    }
    final json = jsonEncode(user.toJson());
    await _prefs.setString(_keyUserData, json);
  }

  /// Charge l'utilisateur depuis SharedPreferences
  User? loadUser() {
    final json = _prefs.getString(_keyUserData);
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return User.fromJson(map);
    } catch (e) {
      print('StorageService.loadUser error: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  //  PERSISTANCE DU PANIER
  // ═══════════════════════════════════════════════════════════════

  Future<void> saveCartItems(List<CartItem> items) async {
    final json = jsonEncode(items.map((item) => item.toJson()).toList());
    await _prefs.setString(_keyCartItems, json);
  }

  List<CartItem> loadCartItems() {
    final json = _prefs.getString(_keyCartItems);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('StorageService.loadCartItems error: $e');
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════
  //  PERSISTANCE DE LA COMMANDE EN COURS
  // ═══════════════════════════════════════════════════════════════

  Future<void> saveCurrentOrder(Order? order) async {
    if (order == null) {
      await _prefs.remove(_keyCurrentOrder);
      return;
    }
    final json = jsonEncode(order.toJson());
    await _prefs.setString(_keyCurrentOrder, json);
  }

  Order? loadCurrentOrder() {
    final json = _prefs.getString(_keyCurrentOrder);
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return Order.fromJson(map);
    } catch (e) {
      print('StorageService.loadCurrentOrder error: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  //  NETTOYAGE
  // ═══════════════════════════════════════════════════════════════

  /// Supprime toutes les données persistées (déconnexion)
  Future<void> clearAll() async {
    // Supprimer toutes les clés SharedPreferences
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith('delivip_')) {
        await _prefs.remove(key);
      }
    }
  }
}
