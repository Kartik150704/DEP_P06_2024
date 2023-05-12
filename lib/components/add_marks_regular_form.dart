import 'package:casper/components/customised_button.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:casper/components/form_custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// ignore: must_be_immutable
class AddMarksRegularForm extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final TextEditingController marksInputController, remarksInputController;
  final Function onSubmit;
  final bool isFaculty, status;
  final int totalMarks;

  AddMarksRegularForm({
    super.key,
    required this.marksInputController,
    required this.remarksInputController,
    required this.onSubmit,
    required this.isFaculty,
    required this.status,
    required this.totalMarks,
  });

  @override
  State<AddMarksRegularForm> createState() => _AddMarksRegularFormState();
}

class _AddMarksRegularFormState extends State<AddMarksRegularForm> {
  int status = 0;
  String? integerValidator(
      String? value, String fieldName, int lowerLimit, int higherLimit) {
    if (value == null) {
      return 'Please enter valid $fieldName';
    }

    int? val = int.tryParse(value);
    if (val == null) {
      return 'Please enter valid $fieldName';
    } else if (val > higherLimit || val < lowerLimit) {
      return 'Please enter valid $fieldName';
    }
    return null;
  }

  InputDecoration getDecoration(String hintText) {
    return InputDecoration(
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (status == 1) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      );
    } else if (status == 2) {
      return const FormCustomText(
        text: 'Marks uploaded successfully',
      );
    }

    final formKey = GlobalKey<FormBuilderState>();
    if (widget.status || widget.isFaculty) {
      return FormBuilder(
        key: formKey,
        child: Column(
          children: [
            CustomisedText(
              text: 'Enter the marks out of ${widget.totalMarks}',
              color: const Color(0xff000000),
            ),
            const SizedBox(
              height: 20,
            ),
            FormBuilderTextField(
              name: 'marks',
              validator: (value) {
                return integerValidator(value, 'marks', 0, widget.totalMarks);
              },
              cursorColor: Colors.black,
              decoration: getDecoration('Marks'),
              controller: widget.marksInputController,
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomisedText(
              text: 'Enter the remarks',
              color: Color(0xff000000),
            ),
            const SizedBox(
              height: 20,
            ),
            FormBuilderTextField(
              name: 'remarks',
              validator: FormBuilderValidators.required(
                errorText: 'Please enter a remark',
              ),
              cursorColor: Colors.black,
              decoration: getDecoration('Remarks'),
              controller: widget.remarksInputController,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomisedButton(
                  width: 80,
                  text: 'Submit',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        status = 1;
                      });

                      widget.onSubmit();

                      setState(() {
                        status = 2;
                      });
                    }
                  },
                  height: 50,
                ),
                CustomisedButton(
                  width: 80,
                  height: 50,
                  text: 'Cancel',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
