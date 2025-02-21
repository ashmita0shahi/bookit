import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dartz/dartz.dart';

import '../../../../app/shared_prefs/token_shared_prefs.dart';
import '../../../../core/error/failure.dart';
import '../../../auth/domain/entity/auth_entity.dart';
import '../../domain/repository/user_repository.dart';
import '../data_source/user_remote_data_source.dart';

// class UserRemoteRepositoryImpl implements UserRepository {
//   final UserRemoteDataSource userRemoteDataSource;
//   final TokenSharedPrefs tokenSharedPrefs;

//   UserRemoteRepositoryImpl(this.userRemoteDataSource, this.tokenSharedPrefs);

//   @override
//   Future<Either<Failure, AuthEntity>> getUserProfile() async {
//     try {
//       // ✅ 1. Retrieve token
//       final tokenResult = await tokenSharedPrefs.getToken();
//       return tokenResult.fold(
//         (failure) => Left(failure),
//         (token) async {
//           if (token.isEmpty) {
//             return const Left(ApiFailure(message: "Token is empty"));
//           }

//           print("Retrieved Token: $token"); // ✅ Debugging log

//           try {
//             final decodedToken = JWT.decode(token);
//             print(
//                 "Decoded Payload: ${decodedToken.payload}"); // ✅ Debugging log

//             final userId =
//                 decodedToken.payload['id']; // 🔍 Check if 'id' exists
//             if (userId == null) {
//               return const Left(
//                   ApiFailure(message: "User ID not found in token"));
//             }

//             final userModel =
//                 await userRemoteDataSource.getUserProfile(userId, token);
//             return Right(userModel.toEntity());
//           } catch (e) {
//             print("JWT Decoding Error: $e"); // ✅ Log decoding errors
//             return const Left(ApiFailure(message: "Failed to decode token"));
//           }
//         },
//       );
//     } catch (e) {
//       return Left(ApiFailure(message: e.toString()));
//     }
//   }
// }

class UserRemoteRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  final TokenSharedPrefs tokenSharedPrefs;

  UserRemoteRepositoryImpl(this.userRemoteDataSource, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, AuthEntity>> getUserProfile() async {
    try {
      print("📡 Retrieving Token for User Profile...");
      final tokenResult = await tokenSharedPrefs.getToken();

      return tokenResult.fold(
        (failure) {
          print("❌ Failed to retrieve token: ${failure.message}");
          return Left(failure);
        },
        (token) async {
          if (token.isEmpty) {
            print("❌ Token is empty");
            return const Left(ApiFailure(message: "Token is empty"));
          }

          print("✅ Token to be sent: $token");

          final decodedToken = JWT.decode(token);
          print("✅ Decoded Token Payload: ${decodedToken.payload}");

          final userId = decodedToken
              .payload['id']; // Make sure 'id' is inside the payload

          if (userId == null || userId is! String) {
            print("❌ User ID is null or invalid");
            return const Left(
                ApiFailure(message: "User ID not found in token"));
          }

          print("📤 Fetching Profile for User ID: $userId");

          final userModel =
              await userRemoteDataSource.getUserProfile(userId, token);
          print("✅ Successfully Retrieved User Profile: ${userModel.toJson()}");

          return Right(userModel.toEntity());
        },
      );
    } catch (e) {
      print("❌ Error in getUserProfile: $e");
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
