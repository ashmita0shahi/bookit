import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/di/di.dart';
import '../../../auth/presentation/view/login_page.dart';
import '../view_model/user_bloc.dart';
import '../view_model/user_event.dart';
import '../view_model/user_state.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => getIt<UserBloc>()..add(FetchUserProfile()),
//       child: Scaffold(
//         appBar: AppBar(
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.logout, color: Colors.black),
//               onPressed: () async {
//                 // Perform logout
//                 await getIt<TokenSharedPrefs>().saveToken("");

//                 // Navigate to login page and clear back stack
//                 if (context.mounted) {
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginPage()),
//                     (route) => false,
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//         body: BlocBuilder<UserBloc, UserState>(
//           builder: (context, state) {
//             if (state is UserLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is UserLoaded) {
//               final user = state.user;
//               return Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     user.image != null && user.image!.isNotEmpty
//                         ? CircleAvatar(
//                             radius: 50,
//                             backgroundImage: NetworkImage(
//                               "http://10.0.2.2:3000${user.image!.replaceAll("public/", "").replaceAll("\\", "/")}",
//                             ),
//                           )
//                         : const CircleAvatar(
//                             radius: 50,
//                             child: Icon(Icons.person, size: 50),
//                           ),
//                     const SizedBox(height: 10),
//                     Text(user.fullname,
//                         style: const TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold)),
//                     Text(user.email,
//                         style:
//                             const TextStyle(fontSize: 16, color: Colors.grey)),
//                     const SizedBox(height: 10),
//                     ListTile(
//                         leading: const Icon(Icons.phone),
//                         title: Text(user.phoneNo)),
//                     ListTile(
//                         leading: const Icon(Icons.location_on),
//                         title: Text(user.address)),
//                   ],
//                 ),
//               );
//             } else if (state is UserError) {
//               return Center(child: Text("Error: ${state.message}"));
//             }
//             return const Center(child: Text("Profile Page"));
//           },
//         ),
//       ),
//     );
//   }
// }

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
    _listenForFlip();
  }

  // ✅ Flip Detection for Logging Out
  void _listenForFlip() {
    gyroscopeEvents.listen((event) {
      if (event.y < -7 && !_isFlipped) {
        // ✅ Detect if phone is flipped upside down
        _isFlipped = true;
        _logoutUser();

        // ✅ Prevent multiple triggers using a Timer
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(seconds: 3), () {
          _isFlipped = false; // Reset after cooldown
        });
      }
    });
  }

  // ✅ Logout Function
  Future<void> _logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove saved token

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserBloc>()..add(FetchUserProfile()),
      child: Scaffold(
        // appBar: AppBar(
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.logout),
        //       onPressed: _logoutUser, // Manual Logout Button
        //     ),
        //   ],
        // ),
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
}
