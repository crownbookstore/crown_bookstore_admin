import 'package:book_store_admin/controller/admin_login_controller.dart';
import 'package:book_store_admin/utils/app_image.dart';
import 'package:book_store_admin/utils/func.dart';
import 'package:book_store_admin/view/page/home_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import 'unauthorized_route.dart';

class UserStatusCheckRoute extends GetView<AdminLoginController> {
  const UserStatusCheckRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(() {
      if ((controller.currentUser["status"] ?? -1) > 0) {
        return const HomeRoute();
      }
      if ((controller.currentUser["status"] ?? -1) == 0) {
        return const UnAuthorizeRoute();
      }
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppImage.checkAuthorize,
                  width: size.width * 0.8,
                  height: size.height * 0.4,
                ),
                verticalSpace(),
                Text(
                  "Checking authorisation.....",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
