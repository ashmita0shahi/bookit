import 'package:dio/dio.dart';

import '../../../../app/constants/api_endpoints.dart';
import '../../domain/entity/room_entity.dart';
import '../model/room_api_model.dart';

class RoomRemoteDataSource {
  final Dio dio;

  RoomRemoteDataSource({required this.dio});

  Future<List<RoomEntity>> getRooms() async {
    try {
      final response = await dio.get(ApiEndpoints.getAllRooms);
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => RoomApiModel.fromJson(json).toEntity()).toList();
      } else {
        throw Exception('Failed to fetch rooms');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<RoomEntity> getRoomById(String id) async {
    try {
      final response = await dio.get('${ApiEndpoints.getRoomById}$id');
      if (response.statusCode == 200) {
        final data = response.data;
        return RoomApiModel.fromJson(data).toEntity();
      } else {
        throw Exception('Failed to fetch room details');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}
