import 'package:freezed_annotation/freezed_annotation.dart';

import 'book.dart';

part 'purchase.freezed.dart';
part 'purchase.g.dart';

@freezed
class PurchaseModel with _$PurchaseModel {
  @JsonSerializable(explicitToJson: true)
  factory PurchaseModel({
    required String id,
    required List<Book> items,
    required String name,
    required String email,
    required String phone,
    required String address,
    required int total,
    required List deliveryTownshipInfo,
    @JsonKey(nullable: true) String? bankSlipImage,
    String? paymentMethod,
    required String dateTime,
    @JsonKey(nullable: true, defaultValue: 0) int? status,
  }) = _PurchaseModel;
  factory PurchaseModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseModelFromJson(json);
}
