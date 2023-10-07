import 'dart:async';
import 'dart:developer';
import 'package:book_store_admin/router/route_name.dart';
import 'package:book_store_admin/utils/show_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../server/reference.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../utils/constant.dart';

class AdminLoginController extends GetxController {
  final box = Hive.box(loginBox);

  RxMap<String, dynamic> currentUser = <String, dynamic>{}.obs;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _streamSubscription;

  Future<void> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
      await FirebaseAuth.instance.signInWithPopup(googleProvider);
      box.put(isAuthenticatedKey, true);
      Get.toNamed(authorizeCheckRoute);
    } catch (e) {
      log("=======Google Signin Error: $e");
      errorSnap("$e");
    }
  }

  @override
  void onInit() {
    FirebaseAuth.instance.userChanges().listen((User? user) async {
      if (user == null) {
        currentUser.value = {};
        log('------------User is currently signed out!');
      } else {
        //Check if doc already exists
        final result = await FirebaseReference.userDocument(user.uid).get();
        //if not exists,insert
        if (!result.exists) {
          final item = {
            "id": user.uid,
            "name": user.displayName,
            "image": user.photoURL,
            "email": user.email,
            "status": 0,
          };
          await FirebaseReference.userDocument(user.uid).set(item);
        }
        //listen document
        if (!(_streamSubscription == null)) _streamSubscription?.cancel();
        _streamSubscription = FirebaseReference.userDocument(user.uid)
            .snapshots()
            .listen((event) {
          if (!(event.data() == null)) {
            currentUser.value = event.data()!;
            log("=======User: ${currentUser.toString()}");
          }
        });
      }
    });
    super.onInit();
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      box.put(isAuthenticatedKey, false);
      currentUser.value = {};
      Get.toNamed(adminLoginRoute);
    } catch (e) {
      log("=====Error: $e");
    }
  }
}
