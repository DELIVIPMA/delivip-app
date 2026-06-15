import 'package:flutter/material.dart';

// ═════════════════════════════════════════════════════════════
//  LOCALIZATION — Admin Dashboard (AR / FR / EN)
// ═════════════════════════════════════════════════════════════

enum AppLanguage { arabic, french, english }

extension AppLanguageExt on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.arabic: return 'ar';
      case AppLanguage.french: return 'fr';
      case AppLanguage.english: return 'en';
    }
  }

  String get label {
    switch (this) {
      case AppLanguage.arabic: return 'العربية';
      case AppLanguage.french: return 'Français';
      case AppLanguage.english: return 'English';
    }
  }

  String get flag {
    switch (this) {
      case AppLanguage.arabic: return '🇲🇦';
      case AppLanguage.french: return '🇫🇷';
      case AppLanguage.english: return '🇬🇧';
    }
  }
}

// ═════════════════════════════════════════════════════════════
//  LANGUAGE PROVIDER
// ═════════════════════════════════════════════════════════════

class LanguageProvider extends ChangeNotifier {
  AppLanguage _current = AppLanguage.english;

  AppLanguage get current => _current;
  AdminStrings get strings => AdminStrings(_current);

  void setLanguage(AppLanguage lang) {
    _current = lang;
    notifyListeners();
  }

  bool get isRtl => _current == AppLanguage.arabic;
}

// ═════════════════════════════════════════════════════════════
//  ALL TRANSLATIONS
// ═════════════════════════════════════════════════════════════

class AdminStrings {
  final AppLanguage lang;

  const AdminStrings(this.lang);

  // ─── GENERAL ────────────────────────────────────────────
  String get appTitle {
    switch (lang) {
      case AppLanguage.arabic: return 'دليفيب  |  لوحة التحكم';
      case AppLanguage.french: return 'DELIVIP | Tableau de Bord';
      case AppLanguage.english: return 'DELIVIP | Admin Dashboard';
    }
  }

  String get adminLabel {
    switch (lang) {
      case AppLanguage.arabic: return 'مدير';
      case AppLanguage.french: return 'Admin';
      case AppLanguage.english: return 'Admin';
    }
  }

  String get superAdmin {
    switch (lang) {
      case AppLanguage.arabic: return 'مشرف عام';
      case AppLanguage.french: return 'Super Admin';
      case AppLanguage.english: return 'Super Admin';
    }
  }

  String get modeLight {
    switch (lang) {
      case AppLanguage.arabic: return 'وضع فاتح';
      case AppLanguage.french: return 'Mode clair';
      case AppLanguage.english: return 'Light mode';
    }
  }

  String get modeDark {
    switch (lang) {
      case AppLanguage.arabic: return 'وضع مظلم';
      case AppLanguage.french: return 'Mode sombre';
      case AppLanguage.english: return 'Dark mode';
    }
  }

  String get languageLabel {
    switch (lang) {
      case AppLanguage.arabic: return 'اللغة';
      case AppLanguage.french: return 'Langue';
      case AppLanguage.english: return 'Language';
    }
  }

  // ─── SIDEBAR ────────────────────────────────────────────
  String get navDashboard {
    switch (lang) {
      case AppLanguage.arabic: return 'لوحة البيانات';
      case AppLanguage.french: return 'Dashboard';
      case AppLanguage.english: return 'Dashboard';
    }
  }

  String get navStores {
    switch (lang) {
      case AppLanguage.arabic: return 'المتاجر';
      case AppLanguage.french: return 'Stores';
      case AppLanguage.english: return 'Stores';
    }
  }

  String get navOrders {
    switch (lang) {
      case AppLanguage.arabic: return 'الطلبيات';
      case AppLanguage.french: return 'Commandes';
      case AppLanguage.english: return 'Orders';
    }
  }

  String get navCustomers {
    switch (lang) {
      case AppLanguage.arabic: return 'الزبائن';
      case AppLanguage.french: return 'Clients';
      case AppLanguage.english: return 'Customers';
    }
  }

