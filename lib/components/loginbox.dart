import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:casper/utils.dart';

class LoginBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      // frame66V4f (225:317)
      margin: EdgeInsets.fromLTRB(376 * fem, 0 * fem, 376 * fem, 0 * fem),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(30 * fem),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2 * fem,
            sigmaY: 2 * fem,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // frame68jDu (225:318)
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 36 * fem),
                width: 691 * fem,
                height: 97 * fem,
                decoration: BoxDecoration(
                  color: Color(0xff1a1e2e),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10 * fem),
                    topRight: Radius.circular(10 * fem),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Welcome To Casper',
                    style: SafeGoogleFont(
                      'Montserrat',
                      fontSize: 45 * ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.2175 * ffem / fem,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
              Container(
                // usernameX9m (225:332)
                margin:
                    EdgeInsets.fromLTRB(115 * fem, 0 * fem, 0 * fem, 0 * fem),
                child: Text(
                  'Username',
                  style: SafeGoogleFont(
                    'Montserrat',
                    fontSize: 25 * ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.2175 * ffem / fem,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Container(
                // autogroupp38ezp3 (4avAeHtaWdjMVGcNF4P38e)
                padding: EdgeInsets.fromLTRB(
                    115 * fem, 9 * fem, 115 * fem, 34 * fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // frame71J43 (225:328)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 20 * fem),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10 * fem),
                        border: Border.all(color: Color(0xff000000)),
                        color: Color(0xffe1e3e8),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(
                              17 * fem, 13 * fem, 17 * fem, 13 * fem),
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
                    Container(
                      // passwordtnw (225:338)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 331 * fem, 9 * fem),
                      child: Text(
                        'Password',
                        style: SafeGoogleFont(
                          'Montserrat',
                          fontSize: 25 * ffem,
                          fontWeight: FontWeight.w700,
                          height: 1.2175 * ffem / fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // frame72mbq (225:336)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 60 * fem),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10 * fem),
                        border: Border.all(color: Color(0xff000000)),
                        color: Color(0xffe1e3e8),
                      ),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(
                              17 * fem, 13 * fem, 17 * fem, 13 * fem),
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
                    Container(
                      // frame70zzP (225:325)
                      margin: EdgeInsets.fromLTRB(
                          166 * fem, 0 * fem, 165 * fem, 0 * fem),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 43 * fem,
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
                                fontSize: 10 * ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.2175 * ffem / fem,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
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
    );
  }
}
