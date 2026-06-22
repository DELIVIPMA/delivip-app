import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
//  PHONE VERIFICATION SCREEN — DeliVip Vérification téléphone
// ═══════════════════════════════════════════════════════════════════

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _countdown = 60;
  Timer? _timer;
  bool _canResend = false;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Listen to all controllers to check if complete
    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(() => _checkComplete());
      _focusNodes[i].addListener(() => setState(() {}));
    }
    // Auto-focus first box after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _countdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  void _checkComplete() {
    final complete = _controllers.every((c) => c.text.isNotEmpty);
    if (complete != _isComplete) {
      setState(() => _isComplete = complete);
    }
  }

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      _controllers[index].text = value.substring(value.length - 1);
      _controllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: _controllers[index].text.length),
      );
    }

    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onDigitBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _timerText {
    final minutes = (_countdown ~/ 60).toString().padLeft(1, '0');
    final seconds = (_countdown % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ──────────────────────────────────────────
              Text(
                'Entrez le code \u00E0 4 chiffres envoy\u00E9 au 0661234567',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              // ── OTP Input Row ──────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final isFocused = _focusNodes[i].hasFocus;
                  final hasText = _controllers[i].text.isNotEmpty;
                  return Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: hasText ? Colors.white : const Color(0xFFF5F5F5),
                      border: Border.all(
                        color: isFocused ? Colors.black : const Color(0xFFCCCCCC),
                        width: isFocused ? 2.0 : 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: TextField(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        maxLines: 1,
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (v) => _onDigitChanged(i, v),


                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              // ── Resend Code Button ─────────────────────────────
              GestureDetector(
                onTap: _canResend
                    ? () {
                        _startTimer();
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
                      children: [
                        const TextSpan(text: "Je n'ai pas re\u00E7u de code ("),
                        TextSpan(
                          text: _canResend ? 'envoyer' : _timerText,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: _canResend
                                ? const Color(0xFF00BFA5)
                                : Colors.black,
                            fontWeight: _canResend ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const TextSpan(text: ')'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // ── Login with Password Button ─────────────────────
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/password-input');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Se connecter avec mot de passe',
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
                  ),
                ),
              ),
              const Spacer(),
              // ── Bottom Bar ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
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
                        child: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
                      ),
                    ),
                    // Next button
                    GestureDetector(
                      onTap: _isComplete ? () {} : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        decoration: BoxDecoration(
                          color: _isComplete ? Colors.black : const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Suivant',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: _isComplete ? Colors.white : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: _isComplete ? Colors.white : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
