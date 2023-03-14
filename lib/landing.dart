import 'package:casper/student/studentHome.dart';
import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';
import 'package:casper/login_page.dart';
import 'package:casper/components/loginbox.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  void onPressed() {
    // showDialog(context: context, builder: AlertDialog(title: 'ok',));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1a1e2e),
        title: Text(
          'Casper',
          style: SafeGoogleFont(
            'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xffffffff),
          ),
        ),
        leading: Row(
          children: [
            TextButton(
              onPressed: onPressed,
              child: Text('Home'),
            ),
          ],
        ),
      ),
      body: const StudentHome(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff1a1e2e),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
            ),
            label: 'Contact',
          ),
        ],
        // unselectedLabelStyle: TextStyle(color: Color(0xffffffff)),
        unselectedItemColor: const Color(0xffffffff),
        selectedItemColor: const Color(0xffffffff),
      ),
    );
  }
}
