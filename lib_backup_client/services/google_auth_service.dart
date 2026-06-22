// ═══════════════════════════════════════════════════════════════════
//  GOOGLE AUTH SERVICE — DeliVip
//  Service de connexion avec Google Sign-In (v7 — singleton)
// ═══════════════════════════════════════════════════════════════════

import 'package:google_sign_in/google_sign_in.dart';

/// Résultat d'une connexion Google
class GoogleAuthResult {
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final String? idToken;
  final bool isSuccess;
  final String? errorMessage;

  const GoogleAuthResult({
    this.displayName,
    this.email,
    this.photoUrl,
    this.idToken,
    required this.isSuccess,
    this.errorMessage,
  });
}

/// Service d'authentification Google
class GoogleAuthService {
  static bool _initialized = false;

  /// Initialise Google Sign-In (peut échouer sans Client ID — l'app marche quand même)
  static Future<void> initialize({String? clientId}) async {
    if (_initialized) return;
    try {
      await GoogleSignIn.instance.initialize(clientId: clientId);
      _initialized = true;
    } catch (e) {
      // L'initialisation échoue si le Client ID n'est pas défini
      // L'app continue normalement, le bouton Google affichera une erreur
    }
  }

  /// Vérifie si l'utilisateur est déjà connecté
  static Future<bool> isSignedIn() async {
    if (!_initialized) return false;
    try {
      final result =
          await GoogleSignIn.instance.attemptLightweightAuthentication();
      return result != null;
    } catch (_) {
      return false;
    }
  }

  /// Récupère l'utilisateur actuellement connecté (silencieux)
  static Future<GoogleAuthResult?> trySilentSignIn() async {
    if (!_initialized) return null;
    try {
      final account =
          await GoogleSignIn.instance.attemptLightweightAuthentication();
      if (account != null) {
        return _buildResult(account);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Déclenche la popup de connexion Google
  static Future<GoogleAuthResult> signIn() async {
    // Réessayer d'initialiser si pas encore fait
    if (!_initialized) {
      await initialize();
    }
    if (!_initialized) {
      return const GoogleAuthResult(
        isSuccess: false,
        errorMessage:
            'Service non initialisé. Ajoutez un OAuth Client ID dans index.html',
      );
    }
    try {
      final account = await GoogleSignIn.instance.authenticate();
      return _buildResult(account);
    } on GoogleSignInException catch (e) {
      final code = e.code;
      String message;
      switch (code) {
        case GoogleSignInExceptionCode.canceled:
          message = 'Connexion annulée';
          break;
        case GoogleSignInExceptionCode.interrupted:
          message = 'Connexion interrompue';
          break;
        case GoogleSignInExceptionCode.uiUnavailable:
          message = 'Connexion temporairement indisponible';
          break;
        case GoogleSignInExceptionCode.unknownError:
        default:
          message = 'Erreur de connexion : ${e.description ?? "inconnue"}';
          break;
      }
      return GoogleAuthResult(
        isSuccess: false,
        errorMessage: message,
      );
    } catch (e) {
      return GoogleAuthResult(
        isSuccess: false,
        errorMessage: 'Erreur de connexion : ${e.toString()}',
      );
    }
  }

  /// Déconnexion
  static Future<void> signOut() async {
    if (!_initialized) return;
    await GoogleSignIn.instance.signOut();
  }

  /// Construit le résultat à partir du compte Google
  static GoogleAuthResult _buildResult(GoogleSignInAccount account) {
    return GoogleAuthResult(
      displayName: account.displayName,
      email: account.email,
      photoUrl: account.photoUrl,
      idToken: account.authentication.idToken,
      isSuccess: true,
    );
  }
}
