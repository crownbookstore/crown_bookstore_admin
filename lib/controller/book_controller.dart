import 'dart:convert';
import 'dart:developer';
import 'package:book_store_admin/controller/author_controller.dart';
import 'package:book_store_admin/controller/category_controller.dart';
import 'package:book_store_admin/model/author.dart';
import 'package:book_store_admin/model/book.dart';
import 'package:book_store_admin/model/category.dart';
import 'package:book_store_admin/utils/debouncer.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../server/reference.dart';
import '../utils/func.dart';
import '../utils/show_loading.dart';

class BookController extends GetxController {
  final debouncer = Debouncer(milliseconds: 800);

  final AuthorController authorController = Get.find();
  final CategoryController categoryController = Get.find();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController imageTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController discountPriceTextController = TextEditingController();

  TextEditingController scoreTextController = TextEditingController();
  Rxn<Author> selectedAuthor = Rxn<Author>();
  Rxn<AppCategory> selectedCategory = Rxn<AppCategory>();
  var authorDropDownController = SingleValueDropDownController().obs;
  var categoryDropDownController = SingleValueDropDownController().obs;
  //------//
  RxList<Book> searchItems = <Book>[].obs;

  RxList<Book> books = <Book>[].obs;
  Rxn<Book> selectedBook = Rxn<Book>();
  var toggleActive = false.obs;
  var animateToggle = false.obs;
  void changeToggleActive() {
    toggleActive.value = !toggleActive.value;
  }

  void setSelectedAuthor(String id) {
    final item =
        authorController.authors.firstWhere((element) => element.id == id);
    selectedAuthor.value = item;
    log("====Selected Author: ${selectedAuthor.value.toString()}");
  }

  void setSelectedCategory(String id) {
    final item =
        categoryController.categories.firstWhere((element) => element.id == id);
    selectedCategory.value = item;
    log("====Selected Author: ${selectedCategory.value.toString()}");
  }

  void clearAll() {
    titleTextController.clear();
    imageTextController.clear();
    descTextController.clear();
    priceTextController.clear();
    discountPriceTextController.clear();
    scoreTextController.clear();
    selectedAuthor.value = null;
    selectedCategory.value = null;
    authorDropDownController.value.clearDropDown();
    categoryDropDownController.value.clearDropDown();
  }

  void setSelectedID(Book v) {
    if (selectedBook.value?.id == v.id) {
      selectedBook.value = null;
      clearAll();
    } else {
      selectedBook.value = v;
      titleTextController.text = v.title;
      imageTextController.text = v.image;
      descTextController.text = v.description;
      priceTextController.text = v.price.toString();
      discountPriceTextController.text = v.discountPrice.toString();
      scoreTextController.text = v.score.toString();
      /* selectedAuthor.value =
          authorController.authors.firstWhere((e) => e.id == v.authorId);
      selectedCategory.value =
          categoryController.categories.firstWhere((e) => e.id == v.categoryId); */
      authorDropDownController.value = SingleValueDropDownController(
        data: DropDownValueModel(
            name: v.authorName ?? "", value: v.authorId ?? ""),
      );
      categoryDropDownController.value = SingleValueDropDownController(
        data: DropDownValueModel(
            name: v.categoryName ?? "", value: v.categoryId ?? ""),
      );
      final auList =
          authorController.authors.where((e) => e.id == v.authorId).toList();
      if (auList.isNotEmpty) selectedAuthor.value = auList.first;
      final caList = categoryController.categories
          .where((e) => e.id == v.categoryId)
          .toList();
      if (caList.isNotEmpty) selectedCategory.value = caList.first;
      animateToggle.value = true;
      Future.delayed(const Duration(milliseconds: 500))
          .then((value) => animateToggle.value = false);
    }
  }

  var firstTimePressed = false.obs;
  void nameCheck() => nameError.value = titleTextController.text.isEmpty;
  void descCheck() => descriptionError.value = descTextController.text.isEmpty;
  void imageCheck() => imageError.value = imageTextController.text.isEmpty;
  void priceCheck() => priceError.value = priceTextController.text.isEmpty;
  void scoreCheck() => scoreError.value = scoreTextController.text.isEmpty;
  void authorCheck() => authorIdError.value = selectedAuthor.value == null;
  void categoryCheck() =>
      categoryIdError.value = selectedCategory.value == null;
  var nameError = false.obs;
  var descriptionError = false.obs;
  var imageError = false.obs;
  var priceError = false.obs;
  var scoreError = false.obs;
  var authorIdError = false.obs;
  var categoryIdError = false.obs;

