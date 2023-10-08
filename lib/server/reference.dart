import 'package:book_store_admin/model/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../model/author.dart';
import '../model/book.dart';
import '../model/division.dart';
import '../model/purchase.dart';

class FirebaseReference {
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static CollectionReference<Map<String, dynamic>> userCollection() =>
      firestore.collection("users");
  static DocumentReference<Map<String, dynamic>> userDocument(String id) =>
      userCollection().doc(id);

  static CollectionReference<AppCategory> appCategoryCollection =
      firestore.collection("categories").withConverter<AppCategory>(
            fromFirestore: (snap, __) => AppCategory.fromJson(snap.data()!),
            toFirestore: (appCategory, __) => appCategory.toJson(),
          );
  static DocumentReference<AppCategory> categoryDocument(String id) =>
      appCategoryCollection.doc(id);
  static CollectionReference<Author> authorCollection =
      firestore.collection("authors").withConverter<Author>(
            fromFirestore: (snap, __) => Author.fromJson(snap.data()!),
            toFirestore: (author, __) => author.toJson(),
          );
  static DocumentReference<Author> authorDocument(String id) =>
      authorCollection.doc(id);
  static CollectionReference<Book> bookCollection =
      firestore.collection("books").withConverter<Book>(
            fromFirestore: (snap, __) => Book.fromJson(snap.data()!),
            toFirestore: (book, __) => book.toJson(),
          );
  static DocumentReference<Book> bookDocument(String id) =>
      bookCollection.doc(id);

  static CollectionReference<Division> divisionCollection =
      firestore.collection("divisions").withConverter<Division>(
            fromFirestore: (snap, __) => Division.fromJson(snap.data()!),
            toFirestore: (book, __) => book.toJson(),
          );
  static DocumentReference<Division> divisionDocument(String id) =>
      divisionCollection.doc(id);
  static CollectionReference<PurchaseModel> orderCollection =
      firestore.collection("orders").withConverter<PurchaseModel>(
            fromFirestore: (snap, __) => PurchaseModel.fromJson(snap.data()!),
            toFirestore: (book, __) => book.toJson(),
          );
  static DocumentReference<PurchaseModel> orderDocument(String id) =>
      orderCollection.doc(id);

  static Future<String> uploadImage(String path, String image) async {
    Reference storageReference = firebaseStorage.ref().child('$path/$image');
    UploadTask uploadTask =
        storageReference.putData(await XFile(image).readAsBytes());
    final snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }

  static Future<String?> checkUploadImage(
      bool check, String path, String image) async {
    if (check) {
      return await uploadImage(path, image);
    } else {
      return null;
    }
  }
}
