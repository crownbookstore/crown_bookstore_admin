import 'dart:developer';

import 'package:book_store_admin/model/division.dart';
import 'package:book_store_admin/model/township.dart';
import 'package:book_store_admin/server/reference.dart';
import 'package:book_store_admin/utils/debouncer.dart';
import 'package:book_store_admin/utils/show_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../utils/func.dart';

class DivisionController extends GetxController {
  final debouncer = Debouncer(milliseconds: 800);
  var firstTimePressed = false.obs;
  TextEditingController nameTextController = TextEditingController();
  RxList<Township> townships = <Township>[].obs;

  RxList<Division> searchItems = <Division>[].obs;
  RxList<Division> divisions = <Division>[].obs;
  Rxn<Division> selectedDivision = Rxn<Division>(null);
  var toggleActive = false.obs;
  var animateToggle = false.obs;
  void changeToggleActive() {
    toggleActive.value = !toggleActive.value;
  }

  void nameCheck() => nameError.value = nameTextController.text.isEmpty;

  void townshipCheck() =>
      townshipError.value = townships.isEmpty || individualTownshipCheck();

  bool individualTownshipCheck() {
    List<bool> errorBoolList = [];
    for (var element in townships) {
      if (element.name.isEmpty) {
        errorBoolList.add(true);
      }
    }
    return errorBoolList.isNotEmpty;
  }

  void addTownship() => townships.add(Township.empty());
  void removeTownship(int index) => townships.removeAt(index);
  void changeTownshipName(String value, int index) {
    final item = townships[index];
    townships[index] = item.copyWith(name: value);
  }

  void changeTownshipFee(String value, int index) {
    final item = townships[index];
    townships[index] = item.copyWith(fee: int.tryParse(value) ?? 0);
  }

  var nameError = false.obs;
  var townshipError = false.obs;
  GlobalKey<FormState> townshipFormKey = GlobalKey();

  Future<void> save() async {
    nameCheck();
    townshipCheck();
    firstTimePressed.value = true;
    var formValidate = townshipFormKey.currentState?.validate() == true;
    //name,image
    if (!nameError.value && townshipError.value == false && formValidate) {
      log("======Township Error: ${townshipError.value}");
      //:TODO:Save Item
      firstTimePressed.value = false;

      //:TODO:To store image into firebase storage
      showLoading();
      await Future.delayed(const Duration(milliseconds: 10));

      final item = Division(
        id: Uuid().v1(),
        name: nameTextController.text,
        dateTime: DateTime.now(),
        townships: townships,
      );
      //After uploading image,we save to firestore
      await FirebaseReference.divisionDocument(item.id).set(item);
      hideLoading();
      successSnap("Division is added successfully!");
      log("===SavedTownshiplist:${item.townships.length}");

      /* divisions.add(item); */
      clearAll();
    } else {
      //:TODO:Do Nothing
    }
  }

  Future<void> edit() async {
    nameCheck();
    townshipCheck();
    firstTimePressed.value = true;
    //name,image
    if (!nameError.value &&
        townshipError.value == false &&
        townshipFormKey.currentState?.validate() == true) {
      //:TODO:Save Item
      firstTimePressed.value = false;
      //:TODO:To store image into firebase storage
      showLoading();
      await Future.delayed(const Duration(milliseconds: 10));
      final item = Division(
        id: selectedDivision.value!.id,
        name: nameTextController.text,
        dateTime: DateTime.now(),
        townships: townships,
      );

      //After uploading image,we save to firestore
      await FirebaseReference.divisionDocument(item.id).update(item.toJson());
      hideLoading();
      successSnap("Division is updated successfully!");

      /* final index = divisions.indexWhere((element) => element.id == item.id);
      divisions[index] = item; */
      log("===Edited Townshiplist:${item.townships.length}");
    } else {
      //:TODO:Do Nothing
    }
  }

  Future<void> deleteItem(String id) async {
    showLoading();
    await FirebaseReference.divisionDocument(id).delete();
    hideLoading();
    divisions.removeWhere((element) => element.id == id);
    successSnap("Category is deleted successfully");
  }

  void clearAll() {
    nameTextController.clear();
    townships.value = [];
    townships.clear();
  }

  void setSelectedID(Division v) {
    clearAll();
    log("====TownshipList: ${v.townships.length}");

    if (selectedDivision.value?.id == v.id) {
      selectedDivision.value = null;
    } else {
      selectedDivision.value = v;
      nameTextController.text = v.name;
      townships.value = List.from(v.townships);
      animateToggle.value = true;

      Future.delayed(const Duration(milliseconds: 500))
          .then((value) => animateToggle.value = false);
    }
  }

  void startItemSearch(String v) {
    if (v.isEmpty) {
      searchItems.clear();
    } else {
      searchItems.value =
          divisions.where((e) => getStringList(e.name).contains(v)).toList();
    }
    log("==========Search Items: ${searchItems.length}=======");
  }

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }

  Future<void> getCategories() async {
    try {
      /*  //TODO:Change
      final result = await rootBundle.loadString("assets/data/CATEGORY.json");
      final decoded = jsonDecode(result) as List;
      categories.value = decoded.map((e) => AppCategory.fromJson(e)).toList(); */
      /* final result =
          await  */
      FirebaseReference.divisionCollection
          .orderBy("dateTime")
          .snapshots()
          .listen((event) {
        divisions.value = event.docs.map((e) => e.data()).toList();
      });
    } catch (e) {
      debugPrint("=========Error: $e");
    }
  }

  //update picked image//
  final ImagePicker _imagePicker = ImagePicker();
}
