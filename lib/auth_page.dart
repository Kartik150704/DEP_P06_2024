import 'package:casper/faculty/facultyHome.dart';
import 'package:casper/login_page.dart';
import 'package:casper/login_scaffold.dart';
import 'package:casper/student/student_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);

  var db = FirebaseFirestore.instance;

  late final String role;

  Future<String> getRole() async {
    var role1 = '';
    await db
        .collection("users")
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then(
      (querySnapshot) {
        role1 = querySnapshot.docs[0]['role'];
      },
    );
    return role1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print(getRole());
            return FutureBuilder(
              future: getRole(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == 'student') {
                    return const StudentHomePage();
                  } else if (snapshot.data == 'supervisor') {
                    return const FacultyHome(role: 'su',);
                  } else{
                    return const FacultyHome(role: 'co',);
                  }
                }
                else {
                  return const CircularProgressIndicator();
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
import 'package:casper/faculty/facultyHome.dart';
import 'package:casper/login_page.dart';
import 'package:casper/login_scaffold.dart';
import 'package:casper/student/student_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);

  var db = FirebaseFirestore.instance;

  late final String role;

  Future<String> getRole() async {
    var role1 = '';
    await db
        .collection("users")
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then(
      (querySnapshot) {
        role1 = querySnapshot.docs[0]['role'];
      },
    );
    return role1;
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // print(getRole());
              return FutureBuilder(
                future: getRole(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == 'student') {
                      return const StudentHomePage();
                    } else if (snapshot.data == 'supervisor') {
                      return const FacultyHome(
                        role: 'su',
                      );
                    } else {
                      return const FacultyHome(
                        role: 'co',
                      );
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              );
            } else {
              return const LoginScaffold(scaffoldbody: LoginPage());
            }
          },
        ),
      ),
    );
  }
}
