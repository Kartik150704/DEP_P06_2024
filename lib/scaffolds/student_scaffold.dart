import 'package:casper/components/customised_text.dart';
import 'package:casper/components/customised_text_button.dart';
import 'package:casper/utilities/utilites.dart';
import 'package:casper/views/student/student_home_page.dart';
import 'package:casper/views/student/student_offerings/student_offerings.dart';
import 'package:casper/views/student/student_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentScaffold extends StatefulWidget {
  const StudentScaffold({
    Key? key,
  }) : super(key: key);

  @override
  State<StudentScaffold> createState() => _StudentScaffoldState();
}

class _StudentScaffoldState extends State<StudentScaffold> {
  String userName = '';
  dynamic displayPage;
  final appBarOptions = [
    'PROFILE',
    'HOME',
    'OFFERINGS',
  ];

  void signUserOut(context) {
    FirebaseAuth.instance.signOut();
    Navigator.popUntil(
      context,
      ModalRoute.withName("/"),
    );
  }

  void selectOption(option) {
    setState(() {
      switch (option) {
        case 0:
          displayPage = const StudentProfilePage();
          break;
        case 1:
          displayPage = StudentHomePage(
            selectOption: selectOption,
          );
          break;
        case 2:
          displayPage = const StudentOfferings();
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    displayPage = StudentHomePage(
      selectOption: selectOption,
    );

    FirebaseFirestore.instance
        .collection('student')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      setState(() {
        userName = value.docs[0]['name'];
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
                onPressed: () => selectOption(i),
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
              text: '$userName (Student)',
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
      body: displayPage,
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
