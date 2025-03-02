import 'package:dio/dio.dart';

import '../../../../app/constants/api_endpoints.dart';
import '../../../../core/error/failure.dart';
import '../../../auth/data/model/auth_api_model.dart';

abstract class UserRemoteDataSource {
  Future<AuthApiModel> getUserProfile(String userId, String token);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio; // ✅ Inject Dio instead of ApiService

  UserRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthApiModel> getUserProfile(String userId, String token) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getuser + userId, // ✅ Use ApiEndpoints
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        print("✅ API Response: $jsonData"); // Debug log

        return AuthApiModel.fromJson({
          "_id": jsonData["_id"] ?? "",
          "fullname": jsonData["fullname"] ?? "Unknown",
          "address": jsonData["address"] ?? "No Address",
          "phoneno": jsonData["phone"] ?? "No Phone",
          "image": jsonData["image"],
          "email": jsonData["email"] ?? "No Email",
          "password": jsonData["password"] ?? "",
          "otp": jsonData["otp"],
          "otpExpires": jsonData["otpExpires"],
        });
      } else {
        throw const ApiFailure(message: "Failed to fetch user profile");
      }
    } catch (e) {
      print("❌ Error in getUserProfile: $e");
      throw ApiFailure(message: e.toString());
    }
  }
}
