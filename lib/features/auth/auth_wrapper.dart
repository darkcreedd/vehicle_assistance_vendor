import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/features/onboarding/pages/onboarding_page.dart';
import '/features/root_app_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (snapshot.hasData) {
          return const RootAppPage();
        }
        return const OnboardingPage();
      },
    );
  }
}
