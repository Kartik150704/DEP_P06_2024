import 'package:casper/components/customised_text.dart';
import 'package:casper/utilities/utilites.dart';
import 'package:casper/views/admin/admin_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminScaffold extends StatefulWidget {
  const AdminScaffold({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold> {
  String userName = '';

  void signUserOut(context) {
    FirebaseAuth.instance.signOut();
    Navigator.popUntil(
      context,
      ModalRoute.withName("/"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff12141D),
        actions: [
          Container(
            alignment: Alignment.center,
            child: const CustomisedText(
              text: '(Admin)',
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
      body: AdminHomePage(),
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
