import 'package:casper/components/customised_text_button.dart';
import 'package:casper/views/student/student_home_page.dart';
import 'package:casper/views/student/student_offerings_page.dart';
import 'package:casper/views/student/student_profile_page.dart';
import 'package:casper/utilites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/customised_text.dart';

class StudentLoggedInScaffold extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final studentScaffoldBody;
  final uid;

  const StudentLoggedInScaffold({
    Key? key,
    this.uid,
    required this.studentScaffoldBody,
  }) : super(key: key);

  @override
  State<StudentLoggedInScaffold> createState() =>
      _StudentLoggedInScaffoldState();
}

class _StudentLoggedInScaffoldState extends State<StudentLoggedInScaffold> {
  final appBarOptions = [
    'PROFILE',
    'HOME',
    'OFFERINGS',
  ];
  String username = '';
  late final appBarFunctions = [
    StudentProfilePage(uid: widget.uid),
    const StudentHomePage(),
    const StudentOfferingsPage(),
  ];

  void signUserOut(context) {
    FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('student')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      setState(() {
        username = value.docs[0]['name'];
      });
    });
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => appBarFunctions[i],
                  //   ),
                  // )
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
          Container(
            alignment: Alignment.center,
            child: CustomisedText(
              text: '$username (Student)',
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () => signUserOut(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: widget.studentScaffoldBody,
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
