import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String fullname;
  final String phoneNo;
  final String address;
  final String? image;
  final String email;
  final String password;
  // final bool isAdmin;

  const AuthEntity({
    this.userId,
    required this.fullname,
    required this.phoneNo,
    required this.address,
    this.image,
    required this.email,
    required this.password,
    // this.isAdmin = false,
  });

  @override
  List<Object?> get props =>
      [userId, fullname, phoneNo, address, image, email, password];
}
