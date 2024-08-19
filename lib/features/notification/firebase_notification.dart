import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMFunctions {
  static Future<void> retrieveAndSaveFCMToken() async {
    try {
      final notificationSettings =
          await FirebaseMessaging.instance.requestPermission(provisional: true);
      if (notificationSettings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        FirebaseMessaging.instance.getToken().then((value) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            FirebaseFirestore.instance
                .collection("fcm")
                .doc(user.uid)
                .set({"token": value});
          }
        });
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  static Future<void> updateFCMToken(String token) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance
            .collection("fcm")
            .doc(user.uid)
            .set({"token": token});
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
