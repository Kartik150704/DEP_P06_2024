import 'package:flutter/material.dart';

import '../utilites.dart';

class ProjectTile extends StatelessWidget {
  final title,
      type,
      info,
      status,
      button_flag,
      button_text,
      theme,
      button2_flag,
      button2_text,
      isLink;
  var button_onPressed, button2_onPressed, title_onPressed;

  ProjectTile({
    Key? key,
    required this.title,
    required this.type,
    required this.info,
    this.status = '',
    this.button_flag = false,
    this.button_text = '',
    this.button_onPressed,
    this.theme = 'w',
    this.button2_flag = false,
    this.button2_text = '',
    this.button2_onPressed,
    this.title_onPressed,
    this.isLink = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topBarColor, lowerBarColor, lighttextcolor, darktextcolor;
    // black and white Color(0x3f000000), Color(0xff1a1d2d)
    // red Color(0xfff23936), Color(0xff902e2e)
    // green    Color(0xff7ae37b), Color(0xff45c646)
    // orange   Color(0xffe0c595), Color(0xfffabb18)
    switch (theme) {
      case 'w':
        topBarColor = const Color(0xff1a1d2d);
        lowerBarColor = const Color(0xffffffff);
        lighttextcolor = const Color(0xffffffff);
        darktextcolor = const Color(0xff000000);
        break;
      case 'r':
        topBarColor = const Color(0xff902e2e);
        lowerBarColor = const Color(0xfff23936);
        lighttextcolor = const Color(0xff000000);
        darktextcolor = const Color(0xff000000);
        break;
      case 'g':
        topBarColor = const Color(0xff45c646);
        lowerBarColor = const Color(0xff7ae37b);
        lighttextcolor = const Color(0xff000000);
        darktextcolor = const Color(0xff000000);
        break;
      case 'o':
        topBarColor = const Color(0xfffabb18);
        lowerBarColor = const Color(0xffe0c595);
        lighttextcolor = const Color(0xff000000);
        darktextcolor = const Color(0xff000000);
        break;
      default:
        topBarColor = const Color(0xff1a1d2d);
        lowerBarColor = const Color(0xffffffff);
        lighttextcolor = const Color(0xffffffff);
        darktextcolor = const Color(0xff000000);
    }
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30 * fem, vertical: 10 * fem),
      child: Container(
        // frame66FBH (222:111)
        // margin: EdgeInsets.fromLTRB(3 * fem, 0 * fem, 0 * fem, 22 * fem),
        padding: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 25 * fem),
        width: double.infinity,
        // height: 299 * fem,
        decoration: BoxDecoration(
          color: lowerBarColor,
          borderRadius: BorderRadius.circular(10 * fem),
          // boxShadow: [
          // BoxShadow(
          //   color: topBarColor,
          //   offset: Offset(0 * fem, 4 * fem),
          //   blurRadius: 2 * fem,
          // ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // frame68tk3 (222:113)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
              padding:
                  EdgeInsets.fromLTRB(59 * fem, 12 * fem, 27 * fem, 17 * fem),
              width: double.infinity,
              decoration: BoxDecoration(
                color: topBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10 * fem),
                  topRight: Radius.circular(10 * fem),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // projecttitlewiK (222:114)
                    // margin: EdgeInsets.fromLTRB(
                    //     0 * fem, 0 * fem, 514 * fem, 0 * fem),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: title_onPressed,
                            child: Text(
                              title,
                              style: SafeGoogleFont(
                                'Ubuntu',
                                fontSize: 45 * ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.2175 * ffem / fem,
                                color: (isLink ? Colors.blue : lighttextcolor),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            status,
                            style: SafeGoogleFont(
                              'Ubuntu',
                              fontSize: 20 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.2175 * ffem / fem,
                              color: lighttextcolor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // cp303R7h (223:123)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 6 * fem, 0 * fem, 0 * fem),
                    child: Text(
                      type,
                      textAlign: TextAlign.right,
                      style: SafeGoogleFont(
                        'Ubuntu',
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.2175 * ffem / fem,
                        color: lighttextcolor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroupshfhq6s (P7HrmYG8uJMz5NaSKDshFH)
              margin: EdgeInsets.fromLTRB(20 * fem, 0 * fem, 25 * fem, 0 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    info,
                    style: SafeGoogleFont(
                      'Ubuntu',
                      fontSize: 25 * ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.2175 * ffem / fem,
                      color: darktextcolor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      (button_flag)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                // frame70SsM (225:149)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 14 * fem, 0 * fem, 0 * fem),
                                child: TextButton(
                                  onPressed: button_onPressed,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Container(
                                    width: 127 * fem,
                                    height: 43 * fem,
                                    decoration: BoxDecoration(
                                      color: Color(0xff1a1d2d),
                                      borderRadius:
                                          BorderRadius.circular(10 * fem),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xff1a1d2d),
                                          offset: Offset(0 * fem, 4 * fem),
                                          // blurRadius: 2 * fem,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        button_text,
                                        style: SafeGoogleFont(
                                          'Ubuntu',
                                          fontSize: 10 * ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.2175 * ffem / fem,
                                          color: const Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      (button2_flag)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                // frame70SsM (225:149)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 14 * fem, 0 * fem, 0 * fem),
                                child: TextButton(
                                  onPressed: button2_onPressed,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Container(
                                    width: 127 * fem,
                                    height: 43 * fem,
                                    decoration: BoxDecoration(
                                      color: Color(0xff1a1d2d),
                                      borderRadius:
                                          BorderRadius.circular(10 * fem),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xff1a1d2d),
                                          offset: Offset(0 * fem, 4 * fem),
                                          // blurRadius: 2 * fem,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        button2_text,
                                        style: SafeGoogleFont(
                                          'Ubuntu',
                                          fontSize: 10 * ffem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.2175 * ffem / fem,
                                          color: const Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
