import 'package:casper/login.dart';
import 'package:casper/loginScaffold.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const myActualApp());
}

class myActualApp extends StatelessWidget {
  const myActualApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Casper',
      debugShowCheckedModeBanner: false,
      home: LogInScaffold(scaffoldbody: LoginPage()),
    );
  }
}
