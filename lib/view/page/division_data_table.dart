import 'dart:developer';

import 'package:book_store_admin/controller/division_controller.dart';
import 'package:book_store_admin/controller/home_controller.dart';
import 'package:book_store_admin/utils/app_image.dart';
import 'package:book_store_admin/utils/constant.dart';
import 'package:book_store_admin/view/widgets/table_row_title.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import '../../controller/category_controller.dart';
import '../../utils/func.dart';

class DivisionDataTable extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;
  const DivisionDataTable({
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
    final DivisionController divisionController = Get.find();
    final colorLightTextTheme = textTheme.displayMedium?.copyWith(
      color: Colors.white,
    );
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Stack(
        children: [
          Obx(() {
            final searchItem = divisionController.searchItems;
            final selectedCategory = divisionController.selectedDivision.value;
            final categories = divisionController.divisions;
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
                    right: "ID",
                  ),
                ),
                DataColumn(
                  label: TableRowTitle(
                    left: AppImage.sort,
                    right: "Name",
                  ),
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
                searchItem.isNotEmpty ? searchItem.length : categories.length,
                (index) {
                  final item = searchItem.isNotEmpty
                      ? searchItem[index]
                      : categories[index];

                  return DataRow(
                    selected: selectedCategory?.id == item.id,
                    onSelectChanged: (v) {
                      divisionController.setSelectedID(item);
                    },
                    cells: [
                      DataCell(
                        Text(
                          item.id,
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      DataCell(
                        Text(
                          item.name,
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            iconSize: 25,
                            onPressed: () {
                              divisionController.deleteItem(item.id);
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
            final isToggleActive = divisionController.toggleActive.value;
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
                              child: SingleChildScrollView(
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
                                        onChanged: (v) => divisionController
                                            .debouncer
                                            .run(() {
                                          divisionController.nameCheck();
                                        }),
                                        style: textTheme.displaySmall,
                                        controller: divisionController
                                            .nameTextController,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(
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
                                          divisionController.nameError.value &&
                                              divisionController
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
                                    Row(
                                      children: [
                                        Text(
                                          "Townsips:",
                                          style:
                                              textTheme.displaySmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        horizontalSpace(),
                                        IconButton(
                                          onPressed: () {
                                            //TODO:ADD NEW EMPTY TOWNSHIP
                                            divisionController.addTownship();
                                          },
                                          icon: const Icon(
                                            FontAwesomeIcons.plus,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    verticalSpace(v: 10),
                                    //TODO:Township List
                                    Obx(() {
                                      final townships =
                                          divisionController.townships;
                                      final firstTimePressed =
                                          divisionController
                                              .firstTimePressed.value;
                                      return Form(
                                        key: divisionController.townshipFormKey,
                                        autovalidateMode: firstTimePressed
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                        child: ListView.separated(
                                          key: UniqueKey(),
                                          shrinkWrap: true,
                                          primary: false,
                                          itemCount: townships.length,
                                          separatorBuilder: (context, index) {
                                            return const Padding(
                                              padding: EdgeInsets.only(
                                                bottom: 20,
                                              ),
                                              child: Divider(
                                                thickness: 2,
                                              ),
                                            );
                                          },
                                          itemBuilder: (context, index) {
                                            final township = townships[index];

                                            return SizedBox(
                                              height: 220,
                                              key: UniqueKey(),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  //Name
                                                  TextFormField(
                                                    initialValue: township.name,
                                                    onChanged: (v) =>
                                                        divisionController
                                                            .debouncer
                                                            .run(() {
                                                      divisionController
                                                          .changeTownshipName(
                                                              v, index);
                                                    }),
                                                    style:
                                                        textTheme.displaySmall,
                                                    validator: (v) {
                                                      log("=====validate name");
                                                      if (!(v == null) &&
                                                          v.isNotEmpty) {
                                                        return null;
                                                      } else {
                                                        return "Name is required.";
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                      ),
                                                      border: dropDownBorder(),
                                                      disabledBorder:
                                                          dropDownBorder(),
                                                      focusedBorder:
                                                          dropDownBorder(),
                                                      enabledBorder:
                                                          dropDownBorder(),
                                                      labelText: "Name",
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                    ),
                                                  ),
                                                  verticalSpace(),
                                                  //Fee
                                                  TextFormField(
                                                    initialValue:
                                                        township.fee.toString(),
                                                    onChanged: (v) =>
                                                        divisionController
                                                            .debouncer
                                                            .run(() {
                                                      divisionController
                                                          .changeTownshipFee(
                                                              v, index);
                                                    }),
                                                    validator: (v) {
                                                      log("=====validate fee");
                                                      if (v == null) {
                                                        return "Fee is required.";
                                                      } else if (int.tryParse(
                                                              v) ==
                                                          null) {
                                                        return "Fee must be integer.";
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    style:
                                                        textTheme.displaySmall,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                      ),
                                                      border: dropDownBorder(),
                                                      disabledBorder:
                                                          dropDownBorder(),
                                                      focusedBorder:
                                                          dropDownBorder(),
                                                      enabledBorder:
                                                          dropDownBorder(),
                                                      labelText: "Fee",
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                    ),
                                                  ),
                                                  //Delete
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: IconButton(
                                                      onPressed: () =>
                                                          divisionController
                                                              .removeTownship(
                                                                  index),
                                                      icon: const Icon(
                                                        FontAwesomeIcons.remove,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                    Obx(() {
                                      final hasError = divisionController
                                              .townshipError.value &&
                                          divisionController
                                              .firstTimePressed.value;
                                      return hasError
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Text(
                                                "Townsihps can't be empty",
                                                style: textTheme.displaySmall
                                                    ?.copyWith(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            )
                                          : const SizedBox();
                                    }),

                                    verticalSpace(v: 40),
                                    Center(
                                      child: Obx(() {
                                        final isAdd = divisionController
                                                .selectedDivision.value ==
                                            null;
                                        return ElevatedButton(
                                          onPressed: () => isAdd
                                              ? divisionController.save()
                                              : divisionController.edit(),
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
                      final isAnimate = divisionController.animateToggle.value;
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
                                divisionController.changeToggleActive(),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Obx(() {
                                final selectedCategory =
                                    divisionController.selectedDivision.value;
                                final isToggleActive =
                                    divisionController.toggleActive.value;
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
