import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../data/address_provider.dart';
import '../widgets/responsive_helper.dart';

// ─── Address Type Enum ─────────────────────────────────
enum AddressType {
  maison('Maison', Icons.home_rounded),
  residence('Résidence', Icons.apartment_rounded),
  bureau('Bureau', Icons.business_rounded);

  final String label;
  final IconData icon;
  const AddressType(this.label, this.icon);
}

// ═══════════════════════════════════════════════════════════
//  ADD NEW ADDRESS SCREEN — Dynamic Glassmorphism Form
//  with full‑screen Mapbox map & centered pin
//  ⚡ Uber‑Eats / Glovo‑style interactive map picker
// ═══════════════════════════════════════════════════════════

class AddNewAddressScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const AddNewAddressScreen({super.key, this.initialLocation});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // ─── Mapbox Access Token ──────────────────────────────
  // Provide your Mapbox token via dart-define when running:
  //   flutter run --dart-define=MAPBOX_ACCESS_TOKEN=<YOUR_TOKEN>
  static const String _mapboxAccessToken = String.fromEnvironment(
    'MAPBOX_ACCESS_TOKEN',
    defaultValue: 'YOUR_MAPBOX_TOKEN_HERE',
  );

  // ─── Agadir, Morocco — default camera ─────────────────
  static const LatLng _agadirCenter = LatLng(30.4278, -9.5981);
  static const double _initialZoom = 14.0;

  // ─── Map Controller ───────────────────────────────────
  final MapController _mapController = MapController();

  // ─── Selected coordinates (map center) ────────────────
  LatLng _selectedLatLng = _agadirCenter;

  // ─── Loading states ───────────────────────────────────
  bool _isLocating = false;
  bool _isReversing = false;

  // ─── Pin bounce animation ─────────────────────────────
  late final AnimationController _pinAnimController;
  late final Animation<double> _pinBounceAnimation;

  // ─── Debounce timer for reverse geocoding ─────────────
  Timer? _reverseGeocodeTimer;

  // ─── Saving state ─────────────────────────────────────
  bool _isSaving = false;

  // ─── Address Type (determines which fields are shown) ──
  AddressType _addressType = AddressType.maison;

  // ─── Controllers ───────────────────────────────────────
  final _streetController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _doorController = TextEditingController();
  final _instructionsController = TextEditingController();

  // ─── Label ─────────────────────────────────────────────
  String _selectedLabel = 'Home';
  final List<String> _labels = ['Home', 'Work', 'Other'];

  // ─── Brand Colors ──────────────────────────────────────
  static const _teal = Color(0xFF39BCA8);
  static const _dark = Color(0xFF1E1E24);

  // ────────────────────────────────────────────────────────
  //  LIFE-CYCLE
  // ────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    // If an initial location was provided, use it
    if (widget.initialLocation != null) {
      _selectedLatLng = widget.initialLocation!;
    }

    // Pin bounce animation setup
    _pinAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pinBounceAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(parent: _pinAnimController, curve: Curves.easeOutBack),
    );

    // Pre-fetch address for the initial center
    _scheduleReverseGeocode();
  }

  @override
  void dispose() {
    _reverseGeocodeTimer?.cancel();
    _pinAnimController.dispose();
    _streetController.dispose();
    _houseNumberController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _doorController.dispose();
    _instructionsController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // ────────────────────────────────────────────────────────
  //  MAP EVENT HANDLER
  // ────────────────────────────────────────────────────────

  /// Called when a map event occurs (drag start, drag end, zoom…).
  void _onMapEvent(MapEvent event) {
    if (event is MapEventMoveStart) {
      // Pin gets a slight "pressed" feel when the user starts dragging
      _pinAnimController.reverse();
    } else if (event is MapEventMoveEnd) {
      _updateCenter();
      // Pin bounces up to signal the new location is registered
      _pinAnimController.forward();
    }
  }

  /// Reads the current map center and triggers reverse geocode.
  void _updateCenter() {
    final center = _mapController.camera.center;
    setState(() {
      _selectedLatLng = center;
    });
    _scheduleReverseGeocode();
  }

  // ────────────────────────────────────────────────────────
  //  REVERSE GEOCODING (Mapbox API)
  // ────────────────────────────────────────────────────────

  /// Schedules a reverse geocode call with a 600ms debounce
  /// so we don't spam the API while the user is still dragging.
  void _scheduleReverseGeocode() {
    _reverseGeocodeTimer?.cancel();
    _reverseGeocodeTimer = Timer(const Duration(milliseconds: 600), () {
      _fetchStreetName(_selectedLatLng);
    });
  }

  /// Calls Mapbox Geocoding API to get a human-readable street name.
  Future<void> _fetchStreetName(LatLng latLng) async {
    if (_isReversing) return;
    setState(() => _isReversing = true);

    try {
      final url = Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/'
        '${latLng.longitude},${latLng.latitude}.json'
        '?access_token=$_mapboxAccessToken'
        '&types=address,locality,place,neighborhood,poi'
        '&language=fr'
        '&limit=1',
      );

      final response = await http.get(url);
      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final features = data['features'] as List<dynamic>?;

      if (features == null || features.isEmpty) return;

      // Try to get the best human-readable address
      final first = features.first as Map<String, dynamic>;
      final placeName = first['place_name'] as String?;

      if (placeName != null && placeName.isNotEmpty) {
        // place_name format is usually "street, city, region, country"
        // We extract just the first part (street / area name)
        final parts = placeName.split(',');
        final streetPart = parts.first.trim();

        // Only update if the field is empty or this is an auto-fill
        if (_streetController.text.isEmpty ||
            _streetController.text == 'Chargement...') {
          _streetController.text = streetPart;
        }
      }
    } catch (_) {
      // Silently fail – the user can type the address manually
    } finally {
      if (mounted) setState(() => _isReversing = false);
    }
  }

  // ────────────────────────────────────────────────────────
  //  LOCATE ME — GPS avec animation fluide
  // ────────────────────────────────────────────────────────

  Future<void> _locateMe() async {
    setState(() => _isLocating = true);

    try {
      // Check / request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Veuillez autoriser la localisation dans les paramètres',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        setState(() => _isLocating = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      );

      final userLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _selectedLatLng = userLocation;
      });

      // Move to the user location
      _mapController.move(userLocation, _initialZoom);

      // Bounce the pin to signal success
      _pinAnimController.forward();

      // Schedule reverse geocode after the map has settled
      Future.delayed(const Duration(milliseconds: 500), () {
        _scheduleReverseGeocode();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible d\'obtenir votre position'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  // ────────────────────────────────────────────────────────
  //  BUILDERS
  // ────────────────────────────────────────────────────────

  // ─── Builds a single glassmorphism text field ──────────
  Widget _buildGlassField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _dark,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: _dark, fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: _dark.withValues(alpha: 0.35),
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _teal, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  /// Returns the list of dynamic extra fields based on [_addressType].
  List<Widget> _buildDynamicFields() {
    switch (_addressType) {
      case AddressType.maison:
        return [
          _buildGlassField(
            label: 'Numéro de maison',
            controller: _houseNumberController,
            hintText: 'ex: 24',
            keyboardType: TextInputType.text,
          ),
        ];

      case AddressType.residence:
        return [
          _buildGlassField(
            label: 'Nom de la résidence',
            controller: _buildingController,
            hintText: 'ex: Riad Sakane, Hay Salam',
          ),
          Row(
            children: [
              Expanded(
                child: _buildGlassField(
                  label: 'Étage',
                  controller: _floorController,
                  hintText: 'ex: 3e',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGlassField(
                  label: 'Appartement',
                  controller: _apartmentController,
                  hintText: 'ex: 12',
                ),
              ),
            ],
          ),
        ];

      case AddressType.bureau:
        return [
          _buildGlassField(
            label: 'Immeuble / Bâtiment',
            controller: _buildingController,
            hintText: 'ex: Immeuble ABC',
          ),
          Row(
            children: [
              Expanded(
                child: _buildGlassField(
                  label: 'Étage',
                  controller: _floorController,
                  hintText: 'ex: 5e',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGlassField(
                  label: 'Numéro de porte / bureau',
                  controller: _doorController,
                  hintText: 'ex: 502',
                ),
              ),
            ],
          ),
        ];
    }
  }

  /// Saves the address globally, shows loading, then pops.
  Future<void> _saveAddress() async {
    // ─── 1. Validate the form ──────────────────────────
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // ─── 2. Extra check on street (double safety) ─────
    final street = _streetController.text.trim();
    if (street.isEmpty) {
      _showSnackBar(
        message: 'Veuillez remplir le nom de la rue/quartier',
        isError: true,
      );
      return;
    }

    // ─── 3. Show loading on button ─────────────────────
    setState(() => _isSaving = true);

    // ─── 4. Build address data from all form fields ────
    final addressString = street;
    final instructions = _instructionsController.text.trim();

    // Build a complete address string with details
    String detailSuffix = '';
    switch (_addressType) {
      case AddressType.maison:
        final houseNo = _houseNumberController.text.trim();
        if (houseNo.isNotEmpty) detailSuffix = ', N° $houseNo';
        break;
      case AddressType.residence:
        final building = _buildingController.text.trim();
        final floor = _floorController.text.trim();
        final apt = _apartmentController.text.trim();
        if (building.isNotEmpty) detailSuffix += ', $building';
        if (floor.isNotEmpty) detailSuffix += ', Étage $floor';
        if (apt.isNotEmpty) detailSuffix += ', Appt $apt';
        break;
      case AddressType.bureau:
        final building = _buildingController.text.trim();
        final floor = _floorController.text.trim();
        final door = _doorController.text.trim();
        if (building.isNotEmpty) detailSuffix += ', $building';
        if (floor.isNotEmpty) detailSuffix += ', Étage $floor';
        if (door.isNotEmpty) detailSuffix += ', Bureau $door';
        break;
    }

    // ─── 5. Save to global AddressProvider ─────────────
    final addressProvider = context.read<AddressProvider>();
    await addressProvider.setAddress(
      DeliveryAddress(
        streetName: '$addressString$detailSuffix',
        addressType: _addressType.label,
        label: _selectedLabel,
        latitude: _selectedLatLng.latitude,
        longitude: _selectedLatLng.longitude,
        instructions: instructions,
      ),
    );

    // ─── 6. Short delay for VIP feel ───────────────────
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isSaving = false);

    // ─── 7. Show success snackbar then pop ─────────────
    _showSnackBar(message: 'Adresse enregistrée avec succès !', isError: false);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pop(context);
    }
  }

  /// Premium SnackBar — glassmorphism style with error / success colors.
  void _showSnackBar({required String message, required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError
            ? const Color(0xFFE53935) // Red error
            : const Color(0xFF39BCA8), // Brand teal success
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: Duration(seconds: isError ? 3 : 2),
        elevation: 6,
      ),
    );
  }

  // ─── Bottom Glassmorphism Form ─────────────────────────
  Widget _buildBottomForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: ResponsiveHelper.constrainWidth(
        context,
        Form(
          key: _formKey,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ═════════════════════════════════════
                    //  TYPE D'ADRESSE — Choice Chips
                    // ═════════════════════════════════════
                    Text(
                      "Type d'adresse",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: AddressType.values.map((type) {
                        final isSelected = _addressType == type;
                        return ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                type.icon,
                                size: 18,
                                color: isSelected ? Colors.white : _teal,
                              ),
                              const SizedBox(width: 6),
                              Text(type.label),
                            ],
                          ),
                          selected: isSelected,
                          selectedColor: _teal,
                          backgroundColor: Colors.white.withValues(alpha: 0.5),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : _dark,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? _teal
                                : Colors.white.withValues(alpha: 0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _addressType = type);
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // ═════════════════════════════════════
                    //  STREET / AREA — Toujours visible
                    // ═════════════════════════════════════
                    _buildGlassField(
                      label: 'Rue / Quartier',
                      controller: _streetController,
                      hintText: 'ex: Hay Salam, Rue 4',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez entrer une rue ou un quartier';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // ═════════════════════════════════════
                    //  DYNAMIC FIELDS — Animé + Conditionnel
                    // ═════════════════════════════════════
                    AnimatedSize(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOutCubic,
                      alignment: Alignment.topCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Separator label
                          Text(
                            _addressType == AddressType.maison
                                ? 'Détails maison'
                                : _addressType == AddressType.residence
                                ? 'Détails résidence'
                                : 'Détails bureau',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _dark,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Key-based AnimatedSwitcher for smooth cross-fade
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SizeTransition(
                                  sizeFactor: animation,
                                  alignment: Alignment.topCenter,
                                  child: child,
                                ),
                              );
                            },
                            child: Column(
                              key: ValueKey(_addressType),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [..._buildDynamicFields()],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ═════════════════════════════════════
                    //  DELIVERY INSTRUCTIONS
                    // ═════════════════════════════════════
                    _buildGlassField(
                      label: 'Instructions pour le livreur (ex: ne pas sonner)',
                      controller: _instructionsController,
                      hintText: 'ex: Sonner deux fois, laisser devant la porte',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

                    // ═════════════════════════════════════
                    //  LABEL — Étiquette d'adresse
                    // ═════════════════════════════════════
                    Text(
                      'Étiqueter cette adresse',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: _labels.map((label) {
                        final isSelected = _selectedLabel == label;
                        return ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                label == 'Home'
                                    ? Icons.home_outlined
                                    : label == 'Work'
                                    ? Icons.work_outline
                                    : Icons.place_outlined,
                                size: 18,
                                color: isSelected ? Colors.white : _teal,
                              ),
                              const SizedBox(width: 6),
                              Text(label),
                            ],
                          ),
                          selected: isSelected,
                          selectedColor: _teal,
                          backgroundColor: Colors.white.withValues(alpha: 0.5),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : _dark,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? _teal
                                : Colors.white.withValues(alpha: 0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedLabel = label);
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),

                    // ═════════════════════════════════════
                    //  SAVE BUTTON
                    // ═════════════════════════════════════
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _teal,
                          disabledBackgroundColor: _teal.withValues(alpha: 0.7),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                "Enregistrer l'adresse",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Ajouter une adresse',
          style: TextStyle(
            color: _dark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ─── 1. Full‑screen Mapbox Map ─────────────
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _selectedLatLng,
                initialZoom: _initialZoom,
                onMapEvent: _onMapEvent,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}?access_token=$_mapboxAccessToken',
                  userAgentPackageName: 'com.delivip.app',
                ),
              ],
            ),
          ),

          // ─── 2. Pin centré visuellement au-dessus du bottom sheet ─
          //     On utilise Align avec un offset négatif pour placer
          //     le pin dans la zone visible de la carte (hors formulaire)
          Align(
            alignment: Alignment(0.0, -0.4),
            child: AnimatedBuilder(
              animation: _pinBounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _pinBounceAnimation.value),
                  child: child,
                );
              },
              child: _buildMapPin(),
            ),
          ),

          // ─── 3. "Locate Me" floating button ─────────
          Positioned(right: 16, bottom: 360, child: _buildLocateMeButton()),

          // ─── 4. Coordinate indicator badge ──────────
          Positioned(
            left: 16,
            top: MediaQuery.of(context).padding.top + 60,
            child: _buildCoordinateBadge(),
          ),

          // ─── 5. Bottom glassmorphism form ──────────
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomForm(context),
          ),
        ],
      ),
    );
  }

  /// Premium map pin with shadow, glow ring, and the brand color.
  Widget _buildMapPin() {
    return SizedBox(
      width: 52,
      height: 68,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Glow ring — centered at the bottom of the pin
          Positioned(
            left: 15,
            top: 46,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _teal.withValues(alpha: 0.2),
                border: Border.all(
                  color: _teal.withValues(alpha: 0.5),
                  width: 3,
                ),
              ),
            ),
          ),
          // Drop shadow for the pin icon
          const Positioned(
            left: 0,
            top: 0,
            child: Icon(
              Icons.location_on,
              color: _teal,
              size: 52,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tiny badge showing current coordinates (for power‑users / debugging).
  Widget _buildCoordinateBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.gps_fixed,
            size: 14,
            color: Colors.white.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 6),
          Text(
            '${_selectedLatLng.latitude.toStringAsFixed(5)}, '
            '${_selectedLatLng.longitude.toStringAsFixed(5)}',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Floating glassy "Locate Me" button — Uber‑Eats style.
  Widget _buildLocateMeButton() {
    return Material(
      elevation: 8,
      shape: const CircleBorder(),
      color: Colors.transparent,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _isLocating ? null : _locateMe,
          child: Center(
            child: _isLocating
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(_teal),
                    ),
                  )
                : Icon(Icons.my_location_rounded, color: _dark, size: 26),
          ),
        ),
      ),
    );
  }
}
