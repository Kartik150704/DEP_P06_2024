import 'package:casper/data_tables/faculty/enrollment_request_data_table.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/confirm_action.dart';

class EnrollmentRequestsPageFaculty extends StatefulWidget {
  const EnrollmentRequestsPageFaculty({Key? key}) : super(key: key);

  @override
  State<EnrollmentRequestsPageFaculty> createState() =>
      _EnrollmentRequestsPageFacultyState();
}

class _EnrollmentRequestsPageFacultyState
    extends State<EnrollmentRequestsPageFaculty> {
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
    double fem = MediaQuery.of(context).size.width / baseWidth * 0.97;
    return Expanded(
      child: Container(
          color: Color(0xff302c42),
          child: ListView(
            children: [
              Container(
                height: 800,
                width: 1200 * fem,
                margin: EdgeInsets.fromLTRB(60, 30, 100 * fem, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                    ),
                    BoxShadow(
                      color: Color.fromARGB(255, 70, 67, 83),
                      spreadRadius: -3,
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: EnrollmentRequestDataTable(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
