import 'package:casper/utilities/utilites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyProfilePage extends StatefulWidget {
  final role;

  const FacultyProfilePage({Key? key, required this.role}) : super(key: key);

  @override
  State<FacultyProfilePage> createState() => _FacultyProfilePageState();
}

class _FacultyProfilePageState extends State<FacultyProfilePage> {
  var faculty = ['', '', ''];
  var name = ['', '', ''];
  void onPressed() {}

  // ProjectPage projectpage = ProjectPage(
  //   project: ['', '', '', '', '', '', '', ''],
  // );
  void fetchName() {
    setState(() {
      faculty = ['', '', ''];
      name = ['', '', ''];
    });
    FirebaseFirestore.instance.collection('instructors').get().then((value) {
      value.docs.forEach((element) {
        var doc = element.data();
        if (doc['uid'] == FirebaseAuth.instance.currentUser?.uid) {
          setState(() {
            faculty[0] = (doc['name']);
            faculty[1] = (doc['department']);
            faculty[2] = (doc['contact']);
          });
          name = faculty[0].split(' ');
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchName();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double wfem = MediaQuery.of(context).size.width / baseWidth * 0.97;
    double fwfem = wfem * 0.97;
    return Row(
      children: [
        Container(
          width: 300 * fwfem,
          color: const Color(0xff545161),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 200.0,
                      width: 120.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg'),
                          fit: BoxFit.fitHeight,
                        ),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: Center(
                      child: Text(
                        'Faculty ID -',
                        style: SafeGoogleFont(
                          'Ubuntu',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: Center(
                      child: Text(
                        '${FirebaseAuth.instance.currentUser?.uid}',
                        style: SafeGoogleFont(
                          'Ubuntu',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding:
                EdgeInsets.fromLTRB(34 * wfem, 40 * wfem, 0 * wfem, 40 * wfem),
            height: double.infinity,
            color: const Color(0xff302c42),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(
                      0 * wfem, 0 * wfem, 289 * wfem, 0 * wfem),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            66 * wfem, 0 * wfem, 0 * wfem, 70 * wfem),
                        child: Text(
                          '${name[0]} ${name[1]}\'s Profile',
                          style: SafeGoogleFont(
                            'Ubuntu',
                            fontSize: 50 * fwfem,
                            fontWeight: FontWeight.w700,
                            height: 1.2175 * fwfem / wfem,
                            color: const Color(0xffffffff),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            66 * wfem, 0 * wfem, 0 * wfem, 9 * wfem),
                        child: Text(
                          'Name - ${faculty[0]}',
                          style: SafeGoogleFont(
                            'Ubuntu',
                            fontSize: 25 * fwfem,
                            fontWeight: FontWeight.w700,
                            height: 1.2175 * fwfem / wfem,
                            color: const Color(0xffffffff),
                          ),
                        ),
                      ),
                      Container(
                        // programprogram5jG (225:254)
                        margin: EdgeInsets.fromLTRB(
                            66 * wfem, 0 * wfem, 0 * wfem, 9 * wfem),
                        child: Text(
                          'Department - ${faculty[1]}',
                          style: SafeGoogleFont(
                            'Ubuntu',
                            fontSize: 25 * fwfem,
                            fontWeight: FontWeight.w700,
                            height: 1.2175 * fwfem / wfem,
                            color: const Color(0xffffffff),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            66 * wfem, 0 * wfem, 0 * wfem, 9 * wfem),
                        child: Text(
                          'Contact - ${faculty[2]}',
                          style: SafeGoogleFont(
                            'Ubuntu',
                            fontSize: 25 * fwfem,
                            fontWeight: FontWeight.w700,
                            height: 1.2175 * fwfem / wfem,
                            color: const Color(0xffffffff),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
