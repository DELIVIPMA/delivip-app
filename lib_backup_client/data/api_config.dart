// ═══════════════════════════════════════════════════════════════════
//  API CONFIG — DeliVip
//  Google Services Configuration
// ═══════════════════════════════════════════════════════════════════

/// Classe de configuration centralisée pour les APIs Google.
///
/// ⚠️ Pour obtenir une clé API Google :
///
/// 1️⃣ Allez sur https://console.cloud.google.com/
/// 2️⃣ Créez un nouveau projet (ou sélectionnez un projet existant)
/// 3️⃣ Allez dans "APIs & Services" > "Library"
/// 4️⃣ Activez les APIs suivantes :
///    - Places API
///    - Geocoding API
///    - Maps JavaScript API
/// 5️⃣ Allez dans "APIs & Services" > "Credentials"
/// 6️⃣ Créez une clé API ("Create Credentials" > "API Key")
/// 7️⃣ (Recommandé) Restreignez la clé :
///    - Sous "Application restrictions" > "HTTP referrers"
///    - Ajoutez votre domaine (ex: *.delivip.ma, localhost)
///    - Sous "API restrictions" > "Restrict key" > sélectionnez les 3 APIs
///
/// 📝 Collez votre clé ci-dessous :
class ApiConfig {
  // ═══════════════════════════════════════════════════════════════
  //  🔑 Remplacez par VOTRE clé API Google
  // ═══════════════════════════════════════════════════════════════
  static const String googleApiKey = 'VOTRE_CLE_API_GOOGLE_ICI';

  // ═══════════════════════════════════════════════════════════════
  //  URLs des services Google
  // ═══════════════════════════════════════════════════════════════

  /// Google Places Autocomplete API
  static String get placesAutocompleteUrl => Uri.parse(
    'https://maps.googleapis.com/maps/api/place/autocomplete/json',
  ).replace(queryParameters: {
    'key': googleApiKey,
    'types': 'address',
    'components': 'country:ma', // Maroc
    'language': 'fr',
  }).toString();

  /// Google Geocoding API (lat/lng → adresse)
  static String geocodeUrl(double lat, double lng) => Uri.parse(
    'https://maps.googleapis.com/maps/api/geocode/json',
  ).replace(queryParameters: {
    'key': googleApiKey,
    'latlng': '$lat,$lng',
    'language': 'fr',
  }).toString();

  /// Google Geocoding API (adresse → lat/lng)
  static String get geocodeByAddressUrl => Uri.parse(
    'https://maps.googleapis.com/maps/api/geocode/json',
  ).replace(queryParameters: {
    'key': googleApiKey,
    'language': 'fr',
    'components': 'country:MA',
  }).toString();
}
