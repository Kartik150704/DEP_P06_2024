import 'package:casper/faculty/faculty_home_page.dart';
import 'package:casper/login_page.dart';
import 'package:casper/login_scaffold.dart';
import 'package:casper/student/student_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);

  var db = FirebaseFirestore.instance;

  late final String role;

  Future<String> getRole() async {
    var currentRole = '';
    await db
        .collection("users")
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then(
      (querySnapshot) {
        currentRole = querySnapshot.docs[0]['role'];
      },
    );
    return currentRole;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: getRole(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == 'student') {
                    return const StudentHomePage();
                  } else if (snapshot.data == 'supervisor') {
                    return const FacultyHomePage(
                      role: 'su',
                    );
                  } else {
                    return const FacultyHomePage(
                      role: 'co',
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  );
                }
              },
            );
          } else {
            return const LoginScaffold(scaffoldbody: LoginPage());
          }
        },
      ),
    );
  }
}
