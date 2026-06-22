import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════
//  DELIVERY ADDRESS MODEL
// ═══════════════════════════════════════════════════════

class DeliveryAddress {
  final String streetName;
  final String addressType; // "Maison", "Résidence", "Bureau"
  final String label; // "Home", "Work", "Other"
  final double latitude;
  final double longitude;
  final String instructions;

  const DeliveryAddress({
    required this.streetName,
    required this.addressType,
    required this.label,
    required this.latitude,
    required this.longitude,
    this.instructions = '',
  });

  /// Serialize to JSON for SharedPreferences
  Map<String, dynamic> toJson() => {
    'streetName': streetName,
    'addressType': addressType,
    'label': label,
    'latitude': latitude,
    'longitude': longitude,
    'instructions': instructions,
  };

  /// Deserialize from JSON
  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        streetName: json['streetName'] as String? ?? '',
        addressType: json['addressType'] as String? ?? 'Maison',
        label: json['label'] as String? ?? 'Home',
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
        instructions: json['instructions'] as String? ?? '',
      );

  /// Icon name for the address type (used in Home header)
  String get iconName {
    switch (addressType.toLowerCase()) {
      case 'maison':
        return 'home';
      case 'résidence':
      case 'residence':
      case 'bureau':
        return 'work';
      default:
        return 'place';
    }
  }
}

// ═══════════════════════════════════════════════════════
//  ADDRESS PROVIDER (ChangeNotifier + Persistence)
// ═══════════════════════════════════════════════════════

class AddressProvider extends ChangeNotifier {
  static const String _storageKey = 'delivip_saved_address';

  DeliveryAddress? _currentAddress;
  bool _isLoaded = false;

  /// The current saved delivery address, or null if none.
  DeliveryAddress? get currentAddress => _currentAddress;

  /// Whether the provider has finished loading from disk.
  bool get isLoaded => _isLoaded;

  /// Load the saved address from SharedPreferences on creation.
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        _currentAddress = DeliveryAddress.fromJson(json);
      }
    } catch (_) {
      // Silently fail — user will see "Select Delivery Address"
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  /// Save a new address both in-memory and to disk.
  Future<void> setAddress(DeliveryAddress address) async {
    _currentAddress = address;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(address.toJson()));
    } catch (_) {
      // Storage write failed — in-memory state is still updated
    }
  }

  /// Clear the saved address.
  Future<void> clearAddress() async {
    _currentAddress = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (_) {
      // Silently fail
    }
  }
}
