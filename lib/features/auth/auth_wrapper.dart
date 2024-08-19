import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/features/onboarding/pages/onboarding_page.dart';
import '/features/root_app_page.dart';

// class AuthWrapper extends ConsumerWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return StreamBuilder(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator.adaptive());
//         }

//         if (snapshot.hasData) {
//           return _checkAndFetchWorkshopDetails(context, ref);
//         }

//         return const OnboardingPage();
//       },
//     );
//   }

//   Widget _checkAndFetchWorkshopDetails(BuildContext context, WidgetRef ref) {
//     final appUserData = ref.watch(appUserDataProvider);
//     if (appUserData.name.isEmpty) {
//       return FutureBuilder(
//         future: fetchWorkshopDetailsAndUser(context, ref),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//                 body: Center(child: CircularProgressIndicator.adaptive()));
//           }

//           if (snapshot.connectionState == ConnectionState.done) {
//             if (snapshot.hasData) {
//               return const RootAppPage();
//             } else if (snapshot.hasError) {
//               return Scaffold(
//                 body: Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset('assets/failed.png'),
//                       const Padding(
//                         padding: EdgeInsets.all(16.0),
//                         child: Text(
//                             textAlign: TextAlign.center,
//                             "Oops an error occured, check your internet connection and retry"),
//                       ),
//                       FilledButton(
//                           onPressed: () => Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => const PhoneAuthPage()),
//                               (route) => false),
//                           child: const Text("Retry"))
//                     ],
//                   ),
//                 ),
//               );
//             }
//           }

//           return const Scaffold();
//         },
//       );
//     }

//     return const RootAppPage();
//   }
// }

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
