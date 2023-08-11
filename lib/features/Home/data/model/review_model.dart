import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  @JsonKey(name: '_id')
  String? id;
  String? user;
  String? name;
  int? rating;
  String? comment;
  String? time;

  ReviewModel({
    this.id,
    this.user,
    this.name,
    this.rating,
    this.comment,
    this.time,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}
