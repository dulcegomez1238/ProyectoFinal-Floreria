import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      debugPrint('AuthService: Iniciando signInWithEmailAndPassword...');
      return await _auth.signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 15), onTimeout: () {
            debugPrint('AuthService: Error - Tiempo de espera agotado (15s)');
            throw Exception('Tiempo de espera agotado. Revisa tu conexión a internet.');
          });
    } catch (e) {
      debugPrint('AuthService: Error en signInWithEmail: $e');
      rethrow;
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmail(String email, String password) async {
    try {
      debugPrint('AuthService: Iniciando createUserWithEmailAndPassword...');
      return await _auth.createUserWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 15), onTimeout: () {
            debugPrint('AuthService: Error - Tiempo de espera agotado (15s)');
            throw Exception('Tiempo de espera agotado. Revisa tu conexión a internet.');
          });
    } catch (e) {
      debugPrint('AuthService: Error en registerWithEmail: $e');
      rethrow;
    }
  }

  // Forgot password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // For Web
      if (kIsWeb) {
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        return await _auth.signInWithPopup(authProvider);
      } else {
        // For Android/iOS
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null; // The user canceled the sign-in

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
