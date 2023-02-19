import 'package:casper/components/button.dart';
import 'package:flutter/material.dart';

import '../components/projecttile.dart';
import '../utils.dart';

class PanelPage extends StatelessWidget {
  final name, type, year, semester;
  final role;

  const PanelPage(
      {Key? key,
      required this.name,
      required this.type,
      required this.year,
      required this.semester,
      this.role = 'su'})
      : super(key: key);

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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Text(
                    'Panel A',
                    style: SafeGoogleFont(
                      'Montserrat',
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: SizedBox(
                    // height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$type = $year $semester',
                          style: SafeGoogleFont(
                            'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffffffff),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'EVALUATOR 1',
                                  style: SafeGoogleFont(
                                    'Montserrat',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                Text(
                                  'EVALUATOR 2',
                                  style: SafeGoogleFont(
                                    'Montserrat',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                Text(
                                  'EVALUATOR 3',
                                  style: SafeGoogleFont(
                                    'Montserrat',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                (role == 'co')
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        child: CustomButton(
                            buttonText: 'Add Team', onPressed: () {}),
                      )
                    : Container(),
                ProjectTile(
                  info:
                      'Project Title - TITLE\nProject Description - DESCRIPTION\nMember 1 Name - NAME\n Member 1 Marks - MARKS\nMember 1 Remarks - NA\nMember 2 Name - NAME\n Member 2 Marks - MARKS\nMember 2 Remarks - NA',
                  title: 'TEAM A',
                  title_onPressed: () {},
                  type: '',
                  theme: 'o',
                  button_flag: true,
                  button_text: 'Upload Marks',
                  button_onPressed: () {},
                ),
                ProjectTile(
                  info:
                      'Project Title - TITLE\nProject Description - DESCRIPTION\nMember 1 Name - NAME\n Member 1 Marks - MARKS\nMember 1 Remarks - NA\nMember 2 Name - NAME\n Member 2 Marks - MARKS\nMember 2 Remarks - NA',
                  title: 'TEAM B',
                  title_onPressed: () {},
                  type: '',
                  theme: 'o',
                  button_flag: true,
                  button_text: 'Upload Marks',
                  button_onPressed: () {},
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
