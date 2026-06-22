// ═══════════════════════════════════════════════════════════════════
//  EMAIL SERVICE — DeliVip
//  Service d'envoi de codes de vérification par Gmail SMTP
// ═══════════════════════════════════════════════════════════════════
//
//  ⚠️ CONFIGURATION GMAIL — IMPORTANT ⚠️
//
//  1️⃣ Activez l'authentification à deux facteurs (2FA) sur votre
//     compte Gmail : https://myaccount.google.com/security
//
//  2️⃣ Créez un "Mot de passe d'application" :
//     - Allez sur https://myaccount.google.com/apppasswords
//     - Sélectionnez "Mail" et votre appareil
//     - Copiez le mot de passe à 16 caractères généré
//
//  3️⃣ Remplacez les valeurs ci-dessous :
//     - _gmailUser → votre adresse Gmail
//     - _gmailPassword → le mot de passe d'application (16 caractères)
//
//  📝 Note : Ne stockez jamais vos identifiants en clair en production.
//  Utilisez des variables d'environnement ou un backend sécurisé.
// ═══════════════════════════════════════════════════════════════════

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailService {
  // ═══════════════════════════════════════════════════════════════
  //  🔑 Remplacez par vos identifiants Gmail
  // ═══════════════════════════════════════════════════════════════
  static const String _gmailUser = 'delivip24@gmail.com';
  // ⚠️ Remplacez 'VOTRE_MOT_DE_PASSE_APPLICATION' par le code
  //    16 caractères généré sur https://myaccount.google.com/apppasswords
  static const String _gmailPassword = 'VOTRE_MOT_DE_PASSE_APPLICATION';

  /// Génère un code de vérification aléatoire à 6 chiffres
  static String generateVerificationCode() {
    final random = DateTime.now().microsecondsSinceEpoch;
    final code = (random % 900000 + 100000).toString();
    return code;
  }

  /// Envoie un email avec le code de vérification à 6 chiffres
  static Future<bool> sendVerificationCode({
    required String email,
    required String code,
    String? userName,
  }) async {
    try {
      final smtpServer = gmail(_gmailUser, _gmailPassword);

      final greeting = userName != null ? 'Bonjour $userName,' : 'Bonjour,';
      final message = Message()
        ..from = Address(_gmailUser, 'DeliVIP')
        ..recipients.add(email)
        ..subject = 'Votre code de vérification DeliVIP'
        ..html = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
      margin: 0;
      padding: 0;
    }
    .container {
      max-width: 600px;
      margin: 0 auto;
      padding: 30px 20px;
    }
    .card {
      background: #ffffff;
      border-radius: 16px;
      padding: 40px 30px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.08);
    }
    .logo {
      text-align: center;
      font-size: 28px;
      font-weight: bold;
      color: #00BCD4;
      margin-bottom: 24px;
    }
    h1 {
      font-size: 22px;
      color: #333;
      margin-bottom: 8px;
    }
    p {
      font-size: 15px;
      color: #666;
      line-height: 1.6;
      margin-bottom: 20px;
    }
    .code-box {
      background: #f0fcff;
      border: 2px dashed #00BCD4;
      border-radius: 12px;
      padding: 20px;
      text-align: center;
      margin: 24px 0;
    }
    .code {
      font-size: 42px;
      font-weight: bold;
      letter-spacing: 8px;
      color: #00BCD4;
      font-family: 'Courier New', monospace;
    }
    .footer {
      font-size: 12px;
      color: #999;
      text-align: center;
      margin-top: 24px;
    }
    hr {
      border: none;
      border-top: 1px solid #eee;
      margin: 24px 0;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="card">
      <div class="logo">🍽️ DeliVIP</div>
      <h1>Vérification de votre compte</h1>
      <p>$greeting</p>
      <p>Merci de vous être inscrit sur DeliVIP ! Veuillez utiliser le code ci-dessous pour vérifier votre adresse email :</p>
      <div class="code-box">
        <div class="code">$code</div>
      </div>
      <p>Ce code est valable pendant <strong>10 minutes</strong>. Ne le partagez avec personne.</p>
      <hr>
      <p style="font-size: 13px; color: #888;">Si vous n'avez pas créé de compte DeliVIP, ignorez simplement cet email.</p>
      <div class="footer">
        <p>DeliVIP — Votre application de livraison</p>
      </div>
    </div>
  </div>
</body>
</html>
''';

      await send(message, smtpServer);
      return true;
    } catch (e) {
      // En mode développement, on simule l'envoi
      print('EmailService: Erreur d\'envoi - $e');
      return false;
    }
  }

  /// Envoie un email de bienvenue après vérification réussie
  static Future<bool> sendWelcomeEmail({
    required String email,
    required String userName,
  }) async {
    try {
      final smtpServer = gmail(_gmailUser, _gmailPassword);
      final message = Message()
        ..from = Address(_gmailUser, 'DeliVIP')
        ..recipients.add(email)
        ..subject = 'Bienvenue sur DeliVIP !'
        ..html = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
      margin: 0;
      padding: 0;
    }
    .container {
      max-width: 600px; margin: 0 auto; padding: 30px 20px;
    }
    .card {
      background: #ffffff; border-radius: 16px; padding: 40px 30px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.08);
    }
    .logo { text-align: center; font-size: 28px; font-weight: bold; color: #00BCD4; margin-bottom: 24px; }
    h1 { font-size: 22px; color: #333; }
    p { font-size: 15px; color: #666; line-height: 1.6; }
  </style>
</head>
<body>
  <div class="container">
    <div class="card">
      <div class="logo">🍽️ DeliVIP</div>
      <h1>Bienvenue $userName ! 🎉</h1>
      <p>Votre compte a été vérifié avec succès.</p>
      <p>Vous pouvez dès maintenant commander vos plats préférés et profiter de nos offres exceptionnelles.</p>
      <p style="text-align: center; font-size: 32px; margin: 20px 0;">🚀</p>
      <p style="color: #888;">L'équipe DeliVIP</p>
    </div>
  </div>
</body>
</html>
''';

      await send(message, smtpServer);
      return true;
    } catch (e) {
      print('EmailService: Erreur envoi bienvenue - $e');
      return false;
    }
  }
}
