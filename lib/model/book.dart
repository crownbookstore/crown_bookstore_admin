import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  const factory Book({
    required String id,
    required String title,
    required String description,
    required String image,
    required int price,
    int? discountPrice,
    double? score,
    String? authorId,
    String? categoryId,
    String? authorName,
    String? authorImage,
    String? categoryName,
    String? categoryImage,
    @JsonKey(nullable: true) int? count,
    @JsonKey(nullable: true) DateTime? dateTime,
    @JsonKey(nullable: true) List<String>? searchList,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}
