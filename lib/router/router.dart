import 'package:book_store_admin/view/page/login_page.dart';
import 'package:book_store_admin/view/page/user_status_check_route.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../utils/constant.dart';
import '../view/page/home_route.dart';
import 'route_name.dart';

String getInitialRoute() {
  final box = Hive.box(loginBox);
  if (box.get(isAuthenticatedKey, defaultValue: false) == false) {
    return adminLoginRoute; /* loginRoute; */
  } else {
    return authorizeCheckRoute;
  }
}

List<GetPage> getPages = [
  GetPage(
    name: homePage,
    page: () => const HomeRoute(),
  ),
  GetPage(
    name: adminLoginRoute,
    page: () => const AdminLoginPage(),
  ),
  GetPage(
    name: authorizeCheckRoute,
    page: () => const UserStatusCheckRoute(),
  ),
];
