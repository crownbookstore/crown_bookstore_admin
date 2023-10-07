import 'package:book_store_admin/utils/app_image.dart';
import 'package:book_store_admin/utils/func.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class UnAuthorizeRoute extends StatelessWidget {
  const UnAuthorizeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Image
              SizedBox(
                height: size.height * 0.3,
                width: size.width * 0.8,
                child: Image.asset(
                  AppImage.accessDenied,
                ),
              ),
              //
              Text(
                "Access Denied: Admin Privileges Required",
                style: textTheme.displayLarge,
              ),
              verticalSpace(),
              Text(
                "We're sorry, but this section of the website requires administrator privileges. If you believe you should have access, please contact the website administrator for assistance.",
                style: textTheme.displayMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
