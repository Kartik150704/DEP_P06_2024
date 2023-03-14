import 'package:casper/utilites.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/textfield.dart';
import 'package:casper/components/button.dart';

class AddProjectForm extends StatefulWidget {
  final projectNameController,
      projectSemesterController,
      projectYearController,
      projectDescriptionController,
      onSubmit;

  AddProjectForm({
    super.key,
    this.projectNameController,
    this.projectSemesterController,
    this.projectYearController,
    this.projectDescriptionController,
    this.onSubmit,
  });

  @override
  State<AddProjectForm> createState() => _AddProjectFormState();
}

class _AddProjectFormState extends State<AddProjectForm> {
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
                'Enter the project name',
                style: SafeGoogleFont(
                  'Ubuntu',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff000000),
                ),
              ),
            ],
          ),
          CustomTextField(
            texteditingcontroller: widget.projectNameController,
            hinttext: 'Name',
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
                'Enter the project semester',
                style: SafeGoogleFont(
                  'Ubuntu',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff000000),
                ),
              ),
            ],
          ),
          CustomTextField(
            texteditingcontroller: widget.projectSemesterController,
            hinttext: 'Semester',
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
                'Enter the project year',
                style: SafeGoogleFont(
                  'Ubuntu',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff000000),
                ),
              ),
            ],
          ),
          CustomTextField(
            texteditingcontroller: widget.projectYearController,
            hinttext: 'Year',
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
                'Enter the project description',
                style: SafeGoogleFont(
                  'Ubuntu',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff000000),
                ),
              ),
            ],
          ),
          CustomTextField(
            texteditingcontroller: widget.projectDescriptionController,
            hinttext: 'Description',
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
