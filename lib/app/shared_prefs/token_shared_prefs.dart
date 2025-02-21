import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/error/failure.dart';

// class TokenSharedPrefs {
//   final SharedPreferences _sharedPreferences;

//   TokenSharedPrefs(this._sharedPreferences);

//   Future<Either<Failure, void>> saveToken(String token) async {
//     try {
//       await _sharedPreferences.setString('token', token);
//       return const Right(null);
//     } catch (e) {
//       return Left(SharedPrefsFailure(message: e.toString()));
//     }
//   }

//   Future<Either<Failure, String>> getToken() async {
//     try {
//       final token = _sharedPreferences.getString('token');
//       return Right(token ?? '');
//     } catch (e) {
//       return Left(SharedPrefsFailure(message: e.toString()));
//     }
//   }
// }

class TokenSharedPrefs {
  final SharedPreferences _sharedPreferences;

  TokenSharedPrefs(this._sharedPreferences);

  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      print("💾 Saving Token: $token"); // Debug Log
      await _sharedPreferences.setString('token', token);
      return const Right(null);
    } catch (e) {
      print("❌ Error Saving Token: $e"); // Debug Log
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> getToken() async {
    try {
      final token = _sharedPreferences.getString('token');
      print("📥 Retrieved Token from Storage: $token"); // Debug Log
      return Right(token ?? '');
    } catch (e) {
      print("❌ Error Retrieving Token: $e"); // Debug Log
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }
}
