import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String firstName;
  final String lastName;

  final String phoneNumber;
  // final BatchEntity batch;
  // final List<CourseEntity> courses;
  final String username;
  final String password;

  const UserEntity({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,

    // required this.batch,
    // required this.courses,
    required this.username,
    required this.password,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [username,password,firstName,lastName,phoneNumber];

  // factory AuthEntity.fromJson(Map<String, dynamic> json) => AuthEntity(
  //       id: json["id"],
  //       fname: json["fname"],
  //       lname: json["lname"],

  //       phone: json["phone"],
  //       // batch: BatchEntity.fromJson(json["batch"]),
  //       // courses: List<CourseEntity>.from(
  //       //     json["courses"].map((x) => CourseEntity.fromJson(x))),
  //       username: json["username"],
  //       password: json["password"],
  //     );

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "fname": fname,
  //       "lname": lname,
  //       "image": image,
  //       "phone": phone,
  //       // "batch": batch == null ? null : batch.toJson(),
  //       // "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
  //       "username": username,
  //       "password": password,
  //     };

  // @override
  // List<Object?> get props => [
  //       fname,
  //       lname,
  //       image,
  //       phone,
  //       // batch,
  //       // courses,
  //       username,
  //       password,
  //     ];
}
