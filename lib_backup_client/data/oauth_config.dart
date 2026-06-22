// ═══════════════════════════════════════════════════
//  GOOGLE OAUTH — Configuration
// ═══════════════════════════════════════════════════
//
//  Pour obtenir un Client ID OAuth :
//  1. Va sur https://console.cloud.google.com/apis/credentials?project=delivip-app
//  2. Clique "Create Credentials" > "OAuth client ID"
//  3. Application type: "Web application"
//  4. Name: "DeliVip Web"
//  5. Authorized JavaScript origins: http://localhost
//  6. Clique "Create"
//  7. Copie le Client ID et colle-le ci-dessous
// ═══════════════════════════════════════════════════

class GoogleOAuthConfig {
  static const String webClientId = 'YOUR_OAUTH_CLIENT_ID_HERE';
}
