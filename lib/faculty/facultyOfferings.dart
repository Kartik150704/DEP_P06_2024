import 'package:casper/components/customised_sidebar_button.dart';
import 'package:casper/faculty/enrollmentRequestsFaculty.dart';
import 'package:casper/faculty/faculty_logged_in_scaffold.dart';
import 'package:casper/faculty/offeringsPageFaculty.dart';
import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FacultyOfferings extends StatefulWidget {
  final role;

  const FacultyOfferings({Key? key, required this.role}) : super(key: key);

  @override
  State<FacultyOfferings> createState() => _FacultyOfferingsState();
}

class _FacultyOfferingsState extends State<FacultyOfferings> {
  void onPressed() {}
  dynamic shownpage;
  var option;

  var options = ['Projects', 'Enrollmet Requests'];

  void selectOption(opt) {
    setState(() {
      option = opt;
      if (option == 1) {
        shownpage = OfferingsPageFaculty();
      } else {
        shownpage = EnrollmentRequestsPageFaculty();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    option = 1;
    shownpage = OfferingsPageFaculty();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = MediaQuery.of(context).size.width / baseWidth * 0.97;
    return FacultyLoggedInScaffold(
      role: widget.role,
      scaffoldbody: Row(
        children: [
          Container(
            width: 300 * fem,
            color: Color(0xff545161),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < options.length; i++) ...[
                      CustomisedSidebarButton(
                        text: options[i],
                        isSelected: (option == (i + 1)),
                        onPressed: () => selectOption(i + 1),
                      )
                    ],
                  ],
                ),
              ],
            ),
          ),
          shownpage,
        ],
      ),
    );
  }
}
