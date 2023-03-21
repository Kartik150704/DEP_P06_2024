import 'package:casper/components/confirm_action.dart';
import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:flutter/material.dart';

class OfferingTile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final status, header, secondaryHeader, details, text, isStatus;

  const OfferingTile({
    super.key,
    required this.status,
    required this.header,
    required this.secondaryHeader,
    required this.details,
    required this.text,
    this.isStatus = false,
  });

  @override
  State<OfferingTile> createState() => _OfferingTileState();
}

class _OfferingTileState extends State<OfferingTile> {
  final parameters = [
    'Supervisor Name: ',
    'Semester: ',
    'Year: ',
    'Project Description: ',
  ];

  void confirmAction() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: ConfirmAction(
              text: widget.text,
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
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
      width: 850 * fem,
      // height: 250,
      decoration: BoxDecoration(
        color: (widget.status == '0'
            ? Colors.white
            : (widget.status == '1'
                ? const Color(0xfffabb18)
                : (widget.status == '2'
                    ? const Color(0xff45c646)
                    : const Color(0xfff23936)))),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 3,
            blurRadius: 20,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            width: 850 * fem,
            height: 80,
            decoration: BoxDecoration(
              color: (widget.status == '0'
                  ? const Color.fromARGB(255, 22, 25, 41)
                  : (widget.status == '1'
                      ? const Color(0xffe0c596)
                      : (widget.status == '2'
                          ? const Color(0xff7ae37b)
                          : const Color(0xff902e2e)))),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: CustomisedText(
                    text: widget.header,
                    fontSize: 40,
                    color: (widget.status == '0' ? Colors.white : Colors.black),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                  child: CustomisedText(
                    text: widget.secondaryHeader,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          for (int i = 0; i < parameters.length; i++) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: CustomisedText(
                text: parameters[i] + widget.details[i],
                fontSize: 25,
                color: const Color(0xff3f3f3f),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 25, 0),
            alignment: Alignment.bottomRight,
            child: CustomisedButton(
              width: 90,
              height: 50,
              text: (widget.isStatus ? 'Withdraw' : 'Apply'),
              onPressed: confirmAction,
            ),
          ),
        ],
      ),
    );
  }
}
