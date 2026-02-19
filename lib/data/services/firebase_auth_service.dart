import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Typed exception for authentication errors.
class AuthException implements Exception {
  final String message;
  final String? code;
  const AuthException(this.message, {this.code});

  @override
  String toString() => message;
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Check if we have the necessary tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw const AuthException(
          'No se pudieron obtener las credenciales de Google.',
          code: 'missing-credentials',
        );
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        'Error al iniciar sesión con Google: ${e.toString()}',
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw const AuthException(
        'Error al cerrar sesión. Por favor, intenta de nuevo.',
        code: 'sign-out-error',
      );
    }
  }

  // Handle Firebase Auth exceptions with Spanish messages
  AuthException _handleAuthException(FirebaseAuthException e) {
    final message = switch (e.code) {
      'account-exists-with-different-credential' =>
        'Ya existe una cuenta con este correo electrónico.',
      'invalid-credential' => 'Las credenciales proporcionadas son inválidas.',
      'operation-not-allowed' => 'Esta operación no está permitida.',
      'user-disabled' => 'Esta cuenta ha sido deshabilitada.',
      'user-not-found' => 'No se encontró ninguna cuenta con este correo.',
      'wrong-password' => 'Contraseña incorrecta.',
      'invalid-verification-code' => 'Código de verificación inválido.',
      'invalid-verification-id' => 'ID de verificación inválido.',
      'network-request-failed' => 'Error de conexión. Verifica tu internet.',
      'too-many-requests' =>
        'Demasiados intentos. Por favor, intenta más tarde.',
      _ => 'Error de autenticación: ${e.message ?? "Error desconocido"}',
    };
    return AuthException(message, code: e.code);
  }
}

// Riverpod provider for FirebaseAuthService
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});
