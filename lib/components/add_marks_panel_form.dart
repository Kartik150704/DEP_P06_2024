import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/components/form_custom_text.dart';
import 'package:casper/data_tables/faculty/faculty_panel_teams_data_table.dart';
import 'package:casper/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// ignore: must_be_immutable
class EvaluationSubmissionForm extends StatefulWidget {
  final int totalMarks;

  // ignore: prefer_typing_uninitialized_variables
  final StudentData1 studentdata;
  Function? updateEvaluation;

  EvaluationSubmissionForm({
    super.key,
    required this.studentdata,
    // TODO: Make this required
    this.totalMarks = 30,
    this.updateEvaluation,
  });

  @override
  State<EvaluationSubmissionForm> createState() =>
      _EvaluationSubmissionFormState();
}

class _EvaluationSubmissionFormState extends State<EvaluationSubmissionForm> {
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

  final _formKey = GlobalKey<FormBuilderState>();
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

    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CustomisedText(
            text: 'Enter the marks out of ${widget.totalMarks}',
            color: const Color(0xff000000),
          ),
          const SizedBox(
            height: 20,
          ),
          FormBuilderTextField(
            name: 'studentMarks',
            cursorColor: Colors.black,
            decoration: getDecoration('Marks'),
            validator: (value) {
              return integerValidator(value, 'marks', 0, widget.totalMarks);
            },
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
            // TODO: This is dummy, get it from parent page
            controller: TextEditingController(),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomisedButton(
                text: 'Submit',
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    setState(() {
                      status = 1;
                    });

                    var data = _formKey.currentState!.value;
                    await FirebaseFirestore.instance
                        .collection('evaluations')
                        .doc(widget.studentdata.evaluationObject.id)
                        .get()
                        .then((evaluationDoc) async {
                      if (evaluationDoc.exists) {
                        var doc = evaluationDoc.data() as Map<String, dynamic>;
                        if (widget.studentdata.evaluationObject.type ==
                            'MidTerm') {
                          var midsemEvaluation = doc['midsem_evaluation'];
                          midsemEvaluation[widget
                                  .studentdata.evaluationObject.panelIndex][
                              widget.studentdata.evaluationObject.student
                                  .entryNumber] = data['studentMarks'];
                          await FirebaseFirestore.instance
                              .collection('evaluations')
                              .doc(widget.studentdata.evaluationObject.id)
                              .update({
                            'midsem_evaluation': midsemEvaluation,
                          }).then((value) {
                            Evaluation newEvaluation =
                                widget.studentdata.evaluationObject;
                            newEvaluation.marks =
                                double.parse(data['studentMarks']);
                            newEvaluation.done = true;
                            widget.updateEvaluation!(newEvaluation);
                          });
                        } else if (widget.studentdata.evaluationObject.type ==
                            'EndTerm') {
                          var endsemEvaluation = doc['endsem_evaluation'];
                          endsemEvaluation[widget
                                  .studentdata.evaluationObject.panelIndex][
                              widget.studentdata.evaluationObject.student
                                  .entryNumber] = data['studentMarks'];
                          await FirebaseFirestore.instance
                              .collection('evaluations')
                              .doc(widget.studentdata.evaluationObject.id)
                              .update({
                            'endsem_evaluation': endsemEvaluation,
                          }).then((value) {
                            Evaluation newEvaluation =
                                widget.studentdata.evaluationObject;
                            newEvaluation.marks =
                                double.parse(data['studentMarks']);
                            newEvaluation.done = true;
                            widget.updateEvaluation!(newEvaluation);
                          });
                        } else {
                          print(
                              'evaluation_submission_form.dart: evaluation type is not MidTerm or EndTerm');
                        }
                      } else {
                        print(
                            'evaluation_submission_form.dart: evaluation doc does not exist');
                      }
                    });

                    setState(() {
                      status = 2;
                    });
                  }
                },
                height: 50,
                width: 70,
              ),
              CustomisedButton(
                text: 'Cancel',
                onPressed: () => {
                  Navigator.pop(context),
                },
                height: 50,
                width: 70,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
