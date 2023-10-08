import 'dart:developer';
import 'dart:js' as js;
import 'package:book_store_admin/controller/home_controller.dart';
import 'package:book_store_admin/controller/order_controller.dart';
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

class OrderDataTable extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;
  const OrderDataTable({
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
    final OrderController orderController = Get.find();
    final colorLightTextTheme = textTheme.displayMedium?.copyWith(
      color: Colors.white,
    );
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Stack(
        children: [
          Obx(() {
            final searchItem = orderController.searchItems;
            final selectedCategory =
                orderController.selectedPurchaseModel.value;
            final categories = orderController.purchaseModels;
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
              columns: [
                DataColumn2(
                  label: TableRowTitle(
                    left: AppImage.sort,
                    right: "Customer Name",
                  ),
                  size: ColumnSize.S,
                  fixedWidth: width * 0.2,
                ),
                //Out of stock
                DataColumn2(
                  label: TableRowTitle(
                    left: AppImage.sort,
                    right: "Address",
                  ),
                  fixedWidth: width * 0.2,
                ),
                DataColumn2(
                  label: TableRowTitle(
                    left: AppImage.price,
                    right: "Total Price",
                  ),
                  fixedWidth: width * 0.15,
                ),
                DataColumn2(
                    label: TableRowTitle(
                      left: AppImage.sort,
                      right: "Delivery Information",
                    ),
                    size: ColumnSize
                        .S /* 
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
                      orderController.setSelectedID(item);
                    },
                    cells: [
                      DataCell(
                        Text(
                          item.name,
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      //address
                      DataCell(
                        Text(
                          item.address,
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      //total price
                      DataCell(
                        Text(
                          "${item.total} Ks",
                          style: textTheme.headlineSmall,
                        ),
                      ),

                      //Delivery information
                      DataCell(
                        Text(
                          item.deliveryTownshipInfo[0],
                          style: textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }),
          //Toggle
          Obx(() {
            final item = orderController.selectedPurchaseModel.value;
            final isDrawerClose = !homeController.drawerOpen.value;
            final isToggleActive = orderController.toggleActive.value;
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
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      verticalSpace(),
                                      Text(
                                        "Customer Name:",
                                        style: textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      verticalSpace(v: 10),
                                      Text(
                                        item?.name ?? "",
                                        style:
                                            textTheme.displayMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      verticalSpace(),
                                      //Email
                                      Text(
                                        "Email:",
                                        style: textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      verticalSpace(v: 10),
                                      Text(
                                        item?.email ?? "",
                                        style:
                                            textTheme.displayMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      verticalSpace(),
                                      //Phone
                                      Text(
                                        "Phone:",
                                        style: textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      verticalSpace(v: 10),
                                      Text(
                                        item?.phone ?? "",
                                        style:
                                            textTheme.displayMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      verticalSpace(),
                                      //Address
                                      Text(
                                        "Address:",
                                        style: textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      verticalSpace(v: 10),
                                      Text(
                                        item?.address ?? "",
                                        style:
                                            textTheme.displayMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      verticalSpace(),
                                      //Total
                                      Text(
                                        "Total:",
                                        style: textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      verticalSpace(v: 10),
                                      Text(
                                        "${item?.total}Ks",
                                        style:
                                            textTheme.displayMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      verticalSpace(),
                                      //Delivery information
                                      Text(
                                        "Delivery Informations:",
                                        style: textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      verticalSpace(v: 10),
                                      Text(
                                        "${item?.deliveryTownshipInfo[0]} = ${item?.deliveryTownshipInfo[1]}Ks",
                                        style:
                                            textTheme.displayMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      verticalSpace(),
                                      //DateTime
                                      Text(
                                        "Created At:",
                                        style: textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      verticalSpace(v: 10),
                                      Text(
                                        dateFormat(item?.dateTime ?? ""),
                                        style:
                                            textTheme.displayMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      verticalSpace(),
                                      //BankSlip Image
                                      item?.bankSlipImage == null
                                          ? verticalSpace(v: 0)
                                          : InkWell(
                                              onTap: () {
                                                js.context.callMethod('open',
                                                    [item.bankSlipImage]);
                                              },
                                              child: Image.network(
                                                item!.bankSlipImage!,
                                                height: 150,
                                              ),
                                            ),
                                      verticalSpace(),
                                      Text(
                                        "Books:",
                                        style: textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      verticalSpace(v: 10),
                                      //Items
                                      ListView.separated(
                                        shrinkWrap: true,
                                        primary: false,
                                        itemBuilder: (context, index) {
                                          final book = item?.items[index];
                                          return ListTile(
                                            leading: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.black,
                                              child: Text("${index + 1}",
                                                  style: textTheme.displaySmall
                                                      ?.copyWith(
                                                          color: Colors.white)),
                                            ),
                                            title: Text(book?.title ?? "",
                                                style: textTheme.displayMedium),
                                            trailing: Text(
                                                "${book?.price}Ks ✕ ${book?.count}"),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Divider();
                                        },
                                        itemCount: item?.items.length ?? 0,
                                      )
                                    ],
                                  ),
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
                      final isAnimate = orderController.animateToggle.value;
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
                            onTap: () => orderController.changeToggleActive(),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Obx(() {
                                final isToggleActive =
                                    orderController.toggleActive.value;
                                return Icon(
                                  isToggleActive
                                      ? FontAwesomeIcons.chevronRight
                                      : FontAwesomeIcons.chevronLeft,
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
