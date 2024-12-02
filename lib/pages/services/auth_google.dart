import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthGoogle {
  Future<User?> loginGoogle() async {
    try {
      final googleAccount = await GoogleSignIn().signIn();

      if (googleAccount == null) {
        print("Inicio de sesión cancelado por el usuario.");
        return null;
      }

      final googleAuth = await googleAccount.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print("Error: No se obtuvo acceso de Google.");
        return null;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Inicia sesión con Google
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print('Error durante el inicio de sesión: $e');
      return null;
    }
  }
}
