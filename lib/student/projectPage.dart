import 'package:casper/utils.dart';
import 'package:casper/components/weektile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProjectPage extends StatelessWidget {
  final flag;

  ProjectPage({Key? key, this.flag = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    if (flag) {
      return Expanded(
        child: Container(
          color: Color(0xff302c42),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: Text(
                      'Fair Clustering Algorithms',
                      style: SafeGoogleFont(
                        'Montserrat',
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: Text(
                          'Dr Shweta Jain - 2023 II',
                          style: SafeGoogleFont(
                            'Montserrat',
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 5),
                            child: Text(
                              'Aman Kumar',
                              style: SafeGoogleFont(
                                'Montserrat',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 5),
                            child: Text(
                              'Ojassvi Kumar',
                              style: SafeGoogleFont(
                                'Montserrat',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  WeekTile(
                    datefrom: '03/01/2023',
                    dateto: '09/01/2023',
                    weekname: 'Week 1',
                    remarks: 'Good!',
                    marksobtained: 'Marks Not Uploaded Yet',
                    flag: false,
                    buttonflag: true,
                    buttonOnPressed: () {},
                    buttontext: 'Add Marks',
                  ),
                  const WeekTile(
                    datefrom: '03/01/2023',
                    dateto: '09/01/2023',
                    weekname: 'Week 2',
                    remarks: 'Good!',
                    marksobtained: '97/100',
                    flag: true,
                  )
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return Expanded(
        child: Container(
          color: Color(0xff302c42),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                'No project found!',
                style: SafeGoogleFont(
                  'Montserrat',
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffffffff),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
