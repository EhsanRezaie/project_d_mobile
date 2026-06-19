import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class GoogleAuthService {
  static String get _webClientId => dotenv.env['WEB_CLIENT_ID'] ?? '';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: _webClientId,
  );

  Future<Map<String, String>?> signIn() async {
    try {
      print('🟢 1. Calling Google Sign-In...');
      
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      print('🟢 2. Account: $account');
      
      if (account == null) {
        print('🔴 3. Account is null (user cancelled)');
        return null;
      }

      print('🟢 3. Account displayName: ${account.displayName}');
      print('🟢 4. Account email: ${account.email}');
      print('🟢 5. Account photoUrl: ${account.photoUrl}');
      print('🟢 6. Account id: ${account.id}');

      final GoogleSignInAuthentication auth = await account.authentication;
      print('🟢 7. Authentication received');
      print('🟢 8. auth.idToken: ${auth.idToken}');
      print('🟢 9. auth.accessToken: ${auth.accessToken}');

      final idToken = auth.idToken;
      if (idToken == null) {
        print('🔴 10. idToken is null!');
        print('🔴 11. accessToken: ${auth.accessToken}');
        return null;
      }

      print('🟢 12. idToken received! Length: ${idToken.length}');

      return {
        'id_token': idToken,
        'name': account.displayName ?? '',
        'email': account.email,
        'picture': account.photoUrl ?? '',
      };
    } catch (e, stacktrace) {
      print('🔴 Google SignIn Error: $e');
      print('🔴 Stacktrace: $stacktrace');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}