import 'dart:developer';
import 'package:book_store_admin/model/purchase.dart';
import 'package:book_store_admin/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../server/reference.dart';
import '../utils/func.dart';

class OrderController extends GetxController {
  final debouncer = Debouncer(milliseconds: 800);
  var newOrderCount = 0.obs;
  var selectedToggle = false.obs;
  RxList<PurchaseModel> searchItems = <PurchaseModel>[].obs;

  RxList<PurchaseModel> purchaseModels = <PurchaseModel>[].obs;
  Rxn<PurchaseModel> selectedPurchaseModel = Rxn<PurchaseModel>();
  var toggleActive = false.obs;
  var animateToggle = false.obs;
  void changeToggleActive() {
    toggleActive.value = !toggleActive.value;
  }

  Future<void> makeSeenOrNot(PurchaseModel v) async {
    if (v.status == 0) {
      //we need to update status to 1 (or) value greather than 0
      await FirebaseReference.orderDocument(v.id).update({
        "status": 1,
      });
    }
  }

  void setSelectedID(PurchaseModel v) {
    if (selectedPurchaseModel.value?.id == v.id) {
      selectedPurchaseModel.value = null;
    } else {
      makeSeenOrNot(v);
      selectedPurchaseModel.value = v;

      animateToggle.value = true;

      Future.delayed(const Duration(milliseconds: 500))
          .then((value) => animateToggle.value = false);
    }
  }

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }

  void startItemSearch(String v) {
    if (v.isEmpty) {
      searchItems.clear();
    } else {
      searchItems.value = purchaseModels
          .where((e) => getStringList(e.name.toLowerCase()).contains(v))
          .toList();
    }
    log("==========Search Author Items: ${searchItems.length}");
  }

  Future<void> getCategories() async {
    try {
      //TODO:Change
      /* final result = await rootBundle.loadString("assets/data/AUTHOR.json");
      final decoded = jsonDecode(result) as List;
      authors.value = decoded.map((e) => Author.fromJson(e)).toList(); */
      FirebaseReference.orderCollection
          .orderBy("dateTime")
          .snapshots()
          .listen((event) {
        newOrderCount.value = 0;
        purchaseModels.value = event.docs.map((e) => e.data()).toList();
        for (var element in event.docs) {
          if (element.data().status == 0) {
            newOrderCount.value += 1;
          }
        }
      });
    } catch (e) {
      debugPrint("=========Error: $e");
    }
  }
}
