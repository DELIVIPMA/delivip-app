import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../models/app_state.dart';
import 'multi_store_home_screen.dart';

class WhatsAppLoginScreen extends StatefulWidget {
  final AppState appState;

  const WhatsAppLoginScreen({super.key, required this.appState});

  @override
  State<WhatsAppLoginScreen> createState() => _WhatsAppLoginScreenState();
}

class _WhatsAppLoginScreenState extends State<WhatsAppLoginScreen>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController(text: '+212 ');
  final _codeController = TextEditingController();
  final _phoneFormKey = GlobalKey<FormState>();
  final _codeFormKey = GlobalKey<FormState>();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  bool _showCodeInput = false;
  bool _isLoading = false;
  bool _whatsAppOpened = false;
  String _enteredPhone = '';
  String _generatedCode = '';
  int _resendSeconds = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _animController.dispose();
    super.dispose();
  }

  String _generateCode() {
    final random = Random();
    return String.fromCharCodes(
      List.generate(6, (_) => random.nextInt(10) + 48),
    );
  }

  Future<void> _sendWhatsAppCode() async {
    if (!_phoneFormKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Générer un code aléatoire
    _generatedCode = _generateCode();

    // Nettoyer le numéro : garder que les chiffres
    String phone = _phoneController.text.trim();
    phone = phone.replaceAll(RegExp(r'\s+'), '');
    if (phone.startsWith('+')) {
      phone = phone.substring(1); // wa.me demande sans +
    }
    // Si commence par 0, enlever le 0 et ajouter 212
    if (phone.startsWith('0')) {
      phone = '212${phone.substring(1)}';
    }

    setState(() {
      _enteredPhone = _phoneController.text.trim();
      _isLoading = false;
      _showCodeInput = true;
      _whatsAppOpened = false;
    });
    _animController.forward();
    _startResendTimer();

    // Ouvrir WhatsApp avec le code pré-rempli
    final message = Uri.encodeComponent(
      'Votre code DeliVIP : $_generatedCode',
    );
    final whatsappUrl = 'https://wa.me/$phone?text=$message';

    try {
      final uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        setState(() => _whatsAppOpened = true);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Vous devez avoir WhatsApp installé',
            ),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'ouverture de WhatsApp')),
      );
    }
  }

  void _startResendTimer() {
    _resendSeconds = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_resendSeconds > 0) _resendSeconds--;
      });
      return _resendSeconds > 0;
    });
  }

  void _verifyCode() {
    if (!_codeFormKey.currentState!.validate()) return;

    // Vérifier le code
    if (_codeController.text.trim() != _generatedCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Code incorrect. Veuillez réessayer.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      widget.appState.register(
        firstName: 'Utilisateur',
        lastName: 'WhatsApp',
        email: 'whatsapp_${DateTime.now().millisecondsSinceEpoch}@delivip.ma',
        phone: _enteredPhone,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MultiStoreHomeScreen(appState: widget.appState),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: !_showCodeInput ? _buildPhoneInput() : _buildCodeInput(),
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        // WhatsApp Icon
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF25D366).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.chat,
            size: 60,
            color: Color(0xFF25D366),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Connexion avec WhatsApp',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Entrez votre numéro de téléphone\npour recevoir un code de vérification',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
        const SizedBox(height: 40),
        // Phone input
        Form(
          key: _phoneFormKey,
          child: TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Numéro de téléphone',
              hintText: '+212 6 XX XX XX XX',
              prefixIcon: const Icon(Icons.phone_android, color: Color(0xFF25D366)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF25D366), width: 2),
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Numéro requis';
              if (v.trim().length < 10) return 'Numéro invalide';
              return null;
            },
          ),
        ),
        const SizedBox(height: 24),
        // Send button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _sendWhatsAppCode,
            icon: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.chat, color: Colors.white),
            label: Text(
              _isLoading ? 'Préparation...' : 'Envoyer le code via WhatsApp',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Nous ouvrirons WhatsApp avec\nvotre code de vérification',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildCodeInput() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Check icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF25D366).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read,
              size: 60,
              color: Color(0xFF25D366),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Code de vérification',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Un code a été envoyé à $_enteredPhone\nvia WhatsApp',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          if (_whatsAppOpened) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF25D366), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'WhatsApp ouvert ✓ Revenez ici après avoir reçu le code',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          // Code input
          Form(
            key: _codeFormKey,
            child: TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 12,
              ),
              decoration: InputDecoration(
                labelText: 'Code à 6 chiffres',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: Color(0xFF25D366), width: 2),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (v) {
                if (v == null || v.length != 6) return 'Code invalide';
                return null;
              },
            ),
          ),
          const SizedBox(height: 24),
          // Verify button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryCyan,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Vérifier',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          // Resend
          TextButton(
            onPressed:
                _resendSeconds == 0 ? _sendWhatsAppCode : null,
            child: Text(
              _resendSeconds > 0
                  ? 'Renvoyer dans $_resendSeconds s'
                  : 'Renvoyer le code',
              style: TextStyle(
                color: _resendSeconds == 0
                    ? const Color(0xFF25D366)
                    : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
