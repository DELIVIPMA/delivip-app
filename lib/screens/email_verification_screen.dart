import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  EMAIL VERIFICATION SCREEN — DeliVip Vérification email
// ═══════════════════════════════════════════════════════════════════

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<String> _digits = List.generate(4, (_) => '');

  @override
  void initState() {
    super.initState();
    // Set first digit as example "5"
    _controllers[0].text = '5';
    _digits[0] = '5';
    // Auto-focus on first box
    _focusNodes[0].requestFocus();

    // Add listeners to each controller
    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(() {
        final text = _controllers[i].text;
        if (text.length > 1) {
          _controllers[i].text = text.substring(text.length - 1);
          _controllers[i].selection = TextSelection.collapsed(offset: 1);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  bool get _allFilled => _digits.every((d) => d.isNotEmpty);

  void _onDigitChanged(int index, String value) {
    setState(() {
      _digits[index] = value;
    });

    if (value.isNotEmpty && index < 3) {
      _focusNodes[index].unfocus();
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index].unfocus();
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update digits from controllers
    for (int i = 0; i < 4; i++) {
      if (_controllers[i].text != _digits[i]) {
        _digits[i] = _controllers[i].text;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Title
                  Text(
                    'Entrez le code à 4 chiffres envoyé à :\nadmin@delivip.ma',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // OTP Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final isFilled = _digits[index].isNotEmpty;
                      final isFocused = _focusNodes[index].hasFocus;
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : 6,
                          right: index == 3 ? 0 : 6,
                        ),
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: isFilled ? Colors.white : const Color(0xFFF5F5F5),
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isFocused ? Colors.black : const Color(0xFFCCCCCC),
                                  width: isFocused ? 2 : 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isFocused ? Colors.black : const Color(0xFFCCCCCC),
                                  width: isFocused ? 2 : 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) => _onDigitChanged(index, value),
                          ),

                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  // Tip text
                  Text(
                    'Astuce : Vérifiez votre boîte de réception et dossier spam',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // "Se connecter avec mot de passe" pill button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFCCCCCC), width: 1.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Se connecter avec mot de passe',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Bottom bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Suivant button
                  GestureDetector(
                    onTap: _allFilled
                        ? () {
                            // TODO: Handle next
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      decoration: BoxDecoration(
                        color: _allFilled ? Colors.black : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Suivant →',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _allFilled ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
