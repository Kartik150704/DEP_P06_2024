import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/customised_text_field.dart';
import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';

class MarksSubmissionForm extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final marksInputController, marksConfirmInputController, onSubmit, evaluation;

  const MarksSubmissionForm({
    super.key,
    this.marksInputController,
    this.marksConfirmInputController,
    this.onSubmit,
    this.evaluation,
  });

  @override
  State<MarksSubmissionForm> createState() => _MarksSubmissionFormState();
}

class _MarksSubmissionFormState extends State<MarksSubmissionForm> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

    if (widget.evaluation.status == '1') {
      return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 198, 189, 207),
        ),
        width: 350 * fem,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20 * fem, 0, 0, 0),
              child: CustomisedText(
                text: widget.evaluation.week,
                color: Colors.black,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(45 * fem, 0, 0, 0),
              child: const CustomisedText(
                text: 'Enter Obtained Marks',
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            CustomisedTextField(
              textEditingController: widget.marksInputController,
              hintText: 'Marks',
              obscureText: false,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(45 * fem, 0, 0, 0),
              child: const CustomisedText(
                text: 'Enter Remarks',
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            CustomisedTextField(
              textEditingController: widget.marksConfirmInputController,
              hintText: 'Remarks',
              obscureText: false,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomisedButton(
                  width: 80,
                  height: 50,
                  text: 'Submit',
                  onPressed: () => {},
                ),
                CustomisedButton(
                  width: 80,
                  height: 50,
                  text: 'Cancel',
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      );
    } else {
      return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 198, 189, 207),
        ),
        width: 350 * fem,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20 * fem, 0, 0, 0),
              child: CustomisedText(
                text: widget.evaluation.week,
                color: Colors.black,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(35 * fem, 0, 0, 0),
              child: const CustomisedText(
                text: 'Marks Obtained',
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(37 * fem, 0, 0, 0),
              child: SelectionArea(
                child: Text(
                  widget.evaluation.marks,
                  textAlign: TextAlign.start,
                  style: SafeGoogleFont(
                    'Ubuntu',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                  softWrap: true,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(35 * fem, 0, 0, 0),
              child: const CustomisedText(
                text: 'Remarks',
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(37 * fem, 0, 0, 0),
              child: SelectionArea(
                child: Text(
                  widget.evaluation.remarks,
                  textAlign: TextAlign.start,
                  style: SafeGoogleFont(
                    'Ubuntu',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                  softWrap: true,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    }
  }
}
