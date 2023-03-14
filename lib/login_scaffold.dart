import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';

class LogInScaffold extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final scaffoldbody;

  const LogInScaffold({
    Key? key,
    required this.scaffoldbody,
  }) : super(key: key);

  @override
  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0d0e14),
      ),
      body: scaffoldbody,
      bottomSheet: Container(
        height: 55,
        width: double.infinity,
        color: const Color(0xff0d0e14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 50,
            ),
            Text(
              "\u00a9 Casper 2023",
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
