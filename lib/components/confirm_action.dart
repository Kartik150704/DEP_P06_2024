import 'package:casper/components/customised_button.dart';
import 'package:casper/comp/customised_text.dart';
import 'package:flutter/material.dart';

class ConfirmAction extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final text, onSubmit;

  const ConfirmAction({
    super.key,
    required this.onSubmit,
    this.text = '',
  });

  @override
  State<ConfirmAction> createState() => _ConfirmActionState();
}

class _ConfirmActionState extends State<ConfirmAction> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 450,
            child: CustomisedText(
              text: '${widget.text} Are you sure?',
              fontSize: 23,
              color: Colors.black,
            ),
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
                text: 'Yes',
                onPressed: widget.onSubmit,
              ),
              CustomisedButton(
                width: 70,
                height: 50,
                text: 'No',
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
  }
}
