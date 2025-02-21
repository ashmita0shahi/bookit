import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_service.dart';
import '../../core/network/hive_service.dart';
import '../../features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import '../../features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart';
import '../../features/auth/data/repository/local_repository/auth_local_repository.dart';
import '../../features/auth/data/repository/remote_repository/auth_remote_repository.dart';
import '../../features/auth/domain/use_case/login_usecase.dart';
import '../../features/auth/domain/use_case/register_usecase.dart';
import '../../features/auth/domain/use_case/upload_image_usecase.dart';
import '../../features/auth/domain/use_case/verify_usecase.dart';
import '../../features/auth/presentation/view_model/login/login_bloc.dart';
import '../../features/auth/presentation/view_model/register/register_bloc.dart';
import '../../features/home/presentation/view_model/home_cubit.dart';
import '../../features/profile/data/data_source/user_remote_data_source.dart';
import '../../features/profile/data/repository/user_remote_repository.dart';
import '../../features/profile/domain/repository/user_repository.dart';
import '../../features/profile/domain/use_case/get_user_profile_usecase.dart';
import '../../features/profile/presentation/view_model/user_bloc.dart';
import '../../features/rooms/data/data_source/room_local_data_source.dart';
import '../../features/rooms/data/data_source/room_remote_data_source.dart';
import '../../features/rooms/data/repository/room_local_repository.dart';
import '../../features/rooms/data/repository/room_remote_repository.dart';
import '../../features/rooms/domain/use_case/get_room_by_id_usecase.dart';
import '../../features/rooms/domain/use_case/get_room_usecase.dart';
import '../../features/rooms/presentation/view_model/room_bloc.dart';
import '../shared_prefs/token_shared_prefs.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  _initHiveService();
  _initApiService();
  await _initSharedPreferences();
  await _initLoginDependencies();
  await _initSignupDependencies();
  _initUserDependencies(); // ✅ Add this for UserBloc

  _initHomeDependencies();
  _initRoomDependencies();
  // _initUserDependencies(); // ✅ Add this for UserBloc
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

void _initApiService() {
  getIt.registerLazySingleton<Dio>(
    () => ApiService(Dio()).dio,
  );
}

void _initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

void _initHomeDependencies() {
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(),
  );
}

void _initRoomDependencies() {
  // Room Data Sources
  getIt.registerLazySingleton<RoomLocalDataSource>(
    () => RoomLocalDataSource(hiveService: getIt<HiveService>()),
  );

  getIt.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSource(dio: getIt<Dio>()),
  );

  // Room Repositories
  getIt.registerLazySingleton<RoomLocalRepository>(
    () =>
        RoomLocalRepository(roomLocalDataSource: getIt<RoomLocalDataSource>()),
  );

  getIt.registerLazySingleton<RoomRemoteRepository>(
    () => RoomRemoteRepository(
        roomRemoteDataSource: getIt<RoomRemoteDataSource>()),
  );

  // Room Use Cases
  getIt.registerLazySingleton<GetRoomsUseCase>(
    () => GetRoomsUseCase(roomRepository: getIt<RoomRemoteRepository>()),
  );

  getIt.registerLazySingleton<GetRoomByIdUseCase>(
    () => GetRoomByIdUseCase(roomRepository: getIt<RoomRemoteRepository>()),
  );

  // Room Bloc
  getIt.registerFactory<RoomBloc>(
    () => RoomBloc(
      getRoomsUseCase: getIt<GetRoomsUseCase>(),
      getRoomByIdUseCase: getIt<GetRoomByIdUseCase>(),
    ),
  );
}

// **FIXED: Added missing VerifyEmailUsecase registration**
Future<void> _initSignupDependencies() async {
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(getIt<HiveService>()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<AuthLocalRepository>(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );

  getIt.registerLazySingleton<AuthRemoteRepository>(
    () => AuthRemoteRepository(getIt<AuthRemoteDataSource>()),
  );

  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRemoteRepository>()),
  );

  getIt.registerLazySingleton<UploadImageUsecase>(
    () => UploadImageUsecase(getIt<AuthRemoteRepository>()),
  );

  // **FIXED: Register VerifyEmailUsecase before using it**
  getIt.registerLazySingleton<VerifyEmailUsecase>(
    () => VerifyEmailUsecase(getIt<AuthRemoteRepository>()),
  );

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      registerUseCase: getIt<RegisterUseCase>(),
      verifyEmailUsecase: getIt<VerifyEmailUsecase>(),
      // uploadImageUsecase:
      // getIt<UploadImageUsecase>(), // Fixed: Added UploadImageUsecase
    ),
  );
}

// **FIXED: Ensure TokenSharedPrefs is injected in LoginUseCase**
Future<void> _initLoginDependencies() async {
  getIt.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt<AuthRemoteRepository>(),
      getIt<TokenSharedPrefs>(), // Fixed: Injected TokenSharedPrefs
    ),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      homeCubit: getIt<HomeCubit>(),
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );
}

void _initUserDependencies() {
  // ✅ Register UserRemoteDataSource
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(getIt<Dio>()),
  );

  // ✅ Register UserRepository
  getIt.registerLazySingleton<UserRepository>(
    () => UserRemoteRepositoryImpl(
      getIt<UserRemoteDataSource>(),
      getIt<TokenSharedPrefs>(),
    ),
  );

  // ✅ Register GetUserProfileUseCase
  getIt.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(getIt<UserRepository>()),
  );

  // ✅ Register UserBloc
  getIt.registerFactory<UserBloc>(
    () => UserBloc(getIt<GetUserProfileUseCase>()),
  );
}
