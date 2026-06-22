import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../data/map_styles.dart';
import '../data/api_config.dart';

// ═══════════════════════════════════════════════════════════════════
//  CHANGE ADDRESS SCREEN — DeliVip Adresse de livraison
// ═══════════════════════════════════════════════════════════════════

class ChangeAddressScreen extends StatefulWidget {
  const ChangeAddressScreen({super.key});

  @override
  State<ChangeAddressScreen> createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  // Agadir, Maroc coordinates
  LatLng _markerPosition = const LatLng(30.427755, -9.598107);
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  final List<_RecentAddress> _recentAddresses = [
    _RecentAddress(
      name: 'Agadir Marina',
      city: 'Agadir, Maroc',
      isSelected: true,
    ),
    _RecentAddress(
      name: 'Hay Mohammadi',
      city: 'Agadir, Maroc',
      isSelected: false,
    ),
  ];

  // Autocomplete state
  List<_SearchSuggestion> _suggestions = [];
  bool _isSearching = false;
  bool _showSuggestions = false;

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // ── Recherche d'adresse (Google Places ou Nominatim) ────────────
  Future<void> _searchAddress(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      // ✅ Utilise Google Places si la clé API est configurée
      if (ApiConfig.googleApiKey != 'VOTRE_CLE_API_GOOGLE_ICI') {
        await _searchWithGooglePlaces(query);
      } else {
        // ⬇️ Fallback: Nominatim (OpenStreetMap) gratuit
        await _searchWithNominatim(query);
      }
    } catch (e) {
      // Silencieux - les suggestions ne s'affichent juste pas
    } finally {
      setState(() => _isSearching = false);
    }
  }

  /// Recherche via Google Places API (nécessite une clé API)
  Future<void> _searchWithGooglePlaces(String query) async {
    // Étape 1: Autocomplete via Places API
    final autocompleteUrl = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
      '?input=${Uri.encodeComponent(query)}'
      '&types=address'
      '&components=country:ma'
      '&language=fr'
      '&key=${ApiConfig.googleApiKey}',
    );

    final autoResponse = await http.get(autocompleteUrl);
    if (autoResponse.statusCode != 200) return;

    final autoData = json.decode(autoResponse.body);
    final predictions = autoData['predictions'] as List? ?? [];

    if (predictions.isEmpty) return;

    // Limiter à 5 résultats
    final limited = predictions.take(5).toList();

    // Étape 2: Geocoding pour chaque prédiction (description → lat/lng)
    final suggestions = <_SearchSuggestion>[];
    for (final prediction in limited) {
      final placeId = prediction['place_id'] ?? '';
      final description = prediction['description'] ?? '';

      if (placeId.isNotEmpty) {
        final geocodeUrl = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json'
          '?place_id=$placeId'
          '&language=fr'
          '&key=${ApiConfig.googleApiKey}',
        );

        final geoResponse = await http.get(geocodeUrl);
        if (geoResponse.statusCode == 200) {
          final geoData = json.decode(geoResponse.body);
          final results = geoData['results'] as List? ?? [];
          if (results.isNotEmpty) {
            final location = results[0]['geometry']['location'];
            suggestions.add(
              _SearchSuggestion(
                displayName: description,
                lat: (location['lat'] as num).toDouble(),
                lon: (location['lng'] as num).toDouble(),
              ),
            );
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _suggestions = suggestions;
        _showSuggestions = _suggestions.isNotEmpty;
      });
    }
  }

  /// Recherche via Nominatim (OpenStreetMap) — fallback gratuit
  Future<void> _searchWithNominatim(String query) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?q=${Uri.encodeComponent(query)}'
      '&format=json&limit=5&countrycodes=ma',
    );

    final response = await http.get(
      url,
      headers: {'User-Agent': 'DelivipApp/1.0'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (mounted) {
        setState(() {
          _suggestions = data
              .map(
                (item) => _SearchSuggestion(
                  displayName: item['display_name'] ?? '',
                  lat: double.parse(item['lat'] ?? '0'),
                  lon: double.parse(item['lon'] ?? '0'),
                ),
              )
              .toList();
          _showSuggestions = _suggestions.isNotEmpty;
        });
      }
    }
  }

  void _selectSuggestion(_SearchSuggestion suggestion) {
    setState(() {
      _markerPosition = LatLng(suggestion.lat, suggestion.lon);
      _searchController.text = suggestion.displayName.split(',')[0];
      _showSuggestions = false;
      _suggestions = [];
    });
    _mapController.move(_markerPosition, 16.0);
  }

  void _selectAddress(int index) {
    setState(() {
      for (int i = 0; i < _recentAddresses.length; i++) {
        _recentAddresses[i] = _RecentAddress(
          name: _recentAddresses[i].name,
          city: _recentAddresses[i].city,
          isSelected: i == index,
        );
      }
    });
    Navigator.of(context).pop();
  }

  void _editAddress(int index) {
    final address = _recentAddresses[index];
    final nameController = TextEditingController(text: address.name);
    final cityController = TextEditingController(text: address.city);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Modifier l\'adresse',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nom de l\'adresse',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'Ville',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BFA5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _recentAddresses[index] = _RecentAddress(
                        name: nameController.text.trim(),
                        city: cityController.text.trim(),
                        isSelected: _recentAddresses[index].isSelected,
                      );
                    });
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Adresse modifiée'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text(
                    'Enregistrer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteAddress(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer l\'adresse'),
        content: Text(
          'Voulez-vous vraiment supprimer "${_recentAddresses[index].name}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _recentAddresses.removeAt(index);
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🗑️ Adresse supprimée'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  Future<void> _activateCurrentLocation() async {
    try {
      // Check if location services are enabled
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Veuillez activer la localisation dans les paramètres',
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      // Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Permission de localisation refusée'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Permission de localisation refusée définitivement. Modifiez les paramètres.',
              ),
              duration: Duration(seconds: 4),
            ),
          );
        }
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      if (!mounted) return;

      // Update marker and center map
      setState(() {
        _markerPosition = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_markerPosition, 16.0);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📍 Localisation activée'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de localisation: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ═══ Custom Top Bar ═══════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Détails de la commande',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEBEDF0)),

            // ═══ MAP (OpenStreetMap) ══════════════════════════
            SizedBox(
              height: 260,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _markerPosition,
                      initialZoom: 14.0,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                      onTap: (tapPosition, point) {
                        setState(() {
                          _markerPosition = point;
                        });
                      },
                    ),
                    children: [
                      // Uber Eats inspired map style:
                      // Clean CartoDB Positron tiles + color filter
                      buildUberEatsTileLayer(
                        userAgentPackageName: 'com.delivip.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _markerPosition,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_on,
                              color: Color(0xFF00BFA5),
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Position indicator on map
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.my_location,
                            size: 14,
                            color: Color(0xFF00BFA5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_markerPosition.latitude.toStringAsFixed(4)}, ${_markerPosition.longitude.toStringAsFixed(4)}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Tap hint
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Appuyez sur la carte pour positionner',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ═══ Scrollable content below map ═════════════════
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Time Row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 20,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Livrer maintenant',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Planification de livraison'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Planifier',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFEBEDF0),
                    ),

                    // ═══ Search Bar with Autocomplete ═══════════
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.search,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (value) {
                                      _searchAddress(value);
                                    },
                                    decoration: InputDecoration(
                                      hintText:
                                          'Entrer une nouvelle adresse...',
                                      hintStyle: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                    ),
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                if (_isSearching)
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Suggestions dropdown
                          if (_showSuggestions)
                            Container(
                              constraints: const BoxConstraints(maxHeight: 200),
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: _suggestions.length,
                                separatorBuilder: (_, _) => const Divider(
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                itemBuilder: (context, index) {
                                  final suggestion = _suggestions[index];
                                  final parts = suggestion.displayName.split(
                                    ',',
                                  );
                                  final name = parts.isNotEmpty
                                      ? parts[0].trim()
                                      : '';
                                  final rest = parts.length > 1
                                      ? parts.sublist(1).join(',').trim()
                                      : '';

                                  return ListTile(
                                    dense: true,
                                    leading: const Icon(
                                      Icons.location_on_outlined,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    title: Text(
                                      name,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: rest.isNotEmpty
                                        ? Text(
                                            rest,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : null,
                                    onTap: () => _selectSuggestion(suggestion),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Section: "À proximité"
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Text(
                        'À proximité',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF888888),
                        ),
                      ),
                    ),

                    // Current Location Row
                    GestureDetector(
                      onTap: _activateCurrentLocation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.arrow_forward,
                              size: 22,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'Localisation actuelle',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Activer',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                      color: Color(0xFFF0F1F3),
                    ),

                    // Section: "Adresses récentes"
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Text(
                        'Adresses récentes',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF888888),
                        ),
                      ),
                    ),

                    // Recent Address List
                    ..._recentAddresses.asMap().entries.map(
                      (entry) => _RecentAddressRow(
                        address: entry.value,
                        onTap: () => _selectAddress(entry.key),
                        onEdit: () => _editAddress(entry.key),
                        onDelete: () => _deleteAddress(entry.key),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Recent Address Row Widget
// ═══════════════════════════════════════════════════════════════════

class _RecentAddressRow extends StatelessWidget {
  final _RecentAddress address;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RecentAddressRow({
    required this.address,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: address.isSelected ? const Color(0xFFF5F5F5) : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              GestureDetector(
                onTap: onTap,
                child: const Icon(
                  Icons.location_on_outlined,
                  size: 22,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.name,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        address.city,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Edit button
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Delete button
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
          color: Color(0xFFF0F1F3),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  Data Models
// ═══════════════════════════════════════════════════════════════════

class _RecentAddress {
  final String name;
  final String city;
  final bool isSelected;

  const _RecentAddress({
    required this.name,
    required this.city,
    required this.isSelected,
  });
}

class _SearchSuggestion {
  final String displayName;
  final double lat;
  final double lon;

  const _SearchSuggestion({
    required this.displayName,
    required this.lat,
    required this.lon,
  });
}
