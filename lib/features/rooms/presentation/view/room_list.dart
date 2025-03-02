import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../../core/sensor/sensor_manager.dart';
import '../../domain/entity/room_entity.dart';
import '../view_model/room_bloc.dart';
import '../view_model/room_event.dart';
import '../view_model/room_state.dart';
import 'room_detail_screen.dart'; // Room Detail Screen to navigate to

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  bool _isDarkMode = false;
  bool _isShakeDetected = false;
  double _previousX = 0, _previousY = 0, _previousZ = 0;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    SensorManager().accelerometerStream.listen(_handleShake);
    context.read<RoomBloc>().add(GetRoomsEvent()); // ✅ Fetch rooms on start
  }

  // ✅ Handle Shake Gesture to Toggle Dark Mode
  void _handleShake(AccelerometerEvent event) {
    double deltaX = (_previousX - event.x).abs();
    double deltaY = (_previousY - event.y).abs();
    double deltaZ = (_previousZ - event.z).abs();

    _previousX = event.x;
    _previousY = event.y;
    _previousZ = event.z;

    if ((deltaX > 10 || deltaY > 10 || deltaZ > 10) && !_isShakeDetected) {
      _isShakeDetected = true;

      setState(() {
        _isDarkMode = !_isDarkMode; // ✅ Toggle Dark Mode
      });

      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(seconds: 2), () {
        _isShakeDetected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: _isDarkMode
              ? Colors.black
              : const Color.fromARGB(255, 255, 255, 255),
        ),
        body: BlocBuilder<RoomBloc, RoomState>(
          builder: (context, state) {
            if (state is RoomLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RoomError) {
              return Center(child: Text(state.message));
            } else if (state is RoomsLoaded) {
              if (state.rooms.isEmpty) {
                return const Center(child: Text('No rooms available.'));
              }
              return ListView.builder(
                itemCount: state.rooms.length,
                itemBuilder: (context, index) {
                  final room = state.rooms[index];
                  return RoomCard(
                    room: room,
                    isDarkMode: _isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomDetailScreen(room: room),
                        ),
                      );
                    },
                  );
                },
              );
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

class RoomCard extends StatelessWidget {
  final RoomEntity room;
  final bool isDarkMode;
  final VoidCallback onTap;

  const RoomCard({
    super.key,
    required this.room,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final String imageUrl = room.images.isNotEmpty
        ? 'http://10.0.2.2:3000/${room.images.first.replaceAll("public/", "").replaceAll("\\", "/")}'
        : 'https://via.placeholder.com/150';

    return Card(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) => const Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      room.type,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'NRs. ${room.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
