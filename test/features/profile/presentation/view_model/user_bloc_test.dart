import 'package:bloc_test/bloc_test.dart';
import 'package:bookit/core/error/failure.dart';
import 'package:bookit/features/auth/domain/entity/auth_entity.dart';
import 'package:bookit/features/profile/domain/use_case/get_user_profile_usecase.dart';
import 'package:bookit/features/profile/presentation/view_model/user_bloc.dart';
import 'package:bookit/features/profile/presentation/view_model/user_event.dart';
import 'package:bookit/features/profile/presentation/view_model/user_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ✅ Mock Dependencies
class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

void main() {
  late UserBloc userBloc;
  late MockGetUserProfileUseCase mockGetUserProfileUseCase;

  setUp(() {
    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    userBloc = UserBloc(mockGetUserProfileUseCase);
  });

  tearDown(() {
    userBloc.close();
  });

  group('UserBloc Tests', () {
    const testUser = AuthEntity(
      userId: '123',
      fullname: 'John Doe',
      address: 'New York, USA',
      phoneNo: '1234567890',
      image: '/uploads/johndoe.jpg',
      email: 'johndoe@example.com',
      password: 'hashed_password',
    );

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserLoaded] when FetchUserProfile is added and succeeds',
      build: () {
        when(() => mockGetUserProfileUseCase()).thenAnswer(
            (_) async => const Right(testUser)); // ✅ Corrected mock return
        return userBloc;
      },
      act: (bloc) => bloc.add(FetchUserProfile()),
      expect: () => [
        UserLoading(),
        UserLoaded(testUser),
      ],
    );

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserError] when FetchUserProfile fails',
      build: () {
        when(() => mockGetUserProfileUseCase()).thenAnswer((_) async =>
            const Left(ApiFailure(message: "Failed to fetch user profile")));
        return userBloc;
      },
      act: (bloc) => bloc.add(FetchUserProfile()),
      expect: () => [
        UserLoading(),
        UserError("Failed to fetch user profile"),
      ],
    );
  });
}
