import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/textfield.dart';
import 'package:casper/components/button.dart';

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
    return SizedBox(
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Text(
                'Enter Obtained Marks',
                style: SafeGoogleFont(
                  'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff000000),
                ),
              ),
            ],
          ),
          CustomTextField(
            texteditingcontroller: widget.marksInputController,
            hinttext: 'Marks',
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Text(
                'Confirm Obtained Marks',
                style: SafeGoogleFont(
                  'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff000000),
                ),
              ),
            ],
          ),
          CustomTextField(
            texteditingcontroller: widget.marksConfirmInputController,
            hinttext: 'Confirm Marks',
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                buttonText: 'Submit',
                onPressed: widget.onSubmit,
              ),
              CustomButton(
                buttonText: 'Cancel',
                onPressed: () => {
                  Navigator.pop(context),
                },
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
