import 'package:book_store_admin/controller/admin_login_controller.dart';
import 'package:book_store_admin/controller/author_controller.dart';
import 'package:book_store_admin/controller/book_controller.dart';
import 'package:book_store_admin/controller/category_controller.dart';
import 'package:book_store_admin/controller/division_controller.dart';
import 'package:book_store_admin/controller/home_controller.dart';
import 'package:book_store_admin/controller/order_controller.dart';
import 'package:book_store_admin/router/router.dart';
import 'package:book_store_admin/theme/app_theme.dart';
import 'package:book_store_admin/utils/constant.dart';
import 'package:book_store_admin/utils/key.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //This is for web
      options: const FirebaseOptions(
    authDomain: authDomain,
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    storageBucket: storageBucket,
  ));
  await Hive.initFlutter();
  await Hive.openBox(loginBox);
  Get.put(AdminLoginController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    Get.put(CategoryController());
    Get.put(AuthorController());
    Get.put(BookController());
    Get.put(DivisionController());
    Get.put(OrderController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crown Bookstore',
      theme: AppTheme.lightTheme(),
      initialRoute: getInitialRoute(),
      getPages: getPages,
    );
  }
}