  Future<void> save() async {
    nameCheck();
    descCheck();
    imageCheck();
    priceCheck();
    scoreCheck();
    authorCheck();
    categoryCheck();
    firstTimePressed.value = true;

    //name,image
    if (!nameError.value &&
        !imageError.value &&
        !descriptionError.value &&
        !priceError.value &&
        /*  !scoreError.value && */
        !authorIdError.value &&
        !categoryIdError.value) {
      //:TODO:Save Item
      firstTimePressed.value = false;
      //:TODO:To store image into firebase storage
      showLoading();
      await Future.delayed(const Duration(milliseconds: 10));

      final item = Book(
        id: Uuid().v1(),
        authorId: selectedAuthor.value!.id,
        authorName: selectedAuthor.value!.fullname,
        authorImage: selectedAuthor.value!.image,
        categoryId: selectedCategory.value!.id,
        categoryName: selectedCategory.value!.name,
        categoryImage: selectedCategory.value!.image,
        title: titleTextController.text,
        description: descTextController.text,
        image: imageTextController.text,
        price: int.parse(priceTextController.text),
        discountPrice: int.tryParse(discountPriceTextController.text),
        score: double.tryParse(scoreTextController.text),
        dateTime: DateTime.now(),
        searchList: getStringList(titleTextController.text),
      );
      FirebaseReference.uploadImage("books/", imageTextController.text)
          .then((value) async {
        //After uploading image,we save to firestore
        await FirebaseReference.bookDocument(item.id)
            .set(item.copyWith(image: value));
        hideLoading();
        successSnap("Book is added successfully!");
      });

      books.add(item);
      clearAll();
    } else {
      //:TODO:Do Nothing
    }
  }

  Future<void> edit() async {
    nameCheck();
    descCheck();
    imageCheck();
    priceCheck();
    scoreCheck();
    authorCheck();
    categoryCheck();
    firstTimePressed.value = true;

    //name,image
    if (!nameError.value &&
        !imageError.value &&
        !descriptionError.value &&
        !priceError.value &&
        !scoreError.value &&
        !authorIdError.value &&
        !categoryIdError.value) {
      //:TODO:Save Item
      firstTimePressed.value = false;
      //:TODO:To store image into firebase storage
      showLoading();
      await Future.delayed(const Duration(milliseconds: 10));
      final item = Book(
        id: selectedBook.value!.id,
        authorId: selectedAuthor.value!.id,
        authorName: selectedAuthor.value!.fullname,
        authorImage: selectedAuthor.value!.image,
        categoryId: selectedCategory.value!.id,
        categoryName: selectedCategory.value!.name,
        categoryImage: selectedCategory.value!.image,
        title: titleTextController.text,
        description: descTextController.text,
        image: imageTextController.text,
        price: int.parse(priceTextController.text),
        discountPrice: int.tryParse(discountPriceTextController.text),
        score: double.tryParse(scoreTextController.text),
        dateTime: DateTime.now(),
        searchList: getStringList(titleTextController.text),
      );
      //Check need image upload or not
      FirebaseReference.checkUploadImage(
              selectedCategory.value!.image != imageTextController.text,
              "books/",
              imageTextController.text)
          .then((value) async {
        //After uploading image,we save to firestore
        await FirebaseReference.bookDocument(item.id).update(item
            .copyWith(image: value ?? selectedCategory.value!.image)
            .toJson());
        hideLoading();
        successSnap("Author is updated successfully!");
      });
      final index = books.indexWhere((element) => element.id == item.id);
      books[index] = item;
    } else {
      //:TODO:Do Nothing
    }
  }

  Future<void> deleteItem(String id) async {
    showLoading();
    await FirebaseReference.bookDocument(id).delete();
    hideLoading();
    books.removeWhere((element) => element.id == id);
    successSnap("Book is deleted successfully");
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
      searchItems.value =
          books.where((e) => getStringList(e.title).contains(v)).toList();
    }
    log("==========Search Book Items: ${searchItems.length}");
  }

  Future<void> getCategories() async {
    try {
      /* //TODO:DO
      final result = await rootBundle.loadString("assets/data/BOOK.json");
      final decoded = jsonDecode(result) as List;
      books.value = decoded.map((e) => Book.fromJson(e)).toList(); */
      final result =
          await FirebaseReference.bookCollection.orderBy("dateTime").get();
      books.value = result.docs.map((e) => e.data()).toList();
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
