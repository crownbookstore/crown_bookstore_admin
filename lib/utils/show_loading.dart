import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void showCustomDialog(
  BuildContext context, {
  required Widget child,
  Color? barrierColor,
  bool isDimissible = false,
  required double width,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: isDimissible,
    /*  barrierColor: barrierColor ?? const Color(0x80000000), */
    pageBuilder: (context, __, ___) {
      return Center(
          child: SizedBox(
              width: width,
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [child],
                  shrinkWrap: true,
                ),
              ))));
    },
  );
}

successSnap(String title, {String? message}) {
  Get.snackbar(
    title,
    message ?? "",
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
}

errorSnap(String title, {String? message}) {
  Get.snackbar(
    title,
    message ?? "",
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}

showLoading() {
  showGeneralDialog(
    context: Get.context!,
    barrierDismissible: false,
    barrierColor: Colors.white.withOpacity(0),
    pageBuilder: (context, __, ___) {
      return Center(
          child: SizedBox(
        height: 50,
        width: 100,
        child: Card(
          child: Center(
            child: LoadingAnimationWidget.flickr(
              leftDotColor: Theme.of(context).primaryColor,
              rightDotColor: const Color.fromRGBO(244, 167, 41, 1),
              size: 50,
            ),
          ),
        ),
      ));
    },
  );
}

hideLoading() {
  Navigator.of(Get.context!).pop();
}
