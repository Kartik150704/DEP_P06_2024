import 'package:casper/components/customised_text_button.dart';
import 'package:casper/student/student_home_page.dart';
import 'package:casper/student/student_offerings_page.dart';
import 'package:casper/student/student_profile_page.dart';
import 'package:casper/utilites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentLoggedInScaffold extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final studentScaffoldBody;

  final appBarOptions = [
    'PROFILE',
    'HOME',
    'OFFERINGS',
  ];
  final appBarFunctions = const [
    StudentProfilePage(),
    StudentHomePage(),
    StudentOfferingsPage(),
  ];

  StudentLoggedInScaffold({
    Key? key,
    required this.studentScaffoldBody,
  }) : super(key: key);

  void signUserOut(context) {
    FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => appBarFunctions[i],
                    ),
                  )
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
      body: studentScaffoldBody,
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
}