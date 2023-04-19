import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddEventForm extends StatefulWidget {
  final List<String> events;
  const AddEventForm({
    super.key,
    required this.events,
  });

  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    List<String> vals = [];

    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const CustomisedText(
            text: 'Select the type of event you want to add',
            color: Colors.black,
            fontSize: 23,
          ),
          FormBuilderDropdown(
            name: 'event',
            items: widget.events
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: CustomisedText(
                        text: e,
                        color: Colors.grey[700],
                      ),
                    ))
                .toList(),
            validator: FormBuilderValidators.required(
                errorText: 'Type cannot be blank'),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomisedButton(
                width: 70,
                height: 50,
                text: 'Submit',
                onPressed: () {},
              ),
              CustomisedButton(
                width: 70,
                height: 50,
                text: 'Cancel',
                onPressed: () => {
                  Navigator.pop(context),
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
