import 'package:casper/components/customised_button.dart';
import 'package:casper/components/customised_text.dart';
import 'package:casper/utilites.dart';
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
    double baseWidth = 1440;
    double fem = (MediaQuery.of(context).size.width / baseWidth) * 0.97;

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
              Container(
                width: 250 * fem,
                margin: EdgeInsets.fromLTRB(25 * fem, 0, 0, 0),
                child: Text(
                  'Are you sure? ${widget.text}',
                  textAlign: TextAlign.center,
                  style: SafeGoogleFont(
                    'Ubuntu',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                // CustomisedText(
                //   text: 'Are you sure? ${widget.text}',
                //   color: Colors.black,
                // ),
              ),
            ],
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
                onPressed: () => {},
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
