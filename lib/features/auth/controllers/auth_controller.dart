import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/features/auth/pages/verify_phone_page.dart';
import '/features/onboarding/pages/account_setup_page.dart';
import '/features/root_app_page.dart';

class AuthController {
  static final _auth = FirebaseAuth.instance;

  static Future<void> sendOtp({
    required BuildContext context,
    required String phoneNumber,
    VoidCallback? onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (verificationId, forceResendingToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyPhonePage(
                phone: phoneNumber,
                verificationId: verificationId,
              ),
            ),
          );
        },
        verificationCompleted: (phoneAuthCredential) async {},
        verificationFailed: (error) {
          if (!context.mounted) return;
          onError?.call();
          debugPrint("from auth_controller $error");
          ScaffoldMessenger.of(context)
            ..hideCurrentMaterialBanner()
            ..showSnackBar(SnackBar(content: Text("${error.message}")));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      onError?.call();
      ScaffoldMessenger.of(context)
        ..hideCurrentMaterialBanner()
        ..showSnackBar(SnackBar(content: Text("${e.message}")));
    } catch (e) {
      onError?.call();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> verifyOtp(
      {required BuildContext context,
      required String otp,
      required String verificationId}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final user = await _auth.signInWithCredential(credential);
      if (!context.mounted) return;
      if (user.additionalUserInfo?.isNewUser == true) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountSetupPage(),
            ));
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const RootAppPage(),
            ),
            (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
