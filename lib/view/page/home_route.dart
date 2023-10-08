import 'package:book_store_admin/controller/admin_login_controller.dart';
import 'package:book_store_admin/controller/author_controller.dart';
import 'package:book_store_admin/controller/book_controller.dart';
import 'package:book_store_admin/controller/category_controller.dart';
import 'package:book_store_admin/controller/home_controller.dart';
import 'package:book_store_admin/model/app_page.dart';
import 'package:book_store_admin/utils/app_image.dart';
import 'package:book_store_admin/utils/func.dart';
import 'package:book_store_admin/view/page/authors_data_table.dart';
import 'package:book_store_admin/view/page/books_data_table.dart';
import 'package:book_store_admin/view/page/division_data_table.dart';
import 'package:book_store_admin/view/widgets/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'categories_data_table.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminLoginController loginController = Get.find();
    dropDownBorder() => OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey.shade400,
        ));
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final HomeController homeController = Get.find();
    final CategoryController categoryController = Get.find();
    final AuthorController authorController = Get.find();
    final BookController bookController = Get.find();
    final colorLightTextTheme = textTheme.displayMedium?.copyWith(
      color: Colors.white,
    );
    final isMobile = size.width <= 499;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 10,
          ),
          child: InkWell(
            onTap: () => homeController.changeDrawerOpen(),
            child: SvgPicture.asset(
              AppImage.drawer,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ),
        ),
        centerTitle: false,
        title: Row(
          children: [
            isMobile
                ? const SizedBox()
                : Text(
                    "CROWN",
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
            const Expanded(child: SizedBox()),
            Obx(() {
              final appPage = homeController.appPage.value;
              return Text(
                getTitle(appPage),
                style: textTheme.displayLarge,
              );
            }),
            horizontalSpace(),
            Expanded(
              flex: 6,
              child: SizedBox(
                height: 30,
                child: Obx(() {
                  final appPage = homeController.appPage.value;
                  return TextFormField(
                    onChanged: (v) {
                      if (appPage == const AppPage.category()) {
                        //category search
                        categoryController.debouncer.run(() {
                          categoryController.startItemSearch(v);
                        });
                      } else if (appPage == const AppPage.author()) {
                        authorController.debouncer.run(() {
                          authorController.startItemSearch(v);
                        });
                      } else {
                        bookController.debouncer.run(() {
                          bookController.startItemSearch(v);
                        });
                      }
                    },
                    style: textTheme.displaySmall,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        FontAwesomeIcons.search,
                        color: Colors.grey.shade400,
                      ),
                      contentPadding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      border: dropDownBorder(),
                      disabledBorder: dropDownBorder(),
                      focusedBorder: dropDownBorder(),
                      enabledBorder: dropDownBorder(),
                      /*  labelText: "Name", */
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        actions: [
          Obx(() {
            final profile = loginController.currentUser["image"] as String?;
            return profile == null
                ? const CircleAvatar(
                    backgroundImage: AssetImage(
                      AppImage.profile,
                    ),
                    radius: 18,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(
                      profile,
                    ),
                    radius: 18,
                  );
          }),
          horizontalSpace(),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Name
                Text(
                  loginController.currentUser["name"] ?? "",
                  style: textTheme.displayMedium,
                ),
                verticalSpace(v: 5),
                //email
                Text(
                  loginController.currentUser["email"] ?? "",
                  style: textTheme.displaySmall,
                ),
              ],
            );
          }),
          horizontalSpace(v: 10),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;
          final isTablet = width <= 920;
          final isDesktop = width >= 1000;

          return Stack(
            children: [
              //Content
              Positioned(
                top: 0,
                left: 0,
                child: Obx(() {
                  final appPage = homeController.appPage.value;
                  final isOpen = homeController.drawerOpen.value;
                  return Container(
                    width: width,
                    height: height,
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    margin: isTablet
                        ? EdgeInsets.zero
                        : isOpen
                            ? EdgeInsets.only(left: 250)
                            : EdgeInsets.zero,
                    child: appPage == const AppPage.category()
                        ? CategoriesDataTable(
                            isTablet: isTablet,
                            isDesktop: isDesktop,
                          )
                        : appPage == const AppPage.author()
                            ? AuthorsDataTable(
                                isTablet: isTablet, isDesktop: isDesktop)
                            : appPage == const AppPage.book()
                                ? BooksDataTable(
                                    isTablet: isTablet, isDesktop: isDesktop)
                                : appPage == const AppPage.division()
                                    ? DivisionDataTable(
                                        isTablet: isTablet,
                                        isDesktop: isDesktop)
                                    : const SizedBox(),
                  );
                }),
              ),
              //Drawer Body
              Obx(() {
                final isOpen = homeController.drawerOpen.value;
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  top: 0,
                  left: isOpen ? 0 : -size.width,
                  child: SizedBox(
                    width: 250,
                    height: size.height,
                    child: Card(
                      elevation: isTablet ? 5 : 0,
                      child: Column(
                        children: [
                          isTablet
                              ? verticalSpace()
                              : const Divider(
                                  thickness: 1,
                                ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: Obx(() {
                              final appPage = homeController.appPage.value;
                              return HoverButton(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 0,
                                  ),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(
                                    15,
                                  )),
                                  hoverColor: Colors.grey.shade200,
                                  color: appPage == AppPage.category()
                                      ? Colors.grey.shade200
                                      : Colors.white,
                                  splashColor: Colors.black,
                                  onPressed: () {
                                    homeController
                                        .changeAppPage(AppPage.category());
                                  },
                                  child: IntrinsicHeight(
                                      child: Row(
                                    children: [
                                      VerticalDivider(
                                        color: appPage == AppPage.category()
                                            ? theme.primaryColor
                                            : Colors.white,
                                        thickness: 3,
                                      ),
                                      horizontalSpace(),
                                      SvgPicture.asset(
                                        AppImage.category,
                                        width: 25,
                                        height: 25,
                                      ),
                                      horizontalSpace(),
                                      Text(
                                        "Categories",
                                        style: textTheme.displayMedium,
                                      ),
                                    ],
                                  )));
                            }),
                          ),
                          verticalSpace(),
                          //Author
                          Obx(() {
                            final appPage = homeController.appPage.value;
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: HoverButton(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 0,
                                  ),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(
                                    15,
                                  )),
                                  hoverColor: Colors.grey.shade200,
                                  color: appPage == AppPage.author()
                                      ? Colors.grey.shade200
                                      : Colors.white,
                                  splashColor: Colors.black,
                                  onPressed: () {
                                    homeController
                                        .changeAppPage(AppPage.author());
                                  },
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        VerticalDivider(
                                          color: appPage == AppPage.author()
                                              ? theme.primaryColor
                                              : Colors.white,
                                          thickness: 3,
                                        ),
                                        horizontalSpace(),
                                        SvgPicture.asset(
                                          AppImage.author,
                                          width: 25,
                                          height: 25,
                                        ),
                                        horizontalSpace(),
                                        Text(
                                          "Authors",
                                          style: textTheme.displayMedium,
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          }),
                          verticalSpace(),
                          //Book
                          Obx(() {
                            final appPage = homeController.appPage.value;
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: HoverButton(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 0,
                                  ),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(
                                    15,
                                  )),
                                  hoverColor: Colors.grey.shade200,
                                  color: appPage == AppPage.book()
                                      ? Colors.grey.shade200
                                      : Colors.white,
                                  splashColor: Colors.black,
                                  onPressed: () {
                                    homeController
                                        .changeAppPage(AppPage.book());
                                  },
                                  child: IntrinsicHeight(
                                      child: Row(
                                    children: [
                                      VerticalDivider(
                                        color: appPage == AppPage.book()
                                            ? theme.primaryColor
                                            : Colors.white,
                                        thickness: 3,
                                      ),
                                      horizontalSpace(),
                                      SvgPicture.asset(
                                        AppImage.book,
                                        width: 25,
                                        height: 25,
                                      ),
                                      horizontalSpace(),
                                      Text(
                                        "Books",
                                        style: textTheme.displayMedium,
                                      ),
                                    ],
                                  ))),
                            );
                          }),
                          verticalSpace(),
                          //Division
                          Obx(() {
                            final appPage = homeController.appPage.value;
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: HoverButton(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 0,
                                  ),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(
                                    15,
                                  )),
                                  hoverColor: Colors.grey.shade200,
                                  color: appPage == AppPage.division()
                                      ? Colors.grey.shade200
                                      : Colors.white,
                                  splashColor: Colors.black,
                                  onPressed: () {
                                    homeController
                                        .changeAppPage(AppPage.division());
                                  },
                                  child: IntrinsicHeight(
                                      child: Row(
                                    children: [
                                      VerticalDivider(
                                        color: appPage == AppPage.division()
                                            ? theme.primaryColor
                                            : Colors.white,
                                        thickness: 3,
                                      ),
                                      horizontalSpace(),
                                      SvgPicture.asset(
                                        AppImage.division,
                                        width: 25,
                                        height: 25,
                                      ),
                                      horizontalSpace(),
                                      Text(
                                        "Divisions",
                                        style: textTheme.displayMedium,
                                      ),
                                    ],
                                  ))),
                            );
                          }),

                          const SizedBox(
                            height: 100,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          InkWell(
                            onTap: () => loginController.logOut(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  horizontalSpace(),
                                  SvgPicture.asset(
                                    AppImage.powerOff,
                                    width: 25,
                                    height: 25,
                                  ),
                                  horizontalSpace(),
                                  Text(
                                    "Log Out",
                                    style: textTheme.displayMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  String getTitle(AppPage appPage) {
    if (appPage == AppPage.category()) {
      return "/Categories";
    } else if (appPage == AppPage.author()) {
      return "/Authors";
    } else if (appPage == AppPage.book()) {
      return "/Books";
    } else if (appPage == AppPage.division()) {
      return "/Divisions";
    } else {
      return "/";
    }
  }
}