  String get navCategories {
    switch (lang) {
      case AppLanguage.arabic: return 'التصنيفات';
      case AppLanguage.french: return 'Catégories';
      case AppLanguage.english: return 'Categories';
    }
  }

  String get navSettings {
    switch (lang) {
      case AppLanguage.arabic: return 'الإعدادات';
      case AppLanguage.french: return 'Paramètres';
      case AppLanguage.english: return 'Settings';
    }
  }

  // ─── DASHBOARD ──────────────────────────────────────────
  String get totalOrders {
    switch (lang) {
      case AppLanguage.arabic: return 'إجمالي الطلبيات';
      case AppLanguage.french: return 'Total Commandes';
      case AppLanguage.english: return 'Total Orders';
    }
  }

  String get revenue {
    switch (lang) {
      case AppLanguage.arabic: return 'الإيرادات';
      case AppLanguage.french: return 'Revenus';
      case AppLanguage.english: return 'Revenue';
    }
  }

  String get activeOrders {
    switch (lang) {
      case AppLanguage.arabic: return 'الطلبيات النشطة';
      case AppLanguage.french: return 'Commandes Actives';
      case AppLanguage.english: return 'Active Orders';
    }
  }

  String get customers {
    switch (lang) {
      case AppLanguage.arabic: return 'الزبائن';
      case AppLanguage.french: return 'Clients';
      case AppLanguage.english: return 'Customers';
    }
  }

  String get revenueOverview {
    switch (lang) {
      case AppLanguage.arabic: return 'نظرة عامة على الإيرادات';
      case AppLanguage.french: return 'Aperçu des revenus';
      case AppLanguage.english: return 'Revenue Overview';
    }
  }

  String get recentOrders {
    switch (lang) {
      case AppLanguage.arabic: return 'آخر الطلبيات';
      case AppLanguage.french: return 'Dernières commandes';
      case AppLanguage.english: return 'Recent Orders';
    }
  }

  String get storesOverview {
    switch (lang) {
      case AppLanguage.arabic: return 'نظرة عامة على المتاجر';
      case AppLanguage.french: return 'Aperçu des stores';
      case AppLanguage.english: return 'Stores Overview';
    }
  }

  String get productsCount {
    switch (lang) {
      case AppLanguage.arabic: return 'منتج';
      case AppLanguage.french: return 'produits';
      case AppLanguage.english: return 'products';
    }
  }

  String get active {
    switch (lang) {
      case AppLanguage.arabic: return 'نشط';
      case AppLanguage.french: return 'Actif';
      case AppLanguage.english: return 'Active';
    }
  }

  String get inactive {
    switch (lang) {
      case AppLanguage.arabic: return 'غير نشط';
      case AppLanguage.french: return 'Inactif';
      case AppLanguage.english: return 'Inactive';
    }
  }

  // ─── STORES ─────────────────────────────────────────────
  String get storeManagement {
    switch (lang) {
      case AppLanguage.arabic: return 'إدارة المتاجر';
      case AppLanguage.french: return 'Gestion des Stores';
      case AppLanguage.english: return 'Store Management';
    }
  }

  String get listView {
    switch (lang) {
      case AppLanguage.arabic: return '📋 القائمة';
      case AppLanguage.french: return '📋 Liste';
      case AppLanguage.english: return '📋 List';
    }
  }

  String get newStore {
    switch (lang) {
      case AppLanguage.arabic: return '➕ متجر جديد';
      case AppLanguage.french: return '➕ Nouveau Store';
      case AppLanguage.english: return '➕ New Store';
    }
  }

  String get searchStores {
    switch (lang) {
      case AppLanguage.arabic: return 'بحث في المتاجر...';
      case AppLanguage.french: return 'Rechercher...';
      case AppLanguage.english: return 'Search stores...';
    }
  }

  String get showInactive {
    switch (lang) {
      case AppLanguage.arabic: return 'غير النشطة';
      case AppLanguage.french: return 'Inactifs';
      case AppLanguage.english: return 'Inactive';
    }
  }

