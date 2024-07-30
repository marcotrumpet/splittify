// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'found_raise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoundRaiseModelImpl _$$FoundRaiseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FoundRaiseModelImpl(
      id: json['id'] as String,
      creatorEmail: json['creatorEmail'] as String,
      recipientEmail: json['recipientEmail'] as String,
      goal: json['goal'] as num,
      fee: json['fee'] as num,
      attendeesEmail: (json['attendeesEmail'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      creationDate: json['creationDate'] as String,
      dueDate: json['dueDate'] as String?,
      birthday: json['birthday'] as String?,
    );

Map<String, dynamic> _$$FoundRaiseModelImplToJson(
        _$FoundRaiseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creatorEmail': instance.creatorEmail,
      'recipientEmail': instance.recipientEmail,
      'goal': instance.goal,
      'fee': instance.fee,
      'attendeesEmail': instance.attendeesEmail,
      'creationDate': instance.creationDate,
      'dueDate': instance.dueDate,
      'birthday': instance.birthday,
    };
