import '../../../../app/constants/api_endpoints.dart';

class UserModel {
  final String id;
  final String fullname;
  final String address;
  final String phone;
  final String email;
  final String? image;

  UserModel({
    required this.id,
    required this.fullname,
    required this.address,
    required this.phone,
    required this.email,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"],
      fullname: json["fullname"],
      address: json["address"],
      phone: json["phone"],
      email: json["email"],
      image: json["image"] != null ? ApiEndpoints.imageUrl + json["image"] : null,
    );
  }
}
