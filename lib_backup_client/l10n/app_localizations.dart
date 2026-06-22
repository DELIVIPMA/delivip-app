import 'package:flutter/material.dart';

/// Service de localisation pour 3 langues : Arabe, Français, Anglais
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const List<String> supportedLanguages = ['fr', 'en', 'ar'];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String get appName => _translate('appName');
  String get deliveryGratuite => _translate('deliveryGratuite');
  String get livrerA => _translate('livrerA');
  String get rechercher => _translate('rechercher');
  String get queSouhaitezVous => _translate('queSouhaitezVous');
  String get restaurants => _translate('restaurants');
  String get epiceries => _translate('epiceries');
  String get pharmacies => _translate('pharmacies');
  String get boutiques => _translate('boutiques');
  String get magasinsVip => _translate('magasinsVip');
  String get mesCommandes => _translate('mesCommandes');
  String get mesFavoris => _translate('mesFavoris');
  String get monCompte => _translate('monCompte');
  String get parametres => _translate('parametres');
  String get aide => _translate('aide');
  String get deconnexion => _translate('deconnexion');
  String get seDeconnecter => _translate('seDeconnecter');
  String get localisation => _translate('localisation');
  String get adresseLivraison => _translate('adresseLivraison');
  String get confidentialite => _translate('confidentialite');
  String get parametresConfidentialite => _translate('parametresConfidentialite');
  String get donneesPersonnelles => _translate('donneesPersonnelles');
  String get politiqueConfidentialite => _translate('politiqueConfidentialite');
  String get supprimerCompte => _translate('supprimerCompte');
  String get notifications => _translate('notifications');
  String get langue => _translate('langue');
  String get propos => _translate('propos');
  String get mesInfos => _translate('mesInfos');
  String get changerPhoto => _translate('changerPhoto');
  String get prenom => _translate('prenom');
  String get nom => _translate('nom');
  String get email => _translate('email');
  String get telephone => _translate('telephone');
  String get enregistrer => _translate('enregistrer');
  String get annuler => _translate('annuler');
  String get ajouterAdresse => _translate('ajouterAdresse');
  String get rue => _translate('rue');
  String get ville => _translate('ville');
  String get codePostal => _translate('codePostal');
  String get instructionsLivraison => _translate('instructionsLivraison');
  String get positionActuelle => _translate('positionActuelle');
  String get voirSurCarte => _translate('voirSurCarte');
  String get suiviCommande => _translate('suiviCommande');
  String get enPreparation => _translate('enPreparation');
  String get livreurEnRoute => _translate('livreurEnRoute');
  String get commandeLivree => _translate('commandeLivree');
  String get arriveePrevue => _translate('arriveePrevue');
  String get appeler => _translate('appeler');
  String get message => _translate('message');
  String get pourboire => _translate('pourboire');
  String get connexion => _translate('connexion');
  String get inscription => _translate('inscription');
  String get motDePasse => _translate('motDePasse');
  String get confirmermotDePasse => _translate('confirmermotDePasse');
  String get connecte => _translate('connecte');
  String get bienvenueMessage => _translate('bienvenueMessage');
  String get total => _translate('total');
  String get commander => _translate('commander');
  String get panier => _translate('panier');
  String get livraison => _translate('livraison');
  String get taxes => _translate('taxes');
  String get sousTotal => _translate('sousTotal');
  String get retrait => _translate('retrait');
  String get min => _translate('min');
  String get km => _translate('km');

  String _translate(String key) {
    final map = _localizedValues[locale.languageCode];
    if (map != null && map.containsKey(key)) {
      return map[key]!;
    }
    // Fallback to French
    return _localizedValues['fr']![key] ?? key;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'fr': {
      'appName': 'DeliVIP',
      'deliveryGratuite': 'Livraison gratuite',
      'livrerA': 'Livrer à',
      'rechercher': 'Rechercher un magasin ou un produit...',
      'queSouhaitezVous': 'Que souhaitez-vous commander ?',
      'restaurants': 'Restaurants',
      'epiceries': 'Épiceries',
      'pharmacies': 'Pharmacies',
      'boutiques': 'Boutiques',
      'magasinsVip': 'Magasins VIP',
      'mesCommandes': 'Mes commandes',
      'mesFavoris': 'Mes favoris',
      'monCompte': 'Mon compte',
      'parametres': 'Paramètres',
      'aide': 'Aide',
      'deconnexion': 'Déconnexion',
      'seDeconnecter': 'Se déconnecter',
      'localisation': 'Localisation',
      'adresseLivraison': 'Adresse de livraison',
      'confidentialite': 'Confidentialité',
      'parametresConfidentialite': 'Paramètres de confidentialité',
      'donneesPersonnelles': 'Données personnelles',
      'politiqueConfidentialite': 'Politique de confidentialité',
      'supprimerCompte': 'Supprimer mon compte',
      'notifications': 'Notifications',
      'langue': 'Langue',
      'propos': 'À propos',
      'mesInfos': 'Mes informations',
      'changerPhoto': 'Changer la photo',
      'prenom': 'Prénom',
      'nom': 'Nom',
      'email': 'Email',
      'telephone': 'Téléphone',
      'enregistrer': 'Enregistrer',
      'annuler': 'Annuler',
      'ajouterAdresse': 'Ajouter une adresse',
      'rue': 'Rue',
      'ville': 'Ville',
      'codePostal': 'Code postal',
      'instructionsLivraison': 'Instructions de livraison',
      'positionActuelle': 'Position actuelle',
      'voirSurCarte': 'Voir sur la carte',
      'suiviCommande': 'Suivi de commande',
      'enPreparation': 'En préparation',
      'livreurEnRoute': 'Livreur en route',
      'commandeLivree': 'Commande livrée',
      'arriveePrevue': 'Arrivée prévue dans 8 min',
      'appeler': 'Appeler',
      'message': 'Message',
      'pourboire': 'Pourboire',
      'connexion': 'Connexion',
      'inscription': 'Inscription',
      'motDePasse': 'Mot de passe',
      'confirmermotDePasse': 'Confirmer le mot de passe',
      'connecte': 'Connecté',
      'bienvenueMessage': 'Bienvenue sur DeliVIP',
      'total': 'Total',
      'commander': 'Commander',
      'panier': 'Panier',
      'livraison': 'Livraison',
      'taxes': 'Taxes',
      'sousTotal': 'Sous-total',
      'retrait': 'Retrait',
      'min': 'min',
      'km': 'km',
    },
    'en': {
      'appName': 'DeliVIP',
      'deliveryGratuite': 'Free delivery',
      'livrerA': 'Deliver to',
      'rechercher': 'Search for a store or product...',
      'queSouhaitezVous': 'What would you like to order?',
      'restaurants': 'Restaurants',
      'epiceries': 'Grocery stores',
      'pharmacies': 'Pharmacies',
      'boutiques': 'Shops',
      'magasinsVip': 'VIP Stores',
      'mesCommandes': 'My orders',
      'mesFavoris': 'My favorites',
      'monCompte': 'My account',
      'parametres': 'Settings',
      'aide': 'Help',
      'deconnexion': 'Logout',
      'seDeconnecter': 'Log out',
      'localisation': 'Location',
      'adresseLivraison': 'Delivery address',
      'confidentialite': 'Privacy',
      'parametresConfidentialite': 'Privacy settings',
      'donneesPersonnelles': 'Personal data',
      'politiqueConfidentialite': 'Privacy policy',
      'supprimerCompte': 'Delete my account',
      'notifications': 'Notifications',
      'langue': 'Language',
      'propos': 'About',
      'mesInfos': 'My information',
      'changerPhoto': 'Change photo',
      'prenom': 'First name',
      'nom': 'Last name',
      'email': 'Email',
      'telephone': 'Phone',
      'enregistrer': 'Save',
      'annuler': 'Cancel',
      'ajouterAdresse': 'Add an address',
      'rue': 'Street',
      'ville': 'City',
      'codePostal': 'Postal code',
      'instructionsLivraison': 'Delivery instructions',
      'positionActuelle': 'Current location',
      'voirSurCarte': 'View on map',
      'suiviCommande': 'Order tracking',
      'enPreparation': 'Preparing',
      'livreurEnRoute': 'Courier on the way',
      'commandeLivree': 'Delivered',
      'arriveePrevue': 'Arriving in 8 min',
      'appeler': 'Call',
      'message': 'Message',
      'pourboire': 'Tip',
      'connexion': 'Login',
      'inscription': 'Sign up',
      'motDePasse': 'Password',
      'confirmermotDePasse': 'Confirm password',
      'connecte': 'Connected',
      'bienvenueMessage': 'Welcome to DeliVIP',
      'total': 'Total',
      'commander': 'Order',
      'panier': 'Cart',
      'livraison': 'Delivery',
      'taxes': 'Taxes',
      'sousTotal': 'Subtotal',
      'retrait': 'Pickup',
      'min': 'min',
      'km': 'km',
    },
    'ar': {
      'appName': 'ديلي فيب',
      'deliveryGratuite': 'توصيل مجاني',
      'livrerA': 'التوصيل إلى',
      'rechercher': 'ابحث عن متجر أو منتج...',
      'queSouhaitezVous': 'ماذا تريد أن تطلب؟',
      'restaurants': 'مطاعم',
      'epiceries': 'بقالات',
      'pharmacies': 'صيدليات',
      'boutiques': 'متاجر',
      'magasinsVip': 'متاجر VIP',
      'mesCommandes': 'طلباتي',
      'mesFavoris': 'المفضلة',
      'monCompte': 'حسابي',
      'parametres': 'الإعدادات',
      'aide': 'مساعدة',
      'deconnexion': 'تسجيل الخروج',
      'seDeconnecter': 'تسجيل الخروج',
      'localisation': 'الموقع',
      'adresseLivraison': 'عنوان التوصيل',
      'confidentialite': 'الخصوصية',
      'parametresConfidentialite': 'إعدادات الخصوصية',
      'donneesPersonnelles': 'البيانات الشخصية',
      'politiqueConfidentialite': 'سياسة الخصوصية',
      'supprimerCompte': 'حذف حسابي',
      'notifications': 'الإشعارات',
      'langue': 'اللغة',
      'propos': 'حول',
      'mesInfos': 'معلوماتي',
      'changerPhoto': 'تغيير الصورة',
      'prenom': 'الاسم الأول',
      'nom': 'اسم العائلة',
      'email': 'البريد الإلكتروني',
      'telephone': 'الهاتف',
      'enregistrer': 'حفظ',
      'annuler': 'إلغاء',
      'ajouterAdresse': 'إضافة عنوان',
      'rue': 'الشارع',
      'ville': 'المدينة',
      'codePostal': 'الرمز البريدي',
      'instructionsLivraison': 'تعليمات التوصيل',
      'positionActuelle': 'الموقع الحالي',
      'voirSurCarte': 'عرض على الخريطة',
      'suiviCommande': 'تتبع الطلب',
      'enPreparation': 'قيد التحضير',
      'livreurEnRoute': 'المندوب في الطريق',
      'commandeLivree': 'تم التوصيل',
      'arriveePrevue': 'الوصول خلال 8 دقائق',
      'appeler': 'اتصال',
      'message': 'رسالة',
      'pourboire': 'بقشيش',
      'connexion': 'تسجيل الدخول',
      'inscription': 'إنشاء حساب',
      'motDePasse': 'كلمة السر',
      'confirmermotDePasse': 'تأكيد كلمة السر',
      'connecte': 'متصل',
      'bienvenueMessage': 'مرحباً بك في ديلي فيب',
      'total': 'المجموع',
      'commander': 'طلب',
      'panier': 'السلة',
      'livraison': 'التوصيل',
      'taxes': 'الضرائب',
      'sousTotal': 'المجموع الفرعي',
      'retrait': 'استلام',
      'min': 'دقيقة',
      'km': 'كم',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLanguages.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