  String get noStoresFound {
    switch (lang) {
      case AppLanguage.arabic: return 'لم يتم العثور على متاجر';
      case AppLanguage.french: return 'Aucun store trouvé';
      case AppLanguage.english: return 'No stores found';
    }
  }

  String get addStore {
    switch (lang) {
      case AppLanguage.arabic: return 'إضافة متجر';
      case AppLanguage.french: return 'Ajouter un store';
      case AppLanguage.english: return 'Add a store';
    }
  }

  String get edit {
    switch (lang) {
      case AppLanguage.arabic: return 'تعديل';
      case AppLanguage.french: return 'Modifier';
      case AppLanguage.english: return 'Edit';
    }
  }

  String get delete {
    switch (lang) {
      case AppLanguage.arabic: return 'حذف';
      case AppLanguage.french: return 'Supprimer';
      case AppLanguage.english: return 'Delete';
    }
  }

  String get confirmDeleteTitle {
    switch (lang) {
      case AppLanguage.arabic: return 'حذف المتجر؟';
      case AppLanguage.french: return 'Supprimer le store ?';
      case AppLanguage.english: return 'Delete store?';
    }
  }

  String get confirmDeleteMsg {
    switch (lang) {
      case AppLanguage.arabic: return 'هل تريد حذف "{{name}}"؟ هذا الإجراء لا رجعة فيه.';
      case AppLanguage.french: return 'Voulez-vous supprimer "{{name}}" ? Cette action est irréversible.';
      case AppLanguage.english: return 'Do you want to delete "{{name}}"? This action is irreversible.';
    }
  }

  String get cancel {
    switch (lang) {
      case AppLanguage.arabic: return 'إلغاء';
      case AppLanguage.french: return 'Annuler';
      case AppLanguage.english: return 'Cancel';
    }
  }

  String get storeActive {
    switch (lang) {
      case AppLanguage.arabic: return 'المتجر نشط';
      case AppLanguage.french: return 'Store actif';
      case AppLanguage.english: return 'Store active';
    }
  }

  String get addProduct {
    switch (lang) {
      case AppLanguage.arabic: return 'إضافة منتج';
      case AppLanguage.french: return 'Ajouter un produit';
      case AppLanguage.english: return 'Add a product';
    }
  }

  String get save {
    switch (lang) {
      case AppLanguage.arabic: return '💾 حفظ';
      case AppLanguage.french: return '💾 Enregistrer';
      case AppLanguage.english: return '💾 Save';
    }
  }

  String get addStoreBtn {
    switch (lang) {
      case AppLanguage.arabic: return '✅ إضافة المتجر';
      case AppLanguage.french: return '✅ Ajouter le store';
      case AppLanguage.english: return '✅ Add store';
    }
  }

  String get storeName {
    switch (lang) {
      case AppLanguage.arabic: return 'اسم المتجر';
      case AppLanguage.french: return 'Nom du store';
      case AppLanguage.english: return 'Store name';
    }
  }

  String get emojiFallback {
    switch (lang) {
      case AppLanguage.arabic: return 'رمز تعبيري (بديل)';
      case AppLanguage.french: return 'Emoji (fallback)';
      case AppLanguage.english: return 'Emoji (fallback)';
    }
  }

  String get imageUrl {
    switch (lang) {
      case AppLanguage.arabic: return 'رابط الصورة';
      case AppLanguage.french: return 'Image URL (lien vers image)';
      case AppLanguage.english: return 'Image URL';
    }
  }

  String get description {
    switch (lang) {
      case AppLanguage.arabic: return 'الوصف';
      case AppLanguage.french: return 'Description';
      case AppLanguage.english: return 'Description';
    }
  }

  String get address {
    switch (lang) {
      case AppLanguage.arabic: return 'العنوان';
      case AppLanguage.french: return 'Adresse';
      case AppLanguage.english: return 'Address';
    }
  }

