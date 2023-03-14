import 'package:casper/components/button.dart';
import 'package:casper/faculty/panelPage.dart';
import 'package:flutter/material.dart';

import '../components/projecttile.dart';
import '../utilites.dart';
import 'loggedinscaffoldFaculty.dart';

class PanelPageFaculty extends StatelessWidget {
  final role;

  const PanelPageFaculty({Key? key, this.role = 'su'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Expanded(
      child: Container(
        color: const Color(0xff302c42),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Text(
                        'Panels',
                        style: SafeGoogleFont(
                          'Ubuntu',
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xffffffff),
                        ),
                      ),
                    ),
                    (role == 'co')
                        ? CustomButton(
                            buttonText: 'Add Panel',
                            onPressed: () {},
                          )
                        : Container(),
                  ],
                ),
                (role == 'co')
                    ? ProjectTile(
                        info:
                            'Number of Evaluations - NUMBER\nNumber of Teams Assigned - NUMBER\nNumber of evaluations completed - NUMBER',
                        title: 'Panel A',
                        title_onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoggedInScaffoldFaculty(
                                  scaffoldbody: Row(
                                children: [
                                  PanelPage(
                                    name: 'Panel A',
                                    type: 'Mid-Term',
                                    year: '2023',
                                    semester: '||',
                                    role: role,
                                  ),
                                ],
                              )),
                            ),
                          );
                        },
                        type: 'Mid-term',
                        theme: 'w',
                        button_flag: true,
                        button_text: 'Delete Panel',
                        isLink: true,
                      )
                    : ProjectTile(
                        info:
                            'Number of Evaluations - NUMBER\nNumber of Teams Assigned - NUMBER\nNumber of evaluations completed - NUMBER',
                        title: 'Panel A',
                        title_onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoggedInScaffoldFaculty(
                                  scaffoldbody: Row(
                                children: const [
                                  PanelPage(
                                      name: 'Panel A',
                                      type: 'Mid-Term',
                                      year: '2023',
                                      semester: '||'),
                                ],
                              )),
                            ),
                          );
                        },
                        type: 'Mid-term',
                        theme: 'w',
                        button_flag: false,
                        isLink: true,
                      ),
                const SizedBox(
                  height: 100,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
