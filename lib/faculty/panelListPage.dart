import 'package:casper/components/button.dart';
import 'package:casper/components/confirm_action.dart';
import 'package:casper/faculty/panelPage.dart';
import 'package:flutter/material.dart';

import '../components/projecttile.dart';
import '../utilites.dart';
import 'loggedinscaffoldFaculty.dart';

class PanelPageFaculty extends StatefulWidget {
  final role;

  const PanelPageFaculty({Key? key, required this.role}) : super(key: key);

  @override
  State<PanelPageFaculty> createState() => _PanelPageFacultyState();
}

class _PanelPageFacultyState extends State<PanelPageFaculty> {
  void confirmAction() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: ConfirmAction(
              onSubmit: () {},
            ),
          ),
        );
      },
    );
  }

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
                    (widget.role == 'co')
                        ? CustomButton(
                            buttonText: 'Add Panel',
                            onPressed: () {},
                          )
                        : Container(),
                  ],
                ),
                (widget.role == 'co')
                    ? ProjectTile(
                        info:
                            'Number of Evaluations - NUMBER\nNumber of Teams Assigned - NUMBER\nNumber of evaluations completed - NUMBER',
                        title: 'Panel A',
                        title_onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoggedInScaffoldFaculty(
                                  role: widget.role,
                                  scaffoldbody: Row(
                                    children: [
                                      PanelPage(
                                        name: 'Panel A',
                                        type: 'Mid-Term',
                                        year: '2023',
                                        semester: '||',
                                        role: widget.role,
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
                        button_onPressed: confirmAction,
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
                                  role: widget.role,
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
