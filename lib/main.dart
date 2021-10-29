// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:authdia/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth',
      theme: ThemeData(),
      home: Scaffold(
        body: SafeArea(
          child: FutureBuilder(
            future: _firebaseApp,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Ha ocurrido un error');
              } else if (snapshot.hasData) {
                return const Center(child: Login());
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String userPhoto = '';
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          email = user.email;
          userPhoto = user.photoURL;
        });
      }
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Usuario: $email',
          style: const TextStyle(fontSize: 16),
        ),
        userPhoto != '' ? Image.network(userPhoto) : Container(),
        ElevatedButton(
          onPressed: () {
            registerEmail('saule@mesoamericana.edu.gt', 'mesoamericana');
          },
          child: const Text('Registrar Correo'),
        ),
        ElevatedButton(
          onPressed: () {
            signInEmail('saule@mesoamericana.edu.gt', 'mesoamericana');
          },
          child: const Text('Autenticar Correo'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Iniciar con Google'),
        ),
        ElevatedButton(
          onPressed: () {
            signOut();
            setState(() {
              email = 'No autenticado';
              userPhoto = '';
            });
          },
          child: const Text('Cerrar sesion'),
        ),
      ],
    );
  }
}
