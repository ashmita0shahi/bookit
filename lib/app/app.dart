import 'package:bookit/app/di/di.dart';
import 'package:bookit/features/splash/presentation/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/presentation/view_model/login/login_bloc.dart';
import '../features/auth/presentation/view_model/register/register_bloc.dart';
import '../features/home/presentation/view_model/home_cubit.dart';
import '../features/rooms/presentation/view_model/room_bloc.dart';
import '../features/rooms/presentation/view_model/room_event.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return KhaltiScope(
//       publicKey: 'test_public_key_1c3931fa382545e69ff56ab2523fb6a2',
//       enabledDebugging: true,
//       builder: (context, navKey) {
//         return MultiBlocProvider(
//           providers: [
//             BlocProvider<LoginBloc>(create: (_) => getIt<LoginBloc>()),
//             BlocProvider<RegisterBloc>(create: (_) => getIt<RegisterBloc>()),
//             BlocProvider<HomeCubit>(create: (_) => getIt<HomeCubit>()),
//             BlocProvider<RoomBloc>(
//                 create: (_) => getIt<RoomBloc>()..add(GetRoomsEvent())),
//           ],
//           child: MaterialApp(
//             navigatorKey: navKey, // Moved here
//             debugShowCheckedModeBanner: false,
//             title: 'Bookit - Hotel Booking',
//             theme: ThemeData(primarySwatch: Colors.blue),
//             localizationsDelegates: const [
//               KhaltiLocalizations.delegate, // 🔥 Add this
//             ],
//             home: const SplashScreen(),
//           ),
//         );
//       },
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => getIt<LoginBloc>()),
        BlocProvider<RegisterBloc>(create: (_) => getIt<RegisterBloc>()),
        BlocProvider<HomeCubit>(create: (_) => getIt<HomeCubit>()),
        BlocProvider<RoomBloc>(
            create: (_) => getIt<RoomBloc>()..add(GetRoomsEvent())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bookit - Hotel Booking',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashScreen(),
      ),
    );
  }
}
