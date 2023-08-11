// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      id: json['_id'] as String?,
      user: json['user'] as String?,
      name: json['name'] as String?,
      rating: json['rating'] as int?,
      comment: json['comment'] as String?,
      time: json['time'] as String?,
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user': instance.user,
      'name': instance.name,
      'rating': instance.rating,
      'comment': instance.comment,
      'time': instance.time,
    };
