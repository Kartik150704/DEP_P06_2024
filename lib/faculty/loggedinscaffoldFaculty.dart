import 'package:casper/faculty/facultyOfferings.dart';
import 'package:casper/faculty/facultyProfile.dart';
import 'package:casper/main.dart';
import 'package:casper/utils.dart';
import 'package:flutter/material.dart';

import 'facultyHome.dart';

class LoggedInScaffoldFaculty extends StatelessWidget {
  final scaffoldbody;
  final role;

  const LoggedInScaffoldFaculty({
    Key? key,
    required this.scaffoldbody,
    this.role = 'su',
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
        //     'Montserrat',
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
                      builder: (context) => const FacultyProfile()),
                );
              },
              child: Text(
                'PROFILE',
                style: SafeGoogleFont(
                  'Montserrat',
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
                          )),
                );
              },
              child: Text(
                'HOME',
                style: SafeGoogleFont(
                  'Montserrat',
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
                      builder: (context) => const FacultyOfferings()),
                );
              },
              child: Text(
                'OFFERINGS',
                style: SafeGoogleFont(
                  'Montserrat',
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
              while (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => myActualApp()));
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
              "Casper",
              style: SafeGoogleFont(
                'Montserrat',
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
