import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyecto_flutter/pages/home_page.dart';

class LogingPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LogingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Método para iniciar sesión con Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // Usuario canceló el inicio de sesión
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print('Error durante la autenticación: $e');
      return null;
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Eliminar la declaración redundante de 'user'
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login con Google'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Verificar si hay un usuario autenticado
            if (user == null) ...[
              ElevatedButton.icon(
                icon: Icon(Icons.login),
                label: Text('Iniciar sesión con Google'),
                onPressed: () async {
                  final user = await signInWithGoogle();
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bienvenido, ${user.displayName}!')),
                    );
                    // Redirigir a la página Home
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Inicio de sesión cancelado.')),
                    );
                  }
                },
              ),
            ] else ...[
              // Si ya está logueado
              Text('Bienvenido, ${user.displayName}!'),
              ElevatedButton.icon(
                icon: Icon(Icons.logout),
                label: Text('Cerrar sesión'),
                onPressed: () async {
                  await signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sesión cerrada.')),
                  );
                  // Volver a la página de Login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LogingPage()),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