  String get phone {
    switch (lang) {
      case AppLanguage.arabic: return 'الهاتف';
      case AppLanguage.french: return 'Téléphone';
      case AppLanguage.english: return 'Phone';
    }
  }

  String get openingHours {
    switch (lang) {
      case AppLanguage.arabic: return 'وقت الافتتاح';
      case AppLanguage.french: return 'Ouverture';
      case AppLanguage.english: return 'Opening';
    }
  }

  String get closingHours {
    switch (lang) {
      case AppLanguage.arabic: return 'وقت الإغلاق';
      case AppLanguage.french: return 'Fermeture';
      case AppLanguage.english: return 'Closing';
    }
  }

  String get latitude {
    switch (lang) {
      case AppLanguage.arabic: return 'خط العرض';
      case AppLanguage.french: return 'Latitude';
      case AppLanguage.english: return 'Latitude';
    }
  }

  String get longitude {
    switch (lang) {
      case AppLanguage.arabic: return 'خط الطول';
      case AppLanguage.french: return 'Longitude';
      case AppLanguage.english: return 'Longitude';
    }
  }

  // ─── ORDERS ─────────────────────────────────────────────
  String get orderManagement {
    switch (lang) {
      case AppLanguage.arabic: return 'إدارة الطلبيات';
      case AppLanguage.french: return 'Gestion des Commandes';
      case AppLanguage.english: return 'Order Management';
    }
  }

  String get searchOrders {
    switch (lang) {
      case AppLanguage.arabic: return 'بحث بالزبون أو رقم الطلب...';
      case AppLanguage.french: return 'Rechercher par client ou ID...';
      case AppLanguage.english: return 'Search by customer or ID...';
    }
  }

  String get all {
    switch (lang) {
      case AppLanguage.arabic: return 'الكل';
      case AppLanguage.french: return 'Tous';
      case AppLanguage.english: return 'All';
    }
  }

  String get pending {
    switch (lang) {
      case AppLanguage.arabic: return 'قيد الانتظار';
      case AppLanguage.french: return 'En attente';
      case AppLanguage.english: return 'Pending';
    }
  }

  String get preparing {
    switch (lang) {
      case AppLanguage.arabic: return 'قيد التحضير';
      case AppLanguage.french: return 'Préparation';
      case AppLanguage.english: return 'Preparing';
    }
  }

  String get ready {
    switch (lang) {
      case AppLanguage.arabic: return 'جاهزة';
      case AppLanguage.french: return 'Prête';
      case AppLanguage.english: return 'Ready';
    }
  }

  String get delivering {
    switch (lang) {
      case AppLanguage.arabic: return 'قيد التوصيل';
      case AppLanguage.french: return 'Livraison';
      case AppLanguage.english: return 'Delivering';
    }
  }

  String get delivered {
    switch (lang) {
      case AppLanguage.arabic: return 'تم التوصيل';
      case AppLanguage.french: return 'Livrée';
      case AppLanguage.english: return 'Delivered';
    }
  }

  String get cancelled {
    switch (lang) {
      case AppLanguage.arabic: return 'ملغية';
      case AppLanguage.french: return 'Annulée';
      case AppLanguage.english: return 'Cancelled';
    }
  }

  String get total {
    switch (lang) {
      case AppLanguage.arabic: return 'المجموع';
      case AppLanguage.french: return 'Total';
      case AppLanguage.english: return 'Total';
    }
  }

  String get inProgress {
    switch (lang) {
      case AppLanguage.arabic: return 'قيد التنفيذ';
      case AppLanguage.french: return 'En cours';
      case AppLanguage.english: return 'In progress';
    }
  }

  String get items {
    switch (lang) {
      case AppLanguage.arabic: return 'عنصر';
      case AppLanguage.french: return 'article(s)';
      case AppLanguage.english: return 'item(s)';
    }
  }

  String get noOrders {
    switch (lang) {
      case AppLanguage.arabic: return 'لا توجد طلبيات';
      case AppLanguage.french: return 'Aucune commande';
      case AppLanguage.english: return 'No orders';
    }
  }

