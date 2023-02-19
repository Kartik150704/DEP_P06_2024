import 'package:casper/components/button.dart';
import 'package:casper/utils.dart';
import 'package:flutter/cupertino.dart';

class WeekTile extends StatelessWidget {
  final weekname,
      datefrom,
      dateto,
      marksobtained,
      remarks,
      flag,
      buttonflag,
      buttontext,
      buttonOnPressed;

  // final topbartext, topbarrighttext, bottomtext
  const WeekTile({
    Key? key,
    required this.weekname,
    required this.datefrom,
    required this.dateto,
    required this.remarks,
    required this.marksobtained,
    required this.flag,
    this.buttonflag = false,
    this.buttontext,
    this.buttonOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30 * fem, vertical: 10 * fem),
      child: Container(
        margin: EdgeInsets.fromLTRB(3 * fem, 0 * fem, 0 * fem, 22 * fem),
        padding: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 51 * fem),
        decoration: BoxDecoration(
          color: (flag) ? const Color(0xff45c646) : const Color(0xfffabb18),
          borderRadius: BorderRadius.circular(10 * fem),
          boxShadow: [
            BoxShadow(
              color: Color(0x3f000000),
              offset: Offset(0 * fem, 4 * fem),
              blurRadius: 2 * fem,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // frame68NPV (210:160)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 16 * fem),
              padding:
                  EdgeInsets.fromLTRB(59 * fem, 12 * fem, 30 * fem, 11 * fem),
              width: double.infinity,
              decoration: BoxDecoration(
                color: (flag) ? Color(0xff7ae37b) : Color(0xffe0c595),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10 * fem),
                  topRight: Radius.circular(10 * fem),
                ),
              ),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      weekname,
                      style: SafeGoogleFont(
                        'Montserrat',
                        fontSize: 50 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.2175 * ffem / fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Text(
                    // v3d (212:170)
                    '$datefrom - $dateto',
                    style: SafeGoogleFont(
                      'Montserrat',
                      fontSize: 20 * ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.2175 * ffem / fem,
                      color: Color(0xff12141d),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // marksobtained97100Snf (212:168)
              margin: EdgeInsets.fromLTRB(20 * fem, 0 * fem, 0 * fem, 8 * fem),
              child: Text(
                'Marks Obtained - $marksobtained',
                style: SafeGoogleFont(
                  'Montserrat',
                  fontSize: 25 * ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.2175 * ffem / fem,
                  color: Color(0xff3f3f3f),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // remarksnoneWnX (212:169)
                  margin:
                      EdgeInsets.fromLTRB(20 * fem, 0 * fem, 0 * fem, 0 * fem),
                  child: Text(
                    'Remarks - $remarks',
                    style: SafeGoogleFont(
                      'Montserrat',
                      fontSize: 25 * ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.2175 * ffem / fem,
                      color: Color(0xff3f3f3f),
                    ),
                  ),
                ),
                (buttonflag)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomButton(
                            buttonText: buttontext, onPressed: buttonOnPressed),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
