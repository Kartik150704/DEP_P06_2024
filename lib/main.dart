import 'package:casper/login_page.dart';
import 'package:casper/login_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const myActualApp());
}

class myActualApp extends StatelessWidget {
  const myActualApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Casper',
      debugShowCheckedModeBanner: false,
      home: LogInScaffold(scaffoldbody: LoginPage()),
    );
  }
}
