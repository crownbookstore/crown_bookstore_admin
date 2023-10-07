import 'package:flutter/material.dart';

verticalSpace({double v = 20}) => SizedBox(
      height: v,
    );
horizontalSpace({double v = 20}) => SizedBox(
      width: v,
    );

List<String> getStringList(String v) {
  List<String> subName = [];
  var subList = v.split('');
  for (var i = 0; i < subList.length; i++) {
    subName.add(v.substring(0, i + 1).toLowerCase());
  }
  return subName;
}
