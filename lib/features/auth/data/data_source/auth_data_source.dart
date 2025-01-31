import 'dart:io';

import '../../domain/entity/auth_entity.dart';


abstract interface class IAuthDataSource {
  Future<String> loginUser(String username, String password);

  Future<void> registerUser(AuthEntity user);

  Future<AuthEntity> getCurrentUser();

  Future<void> verifyEmail(String email, String otp);

  Future<String> uploadProfilePicture(File file);
}
