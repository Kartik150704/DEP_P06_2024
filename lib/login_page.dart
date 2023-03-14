import 'package:casper/faculty/facultyHome.dart';
import 'package:casper/student/studentHome.dart';
import 'package:flutter/material.dart';
import 'package:casper/utilites.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const double spacerHeightBig = 25;

    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    void signUserIn() {}

    void forgotPassword() {}

    void signUserUp() {}

    return Container(
      color: const Color(0xff302c42),
      child: Center(
        child: Container(
          width: 800,
          height: 430,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xff1a1e2e),
                  border: Border.all(color: const Color(0xff1a1e2e)),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Welcome back, we missed you too',
                    style: SafeGoogleFont(
                      'Montserrat',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      height: 1.2175 * ffem / fem,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  // usernamewzs (225:332)
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    'Username',
                    style: SafeGoogleFont(
                      'Montserrat',
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      height: 1.2175 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10 * fem),
                  border: Border.all(color: Color(0xff000000)),
                  color: Color(0xffe1e3e8),
                ),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Color(0xff818488)),
                  ),
                  style: SafeGoogleFont(
                    'Montserrat',
                    fontSize: 15 * ffem,
                    fontWeight: FontWeight.w400,
                    height: 1.2175 * ffem / fem,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  // usernamewzs (225:332)
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    'Password',
                    style: SafeGoogleFont(
                      'Montserrat',
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      height: 1.2175 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10 * fem),
                  border: Border.all(color: Color(0xff000000)),
                  color: Color(0xffe1e3e8),
                ),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Color(0xff818488)),
                  ),
                  style: SafeGoogleFont(
                    'Montserrat',
                    fontSize: 15 * ffem,
                    fontWeight: FontWeight.w400,
                    height: 1.2175 * ffem / fem,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              const SizedBox(
                height: 2 * spacerHeightBig,
              ),
              TextButton(
                onPressed: () {
                  if (usernameController.text.trim() == 'student') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StudentHome()),
                    );
                  } else if (usernameController.text.trim() == 'supervisor') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FacultyHome(
                                role: 'su',
                              )),
                    );
                  } else if (usernameController.text.trim() == 'coordinator') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FacultyHome(
                                role: 'co',
                              )),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xff1a1e2e),
                    borderRadius: BorderRadius.circular(10 * fem),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3f000000),
                        offset: Offset(0 * fem, 4 * fem),
                        blurRadius: 2 * fem,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Sign In',
                      style: SafeGoogleFont(
                        'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.2175 * ffem / fem,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
