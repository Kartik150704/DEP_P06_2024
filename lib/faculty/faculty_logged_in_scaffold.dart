import 'package:casper/components/customised_text_button.dart';
import 'package:casper/faculty/facultyOfferings.dart';
import 'package:casper/faculty/facultyProfile.dart';
import 'package:casper/faculty/faculty_home_page.dart';
import 'package:casper/utilites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyLoggedInScaffold extends StatelessWidget {
  final appBarOptions = [
    'PROFILE',
    'HOME',
    'OFFERINGS',
  ];

  // ignore: prefer_typing_uninitialized_variables
  final scaffoldbody, role;

  FacultyLoggedInScaffold({
    Key? key,
    required this.scaffoldbody,
    required this.role,
  }) : super(key: key);

  void signUserOut(context) {
    FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff12141d),
        leading: Row(
          children: [
            const SizedBox(
              width: 30,
            ),
            for (int i = 0; i < appBarOptions.length; i++) ...[
              CustomisedTextButton(
                text: appBarOptions[i],
                onPressed: () => {
                  Navigator.of(context).push(
                    _createRoute(i),
                  ),
                },
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ],
        ),
        leadingWidth: 350,
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: scaffoldbody,
      bottomSheet: Container(
        height: 55,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xff12141D),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: 4,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 50,
            ),
            Text(
              '\u00a9 Casper 2023',
              style: SafeGoogleFont(
                'Ubuntu',
                fontSize: 15,
                color: const Color(0xffffffff),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Route _createRoute(i) {
    final appBarFunctions = [
      FacultyProfile(role: role),
      FacultyHomePage(role: role),
      FacultyOfferings(role: role),
    ];
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          appBarFunctions[i],
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.decelerate;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
