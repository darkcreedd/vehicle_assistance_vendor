import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:pinput/pinput.dart';
import '/features/auth/controllers/auth_controller.dart';

class VerifyPhonePage extends StatefulWidget {
  const VerifyPhonePage(
      {super.key, required this.phone, required this.verificationId});

  final String phone;

  final String verificationId;

  @override
  State<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  String otp = "";

  bool loading = false;

  Future<void> verifyOtp() async {
    setState(() {
      loading = true;
    });
    AuthController.verifyOtp(
        context: context, otp: otp, verificationId: widget.verificationId);
  }

  @override
  Widget build(BuildContext context) {
    var disableBtn = otp.length != 6 || loading;

    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      textStyle: theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(6),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: theme.colorScheme.primary),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: theme.colorScheme.primary.withOpacity(0.1),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              top: mediaQuery.size.height * 0.2, left: 16, right: 16),
          child: Center(
            child: Column(
              children: [
                Text(
                  "Verify Phone Number",
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    "We sent a 6 digit verification code to [${widget.phone}]",
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Pinput(
                  length: 6,
                  onChanged: (value) {
                    setState(() {
                      otp = value;
                    });
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.maxFinite,
                  child: FilledButton.icon(
                    onPressed: disableBtn ? null : verifyOtp,
                    label: loading
                        ? const CupertinoActivityIndicator()
                        : const Text("Verify"),
                    icon: loading
                        ? const SizedBox.shrink()
                        : const Icon(IconlyBold.arrowRight),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Back",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
