import 'package:dummyjson/core/theme/colors.dart';
import 'package:flutter/material.dart';

import 'package:pinput/pinput.dart';

class PinputField extends StatefulWidget {
  final int length;
  final TextEditingController pinController;
  const PinputField({
    super.key,
    required this.length,
    required this.pinController,
  });

  @override
  State<PinputField> createState() => _PinputFieldState();
}

class _PinputFieldState extends State<PinputField> {
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 70,
      height: 70,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
      color: primaryColor,
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(color: primaryColor),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.red,
        border: Border.all(color: Colors.red),
      ),
    );

    return Directionality(
      // Specify direction if desired
      textDirection: TextDirection.ltr,
      child: Form(
        key: formKey,
        child: Pinput(
          length: widget.length,
          controller: widget.pinController,
          focusNode: focusNode,
          // smsRetriever: ,
          separatorBuilder: (index) {
            return Container(
              color: Colors.black,
              width: widget.length == 5 ? 10 : 25,
            );
          },
          showCursor: true,

          //androidSmsAutofillMethod:AndroidSmsAutofillMethod.smsUserConsentApi,
          //  listenForMultipleSmsOnAndroid: true,
          validator: (value) {
            return null;
          },

          // onClipboardFound: (value) {
          //   debugPrint('onClipboardFound: $value');
          //   pinController.setText(value);
          // },
          hapticFeedbackType: HapticFeedbackType.heavyImpact,
          onCompleted: (pin) {},
          onChanged: (value) {
            debugPrint('onChanged: $value');
          },
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 9),
                width: 22,
                height: 2,
                color: Colors.white,
              ),
            ],
          ),

          defaultPinTheme: defaultPinTheme,
          submittedPinTheme: submittedPinTheme,
          focusedPinTheme: focusedPinTheme,
          errorPinTheme: errorPinTheme,
          followingPinTheme: defaultPinTheme,
        ),
      ),
    );
  }
}
