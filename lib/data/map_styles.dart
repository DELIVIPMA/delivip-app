import 'package:flutter_map/flutter_map.dart';

// ═══════════════════════════════════════════════════════════════════
//  MAP STYLES — DeliVip
//  Style Uber Eats / clean high-contrast look
// ═══════════════════════════════════════════════════════════════════

/// Google Maps JSON style array — Uber Eats inspired.
/// Ultra-clean, high-contrast, muted pastel palette.
///
/// 🟫 Land / Background : #F3F3F3
/// ⬜ Roads              : #FFFFFF with thin #E0E0E0 borders
/// 🌊 Water              : #D4DAE0 (pale muted gray-blue)
/// 🌿 Parks / Green      : #E2EDE4 (soft muted pale green)
/// 🏷️ Street labels      : #757575 dark gray only
/// ❌ POIs, transit, businesses: all hidden
///
/// Usage with google_maps_flutter:
///   final controller = await mapController.future;
///   controller.setMapStyle(kUberEatsMapStyle);
const String kUberEatsMapStyle = '''[
  {
    "elementType": "geometry",
    "stylers": [
      { "color": "#f3f3f3" }
    ]
  },
  {
    "elementType": "geometry.stroke",
    "stylers": [
      { "color": "#f3f3f3" }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      { "color": "#d4dae0" }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry.stroke",
    "stylers": [
      { "color": "#d4dae0" }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      { "visibility": "off" }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      { "color": "#e2ede4" }
    ]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry",
    "stylers": [
      { "color": "#f3f3f3" }
    ]
  },
  {
    "featureType": "poi",
    "stylers": [
      { "visibility": "off" }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      { "color": "#e2ede4" },
      { "visibility": "on" }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      { "color": "#ffffff" }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [
      { "color": "#e0e0e0" },
      { "weight": 1 }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#757575" }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      { "visibility": "off" }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.fill",
    "stylers": [
      { "color": "#ffffff" }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      { "color": "#d6d6d6" },
      { "weight": 1 }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#757575" }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry.fill",
    "stylers": [
      { "color": "#ffffff" }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry.stroke",
    "stylers": [
      { "color": "#e0e0e0" },
      { "weight": 1 }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#757575" }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "geometry.fill",
    "stylers": [
      { "color": "#ffffff" }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "geometry.stroke",
    "stylers": [
      { "color": "#e8e8e8" },
      { "weight": 1 }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#757575" }
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      { "visibility": "off" }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      { "color": "#e0e0e0" },
      { "weight": 1 },
      { "visibility": "on" }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "labels.text.fill",
    "stylers": [
      { "visibility": "off" }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#9e9e9e" },
      { "visibility": "on" }
    ]
  },
  {
    "featureType": "administrative.neighborhood",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#9e9e9e" },
      { "visibility": "on" }
    ]
  }
]''';

// ═══════════════════════════════════════════════════════════════════
//  FLUTTER_MAP (OpenStreetMap) — Uber Eats style tile configuration
//  Uses CartoDB Positron light tiles for the clean Uber Eats look.
// ═══════════════════════════════════════════════════════════════════

/// Default tile server that gives a clean, light map (CartoDB Positron).
/// This is the exact look Uber Eats uses — clean, minimal, high-contrast.
const String kUberEatsTileUrl =
    'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';

/// Fallback tile server (OpenStreetMap standard).
const String kFallbackTileUrl =
    'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

/// Subdomains for CartoDB tile server.
const List<String> kCartoDbSubdomains = ['a', 'b', 'c', 'd'];

/// Creates a [TileLayer] configured with the Uber Eats inspired style
/// for use with flutter_map.
///
/// Uses **CartoDB Positron** tiles — the same light, clean base map
/// that gives the Uber Eats aesthetic (white roads, light gray land,
/// muted water).
///
/// Features:
/// - CartoDB Positron light tiles (clean, minimal base)
/// - Fallback to OSM tiles if CartoDB fails
TileLayer buildUberEatsTileLayer({
  required String userAgentPackageName,
  bool useRetinaTiles = false,
}) {
  final tileUrl = useRetinaTiles
      ? 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}@2x.png'
      : kUberEatsTileUrl;

  return TileLayer(
    urlTemplate: tileUrl,
    subdomains: kCartoDbSubdomains,
    userAgentPackageName: userAgentPackageName,
    // Fallback to OSM tiles if CartoDB tiles fail to load
    fallbackUrl: kFallbackTileUrl,
  );
}
