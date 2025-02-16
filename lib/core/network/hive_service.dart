import 'package:bookit/app/constants/hive_table_constant.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/auth/data/model/auth_hive_model.dart';
import '../../features/rooms/data/model/room_hive_model.dart';

class HiveService {
  static Future<void> init() async {
    // Initialize the database
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}/bookit.db';

    Hive.init(path);

    // Register Adapters
    Hive.registerAdapter(UserHiveModelAdapter());
    Hive.registerAdapter(RoomHiveModelAdapter());
  }

  // User Queries

  // Add or Register a User
  Future<void> addUser(UserHiveModel user) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.id, user);
  }

  // Delete a User
  Future<void> deleteUser(String id) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(id);
  }

  // Get All Users
  Future<List<UserHiveModel>> getAllUsers() async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    return box.values.toList();
  }

  // Find User by Email and Password (Login)
  Future<UserHiveModel?> login(String email, String password) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    try {
      return box.values.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null; // Return null if no user is found
    }
  }

  // Clear All Data
  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  // Clear Specific User Box
  Future<void> clearUserBox() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  // Close Hive Database
  Future<void> close() async {
    await Hive.close();
  }

  // Room Queries

// Add or Register a Room
  Future<void> addRoom(RoomHiveModel room) async {
    var box = await Hive.openBox<RoomHiveModel>(HiveTableConstant.roomBox);
    await box.put(room.roomId, room);
  }

// Delete a Room by ID
  Future<void> deleteRoom(String roomId) async {
    var box = await Hive.openBox<RoomHiveModel>(HiveTableConstant.roomBox);
    await box.delete(roomId);
  }

// Get All Rooms
  Future<List<RoomHiveModel>> getAllRooms() async {
    var box = await Hive.openBox<RoomHiveModel>(HiveTableConstant.roomBox);
    return box.values.toList();
  }

// Get Room by ID
  Future<RoomHiveModel?> getRoomById(String roomId) async {
    var box = await Hive.openBox<RoomHiveModel>(HiveTableConstant.roomBox);
    return box.get(roomId);
  }
}
