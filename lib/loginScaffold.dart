import 'package:casper/student/studentHome.dart';
import 'package:casper/student/studentOfferings.dart';
import 'package:casper/student/studentProfile.dart';
import 'package:casper/utils.dart';
import 'package:flutter/material.dart';

class LogInScaffold extends StatelessWidget {
  final scaffoldbody;

  const LogInScaffold({Key? key, required this.scaffoldbody}) : super(key: key);

  @override
  void onPressed() {
    // showDialog(context: context, builder: AlertDialog(title: 'ok',));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff12141d),
        title: Text(
          'Casper',
          style: SafeGoogleFont(
            'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xffffffff),
          ),
        ),
      ),
      body: scaffoldbody,
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: const Color(0xff1a1e2e),
      //
      //   // unselectedLabelStyle: TextStyle(color: Color(0xffffffff)),
      //   unselectedItemColor: const Color(0xffffffff),
      //   selectedItemColor: const Color(0xffffffff),
      //   items: [BottomNavigationBarItem(), Container()],
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
