import 'package:book_store_admin/controller/admin_login_controller.dart';
import 'package:book_store_admin/utils/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/func.dart';

class AdminLoginPage extends GetView<AdminLoginController> {
  const AdminLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
/*     final AdminLoginController alController = Get.find();
 */
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: 6,
            child: Image.asset(
              AppImage.bookstore1,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Theme.of(context).cardTheme.color,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(child: SizedBox()),
                    //Logo And Text
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset(
                        AppImage.logo,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        "Crown Bookstore",
                        style: textTheme.displayLarge?.copyWith(
                          fontSize: 25,
                        ),
                      ),
                    ),
                    verticalSpace(v: 60),
                    //Welcome
                    Text(
                      "Welcome to Crown Bookstore Admin! 👋",
                      style: GoogleFonts.inter(
                        color: Theme.of(context).textTheme.displaySmall?.color,
                        fontSize: 20,
                      ),
                    ),
                    verticalSpace(v: 40),
                    Text(
                      "Instant sign-in to your admin account with...",
                      style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                    verticalSpace(v: 40),
                    //FORM
                    Center(
                      child: Align(
                        alignment: Alignment.center,
                        //TODO:GoogleSignIn
                        child: SizedBox(
                          width: 250,
                          child: ElevatedButton(
                            /* style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    10,
                                  ),
                                ),
                              ),
                            ), */
                            onPressed: () => controller.signInWithGoogle(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.google,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  /* Image.asset(
                                    AppImage.google,
                                    width: 35,
                                    height: 35,
                                  ), */
                                  horizontalSpace(),
                                  //GoogleIcon
                                  Text(
                                    "Google Sign In",
                                    style: textTheme.displayMedium?.copyWith(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //Remember me Forget password
                    verticalSpace(),
                    /*  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "SIGN IN",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    */
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
