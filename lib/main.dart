import 'package:casper/controllers/auth.dart';
import 'package:casper/utilities/firebase_options.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Casper());
}

class Casper extends StatelessWidget {
  const Casper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Casper',
      debugShowCheckedModeBanner: false,
      home: Auth(),
    );
  }
}
