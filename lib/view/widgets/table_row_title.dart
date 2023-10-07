import 'package:book_store_admin/utils/app_image.dart';
import 'package:book_store_admin/utils/constant.dart';
import 'package:book_store_admin/utils/func.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TableRowTitle extends StatelessWidget {
  final String left;
  final String right;
  final ImageType imageType;
  const TableRowTitle({
    super.key,
    required this.left,
    required this.right,
    this.imageType = ImageType.svg,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        imageType == ImageType.png
            ? Image.asset(
                left,
                width: left == AppImage.toggle ? 35 : 20,
                height: left == AppImage.toggle ? 35 : 20,
              )
            : SvgPicture.asset(
                left,
                width: 20,
                height: 20,
              ),
        horizontalSpace(v: 10),
        Text(
          right,
          style: textTheme.displayMedium,
        ),
      ],
    );
  }
}