  // ─── CUSTOMERS ──────────────────────────────────────────
  String get searchCustomers {
    switch (lang) {
      case AppLanguage.arabic: return 'بحث عن زبون...';
      case AppLanguage.french: return 'Rechercher un client...';
      case AppLanguage.english: return 'Search a customer...';
    }
  }

  String get totalCustomers {
    switch (lang) {
      case AppLanguage.arabic: return 'إجمالي الزبائن';
      case AppLanguage.french: return 'Total clients';
      case AppLanguage.english: return 'Total customers';
    }
  }

  String get totalOrdersCount {
    switch (lang) {
      case AppLanguage.arabic: return 'إجمالي الطلبيات';
      case AppLanguage.french: return 'Commandes total';
      case AppLanguage.english: return 'Total orders';
    }
  }

  String get newLast7Days {
    switch (lang) {
      case AppLanguage.arabic: return 'جدد (7 أيام)';
      case AppLanguage.french: return 'Nouveaux (7j)';
      case AppLanguage.english: return 'New (7 days)';
    }
  }

  // ─── CATEGORIES ─────────────────────────────────────────
  String get categoriesCount {
    switch (lang) {
      case AppLanguage.arabic: return 'تصنيف';
      case AppLanguage.french: return 'catégories';
      case AppLanguage.english: return 'categories';
    }
  }

  String get newCategory {
    switch (lang) {
      case AppLanguage.arabic: return 'تصنيف جديد';
      case AppLanguage.french: return 'Nouvelle catégorie';
      case AppLanguage.english: return 'New category';
    }
  }

  String get editCategory {
    switch (lang) {
      case AppLanguage.arabic: return 'تعديل التصنيف';
      case AppLanguage.french: return 'Modifier catégorie';
      case AppLanguage.english: return 'Edit category';
    }
  }

  String get categoryName {
    switch (lang) {
      case AppLanguage.arabic: return 'الاسم';
      case AppLanguage.french: return 'Nom';
      case AppLanguage.english: return 'Name';
    }
  }

  String get categoryEmoji {
    switch (lang) {
      case AppLanguage.arabic: return 'رمز تعبيري';
      case AppLanguage.french: return 'Emoji';
      case AppLanguage.english: return 'Emoji';
    }
  }

  String get add {
    switch (lang) {
      case AppLanguage.arabic: return 'إضافة';
      case AppLanguage.french: return 'Ajouter';
      case AppLanguage.english: return 'Add';
    }
  }

  String get orderDisplay {
    switch (lang) {
      case AppLanguage.arabic: return 'الترتيب';
      case AppLanguage.french: return 'Ordre';
      case AppLanguage.english: return 'Order';
    }
  }

  // ─── SETTINGS ───────────────────────────────────────────
  String get appSettings {
    switch (lang) {
      case AppLanguage.arabic: return 'إعدادات التطبيق';
      case AppLanguage.french: return 'Paramètres de l\'application';
      case AppLanguage.english: return 'App Settings';
    }
  }

  String get settingsDesc {
    switch (lang) {
      case AppLanguage.arabic: return 'تحكم في سلوك تطبيق دليفيب';
      case AppLanguage.french: return 'Contrôlez le comportement de l\'app client DeliVip';
      case AppLanguage.english: return 'Control the behavior of the DeliVip client app';
    }
  }

  String get appearance {
    switch (lang) {
      case AppLanguage.arabic: return '🎨 المظهر';
      case AppLanguage.french: return '🎨 Apparence';
      case AppLanguage.english: return '🎨 Appearance';
    }
  }

  String get general {
    switch (lang) {
      case AppLanguage.arabic: return '🏪 عام';
      case AppLanguage.french: return '🏪 Général';
      case AppLanguage.english: return '🏪 General';
    }
  }

