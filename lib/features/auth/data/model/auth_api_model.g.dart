// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
      userId: json['_id'] as String?,
      fullname: json['fullname'] as String,
      address: json['address'] as String,
      phoneno: json['phoneno'] as String,
      image: json['image'] as String?,
      email: json['email'] as String,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'fullname': instance.fullname,
      'address': instance.address,
      'phoneno': instance.phoneno,
      'image': instance.image,
      'email': instance.email,
      'password': instance.password,
    };
