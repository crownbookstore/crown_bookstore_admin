import 'dart:developer';

import 'package:book_store_admin/controller/home_controller.dart';
import 'package:book_store_admin/utils/app_image.dart';
import 'package:book_store_admin/utils/constant.dart';
import 'package:book_store_admin/view/widgets/table_row_title.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/category_controller.dart';
import '../../utils/func.dart';

class CategoriesDataTable extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;
  const CategoriesDataTable({
    super.key,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    dropDownBorder() => const OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.black,
        ));
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final HomeController homeController = Get.find();
    final CategoryController categoryController = Get.find();
    final colorLightTextTheme = textTheme.displayMedium?.copyWith(
      color: Colors.white,
    );
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Stack(
        children: [
          Obx(() {
            final searchItem = categoryController.searchItems;
            final selectedCategory = categoryController.selectedCategory.value;
            final categories = categoryController.categories;
            return DataTable2(
              border: TableBorder(
                left: BorderSide(
                  color: theme.dividerColor,
                ),
                top: BorderSide(
                  color: theme.dividerColor,
                ),
              ),
              showCheckboxColumn: true,
              /* scrollController: scrollController, */
              columnSpacing: 20,
              horizontalMargin: 20,
              minWidth: 200,
              /* onSelectAll: (v) => newsController.setSli, */
              columns: const [
                DataColumn(
                  label: TableRowTitle(
                    left: AppImage.sort,
                    right: "Name",
                  ),
                ),
                //Out of stock
                DataColumn2(
                  label: TableRowTitle(
                    left: AppImage.link,
                    right: "Image",
                  ),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                    label: TableRowTitle(
                      left: AppImage.toggle,
                      right: "Active",
                      imageType: ImageType.png,
                    ),
                    /* size: ColumnSize.S, */
                    fixedWidth: 150),
                DataColumn2(
                    label: TableRowTitle(
                      left: AppImage.rocket,
                      right: "Action",
                      imageType: ImageType.png,
                    ),
                    size: ColumnSize
                        .L /* 
                      fixedWidth: 135, */
                    ),
              ],
              rows: List.generate(
                searchItem.isNotEmpty ? searchItem.length : categories.length,
                (index) {
                  final item = searchItem.isNotEmpty
                      ? searchItem[index]
                      : categories[index];

                  return DataRow(
                    selected: selectedCategory?.id == item.id,
                    onSelectChanged: (v) {
                      categoryController.setSelectedID(item);
                    },
                    cells: [
                      DataCell(
                        Text(
                          item.name,
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      //Total Items
                      DataCell(Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: Image.network(
                          item.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      )),

                      DataCell(
                        Switch(
                          value: item.active,
                          onChanged: (_) {},
                        ),
                      ),

                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            iconSize: 25,
                            onPressed: () {
                              categoryController.deleteItem(item.id);
                            },
                            icon: Icon(
                              FontAwesomeIcons.trash,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          /* IconButton(
                            iconSize: 25,
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.eye,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          IconButton(
                            iconSize: 25,
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.pen,
                              color: Colors.grey.shade600,
                            ),
                          ), */
                        ],
                      )),
                    ],
                  );
                },
              ),
            );
          }),
          //Toggle
          Obx(() {
            final isDrawerClose = !homeController.drawerOpen.value;
            final isToggleActive = categoryController.toggleActive.value;
            return AnimatedPositioned(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 200),
              top: 0,
              right: isToggleActive
                  ? 0
                  : isDrawerClose
                      ? (isTablet ? -width * 0.4 : -width * 0.45)
                      : (isTablet
                          ? -width * 0.4
                          : isDesktop
                              ? -width * 0.25
                              : -width * 0.2) /* : -width * 0.26) */,
              child: SizedBox(
                height: constraints.maxHeight,
                width: width * 0.5,
                child: Stack(
                  children: [
                    //Content Card
                    Positioned(
                      left: 20,
                      top: 0,
                      child: SizedBox(
                        height: constraints.maxHeight,
                        width: isDrawerClose
                            ? width * 0.5
                            : width * 0.5 /* 0.35 */,
                        child: Card(
                          elevation: 5,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              right:
                                  isTablet ? 20 : (!isDrawerClose ? 300 : 20),
                            ),
                            child: Visibility(
                              visible: isToggleActive,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  verticalSpace(),
                                  Text(
                                    "Name:",
                                    style: textTheme.displaySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  verticalSpace(v: 10),
                                  SizedBox(
                                    height: 30,
                                    child: TextFormField(
                                      onChanged: (v) =>
                                          categoryController.debouncer.run(() {
                                        categoryController.nameCheck();
                                      }),
                                      style: textTheme.displaySmall,
                                      controller:
                                          categoryController.nameTextController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        border: dropDownBorder(),
                                        disabledBorder: dropDownBorder(),
                                        focusedBorder: dropDownBorder(),
                                        enabledBorder: dropDownBorder(),
                                        /*  labelText: "Name", */
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                    ),
                                  ),
                                  Obx(() {
                                    final hasError =
                                        categoryController.nameError.value &&
                                            categoryController
                                                .firstTimePressed.value;
                                    return hasError
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                            ),
                                            child: Text(
                                              "Name is required",
                                              style: textTheme.displaySmall
                                                  ?.copyWith(
                                                color: Colors.red,
                                              ),
                                            ),
                                          )
                                        : const SizedBox();
                                  }),
                                  verticalSpace(),
                                  Text(
                                    "Image:",
                                    style: textTheme.displaySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  verticalSpace(v: 10),
                                  SizedBox(
                                    height: 30,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //Image Link
                                        Expanded(
                                          child: TextFormField(
                                            onChanged: (v) => categoryController
                                                .debouncer
                                                .run(() {
                                              categoryController.imageCheck();
                                            }),
                                            controller: categoryController
                                                .imageTextController,
                                            maxLines: 1,
                                            style: textTheme.displaySmall
                                                ?.copyWith(
                                              color: Colors.black,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            validator: (v) {},
                                            /* controller: nameTextController, */
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              border: dropDownBorder(),
                                              disabledBorder: dropDownBorder(),
                                              focusedBorder: dropDownBorder(),
                                              enabledBorder: dropDownBorder(),
                                            ),
                                          ),
                                        ),
                                        //Pick Icon
                                        InkWell(
                                          onTap: () =>
                                              categoryController.pickImage(0),
                                          child: SvgPicture.asset(
                                            AppImage.image,
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Obx(() {
                                    final hasError =
                                        categoryController.imageError.value &&
                                            categoryController
                                                .firstTimePressed.value;
                                    return hasError
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                            ),
                                            child: Text(
                                              "Image is required",
                                              style: textTheme.displaySmall
                                                  ?.copyWith(
                                                color: Colors.red,
                                              ),
                                            ),
                                          )
                                        : const SizedBox();
                                  }),
                                  verticalSpace(),
                                  Text(
                                    "Active:",
                                    style: textTheme.displaySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  verticalSpace(v: 10),
                                  Obx(() {
                                    final value =
                                        categoryController.selectedToggle.value;
                                    return Switch(
                                      value: value,
                                      onChanged: (v) {
                                        categoryController
                                            .selectedToggle.value = v;
                                      },
                                    );
                                  }),
                                  verticalSpace(v: 40),
                                  Center(
                                    child: Obx(() {
                                      final isAdd = categoryController
                                              .selectedCategory.value ==
                                          null;
                                      return ElevatedButton(
                                        onPressed: () => isAdd
                                            ? categoryController.save()
                                            : categoryController.edit(),
                                        child: isAdd
                                            ? Text("ADD")
                                            : Text("UPDATE"),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //LeftCenter Toggle
                    Obx(() {
                      final top = (constraints.maxHeight * 0.5) - 25;
                      final isAnimate = categoryController.animateToggle.value;
                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                        left: 5,
                        top: isAnimate ? top - 20 : top,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () =>
                                categoryController.changeToggleActive(),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Obx(() {
                                final selectedCategory =
                                    categoryController.selectedCategory.value;
                                final isToggleActive =
                                    categoryController.toggleActive.value;
                                return Icon(
                                  selectedCategory == null
                                      ? FontAwesomeIcons.plus
                                      : (isToggleActive
                                          ? FontAwesomeIcons.chevronRight
                                          : FontAwesomeIcons.chevronLeft),
                                  color: Colors.grey,
                                );
                              }),
                            ),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            );
          }),
        ],
      );
    });
  }
}
