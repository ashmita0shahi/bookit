import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/di/di.dart';
import '../../../../core/sensor/sensor_manager.dart';
import '../../../auth/presentation/view/login_page.dart';
import '../view_model/user_bloc.dart';
import '../view_model/user_event.dart';
import '../view_model/user_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isFlipped = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    SensorManager().gyroscopeStream.listen(_handleFlip);
  }

  // ✅ Handle Phone Flip
  void _handleFlip(gyroscopeEvent) {
    if (gyroscopeEvent.y < -7 && !_isFlipped) {
      _isFlipped = true;
      _logoutUser();

      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(seconds: 3), () {
        _isFlipped = false;
      });
    }

    if (gyroscopeEvent.y > 5 && _isFlipped) {
      _isFlipped = false;
    }
  }

  // ✅ Logout Function
  Future<void> _logoutUser() async {
    if (!mounted) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    if (mounted) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserBloc>()..add(FetchUserProfile()),
      child: Scaffold(
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              final user = state.user;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    user.image != null && user.image!.isNotEmpty
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              "http://10.0.2.2:3000${user.image!.replaceAll("public/", "").replaceAll("\\", "/")}",
                            ),
                          )
                        : const CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.person, size: 50),
                          ),
                    const SizedBox(height: 10),
                    Text(user.fullname,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(user.email,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 10),
                    ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text(user.phoneNo)),
                    ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(user.address)),
                  ],
                ),
              );
            } else if (state is UserError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const Center(child: Text("Profile Page"));
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
