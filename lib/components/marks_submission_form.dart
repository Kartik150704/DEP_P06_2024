import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/customised_text_field.dart';
import 'package:flutter/material.dart';

class MarksSubmissionForm extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final marksInputController, marksConfirmInputController, onSubmit;

  const MarksSubmissionForm({
    super.key,
    this.marksInputController,
    this.marksConfirmInputController,
    this.onSubmit,
  });

  @override
  State<MarksSubmissionForm> createState() => _MarksSubmissionFormState();
}

class _MarksSubmissionFormState extends State<MarksSubmissionForm> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 198, 189, 207),
      ),
      width: 350 * fem,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
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
            hintText: "Marks",
            obscureText: false,
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(45 * fem, 0, 0, 0),
            child: const CustomisedText(
              text: 'Confirm Obtained Marks',
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          CustomisedTextField(
            textEditingController: widget.marksConfirmInputController,
            hintText: "Confirm Marks",
            obscureText: false,
          ),
          const SizedBox(
            height: 40,
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
            height: 10,
          ),
        ],
      ),
    );
  }
}
