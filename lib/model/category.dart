import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class AppCategory with _$AppCategory {
  const factory AppCategory({
    required String id,
    required String name,
    required String image,
    @JsonKey(defaultValue: false) required bool active,
    @JsonKey(nullable: true) DateTime? dateTime,
    @JsonKey(nullable: true) List<String>? searchList,
  }) = _AppCategory;

  factory AppCategory.fromJson(Map<String, dynamic> json) =>
      _$AppCategoryFromJson(json);
}
