import 'package:casper/components/customised_text.dart';
import 'package:casper/components/customised_text_button.dart';
import 'package:casper/faculty/faculty_offerings.dart';
import 'package:casper/faculty/faculty_profile_page.dart';
import 'package:casper/faculty/faculty_home_page.dart';
import 'package:casper/utilites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyScaffold extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final userRole;

  const FacultyScaffold({
    Key? key,
    required this.userRole,
  }) : super(key: key);

  @override
  State<FacultyScaffold> createState() => _FacultyScaffoldState();
}

class _FacultyScaffoldState extends State<FacultyScaffold> {
  final appBarOptions = [
    'PROFILE',
    'HOME',
    'OFFERINGS',
  ];
  String username = '';
  dynamic displayPage;

  void signUserOut(context) {
    FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  void selectOption(option) {
    setState(() {
      switch (option) {
        case 0:
          displayPage = FacultyProfilePage(role: widget.userRole);
          break;
        case 1:
          displayPage = FacultyHomePage(userRole: widget.userRole);
          break;
        case 2:
          displayPage = FacultyOfferings(role: widget.userRole);
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    displayPage = FacultyHomePage(userRole: widget.userRole);
    FirebaseFirestore.instance
        .collection('instructors')
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
              text:
                  '$username (${(widget.userRole == 'co') ? 'Coordinator' : 'Supervisor'})',
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
