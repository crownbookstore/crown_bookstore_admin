import 'dart:developer';

import 'package:book_store_admin/controller/author_controller.dart';
import 'package:book_store_admin/controller/book_controller.dart';
import 'package:book_store_admin/controller/home_controller.dart';
import 'package:book_store_admin/utils/app_image.dart';
import 'package:book_store_admin/utils/constant.dart';
import 'package:book_store_admin/view/widgets/table_row_title.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controller/category_controller.dart';
import '../../utils/func.dart';

class BooksDataTable extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;
  const BooksDataTable({
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
    final BookController bookController = Get.find();
    final CategoryController categoryController = Get.find();
    final AuthorController authorController = Get.find();
    final colorLightTextTheme = textTheme.displayMedium?.copyWith(
      color: Colors.white,
    );
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Stack(
        children: [
          Obx(() {
            final searchItems = bookController.searchItems;
            final selectedBook = bookController.selectedBook.value;
            final books = bookController.books;
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
                DataColumn2(
                  label: TableRowTitle(
                    left: AppImage.price,
                    right: "Price",
                  ),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: TableRowTitle(
                    left: AppImage.link,
                    right: "Image",
                  ),
                  size: ColumnSize.S,
                ),
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
                searchItems.isNotEmpty ? searchItems.length : books.length,
                (index) {
                  final item = searchItems.isNotEmpty
                      ? searchItems[index]
                      : books[index];
                  return DataRow(
                    selected: selectedBook?.id == item.id,
                    onSelectChanged: (v) {
                      bookController.setSelectedID(item);
                    },
                    cells: [
                      DataCell(
                        Text(
                          item.title,
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      //Price
                      DataCell(
                        Text(
                          "${item.price} Ks",
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      //Image
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

                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            iconSize: 25,
                            onPressed: () {
                              bookController.deleteItem(item.id);
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
            final isToggleActive = bookController.toggleActive.value;
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
                              left: 30,
                              right:
                                  isTablet ? 20 : (!isDrawerClose ? 300 : 20),
                            ),
                            child: Visibility(
                              visible: isToggleActive,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
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
                                            bookController.debouncer.run(() {
                                          bookController.nameCheck();
                                        }),
                                        style: textTheme.displaySmall,
                                        controller:
                                            bookController.titleTextController,
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
                                      final hasError = bookController
                                              .nameError.value &&
                                          bookController.firstTimePressed.value;
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
                                      "Description:",
                                      style: textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    verticalSpace(v: 10),
                                    TextFormField(
                                      onChanged: (v) =>
                                          bookController.debouncer.run(() {
                                        bookController.descCheck();
                                      }),
                                      maxLines: 5,
                                      style: textTheme.displaySmall,
                                      controller:
                                          bookController.descTextController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        border: dropDownBorder(),
                                        disabledBorder: dropDownBorder(),
                                        focusedBorder: dropDownBorder(),
                                        enabledBorder: dropDownBorder(),
                                        /*  labelText: "Name", */
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                    ),
                                    Obx(() {
                                      final hasError = bookController
                                              .descriptionError.value &&
                                          bookController.firstTimePressed.value;
                                      return hasError
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Text(
                                                "Description is required",
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
                                              controller: bookController
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
                                                disabledBorder:
                                                    dropDownBorder(),
                                                focusedBorder: dropDownBorder(),
                                                enabledBorder: dropDownBorder(),
                                              ),
                                            ),
                                          ),
                                          //Pick Icon
                                          InkWell(
                                            onTap: () =>
                                                bookController.pickImage(0),
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
                                      final hasError = bookController
                                              .imageError.value &&
                                          bookController.firstTimePressed.value;
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
                                    //Price
                                    Text(
                                      "Price:",
                                      style: textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    verticalSpace(v: 10),
                                    SizedBox(
                                      height: 30,
                                      child: TextFormField(
                                        onChanged: (v) =>
                                            bookController.debouncer.run(() {
                                          bookController.priceCheck();
                                        }),
                                        style: textTheme.displaySmall,
                                        controller:
                                            bookController.priceTextController,
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
                                      final hasError = bookController
                                              .priceError.value &&
                                          bookController.firstTimePressed.value;
                                      return hasError
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Text(
                                                "Price is required",
                                                style: textTheme.displaySmall
                                                    ?.copyWith(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            )
                                          : const SizedBox();
                                    }),
                                    //Score
                                    verticalSpace(),
                                    Text(
                                      "Discount Price:",
                                      style: textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    verticalSpace(v: 10),
                                    SizedBox(
                                      height: 30,
                                      child: TextFormField(
                                        style: textTheme.displaySmall,
                                        controller: bookController
                                            .discountPriceTextController,
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
                                    verticalSpace(),
                                    Text(
                                      "Score:",
                                      style: textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    verticalSpace(v: 10),
                                    SizedBox(
                                      height: 30,
                                      child: TextFormField(
                                        onChanged: (v) =>
                                            bookController.debouncer.run(() {
                                          bookController.scoreCheck();
                                        }),
                                        style: textTheme.displaySmall,
                                        controller:
                                            bookController.scoreTextController,
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
                                    verticalSpace(),
                                    //Category
                                    Text(
                                      "Category:",
                                      style: textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    verticalSpace(v: 10),
                                    SizedBox(
                                      height: 30,
                                      child: Obx(
                                        () {
                                          log("==========Category DropDown Change");
                                          final categories =
                                              categoryController.categories;
                                          final controller = bookController
                                              .categoryDropDownController.value;
                                          return DropDownTextField(
                                            controller: controller,
                                            clearOption: true,
                                            textFieldDecoration:
                                                InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(5),
                                              border: dropDownBorder(),
                                              disabledBorder: dropDownBorder(),
                                              focusedBorder: dropDownBorder(),
                                              enabledBorder: dropDownBorder(),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                            ),
                                            validator: (value) {},
                                            dropDownItemCount: 10,
                                            dropDownList: categories
                                                .map((e) => DropDownValueModel(
                                                      name: e.name,
                                                      value: e.id,
                                                    ))
                                                .toList(),
                                            onChanged: (val) {
                                              final value =
                                                  val as DropDownValueModel;
                                              bookController
                                                  .setSelectedCategory(
                                                      value.value);
                                              bookController.categoryCheck();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Obx(() {
                                      final hasError = bookController
                                              .categoryIdError.value &&
                                          bookController.firstTimePressed.value;
                                      return hasError
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Text(
                                                "Category is required",
                                                style: textTheme.displaySmall
                                                    ?.copyWith(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            )
                                          : const SizedBox();
                                    }),
                                    //Author
                                    verticalSpace(),
                                    Text(
                                      "Author:",
                                      style: textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    verticalSpace(v: 10),
                                    SizedBox(
                                      height: 30,
                                      child: Obx(
                                        () {
                                          final authors =
                                              authorController.authors;
                                          return DropDownTextField(
                                            controller: bookController
                                                .authorDropDownController.value,
                                            clearOption: true,
                                            textFieldDecoration:
                                                InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(5),
                                              border: dropDownBorder(),
                                              disabledBorder: dropDownBorder(),
                                              focusedBorder: dropDownBorder(),
                                              enabledBorder: dropDownBorder(),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                            ),
                                            validator: (value) {},
                                            dropDownItemCount: 10,
                                            dropDownList: authors
                                                .map((e) => DropDownValueModel(
                                                      name: e.fullname,
                                                      value: e.id,
                                                    ))
                                                .toList(),
                                            onChanged: (val) {
                                              final value =
                                                  val as DropDownValueModel;
                                              bookController.setSelectedAuthor(
                                                  value.value);
                                              bookController.authorCheck();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Obx(() {
                                      final hasError = bookController
                                              .authorIdError.value &&
                                          bookController.firstTimePressed.value;
                                      return hasError
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Text(
                                                "Author is required",
                                                style: textTheme.displaySmall
                                                    ?.copyWith(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            )
                                          : const SizedBox();
                                    }),
                                    verticalSpace(),

                                    verticalSpace(v: 40),
                                    Center(
                                      child: Obx(() {
                                        final isAdd =
                                            bookController.selectedBook.value ==
                                                null;
                                        return ElevatedButton(
                                          onPressed: () => isAdd
                                              ? bookController.save()
                                              : bookController.edit(),
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
                    ),

                    //LeftCenter Toggle
                    Obx(() {
                      final top = (constraints.maxHeight * 0.5) - 25;
                      final isAnimate = bookController.animateToggle.value;
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
                            onTap: () => bookController.changeToggleActive(),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Obx(() {
                                final selectedBook =
                                    bookController.selectedBook.value;
                                final isToggleActive =
                                    bookController.toggleActive.value;
                                return Icon(
                                  selectedBook == null
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
