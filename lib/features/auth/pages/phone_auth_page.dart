import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../controllers/auth_controller.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  String phoneNumber = "";
  bool loading = false;

  Future<void> sendOtp() async {
    setState(() {
      loading = true;
    });
    AuthController.sendOtp(
      context: context,
      phoneNumber: "+233$phoneNumber",
      onError: () {
        setState(() {
          loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var disableBtn = phoneNumber.length != 10 || loading;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: mediaQuery.size.height * 0.2, left: 16, right: 16),
          child: Center(
            child: Column(
              children: [
                Text(
                  "Enter Your Phone Number",
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: const Text(
                    "We will send you a verification code to this phone number",
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(IconlyLight.call),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.maxFinite,
                  child: FilledButton.icon(
                    onPressed: disableBtn ? null : sendOtp,
                    label: loading ? const CupertinoActivityIndicator() : const Text("Continue"),
                    icon: loading ? const SizedBox.shrink() : const Icon(IconlyBold.arrowRight),
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
