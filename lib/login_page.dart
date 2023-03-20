import 'package:casper/components/customised_text_field.dart';
import 'package:casper/components/customised_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:casper/faculty/facultyHome.dart';
import 'package:casper/student/student_home_page.dart';
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
    final List<String> imageList = [
      'assets/images/carousel_image_1.jpeg',
      'assets/images/carousel_image_2.jpg',
    ];

    void signUserIn() {
      if (usernameController.text.trim() == 'student') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StudentHomePage()),
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
    }

    void forgotPassword() {}

    return Scaffold(
      backgroundColor: const Color(0xff302C42),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 80, 0, 140),
              width: 550,
              height: 710,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 5,
                    blurRadius: 20,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Color(0xff12141D),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Casper, IIT Ropar',
                        style: SafeGoogleFont(
                          'Ubuntu',
                          fontSize: 30,
                          height: 1.2175,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 270,
                    color: const Color(0xffffffff),
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: CarouselSlider.builder(
                      itemCount: imageList.length,
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        height: 300,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        reverse: false,
                        aspectRatio: 5.0,
                      ),
                      itemBuilder: (context, i, id) {
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white,
                                )),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                imageList[i],
                                width: 500,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        'Username',
                        style: SafeGoogleFont(
                          'Ubuntu',
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          height: 1.2175,
                          color: const Color(0xff000000),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  CustomisedTextField(
                    textEditingController: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        'Password',
                        style: SafeGoogleFont(
                          'Ubuntu',
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          height: 1.2175,
                          color: const Color(0xff000000),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  CustomisedTextField(
                    textEditingController: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 2 * spacerHeightBig,
                  ),
                  CustomisedButton(
                    width: 250,
                    height: 50,
                    text: 'Sign In',
                    onPressed: signUserIn,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
