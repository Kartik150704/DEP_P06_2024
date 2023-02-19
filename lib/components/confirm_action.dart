import 'package:casper/utils.dart';
import 'package:flutter/material.dart';
import 'package:casper/components/button.dart';

class ConfirmAction extends StatefulWidget {
  final onSubmit;

  const ConfirmAction({
    super.key,
    this.onSubmit,
  });

  @override
  State<ConfirmAction> createState() => _ConfirmActionState();
}

class _ConfirmActionState extends State<ConfirmAction> {
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
                'Are you sure?',
                style: SafeGoogleFont(
                  'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff000000),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                buttonText: 'Yes',
                onPressed: widget.onSubmit,
              ),
              CustomButton(
                buttonText: 'No',
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
