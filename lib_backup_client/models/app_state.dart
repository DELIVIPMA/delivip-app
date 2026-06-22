import 'package:flutter/material.dart';
import 'cart_item.dart';
import 'order.dart';
import 'user.dart';
import 'address.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  bool _isDarkMode = false;
  final List<CartItem> _cartItems = [];
  Order? _currentOrder;
  User? _currentUser;
  String _locale = 'fr';
  final List<DeliveryAddress> _addresses = [];
  bool _isLoggedIn = false;
  bool _isEmailVerified = false;
  String? _pendingEmail;
  String? _pendingFirstName;
  String? _pendingLastName;
  String? _pendingPhone;
  String? _verificationCode;
  DateTime? _verificationCodeExpiry;
  bool _notificationsEnabled = true;
  bool _locationSharingEnabled = true;
  bool _dataCollectionEnabled = true;

  final StorageService _storage = StorageService();
  bool _storageLoaded = false;

  /// Charge les données persistées au démarrage de l'app
  Future<void> loadPersistedData() async {
    if (_storageLoaded) return;

    // Charger les préférences
    final savedDarkMode = _storage.loadDarkMode();
    if (savedDarkMode != null) _isDarkMode = savedDarkMode;

    final savedLocale = _storage.loadLocale();
    if (savedLocale != null) _locale = savedLocale;

    final savedNotif = _storage.loadNotificationsEnabled();
    if (savedNotif != null) _notificationsEnabled = savedNotif;

    final savedLocShare = _storage.loadLocationSharing();
    if (savedLocShare != null) _locationSharingEnabled = savedLocShare;

    final savedDataColl = _storage.loadDataCollection();
    if (savedDataColl != null) _dataCollectionEnabled = savedDataColl;

    // Charger l'utilisateur
    final savedUser = _storage.loadUser();
    if (savedUser != null) {
      _currentUser = savedUser;
      _isLoggedIn = true;
    }

    _storageLoaded = true;
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  Order? get currentOrder => _currentOrder;
  User? get currentUser => _currentUser;
  String get locale => _locale;
  List<DeliveryAddress> get addresses => List.unmodifiable(_addresses);
  bool get isLoggedIn => _isLoggedIn;
  bool get isEmailVerified => _isEmailVerified;
  String? get pendingEmail => _pendingEmail;
  String? get pendingFirstName => _pendingFirstName;
  String? get pendingLastName => _pendingLastName;
  String? get pendingPhone => _pendingPhone;
  String? get verificationCode => _verificationCode;
  DateTime? get verificationCodeExpiry => _verificationCodeExpiry;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get locationSharingEnabled => _locationSharingEnabled;
  bool get dataCollectionEnabled => _dataCollectionEnabled;

  int get cartItemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee {
    if (_cartItems.isEmpty) return 0.0;
    return subtotal > 100 ? 0.0 : 15.0;
  }

  double get tax {
    return subtotal * 0.1;
  }

  double get total {
    return subtotal + deliveryFee + tax;
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _storage.saveDarkMode(_isDarkMode);
    notifyListeners();
  }

  void setLocale(String locale) {
    _locale = locale;
    _storage.saveLocale(locale);
    notifyListeners();
  }

  /// Prépare l'inscription et initie la vérification par email
  /// Retourne le code de vérification généré
  String initiateRegistration({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) {
    _pendingFirstName = firstName;
    _pendingLastName = lastName;
    _pendingEmail = email;
    _pendingPhone = phone;
    _isEmailVerified = false;

    // Générer un code à 6 chiffres
    final random = DateTime.now().microsecondsSinceEpoch;
    _verificationCode = (random % 900000 + 100000).toString();
    _verificationCodeExpiry = DateTime.now().add(const Duration(minutes: 10));

    notifyListeners();
    return _verificationCode!;
  }

  /// Vérifie si le code entré est correct et encore valide
  bool verifyEmailCode(String code) {
    if (_verificationCode == null || _verificationCodeExpiry == null) {
      return false;
    }
    if (DateTime.now().isAfter(_verificationCodeExpiry!)) {
      return false;
    }
    if (_verificationCode != code) {
      return false;
    }
    return true;
  }

  /// Complète l'inscription après vérification réussie
  void completeRegistration() {
    if (_pendingEmail == null) return;

    _currentUser = User(
      id: 'USR${DateTime.now().millisecondsSinceEpoch}',
      firstName: _pendingFirstName ?? '',
      lastName: _pendingLastName ?? '',
      email: _pendingEmail!,
      phone: _pendingPhone ?? '',
      deliveryAddress: 'Avenue Hassan II',
      deliveryCity: 'Agadir',
      deliveryInstructions: '',
      latitude: 30.4200,
      longitude: -9.6030,
    );
    _isLoggedIn = true;
    _isEmailVerified = true;

    // Persister l'utilisateur
    _storage.saveUser(_currentUser);

    // Nettoyer les données temporaires
    _pendingEmail = null;
    _pendingFirstName = null;
    _pendingLastName = null;
    _pendingPhone = null;
    _verificationCode = null;
    _verificationCodeExpiry = null;

    notifyListeners();
  }

  void register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) {
    _currentUser = User(
      id: 'USR${DateTime.now().millisecondsSinceEpoch}',
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      deliveryAddress: 'Avenue Hassan II',
      deliveryCity: 'Agadir',
      deliveryInstructions: '',
      latitude: 30.4200,
      longitude: -9.6030,
    );
    _isLoggedIn = true;
    _storage.saveUser(_currentUser);
    notifyListeners();
  }

  void login(String email, String password) {
    _currentUser = User(
      id: 'USR${DateTime.now().millisecondsSinceEpoch}',
      firstName: 'Mohammed',
      lastName: 'Amine',
      email: email,
      phone: '+212 6 12 34 56 78',
      deliveryAddress: 'Avenue Hassan II',
      deliveryCity: 'Agadir',
      deliveryInstructions: 'Sonner à la porte, 2ème étage',
      latitude: 30.4200,
      longitude: -9.6030,
    );
    _isLoggedIn = true;
    _storage.saveUser(_currentUser);
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _cartItems.clear();
    _currentOrder = null;
    _storage.saveUser(null);
    _storage.clearAll();
    notifyListeners();
  }

  Future<void> updateUserInfo({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) return;
    if (firstName != null) _currentUser!.firstName = firstName;
    if (lastName != null) _currentUser!.lastName = lastName;
    if (email != null) _currentUser!.email = email;
    if (phone != null) _currentUser!.phone = phone;
    // avatarUrl: null est valide (suppression de la photo)
    if (avatarUrl != null) {
      _currentUser!.avatarUrl = avatarUrl;
    } else if (avatarUrl == null && _currentUser!.avatarUrl != null) {
      // L'utilisateur a explicitement supprimé son avatar
      _currentUser!.avatarUrl = null;
    }
    // Persister automatiquement après chaque mise à jour
    await _storage.saveUser(_currentUser);
    notifyListeners();
  }

  void updateDeliveryAddress({
    String? address,
    String? city,
    String? instructions,
    String? residence,
    String? buildingNumber,
    String? floor,
    String? apartment,
    double? latitude,
    double? longitude,
  }) {
    if (_currentUser == null) return;
    if (address != null) _currentUser!.deliveryAddress = address;
    if (city != null) _currentUser!.deliveryCity = city;
    if (instructions != null) _currentUser!.deliveryInstructions = instructions;
    if (residence != null) _currentUser!.residence = residence;
    if (buildingNumber != null) _currentUser!.buildingNumber = buildingNumber;
    if (floor != null) _currentUser!.floor = floor;
    if (apartment != null) _currentUser!.apartment = apartment;
    if (latitude != null) _currentUser!.latitude = latitude;
    if (longitude != null) _currentUser!.longitude = longitude;
    // Persister automatiquement après chaque mise à jour
    _storage.saveUser(_currentUser);
    notifyListeners();
  }

  void addAddress(DeliveryAddress address) {
    if (address.isDefault) {
      for (var a in _addresses) {
        a.isDefault = false;
      }
    }
    _addresses.add(address);
    notifyListeners();
  }

  void removeAddress(String addressId) {
    _addresses.removeWhere((a) => a.id == addressId);
    notifyListeners();
  }

  void setDefaultAddress(String addressId) {
    for (var a in _addresses) {
      a.isDefault = a.id == addressId;
    }
    notifyListeners();
  }

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    _storage.saveNotificationsEnabled(_notificationsEnabled);
    notifyListeners();
  }

  void toggleLocationSharing() {
    _locationSharingEnabled = !_locationSharingEnabled;
    _storage.saveLocationSharing(_locationSharingEnabled);
    notifyListeners();
  }

  void toggleDataCollection() {
    _dataCollectionEnabled = !_dataCollectionEnabled;
    _storage.saveDataCollection(_dataCollectionEnabled);
    notifyListeners();
  }

  void addToCart(CartItem item, dynamic store) {
    final existingIndex = _cartItems.indexWhere(
      (cartItem) =>
          cartItem.productId == item.productId &&
          cartItem.groupKey == item.groupKey,
    );

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += item.quantity;
    } else {
      _cartItems.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(String cartItemId) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.productId == cartItemId,
    );

    if (existingIndex >= 0) {
      if (_cartItems[existingIndex].quantity > 1) {
        _cartItems[existingIndex].quantity--;
      } else {
        _cartItems.removeAt(existingIndex);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int getItemQuantity(String productId) {
    int total = 0;
    for (var item in _cartItems) {
      if (item.productId == productId) {
        total += item.quantity;
      }
    }
    return total;
  }

  void createOrder() {
    if (_cartItems.isEmpty) return;

    _currentOrder = Order(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(_cartItems),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: total,
      status: OrderStatus.received,
      createdAt: DateTime.now(),
    );

    _cartItems.clear();
    notifyListeners();
  }

  void updateOrderStatus(OrderStatus status) {
    if (_currentOrder != null) {
      _currentOrder = Order(
        id: _currentOrder!.id,
        items: _currentOrder!.items,
        subtotal: _currentOrder!.subtotal,
        deliveryFee: _currentOrder!.deliveryFee,
        tax: _currentOrder!.tax,
        total: _currentOrder!.total,
        status: status,
        createdAt: _currentOrder!.createdAt,
      );
      notifyListeners();
    }
  }
}
