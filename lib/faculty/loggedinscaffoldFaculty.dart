import 'package:casper/faculty/facultyOfferings.dart';
import 'package:casper/faculty/facultyProfile.dart';
import 'package:casper/main.dart';
import 'package:casper/utilites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'facultyHome.dart';

class LoggedInScaffoldFaculty extends StatelessWidget {
  final scaffoldbody;
  final role;

  const LoggedInScaffoldFaculty({
    Key? key,
    required this.scaffoldbody,
    required this.role,
  }) : super(key: key);

  @override
  void onPressed() {
    // showDialog(context: context, builder: AlertDialog(title: 'ok',));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff12141d),
        // title: Text(
        //   'Casper',
        //   style: SafeGoogleFont(
        //     'Ubuntu',
        //     fontSize: 20,
        //     fontWeight: FontWeight.w700,
        //     color: const Color(0xffffffff),
        //   ),
        // ),
        leading: Row(
          children: [
            SizedBox(
              width: 30,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FacultyProfile(role: role)),
                );
              },
              child: Text(
                'PROFILE',
                style: SafeGoogleFont(
                  'Ubuntu',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacultyHome(
                      role: role,
                    ),
                  ),
                );
              },
              child: Text(
                'HOME',
                style: SafeGoogleFont(
                  'Ubuntu',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacultyOfferings(role: role),
                  ),
                );
              },
              child: Text(
                'OFFERINGS',
                style: SafeGoogleFont(
                  'Ubuntu',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
            ),
          ],
        ),
        leadingWidth: 400,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, ModalRoute.withName("/"));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: scaffoldbody,
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: const Color(0xff1a1e2e),
      //   // unselectedLabelStyle: TextStyle(color: Color(0xffffffff)),
      //   unselectedItemColor: const Color(0xffffffff),
      //   selectedItemColor: const Color(0xffffffff), items: const [],
      // ),
      bottomSheet: Container(
        height: 50,
        width: double.infinity,
        color: const Color(0xff12141d),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 50,
            ),
            Text(
              'Casper',
              style: SafeGoogleFont(
                'Ubuntu',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xffffffff),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
