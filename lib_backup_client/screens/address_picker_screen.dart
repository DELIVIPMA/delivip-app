import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import '../models/address.dart';

class AddressPickerScreen extends StatefulWidget {
  const AddressPickerScreen({super.key});

  @override
  State<AddressPickerScreen> createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends State<AddressPickerScreen>
    with TickerProviderStateMixin {
  // Map
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(30.4278, -9.5981); // Agadir
  LatLng _lastMovedCenter = const LatLng(30.4278, -9.5981);
  String _addressText = '';

  // Form
  final _residenceCtrl = TextEditingController();
  final _buildingCtrl = TextEditingController();
  final _floorCtrl = TextEditingController();
  final _apartmentCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _customLabelCtrl = TextEditingController();

  // Chips state
  final Set<String> _selectedInstructions = {};
  String? _addressLabel;
  bool _showCustomLabel = false;

  // Animation
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isLoadingAddress = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _fetchCurrentLocation();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _residenceCtrl.dispose();
    _buildingCtrl.dispose();
    _floorCtrl.dispose();
    _apartmentCtrl.dispose();
    _noteCtrl.dispose();
    _customLabelCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 50,
        ),
      );
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_center, 15.0);
      _reverseGeocode(_center);
    } catch (e) {
      // Fallback à Agadir si pas de GPS
      _reverseGeocode(_center);
    }
  }

  Future<void> _reverseGeocode(LatLng latLng) async {
    if (_isLoadingAddress) return;
    setState(() => _isLoadingAddress = true);

    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=${latLng.latitude}&lon=${latLng.longitude}'
        '&format=json&addressdetails=1&accept-language=fr',
      );
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'DelivipApp/1.0'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final displayName = data['display_name'] as String? ?? '';
        setState(() => _addressText = displayName);
      } else {
        setState(
          () => _addressText =
              '${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}',
        );
      }
    } catch (e) {
      setState(
        () => _addressText =
            '${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}',
      );
    } finally {
      setState(() => _isLoadingAddress = false);
    }
  }

  void _onMapMoved() {
    try {
      final center = _mapController.camera.center;
      // Éviter les appels redondants (boucle de rebuild)
      if (center == _lastMovedCenter) return;
      _lastMovedCenter = center;
      setState(() => _center = center);
      _reverseGeocode(center);
    } catch (e) {
      // Camera pas encore prête
    }
  }

  Future<void> _goToMyLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final loc = LatLng(position.latitude, position.longitude);
      _mapController.move(loc, 15.0);
      _reverseGeocode(loc);
    } catch (e) {
      // Ignorer
    }
  }

  bool get _isFormValid {
    return _addressText.isNotEmpty && _residenceCtrl.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // MAP — fixed height, no Expanded
          SizedBox(height: 300, child: _buildMapSection()),
          // FORM — scrollable
          Expanded(child: _buildFormSection()),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      child: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 15.0,
              onMapEvent: (event) {
                if (event is MapEventMoveEnd) _onMapMoved();
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.delivip.app',
              ),
            ],
          ),
          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 4,
            left: 12,
            child: Material(
              color: Colors.white,
              elevation: 2,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.close, size: 20, color: Colors.black87),
                ),
              ),
            ),
          ),
          // Center pin with pulse
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pulse ring
                    Container(
                      width: 40 * _pulseAnimation.value,
                      height: 40 * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(
                          0xFF1AA49B,
                        ).withValues(alpha: 0.15 * _pulseAnimation.value),
                      ),
                    ),
                    const SizedBox(height: -4),
                    // Pin icon
                    Icon(
                      Icons.location_on,
                      size: 36,
                      color: const Color(0xFF1AA49B),
                      shadows: const [
                        Shadow(blurRadius: 8, color: Colors.black26),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          // Locate me button
          Positioned(
            bottom: 16,
            right: 16,
            child: Material(
              color: Colors.white,
              elevation: 3,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _goToMyLocation,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.my_location,
                    size: 22,
                    color: Color(0xFF1AA49B),
                  ),
                ),
              ),
            ),
          ),
          // Loading indicator
          if (_isLoadingAddress)
            Positioned(
              top: MediaQuery.of(context).padding.top + 52,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF1AA49B),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Localisation...',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAddressSection(),
                  const SizedBox(height: 20),
                  _buildDetailsSection(),
                  const SizedBox(height: 20),
                  _buildInstructionsSection(),
                  const SizedBox(height: 20),
                  _buildLabelSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  // ─── Section 1: Votre adresse ───
  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Votre adresse',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // Focus back to map
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: Color(0xFF9E9E9E),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _addressText.isNotEmpty
                        ? _addressText
                        : 'Adresse non définie',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: _addressText.isNotEmpty
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFF9E9E9E),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.location_on,
                  size: 18,
                  color: Color(0xFF1AA49B),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Section 2: Détails de l'adresse ───
  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Détails de l\'adresse',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDetailField(
                controller: _residenceCtrl,
                icon: Icons.business,
                hint: 'Résidence, quartier...',
              ),
              _buildDivider(),
              _buildDetailField(
                controller: _buildingCtrl,
                icon: Icons.domain,
                hint: 'Nom de l\'immeuble ou villa',
              ),
              _buildDivider(),
              _buildDetailField(
                controller: _floorCtrl,
                icon: Icons.stairs,
                hint: 'Étage (ex: 3ème étage)',
                keyboardType: TextInputType.number,
              ),
              _buildDivider(),
              _buildDetailField(
                controller: _apartmentCtrl,
                icon: Icons.door_front_door,
                hint: 'N° appartement ou villa',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20, color: const Color(0xFF1AA49B)),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1AA49B), width: 2),
          ),
        ),
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 0.5, color: Color(0xFFEEEEEE));
  }

  // ─── Section 3: Instructions de livraison ───
  Widget _buildInstructionsSection() {
    const instructions = [
      {'emoji': '🔔', 'label': 'Ne pas sonner', 'key': 'nosonner'},
      {'emoji': '📦', 'label': 'Laisser à la porte', 'key': 'porte'},
      {'emoji': '📞', 'label': 'Appeler à l\'arrivée', 'key': 'appeler'},
      {'emoji': '🏃', 'label': 'Livraison rapide', 'key': 'rapide'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Instructions de livraison',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Instructions pour le livreur',
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: instructions.map((item) {
              final key = item['key'] as String;
              final selected = _selectedInstructions.contains(key);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _selectedInstructions.remove(key);
                      } else {
                        _selectedInstructions.add(key);
                      }
                    });
                  },
                  child: AnimatedScale(
                    scale: selected ? 0.95 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF1AA49B)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF1AA49B)
                              : const Color(0xFFDDDDDD),
                        ),
                      ),
                      child: Text(
                        '${item['emoji']} ${item['label']}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF6B6B6B),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _noteCtrl,
          maxLines: 3,
          maxLength: 150,
          decoration: InputDecoration(
            hintText: 'Note pour le livreur (optionnel)...',
            hintStyle: const TextStyle(fontSize: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFFF6F6F6),
            contentPadding: const EdgeInsets.all(14),
            counterStyle: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9E9E9E),
            ),
          ),
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  // ─── Section 4: Nom de l'adresse ───
  Widget _buildLabelSection() {
    const labels = [
      {'emoji': '🏠', 'label': 'Domicile', 'key': 'Domicile'},
      {'emoji': '💼', 'label': 'Travail', 'key': 'Travail'},
      {'emoji': '⭐', 'label': 'Autre', 'key': 'Autre'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nom de l\'adresse',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: labels.map((item) {
            final key = item['key'] as String;
            final selected = _addressLabel == key;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _addressLabel = key;
                    _showCustomLabel = key == 'Autre';
                    if (!_showCustomLabel) _customLabelCtrl.clear();
                  });
                },
                child: AnimatedScale(
                  scale: selected ? 0.95 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF1AA49B) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF1AA49B)
                            : const Color(0xFFDDDDDD),
                      ),
                    ),
                    child: Text(
                      '${item['emoji']} ${item['label']}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: selected
                            ? Colors.white
                            : const Color(0xFF6B6B6B),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: _showCustomLabel
              ? Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextField(
                    controller: _customLabelCtrl,
                    decoration: InputDecoration(
                      hintText: 'Nom personnalisé...',
                      hintStyle: const TextStyle(fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF6F6F6),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                    style: const TextStyle(fontSize: 13),
                    onChanged: (_) => setState(() {}),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  // ─── Confirm Button ───
  Widget _buildConfirmButton() {
    final enabled = _isFormValid;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: enabled ? _confirmAddress : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1AA49B),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFFBDBDBD),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Confirmer l\'adresse',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  void _confirmAddress() {
    final label = _addressLabel == 'Autre'
        ? (_customLabelCtrl.text.trim().isNotEmpty
              ? _customLabelCtrl.text.trim()
              : 'Autre')
        : (_addressLabel ?? 'Domicile');

    final address = DeliveryAddress(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: label,
      street: _addressText,
      city: '',
      residence: _residenceCtrl.text.trim(),
      buildingNumber: _buildingCtrl.text.trim(),
      floor: _floorCtrl.text.trim(),
      apartment: _apartmentCtrl.text.trim(),
      instructions: _noteCtrl.text.trim().isNotEmpty
          ? _noteCtrl.text.trim()
          : (_selectedInstructions.isNotEmpty
                ? _selectedInstructions.join(', ')
                : null),
      latitude: _center.latitude,
      longitude: _center.longitude,
      isDefault: false,
    );

    Navigator.pop(context, address);
  }
}
