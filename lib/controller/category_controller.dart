import 'dart:convert';
import 'dart:developer';
import 'package:book_store_admin/model/category.dart';
import 'package:book_store_admin/server/reference.dart';
import 'package:book_store_admin/utils/debouncer.dart';
import 'package:book_store_admin/utils/show_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../utils/func.dart';

class CategoryController extends GetxController {
  final debouncer = Debouncer(milliseconds: 800);
  var firstTimePressed = false.obs;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController imageTextController = TextEditingController();
  var selectedToggle = false.obs;
  RxList<AppCategory> searchItems = <AppCategory>[].obs;

  RxList<AppCategory> categories = <AppCategory>[].obs;
  Rxn<AppCategory> selectedCategory = Rxn<AppCategory>(null);
  var toggleActive = false.obs;
  var animateToggle = false.obs;
  void changeToggleActive() {
    toggleActive.value = !toggleActive.value;
  }

  void nameCheck() => nameError.value = nameTextController.text.isEmpty;

  void imageCheck() => imageError.value = imageTextController.text.isEmpty;
  var nameError = false.obs;
  var imageError = false.obs;

  Future<void> save() async {
    nameCheck();
    imageCheck();
    firstTimePressed.value = true;
    //name,image
    if (!nameError.value && !imageError.value) {
      //:TODO:Save Item
      firstTimePressed.value = false;
      //:TODO:To store image into firebase storage
      showLoading();
      await Future.delayed(const Duration(milliseconds: 10));

      final item = AppCategory(
        id: Uuid().v1(),
        name: nameTextController.text,
        image: imageTextController.text,
        active: selectedToggle.value,
        dateTime: DateTime.now(),
        searchList: getStringList(nameTextController.text),
      );
      FirebaseReference.uploadImage("categories/", imageTextController.text)
          .then((value) async {
        //After uploading image,we save to firestore
        await FirebaseReference.categoryDocument(item.id)
            .set(item.copyWith(image: value));
        hideLoading();
        successSnap("Category is added successfully!");
      });

      categories.add(item);
      clearAll();
    } else {
      //:TODO:Do Nothing
    }
  }

  Future<void> edit() async {
    nameCheck();
    imageCheck();
    firstTimePressed.value = true;
    //name,image
    if (!nameError.value && !imageError.value) {
      //:TODO:Save Item
      firstTimePressed.value = false;
      //:TODO:To store image into firebase storage
      showLoading();
      await Future.delayed(const Duration(milliseconds: 10));
      final item = AppCategory(
        id: selectedCategory.value!.id,
        name: nameTextController.text,
        image: imageTextController.text,
        active: selectedToggle.value,
        dateTime: DateTime.now(),
        searchList: getStringList(nameTextController.text),
      );
      //Check need image upload or not
      FirebaseReference.checkUploadImage(
              selectedCategory.value!.image != imageTextController.text,
              "categories/",
              imageTextController.text)
          .then((value) async {
        //After uploading image,we save to firestore
        await FirebaseReference.categoryDocument(item.id).update(item
            .copyWith(image: value ?? selectedCategory.value!.image)
            .toJson());
        hideLoading();
        successSnap("Category is updated successfully!");
      });

      final index = categories.indexWhere((element) => element.id == item.id);
      categories[index] = item;
    } else {
      //:TODO:Do Nothing
    }
  }

  Future<void> deleteItem(String id) async {
    showLoading();
    await FirebaseReference.categoryDocument(id).delete();
    hideLoading();
    categories.removeWhere((element) => element.id == id);
    successSnap("Category is deleted successfully");
  }

  void clearAll() {
    nameTextController.clear();
    imageTextController.clear();
    selectedToggle.value = false;
  }

  void setSelectedID(AppCategory v) {
    if (selectedCategory.value?.id == v.id) {
      selectedCategory.value = null;
      log("==========is Selected : ${selectedCategory.value?.id == v.id} even false");
      clearAll();
    } else {
      selectedCategory.value = v;
      nameTextController.text = v.name;
      imageTextController.text = v.image;
      selectedToggle.value = v.active;
      animateToggle.value = true;
      log("==========is Selected : ${selectedCategory.value?.id == v.id} even true");

      Future.delayed(const Duration(milliseconds: 500))
          .then((value) => animateToggle.value = false);
    }
  }

  void startItemSearch(String v) {
    if (v.isEmpty) {
      searchItems.clear();
    } else {
      searchItems.value =
          categories.where((e) => getStringList(e.name).contains(v)).toList();
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
      final result = await FirebaseReference.appCategoryCollection
          .orderBy("dateTime")
          .get();
      categories.value = result.docs.map((e) => e.data()).toList();
    } catch (e) {
      debugPrint("=========Error: $e");
    }
  }

  //update picked image//
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage(int index) async {
    try {
      final XFile? _file =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (!(_file == null)) {
        imageTextController.text = _file.path;
        imageCheck();
      }
    } catch (e) {
      log("=======pickImage error $e");
    }
  }
}
