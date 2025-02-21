import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/auth_entity.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String fullname;
  final String address;
  final String phoneno;
  final String? image;
  final String email;
  final String password; // ✅ Ensure password is NOT nullable

  const AuthApiModel({
    this.userId,
    required this.fullname,
    required this.address,
    required this.phoneno,
    required this.image,
    required this.email,
    required this.password, // ✅ Ensure password is always required
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  // toEntity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      fullname: fullname,
      address: address,
      image: image,
      phoneNo: phoneno,
      email: email,
      password: password, // ✅ Ensure password is passed correctly
    );
  }

  @override
  List<Object?> get props =>
      [userId, fullname, address, phoneno, image, email, password];
}
