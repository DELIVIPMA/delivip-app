import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../models/app_state.dart';

/// Écran de sélection d'adresse avec carte interactive
/// Pin centré fixe – l'utilisateur glisse la carte pour positionner
/// Info window blanche au-dessus du pin
class AddressesScreen extends StatefulWidget {
  final AppState appState;

  const AddressesScreen({super.key, required this.appState});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final MapController _mapController = MapController();
  final FocusNode _searchFocusNode = FocusNode();

  // Position initiale (Agadir)
  LatLng _centerPosition = const LatLng(30.4200, -9.6030);
  LatLng _selectedPosition = const LatLng(30.4200, -9.6030);
  bool _isLoadingLocation = false;
  bool _isDragging = false;

  // Contrôleurs de texte
  final _rueController = TextEditingController();
  final _villeController = TextEditingController(text: 'Agadir');
  final _residenceController = TextEditingController();
  final _immeubleController = TextEditingController();
  final _etageController = TextEditingController();
  final _appartementController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pré-remplir avec les données utilisateur existantes
    final user = widget.appState.currentUser;
    if (user != null) {
      // ⚠️ Ne pas initialiser _rueController avec user.deliveryAddress
      // car deliveryAddress contient déjà une chaîne formatée complète
      // (ex: "gh26, Imm. 178, Étage 5") et serait réutilisée comme "rue"
      // lors de la reconstruction, causant une concaténation en boucle.
      _rueController.text = '';
      _villeController.text = 'Agadir';
      _residenceController.text = user.residence ?? '';
      _immeubleController.text = user.buildingNumber ?? '';
      _etageController.text = user.floor ?? '';
      _appartementController.text = user.apartment ?? '';
      _instructionsController.text = user.deliveryInstructions ?? '';
      if (user.latitude != null && user.longitude != null) {
        _selectedPosition = LatLng(user.latitude!, user.longitude!);
        _centerPosition = _selectedPosition;
      }
    }
  }

  @override
  void dispose() {
    _rueController.dispose();
    _villeController.dispose();
    _residenceController.dispose();
    _immeubleController.dispose();
    _etageController.dispose();
    _appartementController.dispose();
    _instructionsController.dispose();
    _searchFocusNode.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // --- Localisation GPS ---
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Veuillez activer la localisation'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Permission de localisation refusée'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final newPos = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _selectedPosition = newPos;
        _centerPosition = newPos;
      });
      _mapController.move(newPos, 16.0);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  // --- Quand l'utilisateur arrête de glisser la carte ---
  void _onMapIdle() {
    final center = _mapController.camera.center;
    if (!_isDragging) return; // ignorer le premier appel au démarrage
    setState(() {
      _selectedPosition = center;
      _centerPosition = center;
      _isDragging = false;
    });
  }

  void _onMapMove() {
    if (!_isDragging) {
      setState(() => _isDragging = true);
    }
  }

  // --- Sauvegarde ---
  void _saveAddress() {
    try {
      // Créer un user si pas connecté
      if (widget.appState.currentUser == null) {
        widget.appState.register(
          firstName: 'Client',
          lastName: '',
          email: 'client@delivip.ma',
          phone: '',
        );
      }

      // Construire l'adresse automatiquement
      final parts = <String>[];
      if (_rueController.text.isNotEmpty) parts.add(_rueController.text);
      if (_residenceController.text.isNotEmpty) {
        parts.add(_residenceController.text);
      }
      if (_immeubleController.text.isNotEmpty) {
        parts.add('Imm. ${_immeubleController.text}');
      }
      if (_etageController.text.isNotEmpty) {
        parts.add('Étage ${_etageController.text}');
      }
      if (_appartementController.text.isNotEmpty) {
        parts.add('Appt ${_appartementController.text}');
      }
      final addressStr = parts.isNotEmpty ? parts.join(', ') : 'Adresse';
      final cityStr = _villeController.text.isNotEmpty
          ? _villeController.text
          : 'Agadir';

      widget.appState.updateDeliveryAddress(
        address: addressStr,
        city: cityStr,
        instructions: _instructionsController.text,
        latitude: _selectedPosition.latitude,
        longitude: _selectedPosition.longitude,
        residence: _residenceController.text,
        buildingNumber: _immeubleController.text,
        floor: _etageController.text,
        apartment: _appartementController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adresse enregistrée ✅'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Adresse de livraison',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _getCurrentLocation,
            icon: _isLoadingLocation
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location, size: 20),
            label: const Text('Géolocaliser'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryCyan,
              textStyle: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- Carte plein largeur (hauteur fixe) ---
          SizedBox(
            height: 320,
            child: Stack(
              children: [
                // FlutterMap
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _centerPosition,
                    initialZoom: 16.0,
                    onMapEvent: (event) {
                      if (event is MapEventMoveStart) _onMapMove();
                      if (event is MapEventFlingAnimationEnd ||
                          event is MapEventMoveEnd) {
                        _onMapIdle();
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.delivip.app',
                    ),
                  ],
                ),

                // --- Info window au-dessus du pin (centrée) ---
                Positioned(
                  top: 24,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryCyan.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.touch_app,
                                color: AppTheme.primaryCyan,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Pointez vers l\'entrée',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // --- Pin centré fixe (custom marker) ---
                Center(
                  child: IgnorePointer(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Petite flèche pointant vers le bas
                        Container(
                          width: 24,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryCyan,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ),
                        // Cercle principal
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryCyan,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        // Tige fine en dessous
                        Container(
                          width: 3,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryCyan.withValues(alpha: 0.6),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- Détails de l'adresse (dans un scroll) ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              children: [
                // Coordonnées
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Lat: ${_selectedPosition.latitude.toStringAsFixed(5)}, '
                      'Lng: ${_selectedPosition.longitude.toStringAsFixed(5)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Champ : Résidence
                _buildField(
                  controller: _residenceController,
                  label: 'Résidence',
                  hint: 'Nom de la résidence',
                  icon: Icons.business,
                ),
                const SizedBox(height: 12),

                // Ligne : Immeuble / Étage / Appartement
                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        controller: _immeubleController,
                        label: 'Imm.',
                        hint: 'N°',
                        icon: Icons.home,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildField(
                        controller: _etageController,
                        label: 'Étage',
                        hint: 'N°',
                        icon: Icons.stairs,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildField(
                        controller: _appartementController,
                        label: 'Appt',
                        hint: 'N°',
                        icon: Icons.door_sliding,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Champ : Instructions
                _buildField(
                  controller: _instructionsController,
                  label: 'Instructions de livraison',
                  hint: 'Sonner à la porte, interphone...',
                  icon: Icons.info_outline,
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                // Bouton Confirmer
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _saveAddress,
                    icon: const Icon(Icons.check_circle, size: 22),
                    label: const Text(
                      'Confirmer l\'adresse',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryCyan,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                SizedBox(height: bottomPad + 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null
            ? Icon(icon, size: 20, color: AppTheme.primaryCyan)
            : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryCyan, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
    );
  }
}