  String get pricing {
    switch (lang) {
      case AppLanguage.arabic: return '💰 الأسعار';
      case AppLanguage.french: return '💰 Tarifs';
      case AppLanguage.english: return '💰 Pricing';
    }
  }

  String get features {
    switch (lang) {
      case AppLanguage.arabic: return '⚙️ الميزات';
      case AppLanguage.french: return '⚙️ Fonctionnalités';
      case AppLanguage.english: return '⚙️ Features';
    }
  }

  String get appName {
    switch (lang) {
      case AppLanguage.arabic: return 'اسم التطبيق';
      case AppLanguage.french: return 'Nom de l\'app';
      case AppLanguage.english: return 'App name';
    }
  }

  String get supportPhone {
    switch (lang) {
      case AppLanguage.arabic: return 'هاتف الدعم';
      case AppLanguage.french: return 'Téléphone support';
      case AppLanguage.english: return 'Support phone';
    }
  }

  String get supportEmail {
    switch (lang) {
      case AppLanguage.arabic: return 'بريد الدعم';
      case AppLanguage.french: return 'Email support';
      case AppLanguage.english: return 'Support email';
    }
  }

  String get deliveryFee {
    switch (lang) {
      case AppLanguage.arabic: return 'رسوم التوصيل (درهم)';
      case AppLanguage.french: return 'Frais de livraison (DH)';
      case AppLanguage.english: return 'Delivery fee (MAD)';
    }
  }

  String get minOrderAmount {
    switch (lang) {
      case AppLanguage.arabic: return 'الحد الأدنى للطلب (درهم)';
      case AppLanguage.french: return 'Minimum commande (DH)';
      case AppLanguage.english: return 'Min order amount (MAD)';
    }
  }

  String get freeDeliveryThreshold {
    switch (lang) {
      case AppLanguage.arabic: return 'التوصيل المجاني ابتداءً من (درهم)';
      case AppLanguage.french: return 'Livraison gratuite à partir de (DH)';
      case AppLanguage.english: return 'Free delivery from (MAD)';
    }
  }

  String get enablePickup {
    switch (lang) {
      case AppLanguage.arabic: return 'تفعيل الاستلام';
      case AppLanguage.french: return 'Activer le "Pickup"';
      case AppLanguage.english: return 'Enable "Pickup"';
    }
  }

  String get enableDineIn {
    switch (lang) {
      case AppLanguage.arabic: return 'تفعيل الأكل في المكان';
      case AppLanguage.french: return 'Activer le "Dine In"';
      case AppLanguage.english: return 'Enable "Dine In"';
    }
  }

  String get enableGrocery {
    switch (lang) {
      case AppLanguage.arabic: return 'تفعيل البقالة';
      case AppLanguage.french: return 'Activer l\'Épicerie';
      case AppLanguage.english: return 'Enable Grocery';
    }
  }

  String get enablePromotions {
    switch (lang) {
      case AppLanguage.arabic: return 'تفعيل العروض';
      case AppLanguage.french: return 'Activer les Promotions';
      case AppLanguage.english: return 'Enable Promotions';
    }
  }

  String get saveSettings {
    switch (lang) {
      case AppLanguage.arabic: return '💾 حفظ الإعدادات';
      case AppLanguage.french: return '💾 Sauvegarder les paramètres';
      case AppLanguage.english: return '💾 Save settings';
    }
  }

  String get settingsSaved {
    switch (lang) {
      case AppLanguage.arabic: return '✅ تم حفظ الإعدادات';
      case AppLanguage.french: return '✅ Paramètres sauvegardés';
      case AppLanguage.english: return '✅ Settings saved';
    }
  }

  String get confirmed {
    switch (lang) {
      case AppLanguage.arabic: return 'مؤكدة';
      case AppLanguage.french: return 'Confirmée';
      case AppLanguage.english: return 'Confirmed';
    }
  }

  String get dh {
    switch (lang) {
      case AppLanguage.arabic: return 'درهم';
      case AppLanguage.french: return 'DH';
      case AppLanguage.english: return 'MAD';
    }
  }
}
