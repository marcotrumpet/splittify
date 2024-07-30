import 'package:freezed_annotation/freezed_annotation.dart';

part 'found_raise_model.freezed.dart';
part 'found_raise_model.g.dart';

@freezed
class FoundRaiseModel with _$FoundRaiseModel {
  @JsonSerializable(explicitToJson: true)
  factory FoundRaiseModel({
    required String id,
    required String creatorEmail,
    required String recipientEmail,
    required num goal,
    required num fee,
    required List<String> attendeesEmail,
    required String creationDate,
    String? dueDate,
    String? birthday,
  }) = _FoundRaiseModel;

  factory FoundRaiseModel.fromJson(Map<String, dynamic> json) =>
      _$FoundRaiseModelFromJson(json);
}
