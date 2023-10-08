import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_page.freezed.dart';

@freezed
class AppPage with _$AppPage {
  const factory AppPage.category() = _Category;
  const factory AppPage.author() = _Author;
  const factory AppPage.book() = _Book;
  const factory AppPage.division() = _Division;
  const factory AppPage.order() = _Order;
}
