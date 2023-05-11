import 'package:casper/components/customised_button.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../data_tables/faculty/faculty_enrollments_data_table.dart';
import '../data_tables/faculty/faculty_panel_teams_data_table.dart';
import '../models/models.dart';

class EvaluationSubmissionForm extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final StudentData1 studentdata;
  Function? updateEvaluation;

  EvaluationSubmissionForm({
    super.key,
    required this.studentdata,
    this.updateEvaluation,
  });

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    Student student = studentdata.student;
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 500,
            child: CustomisedText(
              text: 'Enter marks for ${student.name}',
              color: Colors.black,
              fontSize: 23,
            ),
          ),
          FormBuilderTextField(
            name: 'studentMarks',
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              hintText: 'Marks',
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomisedButton(
                text: 'Upload',
                onPressed: () async {
                  print('Evaluation doc ${studentdata.evaluationObject.id}');
                  print(studentdata.evaluationObject.type);
                  if (_formKey.currentState!.saveAndValidate()) {
                    var data = _formKey.currentState!.value;
                    await FirebaseFirestore.instance
                        .collection('evaluations')
                        .doc(studentdata.evaluationObject.id)
                        .get()
                        .then((evaluationDoc) async {
                      if (evaluationDoc.exists) {
                        var doc = evaluationDoc.data() as Map<String, dynamic>;
                        if (studentdata.evaluationObject.type == 'MidTerm') {
                          var midsem_evaluation = doc['midsem_evaluation'];
                          midsem_evaluation[
                                  studentdata.evaluationObject.panelIndex][
                              studentdata.evaluationObject.student
                                  .entryNumber] = data['studentMarks'];
                          await FirebaseFirestore.instance
                              .collection('evaluations')
                              .doc(studentdata.evaluationObject.id)
                              .update({
                            'midsem_evaluation': midsem_evaluation,
                          }).then((value) {
                            // print(value);
                            print('done');
                            Evaluation newEvaluation =
                                studentdata.evaluationObject;
                            newEvaluation.marks =
                                double.parse(data['studentMarks']);
                            newEvaluation.done = true;
                            updateEvaluation!(newEvaluation);
                          });
                        } else if (studentdata.evaluationObject.type ==
                            'EndTerm') {
                          var endsem_evaluation = doc['endsem_evaluation'];
                          endsem_evaluation[
                                  studentdata.evaluationObject.panelIndex][
                              studentdata.evaluationObject.student
                                  .entryNumber] = data['studentMarks'];
                          await FirebaseFirestore.instance
                              .collection('evaluations')
                              .doc(studentdata.evaluationObject.id)
                              .update({
                            'endsem_evaluation': endsem_evaluation,
                          }).then((value) {
                            // print(value);
                            print('done');
                            Evaluation newEvaluation =
                                studentdata.evaluationObject;
                            newEvaluation.marks =
                                double.parse(data['studentMarks']);
                            newEvaluation.done = true;
                            updateEvaluation!(newEvaluation);
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
                  }
                  Navigator.pop(context);
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
