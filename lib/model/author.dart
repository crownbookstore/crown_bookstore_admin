import 'package:freezed_annotation/freezed_annotation.dart';

part 'author.freezed.dart';
part 'author.g.dart';

@freezed
class Author with _$Author {
  const factory Author({
    required String id,
    required String fullname,
    @JsonKey(defaultValue: 0) int? books,
    required String image,
    @JsonKey(defaultValue: false) required bool active,
    @JsonKey(nullable: true) DateTime? dateTime,
    @JsonKey(nullable: true) List<String>? searchList,
  }) = _Author;

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
}
