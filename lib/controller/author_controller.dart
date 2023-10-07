import 'dart:convert';
import 'dart:developer';
import 'package:book_store_admin/model/author.dart';
import 'package:book_store_admin/model/category.dart';
import 'package:book_store_admin/utils/debouncer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../server/reference.dart';
import '../utils/func.dart';
import '../utils/show_loading.dart';

class AuthorController extends GetxController {
  final debouncer = Debouncer(milliseconds: 800);

  TextEditingController nameTextController = TextEditingController();
  TextEditingController imageTextController = TextEditingController();
  var selectedToggle = false.obs;
  RxList<Author> searchItems = <Author>[].obs;

  RxList<Author> authors = <Author>[].obs;
  Rxn<Author> selectedAuthor = Rxn<Author>();
  var toggleActive = false.obs;
  var animateToggle = false.obs;
  void changeToggleActive() {
    toggleActive.value = !toggleActive.value;
  }

  void clearAll() {
    nameTextController.clear();
    imageTextController.clear();
    selectedToggle.value = false;
  }

  void setSelectedID(Author v) {
    if (selectedAuthor.value?.id == v.id) {
      selectedAuthor.value = null;
      clearAll();
      log("==========is Selected : ${selectedAuthor.value?.id == v.id} even false");
    } else {
      selectedAuthor.value = v;
      nameTextController.text = v.fullname;
      imageTextController.text = v.image;
      selectedToggle.value = v.active;
      animateToggle.value = true;
      log("==========is Selected : ${selectedAuthor.value?.id == v.id} even false");

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
      searchItems.value = authors
          .where((e) => getStringList(e.fullname.toLowerCase()).contains(v))
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
      final result =
          await FirebaseReference.authorCollection.orderBy("dateTime").get();
      authors.value = result.docs.map((e) => e.data()).toList();
    } catch (e) {
      debugPrint("=========Error: $e");
    }
  }

  var firstTimePressed = false.obs;
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
      final item = Author(
        id: Uuid().v1(),
        fullname: nameTextController.text,
        image: imageTextController.text,
        active: selectedToggle.value,
        dateTime: DateTime.now(),
        searchList: getStringList(nameTextController.text),
      );
      FirebaseReference.uploadImage("authors/", imageTextController.text)
          .then((value) async {
        //After uploading image,we save to firestore
        await FirebaseReference.authorDocument(item.id)
            .set(item.copyWith(image: value));
        hideLoading();
        successSnap("Author is added successfully!");
      });

      authors.add(item);
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
      final item = Author(
        id: selectedAuthor.value!.id,
        fullname: nameTextController.text,
        image: imageTextController.text,
        active: selectedToggle.value,
        dateTime: DateTime.now(),
        searchList: getStringList(nameTextController.text),
      );
      //Check need image upload or not
      FirebaseReference.checkUploadImage(
              selectedAuthor.value!.image != imageTextController.text,
              "authors/",
              imageTextController.text)
          .then((value) async {
        //After uploading image,we save to firestore
        await FirebaseReference.authorDocument(item.id).update(item
            .copyWith(image: value ?? selectedAuthor.value!.image)
            .toJson());
        hideLoading();
        successSnap("Author is updated successfully!");
      });

      final index = authors.indexWhere((element) => element.id == item.id);
      authors[index] = item;
    } else {
      //:TODO:Do Nothing
    }
  }

  Future<void> deleteItem(String id) async {
    showLoading();
    await FirebaseReference.authorDocument(id).delete();
    hideLoading();
    authors.removeWhere((e) => e.id == id);
    successSnap("Author is deleted successfully");
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
