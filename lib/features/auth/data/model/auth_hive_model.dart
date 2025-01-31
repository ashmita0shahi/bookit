import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/constants/hive_table_constant.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? fullname;
  @HiveField(2)
  final String? address;
  @HiveField(3)
  final String? phoneNo;
  @HiveField(4)
  final String email;
  @HiveField(5)
  final String password;
  // @HiveField(3)
  // final bool isAdmin;

  UserHiveModel({
    String? id,
    required this.fullname,
    required this.phoneNo,
    required this.address,
    required this.email,
    required this.password,

    // this.isAdmin = false,
  }) : id = id ?? const Uuid().v4();

  // Initial Constructor
  const UserHiveModel.initial()
      : id = '',
        fullname = '',
        phoneNo = '',
        address = '',
        email = '',
        password = '';
  // isAdmin = false;

  // From Entity as JSOn
  factory UserHiveModel.fromJson(Map<String, dynamic> json) {
    return UserHiveModel(
      id: json['id'] as String?,
      fullname: json['fullName'],
      phoneNo: json['phoneNo'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String,
      password: json['password'] as String,
      // isAdmin: json['isAdmin'] as bool? ?? false,
    );
  }

  // To Enstity as JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullname,
      'phoneNo': phoneNo,
      'address': address,
      'email': email,
      'password': password,
      // 'isAdmin': isAdmin,
    };
  }

  @override
  List<Object?> get props => [id, fullname, phoneNo, address, email, password];
}
